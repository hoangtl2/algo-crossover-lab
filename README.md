# Algo Crossover Lab: Hardware-Aware Algorithm Empirical Benchmark Suite

Dự án nghiên cứu thực nghiệm và tối ưu hóa điểm giao cắt phần cứng (**Hardware Crossover & Cutoff Tuning**) cho các thuật toán kinh điển (dựa trên giáo trình *Algorithms, 4th Edition* — Robert Sedgewick & Kevin Wayne).

## 1. Mục tiêu dự án
Trên lý thuyết, độ phức tạp tiệm cận \(\mathcal{O}(N \log N)\) bỏ qua các hằng số ẩn. Trong thực tế, hiệu năng của các thuật toán Chia để trị (Divide & Conquer) phụ thuộc chặt chẽ vào kiến trúc CPU hiện đại (L1/L2/L3 Cache Line, Branch Prediction, Function Call Overhead).

Repository này xây dựng một bộ khung đo kiểm chuẩn hóa (Benchmark Harness) để tìm ra các ngưỡng chuyển đổi (`CUTOFF`) tối ưu trên phần cứng thực tế:
- **Pha A (`v1-submission`):** Khảo sát ngưỡng `CUTOFF` chuyển sang **Insertion Sort** của thuật toán **Mergesort** (đối chiếu với mốc lý thuyết `7` và `10`), kết hợp đếm số phép toán (`Instrumentation`) và kiểm định thống kê.
- **Pha B (`v1.1`):** Khảo sát `CUTOFF` của **Quicksort** (Hoare/Sedgewick 2-way partition + Tail-call optimization) và so sánh trực diện với Mergesort.
- **Pha C (Mở rộng):** Các biến thể Mergesort (Early-exit, Ping-pong, Bottom-up), 3-Way/Dual-Pivot Quicksort, điểm giao cắt Linear vs. Binary Search, d-ary Heapsort, và phân tích Hardware Counters (`perf stat`).

---

## 2. Cấu trúc Repository

```text
algo-crossover-lab/
├── pom.xml                                  # Cấu hình Maven (JDK 21, JUnit 5)
├── src/
│   ├── main/java/crossoverlab/
│   │   ├── core/                            # Sorter interface, Harness, DatasetGenerator, Verify
│   │   └── exp01_mergesort/                 # MergeSort, Insertion, MergeSortCounted
│   └── test/java/crossoverlab/              # Bộ kiểm thử JUnit 5
├── experiments/
│   ├── 01-mergesort-cutoff/                 # Báo cáo và kết quả riêng của thí nghiệm 01
│   └── ...                                  # Các thí nghiệm mở rộng (02 -> 07)
├── scripts/
│   ├── system_info.sh                       # Trích xuất thông tin CPU, Cache, Topology (P/E-core)
│   ├── cpu_freq_logger.sh                   # Giám sát xung nhịp & nhiệt độ chống Thermal Throttling
│   ├── run_experiment.sh                    # Tự động hóa chạy benchmark (taskset, JVM flags)
│   └── analyze_and_plot.py                  # Thống kê (Mean, Median, CI 95%, Wilcoxon) & vẽ đồ thị
├── data/                                    # Bộ dữ liệu mẫu (N=1k, 100k) kèm SHA-256 & quy tắc Seed
├── results/                                 # Dữ liệu đo thô (raw/), bảng thống kê (summary/), biểu đồ (figures/)
└── docs/                                    # Báo cáo thí nghiệm & AI Chat Log
```
