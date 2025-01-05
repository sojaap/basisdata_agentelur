# Step by step
Langkah-Langkah Pembuatan Database

## Membuat Database Agen Telur (`DB`)
```sql
CREATE DATABASE agen_telur;
```
 ![alt text](/folder/createdatabase.png) 
#### Untuk dijadikan sebagai wadah dari data utama yaitu tabel-tabel yang berhubungan dengan operasional bisnis dari agen telur itu.

 ## Membuat Tabel Seller (`Seller`)
 ```sql
 CREATE TABLE seller (
    id_shifter VARCHAR(10) PRIMARY KEY,
    nama_shifter VARCHAR(30) NOT NULL,
    no_telp VARCHAR(20) NOT NULL
) ENGINE=INNODB;
```
 ![alt text](/folder/tableseller.png)
#### Untuk tempat menampung data nama dan nomor telepon dari shifter atau staff yang bekerja.
 
## Membuat Tabel Kategori (`Kategori`)
```sql
CREATE TABLE kategori (
    id_kategori varchar(10) PRIMARY KEY,
    nama_kategori varchar(30) NOT NULL,
    harga_satuan DECIMAL(10,2) NOT NULL
)ENGINE=INNODB;
```
![alt text](/folder/createkategori.png) 
##### Untuk menampung data mengenai produk-produk yang dijual oleh agen.

### Edit Query (NOT NULL)
``` sql
ALTER TABLE seller
MODIFY id_shifter VARCHAR(10) NOT NULL;

ALTER TABLE kategori
MODIFY id_kategori VARCHAR(10) NOT NULL;
```
#### Terdapat aksi edit query dalam tabel ini karena penambahan NOT NULL ke dalam PRIMARY KEY (PK) masing-masing tabel. 

// ini format gambarnya
 ![alt text](/folder/createeditquery.png) 
 
 ## Membuat Tabel Arus Kas (`Arus_Kas`)
```sql
CREATE TABLE arus_kas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tanggal DATE NOT NULL DEFAULT CURRENT_DATE,
    kategori ENUM('pemasukan', 'pengeluaran') NOT NULL,
    jumlah DECIMAL(10, 2) NOT NULL,
    id_sumber INT,
    tipe_sumber ENUM ('penjualan', 'pembelian') NOT NULL,
    keterangan VARCHAR(250)
)ENGINE=INNODB;

```
 ![alt text](/folder/createaruskas.png) 
 
#### Untuk menampung alur kas dari perusahaan agen, ketika tabel relasi laporan_penjualan_harian dan transaksi_supplier menerima data dummy baru, tabel arus_kas secara otomatis merekam juga data baru tersebut.


 ### Edit Query (DROP/DELETE)
```sql
ALTER TABLE arus_kas
DROP COLUMN id_sumber,
DROP COLUMN tipe_sumber;
```
// ini format gambarnya
 ![alt text](/folder/aruskasdropclmn.png) 
  
#### Melakukan penghapusan kolum untuk mengganti fungsi awal id_sumber

### Edit Query (ADD)
```sql
ALTER TABLE arus_kas
ADD COLUMN id_penjualan INT,
ADD COLUMN id_pembelian INT;

```
 
#### Melakukan penambahan kolum untuk mengganti fungsi awal id_sumber yaitu penambahan dua kolom baru bernama id_penjualan dan id_pembelian supaya mengetahui secara jelas transaksi penjualan dan pembelian tersebut merujuk ke ID berapa pada tabel asalnya. 
 
### Edit Query (FK)
```sql
ALTER TABLE arus_kas
ADD CONSTRAINT fk_arus_kas_penjualan
FOREIGN KEY (id_penjualan)
REFERENCES laporan_penjualan_harian(id_penjualan)
ON DELETE CASCADE;

ALTER TABLE arus_kas
ADD CONSTRAINT fk_arus_kas_supplier
FOREIGN KEY (id_pembelian)
REFERENCES transaksi_supplier(id_transaksi)
ON DELETE CASCADE;
ON UPDATE CASCADE; // setelah trigger

```
 ![alt text](/folder/altertablearuskas.png) 
 
 #### Penambahan query ON DELETE CASCADE bermaksud supaya ketika ada penghapusan data dummy dari tabel asal, data dummy yang tercatat di arus_kas juga turut terhapus.

 ## Membuat Tabel Informasi Keuangan (`Informasi_Keuangan`)
```sql
CREATE TABLE informasi_keuangan(
    id_info INT PRIMARY KEY,
    saldo DECIMAL(10, 2) NOT NULL,
    tanggal_update DATE NOT NULL DEFAULT CURRENT_DATE
)ENGINE=INNODB;

```
 ![alt text](/folder/createinfokeu.png) 
#### Untuk menampung informasi akumulatif keuangan dari perusahaan agen.
 

 ## Membuat Tabel Relasi Transaksi_Supplier (`Transaksi_Supplier`)
```sql
CREATE TABLE transaksi_supplier(
    id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
    id_shifter VARCHAR(10) NOT NULL,
    id_kategori VARCHAR(10) NOT NULL,
    jumlah_barang_dibeli INT,
    total_transaksi DECIMAL(10, 2),
    tipe_transaksi ENUM('transfer', 'cash'),
    tanggal_pembelian DATE NOT NULL DEFAULT CURRENT_DATE
)ENGINE=INNODB;

```

 ![alt text](/folder/createtranssup.png)
#### Sebagai tabel relasi yang menjadi penghubung antara shifter dan kategori terkait pencatatan pembelian yang terjadi dengan supplier.

 ### Edit Query (FK)
```sql
ALTER TABLE transaksi_supplier
ADD CONSTRAINT fk_transaksi_supplier_shifter
FOREIGN KEY (id_shifter)
REFERENCES seller(id_shifter);

ALTER TABLE transaksi_supplier
ADD CONSTRAINT fk_transaksi_supplier_kategori
FOREIGN KEY (id_kategori)
REFERENCES kategori(id_kategori);

```
 
#### Guna menghubungkan id_shifter dan id_kategori ke dua tabel entitas, dilakukan Alter Table untuk menghubungkan foreign key ke id_shifter dari tabel seller dan id_kategori yang berasal dari tabel kategori.

## Membuat Tabel Relasi Laporan Penjualan Harian (`Laporan_Penjualan_Harian`)
```sql
CREATE TABLE laporan_penjualan_harian(
    id_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    id_shifter VARCHAR(10) NOT NULL,
    id_kategori VARCHAR(10) NOT NULL,
    jumlah_barang_terjual INT,
    tanggal_penjualan DATE NOT NULL DEFAULT CURRENT_DATE
)ENGINE=INNODB;

```
 ![alt text](/folder/createharian.png) 
#### Guna menjadi penghubung antara shifter dan kategori terkait pencatatan penjualan harian

### Edit Query (UPDATE)
```sql
ALTER TABLE laporan_penjualan_harian
ADD COLUMN total_penjualan DECIMAL(10, 2);

UPDATE laporan_penjualan_harian lph
JOIN kategori k
ON lph.id_kategori = k.id_kategori
SET lph.total_penjualan = lph.jumlah_barang_terjual * k.harga_satuan;

```
 ![alt text](/folder/lphaddcolumn.png) 

 ![alt text](/folder/updatelph.png) 
 
#### Untuk melengkapi fungsi tabel, kolom bernama total_penjualan ditambahkan untuk menyatakan total terjual secara nominal. Supaya tidak melakukan perhitungan manual antara total produk terjual dengan harga satuannya. Maka dilakukan UPDATE untuk menghasilkan perhitungan total per-kategori.

### Edit Query (FK)
```sql
ALTER TABLE laporan_penjualan_harian
ADD CONSTRAINT fk_id_dari_shifter
FOREIGN KEY (id_shifter)
REFERENCES seller(id_shifter);

ALTER TABLE laporan_penjualan_harian
ADD CONSTRAINT fk_id_dari_kategori
FOREIGN KEY (id_kategori)
REFERENCES kategori(id_kategori);

```
 ![alt text](/folder/editfklaporanharian.png) 

 
#### Menghubungkan foreign key ke id_shifter yang berasal dari tabel seller dan id_kategori yang berasal dari tabel kategori.

## Membuat Tabel Relasi Laporan Stok Mingguan (`Laporan_Stok_Mingguan`)
```sql
 CREATE TABLE laporan_stok_mingguan(
    id_lapstok INT AUTO_INCREMENT PRIMARY KEY,
    id_shifter VARCHAR(10) NOT NULL,
    id_kategori VARCHAR(10) NOT NULL,
    jumlah_stok INT,
    tanggal_penjualan DATE NOT NULL DEFAULT CURRENT_DATE
)ENGINE=INNODB;
```
 ![alt text](/folder/createstokmingguan.png) 

#### Menjadi penghubung antara shifter dan kategori terkait pencatatan stok secara mingguan.

### Edit Query (DROP COL)
``` sql
ALTER TABLE laporan_stok_mingguan DROP COLUMN tanggal_penjualan; 

```
 ![alt text](/folder/dropcol.png) 
#### Penghapusan atribut guna memperingkas tabel.

### Edit Query (FK)
``` sql
ALTER TABLE laporan_stok_mingguan
ADD CONSTRAINT fk_id_asal_shifter
FOREIGN KEY (id_shifter)
REFERENCES seller(id_shifter);

ALTER TABLE laporan_stok_mingguan
ADD CONSTRAINT fk_id_asal_kategori
FOREIGN KEY (id_kategori)
REFERENCES kategori(id_kategori);

```
 ![alt text](/folder/editquerymingguan.png) 

#### Menghubungkan  foreign key ke id_shifter yang berasal dari tabel seller dan id_kategori yang berasal dari tabel kategori.

# Pengisian Data Dummy ke dalam Setiap Tabel
### a. Pengisian Data Dummy ke Tabel seller
```sql
INSERT INTO seller (id_shifter, nama_shifter, no_telp) 
VALUES
('kezia', 'Kezia Annabel', '08123456789'),
('soja', 'Soja Purnamasari', '08234567890'),
('sonia', 'Sonia Debora', '08123456789');
```

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
 ![alt text](/folder/recordkategori.png)

 ### c. Pengisian Data Dummy ke Tabel informasi_keuangan
```sql
INSERT INTO informasi_keuangan (id_info, saldo, tanggal_update) 
VALUES
(1, 0.00, CURRENT_DATE);
```
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
 ![alt text](/folder/recordstokmingguan1.png)
  ![alt text](/folder/recordstokmingguan2.png)

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
 ![alt text](/folder/recordtransaksisup1.png)
  ![alt text](/folder/recordtransaksisup2.png)

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
 ![alt text](/folder/recordlaporanharian.png)

 ### g. Impact ke Tabel laporan_stok_mingguan

 ![alt text](/folder/impactstock.png)

  ### h. Impact Tabel arus_kas

 ![alt text](/folder/impactaruskas1.png)
 ![alt text](/folder/impactaruskas2.png)

  ### i. Impact Tabel informasi_keuangan
  
```sql
SELECT * FROM informasi_keuangan;
SELECT SUM(jumlah) as total_pemasukan FROM arus_kas WHERE kategori = ‘pemasukan’;
SELECT SUM(jumlah) as total_pengeluaran FROM arus_kas WHERE kategori = ‘pengeluaran’;
```

 ![alt text](/folder/impactinfokeu.png)

 ## 6. Trigger

 ### a. Trigger arus kas

 #### Trigger yang dibuat untuk tabel arus_kas adalah “after_arus_kas_delete”, di mana trigger ini bekerja supaya ketika tabel arus_kas melakukan DELETE di salah satu data dummy, pengurangan data tersebut mempengaruhi pula isi tabel informasi_keuangan.

 ```sql
DELIMITER $$

CREATE TRIGGER after_arus_kas_delete
AFTER DELETE ON arus_kas
FOR EACH ROW
BEGIN
    UPDATE informasi_keuangan
    SET 
        saldo = (
            SELECT 
                COALESCE(
                    (SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pemasukan'),
                    0
                ) - 
                COALESCE(
                    (SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pengeluaran'),
                    0
                )
        ),
        tanggal_update = CURRENT_DATE
    WHERE id_info = 1;
END$$
```

#### Trigger arus_kas menggunakan fungsi COALESCE untuk menangani kasus ketika tidak ada data di tabel arus_kas. Jadi, andaikan ketika kategori = ‘pemasukan’ atau ‘pengeluaran’ benar-benar tidak ada data yang masuk sama sekali, maka akan mengembalikan nilai NULL.

### b. Trigger laporan_penjualan_harian

####  Trigger-trigger di bawah ini berfungsi untuk update laporan_penjualan_harian setelah melakukan penjualan. Trigger dibuat dengan maksud memengaruhi tabel transaksi_supplier, laporan_stok_mingguan dan informasi_keuangan dalam pencatatannya.

```sql
DELIMITER $$

CREATE TRIGGER stok_sebelum_penjualan
BEFORE INSERT ON laporan_penjualan_harian
FOR EACH ROW
BEGIN
    DECLARE stok_tersedia INT;
   
    SELECT jumlah_stok INTO stok_tersedia
    FROM laporan_stok_mingguan
    WHERE id_kategori = NEW.id_kategori;
   
    IF stok_tersedia < NEW.jumlah_barang_terjual THEN
    	SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'Stok tidak cukup!';
    END IF;
END$$
```

####  Trigger di atas berfungsi untuk konfirmasi stok. Jadi ketika jumlah permintaan barang lebih besar dari jumlah stok, maka SQL akan mengirimkan pesan “Stok tidak cukup!”. 

```sql
DELIMITER $$
CREATE TRIGGER `before_insert_penjualan` 
BEFORE INSERT ON `laporan_penjualan_harian` 
FOR EACH ROW BEGIN
    DECLARE harga DECIMAL(10,2);
    DECLARE total_stok INT;
    
    SELECT harga_satuan INTO harga
    FROM kategori
    WHERE id_kategori = NEW.id_kategori;
    
    SELECT COALESCE(SUM(jumlah_stok), 0) INTO total_stok
    FROM laporan_stok_mingguan
    WHERE id_kategori = NEW.id_kategori;
    
    IF total_stok < NEW.jumlah_barang_terjual THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stok tidak cukup!';
    END IF;
    
    SET NEW.total_penjualan = NEW.jumlah_barang_terjual * harga;
END $$

DELIMITER ;
```

####  Trigger di atas berfungsi untuk persiapan sebelum penjualan dilakukan. Tujuan dari trigger tersebut adalah untuk menghitung otomatis jumlah barang terjual dengan harga satuan per kategorinya.

```sql
DELIMITER $$
CREATE TRIGGER setelah_input_penjualan_ke_arus_kas
AFTER INSERT ON laporan_penjualan_harian
FOR EACH ROW
BEGIN

    INSERT INTO arus_kas (tanggal, kategori, jumlah, id_penjualan, keterangan)
    VALUES (
        	NEW.tanggal_penjualan,
        	'pemasukan',
        	NEW.total_penjualan,
        	NEW.id_penjualan,
        	CONCAT('Penjualan oleh ', NEW.id_shifter, ' - Kategori: ', NEW.id_kategori)
    );
  
	UPDATE informasi_keuangan
	SET
    	saldo = (
        	SELECT (
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pemasukan'), 0) -
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pengeluaran'), 0));
    	tanggal_update = CURRENT_DATE
	WHERE id_info = 1;
END$$
 
saldo + NEW.total_penjualan,
        	tanggal_update = CURRENT_DATE
    WHERE id_info = 1;
  
    UPDATE laporan_stok_mingguan
    SET jumlah_stok = jumlah_stok - NEW.jumlah_barang_terjual
    WHERE id_kategori = NEW.id_kategori;
END$$

DELIMITER ;
```

#### Trigger di atas adalah untuk melakukan UPDATE ke tabel arus_kas yang di mana langsung memasukan data baru ke tabelnya, informasi_keuangan yang di mana langsung melakukan pembaruan akumulasi saldo, dan laporan_stok_mingguan yang di mana langsung mengonfirmasi jumlah stok tersisa setelah penjualan.

```sql
DELIMITER $$ 
CREATE TRIGGER setelah_hapus_penjualan
AFTER DELETE ON laporan_penjualan_harian
FOR EACH ROW
BEGIN

    UPDATE laporan_stok_mingguan
SET jumlah_stok = jumlah_stok + OLD.jumlah_barang_terjual
WHERE id_kategori = OLD.id_kategori;
 
    UPDATE informasi_keuangan
SET
    	saldo = (
        	SELECT (
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pemasukan'), 0) -
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pengeluaran'), 0))),
    	tanggal_update = CURRENT_DATE
     WHERE id_info = 1;
END$$
 
DELIMITER ;
```

####  Trigger di atas berfungsi ketika penjualan dibatalkan. Di mana jumlah_stok dari laporan_stok_mingguan mengalami UPDATE kembali ke jumlah sediakala. Pada bagian informasi_keuangan cukup terjadi pengulangan trigger saja untuk menyesuaikan data di arus_kas.

```sql
DELIMITER $$

CREATE TRIGGER setelah_input_pembelian_ke_arus_kas
AFTER INSERT ON transaksi_supplier
FOR EACH ROW
BEGIN
   
    INSERT INTO arus_kas (tanggal, kategori, jumlah, keterangan)
    VALUES (
    	NEW.tanggal_pembelian,
    	'pengeluaran',
    	NEW.total_transaksi,
    	CONCAT('Pembelian oleh ', NEW.id_shifter, ' - Kategori: ', NEW.id_kategori)
    );

    UPDATE informasi_keuangan
	SET
    	saldo = (
        	SELECT (
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pemasukan'), 0) -
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pengeluaran'), 0))),
    	tanggal_update = CURRENT_DATE
	WHERE id_info = 1;
    
IF EXISTS (
SELECT 1 FROM laporan_stok_mingguan
WHERE id_kategori = NEW.id_kategori )
THEN
    UPDATE laporan_stok_mingguan
    SET jumlah_stok = jumlah_stok + NEW.jumlah_barang_dibeli
    WHERE id_kategori = NEW.id_kategori;
ELSE
    INSERT INTO laporan_stok_mingguan (id_shifter, id_kategori, jumlah_stok)
VALUES (NEW.id_shifter,NEW. id_kategori, NEW.jumlah_barang_dibeli );
END IF;
END$$

DELIMITER ;
```

####   Trigger di atas berfungsi setelah melakukan pembelian dengan supplier. Tabel yang berpengaruh adalah tabel arus_kas, informasi_keuangan dan laporan_stok_mingguan.

### c. Trigger transaksi_supplier

#### Trigger-trigger di bawah ini berfungsi untuk melakukan UPDATE setelah melakukan pembelian. Trigger dibuat dengan maksud memengaruhi tabel laporan_stok_mingguan, arus_kas dan informasi_keuangan dalam pencatatannya.

```sql
CREATE TRIGGER update_setelah_transaksi_supplier
AFTER UPDATE ON transaksi_supplier
FOR EACH ROW
BEGIN

UPDATE laporan_stok_mingguan
SET jumlah_stok = jumlah_stok - OLD.jumlah_barang_dibeli + NEW.jumlah_barang_dibeli
WHERE id_kategori = NEW.id_kategori;

UPDATE arus_kas
SET
    	jumlah = NEW.total_transaksi,
    	tanggal = NEW.tanggal_pembelian,
    	keterangan = CONCAT('Update pembelian oleh ', NEW.id_shifter, ' - Kategori: ', NEW.id_kategori)
WHERE id_pembelian = NEW.id_transaksi;
 
UPDATE informasi_keuangan
SET
    	saldo = (
        	SELECT (
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pemasukan'), 0) -
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pengeluaran'), 0)),
tanggal_update = CURRENT_DATE
     WHERE id_info = 1;
END$$

DELIMITER ;
```

#### Trigger di atas berfungsi untuk melakukan UPDATE setelah melakukan pembelian. Trigger dibuat dengan maksud memengaruhi tabel laporan_stok_mingguan dalam pembaruan jumlah_stok, arus_kas dalam pembaruan catatan datanya, dan informasi_keuangan dalam pembaruan saldonya.

```sql
CREATE TRIGGER setelah_hapus_pembelian
AFTER DELETE ON transaksi_supplier
FOR EACH ROW
BEGIN

UPDATE laporan_stok_mingguan
SET jumlah_stok = jumlah_stok - OLD.jumlah_barang_dibeli
WHERE id_kategori = OLD.id_kategori;
 
UPDATE informasi_keuangan
SET
        saldo = (
        	SELECT
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pemasukan'), 0) -
            	COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pengeluaran'), 0)),
        tanggal_update = CURRENT_DATE
    WHERE id_info = 1;
END$$

DELIMITER ;
```

####   Trigger di atas adalah sebagai pelengkap, karena pada trigger sebelumnya kurang tanggap ketika salah satu data pembelian dihapus atau dibatalkan. Pada trigger tersebut, akan terjadi pembaruan di mana jumlah_stok dari laporan_stok_mingguan mengalami UPDATE kembali ke jumlah sediakala.
