#!/usr/bin/env bash
set -euo pipefail

OUT_FILE="${1:-results/system_info.txt}"
mkdir -p "$(dirname "$OUT_FILE")"

{
    echo "=========================================="
    echo "       SYSTEM & HARDWARE PROFILE          "
    echo "=========================================="
    echo "Timestamp: $(date -Iseconds)"
    echo "Kernel/OS: $(uname -a)"
    echo ""
    echo "--- CPU Architecture & Cache ---"
    lscpu
    echo ""
    echo "--- Cache Hierarchy Details ---"
    lscpu -C || true
    echo ""
    echo "--- Core Topology (P-core / E-core & SMT Siblings) ---"
    lscpu -e=CPU,CORE,SOCKET,NODE,L1d:L1i:L2:L3,MAXMHZ,MINMHZ
    echo ""
    echo "--- Memory Status ---"
    free -h
    echo ""
    echo "--- Java Runtime Environment ---"
    java -version 2>&1
} > "$OUT_FILE"

echo "[OK] Đã lưu thông tin hệ thống vào $OUT_FILE"