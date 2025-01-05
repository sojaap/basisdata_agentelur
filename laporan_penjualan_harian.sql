-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 05 Jan 2025 pada 01.30
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `agen_telur`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_penjualan_harian`
--

CREATE TABLE `laporan_penjualan_harian` (
  `id_penjualan` int(11) NOT NULL,
  `id_shifter` varchar(10) NOT NULL,
  `id_kategori` varchar(10) NOT NULL,
  `jumlah_barang_terjual` int(11) DEFAULT NULL,
  `tanggal_penjualan` date NOT NULL DEFAULT curdate(),
  `total_penjualan` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `laporan_penjualan_harian`
--

INSERT INTO `laporan_penjualan_harian` (`id_penjualan`, `id_shifter`, `id_kategori`, `jumlah_barang_terjual`, `tanggal_penjualan`, `total_penjualan`) VALUES
(1, 'sonia', 'telur akm', 100, '2025-01-05', 250000.00),
(2, 'sonia', 'telur an', 120, '2025-01-05', 240000.00),
(3, 'sonia', 'telur bebe', 40, '2025-01-05', 120000.00),
(4, 'sonia', 'telur puyu', 40, '2025-01-05', 20000.00),
(5, 'sonia', 'telur asin', 30, '2025-01-05', 150000.00),
(6, 'sonia', 'telur reta', 45, '2025-01-05', 67500.00),
(7, 'soja', 'minyak 1l', 10, '2025-01-05', 150000.00),
(8, 'soja', 'minyak 2l', 7, '2025-01-05', 210000.00),
(9, 'soja', 'tissue', 5, '2025-01-05', 100000.00),
(10, 'soja', 'beras 5kg', 6, '2025-01-05', 360000.00),
(11, 'soja', 'indomie', 26, '2025-01-05', 78000.00),
(12, 'soja', 'mie sedap', 14, '2025-01-05', 35000.00),
(13, 'soja', 'bumbu', 8, '2025-01-05', 16000.00),
(14, 'kezia', 'royco', 27, '2025-01-05', 27000.00),
(15, 'kezia', 'garam', 4, '2025-01-05', 20000.00),
(16, 'kezia', 'cuka', 2, '2025-01-05', 16000.00),
(17, 'kezia', 'kecap', 3, '2025-01-05', 30000.00),
(18, 'kezia', 'kunyit', 13, '2025-01-05', 13000.00),
(19, 'kezia', 'merica', 21, '2025-01-05', 21000.00),
(20, 'kezia', 'saos', 6, '2025-01-05', 72000.00);

--
-- Trigger `laporan_penjualan_harian`
--
DELIMITER $$
CREATE TRIGGER `before_insert_penjualan` BEFORE INSERT ON `laporan_penjualan_harian` FOR EACH ROW BEGIN
    DECLARE harga DECIMAL(10,2);
    DECLARE total_stok INT;
    
    -- Ambil harga satuan dari tabel kategori
    SELECT harga_satuan INTO harga
    FROM kategori
    WHERE id_kategori = NEW.id_kategori;
    
    -- Hitung total stok dengan SUM
    SELECT COALESCE(SUM(jumlah_stok), 0) INTO total_stok
    FROM laporan_stok_mingguan
    WHERE id_kategori = NEW.id_kategori;
    
    -- Cek stok
    IF total_stok < NEW.jumlah_barang_terjual THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stok tidak cukup!';
    END IF;
    
    -- Set total penjualan secara otomatis
    SET NEW.total_penjualan = NEW.jumlah_barang_terjual * harga;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `setelah_hapus_penjualan` AFTER DELETE ON `laporan_penjualan_harian` FOR EACH ROW BEGIN
    -- Kembalikan stok
    UPDATE laporan_stok_mingguan
    SET jumlah_stok = jumlah_stok + OLD.jumlah_barang_terjual
    WHERE id_kategori = OLD.id_kategori;

    -- Hapus record terkait di arus_kas
    DELETE FROM arus_kas 
    WHERE id_penjualan = OLD.id_penjualan;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `setelah_input_penjualan_ke_arus_kas` AFTER INSERT ON `laporan_penjualan_harian` FOR EACH ROW BEGIN
    -- Insert ke arus kas
    INSERT INTO arus_kas (
        tanggal, 
        kategori, 
        jumlah, 
        id_penjualan,
        keterangan
    )
    VALUES (
        NEW.tanggal_penjualan,
        'pemasukan',
        NEW.total_penjualan,
        NEW.id_penjualan,
        CONCAT('Penjualan oleh ', NEW.id_shifter, ' - Kategori: ', NEW.id_kategori)
    );

    -- Update stok
    UPDATE laporan_stok_mingguan
    SET jumlah_stok = jumlah_stok - NEW.jumlah_barang_terjual
    WHERE id_kategori = NEW.id_kategori;

    -- Update saldo dengan kalkulasi ulang
    UPDATE informasi_keuangan
    SET 
        saldo = (
            SELECT (
                COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pemasukan'), 0) -
                COALESCE((SELECT SUM(jumlah) FROM arus_kas WHERE kategori = 'pengeluaran'), 0)
            )
        ),
        tanggal_update = CURRENT_DATE
    WHERE id_info = 1;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `stok_sebelum_penjualan` BEFORE INSERT ON `laporan_penjualan_harian` FOR EACH ROW BEGIN
    DECLARE stok_tersedia INT;
   
    SELECT jumlah_stok INTO stok_tersedia
    FROM laporan_stok_mingguan
    WHERE id_kategori = NEW.id_kategori;
   
    IF stok_tersedia < NEW.jumlah_barang_terjual THEN
    	SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'Stok tidak cukup!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_setelah_penjualan_harian` AFTER UPDATE ON `laporan_penjualan_harian` FOR EACH ROW BEGIN
    -- 1. Perbarui stok di laporan_stok_mingguan
    UPDATE laporan_stok_mingguan
    SET jumlah_stok = jumlah_stok + OLD.jumlah_barang_terjual - NEW.jumlah_barang_terjual
    WHERE id_kategori = NEW.id_kategori;

    -- 2. Hapus data lama dari arus_kas
    DELETE FROM arus_kas
    WHERE id_penjualan = OLD.id_penjualan;

    -- 3. Tambahkan data baru ke arus_kas untuk penjualan baru
    INSERT INTO arus_kas (tanggal, kategori, jumlah, id_penjualan, keterangan)
    VALUES (
        CURRENT_DATE, -- Tanggal transaksi
        'pemasukan', -- Kategori pemasukan
        NEW.total_penjualan, -- Total penjualan baru
        NEW.id_penjualan, -- ID penjualan baru
        CONCAT('Update penjualan oleh ', NEW.id_shifter, ' - Kategori: ', NEW.id_kategori) -- Keterangan
    );

    -- 4. Perbarui saldo di informasi_keuangan
    UPDATE informasi_keuangan
    SET saldo = (
        (SELECT COALESCE(SUM(jumlah), 0) FROM arus_kas WHERE kategori = 'pemasukan') -
        (SELECT COALESCE(SUM(jumlah), 0) FROM arus_kas WHERE kategori = 'pengeluaran')
    ),
    tanggal_update = CURRENT_DATE
    WHERE id_info = 1;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `laporan_penjualan_harian`
--
ALTER TABLE `laporan_penjualan_harian`
  ADD PRIMARY KEY (`id_penjualan`),
  ADD KEY `fk_id_dari_shifter` (`id_shifter`),
  ADD KEY `fk_id_dari_kategori` (`id_kategori`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `laporan_penjualan_harian`
--
ALTER TABLE `laporan_penjualan_harian`
  MODIFY `id_penjualan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `laporan_penjualan_harian`
--
ALTER TABLE `laporan_penjualan_harian`
  ADD CONSTRAINT `fk_id_dari_kategori` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`),
  ADD CONSTRAINT `fk_id_dari_shifter` FOREIGN KEY (`id_shifter`) REFERENCES `seller` (`id_shifter`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
