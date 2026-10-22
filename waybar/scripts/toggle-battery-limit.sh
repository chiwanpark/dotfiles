#!/usr/bin/env bash
set -u

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

battery_dir="$(find_battery_dir)" || exit 0
end_file="$battery_dir/charge_control_end_threshold"
start_file="$battery_dir/charge_control_start_threshold"

[ -e "$end_file" ] || exit 0
[ -e "$start_file" ] || exit 0

current="$(cat "$end_file" 2>/dev/null || echo 80)"

if [ "$current" = "80" ]; then
  start_value=0
  end_value=100
else
  start_value=75
  end_value=80
fi

if sudo -n true >/dev/null 2>&1; then
  sudo -n bash -c "echo $start_value > '$start_file'; echo $end_value > '$end_file'" >/dev/null 2>&1 || exit 1
elif command -v pkexec >/dev/null 2>&1; then
  pkexec bash -c "echo $start_value > '$start_file'; echo $end_value > '$end_file'" >/dev/null 2>&1 || exit 1
else
  exit 1
fi
