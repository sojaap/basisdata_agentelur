-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 05 Jan 2025 pada 16.46
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

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `proses_pembelian_supplier` (IN `p_id_shifter` VARCHAR(10), IN `p_id_kategori` VARCHAR(10), IN `p_jumlah_barang` INT, IN `p_tipe_transaksi` VARCHAR(10), IN `p_tanggal` DATE)   BEGIN
    -- Tangani error dengan rollback
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Terjadi kesalahan dalam proses pembelian';
    END;

    -- Mulai transaksi
    START TRANSACTION;

        -- Tambahkan data ke transaksi_supplier
        INSERT INTO transaksi_supplier (
            id_shifter, 
            id_kategori, 
            jumlah_barang_dibeli, 
            tipe_transaksi, 
            tanggal_pembelian
        )
        VALUES (
            p_id_shifter, 
            p_id_kategori, 
            p_jumlah_barang,  -- Perbaiki dari p_jumlah ke p_jumlah_barang
            p_tipe_transaksi, 
            p_tanggal
        );

    -- Selesaikan transaksi
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proses_penjualan_harian` (IN `p_id_shifter` VARCHAR(10), IN `p_id_kategori` VARCHAR(10), IN `p_jumlah_barang` INT, IN `p_tanggal` DATE)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Terjadi kesalahan dalam proses penjualan';
    END;
 
    START TRANSACTION; 
        IF NOT EXISTS (
            SELECT 1 FROM laporan_stok_mingguan 
            WHERE id_kategori = p_id_kategori 
            AND jumlah_stok >= p_jumlah_barang
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stok tidak mencukupi';
        END IF;

      INSERT INTO laporan_penjualan_harian (id_shifter, id_kategori, jumlah_barang_terjual, tanggal_penjualan)
        VALUES (p_id_shifter, p_id_kategori, p_jumlah_barang, p_tanggal);

    COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `arus_kas`
--

CREATE TABLE `arus_kas` (
  `id` int(11) NOT NULL,
  `tanggal` date NOT NULL DEFAULT curdate(),
  `kategori` enum('pemasukan','pengeluaran') NOT NULL,
  `jumlah` decimal(10,2) NOT NULL,
  `id_penjualan` int(11) DEFAULT NULL,
  `id_pembelian` int(11) DEFAULT NULL,
  `keterangan` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `arus_kas`
--

INSERT INTO `arus_kas` (`id`, `tanggal`, `kategori`, `jumlah`, `id_penjualan`, `id_pembelian`, `keterangan`) VALUES
(21, '2025-01-05', 'pengeluaran', 276000.00, NULL, 1, 'Pembelian oleh sonia - Kategori: telur akm'),
(22, '2025-01-05', 'pengeluaran', 160000.00, NULL, 2, 'Pembelian oleh sonia - Kategori: telur an'),
(23, '2025-01-05', 'pengeluaran', 170000.00, NULL, 3, 'Pembelian oleh sonia - Kategori: telur bebe'),
(24, '2025-01-05', 'pengeluaran', 50000.00, NULL, 4, 'Pembelian oleh sonia - Kategori: telur puyu'),
(25, '2025-01-05', 'pengeluaran', 140000.00, NULL, 5, 'Pembelian oleh sonia - Kategori: telur asin'),
(26, '2025-01-05', 'pengeluaran', 0.00, NULL, 6, 'Pembelian oleh sonia - Kategori: telur reta'),
(27, '2025-01-05', 'pengeluaran', 300000.00, NULL, 7, 'Pembelian oleh soja - Kategori: minyak 1l'),
(28, '2025-01-05', 'pengeluaran', 600000.00, NULL, 8, 'Pembelian oleh soja - Kategori: minyak 2l'),
(29, '2025-01-05', 'pengeluaran', 170000.00, NULL, 9, 'Pembelian oleh soja - Kategori: tissue'),
(30, '2025-01-05', 'pengeluaran', 500000.00, NULL, 10, 'Pembelian oleh soja - Kategori: beras 5kg'),
(31, '2025-01-05', 'pengeluaran', 75000.00, NULL, 11, 'Pembelian oleh soja - Kategori: indomie'),
(32, '2025-01-05', 'pengeluaran', 65000.00, NULL, 12, 'Pembelian oleh soja - Kategori: mie sedap'),
(33, '2025-01-05', 'pengeluaran', 30000.00, NULL, 13, 'Pembelian oleh soja - Kategori: bumbu'),
(34, '2025-01-05', 'pengeluaran', 20000.00, NULL, 14, 'Pembelian oleh kezia - Kategori: royco'),
(35, '2025-01-05', 'pengeluaran', 60000.00, NULL, 15, 'Pembelian oleh kezia - Kategori: garam'),
(36, '2025-01-05', 'pengeluaran', 60000.00, NULL, 16, 'Pembelian oleh kezia - Kategori: cuka'),
(37, '2025-01-05', 'pengeluaran', 180000.00, NULL, 17, 'Pembelian oleh kezia - Kategori: kecap'),
(38, '2025-01-05', 'pengeluaran', 15000.00, NULL, 18, 'Pembelian oleh kezia - Kategori: kunyit'),
(39, '2025-01-05', 'pengeluaran', 15000.00, NULL, 19, 'Pembelian oleh kezia - Kategori: merica'),
(40, '2025-01-05', 'pengeluaran', 200000.00, NULL, 20, 'Pembelian oleh kezia - Kategori: saos'),
(41, '2025-01-05', 'pemasukan', 250000.00, 1, NULL, 'Penjualan oleh sonia - Kategori: telur akm'),
(42, '2025-01-05', 'pemasukan', 240000.00, 2, NULL, 'Penjualan oleh sonia - Kategori: telur an'),
(43, '2025-01-05', 'pemasukan', 120000.00, 3, NULL, 'Penjualan oleh sonia - Kategori: telur bebe'),
(44, '2025-01-05', 'pemasukan', 20000.00, 4, NULL, 'Penjualan oleh sonia - Kategori: telur puyu'),
(45, '2025-01-05', 'pemasukan', 150000.00, 5, NULL, 'Penjualan oleh sonia - Kategori: telur asin'),
(46, '2025-01-05', 'pemasukan', 67500.00, 6, NULL, 'Penjualan oleh sonia - Kategori: telur reta'),
(47, '2025-01-05', 'pemasukan', 150000.00, 7, NULL, 'Penjualan oleh soja - Kategori: minyak 1l'),
(48, '2025-01-05', 'pemasukan', 210000.00, 8, NULL, 'Penjualan oleh soja - Kategori: minyak 2l'),
(49, '2025-01-05', 'pemasukan', 100000.00, 9, NULL, 'Penjualan oleh soja - Kategori: tissue'),
(50, '2025-01-05', 'pemasukan', 360000.00, 10, NULL, 'Penjualan oleh soja - Kategori: beras 5kg'),
(51, '2025-01-05', 'pemasukan', 78000.00, 11, NULL, 'Penjualan oleh soja - Kategori: indomie'),
(52, '2025-01-05', 'pemasukan', 35000.00, 12, NULL, 'Penjualan oleh soja - Kategori: mie sedap'),
(53, '2025-01-05', 'pemasukan', 16000.00, 13, NULL, 'Penjualan oleh soja - Kategori: bumbu'),
(54, '2025-01-05', 'pemasukan', 27000.00, 14, NULL, 'Penjualan oleh kezia - Kategori: royco'),
(55, '2025-01-05', 'pemasukan', 20000.00, 15, NULL, 'Penjualan oleh kezia - Kategori: garam'),
(56, '2025-01-05', 'pemasukan', 16000.00, 16, NULL, 'Penjualan oleh kezia - Kategori: cuka'),
(57, '2025-01-05', 'pemasukan', 30000.00, 17, NULL, 'Penjualan oleh kezia - Kategori: kecap'),
(58, '2025-01-05', 'pemasukan', 13000.00, 18, NULL, 'Penjualan oleh kezia - Kategori: kunyit'),
(59, '2025-01-05', 'pemasukan', 21000.00, 19, NULL, 'Penjualan oleh kezia - Kategori: merica'),
(60, '2025-01-05', 'pemasukan', 72000.00, 20, NULL, 'Penjualan oleh kezia - Kategori: saos'),
(61, '2025-01-05', 'pemasukan', 300000.00, 21, NULL, 'Penjualan oleh soja - Kategori: minyak 2l');

--
-- Trigger `arus_kas`
--
DELIMITER $$
CREATE TRIGGER `after_arus_kas_delete` AFTER DELETE ON `arus_kas` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `informasi_keuangan`
--

CREATE TABLE `informasi_keuangan` (
  `id_info` int(11) NOT NULL,
  `saldo` decimal(10,2) NOT NULL,
  `tanggal_update` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `informasi_keuangan`
--

INSERT INTO `informasi_keuangan` (`id_info`, `saldo`, `tanggal_update`) VALUES
(1, -790500.00, '2025-01-05');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` varchar(10) NOT NULL,
  `nama_kategori` varchar(30) NOT NULL,
  `harga_satuan` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`, `harga_satuan`) VALUES
('ayam', 'ayam potong', 25000.00),
('beras 5kg', 'Beras 5 Kg', 60000.00),
('bumbu', 'Bumbu Racik', 2000.00),
('cuka', 'Cuka', 8000.00),
('garam', 'Garam', 5000.00),
('indomie', 'Indomie', 3000.00),
('kecap', 'Kecap Manis', 10000.00),
('kunyit', 'Kunyit Bubuk', 1000.00),
('merica', 'Merica Bubuk', 1000.00),
('mie sedap', 'Mie Sedap', 2500.00),
('minyak 1l', 'Minyak 1 Liter', 15000.00),
('minyak 2l', 'Minyak 2 Liter', 30000.00),
('royco', 'Royco', 1000.00),
('saos', 'Saos Sambal', 12000.00),
('telur akm', 'Telur Ayam Kampung', 2500.00),
('telur an', 'Telur Ayam Negeri', 2000.00),
('telur asin', 'Telur Asin', 5000.00),
('telur bebe', 'Telur Bebek', 3000.00),
('telur puyu', 'Telur Puyuh', 500.00),
('telur reta', 'Telur Retak', 1500.00),
('tissue', 'Tissue', 20000.00);

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
(20, 'kezia', 'saos', 6, '2025-01-05', 72000.00),
(21, 'soja', 'minyak 2l', 10, '2025-01-05', 300000.00);

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

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_stok_mingguan`
--

CREATE TABLE `laporan_stok_mingguan` (
  `id_lapstok` int(11) NOT NULL,
  `id_shifter` varchar(10) NOT NULL,
  `id_kategori` varchar(10) NOT NULL,
  `jumlah_stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `laporan_stok_mingguan`
--

INSERT INTO `laporan_stok_mingguan` (`id_lapstok`, `id_shifter`, `id_kategori`, `jumlah_stok`) VALUES
(1, 'sonia', 'telur akm', 20),
(2, 'sonia', 'telur an', 0),
(3, 'sonia', 'telur bebe', 20),
(4, 'sonia', 'telur puyu', 20),
(5, 'sonia', 'telur asin', 0),
(6, 'sonia', 'telur reta', 5),
(7, 'soja', 'minyak 1l', 20),
(8, 'soja', 'minyak 2l', 13),
(9, 'soja', 'tissue', 5),
(10, 'soja', 'beras 5kg', 4),
(11, 'soja', 'indomie', 4),
(12, 'soja', 'mie sedap', 16),
(13, 'soja', 'bumbu', 7),
(14, 'kezia', 'royco', 3),
(15, 'kezia', 'garam', 11),
(16, 'kezia', 'cuka', 8),
(17, 'kezia', 'kecap', 17),
(18, 'kezia', 'kunyit', 17),
(19, 'kezia', 'merica', 9),
(20, 'kezia', 'saos', 14);

-- --------------------------------------------------------

--
-- Struktur dari tabel `seller`
--

CREATE TABLE `seller` (
  `id_shifter` varchar(10) NOT NULL,
  `nama_shifter` varchar(30) NOT NULL,
  `no_telp` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `seller`
--

INSERT INTO `seller` (`id_shifter`, `nama_shifter`, `no_telp`) VALUES
('kezia', 'Kezia Annabel', '08123456789'),
('salim', 'Ahmad Salim', '081234567890'),
('soja', 'Soja Purnamasari', '08234567890'),
('sonia', 'Sonia Debora', '08123456789');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi_supplier`
--

CREATE TABLE `transaksi_supplier` (
  `id_transaksi` int(11) NOT NULL,
  `id_shifter` varchar(10) NOT NULL,
  `id_kategori` varchar(10) NOT NULL,
  `jumlah_barang_dibeli` int(11) DEFAULT NULL,
  `total_transaksi` decimal(10,2) DEFAULT NULL,
  `tipe_transaksi` enum('transfer','cash') DEFAULT NULL,
  `tanggal_pembelian` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi_supplier`
--

INSERT INTO `transaksi_supplier` (`id_transaksi`, `id_shifter`, `id_kategori`, `jumlah_barang_dibeli`, `total_transaksi`, `tipe_transaksi`, `tanggal_pembelian`) VALUES
(1, 'sonia', 'telur akm', 120, 276000.00, 'transfer', '2025-01-05'),
(2, 'sonia', 'telur an', 120, 160000.00, 'transfer', '2025-01-05'),
(3, 'sonia', 'telur bebe', 60, 170000.00, 'transfer', '2025-01-05'),
(4, 'sonia', 'telur puyu', 60, 50000.00, 'transfer', '2025-01-05'),
(5, 'sonia', 'telur asin', 30, 140000.00, 'transfer', '2025-01-05'),
(6, 'sonia', 'telur reta', 50, 0.00, 'transfer', '2025-01-05'),
(7, 'soja', 'minyak 1l', 30, 300000.00, 'transfer', '2025-01-05'),
(8, 'soja', 'minyak 2l', 30, 600000.00, 'transfer', '2025-01-05'),
(9, 'soja', 'tissue', 10, 170000.00, 'transfer', '2025-01-05'),
(10, 'soja', 'beras 5kg', 10, 500000.00, 'transfer', '2025-01-05'),
(11, 'soja', 'indomie', 30, 75000.00, 'transfer', '2025-01-05'),
(12, 'soja', 'mie sedap', 30, 65000.00, 'transfer', '2025-01-05'),
(13, 'soja', 'bumbu', 15, 30000.00, 'transfer', '2025-01-05'),
(14, 'kezia', 'royco', 30, 20000.00, 'cash', '2025-01-05'),
(15, 'kezia', 'garam', 15, 60000.00, 'cash', '2025-01-05'),
(16, 'kezia', 'cuka', 10, 60000.00, 'cash', '2025-01-05'),
(17, 'kezia', 'kecap', 20, 180000.00, 'cash', '2025-01-05'),
(18, 'kezia', 'kunyit', 30, 15000.00, 'cash', '2025-01-05'),
(19, 'kezia', 'merica', 30, 15000.00, 'cash', '2025-01-05'),
(20, 'kezia', 'saos', 20, 200000.00, 'cash', '2025-01-05');

--
-- Trigger `transaksi_supplier`
--
DELIMITER $$
CREATE TRIGGER `setelah_hapus_pembelian` AFTER DELETE ON `transaksi_supplier` FOR EACH ROW BEGIN
    -- Kurangi stok
    UPDATE laporan_stok_mingguan
    SET jumlah_stok = jumlah_stok - OLD.jumlah_barang_dibeli
    WHERE id_kategori = OLD.id_kategori;

    -- Hitung ulang dan update saldo
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `setelah_input_pembelian_ke_arus_kas` AFTER INSERT ON `transaksi_supplier` FOR EACH ROW BEGIN
    -- Insert ke arus kas
    INSERT INTO arus_kas (
        tanggal, 
        kategori, 
        jumlah, 
        id_pembelian,
        keterangan
    )
    VALUES (
        NEW.tanggal_pembelian,
        'pengeluaran',
        NEW.total_transaksi,
        NEW.id_transaksi,
        CONCAT('Pembelian oleh ', NEW.id_shifter, ' - Kategori: ', NEW.id_kategori)
    );

    -- Update stok
    UPDATE laporan_stok_mingguan
    SET jumlah_stok = jumlah_stok + NEW.jumlah_barang_dibeli
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
CREATE TRIGGER `update_setelah_transaksi_supplier` AFTER UPDATE ON `transaksi_supplier` FOR EACH ROW BEGIN
    -- Update stok
    UPDATE laporan_stok_mingguan
    SET jumlah_stok = jumlah_stok - OLD.jumlah_barang_dibeli + NEW.jumlah_barang_dibeli
    WHERE id_kategori = NEW.id_kategori;
    
    -- Update record di arus_kas
    UPDATE arus_kas 
    SET 
        jumlah = NEW.total_transaksi,
        tanggal = NEW.tanggal_pembelian,
        keterangan = CONCAT('Update pembelian oleh ', NEW.id_shifter, ' - Kategori: ', NEW.id_kategori)
    WHERE id_pembelian = NEW.id_transaksi;

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

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_arus_kas_supplier` (`id_pembelian`);

--
-- Indeks untuk tabel `informasi_keuangan`
--
ALTER TABLE `informasi_keuangan`
  ADD PRIMARY KEY (`id_info`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `laporan_penjualan_harian`
--
ALTER TABLE `laporan_penjualan_harian`
  ADD PRIMARY KEY (`id_penjualan`),
  ADD KEY `fk_id_dari_shifter` (`id_shifter`),
  ADD KEY `fk_id_dari_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `laporan_stok_mingguan`
--
ALTER TABLE `laporan_stok_mingguan`
  ADD PRIMARY KEY (`id_lapstok`),
  ADD KEY `fk_id_asal_shifter` (`id_shifter`),
  ADD KEY `fk_id_asal_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `seller`
--
ALTER TABLE `seller`
  ADD PRIMARY KEY (`id_shifter`);

--
-- Indeks untuk tabel `transaksi_supplier`
--
ALTER TABLE `transaksi_supplier`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `fk_transaksi_supplier_shifter` (`id_shifter`),
  ADD KEY `fk_transaksi_supplier_kategori` (`id_kategori`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT untuk tabel `laporan_penjualan_harian`
--
ALTER TABLE `laporan_penjualan_harian`
  MODIFY `id_penjualan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT untuk tabel `laporan_stok_mingguan`
--
ALTER TABLE `laporan_stok_mingguan`
  MODIFY `id_lapstok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `transaksi_supplier`
--
ALTER TABLE `transaksi_supplier`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  ADD CONSTRAINT `fk_arus_kas_supplier` FOREIGN KEY (`id_pembelian`) REFERENCES `transaksi_supplier` (`id_transaksi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `laporan_penjualan_harian`
--
ALTER TABLE `laporan_penjualan_harian`
  ADD CONSTRAINT `fk_id_dari_kategori` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`),
  ADD CONSTRAINT `fk_id_dari_shifter` FOREIGN KEY (`id_shifter`) REFERENCES `seller` (`id_shifter`);

--
-- Ketidakleluasaan untuk tabel `laporan_stok_mingguan`
--
ALTER TABLE `laporan_stok_mingguan`
  ADD CONSTRAINT `fk_id_asal_kategori` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`),
  ADD CONSTRAINT `fk_id_asal_shifter` FOREIGN KEY (`id_shifter`) REFERENCES `seller` (`id_shifter`);

--
-- Ketidakleluasaan untuk tabel `transaksi_supplier`
--
ALTER TABLE `transaksi_supplier`
  ADD CONSTRAINT `fk_transaksi_supplier_kategori` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`),
  ADD CONSTRAINT `fk_transaksi_supplier_shifter` FOREIGN KEY (`id_shifter`) REFERENCES `seller` (`id_shifter`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
