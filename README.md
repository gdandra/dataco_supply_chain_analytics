# DataCo Supply Chain Analysis
Data Analyst Portofolio Project Using DataCo Dataset

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
# 1. Profitability & Market Performance

## Overview
Proyek ini merupakan bagian dari perjalanan belajar saya untuk menguasai alur kerja End-to-End Data Analysis. Fokus utama saya dalam studi kasus ini adalah memahami bagaimana data mentah dari sistem supply chain global dapat ditransformasikan menjadi wawasan strategis mengenai profitabilitas perusahaan.

Dalam fase ini, saya menantang diri saya untuk tidak sekadar melakukan visualisasi statis, melainkan membangun integrasi data yang lebih robust menggunakan PostgreSQL sebagai data warehouse dan Power BI sebagai alat visualisasi melalui koneksi database langsung.

## Objective
1. **Financial Health Monitoring:** Menyediakan dashboard eksekutif untuk memantau Profit Margin secara real-time.
2. **Leakage Detection:** Mengidentifikasi segmen pelanggan (Tiering) yang menyebabkan kerugian finansial.
3. **Discount Policy Audit:** Menganalisis korelasi antara kebijakan pemberian diskon dan erosi profit.

## Skills & Tech Stack
- **SQL & Data Engineering:** Melakukan Exploratory Data Analysis (EDA) mendalam, *data cleaning*, dan transformasi data langsung di **PostgreSQL**.
- **Database Integration:** Menghubungkan database PostgreSQL secara langsung ke **Power BI** untuk memastikan integritas data.
- **Advanced DAX:** Membuat metrik kompleks seperti *Profit Erosion Rate* dan *Whale Curve Analysis*.
- **Data Storytelling:** Menyusun visualisasi yang interaktif dan berorientasi pada tindakan (*actionable insights*).

## The Process: From Database to Dashboard
Dalam proyek ini, saya menghindari metode *export-import* manual (CSV). Saya membangun arsitektur data yang lebih *robust*:
1. **EDA in SQL:** Melakukan agregasi dan pembersihan data di PostgreSQL untuk membuat *view* yang ringan dan siap visualisasi.
2. **Direct Connection:** Menghubungkan Power BI ke server PostgreSQL lokal/cloud untuk menjaga *single source of truth*.
3. **Visual Exploration:** Mengembangkan 2 Slide utama yang membagi analisis antara *Macro Performance* dan *Micro Leakage*.

### Business Analysis: Objective & Strategy
#### 1. **Financial Health Monitoring**
Dalam mengelola bisnis supply chain dengan skala operasional yang luas, transparansi terhadap performa antar wilayah menjadi tantangan utama. Pertanyaan mendasar yang ingin saya eksplorasi adalah: Apakah volume penjualan yang tinggi di suatu pasar selalu berbanding lurus dengan efisiensi margin yang dihasilkan? Seringkali, angka penjualan yang besar dapat mengaburkan realitas operasional di pasar yang sebenarnya memiliki margin sangat tipis.
##### The Strategy
Saya menerapkan teknik agregasi di SQL untuk membedah profitabilitas berdasarkan dimensi pasar (market). Fokus belajar saya di sini adalah memastikan akurasi perhitungan Profit Margin Percentage menggunakan fungsi `NULLIF` untuk menghindari logical error dalam pembagian data.
```sql
SELECT 
    market,
    SUM(sales) AS total_sales,
    SUM(benefit_per_order) AS total_profit,
    ROUND((SUM(benefit_per_order) / NULLIF(SUM(sales), 0)) * 100, 2) AS profit_margin_pct,
    COUNT(order_id) AS total_orders
FROM dataco_cleaned
GROUP BY market
ORDER BY profit_margin_pct DESC;
```

#### 2. **Identifikasi Kebocoran Profit**
Salah satu konsep penting yang saya pelajari dalam analisis profitabilitas adalah bahwa tidak semua pendapatan memberikan kontribusi positif yang sama. Masalah yang ingin saya pecahkan melalui data adalah fenomena "subsidi silang", di mana keuntungan dari pelanggan loyal mungkin habis terkikis oleh biaya melayani pelanggan yang tidak menguntungkan. Saya ingin menyelidiki: Bagaimana kita dapat mengidentifikasi segmen pelanggan yang secara sistematis memberikan dampak negatif terhadap profitabilitas perusahaan?
##### The Strategy
Untuk menjawab tantangan ini, saya mengeksplorasi penggunaan Window Functions seperti `NTILE(4)`. Langkah ini memungkinkan saya untuk melakukan segmentasi pelanggan ke dalam empat kuartil (Tiering) secara otomatis berdasarkan kontribusi profit mereka, sebuah teknik yang sangat efektif untuk mendeteksi profit leakage.
```sql
WITH customer_profitability AS (
    SELECT
        customer_id,
        SUM(benefit_per_order) AS total_profit
    FROM dataco_cleaned
    GROUP BY customer_id
), 
customer_segments AS (
    SELECT
        customer_id,
        total_profit,
        NTILE(4) OVER (ORDER BY total_profit DESC) AS profitability_quartile
    FROM customer_profitability
)
SELECT
    profitability_quartile,
    SUM(total_profit) AS segment_total_profit,
    ROUND((SUM(total_profit) / NULLIF((SELECT SUM(total_profit) FROM customer_profitability), 0)) * 100, 2) AS pct_of_total_profit
FROM customer_segments
GROUP BY profitability_quartile
ORDER BY profitability_quartile;
```
#### 3. **Audit Kebijakan Diskon (Correlation Analysis)**
Pemberian diskon merupakan strategi yang umum digunakan untuk meningkatkan volume penjualan. Namun, sebagai seorang analis, saya perlu memahami batasan efektivitas dari strategi tersebut. Pertanyaan kritis yang saya ajukan adalah: Apakah terdapat ambang batas tertentu di mana pemberian diskon tidak lagi meningkatkan nilai bisnis, melainkan justru mengikis margin hingga ke titik kritis?
##### The Strategy
Saya mempelajari cara melakukan data bucketing menggunakan pernyataan CASE WHEN untuk mengategorikan tingkat diskon. Hal ini bertujuan untuk mengevaluasi korelasi antara besaran diskon dan rata-rata profitabilitas per pesanan, guna menentukan kategori diskon mana yang paling berisiko bagi kesehatan margin perusahaan.
```sql
SELECT
    CASE
        WHEN order_item_discount_rate = 0 THEN 'No Discount'
        WHEN order_item_discount_rate <= 0.1 THEN 'Low Discount (0-10%)'
        WHEN order_item_discount_rate <= 0.3 THEN 'Medium Discount (10-30%)'
        ELSE 'High Discount (>30%)'
    END AS discount_tier,
    COUNT(*) AS total_orders,
    SUM(benefit_per_order) AS total_profit,
    ROUND(AVG(benefit_per_order), 2) AS avg_profit_per_order
FROM dataco_cleaned
GROUP BY discount_tier
ORDER BY avg_profit_per_order DESC;
```
### Interactive Dashboard Visualization
Setelah melakukan pengolahan data di SQL, saya mentransformasikan hasilnya ke dalam **Power BI** untuk mendapatkan wawasan yang lebih interaktif.
#### 1. **Page 1: Executive Financial Health Overview**
<img width="1295" height="730" alt="image" src="https://github.com/user-attachments/assets/8c809eb4-659c-42f4-8b4b-2e4156c099da" />

##### Summary
Halaman ini berfungsi sebagai Financial Pulse perusahaan, memberikan pandangan makro terhadap kesehatan finansial DataCo secara global. Fokus utamanya adalah menyajikan metrik performa tingkat tinggi sebelum masuk ke analisis yang lebih granular.
##### Strategic Insights & Visual Breakdown
- **Baseline Performance (KPI Cards):** Visual ini menyajikan tiga metrik fundamental: Total Sales ($33.1M), Total Profit ($3.97M), dan Profit Margin (12%). Angka-angka ini menjadi tolok ukur utama untuk menilai apakah pertumbuhan volume penjualan berjalan beriringan dengan efisiensi profit.
- **Operational Integrity (Status Realization):** Melalui Donut Chart, saya membedakan keuntungan berdasarkan status pesanan. Sekitar 51% profit telah terealisasi (Full Profit), sementara sisanya masih berupa Potential Profit (dalam proses). Hal ini penting untuk manajemen arus kas (cash flow) agar tidak mengambil keputusan strategis hanya berdasarkan angka di atas kertas.
- **Market & Geographic Distribution:** Grafik batang menunjukkan bahwa pasar Europe dan LATAM adalah kontributor profit terbesar. Namun, dengan adanya visualisasi Top & Bottom 5 Countries, saya dapat mengidentifikasi anomali di mana beberapa negara justru memberikan margin negatif yang berisiko mengikis keuntungan dari wilayah produktif.
- **Growth Trend & Data Integrity:** Grafik Sales and Profit Trend memperlihatkan stabilitas performa dari tahun 2015 hingga 2017.

**Learning Note:** Sebagai bagian dari proses validasi data, saya mencatat adanya penurunan tajam pada Januari 2018. Hal ini diidentifikasi bukan sebagai kegagalan bisnis, melainkan sebagai data cut-off point (data bulan berjalan yang belum lengkap), yang merupakan temuan penting dalam menjaga integritas laporan.
#### 2. **Page 2: Profit Leakage & Behavioral Analysis**
<img width="1287" height="730" alt="image" src="https://github.com/user-attachments/assets/0f613e88-e8c6-4c13-aaea-bda475652717" />

##### Summary
Halaman ini merupakan tahap Investigasi Mendalam untuk menjawab pertanyaan yang muncul di halaman pertama. Fokus utamanya adalah mengidentifikasi sumber kebocoran profit (profit leakage) dan menganalisis korelasi antara kebijakan diskon dengan profitabilitas.
##### Strategic Insights & Visual Breakdown
- **The "Leakage" Indicators (Analytical KPIs):** Saya merancang metrik khusus untuk mengkuantifikasi kerugian. Angka -$1.08M (Total Net Loss Tier 4) dan Profit Erosion Rate 21.35% memberikan gambaran nyata seberapa besar keuntungan perusahaan "termakan" oleh segmen yang tidak efisien.
- **Profit Contribution by Tier:** Menggunakan segmentasi kuartil yang dibuat di SQL, visual ini membuktikan bahwa sementara Tier 1 memberikan kontribusi masif, Tier 4 justru berada di area negatif. Ini menjadi bukti kuat perlunya evaluasi terhadap profil pelanggan di kelompok terbawah.
- **Correlation Plot:** Melalui Scatter Plot, saya menemukan distribusi data yang mengkhawatirkan pada produk dengan diskon tinggi. Titik-titik yang berada di bawah garis referensi nol menunjukkan bahwa kebijakan diskon perusahaan sering kali melampaui ambang batas profitabilitas.
- **Category Risk Mapping (Treemap):** Visualisasi ini memetakan di kategori produk mana kerugian paling banyak terkonsentrasi. Area berwarna merah pekat adalah prioritas utama untuk dilakukan peninjauan ulang struktur biaya atau strategi pricing.

#### Interactive & Navigation Features
Untuk meningkatkan pengalaman pengguna (User Experience) dalam menjelajahi data, saya menambahkan beberapa fitur interaktif yang saling terintegrasi di kedua halaman:
- **Seamless Navigation:** Terdapat tombol "Profit" dan "Deep Dive" di bagian header yang memungkinkan pengguna berpindah konteks analisis (dari makro ke mikro) secara instan tanpa kehilangan alur berpikir.
- **Global Multi-Slicers:** Saya menyediakan tiga slicer utama (Country, Market, Customer Type) yang telah dikonfigurasi menggunakan fitur Sync Slicers. Hal ini memastikan bahwa saat pengguna melakukan filter di satu halaman, kondisi data di halaman lainnya akan ikut menyesuaikan secara otomatis.
- **One-Click Reset Button:** Saya mengimplementasikan tombol Reset Filter (ikon undo) menggunakan kombinasi Bookmarks dan Action Buttons. Fitur ini memungkinkan pengguna untuk mengembalikan seluruh tampilan dashboard ke kondisi awal (tanpa filter) hanya dengan satu klik, memberikan kemudahan dalam memulai eksplorasi data yang baru.
