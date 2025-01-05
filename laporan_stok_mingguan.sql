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
(8, 'soja', 'minyak 2l', 23),
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

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `laporan_stok_mingguan`
--
ALTER TABLE `laporan_stok_mingguan`
  ADD PRIMARY KEY (`id_lapstok`),
  ADD KEY `fk_id_asal_shifter` (`id_shifter`),
  ADD KEY `fk_id_asal_kategori` (`id_kategori`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `laporan_stok_mingguan`
--
ALTER TABLE `laporan_stok_mingguan`
  MODIFY `id_lapstok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `laporan_stok_mingguan`
--
ALTER TABLE `laporan_stok_mingguan`
  ADD CONSTRAINT `fk_id_asal_kategori` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`),
  ADD CONSTRAINT `fk_id_asal_shifter` FOREIGN KEY (`id_shifter`) REFERENCES `seller` (`id_shifter`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
