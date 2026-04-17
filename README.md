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
