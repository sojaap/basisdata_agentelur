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
(60, '2025-01-05', 'pemasukan', 72000.00, 20, NULL, 'Penjualan oleh kezia - Kategori: saos');

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
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  ADD CONSTRAINT `fk_arus_kas_supplier` FOREIGN KEY (`id_pembelian`) REFERENCES `transaksi_supplier` (`id_transaksi`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
