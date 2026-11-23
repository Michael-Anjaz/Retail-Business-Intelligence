
# DATA GOVERNANCE
## Retail Business Intelligence

### 1. Data Ownership

Data Owner:
Project Team Retail Business Intelligence.

Tanggung jawab:
- Menentukan tujuan penggunaan data.
- Menetapkan kebijakan pengelolaan data.
- Menyetujui perubahan struktur dan penggunaan data.

### 2. Data Stewardship

Data Steward:
Data Analyst / ETL Developer.

Tanggung jawab:
- Memastikan kualitas dan konsistensi data.
- Memantau proses ETL.
- Melakukan pemeriksaan Data Quality.
- Memelihara Data Dictionary dan Metadata.

### 3. Database Administration

Database Administrator:
Project Database Administrator.

Tanggung jawab:
- Mengelola PostgreSQL.
- Mengatur hak akses database.
- Melakukan backup dan pemulihan data.
- Memantau keamanan dan ketersediaan database.

### 4. Role-Based Access Control

Sistem menggunakan PostgreSQL Role-Based Access Control (RBAC).

| Role | Access Rights |
|---|---|
| retail_dba | Database administration |
| retail_etl | SELECT, INSERT, UPDATE |
| retail_analyst | SELECT |
| retail_dashboard | SELECT |

Seluruh role dibuat menggunakan atribut NOLOGIN sebagai group role.

Pengujian akses menunjukkan:
- Data Analyst berhasil membaca tabel customers.
- Dashboard berhasil membaca tabel transactions.
- ETL Developer berhasil membaca tabel products.
- DBA berhasil membaca tabel customers.
- Data Analyst gagal melakukan UPDATE karena tidak memiliki izin.

### 5. Data Retention

Kebijakan penyimpanan yang diusulkan:

| Jenis Data | Kebijakan |
|---|---|
| Raw Dataset | Disimpan selama proyek berlangsung dan untuk reproduksibilitas |
| Processed Dataset | Disimpan selama proyek berlangsung |
| Production Database | Dipertahankan untuk kebutuhan analisis proyek |
| Staging Data | Dihapus setelah pengujian selesai |
| Backup Database | Dilakukan sebelum perubahan besar |

### 6. Metadata Management

Metadata dikelola melalui:
- README.md
- data_dictionary.csv
- schema_postgresql.sql
- Dokumentasi ETL
- Dokumentasi Data Quality

Metadata mencakup:
- Nama tabel.
- Nama kolom.
- Tipe data.
- Primary key.
- Foreign key.
- Deskripsi atribut.
- Sumber data.

### 7. Data Privacy

Dataset yang digunakan merupakan data sintetis untuk keperluan akademik.

Dataset tidak merepresentasikan pelanggan atau perusahaan nyata.

Penggunaan data dibatasi untuk:
- Pengembangan sistem EDS.
- Analisis penjualan.
- Pengujian Data Quality.
- Demonstrasi dashboard.
- Dokumentasi akademik.
