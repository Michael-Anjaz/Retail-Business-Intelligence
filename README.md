# Retail Business Intelligence

## 1. Project Overview

Retail Business Intelligence merupakan proyek pengembangan Enterprise Data System (EDS) untuk mengintegrasikan dan menganalisis data penjualan, produk, cabang, dan perilaku pelanggan.

Proyek ini menggunakan dataset sintetis untuk mensimulasikan kebutuhan pengelolaan data pada bisnis retail.

Tujuan proyek:
- Mengintegrasikan data dari beberapa sumber.
- Membangun database terstruktur menggunakan PostgreSQL.
- Mengembangkan proses ETL menggunakan Python dan Pandas.
- Melakukan pemeriksaan kualitas data.
- Menyajikan informasi bisnis melalui dashboard interaktif.

## 2. Technologies

| Technology | Purpose |
|---|---|
| Python | ETL and data processing |
| Pandas | Data transformation |
| PostgreSQL | Database management |
| SQLAlchemy | Database connection |
| Streamlit | Interactive dashboard |
| Plotly | Data visualization |

## 3. Project Structure

```text
Retail-Business-Intelligence/
├── dashboard/
│   └── app.py
├── data/
│   ├── dataset_package/
│   │   └── retail_eds_dataset/
│   ├── processed/
│   └── raw/
├── docs/
│   └── data_governance.md
├── etl/
│   └── load_data.py
├── sql/
│   ├── analytics/
│   │   └── business_kpi.sql
│   ├── data_quality/
│   │   ├── create_staging.sql
│   │   ├── quality_audit.sql
│   │   └── quality_comparison.sql
│   └── schema.sql
├── requirements.txt
└── README.md
```

## 4. Dataset

Dataset yang digunakan merupakan dataset sintetis untuk kebutuhan akademik.

Dataset terdiri dari:
- 10 categories
- 20 suppliers
- 10 branches
- 500 customers
- 100 products
- 8,000 transactions
- 17,133 transaction items
- 1,000 customer reviews

Total data: 26,773 records.

Dataset tersedia di:

`data/dataset_package/retail_eds_dataset/`

## 5. Installation

Pastikan Python dan PostgreSQL sudah terpasang.

Clone repository:

```bash
git clone https://github.com/michaelpradana/Retail-Business-Intelligence.git
cd Retail-Business-Intelligence
```

Buat virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

## 6. Database Setup

Buat database PostgreSQL:

```bash
createdb retail_eds
```

Jalankan database schema:

```bash
psql -d retail_eds -f sql/schema.sql
```

## 7. ETL Execution

Jalankan proses pemuatan dataset:

```bash
python etl/load_data.py
```

Script ETL menggunakan Pandas dan SQLAlchemy untuk membaca dataset CSV dan memuatnya ke PostgreSQL.

## 8. Data Quality Audit

Jalankan pemeriksaan kualitas data:

```bash
psql -d retail_eds -f sql/data_quality/quality_audit.sql
```

Buat staging untuk simulasi masalah kualitas data:

```bash
psql -d retail_eds -f sql/data_quality/create_staging.sql
```

Bandingkan kualitas data production dan staging:

```bash
psql -d retail_eds -f sql/data_quality/quality_comparison.sql
```

## 9. Business Analytics

Query KPI bisnis tersedia di:

`sql/analytics/business_kpi.sql`

KPI yang dianalisis meliputi:
- Total Revenue
- Total Transactions
- Average Order Value
- Sales by Branch
- Sales by Category
- Monthly Sales
- Payment Method
- Customer Rating

## 10. Dashboard Execution

Jalankan dashboard Streamlit:

```bash
python -m streamlit run dashboard/app.py
```

Dashboard menyediakan visualisasi KPI dan analisis penjualan secara interaktif.

## 11. Data Governance

Dokumentasi Data Governance tersedia di:

`docs/data_governance.md`

Dokumentasi mencakup:
- Data Ownership
- Data Stewardship
- Database Administration
- Access Control
- Data Retention

## 12. Project Notes

- Seluruh dataset bersifat sintetis.
- Database menggunakan PostgreSQL.
- Proses ETL menggunakan Python dan Pandas.
- Dashboard menggunakan Streamlit dan Plotly.
- Data staging digunakan untuk simulasi dan pengujian Data Quality.