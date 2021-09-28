-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 08, 2021 at 03:15 AM
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

-- --------------------------------------------------------

--
-- Table structure for table `history_karyawan`
--

CREATE TABLE `history_karyawan` (
  `id_user` varchar(15) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
-- Table structure for table `history_umk`
--

CREATE TABLE `history_umk` (
  `id_umk` int(11) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

-- --------------------------------------------------------

--
-- Table structure for table `master_absensi`
--

CREATE TABLE `master_absensi` (
  `id_absensi` char(16) NOT NULL,
  `id_user` varchar(15) NOT NULL,
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

-- --------------------------------------------------------

--
-- Table structure for table `master_karyawan`
--

CREATE TABLE `master_karyawan` (
  `id_user` varchar(15) NOT NULL,
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

-- --------------------------------------------------------

--
-- Table structure for table `master_lembur`
--

CREATE TABLE `master_lembur` (
  `id_lembur` int(11) NOT NULL,
  `id_user` varchar(15) NOT NULL,
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
  `status_umk` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_cuti`
--

CREATE TABLE `transaksi_cuti` (
  `id_cuti` int(11) NOT NULL,
  `id_user` varchar(15) NOT NULL,
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
  `id_user` varchar(15) NOT NULL,
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
-- Table structure for table `user_login`
--

CREATE TABLE `user_login` (
  `id_user` int(11) NOT NULL,
  `id_user` varchar(15) NOT NULL,
  `username` varchar(25) NOT NULL,
  `password_user` varchar(255) NOT NULL,
  `status` char(1) NOT NULL,
  `change_at` date NOT NULL,
  `change_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_login`
--

INSERT INTO `user_login` (`id_user`, `id_user`, `username`, `password_user`, `status`, `change_at`, `change_by`) VALUES
(1, 'asd', 'admin', '21232f297a57a5a743894a0e4a801fc3', 'Y', '2021-02-05', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `master_absensi`
--
ALTER TABLE `master_absensi`
  ADD PRIMARY KEY (`id_absensi`),
  ADD KEY `id_user` (`id_user`);

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
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `id_jabatan` (`id_jabatan`),
  ADD KEY `id_divisi` (`id_divisi`),
  ADD KEY `id_jam_kerja` (`id_jam_kerja`);

--
-- Indexes for table `master_lembur`
--
ALTER TABLE `master_lembur`
  ADD PRIMARY KEY (`id_lembur`),
  ADD KEY `id_user` (`id_user`);

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
  ADD KEY `id_user` (`id_user`);

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
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_umk` (`id_umk`);

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
  MODIFY `id_divisi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `master_jabatan`
--
ALTER TABLE `master_jabatan`
  MODIFY `id_jabatan` int(5) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `master_jam_kerja`
--
ALTER TABLE `master_jam_kerja`
  MODIFY `id_jam_kerja` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `master_kalender`
--
ALTER TABLE `master_kalender`
  MODIFY `id_kalender` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `master_lembur`
--
ALTER TABLE `master_lembur`
  MODIFY `id_lembur` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `master_umk`
--
ALTER TABLE `master_umk`
  MODIFY `id_umk` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaksi_cuti`
--
ALTER TABLE `transaksi_cuti`
  MODIFY `id_cuti` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `master_absensi`
--
ALTER TABLE `master_absensi`
  ADD CONSTRAINT `master_absensi_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `master_karyawan` (`id_user`);

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
  ADD CONSTRAINT `master_lembur_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `master_karyawan` (`id_user`);

--
-- Constraints for table `transaksi_cuti`
--
ALTER TABLE `transaksi_cuti`
  ADD CONSTRAINT `transaksi_cuti_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `master_karyawan` (`id_user`);

--
-- Constraints for table `transaksi_detail_cuti`
--
ALTER TABLE `transaksi_detail_cuti`
  ADD CONSTRAINT `transaksi_detail_cuti_ibfk_1` FOREIGN KEY (`id_cuti`) REFERENCES `transaksi_cuti` (`id_cuti`);

--
-- Constraints for table `transaksi_penggajian`
--
ALTER TABLE `transaksi_penggajian`
  ADD CONSTRAINT `transaksi_penggajian_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `master_karyawan` (`id_user`),
  ADD CONSTRAINT `transaksi_penggajian_ibfk_2` FOREIGN KEY (`id_umk`) REFERENCES `master_umk` (`id_umk`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
