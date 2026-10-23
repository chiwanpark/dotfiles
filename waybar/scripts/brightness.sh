#!/usr/bin/env bash
set -u

intel_luminance_fallback_max=512

usage() {
  echo "usage: ${0##*/} {up|down} [PERCENT] | set PERCENT | info" >&2
  exit 2
}

find_device() {
  local d dmax best="" best_max=-1
  for d in /sys/class/backlight/*; do
    [ -r "$d/max_brightness" ] || continue
    dmax="$(cat "$d/max_brightness" 2>/dev/null)" || continue
    if [ "$dmax" -gt "$best_max" ]; then
      best="$d"
      best_max="$dmax"
    fi
  done
  [ -n "$best" ] || return 1
  echo "$best"
}

has_edid() {
  [ "$(head -c 128 "$1" 2>/dev/null | wc -c)" -eq 128 ]
}

find_edid() {
  local f
  for f in "$1/device/edid" /sys/class/drm/card*-eDP-*/edid; do
    if has_edid "$f"; then
      echo "$f"
      return 0
    fi
  done
  return 1
}

edid_luminance() {
  od -An -v -tu1 "$1" | awk '
    { for (i = 1; i <= NF; i++) b[n++] = $i + 0 }

    function nits(cv) { return 50 * 2 ^ (cv / 32) }

    function half(lo, hi,   v, e, m) {
      v = hi * 256 + lo
      if (v >= 32768) return 0
      e = int(v / 1024)
      m = v % 1024
      if (e == 0 || e == 31) return 0
      return 2 ^ (e - 15) * (1 + m / 1024)
    }

    function cta(p, end,   tag, len) {
      while (p < end) {
        tag = int(b[p] / 32)
        len = b[p] % 32
        if (tag == 3 && len >= 13 && b[p+1] == 26 && b[p+2] == 0 && b[p+3] == 0 && b[p+4] >= 3) {
          amd_peak = nits(b[p+10])
          amd_sdr = nits(b[p+12])
        } else if (tag == 7 && len >= 5 && b[p+1] == 6 && b[p+5] > 0) {
          hdr_fall = nits(b[p+5])
        }
        p += len + 1
      }
    }

    function displayid(p, end,   tag, len) {
      while (p + 3 <= end) {
        tag = b[p]
        len = b[p+2]
        if (tag == 129) {
          cta(p + 3, p + 3 + len)
        } else if (tag == 33 && len >= 27) {
          did_full = half(b[p+24], b[p+25])
          did_min = half(b[p+28], b[p+29])
        }
        p += len + 3
      }
    }

    END {
      for (off = 128; off + 128 <= n; off += 128) {
        if (b[off] == 2 && b[off+2] >= 4) cta(off + 4, off + b[off+2])
        else if (b[off] == 112) displayid(off + 5, off + 5 + b[off+2])
      }
      sdr = did_full + 0
      if (amd_sdr > 0 && amd_sdr <= amd_peak && amd_sdr >= sdr) sdr = amd_sdr
      if (sdr == 0) sdr = hdr_fall + 0
      lo = did_min + 0
      printf "%d %d\n", int(sdr), ((lo > int(lo)) ? int(lo) + 1 : int(lo))
    }
  '
}

resolve_range() {
  local edid sdr_max panel_min
  dev="$(find_device)" || { echo "no backlight device found" >&2; exit 1; }
  name="${dev##*/}"
  max="$(cat "$dev/max_brightness")"
  min=0

  if [ "$name" = intel_backlight ] && [ "$max" -eq "$intel_luminance_fallback_max" ] \
    && edid="$(find_edid "$dev")"; then
    read -r sdr_max panel_min < <(edid_luminance "$edid")
    if [ "${sdr_max:-0}" -gt 0 ] && [ "$sdr_max" -lt "$max" ]; then
      max="$sdr_max"
    fi
    if [ "${panel_min:-0}" -gt 0 ] && [ "$panel_min" -lt "$max" ]; then
      min="$panel_min"
    fi
  fi
}

current_brightness() {
  cat "$dev/brightness"
}

set_brightness() {
  local value="$1"
  [ "$value" -lt "$min" ] && value="$min"
  [ "$value" -gt "$max" ] && value="$max"

  if busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto \
    org.freedesktop.login1.Session SetBrightness ssu backlight "$name" "$value" >/dev/null 2>&1; then
    return 0
  fi
  [ -w "$dev/brightness" ] && echo "$value" > "$dev/brightness"
}

percent_to_value() {
  echo $(( min + ((max - min) * $1 + 50) / 100 ))
}

value_to_percent() {
  local p
  [ "$max" -gt "$min" ] || { echo 100; return; }
  p=$(( (($1 - min) * 100 + (max - min) / 2) / (max - min) ))
  [ "$p" -lt 0 ] && p=0
  [ "$p" -gt 100 ] && p=100
  echo "$p"
}

is_percent() {
  [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -le 100 ]
}

[ $# -ge 1 ] || usage
resolve_range

case "$1" in
  up|down)
    pct="${2:-5}"
    is_percent "$pct" || usage
    step=$(( ((max - min) * pct + 50) / 100 ))
    [ "$step" -lt 1 ] && step=1
    cur="$(current_brightness)"
    if [ "$1" = up ]; then
      set_brightness $(( cur + step ))
    else
      set_brightness $(( cur - step ))
    fi
    ;;
  set)
    [ $# -ge 2 ] && is_percent "$2" || usage
    set_brightness "$(percent_to_value "$2")"
    ;;
  info)
    cur="$(current_brightness)"
    echo "device=$name min=$min max=$max current=$cur percent=$(value_to_percent "$cur")"
    ;;
  *)
    usage
    ;;
esac
