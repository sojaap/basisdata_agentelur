-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 05 Jan 2025 pada 01.29
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
(1, -1090500.00, '2025-01-05');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `informasi_keuangan`
--
ALTER TABLE `informasi_keuangan`
  ADD PRIMARY KEY (`id_info`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
