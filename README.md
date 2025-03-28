Analisis Data Transaksi Kimia Farma
Ini adalah repository yang berisi skrip SQL untuk membuat tabel analisis transaksi di Google BigQuery.

Struktur Repository
query_tabel_analisis.sql → Query SQL untuk membuat tabel tabel_analisis di BigQuery.

Tentang Dataset
Query ini menggunakan data dari beberapa tabel di BigQuery:

kf_final_transaction → Data transaksi pelanggan.

kf_product → Data produk beserta harga dan margin laba.

kf_kantor_cabang → Data kantor cabang Kimia Farma.

Ringkasan Analisis
Mengambil data transaksi dari tahun 2020-2023.

Menghitung nett sales setelah diskon.

Menghitung nett profit berdasarkan margin laba produk.

Menambahkan persentase gross laba dalam tabel.

Cara Menjalankan
Buka Google BigQuery.

Jalankan skrip query_tabel_analisis.sql di dataset yang sesuai.

Hasilnya akan tersimpan dalam tabel tabel_analisis.

Catatan
Pastikan sudah memiliki akses ke dataset soy-geography-455111-p8.kimia_farma.

Jika ada error akses, cek kembali pengaturan billing di BigQuery.

