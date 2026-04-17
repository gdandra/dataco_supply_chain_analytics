# DataCo Supply Chain Analysis
Data Analyst Portofolio Project Using DataCo Dataset

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
# 1. Profitability & Market Performance

## Overview
Proyek ini melakukan analisis mendalam terhadap performa finansial **DataCo**, sebuah perusahaan supply chain global. Fokus utama tahap pertama ini adalah mendeteksi "Profit Leakage" (kebocoran profit) yang sering tidak terdeteksi pada laporan tingkat tinggi.

Data diambil dari **DataCo Supply Chain Dataset** yang mencakup transaksi, logistik, dan informasi produk yang kompleks.

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
