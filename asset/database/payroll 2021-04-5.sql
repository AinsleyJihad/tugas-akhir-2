-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 05, 2021 at 04:24 AM
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

CREATE DEFINER=`root`@`localhost` FUNCTION `getGajiPokok` (`tahun` INT, `plant` VARCHAR(25)) RETURNS INT(11) BEGIN
  	DECLARE gp int DEFAULT 0;

    SELECT master_umk.total_umk into gp
    FROM master_umk
    WHERE master_umk.tahun_umk = tahun AND
          master_umk.status_umk = 'Y' AND
          master_umk.plant = plant;
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

--
-- Dumping data for table `history_jd_kerja_kyw`
--

INSERT INTO `history_jd_kerja_kyw` (`id_jadwal`, `id_karyawan`, `id_jam_kerja`, `tanggal_jadwal`, `status`, `reason`, `change_by`, `change_at`) VALUES
(2, '2072', 3, '2021-01-06', 'Y', 'Create', 2, '2021-04-02'),
(3, '178', 3, '2021-03-01', 'Y', 'Create', 2, '2021-04-02'),
(4, '178', 3, '2021-03-02', 'Y', 'Create', 2, '2021-04-02'),
(5, '178', 3, '2021-03-03', 'Y', 'Create', 2, '2021-04-02');

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
('2072', '2072', 2, 10, 'AFIF NUZIA AL ASADI', '', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', 5000000, 100000, 'N', 'Krian', 'Y', 'Edit', 1, '2021-03-31');

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
(1, '2072', 'Lembur Libur', '2021-03-02', '16:00:00', '20:00:00', 4, 'Lembur', 'Y', 'Form / HRD / 013 Rev.01', 'Y', 'Create', 1, '2021-03-30');

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
(1, '2072', '2021-01-06', 'Ke Mojoagung', 'Jam Keluar', '10:30:00', 'Y', 'Y', 'Form/HRD/018-Rev.01', 'Y', 'Create', 2, '2021-04-02'),
(1, '2072', '2021-01-06', 'Ke Mojoagung', 'Jam Datang', '10:30:00', '', '', 'Form/HRD/018-Rev.01', 'Y', 'Edit', 2, '2021-04-02');

-- --------------------------------------------------------

--
-- Table structure for table `history_umk`
--

CREATE TABLE `history_umk` (
  `id_umk` int(11) NOT NULL,
  `tahun_umk` int(11) NOT NULL,
  `total_umk` int(11) NOT NULL,
  `gaji_per_jam` int(11) NOT NULL,
  `plant` varchar(25) NOT NULL,
  `status_umk` char(1) NOT NULL,
  `reason` varchar(20) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_umk`
--

INSERT INTO `history_umk` (`id_umk`, `tahun_umk`, `total_umk`, `gaji_per_jam`, `plant`, `status_umk`, `reason`, `change_by`, `change_at`) VALUES
(1, 2021, 4293582, 15341, 'Krian', 'Y', 'Create', 1, '2021-03-29'),
(1, 2021, 4293582, 15340, 'Krian', 'Y', 'Edit', 1, '2021-03-29'),
(1, 2021, 4293582, 15341, 'Krian', 'Y', 'Edit', 1, '2021-03-29');

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
(2, '2072', 'hrd', '4bf31e6f4b818056eaacb83dff01c9b8', 2, 'Y', 'Create', 1, '2021-03-29'),
(3, '2072', 'do', 'd4579b2688d675235f402f6b4b43bcbf', 3, 'Y', 'Create', 1, '2021-03-29'),
(4, '2072', 'kbag', 'ab834cb539e64c1bf02ecf83725195fe', 4, 'Y', 'Create', 1, '2021-03-29'),
(5, '2072', 'karyawan', '9e014682c94e0f2cc834bf7348bda428', 5, 'Y', 'Create', 1, '2021-03-29'),
(6, '2072', 'su', '0b180078d994cb2b5ed89d7ce8e7eea2', 1, 'Y', 'Create', 1, '2021-03-29');

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
('00000001', '12', '0000-00-00', '00:00:00', '', 'N', 2, '2021-03-31'),
('2021010300000001', '2072', '2021-01-03', '06:59:00', 'MESIN  BELAKANG', 'N', 1, '2021-02-18'),
('2021010400000001', '2072', '2021-01-04', '07:53:00', 'MESIN  BELAKANG', 'Y', 2, '2021-03-31'),
('2021010400000002', '2072', '2021-01-04', '07:54:00', 'MESIN  BELAKANG', 'Y', 2, '2021-03-31'),
('2021010400000003', '2072', '2021-01-04', '16:49:00', 'MESIN  BELAKANG', 'Y', 2, '2021-03-31'),
('2021010500000001', '2072', '2021-01-05', '07:54:00', 'MESIN  BELAKANG', 'Y', 2, '2021-03-31'),
('2021010500000002', '2072', '2021-01-05', '16:46:00', 'MESIN  BELAKANG', 'Y', 2, '2021-03-31'),
('2021010600000001', '2072', '2021-01-06', '07:56:00', 'MESIN  BELAKANG', 'Y', 2, '2021-03-31'),
('2021010600000002', '2072', '2021-01-06', '17:23:00', 'MESIN  BELAKANG', 'Y', 2, '2021-03-31');

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
(1, 'SALES', 'Y', 1, '2021-01-01'),
(2, 'KASIR', 'Y', 1, '2021-01-01'),
(3, 'HRD', 'Y', 1, '2021-01-01'),
(4, 'A & D', 'Y', 1, '2021-01-01'),
(5, 'ACCOUNTING', 'Y', 1, '2021-01-01'),
(6, 'CONTROLLING', 'Y', 1, '2021-01-01'),
(7, 'PEMEBELIAN', 'Y', 1, '2021-01-01'),
(8, 'EXIM', 'Y', 1, '2021-01-01'),
(9, 'TAX', 'Y', 1, '2021-01-01'),
(10, 'IT', 'Y', 2, '2021-02-11'),
(11, 'PPIC', 'Y', 1, '2021-01-01'),
(12, 'F & A', 'Y', 1, '2021-01-01'),
(13, 'GA', 'Y', 1, '2021-01-01'),
(14, 'HD SOLUTION\r\n', 'Y', 1, '2021-01-01'),
(15, 'QC ', 'Y', 1, '2021-01-01'),
(16, 'DESIGN', 'Y', 1, '2021-01-01'),
(17, 'FINANCE', 'Y', 1, '2021-01-01'),
(18, 'TEHNIK', 'Y', 1, '2021-01-01'),
(19, 'QC ELETROMEDIK', 'Y', 1, '2021-01-01'),
(20, 'R & D', 'Y', 1, '2021-01-01'),
(21, 'OPERASIONAL', 'Y', 1, '2021-01-01'),
(22, 'DIREKSI', 'Y', 1, '2021-01-01'),
(23, 'ALKES', 'Y', 1, '2021-01-01'),
(24, 'UPAD', 'Y', 1, '2021-01-01'),
(25, 'JAHIT', 'Y', 1, '2021-01-01'),
(26, 'ASSEMBLING', 'Y', 1, '2021-01-01'),
(27, 'ELEKTROMEDIK', 'Y', 1, '2021-01-01'),
(28, 'GUDANG', 'Y', 1, '2021-01-01'),
(29, 'INJECTION', 'Y', 1, '2021-01-01'),
(30, 'MTP', 'Y', 1, '2021-01-01'),
(31, 'MAINTENANCE', 'Y', 1, '2021-01-01'),
(32, 'WS', 'Y', 1, '2021-01-01'),
(33, 'NONWOVEN', 'Y', 1, '2021-01-01'),
(34, 'QC ALKES', 'Y', 1, '2021-01-01'),
(35, 'QC SYRINGE', 'Y', 1, '2021-01-01'),
(36, 'QC NON STERIL', 'Y', 1, '2021-01-01'),
(37, 'QC A & D', 'Y', 1, '2021-01-01'),
(38, 'QA', 'Y', 1, '2021-01-01'),
(39, 'QA & ISO', 'Y', 1, '2021-01-01'),
(40, 'QC ELEKTROMEDIK', 'Y', 1, '2021-01-01'),
(41, 'STERIL', 'Y', 1, '2021-01-01'),
(42, 'UMUM', 'Y', 1, '2021-01-01');

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
(1, 'DIREKTUR', 'Y', 1, '2021-01-01'),
(2, 'STAFF', 'Y', 1, '2021-02-11'),
(3, 'MANAGER', 'Y', 1, '2021-01-01'),
(4, 'ADMIN', 'Y', 1, '2021-01-01'),
(5, 'KABAG ', 'Y', 1, '2021-01-01'),
(6, 'STAFF ', 'Y', 1, '2021-01-01'),
(7, 'SPV', 'Y', 1, '2021-01-01'),
(8, 'KARYAWAN', 'Y', 1, '2021-01-01'),
(9, 'KABAG', 'Y', 1, '2021-01-01'),
(10, 'EXIM', 'Y', 1, '2021-01-01'),
(11, 'MANAGER ', 'Y', 1, '2021-01-01'),
(12, 'PELAKSANA', 'Y', 1, '2021-01-01'),
(13, 'KOORDINATOR', 'Y', 1, '2021-01-01'),
(14, 'SETTER', 'Y', 1, '2021-01-01');

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
(1, '2072', 4, '2021-01-26', 'N', '2021-03-25', 1),
(2, '2072', 3, '2021-01-06', 'Y', '2021-04-02', 2),
(3, '178', 3, '2021-03-01', 'Y', '2021-04-02', 2),
(4, '178', 3, '2021-03-02', 'Y', '2021-04-02', 2),
(5, '178', 3, '2021-03-03', 'Y', '2021-04-02', 2);

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
(1, '1', '2017', 1, 22, 'HERLIEN SRI ARIANI', '011002', '3578235009630002', '086328481609001', 'P', '2001-09-03', '0000-00-00', 'Y', '', '', '1963-09-10', 'KETINTANG PERMAI AC 11 SURABAYA', '2009-06-08', '', '', 'S1 FARMASI MATEMATIKA DAN SAINS UNIVERSITAS AIRLAN', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(10, '10', '2048', 6, 11, 'ABDULLOH AFIF R.', '1110292', '3515022805930001', '706465531603000', 'L', '2011-07-27', '0000-00-00', 'Y', '', '', '1993-05-28', 'TURI RT 02 RW 02 CANGKRINGTURI, PRAMBON, SIDOARJO', '2012-11-19', '', '', 'SMA AL-ISLAM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(100, '100', '56', 12, 27, 'FAHMI DARUSMAN', '1401358', '3515141002950001', '706465168603000', 'L', '2014-01-09', '0000-00-00', 'Y', '', '', '1995-02-10', 'BALONG PANDAN RT07 RW02 JOGOSATRU SUKODONO SIDOARJO', '2014-04-09', '', '', 'SMK ELEKTRONIKA AUDIO VIDEO N 1 SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(101, '101', '2024', 4, 28, 'NUR SANIYAH', '021048', '3515116709800004', '972233829603000', 'P', '2002-09-18', '0000-00-00', 'Y', '', '', '1980-09-27', 'SIDOMOJO RT3 RW1 KRIAN - SDA', '2009-06-08', '', '', 'SMA N 1 KRIAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(102, '102', '2025', 12, 28, 'MULIADI', '041049', '3515023009770004', '885576249603000', 'L', '2004-07-30', '0000-00-00', 'Y', '', '', '1977-09-30', 'WATUTULIS  RT2 RW 1 PRAMBON - SDA', '2009-06-08', '', '', 'SMP PERJUANGAN PRAMBON SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(103, '103', '2026', 7, 28, 'DIDIK TJANDRA WAHONO', '071052', '3578272901880002', '891981961604000', 'L', '2007-12-12', '0000-00-00', 'Y', '', '', '1988-01-29', 'JL SIMO PRONA JAYA 8 RT02 RW08 SIMOMULYO SURABAYA', '2009-06-08', '', '', 'SMA SEJAHTERA SUKOMANUNGGAL SURABAYA', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(104, '104', '2028', 12, 28, 'ERWANTO', '1312258', '3515111104800005', '726792211603000', 'L', '2011-06-12', '0000-00-00', 'Y', '', '', '1980-04-11', 'KARANGPOH RT02 RW02 PONOKAWAN KRIAN SIDOARJO', '2013-12-09', '', '', 'SMA IPS PAKET C SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(105, '105', '2029', 12, 28, 'IBNU SUFYAN', '1312257', '3515112411860003', '788492726603000', 'L', '2011-06-12', '0000-00-00', 'Y', '', '', '1986-11-24', 'KASAK RT06 RW03 TERUNGKULON KRIAN SIDOARJO', '2013-12-09', '', '', 'SMK MEKANIK OTOMOTIF YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(106, '106', '2030', 9, 28, 'ENTYK SUSILOWATI', '1311475', '3576025806820003', '986779593602000', 'P', '2013-06-17', '0000-00-00', 'Y', '', '', '1982-06-18', 'JL. EMPU NALA NO.39 MOJOKERTO', '2013-09-17', '', '', 'INSTITUT TEKNOLOGI NASIONAL MALANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(107, '107', '2042', 4, 28, 'ZULIATIN PRETTY CAHYANINGSEH', '1511604', '3515124507920002', '720918200603000', 'P', '2013-09-05', '0000-00-00', 'Y', '', '', '1992-07-05', 'KEMANGSEN UTARA RT02 RW01 KEMANGSEN BALONGBENDO SIDOARJO', '2016-02-02', '', '', 'SMA IPA WACHID HASYIM 2 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(108, '108', '2031', 4, 28, 'EKO PURWANTININGSIH', '1010193', '3515015712910001', '904868486603000', 'P', '2016-03-04', '0000-00-00', 'Y', '', '', '1991-12-17', 'KEMUNING RT22 RW04 KEMUNING TARIK SIDOARJO', '2016-10-01', '', '', 'SMA IPS N 1 TARIK SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(109, '109', '2032', 12, 28, 'NASHORI WIJAYANTO', '1211434', '3505102611930004', '720802040653000', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1993-11-26', 'TEGALREJO RT04 RW12 SAWENTAR KANIGORO BLITAR', '2017-01-02', '', '', 'SMK PEMESINAN N 1 BLITAR', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(11, '11', '2046', 6, 12, 'ARIESTA MAHARANNY WAHYUNINGTYAS', '1110327', '3515015704920001', '885576371603000', 'P', '2011-12-05', '0000-00-00', 'Y', '', '', '1992-04-17', 'PERUM SUMPUT ASRI F.18-DRIYOREJO - GRESIK', '2012-04-26', '', '', 'SMA K UNTUNG SUROPATI KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(110, '110', '14', 7, 28, 'RONNI SETYAWAN', '18031030', '3506152404880003', '939504411655000', 'L', '2018-03-01', '0000-00-00', 'Y', '', '', '1988-04-24', 'MUNENG WETAN RT02 RW03 MUNENG PURWOASRI KEDIRI', '2018-03-01', '', '', 'SMA IPS N 1 PURWOASRI KEDIRI', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(111, '111', '89', 7, 29, 'RUDY SEPTIANTO', '091067', '3516060209880003', '086364510609000', 'L', '2007-10-26', '0000-00-00', 'Y', '', '', '1988-09-02', 'LEBAK RT03 RW05 LEBAKSONO PUNGGING MOJOKERTO', '2009-06-08', '', '', 'SMK KRISTEN PETRA SURABAYA', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(112, '112', '8', 7, 29, 'SUHARTO', '101073', '3578060506910004', '972233902614000', 'L', '2009-06-01', '0000-00-00', 'Y', '', '', '1991-06-05', 'JL SAWAHAN DKA II / 35 SURABAYA', '2010-06-25', '', '', 'SMK N 2 SURABAYA', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(113, '113', '128', 12, 29, 'IBNU MAS\'UD', '1312259', '3515120208860001', '726703820603000', 'L', '2011-05-29', '0000-00-00', 'Y', '', '', '1986-08-02', 'JERUK LEGI RT08 RW02 JERUKLEGI BALONGBENDO SIDOARJO', '2013-12-09', '', '', 'SMK TEKNIK MESIN PERKAKAS KRIAN 1 SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(114, '114', '121', 12, 29, 'MUHAMMAD SANURI', '1211425', '3515112001870005', '986779783603000', 'L', '2011-12-24', '0000-00-00', 'Y', '', '', '1984-01-20', 'TERIK RT08 RW03 KRIAN-SDA', '2013-12-09', '', '', 'SMK KRIAN 1 SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(115, '115', '171', 14, 29, 'MOCHAMAD CHOIRUL FIDDIN', '1010106', '3515111410860003', '715437232603000', 'L', '2013-03-09', '0000-00-00', 'Y', '', '', '1986-10-14', 'KASAK RT06 RW03 TERUNGKULON KRIAN SIDOARJO', '2016-01-04', '', '', 'SMK MEKANIK OTOMOTIF YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(116, '116', '200', 12, 29, 'M FARID FERI DIANSYAH', '1311629', '3515122010920003', '733917504603000', 'L', '2014-04-23', '0000-00-00', 'Y', '', '', '1992-10-20', 'KEPUHSARI RT02 RW03 GAGANG KEPUHSARI BALONGBENDO SIDOARJO', '2015-02-23', '', '', 'D1 INFORMATIKA PINKOM AL-ISLAM KRIAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(117, '117', '199', 12, 29, 'MUHAMMAD FARID HIDAYAT', '1311592', '3515142504950003', '733914840603000', 'L', '2014-04-28', '0000-00-00', 'Y', '', '', '1995-04-25', 'NGARESREJO RT16 RW03 NGARESREJO SUKODONO SIDOARJO', '2015-02-23', '', '', 'SMK OTOMOTIF KENDARAAN RINGAN YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(118, '118', '201', 12, 29, 'GANIES DIMAS PRATAMA', '1311610', '3515112810940002', '733914154603000', 'L', '2014-04-28', '0000-00-00', 'Y', '', '', '1994-10-28', 'BALEPANJANG RT07 RW01 TROPODO KRIAN SIDOARJO', '2016-04-28', '', '', 'SMK PEMESINAN KRIAN 1 SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(119, '119', '141', 7, 29, 'ADI SULISTYONO', '1411329', '3515052110810001', '793190646617000', 'L', '2014-09-30', '0000-00-00', 'Y', '', '', '1981-10-21', 'DUKUHSARI RT05 RW01 DUKUHSARI JABON SIDOARJO', '2014-12-30', '', '', 'SMK MEKANIK UMUM KRIAN 1 SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(12, '12', '', 1, 22, 'LEONARD HARIADI HARTANTO', '1210360', '3578212604900001', '462426008618000', 'L', '2012-07-04', '0000-00-00', 'Y', '', '', '1990-04-26', 'KENCANASARI BARAT 1/A-4 RT03 RW05 DUKUH PAKIS - SBY', '0000-00-00', '', '', 'MARGUETTE UNIVERSITY FINANCE', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(120, '120', '72', 9, 29, 'AGUS SUPRIADI', '1509352', '3515150410710001', '598245280643000', 'L', '2015-09-01', '0000-00-00', 'Y', '', '', '1971-10-04', 'JL. MBAH DEMANG NO/54 RT10 RW03 ENTAL SEWU BUDURAN SIDOARJO', '2015-12-01', '', '', 'S1 MANAGEMENT UNIVERSITAS 45 SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(121, '121', '178', 4, 29, 'AMRIK SISWANTI', '1701999', '3515115404910001', '715623419603000', 'P', '2017-01-02', '0000-00-00', 'Y', '', '', '1991-04-14', 'SIDORAME RT10 RW03 SIDOREJO KRIAN SIDOARJO', '2017-01-02', '', '', 'SMA IPS PAKET C SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(122, '122', '175', 12, 29, 'ABDUL RHOMAWAN', '17011001', '3515101005930003', '715836128603000', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1993-05-10', 'KARANG PURI RT04 RW02 KARANG PURI WONOAYU SIDOARJO', '2017-01-02', '', '', 'SMK OTOMOTIF KENDARAAN RINGAN YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(123, '123', '189', 12, 29, 'DIMAS AGUNG TRI LAKSAMANA', '', '3515111507900001', '', 'L', '2019-02-01', '0000-00-00', 'Y', '', '', '1990-07-15', 'PERUM JATIKALANG A8/12 RT 24 RW 05 JATIKALANG,KRIAN,SIDOARJO', '0000-00-00', '', '', 'SMA IPS KEMALA BHAYANGKARA 4 WARU SIDOARJO', '01/02/2019 S/D 31/01/2020', '01/02/2020 S/D 31/01/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(124, '124', '1033', 12, 29, 'CHOIRUL ANWAR', '', '3517070802890004', '', 'L', '2019-02-01', '0000-00-00', 'Y', '', '', '1989-02-08', 'JL.KATAK RT 04 RW 06 CATAKGAYAM MOJOWARNO JOMBANG', '0000-00-00', '', '', 'SMK TEKNIK MESIN 10 NOPEMBER JOMBANG', '01/02/2019 S/D 31/01/2020', '01/02/2020 S/D 31/01/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(125, '125', '1015', 12, 29, 'REGGY DESTA SETYAWAN', '', '3515110112940002', '', 'L', '2019-02-01', '0000-00-00', 'Y', '', '', '1994-12-01', 'SIDORANGU RT 11 RW 05 WATUGOLONG KRIAN SIDOARJO', '0000-00-00', '', '', 'SMK TEKNIK OTOMOTIF KRIAN 2 SIDOARJO', '01/02/2019 S/D 31/01/2020', '01/02/2020 S/D 31/01/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(126, '126', '76', 12, 30, 'RULI SUGIONO', '1211403', '3515111906820002', '972233779642000', 'L', '2003-04-10', '0000-00-00', 'Y', '', '', '1982-06-19', 'DSN NGOROREJO RT 014 RW 03 TANJUNGAN, DRIYOREJO, GRESIK', '2009-06-08', '', '', 'SMK TEKNIK MESIN AL-HUDA KOTA KEDIRI', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(127, '127', '48', 9, 31, 'NANANG PURWANTOKO', '1312731', '3525151701880001', '550489306642000', 'L', '2011-03-01', '0000-00-00', 'Y', '', '', '1988-01-17', 'WATES,CANGKIR RT/19 RW/06,DRIYOREJO-GRESIK', '2011-06-01', '', '', 'D3-Teknik elektro POLTEK SAKTI SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(128, '128', '106', 12, 31, 'JOHAN KRISTANTO', '1411342', '3515110211880005', '550488027603000', 'L', '2012-08-01', '0000-00-00', 'Y', '', '', '1988-11-02', 'TAMBAK WATU RT01 RW01 WATUGOLONG KRIAN - SDA', '2012-11-07', '', '', 'SMK YPM 1 KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(129, '129', '251', 7, 31, 'TRI SUGIARTO', '1509353', '3515021906920002', '706465119603000', 'L', '2013-12-09', '0000-00-00', 'Y', '', '', '1992-06-19', 'WIROBITING RT06 RW02 PRAMBON - SDA', '2014-03-10', '', '', 'D3-Teknik kelistrikan kapal Univ. ITS SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(13, '13', '2047', 6, 12, 'LINNARTI', '1312734', '3515125811850001', '986779809603000', 'P', '2012-10-09', '0000-00-00', 'Y', '', '', '1985-11-18', 'PENAMBANGAN RT08 RW02 PENAMBANGAN BALONGBENDO SIDOARJO', '2013-12-09', '', '', 'SMK AKUNTANSI PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(130, '130', '21', 7, 32, 'M ROFIK HIDAYAT', '1509355', '3515110806770006', '598245512603000', 'L', '2014-08-04', '0000-00-00', 'Y', '', '', '1977-06-08', 'TENGGULUNAN RT03 RW02 WATUGOLONG KRIAN SIDOARJO', '2014-11-03', '', '', 'D1 MEKANIK SAKTI SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(131, '131', '90', 7, 31, 'ERIF YUDIONO', '1512667', '3518112002820003', '773179049655000', 'L', '2015-09-07', '0000-00-00', 'Y', '', '', '1982-02-20', 'LING. GAMBIREJO RT02 RW06 WARUAJENG TANJUNGANOM NGANJUK', '2015-12-07', '', '', 'S1 TEKNIK UNIVERSITAS SUNAN GIRI SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(132, '132', '144', 3, 31, 'SONY RAHARJO', '', '3515131505770013', '74674508623000', 'L', '2015-09-10', '0000-00-00', 'Y', '', '', '1977-05-15', 'PERUM. GRIYO TAMAN ASRI HF/11 RT28 RW06 TAWANGSARI TAMAN SIDOARJO', '2015-12-10', '', '', 'TEKNIK ELEKTRO POLITEKNIK UNIVERSITAS BRAWIJAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(133, '133', '230', 12, 31, 'FAISAL EFENDI', '', '3578040907820003', '\'59824577765600', 'L', '2015-12-07', '0000-00-00', 'Y', '', '', '1982-07-09', 'DARMOKALI 1/5-C RT07 RW03 DARMO WONOKROMO SURABAYA', '2016-10-01', '', '', 'D1 MARKETING MANAGEMENT SCHOOL OF BUSINESS MALANG ', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(134, '134', '138', 12, 31, 'MOCHAMAD MAHFUDIN', '', '3525153003880002', '', 'L', '2019-10-01', '0000-00-00', 'Y', '', '', '1988-03-30', 'CANGKIR RT05 RW04 CANGKIR DRIYOREJO GRESIK', '0000-00-00', '', '', 'SMK TEKNIK INSTALASI LISTRIK YPM 1 TAMAN SIDOARJO', '01/10/2019 S/D 30/09/2020', '01/10/2020 S/D 30/09/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(135, '135', '367', 12, 31, 'SULKAN GUFRON', '', '3515100505780007', '720985241603000', 'L', '2020-01-02', '0000-00-00', 'Y', '', '', '1978-05-05', 'KALIBENER RT03 RW01 MERGOBENER TARIK SIDOARJO', '0000-00-00', '', '', 'SMK BISNIS MANAJEMEN PEMUDA KRIAN SIDOARJO', '02/01/2020 S/D 31/12/2020', '02/01/2021 S/D 31/12/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(136, '136', '1150', 12, 31, 'KHOIRUL MUFID', '', '3515042909810005', '831501218617000', 'L', '2020-11-02', '0000-00-00', 'Y', '', '', '1981-09-29', 'KESAMBI RT 05 RW 01 KESAMBI, PORONG, SIDOARJO', '0000-00-00', '', '', 'SMKN 1 SIDOARJO', '02/11/2020 S/D 30/06/2021', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(137, '137', '32', 7, 31, 'MOCHAMMAD NUR MASRUKHAN', '', '3517091601940001', '', 'L', '2020-01-04', '0000-00-00', 'Y', '', '', '1994-01-16', 'PULO KALIMALANG RT 01 RW 06 PULO LOR, JOMBANG', '0000-00-00', '', '', 'S1 TEKNIK ELEKTRO UNIVERSITAS DARUL ULUM JOMBANG', '04/01/2021 S/D 30/06/2021', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(138, '138', '1155', 12, 31, 'MA\'RUF ASMARA EKA PUTRA', '', '3515081205920009', '717654255617000', 'L', '2020-01-12', '0000-00-00', 'Y', '', '', '1992-05-12', 'PERUM MAGERSARI PERMAI AF 10 RT 40 RW 07 MAGERSARI, SIDOARJO', '0000-00-00', '', '', 'PPNS ITS SURABAYA', '12/01/2021 S/D 31/07/2021', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(139, '139', '450', 12, 31, 'ACHMAD WAHYU EKA AFIANTO', '', '3516122906990002', '', 'L', '2021-01-18', '0000-00-00', 'Y', '', '', '1999-06-29', 'TEMBORO RT 04 RW 05 DOMAS, TROWULAN, MOJOKERTO', '0000-00-00', '', '', 'SMKN 1 JATIREJO, MOJOKERTO', '18/01/2021 S/D 31/07/2021', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(14, '14', '97', 7, 3, 'SEPTINIA MAYASARI', '1210401', '3515114209850004', '783811177656000', 'P', '2012-11-01', '0000-00-00', 'Y', '', '', '1985-09-02', 'SIDOMUKTI RT05 RW02 KRATON KRIAN - SDA', '2013-03-01', '', '', 'UNIVERSITAS MERDEKA SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(140, '140', '2', 9, 33, 'DIDIK BUDIYANTO', '991011', '3515110711780003', '891981953603000', 'L', '2002-04-22', '0000-00-00', 'Y', '', '', '1978-11-07', 'DSN PONOKAWAN RT 01 RW 01 KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMA N 3 SITUBONDO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(141, '141', '28', 7, 33, 'SUYADI', '1211416', '3515012201900002', '876828302603000', 'L', '2008-12-15', '0000-00-00', 'Y', '', '', '1990-01-22', 'KEDINDING RT 04 RW 02 TARIK, SIDOARJO', '2012-07-20', '', '', 'SMK KRIAN 1 SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(142, '142', '13', 12, 33, 'SITI INDAH PUSPITA SARI', '18031034', '3515094906920001', '', 'P', '2018-03-01', '0000-00-00', 'Y', '', '', '1992-06-09', 'TROWULAN RT04 RW02 TROWULAN MOJOKERTO', '2018-03-01', '', '', 'SMA IPS PERSATUAN TULANGAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(143, '143', '7', 12, 33, 'ABDUL MUN\'IM', '18031032', '3512081709870002', '', 'L', '2018-03-01', '0000-00-00', 'Y', '', '', '1987-09-17', 'JL SEMERU RT03 RW11 MIMBAAN PANJI SITUBONDO', '2018-03-01', '', '', 'SMA IPS PAKET C SITUBONDO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(144, '144', '9', 7, 33, 'ELMINAFIAN', '18031031', '3578270507950001', '939661161604000', 'L', '2018-03-01', '0000-00-00', 'Y', '', '', '1995-07-05', 'TANJUNGSARI JAYA RT8/12 RT11 RW02 TANJUNGSARI SUKOMANUNGGAL SURABAYA', '2018-03-01', '', '', 'SMK TEKNIK KENDARAAN RINGAN DHARMA BAHARI SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(145, '145', '42', 7, 4, 'SRI ARIANI', '011025', '3578067012700003', '470793555614000', 'P', '2002-05-20', '0000-00-00', 'Y', '', '', '1970-12-30', 'SIMO SIDOMULYO 4/16 RT06 RW16 PETEMON SAWAHAN SURABAYA', '2009-06-08', '', '', 'SMA EKONOMI N 2 SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(146, '146', '70', 12, 4, 'DODIK DANAFI', '031050', '3515113105780001', '972233985603000', 'L', '2003-04-11', '0000-00-00', 'Y', '', '', '1978-05-31', 'JATIREJO RT 3 RW 2 JATIKALANG KRIAN - SDA', '2009-06-08', '', '', 'SMK N 1 SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(147, '147', '73', 12, 4, 'ACKEMAD HARIANTO', '031018', '3515112607830001', '891981938603000', 'L', '2003-07-03', '0000-00-00', 'Y', '', '', '1983-07-26', 'DSN KARANGPOH RT 02 RW 02 PONOKAWAN, KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMK YPM 1 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(148, '148', '16', 12, 4, 'TEGUH SUSANTO', '031036', '3318072007850001', '972234025507000', 'L', '2003-07-23', '0000-00-00', 'Y', '', '', '1985-07-20', 'DSN KLURAHAN RT 05 RW 01 NGRONGGOT, NGANJUK', '2009-06-08', '', '', 'SMK N 1 REMBANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(149, '149', '46', 12, 4, 'SYAMSUL ARIFIN', '041035', '3515110212800002', '706465382603000', 'L', '2004-04-30', '0000-00-00', 'Y', '', '', '1980-12-02', 'MOJOKEMUNING RT 01 RW 01 SIDOMOJO, KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMK MEKANIK OTOMOTIF YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(15, '15', '2006', 6, 12, 'RETNOWATI', '1010178', '3515014303920003', '706465614603000', 'P', '2013-04-11', '0000-00-00', 'Y', '', '', '1992-03-03', 'KEMUNING RT16 RW04 TARIK - SDA', '2013-07-11', '', '', 'SMK PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(150, '150', '49', 12, 4, 'SUROSO', '041034', '3515010804830002', '972233753603000', 'L', '2004-05-31', '0000-00-00', 'Y', '', '', '1983-04-08', 'WISMA LIDAH KULON XB 68 RT 01 RW 04 BANGKINGAN, LAKAR SANTRI, SURABAYA', '2009-06-08', '', '', 'SMK A.YANI BALONGBENDO SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(151, '151', '43', 12, 4, 'ARIF AFANDI', '041029', '3515110803760002', '462535279603000', 'L', '2004-06-21', '0000-00-00', 'Y', '', '', '1976-03-08', 'DSN MOJOKEMUNING RT 03 RW 01 SIDOMOJO, KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMP YPM PANJUNAN SUKODONO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(152, '152', '34', 7, 4, 'MOCHAMAD FAUZAN', '041031', '3515112912800004', '885576322609000', 'L', '2004-07-06', '0000-00-00', 'Y', '', '', '1980-12-29', 'MOJOKEMUNING RT 03 RW 01 SIDOMOJO, KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMK KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(153, '153', '23', 12, 4, 'PUPUT MAHARANI', '041033', '3578184605860002', '972234041609000', 'P', '2004-07-07', '0000-00-00', 'Y', '', '', '1986-05-06', 'PULO TEGALSARI 2/44 RT 05 RW 07 WONOKROMO, SIDOARJO', '2009-06-08', '', '', 'SMK YPM 3 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(154, '154', '45', 12, 4, 'LIANA SISWANTI', '051030', '3515114711810002', '972234157603000', 'P', '2005-02-07', '0000-00-00', 'Y', '', '', '1981-11-07', 'MOJOKEMUNING RT 03 RW 01 SIDOMOJO, KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMA N 1 KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(155, '155', '44', 12, 4, 'YUYUN IRAWATI', '051038', '3515114809800002', '972234033603000', 'P', '2005-09-06', '0000-00-00', 'Y', '', '', '1980-09-08', 'MOJOKEMUNING RT 04 RW 01 SIDOMOJO, KRIAN', '2009-06-08', '', '', 'SMA WAHID HASYIM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(156, '156', '68', 12, 4, 'IKA FATMAWATI', '101043', '3515115212850001', '885576405603000', 'P', '2007-01-18', '0000-00-00', 'Y', '', '', '1985-12-12', 'DSN KARANGPOH RT 03 RW 02 PONOKAWAN, KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMK YPM 2 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(157, '157', '64', 12, 4, 'ADI RIDHO PRADANA', '091066', '3515110912870004', '891981946624000', 'L', '2007-12-17', '0000-00-00', 'Y', '', '', '1987-12-09', 'BABADAN RT11 RW04 JUNWANGI KRIAN-SDA', '2008-12-08', '', '', 'SMK N 1 BANGIL PASURUAN', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(158, '158', '22', 12, 4, 'UNIK FATMAWATI', '081039', '3515115406850006', '972234066603000', 'P', '2008-02-08', '0000-00-00', 'Y', '', '', '1985-06-26', 'JATIKALANG RT 07 RW 01 KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMA WAHID HASYIM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(159, '159', '77', 12, 4, 'BAGUS RAHMAD SAPUTRA', '101058', '3515141007890001', '972234009603000', 'L', '2008-08-14', '0000-00-00', 'Y', '', '', '1989-07-10', 'NGARES REJO RT16 RW03 SUKODONO-SDA', '2010-07-25', '', '', 'SMA WACHID HASYIM 2 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(16, '16', '', 6, 20, 'DWIDJO HARIJONO', '', '3175062110550004', '065497331615000', 'L', '2014-03-01', '0000-00-00', 'Y', '', '', '1955-10-21', 'PERUM BANJAR WIJAYA CLUSTER KRISAN TYPE SERUNI B67 NO9', '0000-00-00', '', '', 'PAAP FE UNAIR', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(160, '160', '101', 12, 4, 'SURYATI', '1211405', '3515115506840005', '550501811603000', 'P', '2010-04-14', '0000-00-00', 'Y', '', '', '1984-06-15', 'SEMAJI RT 13 RW 04 KEMASAN, KRIAN, SIDOARJO', '2012-11-19', '', '', 'SMA PAKET C SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(161, '161', '2027', 12, 4, 'RUDI HANSAH', '1211402', '3515102501900002', '550463897603000', 'L', '2010-09-15', '0000-00-00', 'Y', '', '', '1990-08-25', 'WANTIL RT03 RW02 WONOKALANG WONOAYU SIDOARJO', '2012-11-19', '', '', 'SMA IPS AL-ISLAM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(162, '162', '112', 12, 4, 'WAWAN GIARTO', '1211411', '3520032409920001', '550497655646000', 'L', '2012-04-16', '0000-00-00', 'Y', '', '', '1992-09-24', 'SELUNGGUH RT02 RW01 KEDIREN LEMBEYAN MAGETAN', '2012-11-19', '', '', 'SMK REKAYASA PERANGKAT LUNAK N 1 JENANGAN PONOROGO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(163, '163', '123', 12, 4, 'ASMAUL CHUSNAH', '1210347', '3515114606770001', '986779957603000', 'P', '2013-07-09', '0000-00-00', 'Y', '', '', '1977-06-06', 'TAMBAK WATU RT02 RW01 WATUGOLONG KRIAN SIDOARJO', '2013-12-09', '', '', 'MTS N KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(164, '164', '19', 12, 4, 'JIMMY IMANTAKA', '1501359', '3509191608830008', '', 'L', '2014-01-09', '0000-00-00', 'Y', '', '', '1982-08-16', 'PERUM KEBON AGUNG INDAH XIII/3 LING GEBANG WARU KALIWATES JEMBER', '2014-05-07', '', '', 'SMK ELEKTRO INSTALASI LISTRIK BERDIKARI PATRANG JE', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(165, '165', '146', 12, 4, 'AFFAN PRASETYO', '1312754', '3515112106910001', '716067053603000', 'L', '2014-09-04', '0000-00-00', 'Y', '', '', '1991-06-21', 'KATERUNGAN RT07 RW02 KATERUNGAN KRIAN SIDOARJO', '2015-12-04', '', '', 'SMK PEMESINAN KRIAN 1 SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(166, '166', '149', 12, 4, 'SULIMAH', '1312762', '3515125405900001', '715439444603000', 'P', '2014-09-04', '0000-00-00', 'Y', '', '', '1990-05-14', 'WONOKOYO RT05 RW03 WONOKARANG BALONGBENDO SIDOARJO', '2015-12-04', '', '', 'SMA IPA R.RAHMAT BALONGBENDO SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(167, '167', '162', 12, 4, 'LAILATUL JUM\'AT MUNAWAROCH', '1411353', '3515124703860003', '733543490603000', 'P', '2014-11-20', '0000-00-00', 'Y', '', '', '1986-03-07', 'MELATI RT14 RW04 JERUK LEGI BALONGBENDO SIDOARJO', '2015-02-23', '', '', 'MA IPS AL-IHSAN KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(168, '168', '158', 12, 4, 'KHUZAINI', '1701995', '3514082808940003', '', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1994-08-28', 'JATI KAUMAN RT01 RW01 CENDONO PURWOSARI PASURUAN', '2017-01-02', '', '', 'MA IPA MIFTAHUL HUDA PURWOSARI PASURUAN', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(169, '169', '161', 12, 4, 'PUTRI YULIARDI', '1701996', '3515026607870001', '716051172603000', 'P', '2017-01-02', '0000-00-00', 'Y', '', '', '1987-07-26', 'WONOKERTO LOR RT02 RW01 WONOPLINTAHAN PRAMBON SIDOARJO', '2017-01-02', '', '', 'SMA IPS AL-ISLAM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(17, '17', '2045', 6, 14, 'MUHAMMAD BILAL', '1311525', '3515122405890002', '085516375603000', 'L', '2014-09-04', '0000-00-00', 'Y', '', '', '1989-05-24', 'KEDUNGMOJO RT07 RW02 KEDUNG SUKODANI BALONGBENDO SIDOARJO', '2015-12-04', '', '', 'SMK PEMESINAN JAYANEGARA MOJOKERTO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(170, '170', '157', 4, 4, 'MUSADI FEBRIONO', '1701997', '3515110904950002', '715439543603000', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1995-04-09', 'KRATON RT12 RW03 KRATON KRIAN SIDOARJO', '2017-01-02', '', '', 'SMK MULTIMEDIA KRIAN 2 SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(171, '171', '145', 12, 4, 'ACHWAN ZAKARIYA', '1701998', '3515111505930001', '715899878603000', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1993-05-15', 'TERIK RT11 RW04 TERIK KRIAN SIDOARJO', '2017-01-02', '', '', 'SMA IPS N 1 KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(172, '172', '339', 12, 4, 'INDAH FAJARWATI', '17041015', '3515105807940002', '721118206603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1994-07-18', 'TANGGUL WETAN RT03 RW02 TANGGUL WONOAYU SIDOARJO', '2017-04-01', '', '', 'SMK MULTIMEDIA YAPALIS KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(173, '173', '65', 12, 4, 'ENDAH SRI WULANDARI', '101079', '3515097004820001', '972233795603000', 'P', '2008-06-02', '0000-00-00', 'Y', '', '', '1982-04-30', 'KEBARON RT01 RW03 TULANGAN-SDA', '2010-09-23', '', '', 'SMA N 1 KREMBUNG SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(174, '174', '29', 12, 34, 'NURMA ZUNITA', '02120', '3517174604830001', '972234140602000', 'P', '2002-10-23', '0000-00-00', 'Y', '', '', '1983-04-06', 'TAPEN RT03 RW02 KUDU-JOMBANG', '2009-06-08', '', '', 'SMA DARUL ULUM KUDU JOMBANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(175, '175', '5', 12, 34, 'MAILA DWI KHOIRIYAH', '031014', '3515025005840008', '972233969603000', 'P', '2003-04-08', '0000-00-00', 'Y', '', '', '1984-05-10', 'DS.CLUMPRIT RT 2 RW 3 PRAMBON - SDA', '2009-06-08', '', '', 'SMK BUDI UTOMO PRAMBON SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(176, '176', '60', 12, 35, 'DWI SUHERLINA', '081069', '3515025511800001', '891981979603000', 'P', '2006-03-16', '0000-00-00', 'Y', '', '', '1980-11-15', 'PERTUKANGAN TEMU RT4  RW1 PRAMBON - SDA', '2009-06-08', '', '', 'SMK PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(177, '177', '51', 7, 36, 'ADE KRISTIAN SISWOYO', '071024', '3515012501860001', '972234082642000', 'L', '2007-12-06', '0000-00-00', 'Y', '', '', '1986-01-25', 'KALIMATI CENTONG  RT1 RW1  TARIK SDA', '2009-06-08', '', '', 'D3-ANALIS KESEHATAN DELIMA HUSADA GRESIK', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(178, '178', '108', 12, 35, 'HERMAWATI', '101077', '3515114510820007', '550467542603000', 'P', '2008-05-30', '0000-00-00', 'Y', '', '', '1982-10-05', 'KARANGPOH RT02 RW02 PONOKAWAN KRIAN SIDOARJO', '2012-11-19', '', '', 'SMU IPS AL-ISLAM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(179, '179', '105', 12, 34, 'WIYATI', '1211414', '3515114107780008', '550470900603000', 'P', '2009-01-09', '0000-00-00', 'Y', '', '', '1978-07-01', 'SIDORANGU RT12 RW05 WATUGOLONG KRIAN SIDOARJO', '2012-11-19', '', '', 'SMK AKUNTANSI PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(18, '18', '2008', 9, 20, 'LIA AGUSTINA', '1411363', '3578015708900002', '744604869618000', 'P', '2014-11-29', '0000-00-00', 'Y', '', '', '1990-08-17', 'KEBRAON 5/45B RT06 RW02 KEBRAON KARANG PILANG SURABAYA', '2015-03-02', '', '', 'S1 APOTEKER UNIVERSITAS SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(180, '180', '54', 7, 34, 'SITI LESTARI', '101042', '3518076209910003', '885576280655000', 'P', '2009-06-29', '0000-00-00', 'Y', '', '', '1991-09-22', 'JL. DS KLUAHAN RT 05 / RW 01 KEC NGRONGGOT KAB. NGANJUK', '2010-08-25', '', '', 'D3-ANALIS KESEHATAN YPM SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(181, '181', '53', 7, 37, 'TANTI AYU MEGAWATI', '101041', '3518076203910004', '885576272655000', 'P', '2009-06-29', '0000-00-00', 'Y', '', '', '1991-03-22', 'JL.DUSUN TEMPLEK RT16/RW18 DS KALIANYAR KEC. NGRANGGOT KAB. NGANJUK', '2010-08-25', '', '', 'SMK ANALIS KESEHATAN BHAKTI WIYATA KEDIRI', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(182, '182', '55', 5, 37, 'ARI HALIMATUS ZA\'DIYAH', '1010162', '3578244706840004', '972234116615000', 'P', '2010-08-05', '0000-00-00', 'Y', '', '', '1984-06-07', 'JL. KENDANGSARI GANG VIII NO.1-B SBY', '2010-11-06', '', '', 'S1-KIMIA UNESA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(183, '183', '143', 12, 35, 'AINUR ROHMAWATI', '1110330', '3515114401920001', '758473094603000', 'P', '2011-07-02', '0000-00-00', 'Y', '', '', '1992-01-04', 'KASAK RT05 RW03 KRIAN-SDA', '2015-01-30', '', '', 'SMK PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(184, '184', '107', 5, 34, 'NIA WAHYU DISTYARINI', '1210355', '3515116709880002', '885576181603000', 'P', '2012-04-24', '0000-00-00', 'Y', '', '', '1988-09-27', 'SIDOMOJO RT02 RW02 KRIAN - SDA', '2012-11-07', '', '', 'D3-ANALIS MEDIS KEDOKTERAN UNIVERSITAS AIRLANGGA S', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(185, '185', '114', 7, 37, 'RESTU SETYONINGTYAS ANGGRAENI', '1210358', '3515114404940003', '550490619603000', 'P', '2012-06-12', '0000-00-00', 'Y', '', '', '1994-04-04', 'TAMBAK SELATAN RT14 RW04 KRIAN - SDA', '2012-12-05', '', '', 'S1-BIOLOGI UNIVERSITAS ADI BUANA SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(186, '186', '127', 12, 38, 'HUSNUN NUR DAMAYANTI', '1311539', '3515114806930002', '986779783603000', 'P', '2013-01-21', '0000-00-00', 'Y', '', '', '1993-06-08', 'KASAK RT05 RW03 TERUNGKULON KRIAN SIDOARJO', '2013-12-09', '', '', 'SMK MULTIMEDIA PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(187, '187', '21', 7, 34, 'VITA NUR RISTA FEBRIYANTI', '1312756', '3516096202910002', '986779684602000', 'P', '2013-03-26', '0000-00-00', 'Y', '', '', '1991-02-22', 'JRAMBE RT04 RW01 DLANGGU - MJK', '2013-06-26', '', '', 'D3 ANALIS KESEHATAN POLTEKKES KEMENKES SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(188, '188', '126', 12, 38, 'KUSAITUL KASANAH', '1010147', '3515015208900002', '986779825603000', 'P', '2013-05-03', '0000-00-00', 'Y', '', '', '1990-08-12', 'KEMUNING RT20 RW01 KEMUNING TARIK SIDOARJO', '2013-12-09', '', '', 'SMK AKUNTANSI PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(189, '189', '124', 12, 4, 'ENDAH DWI WINARNI', '1010145', '3515114711740001', '575295803603000', 'P', '2013-07-08', '0000-00-00', 'Y', '', '', '1974-11-07', 'KASAK RT04 RW03 TERUNGKULON KRIAN SIDOARJO', '2013-12-09', '', '', 'SMA IPS DIPONEGORO TULUNGAGUNG ', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(19, '19', '2012', 9, 8, 'FATIMATUS SEHRO', '1601983', '3512095303830002', '581895174656000', 'P', '2016-01-04', '0000-00-00', 'Y', '', '', '1983-03-13', 'SEMIRING SELATAN RT02 RW01 SEMIRING MANGARAN SITUBONDO', '2016-04-04', '', '', 'SMK AKUNTANSI 1 PANJI SITUBONDO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(190, '190', '', 12, 37, 'WINDA AYU ANGGRAINI', '1410319', '3502055412930001', '720773480647000', 'P', '2014-06-02', '0000-00-00', 'Y', '', '', '1993-12-14', 'DUKUH BLUMBANG RT02 RW01 PANGKAL SAWOO PONOROGO', '2014-09-02', '', '', 'SMK ANALIS KESEHATAN BHAKTI WIYATA KEDIRI', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(191, '191', '142', 5, 39, 'RIZKI HERU CAESARIANTO', '1501282', '3578260102910002', '745891366619000', 'L', '2015-01-19', '0000-00-00', 'Y', '', '', '1991-02-01', 'WISMA PERMAI 1/89 RT01 RW05 MULYOREJO SURABAYA', '2015-04-20', '', '', 'S1 FARMASI APOTEKER UNIVERSITAS SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(192, '192', '348', 12, 35, 'IMA FITRIANI', '17041018', '3515114103920003', '721182517603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1992-03-01', 'GAMPING TENGAH RT01 RW01 GAMPING KRIAN SIDOARJO', '2017-04-01', '', '', 'SMK AKUNTANSI PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(193, '193', '347', 12, 35, 'RISUL AINI', '17041017', '3515115407890003', '721117869603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1989-07-14', 'TEMPEL RT04 RW01 TEMPEL KRIAN SIDOARJO', '2017-04-01', '', '', 'SMA IPS AL-ISLAM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(194, '194', '289', 6, 40, 'KUSNUL ROMIMAH', '18051042', '3516166310940002', '902963826603000', 'P', '2018-05-02', '0000-00-00', 'Y', '', '', '1994-10-23', 'KEDUNG SUMUR RT04 RW02 CANGGU JETIS MOJOKERTO', '2018-05-02', '', '', 'S1 TEKNOBIOMEDIK UNIVERSITAS AIRLANGGA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(195, '195', '50', 7, 38, 'ISWATUN HASANAH', '18111050', '3527034311950004', '939652194644000', 'P', '2018-11-01', '0000-00-00', 'Y', '', '', '1995-11-03', 'JL H.AGUSSALIM X NO.19 RT03 RW02 BANYUANYAR SAMPANG ', '2018-11-01', '', '', 'S1 TEKNOBIOMEDIK UNIVERSITAS AIRLANGGA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(196, '196', '202', 12, 35, 'ANA ULVIA', '1602611', '3515104802850001', '726697436603000', 'P', '2019-04-01', '0000-00-00', 'Y', '', '', '1985-02-08', 'BENDET RT03 RW03 PAGERNGUMBUK WONOAYU SIDOARJO', '0000-00-00', '', '', 'SMK AKUNTANSI PEMUDA KRIAN SIDOARJO', '01/04/2019 S/D 31/03/2020', '01/04/2020 S/D 31/03/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(197, '197', '', 12, 37, 'DWI ERIN YULIATI', '', '3517156607970002', '', 'P', '2019-04-22', '0000-00-00', 'Y', '', '', '1997-07-26', 'DUSUN NGENTAK RT 09 RW 03 SUMBEREJO,PLANDAAN ,JOMBANG', '0000-00-00', '', '', 'SMK AKUNTANSI PEMUDA KRIAN SIDOARJO', '22/04/2019 S/D 30/04/2020', '01/05/2020 S/D 30/04/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(198, '198', '325', 5, 15, 'AISYAH AYU RAHMAWATI', '19051056', '3517066507940001', '', 'P', '2019-05-01', '0000-00-00', 'Y', '', '', '1994-07-25', 'PEKUNDEN RT01 RW05 KADEMANGAN MOJOAGUNG JOMBANG', '0000-00-00', '', '', 'S1 TEKNOBIOMEDIK UNIVERSITAS AIRLANGGA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(199, '199', '99', 12, 15, 'ANITA  DWI ISMAYANTI', '', '3517146504970001', '', 'P', '2019-07-29', '0000-00-00', 'Y', '', '', '1997-04-25', 'DSN KUNDEN RT 03 RW 01 KEDUNGDOWO PLOSO JOMBANG', '0000-00-00', '', '', 'D3-ANALIS KESEHATAN INSAN CENDEKIA MEDIKA JOMBANG', '29/07/2019 S/D 31/01/2020', '01/02/2020 S/D 31/01/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(2, '2', '2001', 6, 12, 'KUMIATI', '011004', '3515115503700004', '470793506603000', 'P', '2001-09-03', '0000-00-00', 'Y', '', '', '1970-03-15', 'KASAK RT02 RW03 TERUNGKULON KRIAN SIDOARJO', '2009-06-08', '', '', 'SMA EKONOMI N 3 PAWIYATAN', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(20, '20', '2011', 6, 12, 'NOFARINA MUSHLIHAH', '1601608', '3519027110930001', '764866851621000', 'P', '2016-01-12', '0000-00-00', 'Y', '', '', '1993-10-31', 'JL. KERTORAHARJO RT01 RW01 BANGUNSARI DOLOPO MADIUN', '2016-04-12', '', '', 'D3 KOMPUTERISASI AKUNTANSI POLITEKNIK NEGERI MADIU', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(200, '200', '229', 6, 38, 'ITA SETYORINI', '1609937', '3516166009950001', '815104922602000', 'P', '2016-09-01', '0000-00-00', 'Y', '', '', '1995-09-20', 'KWANGEN RT04 RW02 SIDOREJO JETIS MOJOKERTO', '2016-12-01', '', '', 'SMK TEKNIK ELEKTRONIKA INDUSTRI N 1 JETIS MOJOKERT', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(201, '201', '1134', 6, 38, 'SOVIA NAVACATUS SACHARIA', '', '3515105005960004', '940064074603000', 'P', '2019-11-28', '0000-00-00', 'Y', '', '', '1996-05-10', 'SIMO ANGIN - ANGIN RT 10 RW 04 WONOAYU, SIDOARJO', '0000-00-00', '', '', 'SI FARMASI UNIVERSITAS SURABAYA', '28/11/2019 S/D 30/11/2020', '01/12/2020 S/D 30/11/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(202, '202', '1137', 6, 38, 'AINUR DWIKY SETYAWAN', '', '3515081812960003', '', 'L', '2019-12-16', '0000-00-00', 'Y', '', '', '1996-12-18', 'MAGERSARI PERMAI BB 13 RT 30 RW 07, MAGERSARI, SIDOARJO', '0000-00-00', '', '', 'S1 TEKNIK BIOMEDIS UNIVERSITAS AIRLANGGA SURABAYA', '16/12/2019 S/D 30/06/2020', '01/07/2020 S/D 30/06/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(203, '203', '1136', 6, 38, 'DIYAH NITAMI', '', '3517115612960002', '939858312649000', 'P', '2019-12-16', '0000-00-00', 'Y', '', '', '1996-12-16', 'DUSUN MOJO KURIPAN RT 01 RW 05 JOGOLOYO, SUMOBITO, JOMBANG', '0000-00-00', '', '', 'S1 KIMIA UNIVERSITAS BRAWIJAYA MALANG', '16/12/2019 S/D 30/06/2020', '01/07/2020 S/D 30/06/2021', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(204, '204', '448', 7, 15, 'NEVY VELANTI KUSDINA', '', '3309116111930002', '', 'P', '2020-06-23', '0000-00-00', 'Y', '', '', '1993-11-21', 'TEGALREJO RT 02 RW 05 NGESREP, NGEMPLAK, BOYOLALI', '0000-00-00', '', '', 'S1 KIMIA UNIVERSITAS DIPONEGORO SEMARANG', '23/06/2020 S/D 30/06/2021', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(205, '205', '52', 7, 41, 'SATRIO WICAKSONO', '001046', '3578061103740008', '470793548614000', 'L', '2003-01-06', '0000-00-00', 'Y', '', '', '1974-03-11', 'PADMOSUSASTRO 84 RT 04 RW 02 PAKIS - SAWAHAN, SURABAYA', '2009-06-08', '', '', 'SMK LISTRIK PGRI 1 SAWAHAN SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(206, '206', '17', 12, 41, 'SUHARIANTO', '071051', '3515100910840002', '891982019603000', 'L', '2006-12-04', '0000-00-00', 'Y', '', '', '1984-10-09', 'TANGGUL RT02 RW02 WONOAYU - SDA', '2009-06-08', '', '', 'SMK 1 KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(207, '207', '87', 12, 41, 'IRVAN SUNJAYANA', '101059', '3306070912890001', '972233860531000', 'L', '2009-11-09', '0000-00-00', 'Y', '', '', '1989-12-09', 'KLIWONAN BANYUURIP RT02 RW02 PURWOREJO-JATENG', '2010-06-25', '', '', 'SMK N 1 PURWOREJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(2072, '2072', '2072', 2, 10, 'AFIF NUZIA AL ASADI', '', '1234567891234560', '', 'L', '2021-01-01', '0000-00-00', 'Y', '', '', '0000-00-00', '', '0000-00-00', 'Karyawan', 'Tidak Kontrak', '', '', '', 5000000, 100000, 'N', 'Krian', 'Y', 1, '2021-03-31'),
(208, '208', '130', 12, 41, 'DWI HERMAWANTO', '1110326', '3515122704870002', '986779890603000', 'L', '2011-05-06', '0000-00-00', 'Y', '', '', '1987-04-27', 'WONOKUPANG RT01 RW01 WONOKUPANG BALONGBENDO SIDOARJO', '2013-12-09', '', '', 'SMK ELEKTRO AUDIO VIDEO YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(209, '209', '4', 12, 42, 'MUHAMAD KARTONO', '021053', '3515112807750001', '972233837603000', 'L', '2002-07-15', '0000-00-00', 'Y', '', '', '1975-07-28', 'SIDOMOJO RT1 RW 1 KRIAN - SDA', '2009-06-08', '', 'K/2', 'SMP MUHAMMADIYAH 6 KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(21, '21', '2044', 6, 14, 'ANAS HELMY FAIDZIN', '17011005', '3575032704910001', '765628482624000', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1991-04-27', 'JL. KH MANSYUR RT04 RW04 SEKARGADUNG PURWOREJO PASURUAN', '2017-01-02', '', '', 'S1 KOMPUTER UNIVERSITAS MUHAMMADIYAH MALANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(210, '210', '71', 12, 42, 'ABDUL KAMID', '021047', '3515142609740001', '876828328603000', 'L', '2002-09-01', '0000-00-00', 'Y', '', '', '1975-09-26', 'KETAWANG RT 15 RW 04 JOGOSATRU, SUKODONO, SIDOARJO', '2009-06-08', '', 'K/3', 'SMP N 2 SUKODONO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(211, '211', '37', 12, 42, 'DENDIK HARIYANTO', '071055', '3516081904740002', '885576215602000', 'L', '2007-04-02', '0000-00-00', 'Y', '', '', '1974-04-19', 'BELAHAN RT23 RW07 RANDUBANGO MOJOSARI - MJK', '2009-06-08', '', 'K/1', 'SMEA KITA BHAKTI MOJOSARI MOJOKERTO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(22, '22', '2013', 6, 8, 'MARIYATUL ULFA', '17041023', '3515116707960001', '', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1996-07-27', 'SIDOMORO RT10 RW04 BARENGKRAJAN KRIAN SIDOARJO', '2017-04-01', '', '', 'SMA IPA N 1 KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(23, '23', '30', 3, 21, 'JOKO SUGIYANTO', '17111027', '3515060804680004', '597694892617000', 'L', '2017-05-02', '0000-00-00', 'Y', '', '', '1968-04-08', 'PONDOK TG.ANGIN ASRI II-05 RT04 RW06 KALITENGAH TANGGULANGIN SIDOARJO', '2017-11-01', '', '', 'S1 TEKNIK PERKAPALAN INSTITUT ADHI TAMA SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(24, '24', '2014', 6, 20, 'HELIAWATI', '18021028', '3578157001920001', '844772020605000', 'P', '2018-02-01', '0000-00-00', 'Y', '', '', '1992-01-30', 'GADUKAN UTARA 5-A/20 RT07 RW05 MOROKKREMBANGAN KREMBANGAN SURABAYA', '2018-02-01', '', '', 'S1 TEKNIK INDUSTRI INSTITUT TEKNOLOGI SEPULUH NOPE', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(25, '25', '2050', 6, 11, 'RUSYDINA FIRDAUSI', '18051043', '3526016007950006', '934605379644000', 'P', '2018-05-02', '0000-00-00', 'Y', '', '', '1995-07-20', 'JL KH ABD MUIN 20 RT02 RW07 PEJAGAN BANGKALAN', '2018-05-02', '', '', 'S1 TEKNOBIOMEDIK UNIVERSITAS AIRLANGGA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(26, '26', '', 3, 12, 'JULIA SUNDARI WONGSOWINOTO', '18081046', '3578277107830002', '575532338604000', 'P', '2018-08-01', '0000-00-00', 'Y', '', '', '1983-07-31', 'DARMO PERMAI UTARA15/11 SURABAYA', '2018-08-01', '', '', 'S2 WIDYA MANDALA SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(27, '27', '282', 9, 3, 'FARIS ABIDIN ', '18101049', '3578240303830001', '692544398615000', 'L', '2018-10-01', '0000-00-00', 'Y', '', '', '1983-03-03', 'PERUM GRAHA KOTA C14-25 SIDOAJO', '2018-10-01', '', '', 'S1 PSIKOLOGI UNIVERSITAS HANG TUAH SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(28, '28', '', 9, 13, 'JATTU BELLAWATI', '18101048', '3515087107800003', '573914595617000', 'P', '2018-10-01', '0000-00-00', 'Y', '', '', '1980-07-31', 'BCF JL.SEKAWAN MOLEK IV BLOK II F/35 SIDOARJO', '2018-10-01', '', '', 'S1 HUKUM UNIVERSITAS JEMBER ', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(29, '29', '2041', 9, 14, 'RUDIK HARIYANTO', '19051055', '3506230507860004', '559555701655000', 'L', '2019-05-02', '0000-00-00', 'Y', '', '', '1986-07-05', 'JL SULTAN AGUNG RT 03 RW 03 SAMBI RINGINREJO KEDIRI', '2019-05-02', '', '', 'UNIVERSITAS DR SOETOMO SURABAYA AKUNTANSI', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(3, '3', '2018', 1, 22, 'FRANS HENDRATA', '011001', '3578042805410000', '085421006603000', 'L', '2001-10-04', '0000-00-00', 'Y', '', '', '1941-05-28', 'JEMUR ANDAYANI XV/18 RT06 RW01 JEMUR WONOSARI WONOCOLO SURABAYA', '2009-06-08', '', '', 'S1 FARMASI UNIVERSITAS TRISAKTI SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(30, '30', '', 3, 15, 'GOENADI', '19061059', '3201272408730004', '487118879624000', 'L', '2019-06-24', '0000-00-00', 'N', '', '', '1973-08-24', 'KP SELAWI RT 005 RW 001 PASIR MUNCANG CARINGIN BOGOR JAWA BARAT', '0000-00-00', '', '', 'UNIVERSITAS AIRLANGGA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(31, '31', '2062', 6, 14, 'NINA WIDAYATI', '', '3515135904930003', '', 'P', '2019-07-15', '0000-00-00', 'Y', '', '', '1993-04-19', 'DODOKAN RT 21 RW 03 TANJUNG SARI,TAMAN,SIDOARJO', '0000-00-00', '', '', 'DIII UNIVERSITAS NEGERI SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(32, '32', '436', 6, 13, 'BENY HADI KUSWOYO', '19081063', '3520072404900003', '927717272603000', 'L', '2019-08-01', '0000-00-00', 'Y', '', '', '1990-04-24', 'DS NGARESREJO RT 14 RW 03 NGARESREJO SUKODONO SIDOARJO', '2019-08-01', '', '', 'IKIP BUDI UTOMO MALANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(33, '33', '2056', 6, 16, 'YOGYANTONO', '19091064', '3578250802930001', '', 'L', '2019-09-01', '0000-00-00', 'Y', '', '', '1993-02-08', 'PERUM GUNUNGANYAR EMAS BLOK D19 RT 02 RW 08 GUNUNGANYAR SURABAYA', '2019-09-01', '', '', 'S1 DESAIN DAN MANAJEMEN PRODUK UNIVERSITAS SURABAY', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(34, '34', '2070', 6, 10, 'OKMAH INDAH MAYASARI', '18031033', '3515126710860002', '720845981603000', 'P', '2018-03-01', '0000-00-00', 'Y', '', '', '1986-10-27', 'GAGANG RT03 RW02 GAGANG KEPUHSARI BALONGBENDO SIDOARJO', '2018-03-01', '', '', 'SMA IPA KATOLIK UNTUNG SUROPATI KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(35, '35', '2071', 6, 12, 'ARIF RAHMAN SIDY PRATAMA', '', '3578010604930002', '805869419618000', 'L', '2020-04-06', '0000-00-00', 'Y', '', '', '0000-00-00', 'PERUM GUNUNG SARI INDAH BLOK HH NO. 13 SURABAYA', '0000-00-00', '', '', '', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(36, '36', '2061', 6, 20, 'MARDIYANA', '20101066', '3505025801950001', '964154074603000', 'P', '2020-10-01', '0000-00-00', 'Y', '', '', '1995-01-18', 'DSN RINGINANOM RT02 RW 04 RINGINANOM,UDANAWU,BLITAR', '2020-10-01', '', '', 'S1 SAINS INSTITUT TEKNOLOGI SEPULUH NOPEMBER ', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(37, '37', '2073', 6, 12, 'YASHINTA TANONE', '', '3173024501670001', '182424515036000', 'P', '2020-11-16', '0000-00-00', 'Y', '', '', '1967-01-05', 'JL DR MUWARDI III B / 3 RT 03 RW 03 GROGOL, GROGOL PETAMBURAN, JAKARTA BARAT', '0000-00-00', '', '', 'D3 AKUNTANSI AKADEMI AKUNTANSI JAYABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(38, '38', '32', 12, 23, 'UMAIROH', '31023', '3515117010800006', '972233761603000', 'P', '2003-04-26', '0000-00-00', 'Y', '', '', '1980-10-30', 'MOJOKEMUNING RT 05 RW 01 SIDOMOJO, KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMA WAHID HASYIM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(39, '39', '59', 12, 23, 'MUCHAMAD NASRULLOH', '31015', '3515042006790006', '972233894617000', 'L', '2003-10-30', '0000-00-00', 'Y', '', '', '1979-06-20', 'DSN GENENGAN RT 01 RW 03 DURENSEWU PANDAAN, PASURUAN', '2009-06-08', '', '', 'MTS N KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(4, '4', '2019', 3, 20, 'USWATUN CHASANAH', '021003', '3524166705710001', '470793480601000', 'P', '2002-02-01', '0000-00-00', 'Y', '', '', '1971-05-27', 'KAOPEN RT02 RW02 MANTUP MANTUP LAMONGAN', '2009-06-08', '', '', 'S1FARMASI SAINS UNIVERSITAS AIRLANGGA SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(40, '40', '36', 12, 23, 'MUCHAMAD ROFIK', '41032', '3515012812820002', '462535972603000', 'L', '2004-01-08', '0000-00-00', 'Y', '', '', '1982-12-28', 'KRAJAN RT 11 RW 02 KALIMATI, TARIK, SIDOARJO', '2009-06-08', '', '', 'SMK YPM 7 TARIK SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(41, '41', '58', 12, 23, 'UMI ROIMAH', '61017', '3515115508820008', '972233944603000', 'P', '2005-12-03', '0000-00-00', 'Y', '', '', '1982-08-15', 'TERIK RT 012 RW 04 KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMK LPM SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(42, '42', '10', 12, 23, 'GIAN PURWIANTO', '61016', '3515111909850003', '972233787603000', 'L', '2005-12-16', '0000-00-00', 'Y', '', '', '1985-09-19', 'DSN PONOKAWAN RT 01 RW 01 PONOKAWAN, KRIAN, SIDOARJO', '2009-06-08', '', '', 'SMK YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(43, '43', '15', 13, 23, 'ZULFA MUZAYYAH', '1211408', '3515116806730004', '462782723603000', 'P', '2007-08-21', '0000-00-00', 'Y', '', '', '1973-06-28', 'DSN KARANGPOH RT 02 RW 02 PONOKAWAN, KRIAN, SIDOARJO', '2012-03-26', '', '', 'SMA N 1 JATIROTO LUMAJANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(44, '44', '103', 12, 23, 'SRI WIJAYATI', '1211406', '3515116909840004', '550475545603000', 'P', '2009-08-28', '0000-00-00', 'Y', '', '', '1984-09-29', 'PATOMAN RT 06 RW 02 KEBOHARAN, KRIAN, SIDOARJO', '2012-11-19', '', '', 'SMA BUDI UTOMO PRAMBON', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(45, '45', '102', 12, 23, 'SARI AISAH', '1211407', '3517124511880001', '550492078602000', 'P', '2009-10-29', '0000-00-00', 'Y', '', '', '1988-11-05', 'MOJOKEMUNING RT 03 RW 01 SIDOMOJO, KRIAN, SIDOARJO', '2012-11-19', '', '', 'SMK N 1 MOJOAGUNG JOMBANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(46, '46', '109', 14, 23, 'NUR KHOLIS', '1010114', '3525151804840005', '550465843642000', 'L', '2009-10-31', '0000-00-00', 'Y', '', '', '1984-04-16', 'TANJUNGAN RT12 RW03 DRIYOREJO - GRESIK', '2012-11-19', '', '', 'SMK MESIN PERKAKAS DIPONEGORO PLOSO JOMBANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(47, '47', '117', 14, 23, 'DONI FRANSINATA', '130287', '3578020911890005', '550458319609000', 'L', '2010-01-18', '0000-00-00', 'Y', '', '', '1989-11-09', 'SIWALAN KERTO TENGAH NO33 WONOCOLO-SBY', '2013-02-25', '', '', 'SMK KRISTEN PETRA SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(48, '48', '20', 9, 23, 'MUHAMMAD RIZA HASYIM', '1110206', '3517092205860001', '972233977602000', 'L', '2011-01-19', '0000-00-00', 'Y', '', '', '1986-05-22', 'JL. BRIGJEN KATAMSO NO. 36 B RT 01 RW 01 WEDORO, WARU, SIDOARJO', '2011-04-19', '', '', 'SI-FARMASI APOTEKER UNIVERSITAS SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01');
INSERT INTO `master_karyawan` (`auto_id`, `id_karyawan`, `pin`, `id_jabatan`, `id_divisi`, `nama_karyawan`, `nik`, `no_ktp`, `npwp`, `jenis_kelamin_karyawan`, `tanggal_masuk_karyawan`, `tanggal_keluar_karyawan`, `status_karyawan`, `telp_karyawan`, `tempat_lahir_karyawan`, `tanggal_lahir_karyawan`, `alamat_karyawan`, `tanggal_pengangkatan`, `keterangan`, `k_tk`, `pendidikan`, `pkwt1`, `pkwt2`, `gaji_pokok`, `tunjangan_jabatan`, `bpjs_kesehatan`, `plant`, `ikut_penggajian`, `change_by`, `change_at`) VALUES
(49, '49', '110', 12, 23, 'MOCH HAMAM BAIHACHI', '1211412', '3515111009890003', '550500698603000', 'L', '2011-08-23', '0000-00-00', 'Y', '', '', '1989-09-10', 'KEMBANG SORE RT02 RW02 TERUNGKULON KRIAN SIDOARJO', '2012-11-19', '', '', 'SMK PEMESINAN KRIAN 1 SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(5, '5', '2003', 6, 12, 'VERONICA HANDJOJO', '031005', '3578047006820005', '186519328609000', 'P', '2003-08-01', '0000-00-00', 'Y', '', '', '1982-06-30', 'JL.PUCANG ARJO TIMUR 17 SURABAYA', '2009-06-08', '', '', 'POLTEK-AKUNTANSI UBAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(50, '50', '86', 12, 23, 'YENI WIDI ASTUTI', '1110234', '3515114506760005', '986779692603000', 'P', '2012-05-12', '0000-00-00', 'Y', '', '', '1976-06-05', 'DSN KARANGPOH RT 02 RW 02 PONOKAWAN, KRIAN, SIDOARJO', '2013-12-09', '', '', 'SMA AL-ISLAM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(51, '51', '137', 12, 23, 'ANA ZULIATI', '1110209', '3515115207790008', '986780039603000', 'P', '2012-05-12', '0000-00-00', 'Y', '', '', '1979-07-12', 'DSN KARANGPOH RT 04 RW 02 PONOKAWAN, KRIAN, SIDOARJO', '2013-12-09', '', '', 'SMK 2 BUDURAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(52, '52', '122', 12, 23, 'ARIES ANDI WIBOWO', '1110211', '3515113004880001', '986780013603000', 'L', '2012-08-08', '0000-00-00', 'Y', '', '', '1988-04-30', 'DSN PONOKAWAN RT 04 RW 01 KRIAN, SIDOARJO', '2013-12-09', '', '', 'SMK KRIAN 1 SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(53, '53', '125', 12, 23, 'ARIS KHAYURI', '1311490', '3515010911940001', '986780005603000', 'L', '2013-07-08', '0000-00-00', 'Y', '', '', '1994-11-09', 'SEGODO RT01 RW01 SEGODOBANCANG TARIK SIDOARJO', '2013-12-09', '', '', 'SMK PEMESINAN YPM 7 TARIK SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(54, '54', '309', 12, 23, 'TOMY ANDRIANSYAH', '1311633', '3515010803890001', '543586937603000', 'L', '2014-11-20', '0000-00-00', 'Y', '', '', '1989-03-08', 'KENDAL RT03 RW01 KENDALSEWU TARIK SIDOARJO', '2015-02-23', '', '', 'SMK PEMESINAN YPM 7 TARIK SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(55, '55', '155', 12, 23, 'FANNY ARIESTA ', '1508251', '3525143101930001', '', 'L', '2015-08-06', '0000-00-00', 'Y', '', '', '1993-01-31', 'PANGLIMA SUDIRMAN 160, RT05 RW03 SIDOMORO KEBOMAS GRESIK', '2015-11-06', '', '', 'D3 TEKNIK KIMIA POLITEKNIK NEGERI MALANG', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(56, '56', '40', 9, 23, 'FIQI AINNURROHMA', '17111026', '3518144606930001', '835080573655000', 'P', '2016-09-01', '0000-00-00', 'Y', '', '', '1993-06-06', 'TEMPURAN RT08 RW02 BANARANKULON BAGOR NGANJUK', '2017-11-01', '', '', 'S1 APOTEKER UNIVERSITAS AIRLANGGA SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(57, '57', '244', 7, 23, 'RIRIS ARIFIANA', '17011007', '3516016610920001', '', 'P', '2017-01-02', '0000-00-00', 'Y', '', '', '1992-10-26', 'JL. HASANUDIN RT03 RW08 DINOYO JATIREJO MOJOKERTO', '2017-01-02', '', '', 'SMK MULTIMEDIA N 1 JATIREJO MOJOKERTO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(58, '58', '16', 9, 14, 'SHELVI ISMADA BINTARASARI', '20011065', '3576015508940001', '', 'P', '2020-01-02', '0000-00-00', 'Y', '', '', '1994-08-15', 'MIJI III/2 RT 02 RW 01 MIJI,KRANGGAN,MOJOKERTO', '2020-01-02', '', '', 'S1 KIMIA/MATEMATIKA DAN IPA INSTITUT TEKNOLOGI SEP', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(59, '59', '99', 12, 23, 'M. RISFENDI', '1211410', '3515101511890002', '550461594603000', 'L', '2010-11-24', '0000-00-00', 'Y', '', '', '1989-11-15', 'DSN JEDONG RT 013 RW 03 JEDONGCANGKRING, PRAMBON, SIDOARJO', '2012-11-19', '', '', 'SMK KRIAN 1 SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(6, '6', '2', 6, 3, 'LELA YULAELA', '091006', '3578196101820001', '972234132604000', 'P', '2009-07-13', '0000-00-00', 'Y', '', '', '1982-01-21', 'JL. KANDANGAN JAYA 3 / 23 RT 05 RW 01 BENOWO, SURABAYA', '2009-06-08', '', '', 'S1-MANAJEMEN UNIVERSITAS WIJAYA KUSUMA SURABAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(60, '60', '', 9, 24, 'HARIS WAHYUDI', '', '3515132011770000', '', 'L', '2020-05-05', '0000-00-00', 'Y', '', '', '1977-11-20', 'DSN BRINGINKULON RT 07 RW 04 BRINGINBENDO, TAMAN, SIDOARJO', '0000-00-00', '', '', 'STM NEGERI KEDIRI', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(61, '61', '449', 7, 25, 'IFLAN RAHAFIANSYAH', '', '3517182306870002', '', 'L', '2020-11-02', '0000-00-00', 'Y', '', '', '0000-00-00', 'DSN BODEH RT 03 RW 01 KAYEN, BANDARKEDUNGMULYO, JOMBANG', '0000-00-00', '', '', '', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(62, '62', '146', 7, 23, 'DEDIK ARIAWAN', '', '3517080101900004', '758738280602000', 'L', '2020-12-01', '0000-00-00', 'Y', '', '', '0000-00-00', 'DSN NGLEREP RT 02 RW 01 KWARON, DIWEK, JOMBANG', '0000-00-00', '', '', 'D1 TEKNIK PERGULAAN JOMBANG COMMUNITY COLLEGE', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(63, '63', '11', 12, 26, 'MALIFUL AR RAHMAN', '031019', '3515110609790004', '972233746603000', 'L', '2003-03-14', '0000-00-00', 'Y', '', '', '1979-09-06', 'DSN BALEPANJANG RT 07 RW 01 TROPODO, KRIAN, SIDOARJO', '2009-06-08', '', '', 'S1 EKONOMI MANAJEMEN DR.SOETOMO SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(64, '64', '61', 7, 26, 'RACHMAD AMIN SEDIYO UTOMO', '041064', '3515112106840003', '885576397603000', 'L', '2004-04-30', '0000-00-00', 'Y', '', '', '1984-06-21', 'SIDOMOJO RT1 RW 1 KRIAN - SDA', '2009-06-08', '', '', 'SMK KRIAN 1 SIDOARJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(65, '65', '18', 7, 26, 'A.HANIF ARIANTO', '081065', '3515112809870001', '972233845603000', 'L', '2006-01-12', '0000-00-00', 'Y', '', '', '1987-09-28', 'KASAK RT4RW3 KRIAN', '2009-10-15', '', '', 'SMK YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(66, '66', '47', 12, 26, 'ARIS SRI NINGSIH', '081074', '3515114706830001', '972233910603000', 'P', '2006-01-20', '0000-00-00', 'Y', '', '', '1983-06-07', 'DS.SIDOMOJO RT3 RW 1', '2009-06-08', '', '', 'SMK N 1 SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(67, '67', '39', 12, 26, 'HENY KUSMAWATI', '061025', '3515104911870002', '972233811603000', 'P', '2006-07-24', '0000-00-00', 'Y', '', '', '1987-11-09', 'TANGGUL WETAN RT 02 RW 02 WONOAYU, SIDOARJO', '2009-06-08', '', '', 'SMA AL-ISLAM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(68, '68', '25', 4, 26, 'AINUL AL KAMILAH', '101068', '3515114802850001', '885576389603000', 'P', '2008-05-22', '0000-00-00', 'Y', '', '', '1985-02-08', 'SIDOMOJO RT02 RW01 KRIAN-SDA', '2010-05-25', '', '', 'SMK PEMUDA KRIAN SIDOARJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(69, '69', '81', 14, 26, 'AGUNG SAMBUDI', '101071', '3578242204890002', '972233852615000', 'L', '2009-03-05', '0000-00-00', 'Y', '', '', '1989-04-22', 'WONOKUPANG RT 05 RW 03 BALONGBENDO, SIDOARJO', '2010-06-25', '', '', 'SMK KRISTEN PETRA SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(7, '7', '2049', 4, 14, 'EVY SETYANINGSIH', '1211404', '3515014808810001', '550473342603000', 'P', '2009-10-07', '0000-00-00', 'Y', '', '', '1981-08-08', 'KLINTER RT 018 RW 04 BANJARWUNGU, TARIK, SIDOARJO', '2012-11-19', '', '', 'SMA BUDI UTOMO PRAMBON', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(70, '70', '66', 12, 26, 'RAHMAD AZIS', '101072', '3578160406910005', '972233928616000', 'L', '2009-06-01', '0000-00-00', 'Y', '', '', '1991-06-04', 'JL AMPEL KESUMBA PASAR NO 41', '2010-06-25', '', '', 'SMK N 2 SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(71, '71', '67', 12, 26, 'A. NUR CHOLIL UBAIDILLAH', '101076', '3525050810910003', '972233803612000', 'L', '2009-06-08', '0000-00-00', 'Y', '', '', '1991-10-08', 'DS PANJUNAN KEC. DUDUK SAMPEYAN GRESIK', '2010-06-25', '', '', 'SMK ST LOUIS SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(72, '72', '69', 12, 26, 'TRIYA RAHARJA', '101075', '3515121705910001', '972233878603000', 'L', '2009-07-07', '0000-00-00', 'Y', '', '', '1991-05-17', 'BAKUNGPRINGGODANI RT01 RW01 BALONGBENDO-SDA', '2010-06-25', '', '', 'SMK KRISTEN PETRA SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(73, '73', '116', 12, 26, 'JEFRI FARISKAH', '101099', '3525021405900001', '550434500642000', 'L', '2009-12-03', '0000-00-00', 'Y', '', '', '1990-05-14', 'KALIANYAR RT01 RW01 BALONGPANGGANG - GRESIK', '2013-02-25', '', '', 'SMK KRISTEN PETRA SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(74, '74', '132', 12, 26, 'SUHERMAN', '1010130', '3515020904900001', '986780054603000', 'L', '2010-01-04', '0000-00-00', 'Y', '', '', '1990-04-09', 'SIMOGIRANG RT01 RW03 SIMOGIRANG PRAMBON SIDOARJO', '2013-12-09', '', '', 'SMK TEKNIK MEKANIK OTOMOTIF KRIAN 2 SIDOARJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(75, '75', '93', 12, 26, 'SEPTI ASFIANTO', '1010126', '3578031609880002', '885576421615000', 'L', '2010-01-18', '0000-00-00', 'Y', '', '', '1988-09-16', 'RUNGKUT KIDUL I/32 RT02 RW01 RUNGKUT - SBY', '2012-07-20', '', '', 'SMK KRISTEN PETRA SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(76, '76', '95', 12, 26, 'DADANG PRIANTO AFANDI', '101083', '3515112404870001', '885576413603000', 'L', '2010-03-18', '0000-00-00', 'Y', '', '', '1987-04-24', 'SIDOMOJO RT03 RW01 KRIAN-SDA', '2012-07-20', '', '', 'SMK YPM 1 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(77, '77', '313', 12, 26, 'DANANG SUPRIANTO', '101084', '3525082812900001', '800011025603000', 'L', '2010-04-07', '0000-00-00', 'Y', '', '', '1990-12-28', 'MENUNGGAL RT08 RW02 MENUNGGAL KEDAMEAN GRESIK', '2015-02-23', '', '', 'SMK PEMESINAN BHAKTI KITA DRIYOREJO GRESIK', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(78, '78', '133', 12, 26, 'MASRUDI', '1010109', '3515110205840004', '706465234603000', 'L', '2010-04-09', '0000-00-00', 'Y', '', '', '1984-05-02', 'KASAK RT03 RW03 TERUNGKULON KRIAN SIDOARJO', '2013-12-09', '', '', 'SMK TEKNIK MEKANIK OTOMOTIF YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(79, '79', '327', 12, 26, 'ACHMAD FAHRUL ARIF', '1409361', '3578162607920002', '940284151603000', 'L', '2010-05-05', '0000-00-00', 'Y', '', '', '1992-07-26', 'BENDUL MERISI SELATAN BUNTU 1 RT04 RW07 BENDUL MERISI WONOCOLO SURABAYA', '2016-01-04', '', '', 'SMK PEMESINAN KRISTEN PETRA SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(8, '8', '2004', 9, 12, 'ANNA PRATIWI WULANDARI', '101009', '3578046505850012', '476095906627000', 'P', '2010-01-02', '0000-00-00', 'Y', '', '', '1985-05-25', 'GRIYA KEBRAON TENGAH T/12 SURABAYA', '2009-06-08', '', '', 'D3-AKUTANSI UBAYA', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(80, '80', '63', 12, 26, 'MUHAMMAD SULTON', '1010108', '3578272004880003', '972233886604000', 'L', '2010-05-31', '0000-00-00', 'Y', '', '', '1988-04-20', 'JL SIMO PRONAJAYA II/10 SURABAYA', '2010-09-21', '', '', 'SMK N 2 SURABAYA', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(81, '81', '35', 12, 26, 'BENY SETIYAWAN', '1010185', '3512063009780003', '885576306656000', 'L', '2010-11-08', '0000-00-00', 'Y', '', '', '1978-09-30', 'JL CEMPAKA II KRAJAN BARAT RT 04 RW 02 SUMBERKOLAK, PANARUKAN, SITUBONDO', '2011-05-25', '', '', 'SMK N 2 PROBOLINGGO', '', '', NULL, 0, '', 'Mojoagung', 'Y', 1, '2021-01-01'),
(82, '82', '135', 12, 26, 'NANANG KUSWANTO', '1312744', '3515111804840003', '986779742603000', 'L', '2010-11-12', '0000-00-00', 'Y', '', '', '1984-04-18', 'KASAK RT04 RW03 TERUNGKULON KRIAN SIDOARJO', '2013-12-09', '', '', 'SMK MEKANIK OTOMOTIF YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(83, '83', '134', 12, 26, 'DIAN FEBRI WIYONO', '101085', '3515111202840004', '986779916603000', 'L', '2011-07-04', '0000-00-00', 'Y', '', '', '1984-02-12', 'KASAK RT05 RW03 TERUNGKULON KRIAN SIDOARJO', '2013-12-09', '', '', 'SMK MEKANIK OTOMOTIF YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(84, '84', '129', 14, 26, 'ERVAN ALFIANTO', '1312733', '3515132711900002', '706465325603000', 'L', '2012-12-05', '0000-00-00', 'Y', '', '', '1990-11-27', 'MIJEN RT18 RW04 SIDODADI TAMAN SIDOARJO', '2013-12-09', '', '', 'SMA BAHASA WACHID HASYIM 2 TAMAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(85, '85', '325', 12, 26, 'MOCHAMMAD CHOLIS', '1010107', '3515112206890004', '734043029603000', 'L', '2014-07-02', '0000-00-00', 'Y', '', '', '1989-06-22', 'KASAK RT04 RW03 TERUNGKULON KRIAN SIDOARJO', '2015-02-23', '', '', 'SMK MEKANIK OTOMOTIK YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(86, '86', '316', 12, 26, 'SAIPUL ARIPIN', '1010125', '3525153009890001', '940285695603000', 'L', '2014-07-02', '0000-00-00', 'Y', '', '', '1989-09-30', 'TANJUNGAN RT17 RW03 TANJUNGAN DRIYOREJO GRESIK', '2016-01-04', '', '', 'SMA IPS YPM 4 DRIYOREJO GRESIK', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(87, '87', '320', 12, 26, 'AMALUL ICHSAN ', '1502666', '3515111906960002', '833564560603000', 'L', '2014-11-14', '0000-00-00', 'Y', '', '', '1996-06-19', 'TENGGULUNAN RT15 RW02 WATUGOLONG KRIAN SIDOARJO', '2016-09-01', '', '', 'SMK TEKNIK KENDARAAN RINGAN KRIAN 2 SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(88, '88', '92', 7, 26, 'GALIH ANGGARA MUKTI', '1504603', '6474012911890009', '973060973653000', 'L', '2015-04-27', '0000-00-00', 'Y', '', '', '1989-11-29', 'PERUM GKR M/09 RT01 RW16 SANANWETAN BLITAR', '2016-01-27', '', '', 'D3 TEKNIK MESIN  POLITEKNIK NEGERI MALANG', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(89, '89', '311', 12, 26, 'AFIF PUTRO SETYO', '17011002', '3515111010930001', '715568200603000', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1993-10-10', 'KASAK RT04 RW03 TERUNGKULON KRIAN SIDOARJO', '2017-01-02', '', '', 'SMA WAHID HASYIM KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(9, '9', '2005', 6, 3, 'PIPIN SAVITRI YUSOVIN', '1110265', '3515115907970003', '972233738603000', 'P', '2011-07-11', '0000-00-00', 'Y', '', '', '1993-07-19', 'KRATON RT.12 / RW.03 KRIAN - SIDOARJO', '2012-01-02', '', '', 'SMK YAPALIS KRIAN SIDOARJO', '', '', NULL, 0, '', 'Krian', 'Y', 1, '2021-01-01'),
(90, '90', '321', 12, 26, 'IMAM HANAFI', '17011004', '3507022705950002', '845297720654000', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1995-05-27', 'KRAJAN RT15 RW04 SEMPOL PAGAK MALANG', '2017-01-02', '', '', 'SMK ELEKTRONIKA INDUSTRI N 1 KEPANJEN MALANG', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(91, '91', '287', 12, 26, 'DWI SURYO PRASETYO', '17011003', '3508071310890002', '733760854625000', 'L', '2017-01-02', '0000-00-00', 'Y', '', '', '1989-10-13', 'TUNJUNGREJO KIDUL RT03 RW03 YOSOWILANGUN TUNJUNGREJO LUMAJANG', '2017-01-02', '', '', 'SMA IPS PAKET C LUMAJANG', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(92, '92', '342', 12, 26, 'MUHAMAD AVIN YURISTIAWAN', '17021008', '3515110809900001', '715440434603000', 'L', '2017-02-01', '0000-00-00', 'Y', '', '', '1990-09-08', 'SEMAJI RT15 RW04 KEMASAN KRIAN SIDOARJO', '2017-02-01', '', '', 'SMK MEKANIK OTOMOTIF YPM 4 TAMAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(93, '93', '314', 12, 26, 'TRI PRASTYIA PURNOMO', '17021009', '3578021404890001', '863705141609000', 'L', '2017-02-01', '0000-00-00', 'Y', '', '', '1989-04-14', 'SIWALANKERTO 73/B RT05 RW01 SIWALANKERTO WONOCOLO SURABAYA', '2017-02-01', '', '', 'SMK PEMESINAN KRISTEN PETRA SURABAYA', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(94, '94', '322', 12, 26, 'YUNI PURWANTI', '17041014', '3515117005840002', '726631385603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1984-05-30', 'KALANGAN RT04 RW01 JATIKALANG KRIAN SIDOARJO', '2017-04-01', '', '', 'SMK AKUNTANSI YPM 5 SUKODONO SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(95, '95', '338', 12, 26, 'LAILI DUWI RUSALINAH', '17041019', '3515115002910001', '726751761603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1991-02-10', 'SEMAJI RT16 RW04 KEMASAN KRIAN SIDOARJO', '2017-04-01', '', '', 'SMA IPA WAHID HASYIM KRIAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(96, '96', '345', 12, 26, 'DEVI SUSANTI', '17041021', '3515114412880001', '721116259603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1988-12-04', 'TAMBAK WATU RT01 RW01 WATUGOLONG KRIAN SIDOARJO', '2017-04-01', '', '', 'SMA IPS PAKET C SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(97, '97', '272', 12, 26, 'SITI IBDAIYAH', '17041016', '3305105001870003', '726799026603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1987-01-10', 'TENGGULUNAN RT08 RW04 WATUGOLONG KRIAN SIDOARJO', '2017-04-01', '', '', 'MA IPS N KUTOWINANGUN KEBUMEN', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(98, '98', '277', 12, 26, 'ASLICHATIN', '17041022', '3515114104820002', '721116770603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1982-04-01', 'BARENGKRAJAN RT08 RW03 BARENGKRAJAN KRIAN SIDOARJO', '2017-04-01', '', '', 'MA IPS AL-IHSAN KRIAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01'),
(99, '99', '269', 12, 26, 'NINIK SUNDARI', '17041022', '3515115607890004', '721116952603000', 'P', '2017-04-01', '0000-00-00', 'Y', '', '', '1989-07-16', 'KATERUNGAN RT04 RW01 KATERUNGAN KRIAN SIDOARJO', '2017-04-01', '', '', 'SMA IPS DHARMA WANITA 3 KRIAN SIDOARJO', '', '', NULL, 0, '', '', 'Y', 1, '2021-01-01');

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
(1, '2072', 'Lembur Libur', '2021-03-02', '16:00:00', '20:00:00', 4, 'Lembur', 'Y', '2021-03-30 00:00:00', 'Form / HRD / 013 Rev.01', 'Y', 1);

-- --------------------------------------------------------

--
-- Table structure for table `master_umk`
--

CREATE TABLE `master_umk` (
  `id_umk` int(11) NOT NULL,
  `tahun_umk` int(11) NOT NULL,
  `total_umk` int(11) NOT NULL,
  `gaji_per_jam` int(11) NOT NULL,
  `plant` varchar(25) NOT NULL,
  `status_umk` char(1) NOT NULL,
  `change_by` int(11) NOT NULL,
  `change_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_umk`
--

INSERT INTO `master_umk` (`id_umk`, `tahun_umk`, `total_umk`, `gaji_per_jam`, `plant`, `status_umk`, `change_by`, `change_at`) VALUES
(1, 2021, 4293582, 15341, 'Krian', 'Y', 1, '2021-03-29');

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
(1, '2072', '2021-01-06', 'Ke Mojoagung', 'Jam Datang', '10:30:00', 'Y', 'Y', 'Form/HRD/018-Rev.01', 'Y', 2, '2021-04-02');

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
(1, '2072', 'admin', '21232f297a57a5a743894a0e4a801fc3', 2, 'Y', '2021-03-16', 1),
(2, '2072', 'hrd', '4bf31e6f4b818056eaacb83dff01c9b8', 2, 'Y', '2021-03-29', 1),
(3, '2072', 'do', 'd4579b2688d675235f402f6b4b43bcbf', 3, 'Y', '2021-03-29', 1),
(4, '2072', 'kbag', 'ab834cb539e64c1bf02ecf83725195fe', 4, 'Y', '2021-03-29', 1),
(5, '2072', 'karyawan', '9e014682c94e0f2cc834bf7348bda428', 5, 'Y', '2021-03-29', 1),
(6, '2072', 'su', '0b180078d994cb2b5ed89d7ce8e7eea2', 1, 'Y', '2021-03-29', 1);

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
  MODIFY `id_divisi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `master_jabatan`
--
ALTER TABLE `master_jabatan`
  MODIFY `id_jabatan` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
  MODIFY `id_lembur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `master_umk`
--
ALTER TABLE `master_umk`
  MODIFY `id_umk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transaksi_cuti`
--
ALTER TABLE `transaksi_cuti`
  MODIFY `id_cuti` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transaksi_surat_ijin`
--
ALTER TABLE `transaksi_surat_ijin`
  MODIFY `id_surat_ijin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
