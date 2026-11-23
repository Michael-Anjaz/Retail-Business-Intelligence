# Retail Business Intelligence - Synthetic EDS Dataset

Seluruh data dalam paket ini bersifat sintetis dan dibuat dengan Python. Data tidak merepresentasikan pelanggan, transaksi, atau perusahaan nyata.

## Ringkasan isi
- 500 customers
- 100 products
- 10 categories
- 10 branches
- 20 suppliers
- 8,000 transactions
- 17,133 transaction_items
- 1,000 customer_reviews

Periode transaksi: 2025-01-01 sampai 2026-10-31.

## Dua sumber data
1. `source_pos_sales_raw.csv`: ekspor POS sintetis dalam format CSV, satu baris per item transaksi.
2. `source_customer_reviews_raw.jsonl`: ulasan pelanggan sintetis dalam format JSON Lines.

## Tabel hasil integrasi
`customers.csv`, `products.csv`, `categories.csv`, `branches.csv`, `suppliers.csv`, `transactions.csv`, `transaction_items.csv`, `customer_reviews.csv`.

## Relasi utama
- categories 1:N products
- suppliers 1:N products
- branches 1:N transactions
- customers 1:N transactions
- transactions 1:N transaction_items
- products 1:N transaction_items
- transactions 1:N customer_reviews
- customers 1:N customer_reviews
- products 1:N customer_reviews

## ETL yang disarankan
1. Extract: baca `source_pos_sales_raw.csv` dan `source_customer_reviews_raw.jsonl`.
2. Transform: validasi tipe data, format tanggal, ID, nilai transaksi, rating, duplikasi, dan kelengkapan.
3. Load: masukkan data ke PostgreSQL mengikuti urutan tabel dimensi lalu tabel transaksi/fakta.

## Catatan Data Quality
Dataset dasar sengaja dibuat konsisten agar bisa langsung dimuat. Untuk demonstrasi Data Quality, buat salinan staging lalu sisipkan kasus uji terkontrol seperti nilai kosong, duplikasi baris, rating di luar rentang, dan tanggal tidak valid. Jangan mengubah dataset bersih utama.

Aspek yang dapat diukur:
- Completeness: persentase kolom wajib yang terisi.
- Validity: rating 1-5, quantity > 0, format tanggal valid.
- Uniqueness: tidak ada duplikasi primary key.
- Consistency: total transaksi konsisten dengan rincian item dan diskon.

## Reproduksibilitas
Dataset ini dibuat secara sintetis dengan seed tetap (42). File CSV dan JSONL di dalam paket merupakan hasil yang siap digunakan. Skrip generator terpisah dapat dibuat pada tahap implementasi jika diperlukan.

## File
- `schema_postgresql.sql`: DDL tabel, primary key, foreign key, constraint, dan index.
- `generate_dataset.py`: skrip pembangkit dataset sintetis.
