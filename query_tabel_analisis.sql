CREATE TABLE soy-geography-455111-p8.kimia_farma.tabel_analisis AS
WITH transaksi_filtered AS (
    SELECT 
        transaction_id, date, branch_id, product_id, customer_name, discount_percentage, rating
    FROM soy-geography-455111-p8.kimia_farma.kf_final_transaction
    WHERE date BETWEEN '2020-01-01' AND '2023-12-31'
),
produk_dengan_laba AS (
    SELECT 
        product_id, product_name, price,
        CASE 
            WHEN price <= 50000 THEN 0.10
            WHEN price > 50000 AND price <= 100000 THEN 0.15
            WHEN price > 100000 AND price <= 300000 THEN 0.20
            WHEN price > 300000 AND price <= 500000 THEN 0.25
            ELSE 0.30
        END AS persentase_gross_laba
    FROM soy-geography-455111-p8.kimia_farma.kf_product
)
SELECT 
    t.transaction_id,
    t.date,
    c.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,  
    t.customer_name,
    p.product_id,
    p.product_name,
    p.price AS actual_price,  
    t.discount_percentage,

    -- Harga setelah diskon
    p.price * (1 - t.discount_percentage / 100) AS nett_sales,

    -- Persentase Gross Laba
    p.persentase_gross_laba * 100 AS persentase_gross_laba,

    -- Nett profit
    (p.price * (1 - t.discount_percentage / 100)) * p.persentase_gross_laba AS nett_profit,

    t.rating AS rating_transaksi  

FROM transaksi_filtered t
JOIN soy-geography-455111-p8.kimia_farma.kf_kantor_cabang c 
    ON t.branch_id = c.branch_id
JOIN produk_dengan_laba p
    ON t.product_id = p.product_id;
