
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text

# Konfigurasi database
DATABASE_URL = "postgresql+psycopg2://localhost/retail_eds"

# Lokasi dataset
BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data/dataset_package/retail_eds_dataset"

# Koneksi database
engine = create_engine(DATABASE_URL)

# Urutan import mengikuti relasi foreign key
TABLES = [
    "categories",
    "suppliers",
    "branches",
    "customers",
    "products",
    "transactions",
    "transaction_items",
    "customer_reviews",
]


def load_data():
    print("Memulai proses ETL...")

    with engine.begin() as conn:
        for table in TABLES:
            file_path = DATA_DIR / f"{table}.csv"

            if not file_path.exists():
                raise FileNotFoundError(
                    f"File tidak ditemukan: {file_path}"
                )

            df = pd.read_csv(file_path)

            df.to_sql(
                name=table,
                con=conn,
                if_exists="append",
                index=False,
                method="multi",
                chunksize=1000,
            )

            print(
                f"{table}: {len(df):,} baris berhasil diimpor"
            )

    print("\nETL selesai.")


if __name__ == "__main__":
    load_data()
