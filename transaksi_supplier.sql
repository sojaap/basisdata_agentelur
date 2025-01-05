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
-- AUTO_INCREMENT untuk tabel `transaksi_supplier`
--
ALTER TABLE `transaksi_supplier`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

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
