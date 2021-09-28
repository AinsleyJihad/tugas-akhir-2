-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 10, 2021 at 03:49 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `payroll`
--

-- --------------------------------------------------------

--
-- Table structure for table `history_absensi`
--

CREATE TABLE `history_absensi` (
  `id_absensi` char(16) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_cuti`
--

CREATE TABLE `history_cuti` (
  `id_cuti` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_divisi`
--

CREATE TABLE `history_divisi` (
  `id_divisi` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_divisi`
--

INSERT INTO `history_divisi` (`id_divisi`, `reason`, `change_by`, `change_at`) VALUES
(1, 'Create', 1, '2021-02-08'),
(3, 'Create', 1, '2021-02-08'),
(4, 'Create', 1, '2021-02-08'),
(5, 'Create', 1, '2021-02-08'),
(6, 'Create', 1, '2021-02-08'),
(7, 'Create', 1, '2021-02-08'),
(8, 'Create', 1, '2021-02-08'),
(9, 'Create', 1, '2021-02-08'),
(10, 'Create', 1, '2021-02-08'),
(11, 'Create', 1, '2021-02-08'),
(12, 'Create', 1, '2021-02-08'),
(13, 'Create', 1, '2021-02-08'),
(14, 'Create', 1, '2021-02-08'),
(15, 'Create', 1, '2021-02-08'),
(16, 'Create', 1, '2021-02-08'),
(17, 'Create', 1, '2021-02-08'),
(18, 'Create', 1, '2021-02-09'),
(19, 'Create', 1, '2021-02-09'),
(3, 'Edit', 1, '2021-02-09'),
(10, 'Edit', 1, '2021-02-09'),
(20, 'Create', 1, '2021-02-09'),
(8, 'Edit', 2, '2021-02-09'),
(1, 'Edit', 1, '2021-02-10'),
(1, 'Edit', 1, '2021-02-10'),
(1, 'Edit', 1, '2021-02-10'),
(5, 'Edit', 1, '2021-02-10');

-- --------------------------------------------------------

--
-- Table structure for table `history_jabatan`
--

CREATE TABLE `history_jabatan` (
  `id_jabatan` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_jabatan`
--

INSERT INTO `history_jabatan` (`id_jabatan`, `reason`, `change_by`, `change_at`) VALUES
(1, 'Create', 1, '2021-02-08'),
(2, 'Create', 1, '2021-02-08'),
(2, 'Edit', 2, '2021-02-09');

-- --------------------------------------------------------

--
-- Table structure for table `history_jam_kerja`
--

CREATE TABLE `history_jam_kerja` (
  `id_jam_kerja` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_jam_kerja`
--

INSERT INTO `history_jam_kerja` (`id_jam_kerja`, `reason`, `change_by`, `change_at`) VALUES
(1, 'Create', 1, '2021-02-08'),
(2, 'Create', 1, '2021-02-09');

-- --------------------------------------------------------

--
-- Table structure for table `history_kalender`
--

CREATE TABLE `history_kalender` (
  `id_kalender` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_kalender`
--

INSERT INTO `history_kalender` (`id_kalender`, `reason`, `change_by`, `change_at`) VALUES
(1, 'Create', 1, '2021-02-08'),
(2, 'Create', 1, '2021-02-08');

-- --------------------------------------------------------

--
-- Table structure for table `history_karyawan`
--

CREATE TABLE `history_karyawan` (
  `id_karyawan` varchar(15) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_karyawan`
--

INSERT INTO `history_karyawan` (`id_karyawan`, `reason`, `change_by`, `change_at`) VALUES
('KR0000000000001', 'Create', 1, '2021-02-09'),
('OS0000000000002', 'Create', 1, '2021-02-09'),
('KR0000000000003', 'Create', 1, '2021-02-09'),
('OS0000000000004', 'Create', 1, '2021-02-09');

-- --------------------------------------------------------

--
-- Table structure for table `history_lembur`
--

CREATE TABLE `history_lembur` (
  `id_lembur` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_penggajian`
--

CREATE TABLE `history_penggajian` (
  `id_gaji` varchar(16) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_surat_ijin`
--

CREATE TABLE `history_surat_ijin` (
  `id_surat_ijin` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_umk`
--

CREATE TABLE `history_umk` (
  `id_umk` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_umk`
--

INSERT INTO `history_umk` (`id_umk`, `reason`, `change_by`, `change_at`) VALUES
(1, 'Create', 1, '2021-02-08');

-- --------------------------------------------------------

--
-- Table structure for table `history_user_login`
--

CREATE TABLE `history_user_login` (
  `id_user` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_user_login`
--

INSERT INTO `history_user_login` (`id_user`, `reason`, `change_by`, `change_at`) VALUES
(2, 'Create', 1, '2021-02-09');

-- --------------------------------------------------------

--
-- Table structure for table `master_absensi`
--

CREATE TABLE `master_absensi` (
  `id_absensi` char(16) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `jam_absensi` datetime NOT NULL,
  `status_absensi` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `master_divisi`
--

CREATE TABLE `master_divisi` (
  `id_divisi` int(11) NOT NULL,
  `nama_divisi` varchar(40) NOT NULL,
  `status_divisi` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_divisi`
--

INSERT INTO `master_divisi` (`id_divisi`, `nama_divisi`, `status_divisi`, `change_by`, `change_at`) VALUES
(1, 'Divisi Baru', 'Y', 1, '2021-02-10'),
(2, 'nama_divisi', 'Y', 1, '2021-02-08'),
(3, 'update divisi', 'N', 1, '2021-02-09'),
(4, 'divisi baru uwu', 'Y', 1, '2021-02-08'),
(5, 'nama_divisi_baru_baru', 'N', 1, '2021-02-10'),
(6, 'nama_divisi_baru_baru_baru', 'Y', 1, '2021-02-08'),
(7, 'nama_divisi_1', 'Y', 1, '2021-02-08'),
(8, 'nama_divisi_2 edit', 'N', 2, '2021-02-09'),
(9, 'divdiv', 'Y', 1, '2021-02-08'),
(10, 'new divisi edit', 'N', 1, '2021-02-09'),
(11, 'nama_divisi_333', 'Y', 1, '2021-02-08'),
(12, 'nama_divisi_111', 'Y', 1, '2021-02-08'),
(13, 'nama_divisi_321', 'Y', 1, '2021-02-08'),
(14, 'divisi baru uwu 222', 'Y', 1, '2021-02-08'),
(15, 'nama_divisi_____', 'Y', 1, '2021-02-08'),
(16, 'nama_divisi____', 'Y', 1, '2021-02-08'),
(17, 'nama_divisi', 'Y', 1, '2021-02-08'),
(18, 'divisi baru uwu', 'Y', 1, '2021-02-09'),
(19, 'divisi a', 'Y', 1, '2021-02-09'),
(20, 'divisi 20', 'Y', 1, '2021-02-09');

-- --------------------------------------------------------

--
-- Table structure for table `master_jabatan`
--

CREATE TABLE `master_jabatan` (
  `id_jabatan` int(5) NOT NULL,
  `nama_jabatan` varchar(40) NOT NULL,
  `tunjangan_jabatan` int(11) DEFAULT NULL,
  `status_jabatan` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_jabatan`
--

INSERT INTO `master_jabatan` (`id_jabatan`, `nama_jabatan`, `tunjangan_jabatan`, `status_jabatan`, `change_by`, `change_at`) VALUES
(1, 'jabatan', 0, 'Y', 1, '2021-02-08'),
(2, 'jabatan new', 12322, 'N', 2, '2021-02-09');

-- --------------------------------------------------------

--
-- Table structure for table `master_jam_kerja`
--

CREATE TABLE `master_jam_kerja` (
  `id_jam_kerja` int(11) NOT NULL,
  `nama_jam_kerja` varchar(40) NOT NULL,
  `jam_masuk` time NOT NULL,
  `jam_pulang` time NOT NULL,
  `status_jam_kerja` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_jam_kerja`
--

INSERT INTO `master_jam_kerja` (`id_jam_kerja`, `nama_jam_kerja`, `jam_masuk`, `jam_pulang`, `status_jam_kerja`, `change_by`, `change_at`) VALUES
(1, 'Pagi', '08:00:00', '17:00:00', 'Y', 1, '2021-02-08'),
(2, 'Pagi 2', '07:30:00', '16:30:00', 'Y', 1, '2021-02-09');

-- --------------------------------------------------------

--
-- Table structure for table `master_kalender`
--

CREATE TABLE `master_kalender` (
  `id_kalender` int(11) NOT NULL,
  `jenis_hari` varchar(25) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_akhir` date NOT NULL,
  `jumlah_hari` int(11) NOT NULL,
  `status_kalender` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_kalender`
--

INSERT INTO `master_kalender` (`id_kalender`, `jenis_hari`, `tanggal_mulai`, `tanggal_akhir`, `jumlah_hari`, `status_kalender`, `change_by`, `change_at`) VALUES
(1, 'Cuti Bersama', '2021-02-08', '2021-02-08', 1, 'Y', 1, '2021-02-08'),
(2, 'Hari Libur', '2021-02-07', '2021-02-07', 1, 'Y', 1, '2021-02-08');

-- --------------------------------------------------------

--
-- Table structure for table `master_karyawan`
--

CREATE TABLE `master_karyawan` (
  `auto_id` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `pin` varchar(15) NOT NULL,
  `id_jabatan` int(11) NOT NULL,
  `id_divisi` int(11) NOT NULL,
  `nama_karyawan` varchar(50) NOT NULL,
  `id_jam_kerja` int(11) NOT NULL,
  `nik` char(16) NOT NULL,
  `no_ktp` char(16) NOT NULL,
  `npwp` char(15) DEFAULT NULL,
  `jenis_kelamin_karyawan` char(1) NOT NULL,
  `tanggal_masuk_karyawan` date NOT NULL,
  `tanggal_keluar_karyawan` date DEFAULT NULL,
  `status_karyawan` varchar(4) NOT NULL,
  `telp_karyawan` varchar(15) DEFAULT NULL,
  `tempat_lahir_karyawan` varchar(30) DEFAULT NULL,
  `tanggal_lahir_karyawan` date DEFAULT NULL,
  `alamat_karyawan` varchar(100) DEFAULT NULL,
  `tanggal_pengangkatan` date DEFAULT NULL,
  `keterangan` varchar(40) DEFAULT NULL,
  `k_tk` varchar(20) DEFAULT NULL,
  `pendidikan` varchar(50) DEFAULT NULL,
  `pkwt1` varchar(40) DEFAULT NULL,
  `pkwt2` varchar(40) DEFAULT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_karyawan`
--

INSERT INTO `master_karyawan` (`auto_id`, `id_karyawan`, `pin`, `id_jabatan`, `id_divisi`, `nama_karyawan`, `id_jam_kerja`, `nik`, `no_ktp`, `npwp`, `jenis_kelamin_karyawan`, `tanggal_masuk_karyawan`, `tanggal_keluar_karyawan`, `status_karyawan`, `telp_karyawan`, `tempat_lahir_karyawan`, `tanggal_lahir_karyawan`, `alamat_karyawan`, `tanggal_pengangkatan`, `keterangan`, `k_tk`, `pendidikan`, `pkwt1`, `pkwt2`, `change_by`, `change_at`) VALUES
(1, 'KR0000000000001', '123', 1, 18, 'as', 2, '1234567891234567', '1234567891234567', '', 'L', '2021-02-09', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', 1, '2021-02-09'),
(3, 'KR0000000000003', '1233', 2, 17, 'rifki', 2, '1234567891234567', '1234567891234567', '', 'P', '2021-02-09', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', 1, '2021-02-09'),
(2, 'OS0000000000002', '12313', 2, 18, 'as', 2, '1234567891234567', '1234567891234567', '', 'P', '2021-02-09', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Outsourcing', 'Kontrak', '', '', '', 1, '2021-02-09'),
(4, 'OS0000000000004', '65656', 1, 17, 'danny', 2, '1234567891234567', '1234567891234567', '', 'L', '2021-02-03', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Outsourcing', 'Tidak Kontrak', '', '', '', 1, '2021-02-09');

-- --------------------------------------------------------

--
-- Table structure for table `master_lembur`
--

CREATE TABLE `master_lembur` (
  `id_lembur` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `jam_mulai` datetime NOT NULL,
  `jam_akhir` datetime NOT NULL,
  `uraian_kerja` varchar(80) NOT NULL,
  `persetujuan` char(1) NOT NULL,
  `change_at` datetime NOT NULL,
  `status_lembur` char(1) NOT NULL,
  `change_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `master_umk`
--

CREATE TABLE `master_umk` (
  `id_umk` int(11) NOT NULL,
  `tahun_umk` int(11) NOT NULL,
  `total_umk` int(11) NOT NULL,
  `status_umk` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_umk`
--

INSERT INTO `master_umk` (`id_umk`, `tahun_umk`, `total_umk`, `status_umk`, `change_by`, `change_at`) VALUES
(1, 2019, 3000000, 'Y', 1, '2021-02-08');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_cuti`
--

CREATE TABLE `transaksi_cuti` (
  `id_cuti` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `sisa_cuti` int(11) NOT NULL,
  `tahun_cuti` int(11) NOT NULL,
  `status_cuti` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_detail_cuti`
--

CREATE TABLE `transaksi_detail_cuti` (
  `id_cuti` int(11) NOT NULL,
  `ambil_cuti` int(11) NOT NULL,
  `tahun_cuti` int(11) NOT NULL,
  `tanggal_mulai_cuti` date NOT NULL,
  `tanggal_akhir_cuti` date NOT NULL,
  `status_detail_cuti` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_penggajian`
--

CREATE TABLE `transaksi_penggajian` (
  `id_gaji` varchar(16) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `id_umk` int(11) DEFAULT NULL,
  `tanggal_gaji` date NOT NULL,
  `tunjangan_jabatan` int(11) DEFAULT NULL,
  `tunjangan_keluarga` int(11) DEFAULT NULL,
  `ongkos_bongkar` int(11) DEFAULT NULL,
  `ongkos_lain_lain` int(11) DEFAULT NULL,
  `total_lembur` int(11) DEFAULT NULL,
  `total_gaji` int(11) NOT NULL,
  `timestamp_gaji` datetime NOT NULL,
  `status_gaji` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_surat_ijin`
--

CREATE TABLE `transaksi_surat_ijin` (
  `id_surat_ijin` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `tanggal_ijin` date NOT NULL,
  `alasan_ijin` varchar(50) NOT NULL,
  `jam_datang_keluar_ijin` time NOT NULL,
  `status_ijin` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_login`
--

CREATE TABLE `user_login` (
  `id_user` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `username` varchar(25) NOT NULL,
  `password_user` varchar(255) NOT NULL,
  `status` char(1) NOT NULL,
  `change_at` date NOT NULL,
  `change_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_login`
--

INSERT INTO `user_login` (`id_user`, `id_karyawan`, `username`, `password_user`, `status`, `change_at`, `change_by`) VALUES
(1, 'KR0000000000001', 'admin', '21232f297a57a5a743894a0e4a801fc3', 'Y', '2021-02-05', 1),
(2, 'KR0000000000003', 'admin2', 'c84258e9c39059a89ab77d846ddab909', 'Y', '2021-02-09', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `master_absensi`
--
ALTER TABLE `master_absensi`
  ADD PRIMARY KEY (`id_absensi`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `master_divisi`
--
ALTER TABLE `master_divisi`
  ADD PRIMARY KEY (`id_divisi`);

--
-- Indexes for table `master_jabatan`
--
ALTER TABLE `master_jabatan`
  ADD PRIMARY KEY (`id_jabatan`);

--
-- Indexes for table `master_jam_kerja`
--
ALTER TABLE `master_jam_kerja`
  ADD PRIMARY KEY (`id_jam_kerja`);

--
-- Indexes for table `master_kalender`
--
ALTER TABLE `master_kalender`
  ADD PRIMARY KEY (`id_kalender`);

--
-- Indexes for table `master_karyawan`
--
ALTER TABLE `master_karyawan`
  ADD PRIMARY KEY (`id_karyawan`),
  ADD UNIQUE KEY `auto_id` (`auto_id`),
  ADD KEY `id_jabatan` (`id_jabatan`),
  ADD KEY `id_divisi` (`id_divisi`),
  ADD KEY `id_jam_kerja` (`id_jam_kerja`);

--
-- Indexes for table `master_lembur`
--
ALTER TABLE `master_lembur`
  ADD PRIMARY KEY (`id_lembur`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `master_umk`
--
ALTER TABLE `master_umk`
  ADD PRIMARY KEY (`id_umk`);

--
-- Indexes for table `transaksi_cuti`
--
ALTER TABLE `transaksi_cuti`
  ADD PRIMARY KEY (`id_cuti`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `transaksi_detail_cuti`
--
ALTER TABLE `transaksi_detail_cuti`
  ADD KEY `id_cuti` (`id_cuti`);

--
-- Indexes for table `transaksi_penggajian`
--
ALTER TABLE `transaksi_penggajian`
  ADD PRIMARY KEY (`id_gaji`),
  ADD KEY `id_karyawan` (`id_karyawan`),
  ADD KEY `id_umk` (`id_umk`);

--
-- Indexes for table `transaksi_surat_ijin`
--
ALTER TABLE `transaksi_surat_ijin`
  ADD PRIMARY KEY (`id_surat_ijin`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `user_login`
--
ALTER TABLE `user_login`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `master_divisi`
--
ALTER TABLE `master_divisi`
  MODIFY `id_divisi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `master_jabatan`
--
ALTER TABLE `master_jabatan`
  MODIFY `id_jabatan` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `master_jam_kerja`
--
ALTER TABLE `master_jam_kerja`
  MODIFY `id_jam_kerja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `master_kalender`
--
ALTER TABLE `master_kalender`
  MODIFY `id_kalender` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `master_lembur`
--
ALTER TABLE `master_lembur`
  MODIFY `id_lembur` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `master_umk`
--
ALTER TABLE `master_umk`
  MODIFY `id_umk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transaksi_cuti`
--
ALTER TABLE `transaksi_cuti`
  MODIFY `id_cuti` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaksi_surat_ijin`
--
ALTER TABLE `transaksi_surat_ijin`
  MODIFY `id_surat_ijin` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `master_absensi`
--
ALTER TABLE `master_absensi`
  ADD CONSTRAINT `master_absensi_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `master_karyawan` (`id_karyawan`);

--
-- Constraints for table `master_karyawan`
--
ALTER TABLE `master_karyawan`
  ADD CONSTRAINT `master_karyawan_ibfk_1` FOREIGN KEY (`id_jabatan`) REFERENCES `master_jabatan` (`id_jabatan`),
  ADD CONSTRAINT `master_karyawan_ibfk_2` FOREIGN KEY (`id_divisi`) REFERENCES `master_divisi` (`id_divisi`),
  ADD CONSTRAINT `master_karyawan_ibfk_3` FOREIGN KEY (`id_jam_kerja`) REFERENCES `master_jam_kerja` (`id_jam_kerja`);

--
-- Constraints for table `master_lembur`
--
ALTER TABLE `master_lembur`
  ADD CONSTRAINT `master_lembur_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `master_karyawan` (`id_karyawan`);

--
-- Constraints for table `transaksi_cuti`
--
ALTER TABLE `transaksi_cuti`
  ADD CONSTRAINT `transaksi_cuti_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `master_karyawan` (`id_karyawan`);

--
-- Constraints for table `transaksi_detail_cuti`
--
ALTER TABLE `transaksi_detail_cuti`
  ADD CONSTRAINT `transaksi_detail_cuti_ibfk_1` FOREIGN KEY (`id_cuti`) REFERENCES `transaksi_cuti` (`id_cuti`);

--
-- Constraints for table `transaksi_penggajian`
--
ALTER TABLE `transaksi_penggajian`
  ADD CONSTRAINT `transaksi_penggajian_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `master_karyawan` (`id_karyawan`),
  ADD CONSTRAINT `transaksi_penggajian_ibfk_2` FOREIGN KEY (`id_umk`) REFERENCES `master_umk` (`id_umk`);

--
-- Constraints for table `transaksi_surat_ijin`
--
ALTER TABLE `transaksi_surat_ijin`
  ADD CONSTRAINT `transaksi_surat_ijin_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `master_karyawan` (`id_karyawan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
