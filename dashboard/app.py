
import streamlit as st
import pandas as pd
import plotly.express as px

from sqlalchemy import create_engine, text
from datetime import timedelta

# Konfigurasi halaman
st.set_page_config(
    page_title="Retail Business Intelligence",
    page_icon="📊",
    layout="wide"
)

st.title("Retail Business Intelligence")
st.caption("Enterprise Data System | Sales Analytics Dashboard")

# Koneksi database
@st.cache_resource
def get_engine():
    return create_engine(
        "postgresql+psycopg2://localhost/retail_eds"
    )

engine = get_engine()


def read_data(query, params=None):
    with engine.connect() as conn:
        return pd.read_sql(
            text(query),
            conn,
            params=params or {}
        )


# Rentang tanggal tersedia
date_range = read_data("""
    SELECT
        MIN(transaction_datetime)::date AS min_date,
        MAX(transaction_datetime)::date AS max_date
    FROM transactions
    WHERE transaction_status = 'Completed'
""")

min_date = date_range.loc[0, "min_date"]
max_date = date_range.loc[0, "max_date"]

# Filter tanggal
st.sidebar.header("Filter Dashboard")

selected_dates = st.sidebar.date_input(
    "Periode transaksi",
    value=(min_date, max_date),
    min_value=min_date,
    max_value=max_date
)

if len(selected_dates) != 2:
    st.info("Silakan pilih tanggal awal dan akhir.")
    st.stop()

start_date, end_date = selected_dates

if start_date > end_date:
    st.error("Tanggal awal tidak boleh melebihi tanggal akhir.")
    st.stop()

params = {
    "start_date": start_date,
    "end_date": end_date + timedelta(days=1)
}

# Filter transaksi completed
FILTER = """
    transaction_status = 'Completed'
    AND transaction_datetime >= :start_date
    AND transaction_datetime < :end_date
"""

# KPI utama
kpi = read_data(f"""
    SELECT
        COALESCE(SUM(grand_total), 0) AS revenue,
        COUNT(*) AS total_transactions,
        COALESCE(AVG(grand_total), 0) AS average_order_value
    FROM transactions
    WHERE {FILTER}
""", params)

rating = read_data("""
    SELECT
        COALESCE(AVG(rating), 0) AS average_rating,
        COUNT(*) AS total_reviews
    FROM customer_reviews
""")

revenue = float(kpi.loc[0, "revenue"])
transactions = int(kpi.loc[0, "total_transactions"])
aov = float(kpi.loc[0, "average_order_value"])
avg_rating = float(rating.loc[0, "average_rating"])
total_reviews = int(rating.loc[0, "total_reviews"])


def rupiah(value):
    return "Rp" + f"{value:,.0f}".replace(",", ".")


# Kartu KPI
st.subheader("Key Performance Indicators")

col1, col2, col3, col4 = st.columns(4)

col1.metric(
    "Total Revenue",
    f"Rp{revenue / 1_000_000_000:.2f} M")
col2.metric("Total Transactions", f"{transactions:,}".replace(",", "."))
col3.metric("Average Order Value", rupiah(aov))
col4.metric("Customer Rating", f"{avg_rating:.2f} / 5")

st.divider()

# Penjualan bulanan
monthly = read_data(f"""
    SELECT
        DATE_TRUNC('month', transaction_datetime)::date AS month,
        SUM(grand_total) AS revenue
    FROM transactions
    WHERE {FILTER}
    GROUP BY month
    ORDER BY month
""", params)

st.subheader("Monthly Sales")

fig_monthly = px.line(
    monthly,
    x="month",
    y="revenue",
    markers=True,
    labels={
        "month": "Bulan",
        "revenue": "Revenue"
    }
)

fig_monthly.update_layout(
    yaxis_title="Revenue (Rp)",
    xaxis_title="Bulan"
)

st.plotly_chart(fig_monthly, use_container_width=True)

# Penjualan cabang dan kategori
branch, category = st.columns(2)

branch_data = read_data(f"""
    SELECT
        b.branch_name,
        SUM(t.grand_total) AS revenue
    FROM transactions t
    JOIN branches b ON t.branch_id = b.branch_id
    WHERE {FILTER.replace("transaction_status", "t.transaction_status").replace("transaction_datetime", "t.transaction_datetime")}
    GROUP BY b.branch_name
    ORDER BY revenue DESC
""", params)

with branch:
    st.subheader("Sales by Branch")

    fig_branch = px.bar(
        branch_data,
        x="revenue",
        y="branch_name",
        orientation="h",
        labels={
            "revenue": "Revenue (Rp)",
            "branch_name": "Cabang"
        }
    )

    fig_branch.update_layout(yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig_branch, use_container_width=True)

category_data = read_data(f"""
    SELECT
        c.category_name,
        SUM(ti.line_total) AS revenue
    FROM transaction_items ti
    JOIN products p ON ti.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    JOIN transactions t ON ti.transaction_id = t.transaction_id
    WHERE t.transaction_status = 'Completed'
      AND t.transaction_datetime >= :start_date
      AND t.transaction_datetime < :end_date
    GROUP BY c.category_name
    ORDER BY revenue DESC
""", params)

with category:
    st.subheader("Sales by Category")

    fig_category = px.bar(
        category_data,
        x="revenue",
        y="category_name",
        orientation="h",
        labels={
            "revenue": "Sales (Rp)",
            "category_name": "Kategori"
        }
    )

    fig_category.update_layout(yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig_category, use_container_width=True)

# Metode pembayaran
st.subheader("Payment Method")

payment = read_data(f"""
    SELECT
        payment_method,
        COUNT(*) AS total_transactions,
        SUM(grand_total) AS revenue
    FROM transactions
    WHERE {FILTER}
    GROUP BY payment_method
    ORDER BY revenue DESC
""", params)

fig_payment = px.pie(
    payment,
    names="payment_method",
    values="total_transactions",
    hole=0.4
)

st.plotly_chart(fig_payment, use_container_width=True)

# Informasi ulasan
st.subheader("Customer Reviews")

col1, col2 = st.columns(2)

col1.metric("Average Rating", f"{avg_rating:.2f} / 5")
col2.metric("Total Reviews", f"{total_reviews:,}".replace(",", "."))

st.caption(
    "Data bersifat sintetis dan digunakan untuk keperluan "
    "proyek akademik Enterprise Data System."
)
