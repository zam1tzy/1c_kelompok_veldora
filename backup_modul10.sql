-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 08, 2026 at 03:39 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `praktikum_modul10`
--

-- --------------------------------------------------------

--
-- Table structure for table `fasilitas`
--

CREATE TABLE `fasilitas` (
  `id_fasilitas` int UNSIGNED NOT NULL,
  `nama_fasilitas` varchar(100) NOT NULL,
  `jenis_fasilitas` varchar(50) NOT NULL,
  `lokasi` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasilitas`
--

INSERT INTO `fasilitas` (`id_fasilitas`, `nama_fasilitas`, `jenis_fasilitas`, `lokasi`) VALUES
(1, 'Toilet Gedung A', 'Toilet', 'Gedung A Lt.1'),
(2, 'WiFi Gedung B', 'Jaringan Internet', 'Gedung B'),
(3, 'Lab Komputer 1', 'Laboratorium Komputer', 'Gedung C');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_kerusakan`
--

CREATE TABLE `kategori_kerusakan` (
  `id_kategori` int UNSIGNED NOT NULL,
  `nama_kategori` enum('Ringan','Sedang','Berat') NOT NULL,
  `deskripsi` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori_kerusakan`
--

INSERT INTO `kategori_kerusakan` (`id_kategori`, `nama_kategori`, `deskripsi`) VALUES
(1, 'Ringan', 'Gangguan kecil, fasilitas masih bisa dipakai'),
(2, 'Sedang', 'Fungsi fasilitas terganggu sebagian'),
(3, 'Berat', 'Fasilitas tidak dapat digunakan');

-- --------------------------------------------------------

--
-- Table structure for table `laporan`
--

CREATE TABLE `laporan` (
  `id_laporan` int UNSIGNED NOT NULL,
  `id_user` int UNSIGNED NOT NULL,
  `id_fasilitas` int UNSIGNED NOT NULL,
  `id_kategori` int UNSIGNED NOT NULL,
  `lokasi_detail` varchar(150) DEFAULT NULL,
  `deskripsi` text NOT NULL,
  `foto_bukti` varchar(255) DEFAULT NULL,
  `tanggal_lapor` date NOT NULL,
  `status` enum('Menunggu','Diproses','Selesai') NOT NULL DEFAULT 'Menunggu'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `laporan`
--

INSERT INTO `laporan` (`id_laporan`, `id_user`, `id_fasilitas`, `id_kategori`, `lokasi_detail`, `deskripsi`, `foto_bukti`, `tanggal_lapor`, `status`) VALUES
(1, 1, 1, 3, 'Bilik 2', 'Kran patah', NULL, '2026-10-01', 'Diproses'),
(2, 2, 1, 1, 'Bilik 1', 'Lampu redup', NULL, '2026-10-02', 'Diproses'),
(3, 1, 2, 2, 'Lantai 2', 'WiFi putus-putus', NULL, '2026-10-03', 'Selesai'),
(4, 2, 1, 3, 'Bilik 3', 'Pintu rusak', NULL, '2026-10-04', 'Menunggu'),
(5, 1, 3, 2, 'Meja 5', 'Monitor mati', NULL, '2026-10-05', 'Diproses'),
(7, 2, 3, 3, 'Meja 2', 'Keyboard tidak berfungsi', NULL, '2026-10-06', 'Diproses'),
(8, 2, 3, 3, 'Meja 2', 'Keyboard tidak berfungsi', NULL, '2026-10-06', 'Diproses');

-- --------------------------------------------------------

--
-- Table structure for table `penanganan`
--

CREATE TABLE `penanganan` (
  `id_penanganan` int UNSIGNED NOT NULL,
  `id_laporan` int UNSIGNED NOT NULL,
  `id_petugas` int UNSIGNED NOT NULL,
  `tanggal_penugasan` date NOT NULL,
  `tanggal_selesai` date DEFAULT NULL,
  `catatan` text
) ;

--
-- Dumping data for table `penanganan`
--

INSERT INTO `penanganan` (`id_penanganan`, `id_laporan`, `id_petugas`, `tanggal_penugasan`, `tanggal_selesai`, `catatan`) VALUES
(1, 2, 1, '2026-10-03', NULL, 'Ganti lampu'),
(2, 3, 1, '2026-10-04', '2026-10-06', 'Router direset'),
(3, 5, 1, '2026-10-06', NULL, 'Cek unit monitor'),
(4, 7, 1, '2026-10-06', NULL, 'Dijadwalkan pengecekan'),
(5, 8, 1, '2026-10-06', NULL, 'Dijadwalkan pengecekan');

-- --------------------------------------------------------

--
-- Table structure for table `petugas`
--

CREATE TABLE `petugas` (
  `id_petugas` int UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `jabatan` enum('Teknisi','Pengelola Fasilitas') NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `petugas`
--

INSERT INTO `petugas` (`id_petugas`, `nama`, `jabatan`, `email`, `password`) VALUES
(1, 'Pak Teknisi', 'Teknisi', 'teknisi@example.test', 'hash_dummy'),
(2, 'Bu Pengelola', 'Pengelola Fasilitas', 'pengelola@example.test', 'hash_dummy');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `nomor_induk` varchar(20) NOT NULL,
  `kategori_pengguna` enum('Mahasiswa','Dosen','Tendik') NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nama`, `nomor_induk`, `kategori_pengguna`, `email`, `password`) VALUES
(1, 'Adam', '264311060', 'Mahasiswa', 'adam@example.test', 'hash_dummy'),
(2, 'Iltizam', '264311071', 'Mahasiswa', 'iltizam@example.test', 'hash_dummy');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD PRIMARY KEY (`id_fasilitas`);

--
-- Indexes for table `kategori_kerusakan`
--
ALTER TABLE `kategori_kerusakan`
  ADD PRIMARY KEY (`id_kategori`),
  ADD UNIQUE KEY `nama_kategori` (`nama_kategori`);

--
-- Indexes for table `laporan`
--
ALTER TABLE `laporan`
  ADD PRIMARY KEY (`id_laporan`),
  ADD KEY `fk_laporan_user` (`id_user`),
  ADD KEY `fk_laporan_fasilitas` (`id_fasilitas`),
  ADD KEY `fk_laporan_kategori` (`id_kategori`);

--
-- Indexes for table `penanganan`
--
ALTER TABLE `penanganan`
  ADD PRIMARY KEY (`id_penanganan`),
  ADD KEY `fk_penanganan_laporan` (`id_laporan`),
  ADD KEY `fk_penanganan_petugas` (`id_petugas`);

--
-- Indexes for table `petugas`
--
ALTER TABLE `petugas`
  ADD PRIMARY KEY (`id_petugas`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `nomor_induk` (`nomor_induk`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `fasilitas`
--
ALTER TABLE `fasilitas`
  MODIFY `id_fasilitas` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `kategori_kerusakan`
--
ALTER TABLE `kategori_kerusakan`
  MODIFY `id_kategori` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `laporan`
--
ALTER TABLE `laporan`
  MODIFY `id_laporan` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `penanganan`
--
ALTER TABLE `penanganan`
  MODIFY `id_penanganan` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `petugas`
--
ALTER TABLE `petugas`
  MODIFY `id_petugas` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `laporan`
--
ALTER TABLE `laporan`
  ADD CONSTRAINT `fk_laporan_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_laporan_kategori` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_kerusakan` (`id_kategori`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_laporan_user` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `penanganan`
--
ALTER TABLE `penanganan`
  ADD CONSTRAINT `fk_penanganan_laporan` FOREIGN KEY (`id_laporan`) REFERENCES `laporan` (`id_laporan`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_penanganan_petugas` FOREIGN KEY (`id_petugas`) REFERENCES `petugas` (`id_petugas`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
