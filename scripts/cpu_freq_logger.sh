#!/usr/bin/env bash
# Cách dùng: ./scripts/cpu_freq_logger.sh <PINNED_CORE_ID> <OUTPUT_CSV> &

CORE_ID="${1:-2}"
OUT_CSV="${2:-results/freq_log.csv}"
mkdir -p "$(dirname "$OUT_CSV")"

echo "timestamp,core_id,freq_khz,temp_millideg" > "$OUT_CSV"

FREQ_PATH="/sys/devices/system/cpu/cpu${CORE_ID}/cpufreq/scaling_cur_freq"

# 1. Ưu tiên tìm cảm biến coretemp (Intel Package temp) hoặc k10temp (AMD) trên Fedora
TEMP_PATH=""
for hw in /sys/class/hwmon/hwmon*; do
    if [ -f "$hw/name" ]; then
        hw_name=$(cat "$hw/name" 2>/dev/null || true)
        if [[ "$hw_name" == "coretemp" || "$hw_name" == "k10temp" ]]; then
            if [ -r "$hw/temp1_input" ]; then
                TEMP_PATH="$hw/temp1_input"
                break
            fi
        fi
    fi
done

# 2. Fallback sang thermal_zone nếu không tìm thấy hwmon
if [ -z "$TEMP_PATH" ]; then
    TEMP_PATH="/sys/class/thermal/thermal_zone0/temp"
    for zone in /sys/class/thermal/thermal_zone*; do
        if [ -f "$zone/type" ] && grep -qE "x86_pkg_temp|TCPU" "$zone/type"; then
            TEMP_PATH="$zone/temp"
            break
        fi
    done
fi

while true; do
    TS=$(date +%s)

    # Đọc xung nhịp (kHz): ưu tiên sysfs, nếu bị chặn quyền thì lấy từ /proc/cpuinfo
    if [ -r "$FREQ_PATH" ]; then
        FREQ=$(cat "$FREQ_PATH" 2>/dev/null || echo "N/A")
    else
        MHZ=$(awk -v core="$CORE_ID" '
            /^processor/ { c=$3 }
            /^cpu MHz/ && c==core { printf "%.0f", $4 * 1000; exit }
        ' /proc/cpuinfo)
        FREQ="${MHZ:-N/A}"
    fi

    # Đọc nhiệt độ (milli-độ C, ví dụ 65000 = 65°C)
    TEMP=$(cat "$TEMP_PATH" 2>/dev/null || echo "N/A")

    echo "$TS,$CORE_ID,$FREQ,$TEMP" >> "$OUT_CSV"
    sleep 1
done