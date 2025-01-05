# Step by step
## Membuat Database Agen Telur (`DB`)
```sql
CREATE DATABASE agen_telur;
```
// ini format gambarnya
 ![alt text](/folder/createdatabase.png) 

 ## Membuat Tabel Seller (`Seller`)
 ```sql
 CREATE TABLE seller (
    id_shifter VARCHAR(10) PRIMARY KEY,
    nama_shifter VARCHAR(30) NOT NULL,
    no_telp VARCHAR(20) NOT NULL
) ENGINE=INNODB;
```
// ini format gambarnya
 ![alt text](/folder/tableseller.png) 

## 5. Pengisian Data Dummy ke dalam Setiap Tabel
### a. Pengisian Data Dummy ke Tabel seller
```sql
INSERT INTO seller (id_shifter, nama_shifter, no_telp) 
VALUES
('kezia', 'Kezia Annabel', '08123456789'),
('soja', 'Soja Purnamasari', '08234567890'),
('sonia', 'Sonia Debora', '08123456789');
```

// ini format gambarnya
 ![alt text](/folder/recordseller.png)

 ### b. Pengisian Data Dummy ke Tabel kategori
```sql
 INSERT INTO kategori VALUES
(‘telur akm’, 'Telur Ayam Kampung', 2500.00),
(‘telur an’, 'Telur Ayam Negeri', 2000.00),
(‘telur bebek’, 'Telur Bebek', 3000.00)
(‘telur puyuh’, 'Telur Puyuh', 500.00),
(‘telur asin’, 'Telur Asin', 5000.00),
(‘telur retak’, 'Telur Retak', 1500.00),
(‘minyak 1l’, 'Minyak 1 Liter', 15000.00),
(‘minyak 2l’, 'Minyak 2 Liter', 30000.00),
(‘tissue’, 'Tissue', 20000.00),
(‘bumbu’, 'Bumbu Racik',2000.00),
(‘beras 5kg’, 'Beras 5 Kg', 60000.00),
(‘royco’, 'Royco', 1000.00),
(‘garam’, 'Garam',5000.00),
(‘cuka’, ‘Cuka', 8000.00),
(‘indomie’, ‘Indomie', 3000.00),
(‘kecap’, 'Kecap Manis', 10000.00),
(‘kunyit’, 'Kunyit Bubuk', 1000.00),
(‘merica’, 'Merica Bubuk', 1000.00),
(‘mie sedap’, 'Mie Sedap', 2500.00),
(‘saos’, 'Saos Sambal', 12000.00);
```

// ini format gambarnya
 ![alt text](/folder/recordkategori.png)

 ### c. Pengisian Data Dummy ke Tabel informasi_keuangan
```sql
INSERT INTO informasi_keuangan (id_info, saldo, tanggal_update) 
VALUES
(1, 0.00, CURRENT_DATE);
```

// ini format gambarnya
 ![alt text](/folder/recordinfokeuangan.png)

 ### d. Pengisian Data Dummy ke Tabel laporan_stok_mingguan
```sql
INSERT INTO laporan_stok_mingguan (id_shifter, id_kategori, jumlah_stok) VALUES
('sonia','telur akm', 0),
('sonia','telur an', 0),
('sonia','telur bebek', 0),
('sonia','telur puyuh', 0),
('sonia','telur asin', 0),
('sonia','telur retak', 0),
('soja','minyak 1l', 0),
('soja','minyak 2l', 0),
('soja','tissue', 0),
('soja','beras 5kg', 0),
('soja','indomie', 0),
('soja','mie sedap', 0),
('soja','bumbu', 0),
('kezia','royco', 0),
('kezia','garam', 0),
('kezia','cuka', 0),
('kezia','kecap', 0),
('kezia','kunyit', 0),
('kezia', 'merica', 0),
('kezia', 'saos', 0);
```

// ini format gambarnya
 ![alt text](/folder/recordstokmingguan.png)

 ### e. Pengisian Data Dummy ke Tabel transaksi_supplier
```sql
INSERT INTO transaksi_supplier (id_shifter, id_kategori, jumlah_barang_dibeli, total_transaksi, tipe_transaksi, tanggal_pembelian) VALUES
    ('sonia','telur akm', 120, 276000, 'transfer', CURRENT_DATE),
    ('sonia','telur an', 120, 160000, 'transfer', CURRENT_DATE),
    ('sonia','telur bebek', 60, 170000, 'transfer', CURRENT_DATE),
    ('sonia','telur puyuh', 60, 50000, 'transfer', CURRENT_DATE),
    ('sonia','telur asin', 30, 140000, 'transfer', CURRENT_DATE),
    ('sonia','telur retak', 50, 0, 'transfer', CURRENT_DATE),
    ('soja','minyak 1l', 30, 300000, 'transfer', CURRENT_DATE),
    ('soja','minyak 2l', 30, 600000, 'transfer', CURRENT_DATE),
    ('soja','tissue', 10, 170000, 'transfer', CURRENT_DATE),
    ('soja','beras 5kg', 10, 500000, 'transfer', CURRENT_DATE),
    ('soja','indomie', 30, 75000, 'transfer', CURRENT_DATE),
    ('soja','mie sedap', 30, 65000, 'transfer', CURRENT_DATE),
    ('soja','bumbu', 15, 30000, 'transfer', CURRENT_DATE),
    ('kezia','royco', 30, 20000, 'cash', CURRENT_DATE),
    ('kezia','garam', 15, 60000, 'cash', CURRENT_DATE),
    ('kezia','cuka', 10, 60000, 'cash', CURRENT_DATE),
    ('kezia','kecap', 20, 180000, 'cash', CURRENT_DATE),
    ('kezia','kunyit', 30, 15000, 'cash', CURRENT_DATE),
    ('kezia', 'merica', 30, 15000, 'cash', CURRENT_DATE),
    ('kezia', 'saos', 20, 200000, 'cash', CURRENT_DATE);
```

// ini format gambarnya
 ![alt text](/folder/recordtransaksisup.png)

 ### f. Pengisian Data Dummy ke Tabel laporan_penjualan_harian
```sql
INSERT INTO laporan_penjualan_harian 
(id_shifter, id_kategori, jumlah_barang_terjual, tanggal_penjualan) 
VALUES
    ('sonia','telur akm', 100, CURRENT_DATE),
    ('sonia','telur an', 120, CURRENT_DATE),
    ('sonia','telur bebek', 40, CURRENT_DATE),
    ('sonia','telur puyuh', 40, CURRENT_DATE),
    ('sonia','telur asin', 30, CURRENT_DATE),
    ('sonia','telur retak', 45, CURRENT_DATE),
    ('soja','minyak 1l', 10, CURRENT_DATE),
    ('soja','minyak 2l', 7, CURRENT_DATE),
    ('soja','tissue', 5, CURRENT_DATE),
    ('soja','beras 5kg', 6, CURRENT_DATE),
    ('soja','indomie', 26, CURRENT_DATE),
    ('soja','mie sedap', 14, CURRENT_DATE),
    ('soja','bumbu', 8, CURRENT_DATE),
    ('kezia','royco', 27, CURRENT_DATE),
    ('kezia','garam', 4, CURRENT_DATE),
    ('kezia','cuka', 2, CURRENT_DATE),
    ('kezia','kecap', 3, CURRENT_DATE),
    ('kezia','kunyit', 13, CURRENT_DATE),
    ('kezia', 'merica', 21, CURRENT_DATE),
    ('kezia', 'saos', 6, CURRENT_DATE);
```

// ini format gambarnya
 ![alt text](/folder/recordlaporanharian.png)

 ### g. Impact ke Tabel laporan_stok_mingguan

// ini format gambarnya
 ![alt text](/folder/impactstock.png)

  ### h. Impact Tabel arus_kas

// ini format gambarnya
 ![alt text](/folder/impactaruskas1.png)
 ![alt text](/folder/impactaruskas2.png)

  ### i. Impact Tabel informasi_keuangan
  
```sql
SELECT * FROM informasi_keuangan;
SELECT SUM(jumlah) as total_pemasukan FROM arus_kas WHERE kategori = ‘pemasukan’;
SELECT SUM(jumlah) as total_pengeluaran FROM arus_kas WHERE kategori = ‘pengeluaran’;
```

// ini format gambarnya
 ![alt text](/folder/impactinfokeu.png)

 ## 6. Pengimplementasian Konsep Transaction dan Trigger

 // ini format gambarnya
 ![alt text](/folder/transtrig.png)
