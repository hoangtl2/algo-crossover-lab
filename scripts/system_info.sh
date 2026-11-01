#!/usr/bin/env bash
set -euo pipefail

OUT_FILE="${1:-results/system_info.txt}"
mkdir -p "$(dirname "$OUT_FILE")"

{
    echo "=========================================="
    echo "       SYSTEM & HARDWARE PROFILE          "
    echo "=========================================="
    echo "Timestamp: $(date -Iseconds)"
    echo "OS Release: $(cat /etc/fedora-release 2>/dev/null || uname -o)"
    echo "Kernel: $(uname -r -m)"
    echo ""
    echo "--- CPU Scaling & Power Profile (Fedora) ---"
    echo "Scaling Driver: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver 2>/dev/null || echo 'N/A')"
    echo "Scaling Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'N/A')"
    echo "Energy Performance Preference: $(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo 'N/A')"
    echo ""
    echo "--- CPU Architecture & Cache ---"
    lscpu
    echo ""
    echo "--- Cache Hierarchy Details ---"
    lscpu -C || true
    echo ""
    echo "--- Core Topology (P-core / E-core & SMT Siblings) ---"
    lscpu -e
    echo ""
    echo "--- Memory Status ---"
    free -h
    echo ""
    echo "--- Java Runtime Environment ---"
    java -version 2>&1
} > "$OUT_FILE"

echo "[OK] Đã lưu thông tin hệ thống Fedora vào $OUT_FILE"