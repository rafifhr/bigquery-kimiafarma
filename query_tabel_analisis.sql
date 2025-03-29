-- Membuat tabel baru bernama "tabel_analisis" dengan hasil dari query ini
CREATE TABLE soy-geography-455111-p8.kimia_farma.tabel_analisis AS

-- Mengambil data transaksi yang terjadi antara 1 Januari 2020 hingga 31 Desember 2023
WITH transaksi_filtered AS (
    SELECT 
        transaction_id, -- ID transaksi
        date, -- Tanggal transaksi
        branch_id, -- ID cabang tempat transaksi terjadi
        product_id, -- ID produk yang dibeli dalam transaksi
        customer_name, -- Nama pelanggan
        discount_percentage, -- Persentase diskon yang diberikan dalam transaksi
        rating -- Rating transaksi yang diberikan oleh pelanggan
    FROM soy-geography-455111-p8.kimia_farma.kf_final_transaction
    WHERE date BETWEEN '2020-01-01' AND '2023-12-31' -- Filter hanya transaksi dalam rentang tahun 2020-2023
),

-- Menentukan persentase laba kotor (gross profit margin) berdasarkan harga produk
produk_dengan_laba AS (
    SELECT 
        product_id, -- ID produk
        product_name, -- Nama produk
        price, -- Harga asli produk
        CASE 
            WHEN price <= 50000 THEN 0.10 -- Jika harga ≤ 50.000, gross profit margin 10%
            WHEN price > 50000 AND price <= 100000 THEN 0.15 -- Jika harga > 50.000 dan ≤ 100.000, gross profit margin 15%
            WHEN price > 100000 AND price <= 300000 THEN 0.20 -- Jika harga > 100.000 dan ≤ 300.000, gross profit margin 20%
            WHEN price > 300000 AND price <= 500000 THEN 0.25 -- Jika harga > 300.000 dan ≤ 500.000, gross profit margin 25%
            ELSE 0.30 -- Jika harga > 500.000, gross profit margin 30%
        END AS persentase_gross_laba
    FROM soy-geography-455111-p8.kimia_farma.kf_product
)

-- Menggabungkan data transaksi, data cabang, dan data produk untuk analisis
SELECT 
    t.transaction_id, -- ID transaksi
    t.date, -- Tanggal transaksi
    c.branch_id, -- ID cabang tempat transaksi terjadi
    c.branch_name, -- Nama cabang
    c.kota, -- Kota lokasi cabang
    c.provinsi, -- Provinsi lokasi cabang
    c.rating AS rating_cabang,  -- Rating cabang
    t.customer_name, -- Nama pelanggan yang melakukan transaksi
    p.product_id, -- ID produk yang dibeli
    p.product_name, -- Nama produk
    p.price AS actual_price,  -- Harga asli produk sebelum diskon
    t.discount_percentage, -- Persentase diskon yang diberikan dalam transaksi

    -- Menghitung harga produk setelah diskon diterapkan
    p.price * (1 - t.discount_percentage / 100) AS nett_sales,

    -- Mengonversi persentase gross laba ke dalam bentuk persentase (x100)
    p.persentase_gross_laba * 100 AS persentase_gross_laba,

    -- Menghitung laba bersih setelah diskon diterapkan
    (p.price * (1 - t.discount_percentage / 100)) * p.persentase_gross_laba AS nett_profit,

    t.rating AS rating_transaksi  -- Rating transaksi yang diberikan oleh pelanggan

-- Menggabungkan tabel transaksi dengan tabel cabang berdasarkan branch_id
FROM transaksi_filtered t
JOIN soy-geography-455111-p8.kimia_farma.kf_kantor_cabang c 
    ON t.branch_id = c.branch_id

-- Menggabungkan tabel transaksi dengan tabel produk berdasarkan product_id
JOIN produk_dengan_laba p
    ON t.product_id = p.product_id;
