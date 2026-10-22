#!/usr/bin/env bash
set -u

. "$(dirname "$(readlink -f "$0")")/battery-common.sh"

as_root() {
  if sudo -n true >/dev/null 2>&1; then
    sudo -n "$@"
  elif command -v pkexec >/dev/null 2>&1; then
    pkexec "$@"
  else
    return 1
  fi
}

write_sysfs() {
  as_root sh -c 'echo "$1" > "$2"' sh "$1" "$2" >/dev/null 2>&1
}

battery_dir="$(find_battery_dir)" || exit 0
detect_limit_backend "$battery_dir" || exit 0

case "$limit_backend" in
  threshold)
    end_file="$battery_dir/charge_control_end_threshold"
    start_file="$battery_dir/charge_control_start_threshold"
    current="$(cat "$end_file" 2>/dev/null || echo 80)"

    if [ "$current" = "80" ]; then
      start_value=0
      end_value=100
    else
      start_value=75
      end_value=80
    fi

    if [ -e "$start_file" ]; then
      as_root sh -c 'echo "$1" > "$2"; echo "$3" > "$4"' sh \
        "$start_value" "$start_file" "$end_value" "$end_file" >/dev/null 2>&1 || exit 1
    else
      write_sysfs "$end_value" "$end_file" || exit 1
    fi
    ;;

  charge_types)
    types_file="$battery_dir/charge_types"
    state_file="${XDG_STATE_HOME:-$HOME/.local/state}/waybar/charge-type"
    current="$(charge_types_active "$types_file")" || current=""

    if [ "$current" = "Long_Life" ]; then
      target="$(cat "$state_file" 2>/dev/null)" || target=""
      if [ "$target" = "Long_Life" ] || ! charge_types_supports "$types_file" "$target"; then
        target="Standard"
      fi
    else
      target="Long_Life"
    fi

    write_sysfs "$target" "$types_file" || exit 1

    if [ "$target" = "Long_Life" ] && [ -n "$current" ]; then
      mkdir -p "$(dirname "$state_file")"
      printf '%s\n' "$current" > "$state_file"
    fi
    ;;

  conservation_mode)
    current="$(cat "$conservation_file" 2>/dev/null || echo 0)"

    if [ "$current" = "1" ]; then
      target=0
    else
      target=1
    fi

    write_sysfs "$target" "$conservation_file" || exit 1
    ;;
esac
