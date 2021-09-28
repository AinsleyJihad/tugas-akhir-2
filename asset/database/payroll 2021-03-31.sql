-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2021 at 04:32 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.11

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

--
-- Dumping data for table `history_cuti`
--

INSERT INTO `history_cuti` (`id_cuti`, `id_karyawan`, `tahun_cuti`, `sisa_cuti_lama`, `sisa_cuti_baru`, `ambil_cuti`, `tanggal_mulai_cuti`, `tanggal_akhir_cuti`, `alasan_cuti`, `persetujuan_cuti`, `ambil_tahun_sekarang`, `no_iso`, `status_cuti`, `reason`, `change_by`, `change_at`) VALUES
(7, '2029', 2021, 0, 0, 2, '2021-03-02', '2021-03-03', 'Keperluan', 'Y', 'N', '', 'Y', 'Create', 1, '2021-03-02'),
(8, '4649', 2021, 0, 0, 2, '2021-03-02', '2021-03-03', 'coba', 'Y', 'N', '', 'Y', 'Create', 1, '2021-03-02'),
(1, '4649', 2021, 0, 0, 2, '2021-02-24', '2021-02-25', 'Alasan', 'Y', 'N', '', 'Y', 'Edit', 1, '2021-03-02'),
(0, '', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-03'),
(0, '', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-03'),
(0, '', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-03'),
(0, '', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-03'),
(8, '4649', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-03'),
(8, '', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-03'),
(7, '2029', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-03'),
(9, '2075', 2021, 0, 0, 2, '2021-03-16', '2021-03-17', 'cuti', 'Y', 'N', 'Form/HRD/017-Rev.00', 'Y', 'Create', 1, '2021-03-15'),
(1, '4649', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-15'),
(1, '', 0, 0, 0, 0, '0000-00-00', '0000-00-00', '-', '-', '-', '', 'N', 'Hapus', 1, '2021-03-15');

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

--
-- Dumping data for table `history_divisi`
--

INSERT INTO `history_divisi` (`id_divisi`, `nama_divisi`, `status_divisi`, `reason`, `change_by`, `change_at`) VALUES
(25, 'A&T', 'Y', 'Create', 1, '2021-03-02');

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

--
-- Dumping data for table `history_jabatan`
--

INSERT INTO `history_jabatan` (`id_jabatan`, `nama_jabatan`, `status_jabatan`, `reason`, `change_by`, `change_at`) VALUES
(6, '-', 'N', 'Hapus', 1, '2021-03-02'),
(7, 'jabatan a', 'Y', 'Create', 1, '2021-03-04'),
(8, 'Manager', 'Y', 'Create', 1, '2021-03-08'),
(8, '-', 'N', 'Hapus', 1, '2021-03-08'),
(9, 'asdsadsda', 'Y', 'Create', 1, '2021-03-08'),
(10, '11asada', 'Y', 'Create', 1, '2021-03-08'),
(10, '-', 'N', 'Hapus', 1, '2021-03-08'),
(9, '-', 'N', 'Hapus', 1, '2021-03-08'),
(11, 'baruaaaa', 'Y', 'Create', 1, '2021-03-29'),
(11, 'baruaaaaf', 'Y', 'Edit', 1, '2021-03-29'),
(11, '-', 'N', 'Hapus', 1, '2021-03-29');

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

--
-- Dumping data for table `history_jam_kerja`
--

INSERT INTO `history_jam_kerja` (`id_jam_kerja`, `nama_jam_kerja`, `jam_masuk`, `jam_pulang`, `jam_masuk_sabtu`, `jam_pulang_sabtu`, `status_jam_kerja`, `reason`, `change_by`, `change_at`) VALUES
(7, '-', '00:00:00', '00:00:00', '00:00:00', '00:00:00', 'N', 'Hapus', 1, '2021-03-02'),
(4, 'Pagi 3', '08:00:00', '16:00:00', '08:00:00', '12:00:00', 'Y', 'Edit', 1, '2021-03-25');

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

--
-- Dumping data for table `history_jd_kerja_kyw`
--

INSERT INTO `history_jd_kerja_kyw` (`id_jadwal`, `id_karyawan`, `id_jam_kerja`, `tanggal_jadwal`, `status`, `reason`, `change_by`, `change_at`) VALUES
(49, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-17'),
(50, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-17'),
(51, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-17'),
(52, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-17'),
(53, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-17'),
(54, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-17'),
(55, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-17'),
(1, '', 0, '0000-00-00', '', 'Edit', 2, '2021-02-17'),
(1, '', 0, '0000-00-00', '', 'Edit', 2, '2021-02-17'),
(1, '', 0, '0000-00-00', '', 'Edit', 2, '2021-02-17'),
(1, '', 0, '0000-00-00', '', 'Edit', 2, '2021-02-17'),
(1, '', 0, '0000-00-00', '', 'Edit', 2, '2021-02-17'),
(1, '', 0, '0000-00-00', '', 'Edit', 2, '2021-02-17'),
(1, '', 0, '0000-00-00', '', 'Edit', 2, '2021-02-18'),
(1210, '', 0, '0000-00-00', '', 'Edit', 2, '2021-02-18'),
(1211, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-22'),
(1212, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-22'),
(1211, '', 0, '0000-00-00', '', 'Hapus', 2, '2021-02-22'),
(1212, '', 0, '0000-00-00', '', 'Hapus', 2, '2021-02-22'),
(5, '', 0, '0000-00-00', '', 'Hapus', 2, '2021-02-22'),
(5, '', 0, '0000-00-00', '', 'Hapus', 2, '2021-02-22'),
(5, '', 0, '0000-00-00', '', 'Hapus', 2, '2021-02-22'),
(1213, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-24'),
(1214, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-24'),
(1215, '', 0, '0000-00-00', '', 'Create', 2, '2021-02-24'),
(1216, '', 0, '0000-00-00', '', 'Create', 1, '2021-03-02'),
(1217, '', 0, '0000-00-00', '', 'Create', 1, '2021-03-02'),
(1218, '', 0, '0000-00-00', '', 'Create', 1, '2021-03-02'),
(1219, '', 0, '0000-00-00', '', 'Create', 1, '2021-03-02'),
(1220, '2029', 1, '2021-03-03', 'Y', 'Create', 1, '2021-03-02'),
(1221, '2029', 1, '2021-03-04', 'Y', 'Create', 1, '2021-03-02'),
(1221, '2029', 2, '2021-03-04', 'Y', 'Edit', 1, '2021-03-02'),
(1221, '-', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1222, '2031', 1, '2021-03-02', 'Y', 'Create', 1, '2021-03-02'),
(1222, '', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1222, '', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1220, '', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1219, '', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1218, '', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1218, '', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1218, '', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1217, '4649', 0, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1223, '4648', 7, '2021-03-02', 'Y', 'Create', 1, '2021-03-02'),
(1223, '4648', 7, '0000-00-00', 'N', 'Hapus', 1, '2021-03-02'),
(1224, '4654', 1, '2021-03-03', 'Y', 'Create', 1, '2021-03-03'),
(1225, '2072', 4, '2021-01-01', 'Y', 'Create', 1, '2021-03-05'),
(1226, '2072', 4, '2021-01-02', 'Y', 'Create', 1, '2021-03-05'),
(1227, '2072', 4, '2021-01-04', 'Y', 'Create', 1, '2021-03-05'),
(1228, '2072', 4, '2021-01-05', 'Y', 'Create', 1, '2021-03-05'),
(1229, '2072', 4, '2021-01-06', 'Y', 'Create', 1, '2021-03-05'),
(1230, '2072', 4, '2021-01-07', 'Y', 'Create', 1, '2021-03-05'),
(1231, '2072', 4, '2021-01-08', 'Y', 'Create', 1, '2021-03-05'),
(1232, '2072', 4, '2021-01-09', 'Y', 'Create', 1, '2021-03-05'),
(1233, '2072', 4, '2021-01-11', 'Y', 'Create', 1, '2021-03-05'),
(1234, '2072', 4, '2021-01-12', 'Y', 'Create', 1, '2021-03-05'),
(1235, '2072', 4, '2021-01-13', 'Y', 'Create', 1, '2021-03-05'),
(1236, '2072', 4, '2021-01-14', 'Y', 'Create', 1, '2021-03-05'),
(1237, '2072', 4, '2021-01-15', 'Y', 'Create', 1, '2021-03-05'),
(1238, '2072', 4, '2021-01-16', 'Y', 'Create', 1, '2021-03-05'),
(1239, '2072', 4, '2021-01-18', 'Y', 'Create', 1, '2021-03-05'),
(1240, '2072', 4, '2021-01-19', 'Y', 'Create', 1, '2021-03-05'),
(1241, '2072', 4, '2021-01-20', 'Y', 'Create', 1, '2021-03-05'),
(1242, '2072', 4, '2021-01-21', 'Y', 'Create', 1, '2021-03-05'),
(1243, '2072', 4, '2021-01-22', 'Y', 'Create', 1, '2021-03-05'),
(1244, '2072', 4, '2021-01-23', 'Y', 'Create', 1, '2021-03-05'),
(1245, '2072', 4, '2021-01-25', 'Y', 'Create', 1, '2021-03-05'),
(1246, '2072', 4, '2021-01-26', 'Y', 'Create', 1, '2021-03-05'),
(1247, '2072', 4, '2021-01-27', 'Y', 'Create', 1, '2021-03-05'),
(1248, '2072', 4, '2021-01-28', 'Y', 'Create', 1, '2021-03-05'),
(1249, '2072', 4, '2021-01-29', 'Y', 'Create', 1, '2021-03-05'),
(1250, '2072', 4, '2021-01-30', 'Y', 'Create', 1, '2021-03-05'),
(1251, '2072', 4, '2021-02-01', 'Y', 'Create', 1, '2021-03-05'),
(1252, '2072', 4, '2021-02-02', 'Y', 'Create', 1, '2021-03-05'),
(1253, '2072', 4, '2021-02-03', 'Y', 'Create', 1, '2021-03-05'),
(1254, '2072', 4, '2021-02-04', 'Y', 'Create', 1, '2021-03-05'),
(1255, '2072', 4, '2021-02-05', 'Y', 'Create', 1, '2021-03-05'),
(1256, '2072', 4, '2021-02-06', 'Y', 'Create', 1, '2021-03-05'),
(1257, '2072', 4, '2021-02-08', 'Y', 'Create', 1, '2021-03-05'),
(1258, '2072', 4, '2021-02-09', 'Y', 'Create', 1, '2021-03-05'),
(1259, '2072', 4, '2021-02-10', 'Y', 'Create', 1, '2021-03-05'),
(1260, '2072', 4, '2021-02-11', 'Y', 'Create', 1, '2021-03-05'),
(1261, '2072', 4, '2021-02-12', 'Y', 'Create', 1, '2021-03-05'),
(1262, '2072', 4, '2021-02-13', 'Y', 'Create', 1, '2021-03-05'),
(1263, '2072', 4, '2021-02-15', 'Y', 'Create', 1, '2021-03-05'),
(1264, '2072', 4, '2021-02-16', 'Y', 'Create', 1, '2021-03-05'),
(1265, '2072', 4, '2021-02-17', 'Y', 'Create', 1, '2021-03-05'),
(1266, '2072', 4, '2021-02-18', 'Y', 'Create', 1, '2021-03-05'),
(1267, '2072', 4, '2021-02-19', 'Y', 'Create', 1, '2021-03-05'),
(1268, '2072', 4, '2021-02-20', 'Y', 'Create', 1, '2021-03-05'),
(1269, '2072', 4, '2021-02-22', 'Y', 'Create', 1, '2021-03-05'),
(1270, '2072', 4, '2021-02-23', 'Y', 'Create', 1, '2021-03-05'),
(1271, '2072', 4, '2021-02-24', 'Y', 'Create', 1, '2021-03-05'),
(1272, '2072', 4, '2021-02-25', 'Y', 'Create', 1, '2021-03-05'),
(1273, '2072', 4, '2021-02-26', 'Y', 'Create', 1, '2021-03-05'),
(1274, '2072', 4, '2021-02-27', 'Y', 'Create', 1, '2021-03-05'),
(1275, '2072', 4, '2021-02-27', 'Y', 'Create', 1, '2021-03-08'),
(1276, '2072', 1, '2021-02-27', 'Y', 'Create', 1, '2021-03-08'),
(1276, '2072', 1, '0000-00-00', 'N', 'Hapus', 1, '2021-03-08'),
(1275, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-08'),
(24, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(69, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(127, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(180, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(209, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(277, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(320, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(370, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(418, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(471, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(518, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(614, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(649, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(713, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(748, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(791, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(855, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(898, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(949, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(997, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(1045, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(1091, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(1131, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(1196, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(1254, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(1225, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(1226, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-18'),
(567, '2072', 4, '0000-00-00', 'N', 'Hapus', 1, '2021-03-22'),
(1, '2072', 4, '2021-01-26', 'Y', 'Create', 1, '2021-03-25'),
(2, '2072', 4, '2021-01-27', 'Y', 'Create', 1, '2021-03-25'),
(3, '2072', 4, '2021-01-28', 'Y', 'Create', 1, '2021-03-25'),
(4, '2072', 4, '2021-01-29', 'Y', 'Create', 1, '2021-03-25'),
(5, '2072', 4, '2021-01-30', 'Y', 'Create', 1, '2021-03-25'),
(6, '2072', 4, '2021-02-01', 'Y', 'Create', 1, '2021-03-25'),
(7, '2072', 4, '2021-02-02', 'Y', 'Create', 1, '2021-03-25'),
(8, '2072', 4, '2021-02-03', 'Y', 'Create', 1, '2021-03-25'),
(9, '2072', 4, '2021-02-04', 'Y', 'Create', 1, '2021-03-25'),
(10, '2072', 4, '2021-02-05', 'Y', 'Create', 1, '2021-03-25'),
(11, '2072', 4, '2021-02-06', 'Y', 'Create', 1, '2021-03-25'),
(12, '2072', 4, '2021-02-08', 'Y', 'Create', 1, '2021-03-25'),
(13, '2072', 4, '2021-02-09', 'Y', 'Create', 1, '2021-03-25'),
(14, '2072', 4, '2021-02-10', 'Y', 'Create', 1, '2021-03-25'),
(15, '2072', 4, '2021-02-11', 'Y', 'Create', 1, '2021-03-25'),
(16, '2072', 4, '2021-02-12', 'Y', 'Create', 1, '2021-03-25'),
(17, '2072', 4, '2021-02-13', 'Y', 'Create', 1, '2021-03-25'),
(18, '2072', 4, '2021-02-15', 'Y', 'Create', 1, '2021-03-25'),
(19, '2072', 4, '2021-02-16', 'Y', 'Create', 1, '2021-03-25'),
(20, '2072', 4, '2021-02-17', 'Y', 'Create', 1, '2021-03-25'),
(21, '2072', 4, '2021-02-18', 'Y', 'Create', 1, '2021-03-25'),
(22, '2072', 4, '2021-02-19', 'Y', 'Create', 1, '2021-03-25'),
(23, '2072', 4, '2021-02-20', 'Y', 'Create', 1, '2021-03-25'),
(24, '2072', 4, '2021-02-22', 'Y', 'Create', 1, '2021-03-25'),
(25, '2072', 4, '2021-02-23', 'Y', 'Create', 1, '2021-03-25'),
(26, '2072', 4, '2021-02-24', 'Y', 'Create', 1, '2021-03-25'),
(27, '2072', 4, '2021-02-25', 'Y', 'Create', 1, '2021-03-25');

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

--
-- Dumping data for table `history_kalender`
--

INSERT INTO `history_kalender` (`id_kalender`, `nama_hari`, `jenis_hari`, `tanggal_mulai`, `tanggal_akhir`, `jumlah_hari`, `status_kalender`, `reason`, `change_by`, `change_at`) VALUES
(10, 'Cuti Bersama 5', 'Hari Libur', '2021-03-02', '2021-03-06', 5, 'Y', 'Create', 1, '2021-03-02'),
(10, 'Cuti Bersama 6', 'Hari Libur', '2021-03-02', '2021-03-06', 5, 'Y', 'Edit', 1, '2021-03-02'),
(10, '-', '-', '0000-00-00', '0000-00-00', 0, 'N', 'Hapus', 1, '2021-03-02'),
(11, 'Libur', 'Hari Libur', '2021-02-08', '2021-02-13', 6, 'Y', 'Create', 1, '2021-03-08'),
(12, 'Libur', 'Hari Libur', '2021-01-11', '2021-01-16', 6, 'Y', 'Create', 1, '2021-03-08'),
(12, '-', '-', '0000-00-00', '0000-00-00', 0, 'N', 'Hapus', 1, '2021-03-25'),
(7, '-', '-', '0000-00-00', '0000-00-00', 0, 'N', 'Hapus', 1, '2021-03-25'),
(9, '-', '-', '0000-00-00', '0000-00-00', 0, 'N', 'Hapus', 1, '2021-03-25'),
(11, '-', '-', '0000-00-00', '0000-00-00', 0, 'N', 'Hapus', 1, '2021-03-25'),
(6, 'Imlek', 'Hari Libur', '2021-02-12', '2021-02-13', 2, 'Y', 'Edit', 1, '2021-03-25'),
(6, 'Imlek', 'Hari Libur', '2021-02-12', '2021-02-12', 1, 'Y', 'Edit', 1, '2021-03-25'),
(6, 'Imlek', 'Hari Libur', '2021-02-12', '2021-02-13', 2, 'Y', 'Edit', 1, '2021-03-25');

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
  `nik` varchar(16) DEFAULT NULL,
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
  `plant` varchar(25) NOT NULL,
  `ikut_penggajian` char(1) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_karyawan`
--

INSERT INTO `history_karyawan` (`id_karyawan`, `pin`, `id_jabatan`, `id_divisi`, `nama_karyawan`, `nik`, `no_ktp`, `npwp`, `jenis_kelamin_karyawan`, `tanggal_masuk_karyawan`, `tanggal_keluar_karyawan`, `status_karyawan`, `telp_karyawan`, `tempat_lahir_karyawan`, `tanggal_lahir_karyawan`, `alamat_karyawan`, `tanggal_pengangkatan`, `keterangan`, `k_tk`, `pendidikan`, `pkwt1`, `pkwt2`, `gaji_pokok`, `tunjangan_jabatan`, `bpjs_kesehatan`, `plant`, `ikut_penggajian`, `reason`, `change_by`, `change_at`) VALUES
('4653', '2987', 1, 1, 'Rifki Maulana', '1234567891234560', '1234567891234560', '', 'L', '2021-03-02', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', NULL, 0, '', 'Krian', 'Y', 'Create', 1, '2021-03-02'),
('4654', '9876', 1, 1, 'Rifki Maulana', '1234567891234560', '1234567891234560', '', 'L', '2021-03-02', '0000-00-00', 'Y', '08888888888880', 'Surabaya', '2000-07-01', 'Surabaya', '0000-00-00', 'Karyawan', 'Kontrak', 'Mahasiswa', '', '', NULL, 0, '', 'Krian', 'Y', 'Create', 1, '2021-03-02'),
('4653', '-', 1, 1, '-', '-', '-', '-', '-', '0000-00-00', '0000-00-00', 'N', '-', '-', '0000-00-00', '-', '0000-00-00', '-', '-', '-', '-', '-', NULL, 0, '', 'Krian', 'Y', 'Hapus', 1, '2021-03-02'),
('4654', '9876', 1, 1, 'Rifki Maulana', '1234567891234560', '1234567891234560', '', 'L', '2021-03-02', '0000-00-00', 'Y', '08888888888880', 'Surabaya', '2000-07-01', 'Surabaya', '2021-03-03', 'Karyawan', 'Kontrak', 'Mahasiswa', '', '', NULL, 0, '', 'Krian', 'Y', 'Edit', 1, '2021-03-02'),
('4654', '9876', 7, 1, 'Rifki Maulana', '1234567891234560', '1234567891234560', '', 'L', '2021-03-02', '0000-00-00', 'Y', '08888888888880', 'Surabaya', '2000-07-01', 'Surabaya', '2021-03-03', 'Karyawan', 'Kontrak', 'Mahasiswa', '', '', NULL, 0, '', 'Krian', 'Y', 'Edit', 1, '2021-03-04'),
('4654', '9876', 7, 1, 'Rifki Maulana', '1234567891234560', '1234567891234560', '', 'L', '2021-03-02', '0000-00-00', 'Y', '08888888888880', 'Surabaya', '2000-07-01', 'Surabaya', '2021-03-03', 'Karyawan', 'Tidak Kontrak', 'Mahasiswa', '', '', NULL, 0, '', 'Krian', 'Y', 'Edit', 1, '2021-03-10'),
('4655', '123445', 1, 3, 'antonius vespucchi', '12341231', '1234567891234567', '', 'L', '2021-03-24', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', NULL, 0, '', 'Krian', 'Y', 'Create', 1, '2021-03-24'),
('4655', '123445', 1, 3, 'antonius vespucchi', '12341231', '1234567891234567', '', 'L', '2021-03-24', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', 5000000, 0, '', 'Krian', 'Y', 'Edit', 1, '2021-03-24');

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

--
-- Dumping data for table `history_lembur`
--

INSERT INTO `history_lembur` (`id_lembur`, `id_karyawan`, `pilih_lembur`, `tanggal_lembur`, `jam_mulai`, `jam_akhir`, `ambil_jam`, `uraian_kerja`, `persetujuan`, `no_iso`, `status_lembur`, `reason`, `change_by`, `change_at`) VALUES
(4, '2017', '', '2021-03-02', '11:55:00', '23:55:00', 0, 'Lembur 2', 'Y', '', 'Y', 'Create', 1, '2021-03-02'),
(5, '4654', '', '2021-03-04', '16:00:00', '20:00:00', 3.5, 'aaaa', 'Y', '', 'Y', 'Create', 1, '2021-03-04'),
(4, '2017', '', '2021-03-02', '04:00:00', '19:00:00', 14.5, 'Lembur 2', 'Y', '', 'Y', 'Edit', 1, '2021-03-05'),
(4, '2017', '', '2021-03-02', '16:00:00', '19:00:00', 3, 'Lembur 2', 'Y', '', 'Y', 'Edit', 1, '2021-03-05'),
(1, '2007', '', '2021-02-25', '16:00:00', '23:00:00', 6.5, 'Menambahkan edit ...', 'Y', '', 'Y', 'Edit', 1, '2021-03-05'),
(6, '4654', '', '2021-03-10', '16:00:00', '07:00:00', -9, 'kkkk', 'Y', '', 'Y', 'Create', 1, '2021-03-05'),
(6, '4654', '', '2021-03-10', '16:00:00', '19:00:00', 3, 'kkkk', 'Y', '', 'Y', 'Edit', 1, '2021-03-05'),
(1, '2007', '', '2021-02-26', '16:00:00', '23:00:00', 6.5, 'Menambahkan edit ...', 'Y', '', 'Y', 'Edit', 1, '2021-03-05'),
(7, '4654', '', '2021-03-16', '07:00:00', '19:00:00', 11.5, 'Lembur', 'Y', 'Form/HRD/013Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(8, '2001', 'Lembur Biasa', '2021-03-15', '07:00:00', '19:00:00', 11.5, 'Lembur 2', 'Y', 'Form/HRD/013Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(8, '2001', 'Lembur Libur', '2021-03-15', '07:00:00', '19:00:00', 11.5, 'Lembur 2', 'Y', 'Form/HRD/013Rev.01', 'Y', 'Edit', 1, '2021-03-15'),
(8, '2001', '-', '0000-00-00', '00:00:00', '00:00:00', 0, '-', '-', 'Form/HRD/013Rev.01', 'N', 'Hapus', 1, '2021-03-15'),
(9, '2074', 'Lembur Libur', '2021-03-16', '08:00:00', '21:00:00', 12, 'Lembur 2', 'Y', 'Form/HRD/013Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(10, '4654', 'Lembur Libur', '2021-03-16', '08:00:00', '12:00:00', 4, 'aaa', 'Y', 'Form/HRD/013Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(9, '2074', 'Lembur Libur', '2021-03-16', '08:00:00', '20:00:00', 11, 'Lembur 2', 'Y', 'Form/HRD/013Rev.01', 'Y', 'Edit', 1, '2021-03-15'),
(10, '4654', 'Lembur Libur', '2021-03-16', '08:00:00', '15:00:00', 7, 'aaa', 'Y', 'Form/HRD/013Rev.01', 'Y', 'Edit', 1, '2021-03-15'),
(11, '2025', 'Lembur Biasa', '2021-03-01', '07:00:00', '20:00:00', 12.5, 'alas', 'Y', 'Form/HRD/013Rev.01', 'Y', 'Create', 1, '2021-03-15');

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

--
-- Dumping data for table `history_penggajian`
--

INSERT INTO `history_penggajian` (`id_gaji`, `id_karyawan`, `tahun_gaji`, `bulan_gaji`, `tunjangan_keluarga`, `ongkos_bongkar`, `ongkos_lain_lain`, `reason`, `status_gaji`, `change_by`, `change_at`) VALUES
('4', '2001', 2021, 1, 20000, NULL, NULL, 'Y', 'I', 1, '2021-03-23'),
('5', '2003', 2021, 1, 0, NULL, NULL, 'Input', 'Y', 1, '2021-03-23'),
('3', '2017', 2021, 1, 0, NULL, NULL, 'Input', 'Y', 1, '2021-03-23'),
('5', '2004', 2021, 1, NULL, 0, NULL, 'Input Ongkos Bongkar', 'Y', 1, '2021-03-23'),
('6', '2004', 0, 0, NULL, NULL, 12000, 'Input Ongkos Lain', 'Y', 1, '2021-03-23'),
('7', '2003', 0, 0, NULL, NULL, 0, 'Input Ongkos Lain', 'Y', 1, '2021-03-23'),
('8', '2003', 0, 0, NULL, NULL, 123, 'Input Ongkos Lain', 'Y', 1, '2021-03-23'),
('6', '2004', 2021, 1, NULL, NULL, 100000, 'Input Ongkos Lain', 'Y', 1, '2021-03-23'),
('8', '2006', 2021, 1, NULL, NULL, 1000000, 'Input Ongkos Lain', 'Y', 1, '2021-03-23'),
('9', '2006', 2021, 1, NULL, NULL, 1000000, 'Input Ongkos Lain', 'Y', 1, '2021-03-23');

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

--
-- Dumping data for table `history_potong_absen`
--

INSERT INTO `history_potong_absen` (`id_potong_absen`, `id_karyawan`, `tahun`, `bulan`, `total_hari`, `alasan_potong`, `status_potong`, `reason`, `change_by`, `change_at`) VALUES
(14, '2003', 2021, 2, 20.5, 'alasan', 'Y', 'Create', 1, '2021-03-15'),
(15, '2074', 2021, 5, 18.5, 'alasan', 'Y', 'Create', 1, '2021-03-16'),
(15, '2074', 0, 0, 0, '-', 'N', 'Hapus', 1, '2021-03-16'),
(14, '2003', 2021, 3, 20.5, 'alasan', '', 'Edit', 1, '2021-03-16'),
(14, '2003', 2020, 3, 20.5, 'alasan', 'Y', 'Edit', 1, '2021-03-16'),
(14, '2003', 2020, 4, 20.5, 'alasan', 'Y', 'Edit', 1, '2021-03-16'),
(14, '2003', 0, 0, 0, '-', 'N', 'Hapus', 1, '2021-03-16'),
(16, '2070', 2021, 5, 26.5, 'alasan', 'Y', 'Create', 1, '2021-03-16'),
(1, '2017', 2021, 2, 2, 'alasan', 'Y', 'Create', 1, '2021-03-16'),
(2, '2019', 2020, 3, 5, 'alasan', 'Y', 'Create', 1, '2021-03-16'),
(3, '2001', 2021, 1, 2, 'Alasan 11', 'Y', 'Create', 1, '2021-03-17'),
(3, '2003', 2021, 1, 2, 'Alasan 11', 'Y', 'Edit', 1, '2021-03-29');

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
  `persetujuan_kabag` char(1) NOT NULL,
  `persetujuan_hrd` char(1) NOT NULL,
  `no_iso` varchar(50) NOT NULL,
  `status_ijin` char(1) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_surat_ijin`
--

INSERT INTO `history_surat_ijin` (`id_surat_ijin`, `id_karyawan`, `tanggal_ijin`, `alasan_ijin`, `pilih_jam`, `jam_datang_keluar_ijin`, `persetujuan_kabag`, `persetujuan_hrd`, `no_iso`, `status_ijin`, `reason`, `change_by`, `change_at`) VALUES
(8, '2026', '2021-03-02', 'Keperluan...', '', '11:54:00', 'N', 'N', '', 'Y', 'Create', 1, '2021-03-02'),
(8, '2026', '0000-00-00', '-', '', '00:00:00', 'N', 'N', '', 'N', 'Hapus', 1, '2021-03-03'),
(9, '4654', '2021-03-16', 'Alasan', '', '07:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(10, '2073', '2021-03-16', 'alasan', '', '07:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(10, '2073', '0000-00-00', '-', '', '00:00:00', 'N', 'N', '', 'N', 'Hapus', 1, '2021-03-15'),
(9, '4654', '2021-03-16', 'Alasan', '', '08:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Edit', 1, '2021-03-15'),
(9, '4654', '0000-00-00', '-', '', '00:00:00', 'N', 'N', '', 'N', 'Hapus', 1, '2021-03-15'),
(6, '4649', '0000-00-00', '-', '', '00:00:00', 'N', 'N', '', 'N', 'Hapus', 1, '2021-03-15'),
(11, '4654', '2021-03-16', 'alasan', '', '08:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(11, '4654', '0000-00-00', '-', '', '00:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 'Hapus', 1, '2021-03-15'),
(12, '2028', '2021-03-16', 'sakit', 'Jam Datang', '14:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(12, '2028', '2021-03-16', 'sakit', 'Jam Datang', '15:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Edit', 1, '2021-03-15'),
(12, '2028', '0000-00-00', '-', '-', '00:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 'Hapus', 1, '2021-03-15'),
(13, '4654', '2021-03-16', 'alasan', 'Jam Datang', '07:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Create', 1, '2021-03-15'),
(14, '2017', '2021-12-04', 'alasan datang', 'Jam Datang', '10:30:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Create', 1, '2021-03-22'),
(14, '2017', '2021-01-04', 'alasan datang', 'Jam Datang', '10:30:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Edit', 1, '2021-03-22'),
(15, '2072', '2021-01-27', 'alasan datang', 'Jam Datang', '10:30:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Create', 1, '2021-03-24'),
(16, '2072', '2021-02-17', 'Ke Mojoagung', 'Jam Keluar', '10:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'Y', 'Create', 1, '2021-03-25'),
(2, '2031', '2021-01-03', 'Alasan Izin...', 'Jam Keluar', '12:30:00', 'Y', '', 'Form/HRD/018-Rev.01', 'Y', 'Kabag Menyetujui', 16, '2021-03-29'),
(13, '4654', '2021-03-16', 'alasan', 'Jam Datang', '07:00:00', 'Y', '', 'Form/HRD/018-Rev.01', 'Y', 'Kabag Menyetujui', 16, '2021-03-29'),
(3, '2018', '2021-01-04', 'Ada urusan mendadak', 'Jam Keluar', '12:00:00', 'Y', '', 'Form/HRD/018-Rev.01', 'Y', 'Kabag Menyetujui', 16, '2021-03-29'),
(5, '4649', '2021-02-26', 'Ada urusan mendadak', 'Jam Datang', '23:22:00', 'Y', '', 'Form/HRD/018-Rev.01', 'Y', 'Kabag Menyetujui', 16, '2021-03-29'),
(14, '2017', '2021-01-04', 'alasan datang', 'Jam Datang', '10:30:00', 'D', '', 'Form/HRD/018-Rev.01', 'Y', 'Kabag Menolak', 16, '2021-03-29'),
(15, '2072', '2021-01-27', 'alasan datang', 'Jam Datang', '10:30:00', 'D', '', 'Form/HRD/018-Rev.01', 'Y', 'Kabag Menolak', 16, '2021-03-29'),
(16, '2072', '2021-02-17', 'Ke Mojoagung', 'Jam Keluar', '10:00:00', 'D', '', 'Form/HRD/018-Rev.01', 'Y', 'Kabag Menolak', 16, '2021-03-29');

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

--
-- Dumping data for table `history_umk`
--

INSERT INTO `history_umk` (`id_umk`, `tahun_umk`, `total_umk`, `gaji_per_jam`, `status_umk`, `reason`, `change_by`, `change_at`) VALUES
(7, 2021, 4000000, 0, 'Y', 'Create', 1, '2021-03-02'),
(7, 2021, 4200000, 0, 'Y', 'Edit', 1, '2021-03-02'),
(7, 0, 0, 0, 'N', 'Hapus', 1, '2021-03-02'),
(8, 2021, 4250000, 0, 'Y', 'Create', 1, '2021-03-04'),
(2, 2020, 4000000, 0, 'Y', 'Edit', 1, '2021-03-04'),
(8, 2021, 4293582, 0, 'Y', 'Edit', 1, '2021-03-23'),
(2, 2020, 1730000, 10000, 'Y', 'Edit', 1, '2021-03-29');

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

--
-- Dumping data for table `history_user_login`
--

INSERT INTO `history_user_login` (`id_user`, `id_karyawan`, `username`, `password_user`, `role`, `status`, `reason`, `change_by`, `change_at`) VALUES
(14, '4654', 'rifki', '202cb962ac59075b964b07152d234b70', 0, 'Y', 'Create', 1, '2021-03-02'),
(14, '2001', 'rifki', '827ccb0eea8a706c4c34a16891f84e7b', 0, 'Y', 'Edit', 1, '2021-03-02'),
(14, '2001', '-', '-', 0, 'N', 'Hapus', 1, '2021-03-02'),
(15, '2028', 'erwanto', '827ccb0eea8a706c4c34a16891f84e7b', 1, 'Y', 'Create', 1, '2021-03-16'),
(1, '2001', 'admin', '21232f297a57a5a743894a0e4a801fc3', 2, 'Y', 'Edit', 1, '2021-03-16'),
(15, '2028', 'serwanto', '81dc9bdb52d04dc20036dbd8313ed055', 1, 'Y', 'Edit', 1, '2021-03-16'),
(16, '2025', 'muliadi', '81dc9bdb52d04dc20036dbd8313ed055', 4, 'Y', 'Create', 1, '2021-03-16'),
(2, '2072', 'admin2', 'c84258e9c39059a89ab77d846ddab909', 4, 'Y', 'Edit', 1, '2021-03-16'),
(2, '2072', 'admin2', 'c84258e9c39059a89ab77d846ddab909', 5, 'Y', 'Edit', 1, '2021-03-16'),
(3, '2072', 'afif', 'b56776aa98086825550ff0c3fe260907', 3, 'Y', 'Edit', 1, '2021-03-16'),
(4, '2067', 'mervin', '171f8fdaf2898d6e95d0238fa045259b', 6, 'Y', 'Edit', 1, '2021-03-16'),
(1, '2001', 'admin', '21232f297a57a5a743894a0e4a801fc3', 1, 'Y', 'Edit', 1, '2021-03-16'),
(1, '2001', 'admin', '21232f297a57a5a743894a0e4a801fc3', 2, 'Y', 'Edit', 1, '2021-03-16'),
(1, '2001', 'admin', '81dc9bdb52d04dc20036dbd8313ed055', 2, 'Y', 'Edit', 1, '2021-03-16'),
(1, '2001', 'admin', '21232f297a57a5a743894a0e4a801fc3', 2, 'Y', 'Edit', 1, '2021-03-16');

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
('2021010300000001', '2042', '2021-01-03', '06:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010300000002', '2031', '2021-01-03', '07:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010300000003', '2042', '2021-01-03', '12:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010300000004', '2031', '2021-01-03', '12:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000001', '2030', '2021-01-04', '06:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000002', '2025', '2021-01-04', '07:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000003', '2073', '2021-01-04', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000004', '2007', '2021-01-04', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000005', '2031', '2021-01-04', '07:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000006', '2003', '2021-01-04', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000007', '2005', '2021-01-04', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000008', '2062', '2021-01-04', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000009', '2060', '2021-01-04', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000010', '2067', '2021-01-04', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000011', '2034', '2021-01-04', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000012', '2026', '2021-01-04', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000013', '2069', '2021-01-04', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000014', '2039', '2021-01-04', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000015', '2047', '2021-01-04', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000016', '2049', '2021-01-04', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000017', '2065', '2021-01-04', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000018', '2068', '2021-01-04', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000019', '2008', '2021-01-04', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000020', '2001', '2021-01-04', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000021', '2032', '2021-01-04', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000022', '2072', '2021-01-04', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000023', '2042', '2021-01-04', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000024', '2006', '2021-01-04', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000025', '2028', '2021-01-04', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000026', '2046', '2021-01-04', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000027', '2014', '2021-01-04', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000028', '2035', '2021-01-04', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000029', '2029', '2021-01-04', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000030', '2041', '2021-01-04', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000031', '2056', '2021-01-04', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000032', '2066', '2021-01-04', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000033', '2061', '2021-01-04', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000034', '2038', '2021-01-04', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000035', '2070', '2021-01-04', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000036', '2024', '2021-01-04', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000037', '2053', '2021-01-04', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000038', '2036', '2021-01-04', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000039', '2048', '2021-01-04', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000040', '2013', '2021-01-04', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000041', '2045', '2021-01-04', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000042', '2019', '2021-01-04', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000043', '2071', '2021-01-04', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000044', '2012', '2021-01-04', '08:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000045', '2017', '2021-01-04', '08:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000046', '2074', '2021-01-04', '08:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000047', '2004', '2021-01-04', '08:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000048', '2044', '2021-01-04', '08:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000049', '2018', '2021-01-04', '09:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000050', '2018', '2021-01-04', '13:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000051', '2027', '2021-01-04', '14:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000052', '2029', '2021-01-04', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000053', '2036', '2021-01-04', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000054', '2038', '2021-01-04', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000055', '2028', '2021-01-04', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000056', '2069', '2021-01-04', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000057', '2026', '2021-01-04', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000058', '2039', '2021-01-04', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000059', '2024', '2021-01-04', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000060', '2042', '2021-01-04', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000061', '2025', '2021-01-04', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000062', '2053', '2021-01-04', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000063', '2032', '2021-01-04', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000064', '2030', '2021-01-04', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000065', '2003', '2021-01-04', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000066', '2031', '2021-01-04', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000067', '2035', '2021-01-04', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000068', '2034', '2021-01-04', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000069', '2014', '2021-01-04', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000070', '2061', '2021-01-04', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000071', '2056', '2021-01-04', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000072', '2013', '2021-01-04', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000073', '2046', '2021-01-04', '16:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000074', '2006', '2021-01-04', '16:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000075', '2068', '2021-01-04', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000076', '2071', '2021-01-04', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000077', '2007', '2021-01-04', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000078', '2066', '2021-01-04', '16:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000079', '2005', '2021-01-04', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000080', '2017', '2021-01-04', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000081', '2074', '2021-01-04', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000082', '2070', '2021-01-04', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000083', '2072', '2021-01-04', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000084', '2049', '2021-01-04', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000085', '2041', '2021-01-04', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000086', '2048', '2021-01-04', '17:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000087', '2062', '2021-01-04', '17:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000088', '2067', '2021-01-04', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000089', '2012', '2021-01-04', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000090', '2004', '2021-01-04', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000091', '2073', '2021-01-04', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000092', '2065', '2021-01-04', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000093', '2019', '2021-01-04', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000094', '2047', '2021-01-04', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000095', '2044', '2021-01-04', '17:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000096', '2045', '2021-01-04', '17:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000097', '2060', '2021-01-04', '17:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000098', '2027', '2021-01-04', '23:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010400000099', '2008', '2021-01-04', '17:52:00', 'Edit', 'Y', 2, '2021-02-22'),
('2021010400000100', '2001', '2021-01-04', '07:50:00', 'Edit', 'Y', 2, '2021-02-22'),
('2021010400000101', '2001', '2021-01-04', '19:42:00', 'Edit', 'Y', 2, '2021-02-22'),
('2021010500000001', '2031', '2021-01-05', '06:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000002', '2042', '2021-01-05', '07:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000003', '2025', '2021-01-05', '07:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000004', '2046', '2021-01-05', '07:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000005', '2073', '2021-01-05', '07:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000006', '2007', '2021-01-05', '07:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000007', '2003', '2021-01-05', '07:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000008', '2060', '2021-01-05', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000009', '2047', '2021-01-05', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000010', '2062', '2021-01-05', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000011', '2006', '2021-01-05', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000012', '2068', '2021-01-05', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000013', '2032', '2021-01-05', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000014', '2069', '2021-01-05', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000015', '2008', '2021-01-05', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000016', '2070', '2021-01-05', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000017', '2072', '2021-01-05', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000018', '2049', '2021-01-05', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000019', '2029', '2021-01-05', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000020', '2026', '2021-01-05', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000021', '2061', '2021-01-05', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000022', '2035', '2021-01-05', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000023', '2028', '2021-01-05', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000024', '2038', '2021-01-05', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000025', '2066', '2021-01-05', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000026', '2030', '2021-01-05', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000027', '2041', '2021-01-05', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000028', '2011', '2021-01-05', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000029', '2001', '2021-01-05', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000030', '2014', '2021-01-05', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000031', '2056', '2021-01-05', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000032', '2024', '2021-01-05', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000033', '2004', '2021-01-05', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000034', '2053', '2021-01-05', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000035', '2048', '2021-01-05', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000036', '2044', '2021-01-05', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000037', '2019', '2021-01-05', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000038', '2071', '2021-01-05', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000039', '2036', '2021-01-05', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000040', '2013', '2021-01-05', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000041', '2045', '2021-01-05', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000042', '2012', '2021-01-05', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000043', '2017', '2021-01-05', '08:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000044', '2074', '2021-01-05', '08:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000045', '2067', '2021-01-05', '08:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000046', '2012', '2021-01-05', '10:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000047', '2027', '2021-01-05', '14:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000048', '2029', '2021-01-05', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000049', '2069', '2021-01-05', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000050', '2026', '2021-01-05', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000051', '2024', '2021-01-05', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000052', '2025', '2021-01-05', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000053', '2036', '2021-01-05', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000054', '2042', '2021-01-05', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000055', '2038', '2021-01-05', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000056', '2030', '2021-01-05', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000057', '2028', '2021-01-05', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000058', '2032', '2021-01-05', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000059', '2073', '2021-01-05', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000060', '2011', '2021-01-05', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000061', '2031', '2021-01-05', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000062', '2035', '2021-01-05', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000063', '2053', '2021-01-05', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000064', '2003', '2021-01-05', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000065', '2014', '2021-01-05', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000066', '2013', '2021-01-05', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000067', '2006', '2021-01-05', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000068', '2046', '2021-01-05', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000069', '2061', '2021-01-05', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000070', '2001', '2021-01-05', '16:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000071', '2041', '2021-01-05', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000072', '2049', '2021-01-05', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000073', '2062', '2021-01-05', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000074', '2048', '2021-01-05', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000075', '2056', '2021-01-05', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000076', '2072', '2021-01-05', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000077', '2068', '2021-01-05', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000078', '2070', '2021-01-05', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000079', '2071', '2021-01-05', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000080', '2008', '2021-01-05', '16:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000081', '2066', '2021-01-05', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000082', '2019', '2021-01-05', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000083', '2047', '2021-01-05', '17:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000084', '2060', '2021-01-05', '17:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000085', '2067', '2021-01-05', '17:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000086', '2007', '2021-01-05', '17:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000087', '2004', '2021-01-05', '17:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000088', '2044', '2021-01-05', '17:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000089', '2045', '2021-01-05', '17:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010500000090', '2027', '2021-01-05', '23:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000001', '2027', '2021-01-06', '06:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000002', '2025', '2021-01-06', '07:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000003', '2007', '2021-01-06', '07:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000004', '2073', '2021-01-06', '07:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000005', '2046', '2021-01-06', '07:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000006', '2003', '2021-01-06', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000007', '2047', '2021-01-06', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000008', '2060', '2021-01-06', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000009', '2035', '2021-01-06', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000010', '2031', '2021-01-06', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000011', '2068', '2021-01-06', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000012', '2006', '2021-01-06', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000013', '2062', '2021-01-06', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000014', '2014', '2021-01-06', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000015', '2069', '2021-01-06', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000016', '2005', '2021-01-06', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000017', '2065', '2021-01-06', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000018', '2028', '2021-01-06', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000019', '2026', '2021-01-06', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000020', '2049', '2021-01-06', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000021', '2061', '2021-01-06', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000022', '2041', '2021-01-06', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000023', '2029', '2021-01-06', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000024', '2036', '2021-01-06', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000025', '2032', '2021-01-06', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000026', '2034', '2021-01-06', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000027', '2066', '2021-01-06', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000028', '2070', '2021-01-06', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000029', '2072', '2021-01-06', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000030', '2042', '2021-01-06', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000031', '2038', '2021-01-06', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000032', '2039', '2021-01-06', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000033', '2008', '2021-01-06', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000034', '2056', '2021-01-06', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000035', '2004', '2021-01-06', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000036', '2012', '2021-01-06', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000037', '2024', '2021-01-06', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000038', '2053', '2021-01-06', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000039', '2011', '2021-01-06', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000040', '2001', '2021-01-06', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000041', '2044', '2021-01-06', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000042', '2048', '2021-01-06', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000043', '2013', '2021-01-06', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000044', '2019', '2021-01-06', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000045', '2045', '2021-01-06', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000046', '2017', '2021-01-06', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000047', '2074', '2021-01-06', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000048', '2018', '2021-01-06', '09:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000049', '2018', '2021-01-06', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000050', '2027', '2021-01-06', '15:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000051', '2024', '2021-01-06', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000052', '2042', '2021-01-06', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000053', '2031', '2021-01-06', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000054', '2003', '2021-01-06', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000055', '2011', '2021-01-06', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000056', '2056', '2021-01-06', '16:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000057', '2045', '2021-01-06', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000058', '2041', '2021-01-06', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000059', '2049', '2021-01-06', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000060', '2062', '2021-01-06', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000061', '2008', '2021-01-06', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000062', '2005', '2021-01-06', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000063', '2048', '2021-01-06', '16:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000064', '2014', '2021-01-06', '16:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000065', '2061', '2021-01-06', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000066', '2013', '2021-01-06', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000067', '2017', '2021-01-06', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000068', '2074', '2021-01-06', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000069', '2001', '2021-01-06', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000070', '2034', '2021-01-06', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000071', '2019', '2021-01-06', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000072', '2065', '2021-01-06', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000073', '2068', '2021-01-06', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000074', '2070', '2021-01-06', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000075', '2060', '2021-01-06', '17:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000076', '2044', '2021-01-06', '17:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000077', '2072', '2021-01-06', '17:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000078', '2067', '2021-01-06', '17:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000079', '2012', '2021-01-06', '17:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000080', '2069', '2021-01-06', '17:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000081', '2029', '2021-01-06', '17:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000082', '2036', '2021-01-06', '17:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000083', '2028', '2021-01-06', '17:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000084', '2038', '2021-01-06', '17:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000085', '2025', '2021-01-06', '17:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000086', '2032', '2021-01-06', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000087', '2053', '2021-01-06', '17:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000088', '2039', '2021-01-06', '17:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000089', '2035', '2021-01-06', '17:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000090', '2066', '2021-01-06', '17:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000091', '2026', '2021-01-06', '17:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000092', '2046', '2021-01-06', '17:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000093', '2006', '2021-01-06', '17:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000094', '2007', '2021-01-06', '17:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000095', '2073', '2021-01-06', '17:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000096', '2004', '2021-01-06', '18:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010600000097', '2047', '2021-01-06', '18:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000001', '2031', '2021-01-07', '07:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000002', '2047', '2021-01-07', '07:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000003', '2025', '2021-01-07', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000004', '2073', '2021-01-07', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000005', '2007', '2021-01-07', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000006', '2005', '2021-01-07', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000007', '2003', '2021-01-07', '07:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000008', '2049', '2021-01-07', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000009', '2060', '2021-01-07', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000010', '2067', '2021-01-07', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000011', '2034', '2021-01-07', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000012', '2039', '2021-01-07', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000013', '2006', '2021-01-07', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000014', '2069', '2021-01-07', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000015', '2032', '2021-01-07', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000016', '2046', '2021-01-07', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000017', '2008', '2021-01-07', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000018', '2001', '2021-01-07', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000019', '2042', '2021-01-07', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000020', '2004', '2021-01-07', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000021', '2041', '2021-01-07', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000022', '2038', '2021-01-07', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000023', '2028', '2021-01-07', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000024', '2068', '2021-01-07', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000025', '2035', '2021-01-07', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000026', '2061', '2021-01-07', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000027', '2026', '2021-01-07', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000028', '2036', '2021-01-07', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000029', '2014', '2021-01-07', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000030', '2066', '2021-01-07', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000031', '2024', '2021-01-07', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000032', '2056', '2021-01-07', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000033', '2072', '2021-01-07', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000034', '2053', '2021-01-07', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000035', '2029', '2021-01-07', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000036', '2011', '2021-01-07', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000037', '2012', '2021-01-07', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000038', '2019', '2021-01-07', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000039', '2070', '2021-01-07', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000040', '2044', '2021-01-07', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000041', '2048', '2021-01-07', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000042', '2045', '2021-01-07', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000043', '2013', '2021-01-07', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000044', '2071', '2021-01-07', '08:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000045', '2012', '2021-01-07', '11:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000046', '2027', '2021-01-07', '14:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000047', '2024', '2021-01-07', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000048', '2003', '2021-01-07', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000049', '2011', '2021-01-07', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000050', '2013', '2021-01-07', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000051', '2049', '2021-01-07', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000052', '2042', '2021-01-07', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000053', '2005', '2021-01-07', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000054', '2014', '2021-01-07', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000055', '2056', '2021-01-07', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000056', '2068', '2021-01-07', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000057', '2001', '2021-01-07', '16:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000058', '2041', '2021-01-07', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000059', '2048', '2021-01-07', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000060', '2034', '2021-01-07', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000061', '2008', '2021-01-07', '16:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000062', '2019', '2021-01-07', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000063', '2017', '2021-01-07', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000064', '2074', '2021-01-07', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000065', '2071', '2021-01-07', '17:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000066', '2069', '2021-01-07', '17:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000067', '2038', '2021-01-07', '17:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000068', '2039', '2021-01-07', '17:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000069', '2053', '2021-01-07', '17:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000070', '2028', '2021-01-07', '17:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000071', '2036', '2021-01-07', '17:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000072', '2032', '2021-01-07', '17:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000073', '2025', '2021-01-07', '17:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000074', '2029', '2021-01-07', '17:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000075', '2026', '2021-01-07', '17:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000076', '2031', '2021-01-07', '17:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000077', '2035', '2021-01-07', '17:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000078', '2066', '2021-01-07', '17:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000079', '2072', '2021-01-07', '17:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000080', '2060', '2021-01-07', '17:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000081', '2070', '2021-01-07', '17:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000082', '2073', '2021-01-07', '18:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000083', '2067', '2021-01-07', '18:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000084', '2046', '2021-01-07', '18:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000085', '2006', '2021-01-07', '18:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000086', '2047', '2021-01-07', '18:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000087', '2045', '2021-01-07', '18:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000088', '2004', '2021-01-07', '18:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000089', '2007', '2021-01-07', '18:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010700000090', '2027', '2021-01-07', '23:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000001', '2031', '2021-01-08', '06:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000002', '2047', '2021-01-08', '07:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000003', '2025', '2021-01-08', '07:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000004', '2007', '2021-01-08', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000005', '2073', '2021-01-08', '07:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000006', '2049', '2021-01-08', '07:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000007', '2003', '2021-01-08', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000008', '2046', '2021-01-08', '07:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000009', '2062', '2021-01-08', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000010', '2060', '2021-01-08', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000011', '2006', '2021-01-08', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000012', '2014', '2021-01-08', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000013', '2042', '2021-01-08', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000014', '2069', '2021-01-08', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000015', '2072', '2021-01-08', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000016', '2039', '2021-01-08', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000017', '2065', '2021-01-08', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000018', '2029', '2021-01-08', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000019', '2036', '2021-01-08', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000020', '2038', '2021-01-08', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000021', '2028', '2021-01-08', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000022', '2066', '2021-01-08', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000023', '2032', '2021-01-08', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000024', '2041', '2021-01-08', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000025', '2008', '2021-01-08', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000026', '2068', '2021-01-08', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000027', '2035', '2021-01-08', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000028', '2004', '2021-01-08', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000029', '2044', '2021-01-08', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000030', '2070', '2021-01-08', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000031', '2011', '2021-01-08', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000032', '2024', '2021-01-08', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000033', '2048', '2021-01-08', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000034', '2061', '2021-01-08', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000035', '2053', '2021-01-08', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000036', '2026', '2021-01-08', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000037', '2045', '2021-01-08', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000038', '2013', '2021-01-08', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000039', '2034', '2021-01-08', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000040', '2012', '2021-01-08', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000041', '2001', '2021-01-08', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000042', '2067', '2021-01-08', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000043', '2019', '2021-01-08', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000044', '2056', '2021-01-08', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000045', '2071', '2021-01-08', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000046', '2017', '2021-01-08', '08:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000047', '2074', '2021-01-08', '08:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000048', '2012', '2021-01-08', '13:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000049', '2027', '2021-01-08', '14:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000050', '2024', '2021-01-08', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000051', '2030', '2021-01-08', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000052', '2034', '2021-01-08', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000053', '2028', '2021-01-08', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000054', '2038', '2021-01-08', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000055', '2003', '2021-01-08', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000056', '2011', '2021-01-08', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000057', '2069', '2021-01-08', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000058', '2013', '2021-01-08', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000059', '2029', '2021-01-08', '16:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000060', '2062', '2021-01-08', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000061', '2036', '2021-01-08', '16:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000062', '2056', '2021-01-08', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000063', '2049', '2021-01-08', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000064', '2039', '2021-01-08', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000065', '2042', '2021-01-08', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000066', '2025', '2021-01-08', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000067', '2001', '2021-01-08', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000068', '2014', '2021-01-08', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000069', '2026', '2021-01-08', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000070', '2006', '2021-01-08', '16:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000071', '2046', '2021-01-08', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000072', '2061', '2021-01-08', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000073', '2017', '2021-01-08', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000074', '2074', '2021-01-08', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000075', '2008', '2021-01-08', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000076', '2048', '2021-01-08', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000077', '2072', '2021-01-08', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000078', '2070', '2021-01-08', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000079', '2071', '2021-01-08', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000080', '2068', '2021-01-08', '16:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000081', '2032', '2021-01-08', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000082', '2035', '2021-01-08', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000083', '2073', '2021-01-08', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000084', '2067', '2021-01-08', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000085', '2031', '2021-01-08', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000086', '2045', '2021-01-08', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000087', '2041', '2021-01-08', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000088', '2066', '2021-01-08', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000089', '2053', '2021-01-08', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000090', '2065', '2021-01-08', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000091', '2019', '2021-01-08', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000092', '2060', '2021-01-08', '17:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000093', '2044', '2021-01-08', '17:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000094', '2047', '2021-01-08', '17:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000095', '2007', '2021-01-08', '17:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000096', '2004', '2021-01-08', '18:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010800000097', '2027', '2021-01-08', '23:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000001', '2031', '2021-01-09', '06:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000002', '2030', '2021-01-09', '06:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000003', '2025', '2021-01-09', '07:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000004', '2073', '2021-01-09', '07:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000005', '2007', '2021-01-09', '07:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000006', '2005', '2021-01-09', '07:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000007', '2047', '2021-01-09', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000008', '2042', '2021-01-09', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000009', '2006', '2021-01-09', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000010', '2026', '2021-01-09', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000011', '2028', '2021-01-09', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000012', '2061', '2021-01-09', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000013', '2008', '2021-01-09', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000014', '2068', '2021-01-09', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000015', '2038', '2021-01-09', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000016', '2065', '2021-01-09', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000017', '2032', '2021-01-09', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000018', '2035', '2021-01-09', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000019', '2069', '2021-01-09', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000020', '2003', '2021-01-09', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000021', '2056', '2021-01-09', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000022', '2029', '2021-01-09', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000023', '2036', '2021-01-09', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000024', '2044', '2021-01-09', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000025', '2039', '2021-01-09', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000026', '2066', '2021-01-09', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000027', '2001', '2021-01-09', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000028', '2041', '2021-01-09', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000029', '2062', '2021-01-09', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000030', '2070', '2021-01-09', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000031', '2034', '2021-01-09', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000032', '2046', '2021-01-09', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000033', '2071', '2021-01-09', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000034', '2072', '2021-01-09', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000035', '2019', '2021-01-09', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000036', '2053', '2021-01-09', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000037', '2048', '2021-01-09', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000038', '2011', '2021-01-09', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000039', '2013', '2021-01-09', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000040', '2045', '2021-01-09', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000041', '2004', '2021-01-09', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000042', '2014', '2021-01-09', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000043', '2017', '2021-01-09', '08:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000044', '2074', '2021-01-09', '08:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000045', '2027', '2021-01-09', '11:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000046', '2036', '2021-01-09', '13:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18');
INSERT INTO `master_absensi` (`id_absensi`, `id_karyawan`, `tanggal_absensi`, `jam_absensi`, `nama_mesin`, `status_absensi`, `change_by`, `change_at`) VALUES
('2021010900000047', '2032', '2021-01-09', '13:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000048', '2028', '2021-01-09', '13:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000049', '2073', '2021-01-09', '13:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000050', '2029', '2021-01-09', '13:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000051', '2038', '2021-01-09', '13:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000052', '2003', '2021-01-09', '13:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000053', '2014', '2021-01-09', '13:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000054', '2061', '2021-01-09', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000055', '2013', '2021-01-09', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000056', '2062', '2021-01-09', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000057', '2001', '2021-01-09', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000058', '2045', '2021-01-09', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000059', '2044', '2021-01-09', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000060', '2056', '2021-01-09', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000061', '2071', '2021-01-09', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000062', '2048', '2021-01-09', '13:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000063', '2011', '2021-01-09', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000064', '2041', '2021-01-09', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000065', '2017', '2021-01-09', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000066', '2074', '2021-01-09', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000067', '2030', '2021-01-09', '13:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000068', '2072', '2021-01-09', '13:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000069', '2034', '2021-01-09', '13:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000070', '2068', '2021-01-09', '13:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000071', '2005', '2021-01-09', '13:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000072', '2065', '2021-01-09', '13:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000073', '2019', '2021-01-09', '13:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000074', '2006', '2021-01-09', '13:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000075', '2046', '2021-01-09', '13:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000076', '2047', '2021-01-09', '13:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000077', '2070', '2021-01-09', '13:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000078', '2066', '2021-01-09', '13:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000079', '2007', '2021-01-09', '14:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000080', '2004', '2021-01-09', '14:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000081', '2025', '2021-01-09', '15:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000082', '2069', '2021-01-09', '15:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000083', '2039', '2021-01-09', '15:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000084', '2053', '2021-01-09', '15:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000085', '2035', '2021-01-09', '15:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000086', '2026', '2021-01-09', '15:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000087', '2042', '2021-01-09', '15:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000088', '2031', '2021-01-09', '15:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021010900000089', '2027', '2021-01-09', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000001', '2031', '2021-01-11', '06:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000002', '2027', '2021-01-11', '06:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000003', '2025', '2021-01-11', '07:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000004', '2073', '2021-01-11', '07:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000005', '2007', '2021-01-11', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000006', '2030', '2021-01-11', '07:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000007', '2003', '2021-01-11', '07:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000008', '2067', '2021-01-11', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000009', '2005', '2021-01-11', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000010', '2014', '2021-01-11', '07:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000011', '2060', '2021-01-11', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000012', '2046', '2021-01-11', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000013', '2047', '2021-01-11', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000014', '2049', '2021-01-11', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000015', '2006', '2021-01-11', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000016', '2069', '2021-01-11', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000017', '2068', '2021-01-11', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000018', '2065', '2021-01-11', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000019', '2034', '2021-01-11', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000020', '2035', '2021-01-11', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000021', '2036', '2021-01-11', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000022', '2062', '2021-01-11', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000023', '2028', '2021-01-11', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000024', '2029', '2021-01-11', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000025', '2032', '2021-01-11', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000026', '2060', '2021-01-11', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000027', '2066', '2021-01-11', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000028', '2042', '2021-01-11', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000029', '2039', '2021-01-11', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000030', '2070', '2021-01-11', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000031', '2041', '2021-01-11', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000032', '2001', '2021-01-11', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000033', '2072', '2021-01-11', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000034', '2004', '2021-01-11', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000035', '2038', '2021-01-11', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000036', '2056', '2021-01-11', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000037', '2011', '2021-01-11', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000038', '2048', '2021-01-11', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000039', '2008', '2021-01-11', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000040', '2061', '2021-01-11', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000041', '2013', '2021-01-11', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000042', '2053', '2021-01-11', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000043', '2024', '2021-01-11', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000044', '2019', '2021-01-11', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000045', '2045', '2021-01-11', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000046', '2026', '2021-01-11', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000047', '2012', '2021-01-11', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000048', '2071', '2021-01-11', '08:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000049', '2044', '2021-01-11', '08:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000050', '2017', '2021-01-11', '08:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000051', '2074', '2021-01-11', '08:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000052', '2018', '2021-01-11', '09:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000053', '2012', '2021-01-11', '11:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000054', '2018', '2021-01-11', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000055', '2027', '2021-01-11', '15:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000056', '2028', '2021-01-11', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000057', '2039', '2021-01-11', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000058', '2038', '2021-01-11', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000059', '2024', '2021-01-11', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000060', '2069', '2021-01-11', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000061', '2003', '2021-01-11', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000062', '2034', '2021-01-11', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000063', '2001', '2021-01-11', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000064', '2011', '2021-01-11', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000065', '2030', '2021-01-11', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000066', '2042', '2021-01-11', '16:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000067', '2005', '2021-01-11', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000068', '2014', '2021-01-11', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000069', '2029', '2021-01-11', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000070', '2036', '2021-01-11', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000071', '2062', '2021-01-11', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000072', '2049', '2021-01-11', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000073', '2013', '2021-01-11', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000074', '2048', '2021-01-11', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000075', '2044', '2021-01-11', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000076', '2041', '2021-01-11', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000077', '2056', '2021-01-11', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000078', '2061', '2021-01-11', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000079', '2006', '2021-01-11', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000080', '2046', '2021-01-11', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000081', '2032', '2021-01-11', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000082', '2008', '2021-01-11', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000083', '2019', '2021-01-11', '16:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000084', '2017', '2021-01-11', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000085', '2074', '2021-01-11', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000086', '2073', '2021-01-11', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000087', '2072', '2021-01-11', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000088', '2070', '2021-01-11', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000089', '2067', '2021-01-11', '17:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000090', '2045', '2021-01-11', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000091', '2065', '2021-01-11', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000092', '2068', '2021-01-11', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000093', '2004', '2021-01-11', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000094', '2060', '2021-01-11', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000095', '2071', '2021-01-11', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000096', '2053', '2021-01-11', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000097', '2025', '2021-01-11', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000098', '2026', '2021-01-11', '17:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000099', '2035', '2021-01-11', '17:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000100', '2031', '2021-01-11', '17:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000101', '2047', '2021-01-11', '18:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000102', '2007', '2021-01-11', '18:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011100000103', '2066', '2021-01-11', '18:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000001', '2027', '2021-01-12', '06:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000002', '2025', '2021-01-12', '07:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000003', '2073', '2021-01-12', '07:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000004', '2007', '2021-01-12', '07:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000005', '2005', '2021-01-12', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000006', '2003', '2021-01-12', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000007', '2049', '2021-01-12', '07:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000008', '2046', '2021-01-12', '07:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000009', '2031', '2021-01-12', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000010', '2034', '2021-01-12', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000011', '2062', '2021-01-12', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000012', '2030', '2021-01-12', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000013', '2060', '2021-01-12', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000014', '2069', '2021-01-12', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000015', '2068', '2021-01-12', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000016', '2008', '2021-01-12', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000017', '2006', '2021-01-12', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000018', '2067', '2021-01-12', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000019', '2065', '2021-01-12', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000020', '2036', '2021-01-12', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000021', '2029', '2021-01-12', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000022', '2028', '2021-01-12', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000023', '2047', '2021-01-12', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000024', '2066', '2021-01-12', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000025', '2042', '2021-01-12', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000026', '2038', '2021-01-12', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000027', '2041', '2021-01-12', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000028', '2014', '2021-01-12', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000029', '2032', '2021-01-12', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000030', '2035', '2021-01-12', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000031', '2072', '2021-01-12', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000032', '2024', '2021-01-12', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000033', '2012', '2021-01-12', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000034', '2070', '2021-01-12', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000035', '2001', '2021-01-12', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000036', '2019', '2021-01-12', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000037', '2044', '2021-01-12', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000038', '2048', '2021-01-12', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000039', '2026', '2021-01-12', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000040', '2061', '2021-01-12', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000041', '2053', '2021-01-12', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000042', '2056', '2021-01-12', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000043', '2045', '2021-01-12', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000044', '2011', '2021-01-12', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000045', '2013', '2021-01-12', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000046', '2039', '2021-01-12', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000047', '2004', '2021-01-12', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000048', '2071', '2021-01-12', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000049', '2018', '2021-01-12', '09:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000050', '2018', '2021-01-12', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000051', '2027', '2021-01-12', '15:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000052', '2026', '2021-01-12', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000053', '2069', '2021-01-12', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000054', '2073', '2021-01-12', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000055', '2025', '2021-01-12', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000056', '2028', '2021-01-12', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000057', '2036', '2021-01-12', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000058', '2038', '2021-01-12', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000059', '2029', '2021-01-12', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000060', '2003', '2021-01-12', '16:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000061', '2039', '2021-01-12', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000062', '2030', '2021-01-12', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000063', '2042', '2021-01-12', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000064', '2032', '2021-01-12', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000065', '2024', '2021-01-12', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000066', '2031', '2021-01-12', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000067', '2035', '2021-01-12', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000068', '2034', '2021-01-12', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000069', '2053', '2021-01-12', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000070', '2046', '2021-01-12', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000071', '2006', '2021-01-12', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000072', '2005', '2021-01-12', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000073', '2011', '2021-01-12', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000074', '2061', '2021-01-12', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000075', '2013', '2021-01-12', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000076', '2017', '2021-01-12', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000077', '2014', '2021-01-12', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000078', '2049', '2021-01-12', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000079', '2001', '2021-01-12', '16:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000080', '2041', '2021-01-12', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000081', '2062', '2021-01-12', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000082', '2048', '2021-01-12', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000083', '2008', '2021-01-12', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000084', '2068', '2021-01-12', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000085', '2044', '2021-01-12', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000086', '2045', '2021-01-12', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000087', '2056', '2021-01-12', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000088', '2019', '2021-01-12', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000089', '2071', '2021-01-12', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000090', '2072', '2021-01-12', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000091', '2070', '2021-01-12', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000092', '2004', '2021-01-12', '17:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000093', '2012', '2021-01-12', '17:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000094', '2066', '2021-01-12', '17:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000095', '2047', '2021-01-12', '17:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000096', '2065', '2021-01-12', '17:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000097', '2067', '2021-01-12', '17:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000098', '2060', '2021-01-12', '17:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011200000099', '2007', '2021-01-12', '18:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000001', '2034', '2021-01-13', '06:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000002', '2027', '2021-01-13', '06:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000003', '2025', '2021-01-13', '07:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000004', '2073', '2021-01-13', '07:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000005', '2007', '2021-01-13', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000006', '2031', '2021-01-13', '07:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000007', '2003', '2021-01-13', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000008', '2005', '2021-01-13', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000009', '2069', '2021-01-13', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000010', '2060', '2021-01-13', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000011', '2065', '2021-01-13', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000012', '2068', '2021-01-13', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000013', '2008', '2021-01-13', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000014', '2047', '2021-01-13', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000015', '2042', '2021-01-13', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000016', '2056', '2021-01-13', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000017', '2035', '2021-01-13', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000018', '2006', '2021-01-13', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000019', '2046', '2021-01-13', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000020', '2066', '2021-01-13', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000021', '2049', '2021-01-13', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000022', '2062', '2021-01-13', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000023', '2028', '2021-01-13', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000024', '2032', '2021-01-13', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000025', '2014', '2021-01-13', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000026', '2001', '2021-01-13', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000027', '2029', '2021-01-13', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000028', '2024', '2021-01-13', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000029', '2072', '2021-01-13', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000030', '2041', '2021-01-13', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000031', '2038', '2021-01-13', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000032', '2039', '2021-01-13', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000033', '2070', '2021-01-13', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000034', '2004', '2021-01-13', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000035', '2053', '2021-01-13', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000036', '2026', '2021-01-13', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000037', '2061', '2021-01-13', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000038', '2048', '2021-01-13', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000039', '2011', '2021-01-13', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000040', '2012', '2021-01-13', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000041', '2019', '2021-01-13', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000042', '2044', '2021-01-13', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000043', '2045', '2021-01-13', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000044', '2067', '2021-01-13', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000045', '2071', '2021-01-13', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000046', '2017', '2021-01-13', '08:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000047', '2074', '2021-01-13', '08:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000048', '2036', '2021-01-13', '08:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000049', '2018', '2021-01-13', '09:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000050', '2018', '2021-01-13', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000051', '2027', '2021-01-13', '15:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000052', '2038', '2021-01-13', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000053', '2028', '2021-01-13', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000054', '2026', '2021-01-13', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000055', '2069', '2021-01-13', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000056', '2029', '2021-01-13', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000057', '2032', '2021-01-13', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000058', '2024', '2021-01-13', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000059', '2036', '2021-01-13', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000060', '2025', '2021-01-13', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000061', '2006', '2021-01-13', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000062', '2046', '2021-01-13', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000063', '2030', '2021-01-13', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000064', '2003', '2021-01-13', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000065', '2039', '2021-01-13', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000066', '2011', '2021-01-13', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000067', '2005', '2021-01-13', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000068', '2042', '2021-01-13', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000069', '2007', '2021-01-13', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000070', '2073', '2021-01-13', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000071', '2001', '2021-01-13', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000072', '2014', '2021-01-13', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000073', '2004', '2021-01-13', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000074', '2008', '2021-01-13', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000075', '2017', '2021-01-13', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000076', '2072', '2021-01-13', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000077', '2068', '2021-01-13', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000078', '2074', '2021-01-13', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000079', '2061', '2021-01-13', '16:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000080', '2034', '2021-01-13', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000081', '2053', '2021-01-13', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000082', '2031', '2021-01-13', '16:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000083', '2035', '2021-01-13', '16:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000084', '2066', '2021-01-13', '16:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000085', '2071', '2021-01-13', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000086', '2041', '2021-01-13', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000087', '2049', '2021-01-13', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000088', '2062', '2021-01-13', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000089', '2048', '2021-01-13', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000090', '2056', '2021-01-13', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000091', '2012', '2021-01-13', '17:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000092', '2019', '2021-01-13', '17:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000093', '2047', '2021-01-13', '17:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000094', '2070', '2021-01-13', '17:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000095', '2067', '2021-01-13', '17:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000096', '2065', '2021-01-13', '17:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000097', '2044', '2021-01-13', '17:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011300000098', '2045', '2021-01-13', '17:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000001', '2031', '2021-01-14', '06:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000002', '2027', '2021-01-14', '06:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000003', '2025', '2021-01-14', '07:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000004', '2073', '2021-01-14', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000005', '2007', '2021-01-14', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000006', '2030', '2021-01-14', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000007', '2003', '2021-01-14', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000008', '2005', '2021-01-14', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000009', '2047', '2021-01-14', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000010', '2046', '2021-01-14', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000011', '2049', '2021-01-14', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000012', '2035', '2021-01-14', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000013', '2060', '2021-01-14', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000014', '2006', '2021-01-14', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000015', '2008', '2021-01-14', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000016', '2001', '2021-01-14', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000017', '2068', '2021-01-14', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000018', '2069', '2021-01-14', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000019', '2028', '2021-01-14', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000020', '2036', '2021-01-14', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000021', '2026', '2021-01-14', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000022', '2066', '2021-01-14', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000023', '2062', '2021-01-14', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000024', '2014', '2021-01-14', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000025', '2061', '2021-01-14', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000026', '2042', '2021-01-14', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000027', '2032', '2021-01-14', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000028', '2038', '2021-01-14', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000029', '2067', '2021-01-14', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000030', '2056', '2021-01-14', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000031', '2029', '2021-01-14', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000032', '2072', '2021-01-14', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000033', '2024', '2021-01-14', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000034', '2041', '2021-01-14', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000035', '2011', '2021-01-14', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000036', '2053', '2021-01-14', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000037', '2044', '2021-01-14', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000038', '2013', '2021-01-14', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000039', '2070', '2021-01-14', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000040', '2039', '2021-01-14', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000041', '2004', '2021-01-14', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000042', '2019', '2021-01-14', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000043', '2012', '2021-01-14', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000044', '2048', '2021-01-14', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000045', '2071', '2021-01-14', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000046', '2017', '2021-01-14', '08:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000047', '2074', '2021-01-14', '08:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000048', '2034', '2021-01-14', '09:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000049', '2027', '2021-01-14', '15:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000050', '2044', '2021-01-14', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000051', '2029', '2021-01-14', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000052', '2069', '2021-01-14', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000053', '2026', '2021-01-14', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000054', '2028', '2021-01-14', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000055', '2038', '2021-01-14', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000056', '2024', '2021-01-14', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000057', '2042', '2021-01-14', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000058', '2032', '2021-01-14', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000059', '2053', '2021-01-14', '16:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000060', '2039', '2021-01-14', '16:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000061', '2030', '2021-01-14', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000062', '2034', '2021-01-14', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000063', '2025', '2021-01-14', '16:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000064', '2003', '2021-01-14', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000065', '2011', '2021-01-14', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000066', '2071', '2021-01-14', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000067', '2068', '2021-01-14', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000068', '2005', '2021-01-14', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000069', '2061', '2021-01-14', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000070', '2031', '2021-01-14', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000071', '2036', '2021-01-14', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000072', '2066', '2021-01-14', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000073', '2013', '2021-01-14', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000074', '2001', '2021-01-14', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000075', '2056', '2021-01-14', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000076', '2049', '2021-01-14', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000077', '2048', '2021-01-14', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000078', '2008', '2021-01-14', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000079', '2062', '2021-01-14', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000080', '2014', '2021-01-14', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000081', '2041', '2021-01-14', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000082', '2017', '2021-01-14', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000083', '2074', '2021-01-14', '16:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000084', '2035', '2021-01-14', '16:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000085', '2073', '2021-01-14', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000086', '2007', '2021-01-14', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000087', '2046', '2021-01-14', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000088', '2006', '2021-01-14', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000089', '2072', '2021-01-14', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000090', '2070', '2021-01-14', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000091', '2012', '2021-01-14', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000092', '2004', '2021-01-14', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000093', '2067', '2021-01-14', '17:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000094', '2019', '2021-01-14', '17:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011400000095', '2047', '2021-01-14', '17:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000001', '2030', '2021-01-15', '06:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000002', '2027', '2021-01-15', '06:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000003', '2025', '2021-01-15', '07:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000004', '2007', '2021-01-15', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000005', '2003', '2021-01-15', '07:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000006', '2073', '2021-01-15', '07:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000007', '2047', '2021-01-15', '07:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000008', '2031', '2021-01-15', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000009', '2005', '2021-01-15', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000010', '2060', '2021-01-15', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000011', '2068', '2021-01-15', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000012', '2067', '2021-01-15', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000013', '2070', '2021-01-15', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000014', '2006', '2021-01-15', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000015', '2001', '2021-01-15', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000016', '2014', '2021-01-15', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000017', '2062', '2021-01-15', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000018', '2049', '2021-01-15', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000019', '2069', '2021-01-15', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000020', '2032', '2021-01-15', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000021', '2036', '2021-01-15', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000022', '2026', '2021-01-15', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000023', '2065', '2021-01-15', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000024', '2028', '2021-01-15', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000025', '2035', '2021-01-15', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000026', '2042', '2021-01-15', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000027', '2053', '2021-01-15', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000028', '2066', '2021-01-15', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000029', '2029', '2021-01-15', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000030', '2056', '2021-01-15', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000031', '2072', '2021-01-15', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000032', '2034', '2021-01-15', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000033', '2038', '2021-01-15', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000034', '2039', '2021-01-15', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000035', '2061', '2021-01-15', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000036', '2046', '2021-01-15', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000037', '2041', '2021-01-15', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000038', '2008', '2021-01-15', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000039', '2011', '2021-01-15', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000040', '2013', '2021-01-15', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000041', '2024', '2021-01-15', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000042', '2004', '2021-01-15', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000043', '2048', '2021-01-15', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000044', '2044', '2021-01-15', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000045', '2045', '2021-01-15', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000046', '2071', '2021-01-15', '08:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000047', '2018', '2021-01-15', '09:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000048', '2018', '2021-01-15', '13:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000049', '2027', '2021-01-15', '15:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000050', '2024', '2021-01-15', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000051', '2042', '2021-01-15', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000052', '2073', '2021-01-15', '16:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000053', '2030', '2021-01-15', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000054', '2036', '2021-01-15', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000055', '2013', '2021-01-15', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000056', '2003', '2021-01-15', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000057', '2069', '2021-01-15', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000058', '2028', '2021-01-15', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000059', '2038', '2021-01-15', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000060', '2032', '2021-01-15', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000061', '2026', '2021-01-15', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000062', '2034', '2021-01-15', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000063', '2001', '2021-01-15', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000064', '2011', '2021-01-15', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000065', '2031', '2021-01-15', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000066', '2029', '2021-01-15', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000067', '2025', '2021-01-15', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000068', '2061', '2021-01-15', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000069', '2049', '2021-01-15', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000070', '2039', '2021-01-15', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000071', '2053', '2021-01-15', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000072', '2066', '2021-01-15', '16:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000073', '2048', '2021-01-15', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000074', '2062', '2021-01-15', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000075', '2005', '2021-01-15', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000076', '2035', '2021-01-15', '16:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000077', '2008', '2021-01-15', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000078', '2041', '2021-01-15', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000079', '2071', '2021-01-15', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000080', '2068', '2021-01-15', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000081', '2072', '2021-01-15', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000082', '2056', '2021-01-15', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000083', '2065', '2021-01-15', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000084', '2044', '2021-01-15', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000085', '2067', '2021-01-15', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000086', '2045', '2021-01-15', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18');
INSERT INTO `master_absensi` (`id_absensi`, `id_karyawan`, `tanggal_absensi`, `jam_absensi`, `nama_mesin`, `status_absensi`, `change_by`, `change_at`) VALUES
('2021011500000087', '2019', '2021-01-15', '17:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000088', '2014', '2021-01-15', '17:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000089', '2007', '2021-01-15', '17:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000090', '2060', '2021-01-15', '17:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000091', '2004', '2021-01-15', '19:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000092', '2070', '2021-01-15', '19:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000093', '2046', '2021-01-15', '19:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000094', '2006', '2021-01-15', '19:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011500000095', '2047', '2021-01-15', '19:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000001', '2031', '2021-01-16', '06:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000002', '2034', '2021-01-16', '06:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000003', '2027', '2021-01-16', '06:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000004', '2025', '2021-01-16', '07:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000005', '2073', '2021-01-16', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000006', '2003', '2021-01-16', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000007', '2047', '2021-01-16', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000008', '2006', '2021-01-16', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000009', '2046', '2021-01-16', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000010', '2062', '2021-01-16', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000011', '2005', '2021-01-16', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000012', '2068', '2021-01-16', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000013', '2060', '2021-01-16', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000014', '2036', '2021-01-16', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000015', '2008', '2021-01-16', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000016', '2001', '2021-01-16', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000017', '2014', '2021-01-16', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000018', '2065', '2021-01-16', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000019', '2069', '2021-01-16', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000020', '2032', '2021-01-16', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000021', '2066', '2021-01-16', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000022', '2035', '2021-01-16', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000023', '2029', '2021-01-16', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000024', '2039', '2021-01-16', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000025', '2028', '2021-01-16', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000026', '2061', '2021-01-16', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000027', '2049', '2021-01-16', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000028', '2041', '2021-01-16', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000029', '2038', '2021-01-16', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000030', '2026', '2021-01-16', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000031', '2071', '2021-01-16', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000032', '2072', '2021-01-16', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000033', '2070', '2021-01-16', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000034', '2019', '2021-01-16', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000035', '2004', '2021-01-16', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000036', '2056', '2021-01-16', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000037', '2024', '2021-01-16', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000038', '2011', '2021-01-16', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000039', '2044', '2021-01-16', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000040', '2045', '2021-01-16', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000041', '2053', '2021-01-16', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000042', '2048', '2021-01-16', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000043', '2012', '2021-01-16', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000044', '2013', '2021-01-16', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000045', '2017', '2021-01-16', '08:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000046', '2074', '2021-01-16', '08:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000047', '2027', '2021-01-16', '12:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000048', '2028', '2021-01-16', '13:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000049', '2013', '2021-01-16', '13:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000050', '2026', '2021-01-16', '13:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000051', '2029', '2021-01-16', '13:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000052', '2003', '2021-01-16', '13:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000053', '2073', '2021-01-16', '13:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000054', '2032', '2021-01-16', '13:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000055', '2039', '2021-01-16', '13:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000056', '2005', '2021-01-16', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000057', '2071', '2021-01-16', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000058', '2044', '2021-01-16', '13:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000059', '2001', '2021-01-16', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000060', '2011', '2021-01-16', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000061', '2014', '2021-01-16', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000062', '2025', '2021-01-16', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000063', '2062', '2021-01-16', '13:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000064', '2049', '2021-01-16', '13:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000065', '2048', '2021-01-16', '13:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000066', '2041', '2021-01-16', '13:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000067', '2034', '2021-01-16', '13:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000068', '2006', '2021-01-16', '13:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000069', '2046', '2021-01-16', '13:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000070', '2047', '2021-01-16', '13:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000071', '2056', '2021-01-16', '13:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000072', '2072', '2021-01-16', '13:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000073', '2068', '2021-01-16', '13:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000074', '2065', '2021-01-16', '13:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000075', '2061', '2021-01-16', '13:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000076', '2070', '2021-01-16', '13:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000077', '2045', '2021-01-16', '13:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000078', '2019', '2021-01-16', '13:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000079', '2035', '2021-01-16', '13:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000080', '2031', '2021-01-16', '13:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000081', '2053', '2021-01-16', '13:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000082', '2060', '2021-01-16', '13:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000083', '2004', '2021-01-16', '14:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000084', '2066', '2021-01-16', '14:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000085', '2012', '2021-01-16', '14:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000086', '2024', '2021-01-16', '15:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000087', '2036', '2021-01-16', '15:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000088', '2038', '2021-01-16', '15:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011600000089', '2069', '2021-01-16', '15:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000001', '2031', '2021-01-18', '06:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000002', '2047', '2021-01-18', '07:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000003', '2025', '2021-01-18', '07:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000004', '2073', '2021-01-18', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000005', '2007', '2021-01-18', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000006', '2003', '2021-01-18', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000007', '2049', '2021-01-18', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000008', '2004', '2021-01-18', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000009', '2005', '2021-01-18', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000010', '2060', '2021-01-18', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000011', '2039', '2021-01-18', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000012', '2062', '2021-01-18', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000013', '2006', '2021-01-18', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000014', '2069', '2021-01-18', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000015', '2014', '2021-01-18', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000016', '2001', '2021-01-18', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000017', '2046', '2021-01-18', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000018', '2029', '2021-01-18', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000019', '2032', '2021-01-18', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000020', '2066', '2021-01-18', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000021', '2068', '2021-01-18', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000022', '2035', '2021-01-18', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000023', '2036', '2021-01-18', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000024', '2041', '2021-01-18', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000025', '2026', '2021-01-18', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000026', '2061', '2021-01-18', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000027', '2070', '2021-01-18', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000028', '2034', '2021-01-18', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000029', '2053', '2021-01-18', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000030', '2038', '2021-01-18', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000031', '2011', '2021-01-18', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000032', '2008', '2021-01-18', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000033', '2072', '2021-01-18', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000034', '2024', '2021-01-18', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000035', '2048', '2021-01-18', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000036', '2045', '2021-01-18', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000037', '2044', '2021-01-18', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000038', '2013', '2021-01-18', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000039', '2067', '2021-01-18', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000040', '2071', '2021-01-18', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000041', '2019', '2021-01-18', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000042', '2030', '2021-01-18', '08:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000043', '2017', '2021-01-18', '08:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000044', '2074', '2021-01-18', '08:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000045', '2018', '2021-01-18', '09:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000046', '2018', '2021-01-18', '13:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000047', '2027', '2021-01-18', '14:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000048', '2038', '2021-01-18', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000049', '2069', '2021-01-18', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000050', '2036', '2021-01-18', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000051', '2030', '2021-01-18', '16:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000052', '2047', '2021-01-18', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000053', '2073', '2021-01-18', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000054', '2025', '2021-01-18', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000055', '2003', '2021-01-18', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000056', '2011', '2021-01-18', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000057', '2039', '2021-01-18', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000058', '2029', '2021-01-18', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000059', '2026', '2021-01-18', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000060', '2044', '2021-01-18', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000061', '2013', '2021-01-18', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000062', '2046', '2021-01-18', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000063', '2006', '2021-01-18', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000064', '2034', '2021-01-18', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000065', '2032', '2021-01-18', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000066', '2071', '2021-01-18', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000067', '2068', '2021-01-18', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000068', '2072', '2021-01-18', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000069', '2005', '2021-01-18', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000070', '2001', '2021-01-18', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000071', '2061', '2021-01-18', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000072', '2014', '2021-01-18', '16:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000073', '2049', '2021-01-18', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000074', '2008', '2021-01-18', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000075', '2062', '2021-01-18', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000076', '2066', '2021-01-18', '16:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000077', '2045', '2021-01-18', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000078', '2017', '2021-01-18', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000079', '2041', '2021-01-18', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000080', '2048', '2021-01-18', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000081', '2074', '2021-01-18', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000082', '2053', '2021-01-18', '16:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000083', '2035', '2021-01-18', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000084', '2024', '2021-01-18', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000085', '2031', '2021-01-18', '16:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000086', '2019', '2021-01-18', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000087', '2067', '2021-01-18', '17:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000088', '2007', '2021-01-18', '17:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000089', '2060', '2021-01-18', '17:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000090', '2004', '2021-01-18', '18:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011800000091', '2027', '2021-01-18', '23:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000001', '2031', '2021-01-19', '06:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000002', '2030', '2021-01-19', '07:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000003', '2025', '2021-01-19', '07:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000004', '2073', '2021-01-19', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000005', '2007', '2021-01-19', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000006', '2050', '2021-01-19', '07:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000007', '2049', '2021-01-19', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000008', '2060', '2021-01-19', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000009', '2005', '2021-01-19', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000010', '2047', '2021-01-19', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000011', '2014', '2021-01-19', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000012', '2039', '2021-01-19', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000013', '2069', '2021-01-19', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000014', '2065', '2021-01-19', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000015', '2068', '2021-01-19', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000016', '2006', '2021-01-19', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000017', '2029', '2021-01-19', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000018', '2035', '2021-01-19', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000019', '2066', '2021-01-19', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000020', '2008', '2021-01-19', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000021', '2062', '2021-01-19', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000022', '2072', '2021-01-19', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000023', '2036', '2021-01-19', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000024', '2041', '2021-01-19', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000025', '2001', '2021-01-19', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000026', '2003', '2021-01-19', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000027', '2026', '2021-01-19', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000028', '2024', '2021-01-19', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000029', '2056', '2021-01-19', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000030', '2028', '2021-01-19', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000031', '2032', '2021-01-19', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000032', '2034', '2021-01-19', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000033', '2012', '2021-01-19', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000034', '2070', '2021-01-19', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000035', '2038', '2021-01-19', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000036', '2004', '2021-01-19', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000037', '2067', '2021-01-19', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000038', '2044', '2021-01-19', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000039', '2011', '2021-01-19', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000040', '2048', '2021-01-19', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000041', '2061', '2021-01-19', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000042', '2045', '2021-01-19', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000043', '2046', '2021-01-19', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000044', '2019', '2021-01-19', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000045', '2013', '2021-01-19', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000046', '2053', '2021-01-19', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000047', '2071', '2021-01-19', '08:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000048', '2017', '2021-01-19', '08:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000049', '2074', '2021-01-19', '08:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000050', '2018', '2021-01-19', '09:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000051', '2018', '2021-01-19', '13:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000052', '2027', '2021-01-19', '14:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000053', '2030', '2021-01-19', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000054', '2003', '2021-01-19', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000055', '2026', '2021-01-19', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000056', '2028', '2021-01-19', '16:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000057', '2069', '2021-01-19', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000058', '2038', '2021-01-19', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000059', '2032', '2021-01-19', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000060', '2031', '2021-01-19', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000061', '2034', '2021-01-19', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000062', '2029', '2021-01-19', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000063', '2024', '2021-01-19', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000064', '2025', '2021-01-19', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000065', '2039', '2021-01-19', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000066', '2035', '2021-01-19', '16:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000067', '2053', '2021-01-19', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000068', '2036', '2021-01-19', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000069', '2011', '2021-01-19', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000070', '2005', '2021-01-19', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000071', '2006', '2021-01-19', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000072', '2046', '2021-01-19', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000073', '2061', '2021-01-19', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000074', '2001', '2021-01-19', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000075', '2050', '2021-01-19', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000076', '2062', '2021-01-19', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000077', '2014', '2021-01-19', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000078', '2012', '2021-01-19', '16:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000079', '2049', '2021-01-19', '16:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000080', '2048', '2021-01-19', '16:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000081', '2041', '2021-01-19', '16:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000082', '2013', '2021-01-19', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000083', '2017', '2021-01-19', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000084', '2074', '2021-01-19', '16:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000085', '2073', '2021-01-19', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000086', '2056', '2021-01-19', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000087', '2072', '2021-01-19', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000088', '2068', '2021-01-19', '17:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000089', '2070', '2021-01-19', '17:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000090', '2004', '2021-01-19', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000091', '2019', '2021-01-19', '17:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000092', '2044', '2021-01-19', '17:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000093', '2071', '2021-01-19', '17:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000094', '2045', '2021-01-19', '17:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000095', '2065', '2021-01-19', '17:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000096', '2066', '2021-01-19', '17:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000097', '2060', '2021-01-19', '17:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000098', '2007', '2021-01-19', '18:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021011900000099', '2027', '2021-01-19', '23:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000001', '2025', '2021-01-20', '07:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000002', '2007', '2021-01-20', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000003', '2003', '2021-01-20', '07:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000004', '2060', '2021-01-20', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000005', '2066', '2021-01-20', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000006', '2047', '2021-01-20', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000007', '2062', '2021-01-20', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000008', '2005', '2021-01-20', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000009', '2065', '2021-01-20', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000010', '2041', '2021-01-20', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000011', '2073', '2021-01-20', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000012', '2067', '2021-01-20', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000013', '2049', '2021-01-20', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000014', '2056', '2021-01-20', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000015', '2068', '2021-01-20', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000016', '2028', '2021-01-20', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000017', '2006', '2021-01-20', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000018', '2039', '2021-01-20', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000019', '2069', '2021-01-20', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000020', '2031', '2021-01-20', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000021', '2050', '2021-01-20', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000022', '2061', '2021-01-20', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000023', '2032', '2021-01-20', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000024', '2034', '2021-01-20', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000025', '2014', '2021-01-20', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000026', '2008', '2021-01-20', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000027', '2046', '2021-01-20', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000028', '2036', '2021-01-20', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000029', '2029', '2021-01-20', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000030', '2035', '2021-01-20', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000031', '2044', '2021-01-20', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000032', '2038', '2021-01-20', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000033', '2019', '2021-01-20', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000034', '2024', '2021-01-20', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000035', '2072', '2021-01-20', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000036', '2001', '2021-01-20', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000037', '2004', '2021-01-20', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000038', '2053', '2021-01-20', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000039', '2045', '2021-01-20', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000040', '2048', '2021-01-20', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000041', '2071', '2021-01-20', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000042', '2011', '2021-01-20', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000043', '2013', '2021-01-20', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000044', '2030', '2021-01-20', '08:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000045', '2017', '2021-01-20', '08:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000046', '2074', '2021-01-20', '08:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000047', '2018', '2021-01-20', '09:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000048', '2018', '2021-01-20', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000049', '2027', '2021-01-20', '14:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000050', '2025', '2021-01-20', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000051', '2028', '2021-01-20', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000052', '2038', '2021-01-20', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000053', '2029', '2021-01-20', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000054', '2024', '2021-01-20', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000055', '2039', '2021-01-20', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000056', '2069', '2021-01-20', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000057', '2036', '2021-01-20', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000058', '2053', '2021-01-20', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000059', '2035', '2021-01-20', '16:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000060', '2031', '2021-01-20', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000061', '2034', '2021-01-20', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000062', '2032', '2021-01-20', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000063', '2030', '2021-01-20', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000064', '2003', '2021-01-20', '16:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000065', '2062', '2021-01-20', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000066', '2061', '2021-01-20', '16:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000067', '2005', '2021-01-20', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000068', '2013', '2021-01-20', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000069', '2001', '2021-01-20', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000070', '2014', '2021-01-20', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000071', '2071', '2021-01-20', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000072', '2011', '2021-01-20', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000073', '2050', '2021-01-20', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000074', '2017', '2021-01-20', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000075', '2074', '2021-01-20', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000076', '2049', '2021-01-20', '16:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000077', '2048', '2021-01-20', '16:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000078', '2066', '2021-01-20', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000079', '2056', '2021-01-20', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000080', '2008', '2021-01-20', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000081', '2041', '2021-01-20', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000082', '2019', '2021-01-20', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000083', '2046', '2021-01-20', '17:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000084', '2006', '2021-01-20', '17:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000085', '2047', '2021-01-20', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000086', '2045', '2021-01-20', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000087', '2044', '2021-01-20', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000088', '2065', '2021-01-20', '17:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000089', '2068', '2021-01-20', '17:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000090', '2060', '2021-01-20', '18:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000091', '2004', '2021-01-20', '18:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000092', '2007', '2021-01-20', '21:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012000000093', '2027', '2021-01-20', '23:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000001', '2030', '2021-01-21', '06:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000002', '2025', '2021-01-21', '07:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000003', '2073', '2021-01-21', '07:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000004', '2007', '2021-01-21', '07:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000005', '2003', '2021-01-21', '07:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000006', '2066', '2021-01-21', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000007', '2049', '2021-01-21', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000008', '2067', '2021-01-21', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000009', '2060', '2021-01-21', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000010', '2014', '2021-01-21', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000011', '2047', '2021-01-21', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000012', '2062', '2021-01-21', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000013', '2034', '2021-01-21', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000014', '2001', '2021-01-21', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000015', '2050', '2021-01-21', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000016', '2068', '2021-01-21', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000017', '2039', '2021-01-21', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000018', '2006', '2021-01-21', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000019', '2053', '2021-01-21', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000020', '2028', '2021-01-21', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000021', '2035', '2021-01-21', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000022', '2072', '2021-01-21', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000023', '2029', '2021-01-21', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000024', '2038', '2021-01-21', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000025', '2024', '2021-01-21', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000026', '2032', '2021-01-21', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000027', '2046', '2021-01-21', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000028', '2031', '2021-01-21', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000029', '2056', '2021-01-21', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000030', '2008', '2021-01-21', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000031', '2011', '2021-01-21', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000032', '2041', '2021-01-21', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000033', '2036', '2021-01-21', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000034', '2070', '2021-01-21', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000035', '2048', '2021-01-21', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000036', '2019', '2021-01-21', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000037', '2004', '2021-01-21', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000038', '2013', '2021-01-21', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000039', '2044', '2021-01-21', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000040', '2045', '2021-01-21', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000041', '2012', '2021-01-21', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000042', '2017', '2021-01-21', '08:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000043', '2074', '2021-01-21', '08:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000044', '2005', '2021-01-21', '08:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000045', '2012', '2021-01-21', '11:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000046', '2029', '2021-01-21', '13:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000047', '2027', '2021-01-21', '14:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000048', '2003', '2021-01-21', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000049', '2073', '2021-01-21', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000050', '2044', '2021-01-21', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000051', '2013', '2021-01-21', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000052', '2034', '2021-01-21', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000053', '2005', '2021-01-21', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000054', '2006', '2021-01-21', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000055', '2046', '2021-01-21', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000056', '2011', '2021-01-21', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000057', '2001', '2021-01-21', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000058', '2030', '2021-01-21', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000059', '2056', '2021-01-21', '16:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000060', '2068', '2021-01-21', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000061', '2017', '2021-01-21', '16:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000062', '2074', '2021-01-21', '16:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000063', '2070', '2021-01-21', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000064', '2072', '2021-01-21', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000065', '2066', '2021-01-21', '16:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000066', '2008', '2021-01-21', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000067', '2004', '2021-01-21', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000068', '2048', '2021-01-21', '16:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000069', '2041', '2021-01-21', '16:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000070', '2049', '2021-01-21', '16:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000071', '2050', '2021-01-21', '16:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000072', '2062', '2021-01-21', '16:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000073', '2014', '2021-01-21', '16:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000074', '2024', '2021-01-21', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000075', '2067', '2021-01-21', '17:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000076', '2019', '2021-01-21', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000077', '2060', '2021-01-21', '17:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000078', '2038', '2021-01-21', '17:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000079', '2028', '2021-01-21', '17:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000080', '2045', '2021-01-21', '17:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000081', '2032', '2021-01-21', '17:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000082', '2036', '2021-01-21', '17:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000083', '2039', '2021-01-21', '17:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000084', '2031', '2021-01-21', '17:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000085', '2053', '2021-01-21', '17:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000086', '2035', '2021-01-21', '17:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000087', '2047', '2021-01-21', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000088', '2025', '2021-01-21', '17:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000089', '2007', '2021-01-21', '20:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012100000090', '2027', '2021-01-21', '23:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000001', '2030', '2021-01-22', '06:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000002', '2025', '2021-01-22', '07:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000003', '2031', '2021-01-22', '07:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000004', '2003', '2021-01-22', '07:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000005', '2073', '2021-01-22', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000006', '2007', '2021-01-22', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000007', '2066', '2021-01-22', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000008', '2005', '2021-01-22', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000009', '2047', '2021-01-22', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000010', '2067', '2021-01-22', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000011', '2060', '2021-01-22', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000012', '2069', '2021-01-22', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000013', '2065', '2021-01-22', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000014', '2049', '2021-01-22', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000015', '2034', '2021-01-22', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000016', '2039', '2021-01-22', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000017', '2028', '2021-01-22', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000018', '2046', '2021-01-22', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000019', '2006', '2021-01-22', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000020', '2072', '2021-01-22', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000021', '2056', '2021-01-22', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000022', '2068', '2021-01-22', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000023', '2035', '2021-01-22', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000024', '2029', '2021-01-22', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000025', '2050', '2021-01-22', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000026', '2008', '2021-01-22', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000027', '2001', '2021-01-22', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000028', '2036', '2021-01-22', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000029', '2041', '2021-01-22', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000030', '2062', '2021-01-22', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000031', '2004', '2021-01-22', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000032', '2024', '2021-01-22', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000033', '2053', '2021-01-22', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000034', '2038', '2021-01-22', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000035', '2013', '2021-01-22', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000036', '2011', '2021-01-22', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000037', '2012', '2021-01-22', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000038', '2070', '2021-01-22', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000039', '2026', '2021-01-22', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000040', '2048', '2021-01-22', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000041', '2014', '2021-01-22', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000042', '2019', '2021-01-22', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000043', '2045', '2021-01-22', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000044', '2071', '2021-01-22', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000045', '2044', '2021-01-22', '08:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000046', '2032', '2021-01-22', '08:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000047', '2017', '2021-01-22', '08:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000048', '2074', '2021-01-22', '08:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000049', '2018', '2021-01-22', '09:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000050', '2018', '2021-01-22', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000051', '2027', '2021-01-22', '14:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000052', '2030', '2021-01-22', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000053', '2031', '2021-01-22', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18');
INSERT INTO `master_absensi` (`id_absensi`, `id_karyawan`, `tanggal_absensi`, `jam_absensi`, `nama_mesin`, `status_absensi`, `change_by`, `change_at`) VALUES
('2021012200000054', '2003', '2021-01-22', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000055', '2013', '2021-01-22', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000056', '2001', '2021-01-22', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000057', '2011', '2021-01-22', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000058', '2014', '2021-01-22', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000059', '2066', '2021-01-22', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000060', '2006', '2021-01-22', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000061', '2046', '2021-01-22', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000062', '2005', '2021-01-22', '16:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000063', '2034', '2021-01-22', '16:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000064', '2072', '2021-01-22', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000065', '2008', '2021-01-22', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000066', '2070', '2021-01-22', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000067', '2068', '2021-01-22', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000068', '2071', '2021-01-22', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000069', '2029', '2021-01-22', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000070', '2069', '2021-01-22', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000071', '2039', '2021-01-22', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000072', '2024', '2021-01-22', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000073', '2028', '2021-01-22', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000074', '2036', '2021-01-22', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000075', '2038', '2021-01-22', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000076', '2044', '2021-01-22', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000077', '2048', '2021-01-22', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000078', '2049', '2021-01-22', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000079', '2065', '2021-01-22', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000080', '2056', '2021-01-22', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000081', '4646', '2021-01-22', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000082', '2045', '2021-01-22', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000083', '2025', '2021-01-22', '17:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000084', '2067', '2021-01-22', '17:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000085', '2073', '2021-01-22', '17:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000086', '2032', '2021-01-22', '17:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000087', '2019', '2021-01-22', '17:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000088', '2026', '2021-01-22', '17:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000089', '2012', '2021-01-22', '17:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000090', '2062', '2021-01-22', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000091', '2050', '2021-01-22', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000092', '2041', '2021-01-22', '17:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000093', '2060', '2021-01-22', '17:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000094', '2053', '2021-01-22', '17:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000095', '2035', '2021-01-22', '17:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000096', '2004', '2021-01-22', '17:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000097', '2047', '2021-01-22', '17:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000098', '2007', '2021-01-22', '20:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012200000099', '2027', '2021-01-22', '23:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000001', '2031', '2021-01-23', '06:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000002', '2030', '2021-01-23', '07:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000003', '2025', '2021-01-23', '07:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000004', '2003', '2021-01-23', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000005', '2073', '2021-01-23', '07:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000006', '2005', '2021-01-23', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000007', '2046', '2021-01-23', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000008', '2060', '2021-01-23', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000009', '2047', '2021-01-23', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000010', '2068', '2021-01-23', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000011', '2050', '2021-01-23', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000012', '2061', '2021-01-23', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000013', '2069', '2021-01-23', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000014', '2062', '2021-01-23', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000015', '2049', '2021-01-23', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000016', '2029', '2021-01-23', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000017', '2036', '2021-01-23', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000018', '2066', '2021-01-23', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000019', '2070', '2021-01-23', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000020', '2065', '2021-01-23', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000021', '2034', '2021-01-23', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000022', '2039', '2021-01-23', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000023', '2028', '2021-01-23', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000024', '2001', '2021-01-23', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000025', '2014', '2021-01-23', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000026', '2006', '2021-01-23', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000027', '2032', '2021-01-23', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000028', '2026', '2021-01-23', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000029', '2041', '2021-01-23', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000030', '2056', '2021-01-23', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000031', '2035', '2021-01-23', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000032', '2053', '2021-01-23', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000033', '2072', '2021-01-23', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000034', '2024', '2021-01-23', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000035', '2038', '2021-01-23', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000036', '2017', '2021-01-23', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000037', '2008', '2021-01-23', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000038', '2044', '2021-01-23', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000039', '2074', '2021-01-23', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000040', '2011', '2021-01-23', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000041', '2045', '2021-01-23', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000042', '2048', '2021-01-23', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000043', '2013', '2021-01-23', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000044', '2071', '2021-01-23', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000045', '2019', '2021-01-23', '08:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000046', '2004', '2021-01-23', '08:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000047', '2012', '2021-01-23', '10:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000048', '2027', '2021-01-23', '11:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000049', '2061', '2021-01-23', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000050', '2073', '2021-01-23', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000051', '2003', '2021-01-23', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000052', '2050', '2021-01-23', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000053', '2071', '2021-01-23', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000054', '2068', '2021-01-23', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000055', '2011', '2021-01-23', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000056', '2056', '2021-01-23', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000057', '2065', '2021-01-23', '13:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000058', '2013', '2021-01-23', '13:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000059', '2044', '2021-01-23', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000060', '2030', '2021-01-23', '13:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000061', '2014', '2021-01-23', '13:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000062', '2006', '2021-01-23', '13:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000063', '2047', '2021-01-23', '13:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000064', '2019', '2021-01-23', '13:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000065', '2046', '2021-01-23', '13:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000066', '2049', '2021-01-23', '13:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000067', '2048', '2021-01-23', '13:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000068', '2041', '2021-01-23', '13:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000069', '2008', '2021-01-23', '13:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000070', '2062', '2021-01-23', '13:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000071', '2017', '2021-01-23', '13:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000072', '2074', '2021-01-23', '13:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000073', '2001', '2021-01-23', '13:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000074', '2031', '2021-01-23', '13:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000075', '2072', '2021-01-23', '13:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000076', '2070', '2021-01-23', '13:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000077', '2005', '2021-01-23', '13:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000078', '2045', '2021-01-23', '13:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000079', '2066', '2021-01-23', '13:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000080', '2060', '2021-01-23', '13:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000081', '2012', '2021-01-23', '14:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000082', '2024', '2021-01-23', '15:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000083', '2034', '2021-01-23', '15:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000084', '2039', '2021-01-23', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000085', '2029', '2021-01-23', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000086', '2069', '2021-01-23', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000087', '2038', '2021-01-23', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000088', '2028', '2021-01-23', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000089', '2032', '2021-01-23', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000090', '2025', '2021-01-23', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000091', '2036', '2021-01-23', '16:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000092', '2053', '2021-01-23', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000093', '2035', '2021-01-23', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000094', '2026', '2021-01-23', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000095', '2004', '2021-01-23', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012300000096', '2027', '2021-01-23', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000001', '2027', '2021-01-25', '06:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000002', '2031', '2021-01-25', '07:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000003', '2025', '2021-01-25', '07:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000004', '2003', '2021-01-25', '07:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000005', '2073', '2021-01-25', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000006', '2034', '2021-01-25', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000007', '2047', '2021-01-25', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000008', '2049', '2021-01-25', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000009', '2005', '2021-01-25', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000010', '2060', '2021-01-25', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000011', '2042', '2021-01-25', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000012', '2028', '2021-01-25', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000013', '2069', '2021-01-25', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000014', '2068', '2021-01-25', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000015', '2056', '2021-01-25', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000016', '2050', '2021-01-25', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000017', '2061', '2021-01-25', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000018', '2035', '2021-01-25', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000019', '2065', '2021-01-25', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000020', '2066', '2021-01-25', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000021', '2041', '2021-01-25', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000022', '2062', '2021-01-25', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000023', '2046', '2021-01-25', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000024', '2070', '2021-01-25', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000025', '2029', '2021-01-25', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000026', '2039', '2021-01-25', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000027', '2036', '2021-01-25', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000028', '2072', '2021-01-25', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000029', '2006', '2021-01-25', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000030', '2001', '2021-01-25', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000031', '2014', '2021-01-25', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000032', '2038', '2021-01-25', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000033', '2026', '2021-01-25', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000034', '2032', '2021-01-25', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000035', '2053', '2021-01-25', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000036', '2024', '2021-01-25', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000037', '2048', '2021-01-25', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000038', '2013', '2021-01-25', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000039', '2045', '2021-01-25', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000040', '2019', '2021-01-25', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000041', '2011', '2021-01-25', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000042', '2044', '2021-01-25', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000043', '2071', '2021-01-25', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000044', '2017', '2021-01-25', '08:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000045', '2004', '2021-01-25', '08:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000046', '2018', '2021-01-25', '13:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000047', '2024', '2021-01-25', '13:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000048', '2075', '2021-01-25', '15:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000049', '2027', '2021-01-25', '15:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000050', '2073', '2021-01-25', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000051', '2050', '2021-01-25', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000052', '2028', '2021-01-25', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000053', '2003', '2021-01-25', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000054', '2038', '2021-01-25', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000055', '2044', '2021-01-25', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000056', '2061', '2021-01-25', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000057', '2034', '2021-01-25', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000058', '2029', '2021-01-25', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000059', '2069', '2021-01-25', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000060', '2025', '2021-01-25', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000061', '2039', '2021-01-25', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000062', '2053', '2021-01-25', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000063', '2036', '2021-01-25', '16:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000064', '2056', '2021-01-25', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000065', '2049', '2021-01-25', '16:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000066', '2017', '2021-01-25', '16:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000067', '2048', '2021-01-25', '16:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000068', '2001', '2021-01-25', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000069', '2011', '2021-01-25', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000070', '2013', '2021-01-25', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000071', '2032', '2021-01-25', '16:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000072', '2042', '2021-01-25', '16:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000073', '2006', '2021-01-25', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000074', '2005', '2021-01-25', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000075', '2031', '2021-01-25', '16:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000076', '2066', '2021-01-25', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000077', '2062', '2021-01-25', '16:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000078', '2070', '2021-01-25', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000079', '2072', '2021-01-25', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000080', '2046', '2021-01-25', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000081', '2041', '2021-01-25', '16:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000082', '2014', '2021-01-25', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000083', '2019', '2021-01-25', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000084', '2047', '2021-01-25', '17:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000085', '2035', '2021-01-25', '17:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000086', '2004', '2021-01-25', '17:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000087', '2026', '2021-01-25', '17:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000088', '2060', '2021-01-25', '17:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000089', '2065', '2021-01-25', '18:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000090', '2068', '2021-01-25', '18:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000091', '2071', '2021-01-25', '18:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000092', '2045', '2021-01-25', '18:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012500000093', '2075', '2021-01-25', '19:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000001', '2027', '2021-01-26', '06:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000002', '2031', '2021-01-26', '07:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000003', '2025', '2021-01-26', '07:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000004', '2047', '2021-01-26', '07:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000005', '2073', '2021-01-26', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000006', '2003', '2021-01-26', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000007', '2046', '2021-01-26', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000008', '2060', '2021-01-26', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000009', '2049', '2021-01-26', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000010', '2075', '2021-01-26', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000011', '2069', '2021-01-26', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000012', '2028', '2021-01-26', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000013', '2029', '2021-01-26', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000014', '2006', '2021-01-26', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000015', '2001', '2021-01-26', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000016', '2062', '2021-01-26', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000017', '2065', '2021-01-26', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000018', '2068', '2021-01-26', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000019', '2066', '2021-01-26', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000020', '2032', '2021-01-26', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000021', '2041', '2021-01-26', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000022', '2056', '2021-01-26', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000023', '2034', '2021-01-26', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000024', '2005', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000025', '2008', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000026', '2014', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000027', '2042', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000028', '2036', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000029', '2039', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000030', '2026', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000031', '2038', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000032', '2072', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000033', '2061', '2021-01-26', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000034', '2019', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000035', '2011', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000036', '2070', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000037', '2012', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000038', '2053', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000039', '2045', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000040', '2035', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000041', '2004', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000042', '2013', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000043', '2071', '2021-01-26', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000044', '2048', '2021-01-26', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000045', '2044', '2021-01-26', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000046', '2017', '2021-01-26', '08:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000047', '2018', '2021-01-26', '09:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000048', '2018', '2021-01-26', '13:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000049', '2027', '2021-01-26', '15:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000050', '2029', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000051', '2039', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000052', '2069', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000053', '2038', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000054', '2028', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000055', '2042', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000056', '2036', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000057', '2032', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000058', '2053', '2021-01-26', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000059', '2026', '2021-01-26', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000060', '2025', '2021-01-26', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000061', '2034', '2021-01-26', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000062', '2001', '2021-01-26', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000063', '2003', '2021-01-26', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000064', '2011', '2021-01-26', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000065', '2056', '2021-01-26', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000066', '2005', '2021-01-26', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000067', '2061', '2021-01-26', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000068', '2066', '2021-01-26', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000069', '2031', '2021-01-26', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000070', '2035', '2021-01-26', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000071', '2046', '2021-01-26', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000072', '2006', '2021-01-26', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000073', '2013', '2021-01-26', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000074', '2048', '2021-01-26', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000075', '2049', '2021-01-26', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000076', '2017', '2021-01-26', '16:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000077', '2019', '2021-01-26', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000078', '2041', '2021-01-26', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000079', '2014', '2021-01-26', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000080', '2008', '2021-01-26', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000081', '2062', '2021-01-26', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000082', '2060', '2021-01-26', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000083', '2070', '2021-01-26', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000084', '2072', '2021-01-26', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000085', '2004', '2021-01-26', '17:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000086', '2012', '2021-01-26', '17:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000087', '2047', '2021-01-26', '17:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000088', '2044', '2021-01-26', '18:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000089', '2045', '2021-01-26', '18:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000090', '2071', '2021-01-26', '19:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000091', '2065', '2021-01-26', '19:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000092', '2073', '2021-01-26', '19:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000093', '2068', '2021-01-26', '19:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012600000094', '2075', '2021-01-26', '22:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000001', '2027', '2021-01-27', '06:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000002', '2025', '2021-01-27', '07:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000003', '2050', '2021-01-27', '07:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000004', '2047', '2021-01-27', '07:38:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000005', '2073', '2021-01-27', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000006', '2003', '2021-01-27', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000007', '2060', '2021-01-27', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000008', '2034', '2021-01-27', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000009', '2042', '2021-01-27', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000010', '2049', '2021-01-27', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000011', '2006', '2021-01-27', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000012', '2069', '2021-01-27', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000013', '2046', '2021-01-27', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000014', '2005', '2021-01-27', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000015', '2065', '2021-01-27', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000016', '2035', '2021-01-27', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000017', '2004', '2021-01-27', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000018', '2075', '2021-01-27', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000019', '2029', '2021-01-27', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000020', '2028', '2021-01-27', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000021', '2032', '2021-01-27', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000022', '2070', '2021-01-27', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000023', '2066', '2021-01-27', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000024', '2041', '2021-01-27', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000025', '2056', '2021-01-27', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000026', '2068', '2021-01-27', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000027', '2039', '2021-01-27', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000028', '2061', '2021-01-27', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000029', '2036', '2021-01-27', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000030', '2062', '2021-01-27', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000031', '2019', '2021-01-27', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000032', '2026', '2021-01-27', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000033', '2072', '2021-01-27', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000034', '2038', '2021-01-27', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000035', '2014', '2021-01-27', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000036', '2013', '2021-01-27', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000037', '2024', '2021-01-27', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000038', '2053', '2021-01-27', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000039', '2045', '2021-01-27', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000040', '2048', '2021-01-27', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000041', '2008', '2021-01-27', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000042', '2012', '2021-01-27', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000043', '2044', '2021-01-27', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000044', '2011', '2021-01-27', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000045', '2001', '2021-01-27', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000046', '2017', '2021-01-27', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000047', '2067', '2021-01-27', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000048', '2071', '2021-01-27', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000049', '2018', '2021-01-27', '09:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000050', '2018', '2021-01-27', '13:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000051', '2027', '2021-01-27', '15:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000052', '2069', '2021-01-27', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000053', '2028', '2021-01-27', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000054', '2038', '2021-01-27', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000055', '2029', '2021-01-27', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000056', '2025', '2021-01-27', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000057', '2039', '2021-01-27', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000058', '2032', '2021-01-27', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000059', '2053', '2021-01-27', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000060', '2036', '2021-01-27', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000061', '2073', '2021-01-27', '16:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000062', '2003', '2021-01-27', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000063', '2030', '2021-01-27', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000064', '2041', '2021-01-27', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000065', '2050', '2021-01-27', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000066', '2062', '2021-01-27', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000067', '2049', '2021-01-27', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000068', '2048', '2021-01-27', '16:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000069', '2006', '2021-01-27', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000070', '2046', '2021-01-27', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000071', '2005', '2021-01-27', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000072', '2011', '2021-01-27', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000073', '2066', '2021-01-27', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000074', '2001', '2021-01-27', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000075', '2013', '2021-01-27', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000076', '2042', '2021-01-27', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000077', '2024', '2021-01-27', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000078', '2035', '2021-01-27', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000079', '2034', '2021-01-27', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000080', '2047', '2021-01-27', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000081', '2061', '2021-01-27', '16:25:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000082', '2014', '2021-01-27', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000083', '2056', '2021-01-27', '16:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000084', '2019', '2021-01-27', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000085', '2008', '2021-01-27', '16:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000086', '2070', '2021-01-27', '17:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000087', '2072', '2021-01-27', '17:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000088', '2017', '2021-01-27', '17:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000089', '2067', '2021-01-27', '17:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000090', '2071', '2021-01-27', '17:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000091', '2026', '2021-01-27', '18:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000092', '2044', '2021-01-27', '18:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000093', '2068', '2021-01-27', '18:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000094', '2065', '2021-01-27', '18:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000095', '2045', '2021-01-27', '18:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000096', '2004', '2021-01-27', '18:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000097', '2012', '2021-01-27', '18:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012700000098', '2075', '2021-01-27', '20:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000001', '2027', '2021-01-28', '06:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000002', '2025', '2021-01-28', '07:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000003', '2073', '2021-01-28', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000004', '2031', '2021-01-28', '07:40:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000005', '2030', '2021-01-28', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000006', '2060', '2021-01-28', '07:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000007', '2005', '2021-01-28', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000008', '2062', '2021-01-28', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000009', '2006', '2021-01-28', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000010', '2075', '2021-01-28', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000011', '2068', '2021-01-28', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000012', '2046', '2021-01-28', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000013', '2047', '2021-01-28', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000014', '2049', '2021-01-28', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000015', '2042', '2021-01-28', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000016', '2028', '2021-01-28', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000017', '2070', '2021-01-28', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000018', '2032', '2021-01-28', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000019', '2065', '2021-01-28', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000020', '2066', '2021-01-28', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000021', '2050', '2021-01-28', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000022', '2061', '2021-01-28', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000023', '2039', '2021-01-28', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000024', '2029', '2021-01-28', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000025', '2041', '2021-01-28', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000026', '2034', '2021-01-28', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000027', '2004', '2021-01-28', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000028', '2035', '2021-01-28', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000029', '2036', '2021-01-28', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000030', '2048', '2021-01-28', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000031', '2072', '2021-01-28', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000032', '2026', '2021-01-28', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000033', '2008', '2021-01-28', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000034', '2056', '2021-01-28', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000035', '2045', '2021-01-28', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000036', '2024', '2021-01-28', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000037', '2038', '2021-01-28', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000038', '2011', '2021-01-28', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000039', '2001', '2021-01-28', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000040', '2053', '2021-01-28', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000041', '2013', '2021-01-28', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000042', '2012', '2021-01-28', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000043', '2019', '2021-01-28', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000044', '2071', '2021-01-28', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000045', '2044', '2021-01-28', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000046', '2017', '2021-01-28', '08:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000047', '2069', '2021-01-28', '08:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000048', '2067', '2021-01-28', '08:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000049', '2003', '2021-01-28', '09:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000050', '2029', '2021-01-28', '13:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000051', '2027', '2021-01-28', '15:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000052', '2030', '2021-01-28', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000053', '2038', '2021-01-28', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000054', '2028', '2021-01-28', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000055', '2025', '2021-01-28', '16:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000056', '2039', '2021-01-28', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000057', '2036', '2021-01-28', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000058', '2044', '2021-01-28', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000059', '2071', '2021-01-28', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000060', '2032', '2021-01-28', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000061', '2031', '2021-01-28', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000062', '2005', '2021-01-28', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000063', '2053', '2021-01-28', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000064', '2069', '2021-01-28', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000065', '2003', '2021-01-28', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000066', '2034', '2021-01-28', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000067', '2042', '2021-01-28', '16:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000068', '2024', '2021-01-28', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000069', '2045', '2021-01-28', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000070', '2056', '2021-01-28', '16:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000071', '2013', '2021-01-28', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000072', '2011', '2021-01-28', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000073', '2066', '2021-01-28', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000074', '2006', '2021-01-28', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000075', '2046', '2021-01-28', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000076', '2001', '2021-01-28', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000077', '2026', '2021-01-28', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000078', '2035', '2021-01-28', '16:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000079', '2050', '2021-01-28', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000080', '2062', '2021-01-28', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000081', '2061', '2021-01-28', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000082', '2065', '2021-01-28', '16:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000083', '2068', '2021-01-28', '16:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000084', '2048', '2021-01-28', '16:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000085', '2049', '2021-01-28', '16:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000086', '2017', '2021-01-28', '16:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000087', '2008', '2021-01-28', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000088', '2004', '2021-01-28', '16:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000089', '2072', '2021-01-28', '16:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000090', '2067', '2021-01-28', '16:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000091', '2041', '2021-01-28', '16:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000092', '2070', '2021-01-28', '16:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000093', '2073', '2021-01-28', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000094', '2019', '2021-01-28', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000095', '2012', '2021-01-28', '17:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000096', '2047', '2021-01-28', '18:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012800000097', '2075', '2021-01-28', '20:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18');
INSERT INTO `master_absensi` (`id_absensi`, `id_karyawan`, `tanggal_absensi`, `jam_absensi`, `nama_mesin`, `status_absensi`, `change_by`, `change_at`) VALUES
('2021012900000001', '2027', '2021-01-29', '06:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000002', '2025', '2021-01-29', '07:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000003', '2073', '2021-01-29', '07:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000004', '2003', '2021-01-29', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000005', '2005', '2021-01-29', '07:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000006', '2042', '2021-01-29', '07:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000007', '2034', '2021-01-29', '07:41:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000008', '2060', '2021-01-29', '07:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000009', '2046', '2021-01-29', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000010', '2006', '2021-01-29', '07:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000011', '2032', '2021-01-29', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000012', '2069', '2021-01-29', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000013', '2075', '2021-01-29', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000014', '2049', '2021-01-29', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000015', '2068', '2021-01-29', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000016', '2065', '2021-01-29', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000017', '2029', '2021-01-29', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000018', '2066', '2021-01-29', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000019', '2056', '2021-01-29', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000020', '2008', '2021-01-29', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000021', '2070', '2021-01-29', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000022', '2028', '2021-01-29', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000023', '2036', '2021-01-29', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000024', '2039', '2021-01-29', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000025', '2035', '2021-01-29', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000026', '2031', '2021-01-29', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000027', '2062', '2021-01-29', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000028', '2072', '2021-01-29', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000029', '2026', '2021-01-29', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000030', '2038', '2021-01-29', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000031', '2061', '2021-01-29', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000032', '2050', '2021-01-29', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000033', '2041', '2021-01-29', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000034', '2030', '2021-01-29', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000035', '2067', '2021-01-29', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000036', '2048', '2021-01-29', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000037', '2045', '2021-01-29', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000038', '2014', '2021-01-29', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000039', '2019', '2021-01-29', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000040', '2004', '2021-01-29', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000041', '2024', '2021-01-29', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000042', '2053', '2021-01-29', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000043', '2001', '2021-01-29', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000044', '2011', '2021-01-29', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000045', '2013', '2021-01-29', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000046', '2017', '2021-01-29', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000047', '2071', '2021-01-29', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000048', '2012', '2021-01-29', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000049', '2044', '2021-01-29', '08:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000050', '2018', '2021-01-29', '09:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000051', '2018', '2021-01-29', '13:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000052', '2012', '2021-01-29', '14:43:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000053', '2027', '2021-01-29', '15:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000054', '2003', '2021-01-29', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000055', '2073', '2021-01-29', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000056', '2067', '2021-01-29', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000057', '2072', '2021-01-29', '16:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000058', '2013', '2021-01-29', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000059', '2034', '2021-01-29', '16:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000060', '2066', '2021-01-29', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000061', '2031', '2021-01-29', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000062', '2028', '2021-01-29', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000063', '2038', '2021-01-29', '16:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000064', '2069', '2021-01-29', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000065', '2029', '2021-01-29', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000066', '2032', '2021-01-29', '16:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000067', '2024', '2021-01-29', '16:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000068', '2056', '2021-01-29', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000069', '2025', '2021-01-29', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000070', '2039', '2021-01-29', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000071', '2071', '2021-01-29', '16:20:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000072', '2036', '2021-01-29', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000073', '2053', '2021-01-29', '16:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000074', '2011', '2021-01-29', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000075', '2048', '2021-01-29', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000076', '2041', '2021-01-29', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000077', '2042', '2021-01-29', '16:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000078', '2035', '2021-01-29', '16:28:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000079', '2005', '2021-01-29', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000080', '2049', '2021-01-29', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000081', '2050', '2021-01-29', '16:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000082', '2008', '2021-01-29', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000083', '2062', '2021-01-29', '16:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000084', '2061', '2021-01-29', '16:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000085', '2014', '2021-01-29', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000086', '2006', '2021-01-29', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000087', '2046', '2021-01-29', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000088', '2017', '2021-01-29', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000089', '2001', '2021-01-29', '16:36:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000090', '2026', '2021-01-29', '16:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000091', '2070', '2021-01-29', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000092', '2044', '2021-01-29', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000093', '2045', '2021-01-29', '17:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000094', '2068', '2021-01-29', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000095', '2019', '2021-01-29', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000096', '2065', '2021-01-29', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000097', '2060', '2021-01-29', '18:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000098', '2004', '2021-01-29', '19:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021012900000099', '2075', '2021-01-29', '20:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000001', '2027', '2021-01-30', '06:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000002', '2025', '2021-01-30', '07:13:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000003', '2073', '2021-01-30', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000004', '2003', '2021-01-30', '07:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000005', '2060', '2021-01-30', '07:37:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000006', '2047', '2021-01-30', '07:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000007', '2032', '2021-01-30', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000008', '2062', '2021-01-30', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000009', '2049', '2021-01-30', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000010', '2042', '2021-01-30', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000011', '2068', '2021-01-30', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000012', '2069', '2021-01-30', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000013', '2075', '2021-01-30', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000014', '2028', '2021-01-30', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000015', '2034', '2021-01-30', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000016', '2006', '2021-01-30', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000017', '2005', '2021-01-30', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000018', '2072', '2021-01-30', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000019', '2066', '2021-01-30', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000020', '2065', '2021-01-30', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000021', '2046', '2021-01-30', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000022', '2014', '2021-01-30', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000023', '2039', '2021-01-30', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000024', '2067', '2021-01-30', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000025', '2035', '2021-01-30', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000026', '2026', '2021-01-30', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000027', '2008', '2021-01-30', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000028', '2070', '2021-01-30', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000029', '2036', '2021-01-30', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000030', '2019', '2021-01-30', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000031', '2061', '2021-01-30', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000032', '2050', '2021-01-30', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000033', '2056', '2021-01-30', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000034', '2053', '2021-01-30', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000035', '2011', '2021-01-30', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000036', '2017', '2021-01-30', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000037', '2038', '2021-01-30', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000038', '2024', '2021-01-30', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000039', '2048', '2021-01-30', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000040', '2045', '2021-01-30', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000041', '2044', '2021-01-30', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000042', '2012', '2021-01-30', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000043', '2001', '2021-01-30', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000044', '2013', '2021-01-30', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000045', '2029', '2021-01-30', '07:59:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000046', '2071', '2021-01-30', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000047', '2004', '2021-01-30', '08:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000048', '2031', '2021-01-30', '08:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000049', '2012', '2021-01-30', '10:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000050', '2027', '2021-01-30', '12:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000051', '2024', '2021-01-30', '13:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000052', '2042', '2021-01-30', '13:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000053', '2028', '2021-01-30', '13:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000054', '2038', '2021-01-30', '13:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000055', '2073', '2021-01-30', '13:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000056', '2050', '2021-01-30', '13:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000057', '2069', '2021-01-30', '13:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000058', '2039', '2021-01-30', '13:09:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000059', '2003', '2021-01-30', '13:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000060', '2013', '2021-01-30', '13:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000061', '2048', '2021-01-30', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000062', '2049', '2021-01-30', '13:11:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000063', '2032', '2021-01-30', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000064', '2044', '2021-01-30', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000065', '2071', '2021-01-30', '13:12:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000066', '2025', '2021-01-30', '13:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000067', '2017', '2021-01-30', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000068', '2001', '2021-01-30', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000069', '2062', '2021-01-30', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000070', '2008', '2021-01-30', '13:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000071', '2011', '2021-01-30', '13:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000072', '2056', '2021-01-30', '13:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000073', '2036', '2021-01-30', '13:18:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000074', '2061', '2021-01-30', '13:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000075', '2066', '2021-01-30', '13:21:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000076', '2005', '2021-01-30', '13:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000077', '2014', '2021-01-30', '13:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000078', '2006', '2021-01-30', '13:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000079', '2046', '2021-01-30', '13:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000080', '2047', '2021-01-30', '13:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000081', '2019', '2021-01-30', '13:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000082', '2004', '2021-01-30', '13:27:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000083', '2068', '2021-01-30', '13:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000084', '2065', '2021-01-30', '13:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000085', '2045', '2021-01-30', '13:39:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000086', '2072', '2021-01-30', '13:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000087', '2070', '2021-01-30', '13:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000088', '2067', '2021-01-30', '13:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000089', '2060', '2021-01-30', '13:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000090', '2031', '2021-01-30', '14:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000091', '2026', '2021-01-30', '14:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000092', '2035', '2021-01-30', '14:07:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000093', '2053', '2021-01-30', '14:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000094', '2034', '2021-01-30', '14:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013000000095', '2075', '2021-01-30', '15:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013100000001', '2026', '2021-01-31', '08:17:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013100000002', '2039', '2021-01-31', '08:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013100000003', '2039', '2021-01-31', '14:30:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021013100000004', '2026', '2021-01-31', '14:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000001', '2025', '2021-02-01', '07:22:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000002', '2046', '2021-02-01', '07:29:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000003', '2047', '2021-02-01', '07:34:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000004', '2073', '2021-02-01', '07:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000005', '2003', '2021-02-01', '07:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000006', '2067', '2021-02-01', '07:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000007', '2005', '2021-02-01', '07:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000008', '2049', '2021-02-01', '07:42:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000009', '2075', '2021-02-01', '07:44:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000010', '2032', '2021-02-01', '07:45:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000011', '2060', '2021-02-01', '07:46:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000012', '2062', '2021-02-01', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000013', '2006', '2021-02-01', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000014', '2069', '2021-02-01', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000015', '2042', '2021-02-01', '07:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000016', '2050', '2021-02-01', '07:48:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000017', '2068', '2021-02-01', '07:49:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000018', '2031', '2021-02-01', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000019', '2029', '2021-02-01', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000020', '2041', '2021-02-01', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000021', '2001', '2021-02-01', '07:50:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000022', '2019', '2021-02-01', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000023', '2028', '2021-02-01', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000024', '2056', '2021-02-01', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000025', '2008', '2021-02-01', '07:51:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000026', '2004', '2021-02-01', '07:52:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000027', '2070', '2021-02-01', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000028', '2039', '2021-02-01', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000029', '2065', '2021-02-01', '07:53:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000030', '2026', '2021-02-01', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000031', '2014', '2021-02-01', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000032', '2061', '2021-02-01', '07:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000033', '2072', '2021-02-01', '07:55:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000034', '2035', '2021-02-01', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000035', '2036', '2021-02-01', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000036', '2038', '2021-02-01', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000037', '2024', '2021-02-01', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000038', '2053', '2021-02-01', '07:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000039', '2011', '2021-02-01', '07:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000040', '2013', '2021-02-01', '07:58:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000041', '2012', '2021-02-01', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000042', '2045', '2021-02-01', '08:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000043', '2044', '2021-02-01', '08:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000044', '2071', '2021-02-01', '08:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000045', '2018', '2021-02-01', '09:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000046', '2018', '2021-02-01', '13:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000047', '2069', '2021-02-01', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000048', '2038', '2021-02-01', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000049', '2028', '2021-02-01', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000050', '2029', '2021-02-01', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000051', '2039', '2021-02-01', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000052', '2036', '2021-02-01', '16:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000053', '2024', '2021-02-01', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000054', '2042', '2021-02-01', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000055', '2032', '2021-02-01', '16:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000056', '2030', '2021-02-01', '16:04:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000057', '2025', '2021-02-01', '16:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000058', '2073', '2021-02-01', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000059', '2003', '2021-02-01', '16:10:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000060', '2044', '2021-02-01', '16:14:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000061', '2053', '2021-02-01', '16:15:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000062', '2060', '2021-02-01', '16:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000063', '2013', '2021-02-01', '16:19:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000064', '2004', '2021-02-01', '16:23:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000065', '2061', '2021-02-01', '16:24:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000066', '2011', '2021-02-01', '16:26:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000067', '2026', '2021-02-01', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000068', '2035', '2021-02-01', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000069', '2031', '2021-02-01', '16:31:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000070', '2071', '2021-02-01', '16:32:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000071', '2049', '2021-02-01', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000072', '2050', '2021-02-01', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000073', '2062', '2021-02-01', '16:33:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000074', '2001', '2021-02-01', '16:35:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000075', '2006', '2021-02-01', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000076', '2046', '2021-02-01', '16:54:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000077', '2045', '2021-02-01', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000078', '2056', '2021-02-01', '16:56:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000079', '2005', '2021-02-01', '16:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000080', '2047', '2021-02-01', '17:00:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000081', '2072', '2021-02-01', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000082', '2068', '2021-02-01', '17:01:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000083', '2065', '2021-02-01', '17:02:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000084', '2070', '2021-02-01', '17:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000085', '2008', '2021-02-01', '17:03:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000086', '2041', '2021-02-01', '17:05:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000087', '2067', '2021-02-01', '17:06:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000088', '2019', '2021-02-01', '17:16:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000089', '2014', '2021-02-01', '17:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000090', '2012', '2021-02-01', '17:57:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000091', '2075', '2021-02-01', '19:08:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021020100000092', '2027', '2021-02-01', '22:47:00', 'MESIN  BELAKANG', 'Y', 1, '2021-02-18'),
('2021022400000001', '4648', '2021-02-24', '22:51:00', 'Edit', 'Y', 2, '2021-02-24'),
('2021022500000001', '4648', '2021-02-25', '07:05:00', 'Edit', 'Y', 2, '2021-02-24'),
('2021022500000002', '2072', '2021-02-25', '07:30:00', 'Edit', 'Y', 1, '2021-03-25'),
('2021022500000003', '2072', '2021-02-25', '16:50:00', 'Edit', 'Y', 1, '2021-03-25'),
('2021022600000001', '4649', '2021-02-26', '22:21:00', 'Edit', 'Y', 2, '2021-02-24'),
('2021022700000001', '4649', '2021-02-27', '06:21:00', 'Edit', 'Y', 2, '2021-02-24'),
('2021022700000002', '4649', '2021-02-27', '16:23:00', 'Edit', 'Y', 2, '2021-02-24'),
('2021022700000003', '4649', '2021-02-27', '21:23:00', 'Edit', 'Y', 2, '2021-02-24');

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
(1, 'A&D', 'Y', 2, '2021-02-18'),
(2, 'ALKES', 'Y', 2, '2021-02-11'),
(3, 'DESIGN GRAFIS', 'Y', 2, '2021-02-11'),
(4, 'DIREKSI', 'Y', 2, '2021-02-11'),
(5, 'EXIM', 'Y', 2, '2021-02-11'),
(6, 'F&A', 'Y', 2, '2021-02-11'),
(7, 'GUDANG', 'Y', 2, '2021-02-11'),
(8, 'HRD', 'Y', 2, '2021-02-11'),
(9, 'INJECTION', 'Y', 2, '2021-02-11'),
(10, 'IT', 'Y', 2, '2021-02-11'),
(11, 'MAINTENANCE', 'Y', 2, '2021-02-11'),
(12, 'PEMBELIAN', 'Y', 2, '2021-02-11'),
(13, 'PPIC', 'Y', 2, '2021-02-11'),
(14, 'QUALITY CONTROL', 'Y', 2, '2021-02-11'),
(15, 'R&D', 'Y', 2, '2021-02-11'),
(16, 'REGISTRASI', 'Y', 2, '2021-02-11'),
(17, 'SYRINGE', 'Y', 2, '2021-02-11'),
(18, 'UMUM', 'Y', 2, '2021-02-11'),
(19, 'divisi baru', 'N', 2, '2021-02-16'),
(20, 'PENJUALAN', 'Y', 1, '2021-02-18'),
(21, 'divisi 21', 'N', 2, '2021-02-18'),
(22, 'batu 22', 'N', 2, '2021-02-22'),
(23, 'ELEKTROMEDIK', 'Y', 2, '2021-02-24'),
(24, 'A&T', 'N', 1, '2021-03-01'),
(25, 'A&T', 'Y', 1, '2021-03-02');

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
(1, 'Karyawan', 'Y', 2, '2021-02-11'),
(2, 'Staff', 'Y', 2, '2021-02-11'),
(3, 'Manager', 'Y', 1, '2021-02-18'),
(4, 'jabatan new', 'N', 2, '2021-02-18'),
(5, 'jabjab', 'N', 2, '2021-02-22'),
(6, 'CEO', 'N', 1, '2021-03-02'),
(7, 'jabatan a', 'Y', 1, '2021-03-04'),
(8, 'Manager', 'N', 1, '2021-03-08'),
(9, 'asdsadsda', 'N', 1, '2021-03-08'),
(10, '11asada', 'N', 1, '2021-03-08'),
(11, 'baruaaaaf', 'N', 1, '2021-03-29');

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
(1, 'Pagi', '07:00:00', '15:00:00', '07:00:00', '12:00:00', 'Y', 2, '2021-02-17'),
(2, 'Pagi 2', '07:30:00', '15:30:00', '07:30:00', '12:30:00', 'Y', 2, '2021-02-17'),
(3, 'Sore', '15:00:00', '23:00:00', '12:00:00', '17:00:00', 'Y', 2, '2021-02-17'),
(4, 'Pagi 3', '08:00:00', '16:00:00', '08:00:00', '12:00:00', 'Y', 1, '2021-03-25'),
(5, 'Malam', '23:00:00', '07:00:00', '17:00:00', '22:00:00', 'Y', 2, '2021-02-17'),
(6, 'Shift Baruuuuu', '14:29:00', '14:29:00', '14:29:00', '14:29:00', 'N', 2, '2021-02-22'),
(7, 'Pagi 4', '06:00:00', '12:00:00', '06:30:00', '12:00:00', 'N', 1, '2021-03-02'),
(8, 'Pagi 4', '06:00:00', '00:00:00', '06:30:00', '00:00:00', 'N', 1, '2021-03-01');

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
(1, '2072', 4, '2021-01-26', 'Y', '2021-03-25', 1),
(2, '2072', 4, '2021-01-27', 'Y', '2021-03-25', 1),
(3, '2072', 4, '2021-01-28', 'Y', '2021-03-25', 1),
(4, '2072', 4, '2021-01-29', 'Y', '2021-03-25', 1),
(5, '2072', 4, '2021-01-30', 'Y', '2021-03-25', 1),
(6, '2072', 4, '2021-02-01', 'Y', '2021-03-25', 1),
(7, '2072', 4, '2021-02-02', 'Y', '2021-03-25', 1),
(8, '2072', 4, '2021-02-03', 'Y', '2021-03-25', 1),
(9, '2072', 4, '2021-02-04', 'Y', '2021-03-25', 1),
(10, '2072', 4, '2021-02-05', 'Y', '2021-03-25', 1),
(11, '2072', 4, '2021-02-06', 'Y', '2021-03-25', 1),
(12, '2072', 4, '2021-02-08', 'Y', '2021-03-25', 1),
(13, '2072', 4, '2021-02-09', 'Y', '2021-03-25', 1),
(14, '2072', 4, '2021-02-10', 'Y', '2021-03-25', 1),
(15, '2072', 4, '2021-02-11', 'Y', '2021-03-25', 1),
(16, '2072', 4, '2021-02-12', 'Y', '2021-03-25', 1),
(17, '2072', 4, '2021-02-13', 'Y', '2021-03-25', 1),
(18, '2072', 4, '2021-02-15', 'Y', '2021-03-25', 1),
(19, '2072', 4, '2021-02-16', 'Y', '2021-03-25', 1),
(20, '2072', 4, '2021-02-17', 'Y', '2021-03-25', 1),
(21, '2072', 4, '2021-02-18', 'Y', '2021-03-25', 1),
(22, '2072', 4, '2021-02-19', 'Y', '2021-03-25', 1),
(23, '2072', 4, '2021-02-20', 'Y', '2021-03-25', 1),
(24, '2072', 4, '2021-02-22', 'Y', '2021-03-25', 1),
(25, '2072', 4, '2021-02-23', 'Y', '2021-03-25', 1),
(26, '2072', 4, '2021-02-24', 'Y', '2021-03-25', 1),
(27, '2072', 4, '2021-02-25', 'Y', '2021-03-25', 1);

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

--
-- Dumping data for table `master_kalender`
--

INSERT INTO `master_kalender` (`id_kalender`, `nama_hari`, `jenis_hari`, `tanggal_mulai`, `tanggal_akhir`, `jumlah_hari`, `status_kalender`, `change_by`, `change_at`) VALUES
(1, 'Cuti Bersama', 'Cuti Bersama', '2021-02-08', '2021-02-08', 1, 'Y', 2, '2021-02-22'),
(6, 'Imlek', 'Hari Libur', '2021-02-12', '2021-02-13', 2, 'Y', 1, '2021-03-25'),
(7, 'Cuti Bersama', 'Cuti Bersama', '2020-11-01', '2020-11-01', 1, 'N', 1, '2021-03-25'),
(9, 'Cuti Bersama 4', 'Hari Libur', '2021-03-01', '2021-03-06', 6, 'N', 1, '2021-03-25'),
(10, 'Cuti Bersama 6', 'Hari Libur', '2021-03-02', '2021-03-06', 5, 'N', 1, '2021-03-02'),
(11, 'Libur', 'Hari Libur', '2021-02-08', '2021-02-13', 6, 'N', 1, '2021-03-25'),
(12, 'Libur', 'Hari Libur', '2021-01-11', '2021-01-16', 6, 'N', 1, '2021-03-25');

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
  `nik` varchar(16) DEFAULT NULL,
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
  `plant` varchar(25) NOT NULL,
  `ikut_penggajian` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_karyawan`
--

INSERT INTO `master_karyawan` (`auto_id`, `id_karyawan`, `pin`, `id_jabatan`, `id_divisi`, `nama_karyawan`, `nik`, `no_ktp`, `npwp`, `jenis_kelamin_karyawan`, `tanggal_masuk_karyawan`, `tanggal_keluar_karyawan`, `status_karyawan`, `telp_karyawan`, `tempat_lahir_karyawan`, `tanggal_lahir_karyawan`, `alamat_karyawan`, `tanggal_pengangkatan`, `keterangan`, `k_tk`, `pendidikan`, `pkwt1`, `pkwt2`, `gaji_pokok`, `tunjangan_jabatan`, `bpjs_kesehatan`, `plant`, `ikut_penggajian`, `change_by`, `change_at`) VALUES
(2001, '2001', '2001', 1, 20, 'KUMIATI ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 2, '2021-02-22'),
(2003, '2003', '2003', 1, 6, 'VERONICA  HANDJOJO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2004, '2004', '2004', 1, 6, 'ANNA PRATIWI WULANDARI', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2005, '2005', '2005', 1, 8, 'PIPIN  SAVITRI YUSOVIN', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2006, '2006', '2006', 1, 6, 'RETNOWATI ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2007, '2007', '2007', 1, 6, 'JULIA SUNDARI   WONGSOWINOTO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2008, '2008', '2008', 1, 16, 'LIA  AGUSTINA', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2011, '2011', '2011', 1, 6, 'NOFARINA MUSHLIHAH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2012, '2012', '2012', 1, 5, 'FATIMATUS  SEHRO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2013, '2013', '2013', 1, 5, 'MARIYATUL ULFA', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2014, '2014', '2014', 1, 16, 'HELIAWATI ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2017, '2017', '2017', 1, 4, 'HERLIEN SRI ARIANI', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2018, '2018', '2018', 1, 4, 'FRANS HENDRATA ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2019, '2019', '2019', 1, 4, 'USWATUN  CHASANAH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2024, '2024', '2024', 1, 7, 'NUR  SANIYAH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2025, '2025', '2025', 1, 7, 'MULIADI ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2026, '2026', '2026', 1, 7, 'DIDIK TJANDRA WAHONO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2027, '2027', '2027', 1, 1, 'RUDI HANSAH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2028, '2028', '2028', 1, 7, 'ERWANTO ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2029, '2029', '2029', 1, 7, 'IBNU SUFYAN', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2030, '2030', '2030', 1, 7, 'ENTYK  SUSILOWATI', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2031, '2031', '2031', 1, 7, 'EKO   PURWANTININGSIH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2032, '2032', '2032', 1, 7, 'NASHORI WIJAYANTO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2034, '2034', '2034', 1, 7, 'DEWI  SURYANINGSIH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2035, '2035', '2035', 1, 7, 'DEDI   SETIAWAN', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2036, '2036', '2036', 1, 7, 'ANANG   SUGIANTORO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2038, '2038', '2038', 1, 7, 'FARRIH   SUJATMIKO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2039, '2039', '2039', 1, 7, 'MUAMAR KADAFI FIRDAUS', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2041, '2041', '2041', 1, 13, 'RUDIK  HARIYANTO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2042, '2042', '2042', 1, 7, 'ZULIATIN PRETTY   CAHYANINGSEH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2044, '2044', '2044', 1, 12, 'ANAS HELMY  FAIDZIN', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2045, '2045', '2045', 1, 12, 'MUHAMMAD   BILAL', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2046, '2046', '2046', 1, 6, 'ARIESTA MAHARANNY  WAHYUNINGTYAS', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2047, '2047', '2047', 1, 6, 'LINNARTI  ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2048, '2048', '2048', 1, 13, 'ABDULLOH   AFIF R', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2049, '2049', '2049', 1, 12, 'EVY  SETYANINGSIH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2050, '2050', '2050', 1, 13, 'RUSYDINA  FIRDAUSI', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2053, '2053', '2053', 1, 7, 'AHMAD HASIM MAHRUS', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2056, '2056', '2056', 1, 3, 'YOGYANTONO ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2060, '2060', '2060', 3, 4, 'GOENADI ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2061, '2061', '2061', 1, 16, 'MARDIYANA ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2062, '2062', '2062', 1, 12, 'NINA WIDAYATI', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2065, '2065', '2065', 1, 6, 'ROHMATAYALALI ', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2066, '2066', '2066', 1, 6, 'AGUNG FIRMANSYAH', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2067, '2067', '2067', 1, 10, 'MERVIN JORDAN JOPITER', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2068, '2068', '2068', 1, 6, 'DIMAS RIAN LAKSANA PUTRA', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2069, '2069', '2069', 1, 7, 'RAF SANJANI', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2070, '2070', '2070', 1, 10, 'OKMAH INDAH  MAYASARI S.', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2071, '2071', '2071', 1, 6, 'ARIF RAHMAN SIDY PRATAMA', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2072, '2072', '2072', 2, 10, 'AFIF NUZIA AL ASADI', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', 5000000, 100000, 'N', 'Krian', 'Y', 1, '0000-00-00'),
(2073, '2073', '2073', 2, 6, 'YASHINTA TANONE', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2074, '2074', '2074', 1, 18, 'AGUNG  BUDIHARJO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(2075, '2075', '2075', 3, 6, 'STEVEN JAQUAR TANDJOJO', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(4646, '4646', '4646', 1, 18, '-', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '0000-00-00'),
(4647, '4647', '1234', 1, 3, 'karyawan coba', '1231', '1234567891234561', '', 'L', '2021-01-01', '0000-00-00', 'N', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 2, '2021-02-23'),
(4648, '4648', '12121212', 1, 10, 'karyawan coba jadwal', '1233333333', '1234567891234561', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 2, '2021-02-24'),
(4649, '4649', '122222', 1, 5, 'karyawan coba jadwal 2', '123456', '1234567891234561', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 2, '2021-02-24'),
(4650, '4650', '6969', 1, 1, 'Rifki Maulana', '123456789123456', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'N', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '2021-03-01'),
(4651, '4651', '6969', 1, 1, 'Muzakki', '123456789123456', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y\r\n', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '2021-03-01'),
(4652, '4652', '6966', 1, 1, 'Muzakki', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'N', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '2021-03-01'),
(4653, '4653', '2987', 1, 1, 'Rifki Maulana', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'N', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '2021-03-02'),
(4654, '4654', '9876', 7, 1, 'Rifki Maulana', '1234567891234560', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '08888888888880', 'Surabaya', '2000-07-01', 'Surabaya', '2021-03-03', 'Karyawan', 'Tidak Kontrak', 'Mahasiswa', '', '', NULL, 0, 'Y', 'Krian', 'Y', 1, '2021-03-10'),
(4655, '4655', '123445', 1, 3, 'antonius vespucchi', '12341231', '1234567891234567', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Kontrak', '', '', '', 5000000, 0, 'Y', 'Krian', 'Y', 1, '2021-03-24');

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

--
-- Dumping data for table `master_lembur`
--

INSERT INTO `master_lembur` (`id_lembur`, `id_karyawan`, `pilih_lembur`, `tanggal_lembur`, `jam_mulai`, `jam_akhir`, `ambil_jam`, `uraian_kerja`, `persetujuan`, `change_at`, `no_iso`, `status_lembur`, `change_by`) VALUES
(1, '2007', 'Lembur Biasa', '2021-02-26', '16:00:00', '23:00:00', 6.5, 'Menambahkan edit ...', 'Y', '2021-03-05 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1),
(2, '4648', 'Lembur Biasa', '2021-02-01', '17:18:00', '22:18:00', 4.5, 'Menambahkan ...', 'Y', '2021-02-24 00:00:00', 'Form / HRD / 013 Rev.01', 'N', 2),
(3, '2011', 'Lembur Biasa', '2021-03-02', '18:00:00', '20:00:00', 2, 'Lembur 4', 'Y', '2021-03-01 00:00:00', 'Form / HRD / 013 Rev.01', 'N', 1),
(4, '2017', 'Lembur Biasa', '2021-03-02', '16:00:00', '19:00:00', 3, 'Lembur 2', 'Y', '2021-03-05 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1),
(5, '4654', 'Lembur Biasa', '2021-03-04', '16:00:00', '20:00:00', 3.5, 'aaaa', 'Y', '2021-03-04 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1),
(6, '4654', 'Lembur Biasa', '2021-03-10', '16:00:00', '19:00:00', 3, 'kkkk', 'Y', '2021-03-05 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1),
(7, '4654', 'Lembur Biasa', '2021-03-16', '07:00:00', '19:00:00', 11.5, 'Lembur', 'Y', '2021-03-15 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1),
(8, '2001', 'Lembur Libur', '2021-03-15', '07:00:00', '19:00:00', 11.5, 'Lembur 2', 'Y', '2021-03-15 00:00:00', 'Form / HRD / 013 Rev.01', 'N', 1),
(9, '2074', 'Lembur Libur', '2021-03-16', '08:00:00', '20:00:00', 11, 'Lembur 2', 'Y', '2021-03-15 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1),
(10, '4654', 'Lembur Libur', '2021-03-16', '08:00:00', '15:00:00', 7, 'aaa', 'Y', '2021-03-15 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1),
(11, '2025', 'Lembur Biasa', '2021-03-01', '07:00:00', '20:00:00', 12.5, 'alas', 'Y', '2021-03-15 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1);

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

--
-- Dumping data for table `master_umk`
--

INSERT INTO `master_umk` (`id_umk`, `tahun_umk`, `total_umk`, `gaji_per_jam`, `status_umk`, `change_by`, `change_at`) VALUES
(1, 2019, 17300, 100, 'N', 2, '2021-02-18'),
(2, 2020, 1730000, 10000, 'Y', 1, '2021-03-29'),
(3, 2018, 34600, 200, 'N', 2, '2021-02-18'),
(4, 2011, 12312312, 0, 'N', 2, '2021-02-23'),
(5, 212222, 12321323, 0, 'N', 2, '2021-02-23'),
(6, 2021, 4200000, 0, 'N', 1, '2021-03-01'),
(7, 2021, 4200000, 0, 'N', 1, '2021-03-02'),
(8, 2021, 4293582, 15341, 'Y', 1, '2021-03-23');

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
(1, '4649', 2021, 0, 0, 2, '2021-02-24', '2021-02-25', 'Alasan', 'Y', 'N', 'Form / HRD / 017-Rev00', 'N', 1, '2021-03-15'),
(2, '4649', 2021, 0, 0, 2, '2021-02-22', '2021-02-23', 'Alasan Cuti 11111', 'Y', 'Y', 'Form / HRD / 017-Rev00', 'Y', 1, '2021-02-24'),
(3, '2011', 2021, 0, 0, 2, '2021-03-02', '2021-03-03', 'Keperluan', 'Y', 'N', 'Form / HRD / 017-Rev00', 'Y', 1, '2021-03-02'),
(4, '2014', 2021, 0, 0, 2, '2021-03-02', '2021-03-03', 'Keperluan', 'Y', 'N', 'Form / HRD / 017-Rev00', 'Y', 1, '2021-03-02'),
(5, '2027', 2021, 0, 0, 2, '2021-03-02', '2021-03-03', 'Keperluan', 'Y', 'N', 'Form / HRD / 017-Rev00', 'Y', 1, '2021-03-02'),
(6, '2028', 2021, 0, 0, 2, '2021-03-03', '2021-03-04', 'keperluan', 'Y', 'N', 'Form / HRD / 017-Rev00', 'Y', 1, '2021-03-02'),
(7, '2029', 2021, 0, 0, 2, '2021-03-02', '2021-03-03', 'Keperluan', 'Y', 'N', 'Form / HRD / 017-Rev00', 'N', 1, '2021-03-03'),
(8, '4649', 2021, 0, 0, 2, '2021-03-02', '2021-03-03', 'coba', 'Y', 'N', 'Form / HRD / 017-Rev00', 'N', 1, '2021-03-03'),
(9, '2075', 2021, 0, 0, 2, '2021-03-16', '2021-03-17', 'cuti', 'Y', 'N', 'Form / HRD / 017-Rev00', 'Y', 1, '2021-03-15'),
(10, '2072', 2021, 11, 10, 1, '2021-01-29', '2021-01-29', 'aaaaaa', 'Y', 'N', 'Form / HRD / 017-Rev.00', 'Y', 1, '2021-03-25');

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
('1', '2072', 2021, 1, 100000, NULL, NULL, 'Y', 1, '2021-03-19'),
('2', '2017', 2021, 1, 0, 200000, 100000, 'Y', 1, '2021-03-23'),
('3', '2005', 2021, 1, 100000, 0, 100000, 'Y', 1, '2021-03-19'),
('4', '2001', 2021, 1, 20000, NULL, NULL, 'Y', 1, '2021-03-23'),
('5', '2004', 2021, 1, NULL, 0, 100000, 'Y', 1, '2021-03-23'),
('6', '2004', 0, 0, NULL, NULL, 12000, 'Y', 1, '2021-03-23'),
('7', '2003', 0, 0, NULL, NULL, 123, 'Y', 1, '2021-03-23'),
('8', '2006', 2021, 1, NULL, NULL, 1000000, 'Y', 1, '2021-03-23');

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

--
-- Dumping data for table `transaksi_potong_absen`
--

INSERT INTO `transaksi_potong_absen` (`id_potong_absen`, `id_karyawan`, `tahun`, `bulan`, `total_hari`, `alasan_potong`, `status_potong`, `change_by`, `change_at`) VALUES
(1, '2017', 2021, 2, 2, 'alasan', 'Y', 1, '2021-03-16'),
(2, '2019', 2020, 3, 5, 'alasan', 'Y', 1, '2021-03-16'),
(3, '2003', 2021, 1, 2, 'Alasan 11', 'Y', 1, '2021-03-29');

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
  `persetujuan_kabag` char(1) NOT NULL,
  `persetujuan_hrd` char(1) NOT NULL,
  `no_iso` varchar(50) NOT NULL,
  `status_ijin` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaksi_surat_ijin`
--

INSERT INTO `transaksi_surat_ijin` (`id_surat_ijin`, `id_karyawan`, `tanggal_ijin`, `alasan_ijin`, `pilih_jam`, `jam_datang_keluar_ijin`, `persetujuan_kabag`, `persetujuan_hrd`, `no_iso`, `status_ijin`, `change_by`, `change_at`) VALUES
(1, '2042', '2021-01-03', 'aaaaaaaa', '', '12:30:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 2, '2021-02-23'),
(2, '2031', '2021-01-03', 'Alasan Izin...', 'Jam Keluar', '12:30:00', 'Y', 'N', 'Form/HRD/018-Rev.01', 'Y', 16, '2021-03-29'),
(3, '2018', '2021-01-04', 'Ada urusan mendadak', 'Jam Keluar', '12:00:00', 'Y', 'N', 'Form/HRD/018-Rev.01', 'Y', 16, '2021-03-29'),
(4, '4648', '2021-02-26', 'Ada urusan mendadak', '', '23:07:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 2, '2021-02-24'),
(5, '4649', '2021-02-26', 'Ada urusan mendadak', 'Jam Datang', '23:22:00', 'Y', 'N', 'Form/HRD/018-Rev.01', 'Y', 16, '2021-03-29'),
(6, '4649', '2021-02-27', 'alasan izin alasan izin alasan izin', '', '18:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 1, '2021-03-15'),
(7, '2001', '2021-03-02', 'sakit 3', '', '06:40:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 1, '2021-03-01'),
(8, '2026', '2021-03-02', 'Keperluan...', '', '11:54:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 1, '2021-03-03'),
(9, '4654', '2021-03-16', 'Alasan', '', '08:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 1, '2021-03-15'),
(10, '2073', '2021-03-16', 'alasan', '', '07:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 1, '2021-03-15'),
(11, '4654', '2021-03-16', 'alasan', 'Jam Datang', '08:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 1, '2021-03-15'),
(12, '2028', '2021-03-16', 'sakit', 'Jam Datang', '15:00:00', 'N', 'N', 'Form/HRD/018-Rev.01', 'N', 1, '2021-03-15'),
(13, '4654', '2021-03-16', 'alasan', 'Jam Datang', '07:00:00', 'Y', 'N', 'Form/HRD/018-Rev.01', 'Y', 16, '2021-03-29'),
(14, '2017', '2021-01-04', 'alasan datang', 'Jam Datang', '10:30:00', 'D', 'N', 'Form/HRD/018-Rev.01', 'Y', 16, '2021-03-29'),
(15, '2072', '2021-01-27', 'alasan datang', 'Jam Datang', '10:30:00', 'D', 'N', 'Form/HRD/018-Rev.01', 'Y', 16, '2021-03-29'),
(16, '2072', '2021-02-17', 'Ke Mojoagung', 'Jam Keluar', '10:00:00', 'D', 'N', 'Form/HRD/018-Rev.01', 'Y', 16, '2021-03-29');

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
(1, '2001', 'admin', '21232f297a57a5a743894a0e4a801fc3', 2, 'Y', '2021-03-16', 1),
(2, '2072', 'admin2', 'c84258e9c39059a89ab77d846ddab909', 5, 'Y', '2021-03-16', 1),
(3, '2072', 'afif', 'b56776aa98086825550ff0c3fe260907', 3, 'Y', '2021-03-16', 1),
(4, '2067', 'mervin', '171f8fdaf2898d6e95d0238fa045259b', 6, 'Y', '2021-03-16', 1),
(5, '4646', 'admin0', '62f04a011fbb80030bb0a13701c20b41', 0, 'N', '2021-02-23', 2),
(6, '4646', 'rifki', '2a5c4c5a5ba1c332279685ddec507cd9', 0, 'N', '2021-02-23', 2),
(7, '2024', 'admin admin', '21232f297a57a5a743894a0e4a801fc3', 0, 'N', '2021-03-01', 1),
(8, '2001', 'admin5', '26a91342190d515231d7238b0c5438e1', 0, 'N', '2021-03-01', 1),
(9, '2026', 'didik2', '2ff462bc49e322708a48d3d5e3ca4bab', 0, 'N', '2021-03-01', 1),
(10, '2026', 'didik', '2ff462bc49e322708a48d3d5e3ca4bab', 0, 'N', '2021-03-01', 1),
(11, '2013', 'admin7', '788073cefde4b240873e1f52f5371d7d', 0, 'N', '2021-03-01', 1),
(12, '2024', 'nur', 'b55178b011bfb206965f2638d0f87047', 0, 'N', '2021-03-01', 1),
(13, '2025', 'mu', '89aa4b196b48c8a13a6549bb1eaebd80', 0, 'N', '2021-03-01', 1),
(14, '2001', 'rifki', '827ccb0eea8a706c4c34a16891f84e7b', 0, 'N', '2021-03-02', 1),
(15, '2028', 'serwanto', '81dc9bdb52d04dc20036dbd8313ed055', 1, 'Y', '2021-03-16', 1),
(16, '2025', 'muliadi', '81dc9bdb52d04dc20036dbd8313ed055', 4, 'Y', '2021-03-16', 1);

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
  MODIFY `id_jabatan` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `master_jam_kerja`
--
ALTER TABLE `master_jam_kerja`
  MODIFY `id_jam_kerja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `master_kalender`
--
ALTER TABLE `master_kalender`
  MODIFY `id_kalender` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `master_lembur`
--
ALTER TABLE `master_lembur`
  MODIFY `id_lembur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `master_umk`
--
ALTER TABLE `master_umk`
  MODIFY `id_umk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `transaksi_cuti`
--
ALTER TABLE `transaksi_cuti`
  MODIFY `id_cuti` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `transaksi_surat_ijin`
--
ALTER TABLE `transaksi_surat_ijin`
  MODIFY `id_surat_ijin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

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
