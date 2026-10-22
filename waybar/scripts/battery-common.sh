conservation_cap=80

find_battery_dir() {
  for d in /sys/class/power_supply/BAT*; do
    [ -d "$d" ] || continue
    if [ -e "$d/capacity" ] && [ -e "$d/status" ]; then
      echo "$d"
      return 0
    fi
  done
  return 1
}

charge_types_supports() {
  local types
  types="$(cat "$1" 2>/dev/null)" || return 1
  [ -n "$2" ] || return 1
  [[ " ${types//[\[\]]/} " == *" $2 "* ]]
}

charge_types_active() {
  local types
  types="$(cat "$1" 2>/dev/null)" || return 1
  [[ "$types" =~ \[([^]]+)\] ]] || return 1
  printf '%s\n' "${BASH_REMATCH[1]}"
}

detect_limit_backend() {
  local battery_dir="$1" f
  limit_backend=none
  conservation_file=""

  if [ -e "$battery_dir/charge_control_end_threshold" ]; then
    limit_backend=threshold
    return 0
  fi

  if charge_types_supports "$battery_dir/charge_types" Long_Life; then
    limit_backend=charge_types
    return 0
  fi

  for f in /sys/bus/platform/drivers/ideapad_acpi/*/conservation_mode; do
    if [ -e "$f" ]; then
      limit_backend=conservation_mode
      conservation_file="$f"
      return 0
    fi
  done

  return 1
}
