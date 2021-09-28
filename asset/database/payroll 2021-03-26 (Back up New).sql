-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 26, 2021 at 08:17 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.2

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

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getAlasanIzin` (`id` VARCHAR(15), `tgl` VARCHAR(20), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE alasan VARCHAR(20) DEFAULT '';

	SELECT (IF(EXISTS(
        SELECT 'Y' as hasil
        FROM transaksi_surat_ijin
        WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = a.tanggal_jadwal AND transaksi_surat_ijin.status_ijin = 'Y'
    ),
               (SELECT transaksi_surat_ijin.alasan_ijin
                FROM transaksi_surat_ijin
                WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = a.tanggal_jadwal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N')) into alasan
    FROM master_jd_kerja_kyw as a,
         master_karyawan as b,
         master_jam_kerja c,
         master_divisi d
    WHERE a.status = 'Y' AND
          b.id_karyawan = a.id_karyawan AND
          c.id_jam_kerja = a.id_jam_kerja AND
          d.id_divisi = b.id_divisi AND
          IF(id = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = id) AND
          IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '10') AND
          a.tanggal_jadwal = STR_TO_DATE(tgl, '%Y-%m-%d') AND
          IF(b.k_tk = 'Kontrak', 
             IF(bulan = '1', 
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d'),
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d')),
             IF(bulan = '1', 
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d'),
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d')));
  	RETURN alasan;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getGajiPerJam` (`tahun` INT) RETURNS INT(11) BEGIN
  	DECLARE gpj int DEFAULT 0;

    SELECT master_umk.gaji_per_jam into gpj
    FROM master_umk
    WHERE master_umk.tahun_umk = tahun AND
          master_umk.status_umk = 'Y';
  	RETURN gpj;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getGajiPokok` (`tahun` INT) RETURNS INT(11) BEGIN
  	DECLARE gp int DEFAULT 0;

    SELECT master_umk.total_umk into gp
    FROM master_umk
    WHERE master_umk.tahun_umk = tahun AND
          master_umk.status_umk = 'Y';
  RETURN gp;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getHari` (`tgl` VARCHAR(20)) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE hari VARCHAR(20) DEFAULT '';

	SELECT IF(EXISTS( SELECT a.*
                  FROM master_kalender a
                  WHERE STR_TO_DATE(tgl, '%Y-%m-%d') BETWEEN a.tanggal_mulai AND a.tanggal_akhir AND
                        a.status_kalender = 'Y'), 
          		( SELECT a.jenis_hari
                  FROM master_kalender a
                  WHERE STR_TO_DATE(tgl, '%Y-%m-%d') BETWEEN a.tanggal_mulai AND a.tanggal_akhir AND
                        a.status_kalender = 'Y'), 'N') into hari;
  	RETURN hari;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getIdSuratIzin` (`id` VARCHAR(15), `tgl` VARCHAR(20), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE id_surjin VARCHAR(20) DEFAULT '';

	SELECT IFNULL((IF(EXISTS(
        SELECT 'Y' as hasil
        FROM transaksi_surat_ijin
        WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = a.tanggal_jadwal AND transaksi_surat_ijin.status_ijin = 'Y'
    ),
               (SELECT transaksi_surat_ijin.id_surat_ijin
                FROM transaksi_surat_ijin
                WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = a.tanggal_jadwal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N')), 'N') into id_surjin
    FROM master_jd_kerja_kyw as a,
         master_karyawan as b,
         master_jam_kerja c,
         master_divisi d
    WHERE a.status = 'Y' AND
          b.id_karyawan = a.id_karyawan AND
          c.id_jam_kerja = a.id_jam_kerja AND
          d.id_divisi = b.id_divisi AND
          IF(id = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = id) AND
          IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '10') AND
          a.tanggal_jadwal = STR_TO_DATE(tgl, '%Y-%m-%d') AND
          IF(b.k_tk = 'Kontrak', 
             IF(bulan = '1', 
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d'),
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d')),
             IF(bulan = '1', 
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d'),
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d')));
  	RETURN id_surjin;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getJamIzin` (`id` VARCHAR(15), `tgl` VARCHAR(20), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE jam VARCHAR(20) DEFAULT '';

		SELECT (IF(EXISTS(
                            SELECT 'Y' as hasil
                            FROM transaksi_surat_ijin
                            WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = a.tanggal_jadwal AND transaksi_surat_ijin.status_ijin = 'Y'
                            ),
                            (SELECT transaksi_surat_ijin.jam_datang_keluar_ijin
                            FROM transaksi_surat_ijin
                            WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = a.tanggal_jadwal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N')) into jam
    FROM master_jd_kerja_kyw as a,
         master_karyawan as b,
         master_jam_kerja c,
         master_divisi d
    WHERE a.status = 'Y' AND
          b.id_karyawan = a.id_karyawan AND
          c.id_jam_kerja = a.id_jam_kerja AND
          d.id_divisi = b.id_divisi AND
          IF(id = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = id) AND
          IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '10') AND
          a.tanggal_jadwal = STR_TO_DATE(tgl, '%Y-%m-%d') AND
          IF(b.k_tk = 'Kontrak', 
             IF(bulan = '1', 
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d'),
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d')),
             IF(bulan = '1', 
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d'),
                a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d')));
  	RETURN jam;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getJamMasuk` (`id` VARCHAR(15), `tgl` VARCHAR(20), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE jam VARCHAR(20) DEFAULT '';

	SELECT (IF((a.id_jam_kerja <> 5 AND DAYNAME(a.tanggal_jadwal) <> 'Saturday') OR (a.id_jam_kerja <> 5 AND DAYNAME(a.tanggal_jadwal) = 'Saturday'),
                               		(SELECT MIN(master_absensi.jam_absensi)
                                    FROM master_jd_kerja_kyw
                                    JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                                    WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    									  master_absensi.id_karyawan = b.id_karyawan AND
                                          master_absensi.status_absensi = 'Y'),
                               		IF(a.id_jam_kerja = 5,
                                    (SELECT MIN(master_absensi.jam_absensi)
                                    FROM master_jd_kerja_kyw
                                    JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                                    WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    									  master_absensi.id_karyawan = b.id_karyawan AND
                                          master_absensi.status_absensi = 'Y' AND
                                    	  master_absensi.jam_absensi > '12:0:0'),
                               		(SELECT MAX(master_absensi.jam_absensi)
                                    FROM master_jd_kerja_kyw
                                    JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                                    WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    									  master_absensi.id_karyawan = b.id_karyawan AND
                                          master_absensi.status_absensi = 'Y')))) into jam
        from master_jd_kerja_kyw as a,
             master_karyawan as b,
             master_jam_kerja c,
             master_divisi d
        WHERE a.status = 'Y' AND
              b.id_karyawan = a.id_karyawan AND
              c.id_jam_kerja = a.id_jam_kerja AND
              d.id_divisi = b.id_divisi AND
              IF(id = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = id) AND
              IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '10') AND
              a.tanggal_jadwal = STR_TO_DATE(tgl, '%Y-%m-%d') AND
              IF(b.k_tk = 'Kontrak', 
                 IF(bulan = '1', 
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d'),
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d')),
                 IF(bulan = '1', 
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d'),
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d')));
  	RETURN jam;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getJamPulang` (`id` VARCHAR(15), `tgl` VARCHAR(20), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE jam VARCHAR(20) DEFAULT '';

	SELECT (IF((a.id_jam_kerja <> 5 AND DAYNAME(a.tanggal_jadwal) <> 'Saturday')  OR (a.id_jam_kerja <> 5 AND DAYNAME(a.tanggal_jadwal) = 'Saturday'),
                            		(SELECT MAX(master_absensi.jam_absensi)
                                    FROM master_jd_kerja_kyw
                                    JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                                    WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    									  master_absensi.id_karyawan = b.id_karyawan AND
                                          master_absensi.status_absensi = 'Y'),
                               		IF(a.id_jam_kerja = 5 AND DAYNAME(a.tanggal_jadwal) = 'Saturday',
                                    (SELECT MAX(master_absensi.jam_absensi)
                                    FROM master_jd_kerja_kyw
                                    JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                                    WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    									  master_absensi.id_karyawan = b.id_karyawan AND
                                          master_absensi.status_absensi = 'Y'),
                               		(SELECT MIN(master_absensi.jam_absensi)
                                    FROM master_jd_kerja_kyw
                                    JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                                    WHERE master_absensi.tanggal_absensi = DATE_ADD(a.tanggal_jadwal, INTERVAL 1 DAY) AND
    									  master_absensi.id_karyawan = b.id_karyawan AND
                                          master_absensi.status_absensi = 'Y')))) into jam
        from master_jd_kerja_kyw as a,
             master_karyawan as b,
             master_jam_kerja c,
             master_divisi d
        WHERE a.status = 'Y' AND
              b.id_karyawan = a.id_karyawan AND
              c.id_jam_kerja = a.id_jam_kerja AND
              d.id_divisi = b.id_divisi AND
              IF(id = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = id) AND
              IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '10') AND
              a.tanggal_jadwal = STR_TO_DATE(tgl, '%Y-%m-%d') AND
              IF(b.k_tk = 'Kontrak', 
                 IF(bulan = '1', 
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d'),
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d')),
                 IF(bulan = '1', 
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d'),
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d')));
  	RETURN jam;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getOngkosBongkar` (`id` VARCHAR(15), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE ob VARCHAR(20) DEFAULT '';

    SELECT IFNULL((SELECT IF(EXISTS(
                    SELECT transaksi_penggajian.ongkos_bongkar as hasil
                    FROM transaksi_penggajian
                    WHERE transaksi_penggajian.id_karyawan = id AND 
                          transaksi_penggajian.tahun_gaji = tahun AND 
           				  transaksi_penggajian.bulan_gaji = bulan AND 
                          transaksi_penggajian.status_gaji = 'Y'
                   ),
                     (SELECT transaksi_penggajian.ongkos_bongkar as hasil
                      FROM transaksi_penggajian
                      WHERE transaksi_penggajian.id_karyawan = id AND 
                            transaksi_penggajian.tahun_gaji = tahun AND 
           				    transaksi_penggajian.bulan_gaji = bulan AND 
                            transaksi_penggajian.status_gaji = 'Y'),
                      'N')), 'N') into ob;
  	RETURN ob;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getOngkosLain` (`id` VARCHAR(15), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE ol VARCHAR(20) DEFAULT '';

    SELECT IFNULL((SELECT IF(EXISTS(
                    SELECT transaksi_penggajian.ongkos_lain_lain as hasil
                    FROM transaksi_penggajian
                    WHERE transaksi_penggajian.id_karyawan = id AND 
                          transaksi_penggajian.tahun_gaji = tahun AND 
           				  transaksi_penggajian.bulan_gaji = bulan AND 
                          transaksi_penggajian.status_gaji = 'Y'
                   ),
                     (SELECT transaksi_penggajian.ongkos_lain_lain as hasil
                      FROM transaksi_penggajian
                      WHERE transaksi_penggajian.id_karyawan = id AND 
                            transaksi_penggajian.tahun_gaji = tahun AND 
           				    transaksi_penggajian.bulan_gaji = bulan AND 
                            transaksi_penggajian.status_gaji = 'Y'),
                      'N')), 'N') into ol;
  	RETURN ol;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getPotongAbsen` (`id` VARCHAR(15), `tahun` INT, `bulan` INT) RETURNS INT(11) BEGIN
  	DECLARE potong INT DEFAULT 0;

	SELECT COUNT(a.id_karyawan) as potong_absen into potong
                    from master_jd_kerja_kyw as a,
                        master_karyawan as b,
                        master_jam_kerja c,
                        master_divisi d
                    WHERE a.status = 'Y' AND
                        b.id_karyawan = a.id_karyawan AND
                        c.id_jam_kerja = a.id_jam_kerja AND
                        d.id_divisi = b.id_divisi AND
                        IF(id = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = id) AND
                        IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '10') AND
                        IF(b.k_tk = 'Kontrak', 
                           IF(bulan = '1', 
                              a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-18'), '%Y-%m-%d')AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d'),
                              a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d')),
                           IF(bulan = '1', 
                              a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d'),
                              a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-25'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d'))) AND
                           IF(getHari(a.tanggal_jadwal) = 'N',
                            IF(DAYNAME(a.tanggal_jadwal) = 'Saturday',
                               IF(getStatusCuti(a.id_karyawan, a.tanggal_jadwal, tahun, bulan) = 'N',
                                 IF(getIdSuratIzin(a.id_karyawan, a.tanggal_jadwal, tahun, bulan) = 'N',
                                  IF(getJamMasuk(a.id_karyawan, a.tanggal_jadwal, tahun, bulan) <> getJamPulang(a.id_karyawan, a.tanggal_jadwal, tahun, bulan),
                                     IF(getIdSuratIzin(a.id_karyawan, a.tanggal_jadwal, tahun, bulan) = 'N',
                                        IF(TIMEDIFF (getJamMasuk(a.id_karyawan, a.tanggal_jadwal, tahun, bulan), c.jam_masuk_sabtu) >= '0:10:0', 2=1, 
                                           IF(TIMEDIFF (getJamPulang(a.id_karyawan, a.tanggal_jadwal, tahun, bulan), c.jam_pulang_sabtu) >= '0:0:0', 2=1, 2=1)),
                                        2=1), 1=1), 2=1), 2=1),
                               IF(getStatusCuti(a.id_karyawan, a.tanggal_jadwal, tahun, bulan) = 'N',
                                 IF(getIdSuratIzin(a.id_karyawan, a.tanggal_jadwal, tahun, bulan) = 'N',
                                  IF(getJamMasuk(a.id_karyawan, a.tanggal_jadwal, tahun, bulan) <> getJamPulang(a.id_karyawan, a.tanggal_jadwal, tahun, bulan),
                                     IF(getIdSuratIzin(a.id_karyawan, a.tanggal_jadwal, tahun, bulan) = 'N',
                                        IF(TIMEDIFF (getJamMasuk(a.id_karyawan,a.tanggal_jadwal, tahun, bulan), c.jam_masuk) >= '0:10:0', 2=1,
                                           IF(TIMEDIFF (getJamPulang(a.id_karyawan, a.tanggal_jadwal, tahun, bulan), c.jam_pulang) >= '0:0:0', 2=1, 2=1)),
                                        2=1), 1=1), 2=1), 2=1)), 2=1);
  	RETURN potong;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getPotonganLain` (`id` VARCHAR(15), `tahun` INT, `bulan` INT) RETURNS FLOAT BEGIN
  	DECLARE potong FLOAT DEFAULT 0;

	SELECT IFNULL((SELECT IF(EXISTS
                    (SELECT SUM(transaksi_potong_absen.total_hari)
                    FROM transaksi_potong_absen
                    WHERE transaksi_potong_absen.status_potong = 'Y' AND
                          transaksi_potong_absen.id_karyawan = id AND
                          transaksi_potong_absen.tahun = tahun AND
                          transaksi_potong_absen.bulan = bulan)
                    ,
                    (SELECT SUM(transaksi_potong_absen.total_hari)
                    FROM transaksi_potong_absen
                    WHERE transaksi_potong_absen.status_potong = 'Y' AND
                          transaksi_potong_absen.id_karyawan = id AND
                          transaksi_potong_absen.tahun = tahun AND
                          transaksi_potong_absen.bulan = bulan),
                      0)), 0) into potong;
  	RETURN potong;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getStatusCuti` (`id` VARCHAR(15), `tgl` VARCHAR(20), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE cuti VARCHAR(20) DEFAULT '';

	SELECT (IF(EXISTS(
        SELECT 'Y' as hasil
        FROM master_jd_kerja_kyw
        JOIN transaksi_cuti ON transaksi_cuti.id_karyawan = master_jd_kerja_kyw.id_karyawan
        WHERE (master_jd_kerja_kyw.tanggal_jadwal BETWEEN transaksi_cuti.tanggal_mulai_cuti AND transaksi_cuti.tanggal_akhir_cuti) AND 													  
        transaksi_cuti.status_cuti = 'Y' AND
        transaksi_cuti.id_karyawan = a.id_karyawan AND
        master_jd_kerja_kyw.tanggal_jadwal = a.tanggal_jadwal AND
        transaksi_cuti.status_cuti = 'Y'
    ),
               (
                   SELECT transaksi_cuti.id_cuti
                   FROM master_jd_kerja_kyw
                   JOIN transaksi_cuti ON transaksi_cuti.id_karyawan = master_jd_kerja_kyw.id_karyawan
                   WHERE (master_jd_kerja_kyw.tanggal_jadwal BETWEEN transaksi_cuti.tanggal_mulai_cuti AND transaksi_cuti.tanggal_akhir_cuti) AND 													  
                   transaksi_cuti.status_cuti = 'Y' AND
                   transaksi_cuti.id_karyawan = a.id_karyawan AND
                   master_jd_kerja_kyw.tanggal_jadwal = a.tanggal_jadwal AND
                   transaksi_cuti.status_cuti = 'Y'
               ), 'N'
              )) into cuti
    FROM master_jd_kerja_kyw as a,
         master_karyawan as b,
         master_jam_kerja c,
         master_divisi d
    WHERE a.status = 'Y' AND
          b.id_karyawan = a.id_karyawan AND
          c.id_jam_kerja = a.id_jam_kerja AND
          d.id_divisi = b.id_divisi AND
          IF(id = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = id) AND
          IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '10') AND
          a.tanggal_jadwal = STR_TO_DATE(tgl, '%Y-%m-%d') AND
              IF(b.k_tk = 'Kontrak', 
                 IF(bulan = '1', 
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d'),
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-17'), '%Y-%m-%d')),
                 IF(bulan = '1', 
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun-1, '-', '12', '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d'),
                    a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(tahun, '-', bulan-1, '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(tahun, '-', bulan, '-25'), '%Y-%m-%d')));
  	RETURN cuti;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getTunjanganKeluarga` (`id` VARCHAR(15), `tahun` INT, `bulan` INT) RETURNS VARCHAR(20) CHARSET latin1 BEGIN
  	DECLARE tk VARCHAR(20) DEFAULT '';

    SELECT IFNULL((SELECT IF(EXISTS(
                    SELECT transaksi_penggajian.tunjangan_keluarga as hasil
                    FROM transaksi_penggajian
                    WHERE transaksi_penggajian.id_karyawan = id AND 
                          transaksi_penggajian.tahun_gaji = tahun AND 
           				  transaksi_penggajian.bulan_gaji = bulan AND 
                          transaksi_penggajian.status_gaji = 'Y'
                   ),
                     (SELECT transaksi_penggajian.tunjangan_keluarga as hasil
                      FROM transaksi_penggajian
                      WHERE transaksi_penggajian.id_karyawan = id AND 
                            transaksi_penggajian.tahun_gaji = tahun AND 
           				    transaksi_penggajian.bulan_gaji = bulan AND 
                            transaksi_penggajian.status_gaji = 'Y'),
                      'N')), 'N') into tk;
  	RETURN tk;
END$$

DELIMITER ;

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
  `id_karyawan` varchar(15) NOT NULL,
  `tahun_cuti` int(11) NOT NULL,
  `sisa_cuti_lama` int(11) NOT NULL,
  `sisa_cuti_baru` int(11) NOT NULL,
  `ambil_cuti` int(11) NOT NULL,
  `tanggal_mulai_cuti` date NOT NULL,
  `tanggal_akhir_cuti` date NOT NULL,
  `alasan_cuti` varchar(100) NOT NULL,
  `persetujuan_cuti` char(1) NOT NULL,
  `ambil_tahun_sekarang` char(1) NOT NULL,
  `no_iso` varchar(50) NOT NULL,
  `status_cuti` char(1) NOT NULL,
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
  `nama_divisi` varchar(40) NOT NULL,
  `status_divisi` char(1) NOT NULL,
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
  `nama_jabatan` varchar(40) NOT NULL,
  `status_jabatan` char(1) NOT NULL,
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
  `nama_jam_kerja` varchar(40) NOT NULL,
  `jam_masuk` time NOT NULL,
  `jam_pulang` time NOT NULL,
  `jam_masuk_sabtu` time NOT NULL,
  `jam_pulang_sabtu` time NOT NULL,
  `status_jam_kerja` char(1) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_jd_kerja_kyw`
--

CREATE TABLE `history_jd_kerja_kyw` (
  `id_jadwal` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `id_jam_kerja` int(11) NOT NULL,
  `tanggal_jadwal` date NOT NULL,
  `status` char(1) NOT NULL,
  `reason` varchar(30) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_kalender`
--

CREATE TABLE `history_kalender` (
  `id_kalender` int(11) NOT NULL,
  `nama_hari` varchar(35) NOT NULL,
  `jenis_hari` varchar(25) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_akhir` date NOT NULL,
  `jumlah_hari` int(11) NOT NULL,
  `status_kalender` char(1) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_karyawan`
--

CREATE TABLE `history_karyawan` (
  `id_karyawan` varchar(15) NOT NULL,
  `pin` varchar(15) NOT NULL,
  `id_jabatan` int(11) NOT NULL,
  `id_divisi` int(11) NOT NULL,
  `nama_karyawan` varchar(50) NOT NULL,
  `nik` varchar(16) NOT NULL,
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
  `gaji_pokok` int(11) DEFAULT NULL,
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
  `id_karyawan` varchar(15) NOT NULL,
  `pilih_lembur` varchar(20) NOT NULL,
  `tanggal_lembur` date NOT NULL,
  `jam_mulai` time NOT NULL,
  `jam_akhir` time NOT NULL,
  `ambil_jam` float NOT NULL,
  `uraian_kerja` varchar(80) NOT NULL,
  `persetujuan` char(1) NOT NULL,
  `no_iso` varchar(50) NOT NULL,
  `status_lembur` char(1) NOT NULL,
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
  `id_karyawan` varchar(15) NOT NULL,
  `tahun_gaji` int(11) NOT NULL,
  `bulan_gaji` int(11) NOT NULL,
  `tunjangan_keluarga` int(11) DEFAULT NULL,
  `ongkos_bongkar` int(11) DEFAULT NULL,
  `ongkos_lain_lain` int(11) DEFAULT NULL,
  `reason` varchar(20) NOT NULL,
  `status_gaji` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `history_potong_absen`
--

CREATE TABLE `history_potong_absen` (
  `id_potong_absen` int(11) NOT NULL,
  `id_karyawan` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `tahun` int(11) NOT NULL,
  `bulan` int(11) NOT NULL,
  `total_hari` float NOT NULL,
  `alasan_potong` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `status_potong` char(1) CHARACTER SET utf8mb4 NOT NULL,
  `reason` varchar(20) CHARACTER SET utf8mb4 NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `history_surat_ijin`
--

CREATE TABLE `history_surat_ijin` (
  `id_surat_ijin` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `tanggal_ijin` date NOT NULL,
  `alasan_ijin` varchar(50) NOT NULL,
  `pilih_jam` varchar(20) NOT NULL,
  `jam_datang_keluar_ijin` time NOT NULL,
  `no_iso` varchar(50) NOT NULL,
  `status_ijin` char(1) NOT NULL,
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
  `tahun_umk` int(11) NOT NULL,
  `total_umk` int(11) NOT NULL,
  `gaji_per_jam` int(11) NOT NULL,
  `status_umk` char(1) NOT NULL,
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
  `id_karyawan` varchar(15) NOT NULL,
  `username` varchar(25) NOT NULL,
  `password_user` varchar(255) NOT NULL,
  `role` int(11) NOT NULL,
  `status` char(1) NOT NULL,
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
  `id_karyawan` varchar(15) NOT NULL,
  `tanggal_absensi` date NOT NULL,
  `jam_absensi` time NOT NULL,
  `nama_mesin` varchar(30) NOT NULL,
  `status_absensi` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_absensi`
--

INSERT INTO `master_absensi` (`id_absensi`, `id_karyawan`, `tanggal_absensi`, `jam_absensi`, `nama_mesin`, `status_absensi`, `change_by`, `change_at`) VALUES
('2021010300000001', '2072', '2021-01-03', '06:59:00', 'MESIN  BELAKANG', 'N', 1, '2021-02-18');

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
(10, 'IT', 'Y', 2, '2021-02-11');

-- --------------------------------------------------------

--
-- Table structure for table `master_jabatan`
--

CREATE TABLE `master_jabatan` (
  `id_jabatan` int(5) NOT NULL,
  `nama_jabatan` varchar(40) NOT NULL,
  `status_jabatan` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_jabatan`
--

INSERT INTO `master_jabatan` (`id_jabatan`, `nama_jabatan`, `status_jabatan`, `change_by`, `change_at`) VALUES
(2, 'STAFF', 'Y', 2, '2021-02-11');

-- --------------------------------------------------------

--
-- Table structure for table `master_jam_kerja`
--

CREATE TABLE `master_jam_kerja` (
  `id_jam_kerja` int(11) NOT NULL,
  `nama_jam_kerja` varchar(40) NOT NULL,
  `jam_masuk` time NOT NULL,
  `jam_pulang` time NOT NULL,
  `jam_masuk_sabtu` time NOT NULL,
  `jam_pulang_sabtu` time NOT NULL,
  `status_jam_kerja` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_jam_kerja`
--

INSERT INTO `master_jam_kerja` (`id_jam_kerja`, `nama_jam_kerja`, `jam_masuk`, `jam_pulang`, `jam_masuk_sabtu`, `jam_pulang_sabtu`, `status_jam_kerja`, `change_by`, `change_at`) VALUES
(1, 'PAGI', '07:00:00', '15:00:00', '07:00:00', '12:00:00', 'Y', 2, '2021-02-17'),
(2, 'PAGI 2', '07:30:00', '15:30:00', '07:30:00', '12:30:00', 'Y', 2, '2021-02-17'),
(3, 'PAGI 3', '08:00:00', '16:00:00', '08:00:00', '13:00:00', 'Y', 2, '2021-02-17'),
(4, 'SORE', '15:00:00', '23:00:00', '12:00:00', '17:00:00', 'Y', 1, '2021-03-25'),
(5, 'MALAM', '23:00:00', '07:00:00', '17:00:00', '22:00:00', 'Y', 2, '2021-02-17');

-- --------------------------------------------------------

--
-- Table structure for table `master_jd_kerja_kyw`
--

CREATE TABLE `master_jd_kerja_kyw` (
  `id_jadwal` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `id_jam_kerja` int(11) NOT NULL,
  `tanggal_jadwal` date NOT NULL,
  `status` char(1) NOT NULL,
  `change_at` date NOT NULL,
  `change_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_jd_kerja_kyw`
--

INSERT INTO `master_jd_kerja_kyw` (`id_jadwal`, `id_karyawan`, `id_jam_kerja`, `tanggal_jadwal`, `status`, `change_at`, `change_by`) VALUES
(1, '2072', 4, '2021-01-26', 'N', '2021-03-25', 1);

-- --------------------------------------------------------

--
-- Table structure for table `master_kalender`
--

CREATE TABLE `master_kalender` (
  `id_kalender` int(11) NOT NULL,
  `nama_hari` varchar(35) NOT NULL,
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
  `auto_id` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `pin` varchar(15) NOT NULL,
  `id_jabatan` int(11) NOT NULL,
  `id_divisi` int(11) NOT NULL,
  `nama_karyawan` varchar(50) NOT NULL,
  `nik` varchar(16) NOT NULL,
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
  `gaji_pokok` int(11) DEFAULT NULL,
  `tunjangan_jabatan` int(11) NOT NULL,
  `bpjs_kesehatan` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_karyawan`
--

INSERT INTO `master_karyawan` (`auto_id`, `id_karyawan`, `pin`, `id_jabatan`, `id_divisi`, `nama_karyawan`, `nik`, `no_ktp`, `npwp`, `jenis_kelamin_karyawan`, `tanggal_masuk_karyawan`, `tanggal_keluar_karyawan`, `status_karyawan`, `telp_karyawan`, `tempat_lahir_karyawan`, `tanggal_lahir_karyawan`, `alamat_karyawan`, `tanggal_pengangkatan`, `keterangan`, `k_tk`, `pendidikan`, `pkwt1`, `pkwt2`, `gaji_pokok`, `tunjangan_jabatan`, `bpjs_kesehatan`, `change_by`, `change_at`) VALUES
(2072, '2072', '2072', 2, 10, 'AFIF NUZIA AL ASADI', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', 5000000, 100000, 'N', 1, '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `master_lembur`
--

CREATE TABLE `master_lembur` (
  `id_lembur` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `pilih_lembur` varchar(20) NOT NULL,
  `tanggal_lembur` date NOT NULL,
  `jam_mulai` time NOT NULL,
  `jam_akhir` time NOT NULL,
  `ambil_jam` float NOT NULL,
  `uraian_kerja` varchar(80) NOT NULL,
  `persetujuan` char(1) NOT NULL,
  `change_at` datetime NOT NULL,
  `no_iso` varchar(50) NOT NULL,
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
  `gaji_per_jam` int(11) NOT NULL,
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
  `id_karyawan` varchar(15) NOT NULL,
  `tahun_cuti` int(11) NOT NULL,
  `sisa_cuti_lama` int(11) NOT NULL,
  `sisa_cuti_baru` int(11) NOT NULL,
  `ambil_cuti` int(11) NOT NULL,
  `tanggal_mulai_cuti` date NOT NULL,
  `tanggal_akhir_cuti` date NOT NULL,
  `alasan_cuti` varchar(100) NOT NULL,
  `persetujuan_cuti` char(1) NOT NULL,
  `ambil_tahun_sekarang` char(1) NOT NULL,
  `no_iso` varchar(50) NOT NULL,
  `status_cuti` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaksi_cuti`
--

INSERT INTO `transaksi_cuti` (`id_cuti`, `id_karyawan`, `tahun_cuti`, `sisa_cuti_lama`, `sisa_cuti_baru`, `ambil_cuti`, `tanggal_mulai_cuti`, `tanggal_akhir_cuti`, `alasan_cuti`, `persetujuan_cuti`, `ambil_tahun_sekarang`, `no_iso`, `status_cuti`, `change_by`, `change_at`) VALUES
(1, '2072', 2021, 0, 0, 2, '2021-02-24', '2021-02-25', 'Alasan', 'N', 'N', 'Form / HRD / 017-Rev00', 'N', 1, '2021-03-15');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_penggajian`
--

CREATE TABLE `transaksi_penggajian` (
  `id_gaji` varchar(16) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `tahun_gaji` int(11) NOT NULL,
  `bulan_gaji` int(11) NOT NULL,
  `tunjangan_keluarga` int(11) DEFAULT NULL,
  `ongkos_bongkar` int(11) DEFAULT NULL,
  `ongkos_lain_lain` int(11) DEFAULT NULL,
  `status_gaji` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaksi_penggajian`
--

INSERT INTO `transaksi_penggajian` (`id_gaji`, `id_karyawan`, `tahun_gaji`, `bulan_gaji`, `tunjangan_keluarga`, `ongkos_bongkar`, `ongkos_lain_lain`, `status_gaji`, `change_by`, `change_at`) VALUES
('1', '2072', 2021, 1, 100000, NULL, NULL, 'N', 1, '2021-03-19');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_potong_absen`
--

CREATE TABLE `transaksi_potong_absen` (
  `id_potong_absen` int(11) NOT NULL,
  `id_karyawan` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `tahun` int(11) NOT NULL,
  `bulan` int(11) NOT NULL,
  `total_hari` float NOT NULL,
  `alasan_potong` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `status_potong` char(1) CHARACTER SET utf8mb4 NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_surat_ijin`
--

CREATE TABLE `transaksi_surat_ijin` (
  `id_surat_ijin` int(11) NOT NULL,
  `id_karyawan` varchar(15) NOT NULL,
  `tanggal_ijin` date NOT NULL,
  `alasan_ijin` varchar(50) NOT NULL,
  `pilih_jam` varchar(20) NOT NULL,
  `jam_datang_keluar_ijin` time NOT NULL,
  `no_iso` varchar(50) NOT NULL,
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
  `role` int(11) NOT NULL,
  `status` char(1) NOT NULL,
  `change_at` date NOT NULL,
  `change_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_login`
--

INSERT INTO `user_login` (`id_user`, `id_karyawan`, `username`, `password_user`, `role`, `status`, `change_at`, `change_by`) VALUES
(1, '2072', 'admin', '21232f297a57a5a743894a0e4a801fc3', 2, 'Y', '2021-03-16', 1);

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
-- Indexes for table `master_jd_kerja_kyw`
--
ALTER TABLE `master_jd_kerja_kyw`
  ADD PRIMARY KEY (`id_jadwal`);

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
  ADD KEY `id_divisi` (`id_divisi`);

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
-- Indexes for table `transaksi_penggajian`
--
ALTER TABLE `transaksi_penggajian`
  ADD PRIMARY KEY (`id_gaji`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `transaksi_potong_absen`
--
ALTER TABLE `transaksi_potong_absen`
  ADD PRIMARY KEY (`id_potong_absen`),
  ADD KEY `id_karyawan` (`id_karyawan`);

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
  MODIFY `id_divisi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `master_jabatan`
--
ALTER TABLE `master_jabatan`
  MODIFY `id_jabatan` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `master_jam_kerja`
--
ALTER TABLE `master_jam_kerja`
  MODIFY `id_jam_kerja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

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
  MODIFY `id_cuti` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  ADD CONSTRAINT `master_karyawan_ibfk_2` FOREIGN KEY (`id_divisi`) REFERENCES `master_divisi` (`id_divisi`);

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
-- Constraints for table `transaksi_potong_absen`
--
ALTER TABLE `transaksi_potong_absen`
  ADD CONSTRAINT `transaksi_potong_absen_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `master_karyawan` (`id_karyawan`);

--
-- Constraints for table `transaksi_surat_ijin`
--
ALTER TABLE `transaksi_surat_ijin`
  ADD CONSTRAINT `transaksi_surat_ijin_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `master_karyawan` (`id_karyawan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
