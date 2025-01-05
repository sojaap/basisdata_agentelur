-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 05 Jan 2025 pada 01.28
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

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
