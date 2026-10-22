#!/usr/bin/env bash
set -u

. "$(dirname "$(readlink -f "$0")")/battery-common.sh"

format_duration() {
  local total="$1"

  if [ -z "${total:-}" ] || [ "$total" = "N/A" ] || [ "$total" -lt 0 ] 2>/dev/null; then
    echo "N/A"
    return
  fi

  if [ "$total" -eq 0 ] 2>/dev/null; then
    echo "0s"
    return
  fi

  local hours=$(( total / 3600 ))
  local minutes=$(( (total % 3600) / 60 ))
  local seconds=$(( total % 60 ))

  if [ "$hours" -gt 0 ]; then
    printf '%dh %dm' "$hours" "$minutes"
  elif [ "$minutes" -gt 0 ]; then
    printf '%dm %ds' "$minutes" "$seconds"
  else
    printf '%ds' "$seconds"
  fi
}

battery_dir="$(find_battery_dir)" || {
  printf '{"text":" N/A","class":"fallback","tooltip":"Battery not found"}\n'
  exit 0
}

capacity="$(cat "$battery_dir/capacity" 2>/dev/null || echo 0)"
status="$(cat "$battery_dir/status" 2>/dev/null || echo Unknown)"
power_now="$(cat "$battery_dir/power_now" 2>/dev/null || echo 0)"
energy_now="$(cat "$battery_dir/energy_now" 2>/dev/null || echo 0)"
energy_full="$(cat "$battery_dir/energy_full" 2>/dev/null || echo 0)"

end_threshold="n/a"
cap_note=""
detect_limit_backend "$battery_dir"
case "$limit_backend" in
  threshold)
    end_threshold="$(cat "$battery_dir/charge_control_end_threshold" 2>/dev/null || echo n/a)"
    ;;
  charge_types)
    if charge_type="$(charge_types_active "$battery_dir/charge_types")"; then
      cap_note=" (${charge_type})"
      if [ "$charge_type" = "Long_Life" ]; then
        end_threshold="$conservation_cap"
      else
        end_threshold=100
      fi
    fi
    ;;
  conservation_mode)
    case "$(cat "$conservation_file" 2>/dev/null)" in
      1) end_threshold="$conservation_cap"; cap_note=" (conservation mode)" ;;
      0) end_threshold=100 ;;
    esac
    ;;
esac

case "$status" in
  "Charging"|"Full") icon="" ;;
  "Discharging") icon="" ;;
  *) icon="" ;;
esac

if [ "$end_threshold" = "n/a" ]; then
  state_class="fallback"
else
  if [ "$end_threshold" = "100" ]; then
    state_class="full"
  else
    state_class="limit"
  fi
fi

power_w=$(awk "BEGIN {printf \"%.1f\", $power_now / 1000000}")

time_text="N/A"
time_label="Time"
case "$status" in
  "Charging")
    time_label="Time to full"
    if [ "$power_now" -gt 0 ] && [ "$energy_full" -gt "$energy_now" ]; then
      remaining_seconds=$(( (energy_full - energy_now) * 3600 / power_now ))
      time_text="$(format_duration "$remaining_seconds")"
    fi
    ;;
  "Discharging")
    time_label="Time to empty"
    if [ "$power_now" -gt 0 ] && [ "$energy_now" -gt 0 ]; then
      remaining_seconds=$(( energy_now * 3600 / power_now ))
      time_text="$(format_duration "$remaining_seconds")"
    fi
    ;;
  "Full")
    time_label="Time"
    time_text="Full"
    ;;
esac

if [ "$end_threshold" = "n/a" ]; then
  label="${icon} ${capacity}%"
  tooltip=$(printf '%b' "Battery: ${status}\nCharge: ${capacity}%\nRate: ${power_w} W\n${time_label}: ${time_text}\nCap: unavailable")
else
  label="${icon} ${capacity}% · ${end_threshold}%"
  tooltip=$(printf '%b' "Battery: ${status}\nCharge: ${capacity}%\nRate: ${power_w} W\n${time_label}: ${time_text}\nCap: ${end_threshold}%${cap_note}\nClick to toggle")
fi

python3 - "$label" "$state_class" "$tooltip" <<'PY'
import json, sys
label, cls, tooltip = sys.argv[1], sys.argv[2], sys.argv[3]
print(json.dumps({"text": label, "class": cls, "tooltip": tooltip}, ensure_ascii=False))
PY
