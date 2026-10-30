#!/usr/bin/env bash
CORE_ID="${1:-2}"
OUT_CSV="${2:-results/freq_log.csv}"
mkdir -p "$(dirname "$OUT_CSV")"

echo "timestamp,core_id,freq_khz,temp_millideg" > "$OUT_CSV"

FREQ_PATH="/sys/devices/system/cpu/cpu${CORE_ID}/cpufreq/scaling_cur_freq"
TEMP_PATH="/sys/class/thermal/thermal_zone0/temp"
for zone in /sys/class/thermal/thermal_zone*; do
    if [ -f "$zone/type" ] && grep -q "x86_pkg_temp" "$zone/type"; then
        TEMP_PATH="$zone/temp"
        break
    fi
done

while true; do
    TS=$(date +%s)
    FREQ=$(cat "$FREQ_PATH" 2>/dev/null || echo "N/A")
    TEMP=$(cat "$TEMP_PATH" 2>/dev/null || echo "N/A")
    echo "$TS,$CORE_ID,$FREQ,$TEMP" >> "$OUT_CSV"
    sleep 1
done