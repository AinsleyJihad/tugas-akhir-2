<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class m_data extends CI_Model {

    public function __construct() {
        parent::__construct();
    }



    //=============================== API =====================================
    public function getApiMasterKaryawan($id){
        $query  = "SELECT k.id_karyawan, k.nama_karyawan, k.pin, j.nama_jabatan, d.nama_divisi, k.jenis_kelamin_karyawan, k.status_karyawan, IF(keterangan = 'Karyawan', CONCAT('KAR', LPAD(id_karyawan, 12, '0')), CONCAT('OUT', LPAD(id_karyawan, 12, '0'))) as view_id, k.id_divisi, k.id_jabatan
                    FROM master_karyawan k
                    JOIN master_jabatan j ON k.id_jabatan=j.id_jabatan
                    JOIN master_divisi d ON k.id_divisi=d.id_divisi
                    WHERE k.status_karyawan = 'Y' AND IF('".$id."' <> 0, k.id_karyawan = '".$id."', k.id_karyawan = k.id_karyawan)
                    ORDER BY k.id_karyawan ASC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== Dashboard =====================================
    public function getTotalKaryawan()
    {
        $query  = "SELECT COUNT(id_karyawan) as jumlah
                    FROM master_karyawan
                    WHERE master_karyawan.status_karyawan = 'Y'";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function getTotalSuratIjin()
    {
        $query  = "SELECT COUNT(id_surat_ijin) as jumlah
        FROM transaksi_surat_ijin
        WHERE transaksi_surat_ijin.status_ijin = 'Y' AND MONTH(transaksi_surat_ijin.tanggal_ijin) = MONTH(NOW()) 
        AND YEAR(transaksi_surat_ijin.tanggal_ijin) = YEAR(NOW())";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function getTotalCuti()
    {
        $query  = "SELECT COUNT(id_cuti) as jumlah
        FROM transaksi_cuti
        WHERE transaksi_cuti.status_cuti = 'Y' AND MONTH(transaksi_cuti.tanggal_mulai_cuti) = MONTH(NOW()) 
        AND YEAR(transaksi_cuti.tanggal_mulai_cuti) = YEAR(NOW())";
        $result = $this->db->query($query)->result_array();
        return $result;
    }


    //=============================== Absensi =====================================
    public function getMasterAbsensi()
    {
        $query  = "SELECT a.id_absensi, k.nama_karyawan, d.nama_divisi, j.nama_jabatan, k.plant, a.tanggal_absensi, a.jam_absensi, a.nama_mesin, a.status_absensi, u.username as change_by , a.change_at
                    FROM master_absensi a
                    JOIN master_karyawan k ON a.id_karyawan = k.id_karyawan
                    JOIN user_login u ON a.change_by = u.id_user
                    JOIN master_jabatan j ON j.id_jabatan = k.id_jabatan
                    JOIN master_divisi d ON d.id_divisi = k.id_divisi
                    WHERE a.status_absensi = 'Y'
                    ORDER BY a.id_absensi DESC
                    LIMIT 50";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function getIdKaryawanPin($pin, $plant)
    {
        $query  = "SELECT a.id_karyawan
                    FROM master_karyawan a
                    WHERE a.status_karyawan = 'Y'
                    AND a.pin = '".$pin."'
                    AND a.plant = '".$plant."'"
                    ;
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function getMasterLaporanAbsensi($id_karyawan, $id_divisi, $tanggal_awal, $tanggal_akhir){
        $query  = " SELECT a.id_karyawan, @id_jam_kerja := a.id_jam_kerja as id_jam_kerja, d.id_divisi, d.nama_divisi, j.nama_jabatan, b.plant, @tanggal := a.tanggal_jadwal as tanggal_jadwal, b.nama_karyawan,
                            @cuti :=  IF(EXISTS(
                                SELECT 'Y' as hasil
                                FROM master_jd_kerja_kyw
                                JOIN transaksi_cuti ON transaksi_cuti.id_karyawan = master_jd_kerja_kyw.id_karyawan
                                WHERE (master_jd_kerja_kyw.tanggal_jadwal BETWEEN transaksi_cuti.tanggal_mulai_cuti AND transaksi_cuti.tanggal_akhir_cuti) AND 													  transaksi_cuti.status_cuti = 'Y' AND
                                	  transaksi_cuti.id_karyawan = a.id_karyawan AND
                                	  master_jd_kerja_kyw.tanggal_jadwal = a.tanggal_jadwal AND
                                      transaksi_cuti.status_cuti = 'Y'
                                ),
                                (
                                    SELECT transaksi_cuti.id_cuti
                                    FROM master_jd_kerja_kyw
                                    JOIN transaksi_cuti ON transaksi_cuti.id_karyawan = master_jd_kerja_kyw.id_karyawan
                                    WHERE (master_jd_kerja_kyw.tanggal_jadwal BETWEEN transaksi_cuti.tanggal_mulai_cuti AND transaksi_cuti.tanggal_akhir_cuti) AND 													  transaksi_cuti.status_cuti = 'Y' AND
                                          transaksi_cuti.id_karyawan = a.id_karyawan AND
                                          master_jd_kerja_kyw.tanggal_jadwal = a.tanggal_jadwal AND
                                          transaksi_cuti.status_cuti = 'Y'
                                ), 'N'
                            ) as status_cuti,
                            @jam_masuk := (
                            IF((@id_jam_kerja <> 5 AND DAYNAME(@tanggal) <> 'Saturday') OR (@id_jam_kerja <> 5 AND DAYNAME(@tanggal) = 'Saturday'),
                               		(SELECT MIN(master_absensi.jam_absensi)
                                    FROM master_jd_kerja_kyw
                                    JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                                    WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    									  master_absensi.id_karyawan = b.id_karyawan AND
                                          master_absensi.status_absensi = 'Y'),
                               		IF(@id_jam_kerja = 5,
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
                                          master_absensi.status_absensi = 'Y')))
                            ) as jam_masuk,
                            @jam_pulang := (
                            IF((@id_jam_kerja <> 5 AND DAYNAME(@tanggal) <> 'Saturday') OR (@id_jam_kerja <> 5 AND DAYNAME(@tanggal) = 'Saturday'),
                            		(SELECT MAX(master_absensi.jam_absensi)
                                    FROM master_jd_kerja_kyw
                                    JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
                                    JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                                    WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    									  master_absensi.id_karyawan = b.id_karyawan AND
                                          master_absensi.status_absensi = 'Y'),
                               		IF(@id_jam_kerja = 5 AND DAYNAME(@tanggal) = 'Saturday',
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
                                          master_absensi.status_absensi = 'Y')))
                            ) as jam_pulang, @jd_masuk := c.jam_masuk as jd_masuk, @jd_pulang := c.jam_pulang as jd_pulang, @jd_masuk_sabtu := c.jam_masuk_sabtu as jd_masuk_sabtu, @jd_pulang_sabtu := c.jam_pulang_sabtu as jd_pulang_sabtu, @id_surat_ijin := IF(EXISTS(
                            SELECT 'Y' as hasil
                            FROM transaksi_surat_ijin
                            WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
                            ),
                            (SELECT transaksi_surat_ijin.id_surat_ijin
                            FROM transaksi_surat_ijin
                            WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as id_surat_ijin, 
                            @alasan_ijin := IF(EXISTS(
                            SELECT 'Y' as hasil
                            FROM transaksi_surat_ijin
                            WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
                            ),
                            (SELECT transaksi_surat_ijin.alasan_ijin
                            FROM transaksi_surat_ijin
                            WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as alasan_izin,
                            @jam_datang_keluar_ijin := IF(EXISTS(
                            SELECT 'Y' as hasil
                            FROM transaksi_surat_ijin
                            WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
                            ),
                            (SELECT transaksi_surat_ijin.jam_datang_keluar_ijin
                            FROM transaksi_surat_ijin
                            WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as jam_datang_keluar_ijin,
                            IF(getHari(@tanggal) = 'N',
                                IF(DAYNAME(@tanggal) = 'Saturday',
                                    IF(@cuti = 'N',
                                      IF(@id_surat_ijin = 'N',
                                        IF(@jam_masuk <> @jam_pulang,
                                            IF(@id_surat_ijin = 'N',
                                                IF(TIMEDIFF (@jam_masuk, @jd_masuk_sabtu) >= '0:10:0', 'Terlambat', 
                                                IF(TIMEDIFF (@jam_pulang, @jd_pulang_sabtu) >= '0:0:0', '-', 'Pulang Terlalu Cepat')),
                                                    @alasan_ijin), 'Data Absensi Ada Yang Kurang'), @alasan_ijin), 'Cuti'),
                                    IF(@cuti = 'N',
                                      IF(@id_surat_ijin = 'N',
                                        IF(@jam_masuk <> @jam_pulang,
                                            IF(@id_surat_ijin = 'N',
                                                IF(TIMEDIFF (@jam_masuk, @jd_masuk) >= '0:10:0', 'Terlambat', 
                                                IF(TIMEDIFF (@jam_pulang, @jd_pulang) >= '0:0:0', '-', 'Pulang Terlalu Cepat')),
                                                    @alasan_ijin), 'Data Absensi Ada Yang Kurang'), @alasan_ijin), 'Cuti')),
                                getHari(@tanggal)) as status
                    from master_jd_kerja_kyw as a,
                        master_karyawan as b,
                        master_jam_kerja c,
                        master_divisi d,
                        master_jabatan j
                    WHERE a.status = 'Y' AND
                        b.id_karyawan = a.id_karyawan AND
                        c.id_jam_kerja = a.id_jam_kerja AND
                        d.id_divisi = b.id_divisi AND
                        j.id_jabatan = b.id_jabatan AND
                        if('".$id_karyawan."' = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = '".$id_karyawan."') AND
                        if('".$id_divisi."' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '".$id_divisi."') AND
                        a.tanggal_jadwal BETWEEN '".$tanggal_awal."' AND '".$tanggal_akhir."'
                    ORDER BY a.tanggal_jadwal ASC";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function getLastIdAbsensi($tanggal) {
        $query  = "SELECT SUBSTRING(MAX(a.id_absensi), 9, 16)+1-1 AS MAX_ID 
                    FROM master_absensi a
                    WHERE SUBSTRING(a.id_absensi, 1, 8) = REPLACE('".$tanggal."', '-', '') ";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function getIdAbsensi($tanggal, $id_absensi){
        $query  = "SELECT concat(REPLACE('".$tanggal."', '-', ''), LPAD('".$id_absensi."' ,8, 0)) as id_absensi";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function checkAbsensi($id_karyawan, $tanggal_absensi, $jam_absensi){
        $query  = "SELECT IF(EXISTS(
                    SELECT 'Y' as hasil
                    FROM master_absensi a
                    WHERE a.id_karyawan = '".$id_karyawan."' AND a.jam_absensi = '".$jam_absensi."' AND a.tanggal_absensi = '".$tanggal_absensi."'
                   ), 'Y', 'N') as hasil";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function inputAbsensi($id_absensi, $id_karyawan, $tanggal, $jam_absensi, $status_absensi, $change_by, $nama_mesin){
        $query = 
        "INSERT INTO master_absensi
        VALUES ('".$id_absensi."', '".$id_karyawan."','".$tanggal."', '".$jam_absensi."', '".$nama_mesin."', '".$status_absensi."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query);   
    }

    //=============================== Divisi =====================================
    
    public function getMasterDivisi(){
        $query  = "SELECT id_divisi, nama_divisi, status_divisi, user_login.username as change_by, master_divisi.change_at, CONCAT('DIV', LPAD(id_divisi, 5, '0')) as view_id
                    FROM master_divisi, user_login 
                    WHERE master_divisi.change_by = user_login.id_user AND master_divisi.status_divisi = 'Y'
                    ORDER BY master_divisi.id_divisi ASC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function inputDivisi($id_divisi, $nama_divisi, $status, $change_by, $reason){
        $query = 
        "INSERT INTO master_divisi(id_divisi, nama_divisi, status_divisi, change_by, change_at) 
        VALUES ('".$id_divisi."', '".$nama_divisi."', '".$status."', '".$change_by."', CURDATE())";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_divisi(id_divisi, nama_divisi , status_divisi ,reason, change_by, change_at) 
        VALUES ('".$id_divisi."','".$nama_divisi."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function getLastIdDivisi() {
        $query  = "SELECT MAX(id_divisi) AS MAX_ID FROM master_divisi";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editDivisi($id){
        $query = "SELECT *, CONCAT('DIV', LPAD(id_divisi, 5, '0')) as view_id FROM master_divisi WHERE id_divisi=".$id['id_divisi']."";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editDivisiSave($id_divisi, $nama_divisi, $status_divisi, $change_by, $reason){
        $query = 
        "UPDATE master_divisi
        SET nama_divisi='".$nama_divisi."', status_divisi='".$status_divisi."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_divisi='".$id_divisi."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_divisi(id_divisi, nama_divisi , status_divisi ,reason, change_by, change_at) 
        VALUES ('".$id_divisi."','".$nama_divisi."','".$status_divisi."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusDivisi($id_divisi, $change_by, $reason){
        $query = 
        "UPDATE master_divisi
        SET status_divisi='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_divisi='".$id_divisi."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_divisi(id_divisi, nama_divisi , status_divisi ,reason, change_by, change_at) 
        VALUES ('".$id_divisi."','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function checkDivisi($nama_divisi){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_divisi
        WHERE master_divisi.nama_divisi = '".$nama_divisi."' AND
        master_divisi.status_divisi = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditDivisi($nama_divisi, $status_divisi){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_divisi
        WHERE master_divisi.nama_divisi = '".$nama_divisi."' AND master_divisi.status_divisi = '".$status_divisi."' AND
        master_divisi.status_divisi = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }
   

    //=============================== Jabatan =====================================
    public function getMasterJabatan(){
        $query  = "SELECT id_jabatan, nama_jabatan, status_jabatan, user_login.username as change_by, master_jabatan.change_at , CONCAT('JAB', LPAD(id_jabatan, 5, '0')) as view_id
        FROM master_jabatan, user_login 
        WHERE master_jabatan.change_by = user_login.id_user AND master_jabatan.status_jabatan = 'Y'
        ORDER BY id_jabatan ASC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function checkEditJabatan($nama_jabatan, $status_jabatan){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_jabatan
        WHERE master_jabatan.nama_jabatan = '".$nama_jabatan."' AND 
        master_jabatan.status_jabatan = '".$status_jabatan."' AND 
        master_jabatan.status_jabatan = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkJabatan($nama_jabatan){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_jabatan
        WHERE master_jabatan.nama_jabatan = '".$nama_jabatan."' AND
        master_jabatan.status_jabatan = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function inputJabatan($id_jabatan, $nama_jabatan, $status, $change_by, $reason){
        $query = 
        "INSERT INTO master_jabatan(id_jabatan, nama_jabatan, status_jabatan, change_by, change_at) 
        VALUES ('".$id_jabatan."', '".$nama_jabatan."', '".$status."', '".$change_by."', CURDATE())";
        
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_jabatan(id_jabatan,nama_jabatan , status_jabatan, reason, change_by, change_at) 
        VALUES ('".$id_jabatan."','".$nama_jabatan."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function getLastIdJabatan() {
        $query  = "SELECT MAX(id_jabatan) AS MAX_ID FROM master_jabatan";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editJabatan($id){
        $query = "SELECT *, CONCAT('JAB', LPAD(id_jabatan, 5, '0')) as view_id FROM master_jabatan WHERE id_jabatan=".$id['id_jabatan']."";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editJabatanSave($id_jabatan, $nama_jabatan, $status_jabatan, $change_by, $reason){
        $query = 
        "UPDATE master_jabatan
        SET nama_jabatan='".$nama_jabatan."', status_jabatan='".$status_jabatan."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_jabatan='".$id_jabatan."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_jabatan(id_jabatan,nama_jabatan ,status_jabatan, reason, change_by, change_at) 
        VALUES ('".$id_jabatan."','".$nama_jabatan."','".$status_jabatan."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusJabatan($id_jabatan, $change_by, $reason){
        $query = 
        "UPDATE master_jabatan
        SET status_jabatan='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_jabatan='".$id_jabatan."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_jabatan(id_jabatan,nama_jabatan , status_jabatan, reason, change_by, change_at) 
        VALUES ('".$id_jabatan."','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    //=============================== Jam Kerja =====================================
    public function getMasterJamKerja(){
        $query  = "SELECT id_jam_kerja, nama_jam_kerja, TIME_FORMAT(jam_masuk, '%H : %i') as jam_masuk, TIME_FORMAT(jam_pulang, '%H : %i') as jam_pulang, TIME_FORMAT(jam_masuk_sabtu, '%H : %i') as jam_masuk_sabtu, TIME_FORMAT(jam_pulang_sabtu, '%H : %i') as jam_pulang_sabtu, status_jam_kerja, user_login.username as change_by, master_jam_kerja.change_at , CONCAT('JMK', LPAD(id_jam_kerja, 5, '0')) as view_id
                    FROM master_jam_kerja, user_login 
                    WHERE master_jam_kerja.change_by = user_login.id_user AND master_jam_kerja.status_jam_kerja = 'Y'
                    ORDER BY master_jam_kerja.id_jam_kerja";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function inputJamKerja($id_jam_kerja, $nama_jam_kerja, $jam_masuk, $jam_pulang, $jam_masuk_sabtu, $jam_pulang_sabtu, $status, $change_by, $reason){
        $query = 
        "INSERT INTO master_jam_kerja(id_jam_kerja, nama_jam_kerja, jam_masuk, jam_pulang, jam_masuk_sabtu, jam_pulang_sabtu, status_jam_kerja, change_by, change_at) 
        VALUES ('".$id_jam_kerja."', '".$nama_jam_kerja."','".$jam_masuk."', '".$jam_pulang."','".$jam_masuk_sabtu."', '".$jam_pulang_sabtu."', '".$status."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_jam_kerja(id_jam_kerja, nama_jam_kerja, jam_masuk, jam_pulang, jam_masuk_sabtu, jam_pulang_sabtu, status_jam_kerja, reason , change_by, change_at) 
        VALUES ('".$id_jam_kerja."','".$nama_jam_kerja."','".$jam_masuk."','".$jam_pulang."','".$jam_masuk_sabtu."','".$jam_pulang_sabtu."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function getLastIdJamKerja() {
        $query  = "SELECT MAX(id_jam_kerja) AS MAX_ID FROM master_jam_kerja";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editJamKerja($id){
        $query = "SELECT id_jam_kerja, nama_jam_kerja, TIME_FORMAT(jam_masuk, '%H:%i') AS jam_masuk, TIME_FORMAT(jam_pulang, '%H:%i') AS jam_pulang, TIME_FORMAT(jam_masuk_sabtu, '%H:%i') AS jam_masuk_sabtu, TIME_FORMAT(jam_pulang_sabtu, '%H:%i') AS jam_pulang_sabtu, status_jam_kerja, CONCAT('JMK', LPAD(id_jam_kerja, 5, '0')) as view_id
                    FROM master_jam_kerja 
                    WHERE id_jam_kerja=".$id['id_jam_kerja'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editJamKerjaSave($id_jam_kerja, $nama_jam_kerja, $jam_masuk, $jam_pulang, $jam_masuk_sabtu, $jam_pulang_sabtu, $status_jam_kerja, $change_by, $reason){
        $query = 
        "UPDATE master_jam_kerja
        SET nama_jam_kerja='".$nama_jam_kerja."', jam_masuk='".$jam_masuk."', jam_pulang='".$jam_pulang."', jam_masuk_sabtu='".$jam_masuk_sabtu."', jam_pulang_sabtu='".$jam_pulang_sabtu."', status_jam_kerja='".$status_jam_kerja."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_jam_kerja='".$id_jam_kerja."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_jam_kerja(id_jam_kerja, nama_jam_kerja, jam_masuk, jam_pulang, jam_masuk_sabtu, jam_pulang_sabtu, status_jam_kerja, reason, change_by, change_at) 
        VALUES ('".$id_jam_kerja."','".$nama_jam_kerja."','".$jam_masuk."','".$jam_pulang."','".$jam_masuk_sabtu."','".$jam_pulang_sabtu."','".$status_jam_kerja."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusJamKerja($id_jam_kerja, $change_by, $reason){
        $query = 
        "UPDATE master_jam_kerja
        SET status_jam_kerja='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_jam_kerja='".$id_jam_kerja."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_jam_kerja(id_jam_kerja, nama_jam_kerja, jam_masuk, jam_pulang, jam_masuk_sabtu, jam_pulang_sabtu, status_jam_kerja, reason, change_by, change_at) 
        VALUES ('".$id_jam_kerja."','-','-','-','-','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function checkJamKerja($nama_jam_kerja, $jam_masuk,$jam_pulang, $jam_masuk_sabtu, $jam_pulang_sabtu){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_jam_kerja
        WHERE master_jam_kerja.nama_jam_kerja = '".$nama_jam_kerja."' AND master_jam_kerja.jam_masuk = '".$jam_masuk."' AND
        master_jam_kerja.jam_pulang = '".$jam_pulang."' AND master_jam_kerja.jam_masuk_sabtu = '".$jam_masuk_sabtu."' AND 
        master_jam_kerja.jam_pulang_sabtu = '".$jam_pulang_sabtu."' AND master_jam_kerja.status_jam_kerja   = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditJamKerja($nama_jam_kerja, $jam_masuk,$jam_pulang, $jam_masuk_sabtu, $jam_pulang_sabtu, $status_jam_kerja){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_jam_kerja
        WHERE master_jam_kerja.nama_jam_kerja = '".$nama_jam_kerja."' AND master_jam_kerja.jam_masuk = '".$jam_masuk."' AND
        master_jam_kerja.jam_pulang = '".$jam_pulang."' AND master_jam_kerja.jam_masuk_sabtu = '".$jam_masuk_sabtu."' 
        AND master_jam_kerja.jam_pulang_sabtu = '".$jam_pulang_sabtu."' AND 
        master_jam_kerja.status_jam_kerja = '".$status_jam_kerja."'  AND 
        master_jam_kerja.status_jam_kerja   = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }


    //=============================== Jadwal Kerja =====================================

    public function getLastIdJadwalKerja() {
        $query  = "SELECT MAX(id_jadwal) AS MAX_ID FROM master_jd_kerja_kyw";
        $result = $this->db->query($query)->result_array();
        return $result;
    }
    
    public function getMasterJadwalKerja(){
        $query  = "SELECT j.id_jadwal, k.nama_karyawan, CONCAT(jk.nama_jam_kerja, '</br>(',TIME_FORMAT(jk.jam_masuk, '%H:%i'), ' - ',TIME_FORMAT(jk.jam_pulang, '%H:%i'), ')') as nama_jam_kerja, j.tanggal_jadwal, j.status, j.change_at, u.username as change_by, CONCAT('JDK', LPAD(j.id_jadwal, 11, '0')) as view_id, k.id_karyawan, jk.id_jam_kerja
                    FROM master_jd_kerja_kyw j
                    JOIN master_karyawan k ON j.Id_karyawan = k.id_karyawan
                    JOIN user_login u ON u.id_user = j.change_by
                    JOIN master_jam_kerja jk ON jk.id_jam_kerja = j.id_jam_kerja
                    WHERE j.status = 'Y'
                    ORDER BY j.id_jadwal DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function inputJadwalKerja($id_jadwal, $id_karyawan, $id_jam_kerja, $date, $status, $change_by, $reason){
        $query = 
        "INSERT INTO master_jd_kerja_kyw
        VALUES ('".$id_jadwal."', '".$id_karyawan."','".$id_jam_kerja."', '".$date."','".$status."', CURDATE(), '".$change_by."');";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_jd_kerja_kyw 
        VALUES ('".$id_jadwal."','".$id_karyawan."','".$id_jam_kerja."','".$date."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function editJadwalKerja($id){
        $query = "SELECT id_jadwal, id_karyawan, id_jam_kerja, id_jam_kerja, tanggal_jadwal, status, CONCAT('JDK', LPAD(id_jadwal, 11, '0')) as view_id
                    FROM master_jd_kerja_kyw 
                    WHERE id_jadwal=".$id['id_jadwal'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editJadwalKerjaSave($id_jadwal, $id_karyawan, $id_jam_kerja, $date, $status_jadwal_kerja, $change_by, $reason){
        $query = 
        "UPDATE master_jd_kerja_kyw
        SET id_karyawan='".$id_karyawan."', id_jam_kerja='".$id_jam_kerja."', tanggal_jadwal='".$date."', status='".$status_jadwal_kerja."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_jadwal='".$id_jadwal."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_jd_kerja_kyw 
        VALUES ('".$id_jadwal."','".$id_karyawan."','".$id_jam_kerja."','".$date."','".$status_jadwal_kerja."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusJadwalKerja($id_jadwal_kerja, $id_karyawan, $id_jam_kerja, $change_by, $reason){
        $query = 
        "UPDATE master_jd_kerja_kyw
        SET status='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_jadwal='".$id_jadwal_kerja."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_jd_kerja_kyw 
        VALUES ('".$id_jadwal_kerja."','".$id_karyawan."','".$id_jam_kerja."','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function checkJadwal($id_karyawan, $tanggal){
        $query  = "SELECT IF(EXISTS(
                    SELECT 'Y' as hasil
                    FROM master_jd_kerja_kyw a
                    WHERE a.id_karyawan = '".$id_karyawan."' AND a.tanggal_jadwal = '".$tanggal."' AND a.status = 'Y'
                   ), 'Y', 'N') as hasil";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function checkEditJadwal($id_karyawan, $tanggal, $id_jam_kerja, $status){
        $query  = "SELECT IF(EXISTS(
                    SELECT 'Y' as hasil
                    FROM master_jd_kerja_kyw a
                    JOIN master_jam_kerja b on a.id_jam_kerja = b.id_jam_kerja
                    WHERE a.id_karyawan = '".$id_karyawan."' AND a.tanggal_jadwal = '".$tanggal."' 
                    AND a.tanggal_jadwal = '".$tanggal."' 
                    AND b.id_jam_kerja = '".$id_jam_kerja."'
                    AND a.status = '".$status."'
                    AND a.status = 'Y'), 'Y', 'N') as hasil";
        $result = $this->db->query($query)->result_array();
        return $result;
    }


    //=============================== Kalender =====================================
    public function getMasterKalender(){
        $query  = "SELECT id_kalender, nama_hari, jenis_hari, tanggal_mulai, tanggal_akhir, jumlah_hari, status_kalender, user_login.username as change_by, master_kalender.change_at 
        FROM master_kalender, user_login 
        WHERE master_kalender.change_by = user_login.id_user AND status_kalender ='Y'
        ORDER BY id_kalender DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function inputKalender($id_kalender, $jenis_hari, $tanggal_mulai, $tanggal_akhir, $status, $change_by, $reason, $nama_hari){
        $query = 
        "INSERT INTO master_kalender(id_kalender, nama_hari, jenis_hari, tanggal_mulai, tanggal_akhir, jumlah_hari, status_kalender, change_by, change_at) 
        VALUES ('".$id_kalender."', '".$nama_hari."', '".$jenis_hari."','".$tanggal_mulai."', '".$tanggal_akhir."', DATEDIFF(tanggal_akhir, tanggal_mulai)+1, '".$status."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_kalender(id_kalender, nama_hari, jenis_hari, tanggal_mulai, tanggal_akhir, jumlah_hari, status_kalender, reason, change_by, change_at) 
        VALUES ('".$id_kalender."','".$nama_hari."','".$jenis_hari."','".$tanggal_mulai."','".$tanggal_akhir."', DATEDIFF(tanggal_akhir, tanggal_mulai)+1,'".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function getLastIdKalender() {
        $query  = "SELECT MAX(id_kalender) AS MAX_ID FROM master_kalender";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editKalender($id){
        $query = "SELECT *, CONCAT('KAL', LPAD(id_kalender, 5, '0')) as view_id
                    FROM master_kalender 
                    WHERE id_kalender=".$id['id_kalender'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editKalenderSave($id_kalender, $jenis_hari, $tanggal_mulai, $tanggal_akhir ,$status_kalender, $change_by, $reason, $nama_hari){
        $query = 
        "UPDATE master_kalender
        SET jenis_hari='".$jenis_hari."', nama_hari ='".$nama_hari."', tanggal_mulai ='".$tanggal_mulai."', tanggal_akhir ='".$tanggal_akhir."', jumlah_hari = DATEDIFF('".$tanggal_akhir."', '".$tanggal_mulai."')+1, status_kalender='".$status_kalender."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_kalender='".$id_kalender."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_kalender(id_kalender, nama_hari, jenis_hari, tanggal_mulai, tanggal_akhir, jumlah_hari, status_kalender, reason, change_by, change_at) 
        VALUES ('".$id_kalender."','".$nama_hari."','".$jenis_hari."','".$tanggal_mulai."','".$tanggal_akhir."', DATEDIFF('".$tanggal_akhir."', '".$tanggal_mulai."')+1,'".$status_kalender."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusKalender($id_kalender, $change_by, $reason){
        $query = 
        "UPDATE master_kalender
        SET status_kalender='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_kalender='".$id_kalender."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_kalender(id_kalender, nama_hari, jenis_hari, tanggal_mulai, tanggal_akhir, jumlah_hari, status_kalender, reason, change_by, change_at) 
        VALUES ('".$id_kalender."','-','-','-','-','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function checkKalender($nama_hari, $jenis_hari, $tanggal_mulai, $tanggal_akhir){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_kalender
        WHERE master_kalender.nama_hari = '".$nama_hari."' AND master_kalender.jenis_hari = '".$jenis_hari."' AND master_kalender.tanggal_mulai = '".$tanggal_mulai."' AND
        master_kalender.tanggal_akhir = '".$tanggal_akhir."' AND master_kalender.status_kalender   = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditKalender($nama_hari, $jenis_hari, $tanggal_mulai, $tanggal_akhir, $status_kalender){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_kalender
        WHERE master_kalender.nama_hari = '".$nama_hari."' AND master_kalender.jenis_hari = '".$jenis_hari."' 
        AND master_kalender.tanggal_mulai = '".$tanggal_mulai."' AND
        master_kalender.tanggal_akhir = '".$tanggal_akhir."' AND
        master_kalender.status_kalender = '".$status_kalender."' 
        AND master_kalender.status_kalender   = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    //=============================== Karyawan =====================================
    public function checkPin($pin, $plant){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_karyawan
        WHERE master_karyawan.pin = '".$pin."' 
        AND master_karyawan.plant = '".$plant."' 
        AND master_karyawan.status_karyawan = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkPinEdit($pin, $plant, $id){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_karyawan
        WHERE master_karyawan.pin = '".$pin."' 
        AND master_karyawan.plant = '".$plant."' 
        AND master_karyawan.status_karyawan = 'Y'
        AND master_karyawan.id_karyawan <> '".$id."'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function getAllNamaJabatan(){
        $query  = "SELECT id_jabatan, nama_jabatan FROM master_jabatan WHERE status_jabatan = 'Y'";
        $result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getAllNamaDivisi(){
        $query  = "SELECT id_divisi, nama_divisi FROM master_divisi WHERE status_divisi = 'Y'";
        $result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getAllNamaDanShiftJamKerja(){
        $query  = "SELECT id_jam_kerja, nama_jam_kerja, TIME_FORMAT(jam_masuk, '%H:%i') as jam_masuk, TIME_FORMAT(jam_pulang, '%H:%i') as jam_pulang, TIME_FORMAT(jam_masuk_sabtu, '%H:%i') as jam_masuk_sabtu, TIME_FORMAT(jam_pulang_sabtu, '%H:%i') as jam_pulang_sabtu
                    FROM master_jam_kerja
                    WHERE master_jam_kerja.status_jam_kerja = 'Y'";
        $result = $this->db->query($query)->result_array();
		return $result;
    }
    
    public function getMasterKaryawan(){
        $query  = "SELECT k.id_karyawan, k.nama_karyawan, k.pin, j.nama_jabatan, d.nama_divisi, k.jenis_kelamin_karyawan, k.status_karyawan, IF(keterangan = 'Karyawan', CONCAT('KAR', LPAD(id_karyawan, 12, '0')), CONCAT('OUT', LPAD(id_karyawan, 12, '0'))) as view_id, k.id_divisi, k.id_jabatan, k.bpjs_kesehatan, k.tunjangan_jabatan, k.plant, k.nik, k.no_ktp, k.npwp, k.tanggal_masuk_karyawan, k.tanggal_keluar_karyawan, k.telp_karyawan, k.tempat_lahir_karyawan, k.tanggal_lahir_karyawan, k.alamat_karyawan, k.tanggal_pengangkatan, k.k_tk, k.keterangan, k.pendidikan, k.pkwt1, k.pkwt2, k.gaji_pokok, k.ikut_penggajian, k.kawin_tdkkawin
                    FROM master_karyawan k
                    JOIN master_jabatan j ON k.id_jabatan=j.id_jabatan
                    JOIN master_divisi d ON k.id_divisi=d.id_divisi
                    WHERE k.status_karyawan = 'Y'
                    ORDER BY k.id_karyawan ASC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function inputKaryawan($auto_id, $pin, $id_jabatan, $id_divisi, $nama_karyawan, $nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $telp_karyawan, $tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $tanggal_pengangkatan, $keterangan, $k_tk, $pendidikan, $pkwt1, $pkwt2, $gaji_pokok, $tunjangan_jabatan, $bpjs_kesehatan, $plant, $ikut_penggajian, $kawin_tdkkawin, $status, $change_by, $reason){
        $query = 
        "INSERT INTO master_karyawan(auto_id, id_karyawan, pin, id_jabatan, id_divisi, nama_karyawan, nik, no_ktp, npwp, jenis_kelamin_karyawan, tanggal_masuk_karyawan, tanggal_keluar_karyawan, telp_karyawan, tempat_lahir_karyawan, tanggal_lahir_karyawan, alamat_karyawan, tanggal_pengangkatan, keterangan, k_tk, pendidikan, pkwt1, pkwt2, gaji_pokok, tunjangan_jabatan, bpjs_kesehatan, plant, ikut_penggajian, kawin_tdkkawin, status_karyawan, change_by, change_at) 
        VALUES ('".$auto_id."', '".$auto_id."', '".$pin."', '".$id_jabatan."', '".$id_divisi."'
        , '".$nama_karyawan."', '".$nik."', '".$no_ktp."', '".$npwp."', '".$jenis_kelamin_karyawan."'
        , '".$tanggal_masuk_karyawan."', '', '".$telp_karyawan."', '".$tempat_lahir_karyawan."', '".$tanggal_lahir_karyawan."'
        , '".$alamat_karyawan."', '".$tanggal_pengangkatan."', '".$keterangan."', '".$k_tk."', '".$pendidikan."'
        , '".$pkwt1."', '".$pkwt2."',".$gaji_pokok.",'".$tunjangan_jabatan."','".$bpjs_kesehatan."','".$plant."','".$ikut_penggajian."', '".$kawin_tdkkawin."', '".$status."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_karyawan(id_karyawan,pin, id_jabatan, id_divisi, nama_karyawan, nik, no_ktp, npwp, jenis_kelamin_karyawan, tanggal_masuk_karyawan, tanggal_keluar_karyawan, telp_karyawan, tempat_lahir_karyawan, tanggal_lahir_karyawan, alamat_karyawan, tanggal_pengangkatan, keterangan, k_tk, pendidikan, pkwt1, pkwt2, gaji_pokok, tunjangan_jabatan, bpjs_kesehatan, plant, ikut_penggajian, kawin_tdkkawin, status_karyawan, reason, change_by, change_at) 
        VALUES ('".$auto_id."','".$pin."', '".$id_jabatan."', '".$id_divisi."'
        , '".$nama_karyawan."', '".$nik."', '".$no_ktp."', '".$npwp."', '".$jenis_kelamin_karyawan."'
        , '".$tanggal_masuk_karyawan."', '', '".$telp_karyawan."', '".$tempat_lahir_karyawan."', '".$tanggal_lahir_karyawan."'
        , '".$alamat_karyawan."', '".$tanggal_pengangkatan."', '".$keterangan."', '".$k_tk."', '".$pendidikan."'
        , '".$pkwt1."', '".$pkwt2."',".$gaji_pokok.",'".$tunjangan_jabatan."','".$bpjs_kesehatan."', '".$plant."','".$ikut_penggajian."','".$kawin_tdkkawin."', '".$status."','".$reason."','".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function inputKaryawanOutsourcing($auto_id, $pin, $id_jabatan, $id_divisi, $nama_karyawan, $nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $telp_karyawan, $tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $tanggal_pengangkatan, $keterangan, $k_tk, $pendidikan, $pkwt1, $pkwt2, $gaji_pokok, $tunjangan_jabatan, $bpjs_kesehatan, $plant, $ikut_penggajian, $kawin_tdkkawin, $status, $change_by, $reason){
        $query = 
        "INSERT INTO master_karyawan(auto_id, id_karyawan, pin, id_jabatan, id_divisi, nama_karyawan, nik, no_ktp, npwp, jenis_kelamin_karyawan, tanggal_masuk_karyawan, tanggal_keluar_karyawan, telp_karyawan, tempat_lahir_karyawan, tanggal_lahir_karyawan, alamat_karyawan, tanggal_pengangkatan, keterangan, k_tk, pendidikan, pkwt1, pkwt2, gaji_pokok, tunjangan_jabatan, bpjs_kesehatan, plant, ikut_penggajian, kawin_tdkkawin, status_karyawan, change_by, change_at) 
        VALUES ('".$auto_id."', '".$auto_id."', '".$pin."', '".$id_jabatan."', '".$id_divisi."'
        , '".$nama_karyawan."', '".$nik."', '".$no_ktp."', '".$npwp."', '".$jenis_kelamin_karyawan."'
        , '".$tanggal_masuk_karyawan."', '', '".$telp_karyawan."', '".$tempat_lahir_karyawan."', '".$tanggal_lahir_karyawan."'
        , '".$alamat_karyawan."', '".$tanggal_pengangkatan."', '".$keterangan."', '".$k_tk."', '".$pendidikan."'
        , '".$pkwt1."', '".$pkwt2."',".$gaji_pokok.", '".$tunjangan_jabatan."','".$bpjs_kesehatan."','".$plant."', '".$ikut_penggajian."','".$kawin_tdkkawin."', '".$status."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_karyawan(id_karyawan,pin, id_jabatan, id_divisi, nama_karyawan, nik, no_ktp, npwp, jenis_kelamin_karyawan, tanggal_masuk_karyawan, tanggal_keluar_karyawan, telp_karyawan, tempat_lahir_karyawan, tanggal_lahir_karyawan, alamat_karyawan, tanggal_pengangkatan, keterangan, k_tk, pendidikan, pkwt1, pkwt2, gaji_pokok, tunjangan_jabatan, bpjs_kesehatan, plant, ikut_penggajian, kawin_tdkkawin, status_karyawan, reason, change_by, change_at) 
        VALUES ('".$auto_id."', '".$pin."', '".$id_jabatan."', '".$id_divisi."'
        , '".$nama_karyawan."', '".$nik."', '".$no_ktp."', '".$npwp."', '".$jenis_kelamin_karyawan."'
        , '".$tanggal_masuk_karyawan."', '', '".$telp_karyawan."', '".$tempat_lahir_karyawan."', '".$tanggal_lahir_karyawan."'
        , '".$alamat_karyawan."', '".$tanggal_pengangkatan."', '".$keterangan."', '".$k_tk."', '".$pendidikan."'
        , '".$pkwt1."', '".$pkwt2."',".$gaji_pokok.", '".$tunjangan_jabatan."','".$bpjs_kesehatan."','".$plant."','".$ikut_penggajian."','".$kawin_tdkkawin."','".$status."','".$reason."','".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function getLastIdKaryawan() {
        $query  = "SELECT MAX(auto_id) AS MAX_ID FROM master_karyawan";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editKaryawan($id){
        $query = "SELECT *, IF(keterangan = 'Karyawan', CONCAT('KAR', LPAD(id_karyawan, 12, '0')), CONCAT('OUT', LPAD(id_karyawan, 12, '0'))) as view_id
                    FROM master_karyawan 
                    WHERE id_karyawan='".$id['id_karyawan']."'";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editKaryawanSave($id_karyawan, $pin, $id_jabatan, $id_divisi, $nama_karyawan, $nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $tanggal_keluar_karyawan, $telp_karyawan, $tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $keterangan, $k_tk, $pendidikan, $pkwt1, $pkwt2, $gaji_pokok, $tunjangan_jabatan, $bpjs_kesehatan, $plant, $ikut_penggajian, $kawin_tdkkawin, $status_karyawan, $change_by, $reason, $tanggal_pengangkatan){
        $query = 
        "UPDATE master_karyawan
        SET pin='".$pin."', id_jabatan ='".$id_jabatan."', id_divisi ='".$id_divisi."',
            nama_karyawan ='".$nama_karyawan."',
            nik='".$nik."', no_ktp='".$no_ktp."', npwp='".$npwp."', jenis_kelamin_karyawan='".$jenis_kelamin_karyawan."', 
            tanggal_masuk_karyawan='".$tanggal_masuk_karyawan."', tanggal_keluar_karyawan='".$tanggal_keluar_karyawan."', 
            status_karyawan='".$status_karyawan."', telp_karyawan='".$telp_karyawan."', tempat_lahir_karyawan='".$tempat_lahir_karyawan."', 
            tanggal_lahir_karyawan='".$tanggal_lahir_karyawan."', alamat_karyawan='".$alamat_karyawan."', 
            tanggal_pengangkatan='".$tanggal_pengangkatan."', keterangan='".$keterangan."', k_tk='".$k_tk."', pendidikan='".$pendidikan."', 
            pkwt1='".$pkwt1."', pkwt2='".$pkwt2."',gaji_pokok=".$gaji_pokok.", tunjangan_jabatan='".$tunjangan_jabatan."', bpjs_kesehatan='".$bpjs_kesehatan."', plant='".$plant."', ikut_penggajian='".$ikut_penggajian."', kawin_tdkkawin='".$kawin_tdkkawin."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_karyawan='".$id_karyawan."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_karyawan(id_karyawan,pin, id_jabatan, id_divisi, nama_karyawan, nik, no_ktp, npwp, jenis_kelamin_karyawan, tanggal_masuk_karyawan, tanggal_keluar_karyawan, telp_karyawan, tempat_lahir_karyawan, tanggal_lahir_karyawan, alamat_karyawan, tanggal_pengangkatan, keterangan, k_tk, pendidikan, pkwt1, pkwt2, gaji_pokok, tunjangan_jabatan, bpjs_kesehatan, plant, ikut_penggajian, kawin_tdkkawin, status_karyawan, reason, change_by, change_at) 
        VALUES ('".$id_karyawan."','".$pin."', '".$id_jabatan."', '".$id_divisi."'
        , '".$nama_karyawan."', '".$nik."', '".$no_ktp."', '".$npwp."', '".$jenis_kelamin_karyawan."'
        , '".$tanggal_masuk_karyawan."', '', '".$telp_karyawan."', '".$tempat_lahir_karyawan."', '".$tanggal_lahir_karyawan."'
        , '".$alamat_karyawan."', '".$tanggal_pengangkatan."', '".$keterangan."', '".$k_tk."', '".$pendidikan."'
        , '".$pkwt1."', '".$pkwt2."', ".$gaji_pokok.", ".$tunjangan_jabatan.", '".$bpjs_kesehatan."', '".$plant."','".$ikut_penggajian."','".$kawin_tdkkawin."','".$status_karyawan."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusKaryawan($id_karyawan,$id_jabatan,$id_divisi, $change_by, $reason){
        $query = 
        "UPDATE master_karyawan
        SET status_karyawan='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_karyawan='".$id_karyawan."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_karyawan(id_karyawan,pin, id_jabatan, id_divisi, nama_karyawan, nik, no_ktp, npwp, jenis_kelamin_karyawan, tanggal_masuk_karyawan, tanggal_keluar_karyawan, telp_karyawan, tempat_lahir_karyawan, tanggal_lahir_karyawan, alamat_karyawan, tanggal_pengangkatan, keterangan, k_tk, pendidikan, pkwt1, pkwt2, gaji_pokok, tunjangan_jabatan, bpjs_kesehatan, plant, ikut_penggajian, kawin_tdkkawin, status_karyawan, reason, change_by, change_at) 
        VALUES ('".$id_karyawan."','-', '".$id_jabatan."', '".$id_divisi."'
        , '-', '-', '-', '-', '-'
        , '-', '', '-', '-', '-'
        , '-', '-', '-', '-', '-'
        , '-', '-', '-', '-', '-','-','-','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function checkKaryawan($nama_karyawan, $id_jabatan, $id_divisi, $nik, $no_ktp, $tanggal_masuk_karyawan , $tunjangan_jabatan, $bpjs_kesehatan, $kawin_tdkkawin ){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_karyawan
        JOIN master_jabatan ON master_karyawan.id_jabatan = master_jabatan.id_jabatan
        JOIN master_divisi ON master_karyawan.id_divisi = master_divisi.id_divisi
        WHERE master_karyawan.nama_karyawan = '".$nama_karyawan."' 
        AND master_jabatan.id_jabatan = '".$id_jabatan."' 
        AND master_divisi.id_divisi = '".$id_divisi."' AND
        master_karyawan.nik = '".$nik."' AND master_karyawan.no_ktp = '".$no_ktp."' AND 
        master_karyawan.tanggal_masuk_karyawan = '".$tanggal_masuk_karyawan."' AND 
        master_karyawan.tunjangan_jabatan = '".$tunjangan_jabatan."'AND 
        master_karyawan.bpjs_kesehatan = '".$bpjs_kesehatan."' AND 
        master_karyawan.kawin_tdkkawin = '".$kawin_tdkkawin."'
        AND master_karyawan.status_karyawan   = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditKaryawan($nama_karyawan, $id_jabatan, $id_divisi, $nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $tanggal_keluar_karyawan, $tanggal_pengangkatan, $telp_karyawan, $tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $pendidikan, $k_tk, $keterangan, $pkwt1, $pkwt2, $gaji_pokok, $tunjangan_jabatan, $bpjs_kesehatan, $plant, $ikut_penggajian, $kawin_tdkkawin, $status_karyawan){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_karyawan
        JOIN master_jabatan ON master_karyawan.id_jabatan = master_jabatan.id_jabatan
        JOIN master_divisi ON master_karyawan.id_divisi = master_divisi.id_divisi
        WHERE master_karyawan.nama_karyawan = '".$nama_karyawan."' 
        AND master_jabatan.id_jabatan = '".$id_jabatan."' 
        AND master_divisi.id_divisi = '".$id_divisi."' 
        AND master_karyawan.nik = '".$nik."' 
        AND master_karyawan.no_ktp = '".$no_ktp."' 
        AND master_karyawan.npwp= '".$npwp."'
        AND master_karyawan.tanggal_masuk_karyawan = '".$tanggal_masuk_karyawan."'
        AND master_karyawan.jenis_kelamin_karyawan = '".$jenis_kelamin_karyawan."'
        AND master_karyawan.tanggal_masuk_karyawan = '".$tanggal_masuk_karyawan."'
        AND master_karyawan.tanggal_keluar_karyawan = '".$tanggal_keluar_karyawan."'
        AND master_karyawan.tanggal_pengangkatan = '".$tanggal_pengangkatan."'
        AND master_karyawan.telp_karyawan = '".$telp_karyawan."'
        AND master_karyawan.tempat_lahir_karyawan = '".$tempat_lahir_karyawan."'
        AND master_karyawan.tanggal_lahir_karyawan = '".$tanggal_lahir_karyawan."'
        AND master_karyawan.alamat_karyawan = '".$alamat_karyawan."'
        AND master_karyawan.pendidikan = '".$pendidikan."'
        AND master_karyawan.k_tk = '".$k_tk."'
        AND master_karyawan.keterangan = '".$keterangan."'
        AND master_karyawan.pkwt1 = '".$pkwt1."'
        AND master_karyawan.pkwt2 = '".$pkwt2."'
        AND master_karyawan.gaji_pokok = '".$gaji_pokok."'
        AND master_karyawan.tunjangan_jabatan = '".$tunjangan_jabatan."'
        AND master_karyawan.bpjs_kesehatan = '".$bpjs_kesehatan."'
        AND master_karyawan.plant = '".$plant."'
        AND master_karyawan.ikut_penggajian = '".$ikut_penggajian."'
        AND master_karyawan.kawin_tdkkawin = '".$kawin_tdkkawin."'
        AND master_karyawan.status_karyawan = '".$status_karyawan."'
        AND master_karyawan.status_karyawan   = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }
    


    //=============================== UMK =====================================
    public function getMasterUmk(){
        $query  = "SELECT id_umk, tahun_umk, total_umk, status_umk, user_login.username as change_by, master_umk.change_at, CONCAT('UMK', LPAD(id_umk, 5, '0')) as view_id, master_umk.gaji_per_jam, master_umk.plant
        FROM master_umk, user_login 
        WHERE master_umk.change_by = user_login.id_user AND master_umk.status_umk = 'Y'
        ORDER BY master_umk.tahun_umk ASC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getTahunUmk(){
        $query  = "SELECT DISTINCT tahun_umk
        FROM master_umk, user_login 
        WHERE master_umk.change_by = user_login.id_user AND master_umk.status_umk = 'Y'
        ORDER BY master_umk.tahun_umk ASC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function inputUmk($id_umk, $tahun_umk, $total_umk, $gaji_per_jam, $plant, $status, $change_by, $reason){
        $query = 
        "INSERT INTO master_umk(id_umk, tahun_umk, total_umk, gaji_per_jam , plant, status_umk, change_by, change_at) 
        VALUES ('".$id_umk."', '".$tahun_umk."','".$total_umk."', '".$gaji_per_jam."', '".$plant."', '".$status."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_umk(id_umk, tahun_umk, total_umk, gaji_per_jam, plant, status_umk, reason, change_by, change_at) 
        VALUES ('".$id_umk."','".$tahun_umk."','".$total_umk."', '".$gaji_per_jam."', '".$plant."', '".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function getLastIdUmk() {
        $query  = "SELECT MAX(id_umk) AS MAX_ID FROM master_umk";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editUmk($id){
        $query = "SELECT *, CONCAT('UMK', LPAD(id_umk, 5, '0')) as view_id
                    FROM master_umk 
                    WHERE id_umk=".$id['id_umk'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editUmkSave($id_umk, $tahun_umk, $total_umk, $gaji_per_jam, $plant, $status_umk, $change_by, $reason){
        $query = 
        "UPDATE master_umk
        SET id_umk='".$id_umk."', tahun_umk ='".$tahun_umk."', total_umk ='".$total_umk."', gaji_per_jam ='".$gaji_per_jam."', plant ='".$plant."', status_umk='".$status_umk."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_umk='".$id_umk."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_umk(id_umk, tahun_umk, total_umk, gaji_per_jam, plant, status_umk, reason, change_by, change_at) 
        VALUES ('".$id_umk."','".$tahun_umk."','".$total_umk."','".$gaji_per_jam."','".$plant."','".$status_umk."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusUmk($id_umk, $change_by, $reason){
        $query = 
        "UPDATE master_umk
        SET status_umk='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_umk='".$id_umk."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_umk(id_umk, tahun_umk, total_umk, gaji_per_jam, plant, status_umk, reason, change_by, change_at) 
        VALUES ('".$id_umk."','-','-','-','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function checkUmk($tahun_umk, $plant){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_umk
        WHERE master_umk.tahun_umk = '".$tahun_umk."' 
        AND master_umk.plant = '".$plant."' 
        AND master_umk.status_umk   = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditUmk($tahun_umk, $total_umk, $gaji_per_jam, $plant, $status_umk){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_umk
        WHERE master_umk.tahun_umk = '".$tahun_umk."' AND master_umk.total_umk = '".$total_umk."' 
        AND master_umk.gaji_per_jam = '".$gaji_per_jam."'  AND master_umk.plant = '".$plant."' 
        AND master_umk.status_umk = '".$status_umk."'
        AND master_umk.status_umk   = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    //=============================== User =====================================
    public function getMasterUser(){
        $query  = "SELECT u.id_user, k.nama_karyawan, u.username, u.password_user, u.status, u2.username AS change_by, u.change_at, CONCAT('USR', LPAD(u.id_user, 5, '0')) as view_id, k.id_karyawan, u.role
                    FROM user_login u
                    JOIN master_karyawan k ON u.id_karyawan=k.id_karyawan
                    JOIN user_login u2 ON u.change_by = u2.id_user
                    WHERE u.status = 'Y'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getAllNamaKaryawan(){
        $query  = "SELECT k.auto_id, IF(k.keterangan = 'Karyawan', CONCAT('KAR', LPAD(k.id_karyawan, 12, '0')), CONCAT('OUT', LPAD(k.id_karyawan, 12, '0'))) as idk, 
                          k.id_karyawan, k.nama_karyawan, k.id_jabatan
                    FROM master_karyawan k
                    WHERE k.status_karyawan = 'Y'
                    ORDER BY k.auto_id ASC";
        $result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getKaryawanIdSelected($id_karyawan){
        $query  = "SELECT k.auto_id
                FROM master_karyawan k
                WHERE k.id_karyawan='".$id_karyawan."'";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function inputUser($id_user, $id, $username, $password, $role, $status, $change_by, $reason){
        $query = 
        "INSERT INTO user_login 
        VALUES ('".$id_user."', '".$id."','".$username."','".$password."','".$role."' ,'".$status."', CURDATE(), '".$change_by."');";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_user_login(id_user,id_karyawan, username, password_user, role , status , reason, change_by, change_at) 
        VALUES ('".$id_user."','".$id."','".$username."','".$password."','".$role."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function getLastIdUser() {
        $query  = "SELECT MAX(id_user) AS MAX_ID FROM user_login";
        $result = $this->db->query($query)->result_array();
        return $result;
    }


    public function editUser($id){
        $query = "SELECT *, CONCAT('USR', LPAD(id_user, 5, '0')) as view_id
                    FROM user_login 
                    WHERE id_user=".$id['id_user'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editUserSave($id_user, $id_karyawan, $username, $password_user, $role, $status_user, $change_by, $reason){
        $password_user = md5($password_user);
        $query = 
        "UPDATE user_login
        SET id_karyawan ='".$id_karyawan."', username ='".$username."', password_user ='".$password_user."', role ='".$role."', status ='".$status_user."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_user='".$id_user."'";
        $result = $this->db->query($query);  

        
        $query2 = 
        "INSERT INTO history_user_login(id_user,id_karyawan, username, password_user, role, status, reason, change_by, change_at) 
        VALUES ('".$id_user."','".$id_karyawan."','".$username."','".$password_user."','".$role."','".$status_user."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusUser($id_user, $id_karyawan, $change_by, $reason){
        
        $query = 
        "UPDATE user_login
        SET status='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_user='".$id_user."'";
        $result = $this->db->query($query);  
        
        // $karyawan = $this->getMasterUser();
        // $id_k = '';
        // //var_dump($karyawan);
        // foreach($karyawan as $k){
        //     if($id_user==$k['id_user'])
        //        $id_k = $k['id_karyawan'];
        // }
        // //echo $id_k;
        
        $query2 = 
        "INSERT INTO history_user_login
        VALUES ('".$id_user."','".$id_karyawan."','-','-','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function checkUser($id, $username, $role){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM user_login
        JOIN master_karyawan ON master_karyawan.id_karyawan = user_login.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id."' AND user_login.username = '".$username."' 
        AND user_login.role = '".$role."' 
        AND user_login.status  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditUser($id_karyawan, $username, $password_user, $role, $status_user){
        $password_user = md5($password_user);
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM user_login
        JOIN master_karyawan ON master_karyawan.id_karyawan = user_login.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' AND user_login.username = '".$username."' 
        AND user_login.password_user = '".$password_user."'  AND user_login.role = '".$role."' AND user_login.status = '".$status_user."'
        AND user_login.status  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    //=============================== Surat Sakit Dinas =====================================
    public function getMasterSuratSD(){
        $query  = "SELECT u.id_surat, k.nama_karyawan, u.jenis_surat, u.tanggal_surat, u.keterangan_surat, u.status_surat, 
                    u2.username AS change_by, u.change_at, CONCAT('SSD', LPAD(u.id_surat, 5, '0')) as view_id, 
                    k.id_karyawan
                    FROM surat_sd u
                    JOIN master_karyawan k ON u.id_karyawan=k.id_karyawan
                    JOIN user_login u2 ON u.change_by = u2.id_user
                    WHERE u.status_surat = 'Y'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function inputSuratSD($id_surat, $id_karyawan, $jenis_surat, $tanggal_surat, $keterangan_surat, $status, $change_by, $reason){
        $query = 
        "INSERT INTO surat_sd 
        VALUES ('".$id_surat."', '".$id_karyawan."','".$jenis_surat."','".$tanggal_surat."','".$keterangan_surat."' ,'".$status."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_surat_sd(id_surat ,id_karyawan, jenis_surat, tanggal_surat, keterangan_surat , status_surat , reason, change_by, change_at) 
        VALUES ('".$id_surat."','".$id_karyawan."','".$jenis_surat."','".$tanggal_surat."','".$keterangan_surat."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function getLastIdSuratSD() {
        $query  = "SELECT MAX(id_surat) AS MAX_ID FROM surat_sd";
        $result = $this->db->query($query)->result_array();
        return $result;
    }


    public function editSuratSD($id){
        $query = "SELECT *, CONCAT('SSD', LPAD(id_surat, 5, '0')) as view_id
                    FROM surat_sd 
                    WHERE id_surat=".$id['id_surat'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editSuratSDSave($id_surat, $id_karyawan, $jenis_surat, $tanggal_surat, $keterangan_surat, $status_surat, $change_by, $reason){
        $query = 
        "UPDATE surat_sd
        SET id_karyawan ='".$id_karyawan."', jenis_surat ='".$jenis_surat."', tanggal_surat ='".$tanggal_surat."', keterangan_surat ='".$keterangan_surat."', status_surat ='".$status_surat."', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_surat='".$id_surat."'";
        $result = $this->db->query($query);  

        
        $query2 = 
        "INSERT INTO history_surat_sd(id_surat ,id_karyawan, jenis_surat, tanggal_surat, keterangan_surat , status_surat , reason, change_by, change_at) 
        VALUES ('".$id_surat."','".$id_karyawan."','".$jenis_surat."','".$tanggal_surat."','".$keterangan_surat."','".$status_surat."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusSuratSD($id_surat, $id_karyawan, $change_by, $reason){
        
        $query = 
        "UPDATE surat_sd
        SET status_surat='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_surat='".$id_surat."'";
        $result = $this->db->query($query);  
        
        $query2 = 
        "INSERT INTO history_surat_sd
        VALUES ('".$id_surat."','".$id_karyawan."','-','-','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function checkSuratSd($id_karyawan, $jenis_surat, $tanggal_surat, $keterangan_surat){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM surat_sd
        JOIN master_karyawan ON master_karyawan.id_karyawan = surat_sd.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND surat_sd.jenis_surat = '".$jenis_surat."' 
        AND surat_sd.tanggal_surat = '".$tanggal_surat."' 
        AND surat_sd.keterangan_surat = '".$keterangan_surat."' 
        AND surat_sd.status_surat  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditSuratSd($id_karyawan, $jenis_surat, $tanggal_surat, $keterangan_surat, $status_surat){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM surat_sd
        JOIN master_karyawan ON master_karyawan.id_karyawan = surat_sd.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND surat_sd.jenis_surat = '".$jenis_surat."' 
        AND surat_sd.tanggal_surat = '".$tanggal_surat."'  
        AND surat_sd.keterangan_surat = '".$keterangan_surat."' 
        AND surat_sd.status_surat = '".$status_surat."'
        AND surat_sd.status_surat  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    //=============================== Cuti =====================================
    public function getMasterCuti(){
        $query  = " SELECT c.id_cuti, k.nama_karyawan, d.nama_divisi, c.tahun_cuti, c.tanggal_mulai_cuti, c.tanggal_akhir_cuti, c.ambil_cuti, c.alasan_cuti, c.status_cuti, 
                    u.username as change_by, c.change_at, CONCAT('CUT', LPAD(c.id_cuti, 8, '0')) as view_id, 
                    k.id_karyawan, c.no_iso, j.nama_jabatan, c.sisa_cuti_lama, c.sisa_cuti_baru, k.plant, j.nama_jabatan
                    FROM transaksi_cuti c
                        JOIN master_karyawan k ON c.id_karyawan = k.id_karyawan
                        JOIN master_divisi d ON k.id_divisi = d.id_divisi
                        JOIN master_jabatan j ON j.id_jabatan = k.id_jabatan 
                        JOIN user_login u ON c.change_by = u.id_user
                    WHERE c.status_cuti = 'Y'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getLastIdCuti() {
        $query  = "SELECT MAX(id_cuti) AS MAX_ID FROM transaksi_cuti";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function inputCuti($id_cuti, $id_karyawan, $tahun_cuti, $sisa_cuti_lama, $sisa_cuti_baru, $tanggal_mulai, $tanggal_akhir, $alasan_cuti, $ambil_cuti, $ambil_cuti_tahun_sekarang, $no_iso,  $status, $change_by, $reason){
        $query = 
        "INSERT INTO transaksi_cuti 
        VALUES ('".$id_cuti."', '".$id_karyawan."','".$tahun_cuti."','".$sisa_cuti_lama."','".$sisa_cuti_baru."','".$ambil_cuti."','".$tanggal_mulai."','".$tanggal_akhir."','".$alasan_cuti."', 'Y','".$ambil_cuti_tahun_sekarang."', '".$no_iso."','".$status."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_cuti(id_cuti, id_karyawan , tahun_cuti, sisa_cuti_lama, sisa_cuti_baru ,ambil_cuti, tanggal_mulai_cuti, tanggal_akhir_cuti, alasan_cuti, persetujuan_cuti, ambil_tahun_sekarang, no_iso, status_cuti, reason, change_by, change_at) 
        VALUES ('".$id_cuti."','".$id_karyawan."','".$tahun_cuti."','".$sisa_cuti_lama."','".$sisa_cuti_baru."','".$ambil_cuti."','".$tanggal_mulai."','".$tanggal_akhir."','".$alasan_cuti."', 'Y','".$ambil_cuti_tahun_sekarang."', '".$no_iso."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    
    public function getSisaCuti($tahun, $id_karyawan){
        $tahun_sekarang = (int)$tahun;
        $tahun_kemarin = ((int)$tahun)-1;
        $tahun_depan = ((int)$tahun)+1;
        $query = 
        "SELECT k.id_karyawan, k.nama_karyawan, 
            @cb_tahun_kemarin := IFNULL((
            SELECT SUM(master_kalender.jumlah_hari)
            FROM master_kalender
            WHERE master_kalender.jenis_hari = 'Cuti Bersama' AND
                master_kalender.status_kalender = 'Y' AND
                master_kalender.tanggal_mulai BETWEEN '".$tahun_kemarin."-01-01' AND '".$tahun_kemarin."-12-31' AND
                master_kalender.tanggal_akhir BETWEEN '".$tahun_kemarin."-01-01' AND '".$tahun_kemarin."-12-31'), 0) AS cb_tahun_kemarin,
            @cb_tahun_sekarang := IFNULL((
            SELECT SUM(master_kalender.jumlah_hari)
            FROM master_kalender
            WHERE master_kalender.jenis_hari = 'Cuti Bersama' AND
                master_kalender.status_kalender = 'Y' AND
                master_kalender.tanggal_mulai BETWEEN '".$tahun_sekarang."-01-01' AND '".$tahun_sekarang."-12-31' AND
                master_kalender.tanggal_akhir BETWEEN '".$tahun_sekarang."-01-01' AND '".$tahun_sekarang."-12-31'), 0) AS cb_tahun_sekarang,
            @cuti_tahun_kemarin := IFNULL((SELECT SUM(transaksi_cuti.ambil_cuti)
            FROM transaksi_cuti
            WHERE (transaksi_cuti.tahun_cuti = '".$tahun_kemarin."' OR transaksi_cuti.tahun_cuti = '".$tahun_sekarang."') AND
                transaksi_cuti.id_karyawan = k.id_karyawan AND
                transaksi_cuti.status_cuti = 'Y' AND
                iF(transaksi_cuti.tahun_cuti = '".$tahun_kemarin."', transaksi_cuti.ambil_tahun_sekarang = 'Y', transaksi_cuti.ambil_tahun_sekarang = 'N')), 0) as ambil_cuti_tahun_kemarin,
            @cuti_tahun_ini := IFNULL((SELECT SUM(transaksi_cuti.ambil_cuti)
            FROM transaksi_cuti
            WHERE (transaksi_cuti.tahun_cuti = '".$tahun_sekarang."' OR transaksi_cuti.tahun_cuti = '".$tahun_depan."') AND
                transaksi_cuti.id_karyawan = k.id_karyawan AND
                transaksi_cuti.status_cuti = 'Y' AND
                iF(transaksi_cuti.tahun_cuti = '".$tahun_sekarang."', transaksi_cuti.ambil_tahun_sekarang = 'Y', transaksi_cuti.ambil_tahun_sekarang = 'N')), 0) as ambil_cuti_tahun_ini,
            (12 - @cb_tahun_kemarin - @cuti_tahun_kemarin) AS sisa_cuti_tahun_kemarin,
            (12 - @cb_tahun_sekarang - @cuti_tahun_ini) AS sisa_cuti_tahun_ini
        FROM master_karyawan k
        WHERE k.status_karyawan = 'Y' AND
              k.id_karyawan = '".$id_karyawan."'";
        $result = $this->db->query($query); 
        return $result->result();  
    }

    public function editCuti($id){
        $query = "SELECT *, CONCAT('CUT', LPAD(id_cuti, 5, '0')) as view_id 
                    FROM transaksi_cuti 
                    WHERE id_cuti=".$id['id_cuti']."";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editCutiSave($id_cuti, $id_karyawan, $tahun_cuti, $sisa_cuti_lama, $sisa_cuti_baru, $ambil_cuti, $tanggal_mulai_cuti, $tanggal_akhir_cuti, $alasan_cuti, $persetujuan_cuti, $ambil_tahun_sekarang, $no_iso, $status_cuti, $change_by, $reason){
        $query = 
        "UPDATE transaksi_cuti
        SET id_karyawan='".$id_karyawan."', tahun_cuti='".$tahun_cuti."', sisa_cuti_lama='".$sisa_cuti_lama."', sisa_cuti_baru='".$sisa_cuti_baru."', ambil_cuti='".$ambil_cuti."', 
        tanggal_mulai_cuti='".$tanggal_mulai_cuti."', tanggal_akhir_cuti='".$tanggal_akhir_cuti."', alasan_cuti='".$alasan_cuti."', 
        persetujuan_cuti='".$persetujuan_cuti."', ambil_tahun_sekarang='".$ambil_tahun_sekarang."', no_iso = '".$no_iso."' ,status_cuti='".$status_cuti."', 
        change_by='".$change_by."', change_at=CURDATE()
        WHERE id_cuti='".$id_cuti."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_cuti
        VALUES ('".$id_cuti."','".$id_karyawan."','".$tahun_cuti."','".$sisa_cuti_lama."','".$sisa_cuti_baru."','".$ambil_cuti."','".$tanggal_mulai_cuti."','".$tanggal_akhir_cuti."','".$alasan_cuti."','".$persetujuan_cuti."','".$ambil_tahun_sekarang."', '".$no_iso."','".$status_cuti."','".$reason."','".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function hapusCuti($id_cuti, $id_karyawan, $no_iso, $change_by, $reason){
        $query = 
        "UPDATE transaksi_cuti
        SET status_cuti='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_cuti='".$id_cuti."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_cuti
        VALUES ('".$id_cuti."','".$id_karyawan."','-','-','-','-','-','-','-','-','-', '".$no_iso."','N','".$reason."','".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function checkCuti($id_karyawan, $tahun_cuti, $tanggal_mulai_cuti, $tanggal_akhir_cuti, $ambil_cuti, $alasan_cuti){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM transaksi_cuti
        JOIN master_karyawan ON master_karyawan.id_karyawan = transaksi_cuti.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND transaksi_cuti.tahun_cuti = '".$tahun_cuti."' 
        AND transaksi_cuti.tanggal_mulai_cuti = '".$tanggal_mulai_cuti."'
        AND transaksi_cuti.tanggal_akhir_cuti = '".$tanggal_akhir_cuti."'
        AND transaksi_cuti.ambil_cuti = '".$ambil_cuti."'
        AND transaksi_cuti.alasan_cuti = '".$alasan_cuti."'
        AND transaksi_cuti.status_cuti  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditCuti($id_karyawan, $tahun_cuti, $tanggal_mulai_cuti, $tanggal_akhir_cuti, $ambil_cuti, $alasan_cuti, $status_cuti){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM transaksi_cuti
        JOIN master_karyawan ON master_karyawan.id_karyawan = transaksi_cuti.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND transaksi_cuti.tahun_cuti = '".$tahun_cuti."' 
        AND transaksi_cuti.tanggal_mulai_cuti = '".$tanggal_mulai_cuti."'
        AND transaksi_cuti.tanggal_akhir_cuti = '".$tanggal_akhir_cuti."'
        AND transaksi_cuti.ambil_cuti = '".$ambil_cuti."'
        AND transaksi_cuti.alasan_cuti = '".$alasan_cuti."'
        AND transaksi_cuti.status_cuti = '".$status_cuti."'
        AND transaksi_cuti.status_cuti  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    //=============================== Surat Izin =====================================
    public function getMasterIzin(){
        $query  =   "SELECT s.id_surat_ijin, k.nama_karyawan, d.nama_divisi, s.tanggal_ijin, s.alasan_ijin, s.jam_datang_keluar_ijin, s.status_ijin, u.username as change_by, s.change_at, CONCAT('IZN', LPAD(id_surat_ijin, 8, '0')) as view_id, k.id_karyawan, s.no_iso, j.nama_jabatan, s.pilih_jam, k.plant, j.nama_jabatan
                    FROM transaksi_surat_ijin s 
                    JOIN master_karyawan k on s.id_karyawan = k.id_karyawan
                    JOIN master_divisi d on k.id_divisi = d.id_divisi
                    JOIN master_jabatan j ON j.id_jabatan = k.id_jabatan
                    JOIN user_login u ON s.change_by = u.id_user
                    WHERE s.status_ijin = 'Y'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getPersetujuanIzinKabag(){
        $query  =   "SELECT s.id_surat_ijin, k.nama_karyawan, d.nama_divisi, s.tanggal_ijin, s.alasan_ijin, s.jam_datang_keluar_ijin, s.status_ijin, u.username as change_by, s.change_at, CONCAT('IZN', LPAD(id_surat_ijin, 8, '0')) as view_id, k.id_karyawan, s.no_iso, j.nama_jabatan, s.pilih_jam, s.persetujuan_kabag
                    FROM transaksi_surat_ijin s 
                    JOIN master_karyawan k on s.id_karyawan = k.id_karyawan
                    JOIN master_divisi d on k.id_divisi = d.id_divisi
                    JOIN master_jabatan j ON j.id_jabatan = k.id_jabatan
                    JOIN user_login u ON s.change_by = u.id_user
                    WHERE s.status_ijin = 'Y' AND s.persetujuan_kabag = 'N'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getPersetujuanIzin(){
        $query  =   "SELECT s.id_surat_ijin, k.nama_karyawan, d.nama_divisi, s.tanggal_ijin, s.alasan_ijin, s.jam_datang_keluar_ijin, s.status_ijin, u.username as change_by, s.change_at, CONCAT('IZN', LPAD(id_surat_ijin, 8, '0')) as view_id, k.id_karyawan, s.no_iso, j.nama_jabatan, s.pilih_jam, s.persetujuan_kabag
                    FROM transaksi_surat_ijin s 
                    JOIN master_karyawan k on s.id_karyawan = k.id_karyawan
                    JOIN master_divisi d on k.id_divisi = d.id_divisi
                    JOIN master_jabatan j ON j.id_jabatan = k.id_jabatan
                    JOIN user_login u ON s.change_by = u.id_user
                    WHERE s.status_ijin = 'Y' AND s.persetujuan_kabag = 'N'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getPersetujuanIzinHRD(){
        $query  =   "SELECT s.id_surat_ijin, k.nama_karyawan, d.nama_divisi, s.tanggal_ijin, s.alasan_ijin, s.jam_datang_keluar_ijin, s.status_ijin, u.username as change_by, s.change_at, CONCAT('IZN', LPAD(id_surat_ijin, 8, '0')) as view_id, k.id_karyawan, s.no_iso, j.nama_jabatan, s.pilih_jam, s.persetujuan_hrd, s.persetujuan_kabag
                    FROM transaksi_surat_ijin s 
                    JOIN master_karyawan k on s.id_karyawan = k.id_karyawan
                    JOIN master_divisi d on k.id_divisi = d.id_divisi
                    JOIN master_jabatan j ON j.id_jabatan = k.id_jabatan
                    JOIN user_login u ON s.change_by = u.id_user
                    WHERE s.status_ijin = 'Y' AND s.persetujuan_hrd = 'N' AND s.persetujuan_kabag = 'Y'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getLastIdIzin() {
        $query  = "SELECT MAX(id_surat_ijin) AS MAX_ID FROM transaksi_surat_ijin";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function inputIzin($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $persetujuan_hrd, $no_iso ,$status, $change_by, $reason ){
        $query = 
        "INSERT INTO transaksi_surat_ijin 
        VALUES ('".$id_surat_ijin."', '".$id_karyawan."','".$tanggal_ijin."','".$alasan_ijin."', '".$pilih_jam."','".$jam_datang_keluar_ijin."','".$persetujuan_kabag."','".$persetujuan_hrd."','".$no_iso."', '".$status."','".$change_by."', CURDATE());";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_surat_ijin(id_surat_ijin, id_karyawan, tanggal_ijin, alasan_ijin , pilih_jam, jam_datang_keluar_ijin, persetujuan_kabag, persetujuan_hrd, no_iso , status_ijin, reason, change_by, change_at) 
        VALUES ('".$id_surat_ijin."','".$id_karyawan."', '".$tanggal_ijin."', '".$alasan_ijin."', '".$pilih_jam."','".$jam_datang_keluar_ijin."','".$persetujuan_kabag."','".$persetujuan_hrd."', '".$no_iso."' ,'".$status."' ,'".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function editIzin($id){
        $query = "SELECT * , CONCAT('IZN', LPAD(id_surat_ijin, 8, '0')) as view_id
                    FROM transaksi_surat_ijin 
                    WHERE id_surat_ijin=".$id['id_surat_ijin'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editIzinSave($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $no_iso, $status_ijin, $change_by, $reason){
        $query = 
        "UPDATE transaksi_surat_ijin
        SET id_surat_ijin='".$id_surat_ijin."', id_karyawan ='".$id_karyawan."', tanggal_ijin ='".$tanggal_ijin."', alasan_ijin='".$alasan_ijin."', pilih_jam='".$pilih_jam."', jam_datang_keluar_ijin='".$jam_datang_keluar_ijin."' ,no_iso = '".$no_iso."', status_ijin='".$status_ijin."' ,change_by='".$change_by."', change_at=CURDATE()
        WHERE id_surat_ijin='".$id_surat_ijin."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_surat_ijin(id_surat_ijin, id_karyawan, tanggal_ijin, alasan_ijin , pilih_jam, jam_datang_keluar_ijin, no_iso, status_ijin, reason, change_by, change_at) 
        VALUES ('".$id_surat_ijin."','".$id_karyawan."', '".$tanggal_ijin."', '".$alasan_ijin."', '".$pilih_jam."' , '".$jam_datang_keluar_ijin."','".$no_iso."' ,'".$status_ijin."' ,'".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusIzin($id_surat_ijin, $id_karyawan , $no_iso, $change_by, $reason){
        $query = 
        "UPDATE transaksi_surat_ijin
        SET status_ijin='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_surat_ijin='".$id_surat_ijin."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_surat_ijin(id_surat_ijin, id_karyawan, tanggal_ijin, alasan_ijin , pilih_jam, jam_datang_keluar_ijin, no_iso, status_ijin, reason, change_by, change_at) 
        VALUES ('".$id_surat_ijin."','".$id_karyawan."', '-', '-', '-', '-', '".$no_iso."', 'N' ,'".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function persetujuanKabag($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $no_iso ,$status_ijin, $change_by, $reason ){
        $query = 
        "UPDATE transaksi_surat_ijin
        SET persetujuan_kabag='Y', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_surat_ijin='".$id_surat_ijin."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_surat_ijin(id_surat_ijin, id_karyawan, tanggal_ijin, alasan_ijin , pilih_jam, jam_datang_keluar_ijin, persetujuan_kabag, no_iso, status_ijin, reason, change_by, change_at) 
        VALUES ('".$id_surat_ijin."','".$id_karyawan."', '".$tanggal_ijin."', '".$alasan_ijin."', '".$pilih_jam."' , '".$jam_datang_keluar_ijin."','Y','".$no_iso."' ,'".$status_ijin."' ,'".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function penolakanKabag($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $no_iso ,$status_ijin, $change_by, $reason ){
        $query = 
        "UPDATE transaksi_surat_ijin
        SET persetujuan_kabag='D', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_surat_ijin='".$id_surat_ijin."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_surat_ijin(id_surat_ijin, id_karyawan, tanggal_ijin, alasan_ijin , pilih_jam, jam_datang_keluar_ijin, persetujuan_kabag, no_iso, status_ijin, reason, change_by, change_at) 
        VALUES ('".$id_surat_ijin."','".$id_karyawan."', '".$tanggal_ijin."', '".$alasan_ijin."', '".$pilih_jam."' , '".$jam_datang_keluar_ijin."','D','".$no_iso."' ,'".$status_ijin."' ,'".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2);  
    }

    public function persetujuanHrd($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $persetujuan_hrd, $no_iso ,$status_ijin, $change_by, $reason ){
        $query = 
        "UPDATE transaksi_surat_ijin
        SET persetujuan_hrd='Y', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_surat_ijin='".$id_surat_ijin."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_surat_ijin(id_surat_ijin, id_karyawan, tanggal_ijin, alasan_ijin , pilih_jam, jam_datang_keluar_ijin, persetujuan_kabag, persetujuan_hrd, no_iso, status_ijin, reason, change_by, change_at) 
        VALUES ('".$id_surat_ijin."','".$id_karyawan."', '".$tanggal_ijin."', '".$alasan_ijin."', '".$pilih_jam."' , '".$jam_datang_keluar_ijin."','".$persetujuan_kabag."','Y','".$no_iso."' ,'".$status_ijin."' ,'".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function penolakanHrd($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $persetujuan_hrd, $no_iso ,$status_ijin, $change_by, $reason ){
        $query = 
        "UPDATE transaksi_surat_ijin
        SET persetujuan_hrd='D', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_surat_ijin='".$id_surat_ijin."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_surat_ijin(id_surat_ijin, id_karyawan, tanggal_ijin, alasan_ijin , pilih_jam, jam_datang_keluar_ijin, persetujuan_kabag, persetujuan_hrd, no_iso, status_ijin, reason, change_by, change_at) 
        VALUES ('".$id_surat_ijin."','".$id_karyawan."', '".$tanggal_ijin."', '".$alasan_ijin."', '".$pilih_jam."' , '".$jam_datang_keluar_ijin."', '".$persetujuan_kabag."', 'D','".$no_iso."' ,'".$status_ijin."' ,'".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2);  
    }

    public function checkIzin($id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM transaksi_surat_ijin
        JOIN master_karyawan ON master_karyawan.id_karyawan = transaksi_surat_ijin.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND transaksi_surat_ijin.tanggal_ijin = '".$tanggal_ijin."' 
        AND transaksi_surat_ijin.alasan_ijin = '".$alasan_ijin."'
        AND transaksi_surat_ijin.pilih_jam = '".$pilih_jam."'
        AND transaksi_surat_ijin.jam_datang_keluar_ijin = '".$jam_datang_keluar_ijin."'
        AND transaksi_surat_ijin.status_ijin  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditIzin($id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $status_ijin){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM transaksi_surat_ijin
        JOIN master_karyawan ON master_karyawan.id_karyawan = transaksi_surat_ijin.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND transaksi_surat_ijin.tanggal_ijin = '".$tanggal_ijin."' 
        AND transaksi_surat_ijin.alasan_ijin = '".$alasan_ijin."'
        AND transaksi_surat_ijin.jam_datang_keluar_ijin = '".$jam_datang_keluar_ijin."'
        AND transaksi_surat_ijin.pilih_jam = '".$pilih_jam."'
        AND transaksi_surat_ijin.status_ijin = '".$status_ijin."'
        AND transaksi_surat_ijin.status_ijin  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    //=============================== Lembur =====================================
    public function getMasterLembur(){
        $query  =   "SELECT l.id_lembur, k.nama_karyawan, d.nama_divisi, l.tanggal_lembur, 
                    l.jam_mulai, l.jam_akhir, l.uraian_kerja, l.persetujuan, l.status_lembur, u.username as change_by, 
                    DATE_FORMAT(l.change_at,'%Y-%m-%d') as change_at, CONCAT('LMB', LPAD(l.id_lembur, 8, '0')) as view_id, 
                    k.id_karyawan, l.ambil_jam, l.no_iso, j.nama_jabatan, k.plant
                    FROM master_lembur l 
                    JOIN master_karyawan k ON l.id_karyawan = k.id_karyawan 
                    JOIN master_divisi d ON k.id_divisi = d.id_divisi
                    JOIN master_jabatan j ON j.id_jabatan = k.id_jabatan
                    JOIN user_login u ON l.change_by = u.id_user 
                    WHERE l.status_lembur = 'Y'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getLastIdLembur() {
        $query  = "SELECT MAX(id_lembur) AS MAX_ID FROM master_lembur";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function inputLembur($id_lembur, $id_karyawan, $pilih_lembur, $tanggal_lembur, $jam_mulai, $jam_akhir,$uraian_kerja, $persetujuan, $no_iso ,$status, $change_by, $reason, $ambil_jam){
        $query = 
        "INSERT INTO master_lembur 
        VALUES ('".$id_lembur."' , '".$id_karyawan."' , '".$pilih_lembur."' , '".$tanggal_lembur."' , '".$jam_mulai."' , '".$jam_akhir."' , '".$ambil_jam."' , '".$uraian_kerja."' , '".$persetujuan."' , CURDATE() , '".$no_iso."', '".$status."' , '".$change_by."' );";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_lembur(id_lembur, id_karyawan, pilih_lembur, tanggal_lembur, jam_mulai, jam_akhir, ambil_jam, uraian_kerja, persetujuan, no_iso, status_lembur, reason, change_by, change_at) 
        VALUES ('".$id_lembur."','".$id_karyawan."', '".$pilih_lembur."', '".$tanggal_lembur."','".$jam_mulai."','".$jam_akhir."','".$ambil_jam."','".$uraian_kerja."','".$persetujuan."', '".$no_iso."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function editLembur($id){
        $query = "SELECT * , CONCAT('LMB', LPAD(id_lembur, 8, '0')) as view_id
                    FROM master_lembur 
                    WHERE id_lembur=".$id['id_lembur'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editLemburSave($id_lembur, $id_karyawan, $pilih_lembur, $tanggal_lembur, $jam_mulai, $jam_akhir, $ambil_jam, $uraian_kerja, $persetujuan , $no_iso, $status_lembur, $change_by, $reason){
        $query = 
        "UPDATE master_lembur
        SET id_lembur='".$id_lembur."', id_karyawan ='".$id_karyawan."', pilih_lembur ='".$pilih_lembur."', tanggal_lembur ='".$tanggal_lembur."', jam_mulai='".$jam_mulai."',jam_akhir='".$jam_akhir."',ambil_jam='".$ambil_jam."', uraian_kerja='".$uraian_kerja."', persetujuan='".$persetujuan."',no_iso = '".$no_iso."', status_lembur='".$status_lembur."' ,change_by='".$change_by."', change_at=CURDATE()
        WHERE id_lembur='".$id_lembur."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_lembur(id_lembur, id_karyawan, pilih_lembur, tanggal_lembur, jam_mulai, jam_akhir, ambil_jam, uraian_kerja, persetujuan, no_iso, status_lembur, reason, change_by, change_at) 
        VALUES ('".$id_lembur."','".$id_karyawan."', '".$pilih_lembur."', '".$tanggal_lembur."','".$jam_mulai."','".$jam_akhir."','".$ambil_jam."','".$uraian_kerja."','".$persetujuan."', '".$no_iso."', '".$status_lembur."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusLembur($id_lembur, $id_karyawan, $no_iso, $change_by, $reason){
        $query = 
        "UPDATE master_lembur
        SET status_lembur='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_lembur='".$id_lembur."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_lembur(id_lembur, id_karyawan, pilih_lembur , tanggal_lembur, jam_mulai, jam_akhir, ambil_jam, uraian_kerja, persetujuan, no_iso, status_lembur, reason, change_by, change_at) 
        VALUES ('".$id_lembur."','".$id_karyawan."', '-','-','-','-','0','-','-', '".$no_iso."','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function checkLembur($id_karyawan, $pilih_lembur, $tanggal_lembur, $jam_mulai, $jam_akhir, $uraian_kerja){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_lembur
        JOIN master_karyawan ON master_karyawan.id_karyawan = master_lembur.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND master_lembur.pilih_lembur = '".$pilih_lembur."'
        AND master_lembur.tanggal_lembur = '".$tanggal_lembur."' 
        AND master_lembur.jam_mulai = '".$jam_mulai."'
        AND master_lembur.jam_akhir = '".$jam_akhir."'
        AND master_lembur.uraian_kerja = '".$uraian_kerja."'
        AND master_lembur.status_lembur  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditLembur($id_karyawan, $pilih_lembur, $tanggal_lembur, $jam_mulai, $jam_akhir, $uraian_kerja, $status_lembur){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM master_lembur
        JOIN master_karyawan ON master_karyawan.id_karyawan = master_lembur.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND master_lembur.pilih_lembur = '".$pilih_lembur."'
        AND master_lembur.tanggal_lembur = '".$tanggal_lembur."' 
        AND master_lembur.jam_mulai = '".$jam_mulai."'
        AND master_lembur.jam_akhir = '".$jam_akhir."'
        AND master_lembur.uraian_kerja = '".$uraian_kerja."'
        AND master_lembur.status_lembur = '".$status_lembur."'
        AND master_lembur.status_lembur  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function getRincianLembur($id, $tahun, $bulan){
        $bulan_ini = (int)$bulan;
        $bulan_kemarin = ((int)$bulan)-1;
        if($bulan_kemarin == 0)
        {
            $bulan_kemarin = 12;
        }

        $tahun_ini = (int)$tahun;
        $tahun_kemarin = ((int)$tahun)-1;

        $query  =   "SELECT l.id_lembur, k.nama_karyawan, d.nama_divisi, l.tanggal_lembur, 
                            l.jam_mulai, l.jam_akhir, l.uraian_kerja, l.persetujuan, l.status_lembur, u.username as change_by, 
                            DATE_FORMAT(l.change_at,'%Y-%m-%d') as change_at, CONCAT('LMB', LPAD(l.id_lembur, 8, '0')) as view_id, 
                            k.id_karyawan, l.ambil_jam, j.nama_jabatan
                    FROM master_lembur l 
                    JOIN master_karyawan k ON l.id_karyawan = k.id_karyawan 
                    JOIN master_divisi d ON k.id_divisi = d.id_divisi
                    JOIN user_login u ON l.change_by = u.id_user 
                    JOIN master_jabatan j ON j.id_jabatan = k.id_jabatan
                    WHERE l.status_lembur = 'Y' AND
                          IF('".$bulan_ini."' = '1', 
                              l.tanggal_lembur BETWEEN '".$tahun_kemarin."-".$bulan_kemarin."-18' AND '".$tahun_ini."-".$bulan_ini."-17',
                              l.tanggal_lembur BETWEEN '".$tahun_ini."-".$bulan_kemarin."-18' AND '".$tahun_ini."-".$bulan_ini."-17') AND
                          l.id_karyawan = '".$id."'
                    ORDER BY l.tanggal_lembur ASC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== Penggajian =====================================
    public function getAllJabatan(){
        $query  = "SELECT *
                    FROM master_jabatan
                    WHERE status_jabatan = 'Y'";
        $result = $this->db->query($query)->result_array();
		return $result;
    }
    
    public function getGajiLembur($tahun, $bulan, $id_karyawan){
        $bulan_ini = (int)$bulan;
        $bulan_kemarin = ((int)$bulan)-1;
        if($bulan_kemarin == 0)
        {
            $bulan_kemarin = 12;
        }

        $tahun_ini = (int)$tahun;
        $tahun_kemarin = ((int)$tahun)-1;

        $query = 
           "SELECT l.id_lembur, l.id_karyawan, l.tanggal_lembur, l.jam_mulai, l.jam_akhir, 
                @jam_lembur := l.ambil_jam as ambil_jam, 
                l.uraian_kerja, l.persetujuan, l.change_at, l.status_lembur, l.change_by, u.tahun_umk, u.total_umk,
                @gaji_per_jam := ROUND((u.total_umk/173), 0) as gaji_per_jam,
                @gaji_lembur := ROUND((@jam_lembur*@gaji_per_jam), 0) as gaji_lembur,
                @total_lembur := IFNULL(sum(@gaji_lembur), 0) as total_lembur
            FROM master_lembur l
            JOIN master_umk u ON YEAR(l.tanggal_lembur) = u.tahun_umk
            WHERE IF('".$bulan_ini."' = '1', 
                    l.tanggal_lembur BETWEEN CONCAT('".$tahun_kemarin."-', '".$bulan_kemarin."-', '18') AND CONCAT('".$tahun_ini."-', '".$bulan_ini."-', '17'),
                    l.tanggal_lembur BETWEEN CONCAT('".$tahun_ini."-', '".$bulan_kemarin."-', '18') AND CONCAT('".$tahun_ini."-', '".$bulan_ini."-', '17')) AND
                u.status_umk = 'Y' AND
                l.status_lembur = 'Y' AND
                l.id_karyawan = '".$id_karyawan."'";
        $result = $this->db->query($query); 
        return $result;  
    }

    public function getGaji($id_karyawan, $tahun, $bulan){
        $query = "
            SELECT @tahun_ini := ".$tahun." as tahun_ini, @tahun_kemarin := @tahun_ini-1 as tahun_kemarin,
                @bulan_ini := ".$bulan." as bulan_ini, @bulan_kemarin := IF(@bulan_ini-1 = 0, 12, @bulan_ini-1) as bulan_kemarin,
                IF(keterangan = 'Karyawan', CONCAT('KAR', LPAD(id_karyawan, 12, '0')), CONCAT('OUT', LPAD(id_karyawan, 12, '0'))) as view_id, 
                k.id_karyawan, k.nik, k.nama_karyawan, d.nama_divisi, j.nama_jabatan, k.plant, k.status_karyawan,
                @gaji_pokok := IFNULL(k.gaji_pokok, getGajiPokok(@tahun_ini, k.plant)) as gaji_pokok,
                @gaji_umk := getGajiPokok(@tahun_ini, k.plant) as gaji_umk,
                @tunjangan_jabatan := k.tunjangan_jabatan as tunjangan_jabatan,
                @tunjangan_keluarga := getTunjanganKeluarga(k.id_karyawan, @tahun_ini, @bulan_ini) as tunjangan_keluarga,
                @gaji_per_jam := getGajiPerJam(@tahun_ini, k.plant) as gaji_per_jam,
                @total_jam_lembur := (SELECT IFNULL(SUM(master_lembur.ambil_jam), 0)
                                        FROM master_lembur
                                        WHERE IF(@bulan_ini = '1', 
                                                master_lembur.tanggal_lembur BETWEEN STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'),
                                                master_lembur.tanggal_lembur BETWEEN STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d')) AND
                                                master_lembur.status_lembur = 'Y' AND
                                                master_lembur.id_karyawan = k.id_karyawan
                                        ) as total_jam_lembur,
                @jam_lembur_libur_a := (SELECT IFNULL(SUM(master_lembur.ambil_jam), 0)
                                        FROM master_lembur
                                        WHERE IF(@bulan_ini = '1', 
                                                master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND
                                                    master_lembur.tanggal_lembur < STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d'),
                                                master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND
                                                    master_lembur.tanggal_lembur < STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d')) AND
                                                master_lembur.status_lembur = 'Y' AND
                                                master_lembur.id_karyawan = k.id_karyawan AND
                                                (SELECT IF(EXISTS(SELECT 'Y' as HASIL
                                                                FROM master_jd_kerja_kyw
                                                                WHERE master_jd_kerja_kyw.tanggal_jadwal = master_lembur.tanggal_lembur AND
                                                                        master_jd_kerja_kyw.status = 'Y' AND
                                                                        master_jd_kerja_kyw.id_karyawan = k.id_karyawan AND
                                                                        IF(@bulan_ini = '1', 
                                                                        master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND
                                                                            master_lembur.tanggal_lembur < STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d'),
                                                                        master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND
                                                                            master_lembur.tanggal_lembur < STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d'))
                                                ), 'Y', 'N')) = 'N') as jam_lembur_libur_a,
                @jam_lembur_libur_b := (SELECT IFNULL(SUM(master_lembur.ambil_jam), 0)
                                        FROM master_lembur
                                        WHERE IF(@bulan_ini = '1', 
                                                master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d') AND
                                                    master_lembur.tanggal_lembur <= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'),
                                                master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d') AND
                                                    master_lembur.tanggal_lembur <= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d')) AND
                                                master_lembur.status_lembur = 'Y' AND
                                                master_lembur.id_karyawan = k.id_karyawan AND
                                                (SELECT IF(EXISTS(SELECT 'Y' as HASIL
                                                                FROM master_jd_kerja_kyw
                                                                WHERE master_jd_kerja_kyw.tanggal_jadwal = master_lembur.tanggal_lembur AND
                                                                        master_jd_kerja_kyw.status = 'Y' AND
                                                                        master_jd_kerja_kyw.id_karyawan = k.id_karyawan AND
                                                                        IF(@bulan_ini = '1', 
                                                                        master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d') AND
                                                                            master_lembur.tanggal_lembur <= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'),
                                                                        master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d') AND
                                                                            master_lembur.tanggal_lembur <= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'))
                                                ), 'Y', 'N')) = 'N') as jam_lembur_libur_b,
                @gaji_lembur_libur := (@jam_lembur_libur_a + @jam_lembur_libur_b)*@gaji_per_jam*2 as value_lembur_libur,
                @jam_lembur_a := (SELECT IFNULL(SUM(master_lembur.ambil_jam), 0)
                                        FROM master_lembur
                                        WHERE IF(@bulan_ini = '1', 
                                                master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND
                                                    master_lembur.tanggal_lembur < STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d'),
                                                master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND
                                                    master_lembur.tanggal_lembur < STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d')) AND
                                                master_lembur.status_lembur = 'Y' AND
                                                master_lembur.id_karyawan = k.id_karyawan AND
                                                (SELECT IF(EXISTS(SELECT 'Y' as HASIL
                                                                FROM master_jd_kerja_kyw
                                                                WHERE master_jd_kerja_kyw.tanggal_jadwal = master_lembur.tanggal_lembur AND
                                                                        master_jd_kerja_kyw.status = 'Y' AND
                                                                        master_jd_kerja_kyw.id_karyawan = k.id_karyawan AND
                                                                        IF(@bulan_ini = '1', 
                                                                        master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND
                                                                            master_lembur.tanggal_lembur < STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d'),
                                                                        master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND
                                                                            master_lembur.tanggal_lembur < STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d'))
                                                ), 'Y', 'N')) = 'Y') as jam_lembur_biasa_a,
                @jam_lembur_b := (SELECT IFNULL(SUM(master_lembur.ambil_jam), 0)
                                        FROM master_lembur
                                        WHERE IF(@bulan_ini = '1', 
                                                master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d') AND
                                                    master_lembur.tanggal_lembur <= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'),
                                                master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d') AND
                                                    master_lembur.tanggal_lembur <= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d')) AND
                                                master_lembur.status_lembur = 'Y' AND
                                                master_lembur.id_karyawan = k.id_karyawan AND
                                                (SELECT IF(EXISTS(SELECT 'Y' as HASIL
                                                                FROM master_jd_kerja_kyw
                                                                WHERE master_jd_kerja_kyw.tanggal_jadwal = master_lembur.tanggal_lembur AND
                                                                        master_jd_kerja_kyw.status = 'Y' AND
                                                                        master_jd_kerja_kyw.id_karyawan = k.id_karyawan AND
                                                                        IF(@bulan_ini = '1', 
                                                                        master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d') AND
                                                                            master_lembur.tanggal_lembur <= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'),
                                                                        master_lembur.tanggal_lembur >= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '1'), '%Y-%m-%d') AND
                                                                            master_lembur.tanggal_lembur <= STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'))
                                                ), 'Y', 'N')) = 'Y') as jam_lembur_biasa_b,
                @gaji_lembur_biasa := (@jam_lembur_a + @jam_lembur_b)*@gaji_per_jam as value_lembur_biasa,
                @ongkos_bongkar := getOngkosBongkar(k.id_karyawan, @tahun_ini, @bulan_ini) as ongkos_bongkar,
                @ongkos_lain := getOngkosLain(k.id_karyawan, @tahun_ini, @bulan_ini) as ongkos_lain,
                @sub_total_gaji := @gaji_pokok + @tunjangan_jabatan + IF(@tunjangan_keluarga = 'N', 0, @tunjangan_keluarga) + @gaji_lembur_libur + @gaji_lembur_biasa + IF(@ongkos_bongkar = 'N', 0, @ongkos_bongkar) + IF(@ongkos_lain = 'N', 0, @ongkos_lain) as sub_total_gaji,
                @bpjs_p_jkk := ROUND(@gaji_umk*0.89/100, 0) as bpjs_p_jkk,
                @bpjs_p_jht := ROUND(@gaji_umk*3.70/100, 0) as bpjs_p_jht,
                @bpjs_p_jkm := ROUND(@gaji_umk*0.3/100, 0) as bpjs_p_jkm,
                @bpjs_p_jp := ROUND(@gaji_umk*2/100, 0) as bpjs_p_jp,
                @bpjs_p_kesehatan := IF(k.bpjs_kesehatan = 'Y', ROUND(@gaji_umk*4/100, 0), 0) as bpjs_p_kesehatan,
                @bpjs_p_total := @bpjs_p_jkk + @bpjs_p_jht + @bpjs_p_jkm + @bpjs_p_jp + @bpjs_p_kesehatan as bpjs_p_total,
                
                @bpjs_k_jht := ROUND(@gaji_umk*2/100, 0) as bpjs_k_jht,
                @bpjs_k_jp := ROUND(@gaji_umk*1/100, 0) as bpjs_k_jp,
                @bpjs_k_kesehatan := IF(k.bpjs_kesehatan = 'Y', ROUND(@gaji_umk*1/100, 0), 0) as bpjs_k_kesehatan,
                @bpjs_k_total := @bpjs_k_jht + @bpjs_k_jp + @bpjs_k_kesehatan as bpjs_k_total,
                
                @total_gaji_lembur := @total_jam_lembur * @gaji_per_jam as total_gaji_lembur,
                k.tunjangan_jabatan,
                @jumlah_hari_kerja := (SELECT COUNT(master_jd_kerja_kyw.tanggal_jadwal)
                                        FROM master_jd_kerja_kyw
                                        WHERE IF(k.k_tk = 'Kontrak', 
                                                IF(@bulan_ini = '1', 
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'),
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d')),
                                                IF(@bulan_ini = '1', 
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '25'), '%Y-%m-%d'),
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '25'), '%Y-%m-%d'))
                                        ) AND
                                                master_jd_kerja_kyw.status = 'Y' AND
                                                master_jd_kerja_kyw.id_karyawan = k.id_karyawan) as jumlah_hari_kerja,
                @jumlah_libur_di_jadwal := (SELECT COUNT(master_kalender.jumlah_hari)
                                            FROM master_jd_kerja_kyw, master_kalender
                                            WHERE IF(k.k_tk = 'Kontrak', 
                                                IF(@bulan_ini = '1', 
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d'),
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '17'), '%Y-%m-%d')),
                                                IF(@bulan_ini = '1', 
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(@tahun_kemarin, '-', @bulan_kemarin, '-', '26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '25'), '%Y-%m-%d'),
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_kemarin, '-', '26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(@tahun_ini, '-', @bulan_ini, '-', '25'), '%Y-%m-%d'))
                                            ) AND
                                                    master_jd_kerja_kyw.status = 'Y' AND
                                                    master_jd_kerja_kyw.id_karyawan = k.id_karyawan AND
                                                    master_jd_kerja_kyw.tanggal_jadwal BETWEEN master_kalender.tanggal_mulai AND master_kalender.tanggal_akhir) as jumlah_libur_di_jadwal,
                @potongan_lain := getPotonganLain(k.id_karyawan, @tahun_ini, @bulan_ini) as potongan_lain,
                @potongan_absen_days := getPotongAbsen(k.id_karyawan, @tahun_ini, @bulan_ini) as potongan_absen_days,
                @potongan_absen_value := ROUND((@potongan_absen_days * @gaji_pokok / 25), 0) as potongan_absen_value,
                @sub_total_pengurang_gaji := (@bpjs_k_total + @potongan_lain + @potongan_absen_value) as sub_total_pengurang_gaji,
                (@sub_total_gaji-@sub_total_pengurang_gaji) as gaji_dibayar

                                                
            FROM master_karyawan k
                JOIN master_divisi d ON k.id_divisi = d.id_divisi
                JOIN master_jabatan j ON k.id_jabatan = j.id_jabatan
            WHERE k.status_karyawan = 'Y' AND 
                  IF('".$id_karyawan."' = '0', k.id_karyawan = k.id_karyawan, k.id_karyawan = '".$id_karyawan."') AND
                  k.ikut_penggajian = 'Y'
        ";
        $result = $this->db->query($query)->result_array();
		return $result;
    }

    public function checkGaji($id_karyawan, $tahun, $bulan){
        $query = "  SELECT IF(EXISTS(
                        SELECT *
                        FROM transaksi_penggajian p
                        WHERE p.status_gaji = 'Y' AND
                            p.id_karyawan = '".$id_karyawan."' AND
                            p.tahun_gaji = '".$tahun."' AND
                            p.bulan_gaji = '".$bulan."'), 'Y', 'N' ) as hasil";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function getLastIdGaji() {
        $query  = "SELECT MAX(id_gaji) AS MAX_ID FROM transaksi_penggajian";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function getWhereIdGaji($id_karyawan, $tahun, $bulan) {
        $query  = " SELECT id_gaji AS MAX_ID
                    FROM transaksi_penggajian
                    WHERE id_karyawan = '".$id_karyawan."' AND tahun_gaji = '".$tahun."' AND bulan_gaji = '".$bulan."';";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function inputGajiTunjanganKeluarga($id_gaji, $id_karyawan, $tahun, $bulan, $tunjangan_keluarga, $status, $change_by, $reason){
        $query = 
        "INSERT INTO transaksi_penggajian 
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."' , '".$tunjangan_keluarga."', NULL, NULL, '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_penggajian
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."' , '".$tunjangan_keluarga."', NULL, NULL, '".$reason."' , '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query2); 
    }

    public function inputGajiOngkosBongkar($id_gaji, $id_karyawan, $tahun, $bulan, $ongkos_bongkar, $status, $change_by, $reason){
        $query = 
        "INSERT INTO transaksi_penggajian 
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."' , NULL, '".$ongkos_bongkar."', NULL, '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_penggajian
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."', NULL , '".$ongkos_bongkar."', NULL, '".$reason."' , '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query2); 
    }

    public function inputGajiOngkosLain($id_gaji, $id_karyawan, $tahun, $bulan, $ongkos_lain, $status, $change_by, $reason){
        $query = 
        "INSERT INTO transaksi_penggajian 
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."' , NULL, NULL, '".$ongkos_lain."', '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_penggajian
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."', NULL , NULL, '".$ongkos_lain."', '".$reason."' , '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query2); 
    }

    public function editGajiTunjanganKeluarga($id_gaji, $id_karyawan, $tahun, $bulan, $tunjangan_keluarga, $status, $change_by, $reason){
        $query = 
        "UPDATE transaksi_penggajian 
        SET tunjangan_keluarga = '".$tunjangan_keluarga."', status_gaji = '".$status."' , change_by = '".$change_by."', change_at = CURDATE()
        WHERE id_karyawan = '".$id_karyawan."' AND tahun_gaji = '".$tahun."' AND bulan_gaji = '".$bulan."';";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_penggajian
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."' , '".$tunjangan_keluarga."', NULL, NULL, '".$reason."' , '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query2); 
    }

    public function editGajiOngkosBongkar($id_gaji, $id_karyawan, $tahun, $bulan, $ongkos_bongkar, $status, $change_by, $reason){
        $query = 
        "UPDATE transaksi_penggajian 
        SET ongkos_bongkar = '".$ongkos_bongkar."', status_gaji = '".$status."' , change_by = '".$change_by."', change_at = CURDATE()
        WHERE id_karyawan = '".$id_karyawan."' AND tahun_gaji = '".$tahun."' AND bulan_gaji = '".$bulan."';";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_penggajian
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."' , NULL, '".$ongkos_bongkar."', NULL, '".$reason."' , '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query2); 
    }

    public function editGajiOngkosLain($id_gaji, $id_karyawan, $tahun, $bulan, $ongkos_lain, $status, $change_by, $reason){
        $query = 
        "UPDATE transaksi_penggajian 
        SET ongkos_lain_lain = '".$ongkos_lain."', status_gaji = '".$status."' , change_by = '".$change_by."', change_at = CURDATE()
        WHERE id_karyawan = '".$id_karyawan."' AND tahun_gaji = '".$tahun."' AND bulan_gaji = '".$bulan."';";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_penggajian
        VALUES ('".$id_gaji."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."' , NULL, NULL, '".$ongkos_lain."', '".$reason."' , '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query2); 
    }

    // public function getPotongAbsen($id, $tahun, $bulan){
    //     $query = "
    //         SET @sum := 0;

    //         SELECT a.id_karyawan, @id_jam_kerja := a.id_jam_kerja as id_jam_kerja, d.id_divisi, d.nama_divisi, @tanggal := a.tanggal_jadwal as tanggal_jadwal, b.nama_karyawan,
    //                                         @cuti :=  IF(EXISTS(
    //                                             SELECT 'Y' as hasil
    //                                             FROM master_jd_kerja_kyw
    //                                             JOIN transaksi_cuti ON transaksi_cuti.id_karyawan = master_jd_kerja_kyw.id_karyawan
    //                                             WHERE (master_jd_kerja_kyw.tanggal_jadwal BETWEEN transaksi_cuti.tanggal_mulai_cuti AND transaksi_cuti.tanggal_akhir_cuti) AND 													  
    //                                                 transaksi_cuti.status_cuti = 'Y' AND
    //                                                 transaksi_cuti.id_karyawan = a.id_karyawan AND
    //                                                 master_jd_kerja_kyw.tanggal_jadwal = a.tanggal_jadwal AND
    //                                                 transaksi_cuti.status_cuti = 'Y'
    //                                             ),
    //                                             (
    //                                                 SELECT transaksi_cuti.id_cuti
    //                                                 FROM master_jd_kerja_kyw
    //                                                 JOIN transaksi_cuti ON transaksi_cuti.id_karyawan = master_jd_kerja_kyw.id_karyawan
    //                                                 WHERE (master_jd_kerja_kyw.tanggal_jadwal BETWEEN transaksi_cuti.tanggal_mulai_cuti AND transaksi_cuti.tanggal_akhir_cuti) AND 													  
    //                                                     transaksi_cuti.status_cuti = 'Y' AND
    //                                                     transaksi_cuti.id_karyawan = a.id_karyawan AND
    //                                                     master_jd_kerja_kyw.tanggal_jadwal = a.tanggal_jadwal AND
    //                                                     transaksi_cuti.status_cuti = 'Y'
    //                                             ), 'N'
    //                                         ) as status_cuti,
    //                                         @jam_masuk := (
    //                                         IF((@id_jam_kerja <> 5 AND DAYNAME(@tanggal) <> 'Saturday') OR (@id_jam_kerja <> 5 AND DAYNAME(@tanggal) = 'Saturday'),
    //                                                 (SELECT MIN(master_absensi.jam_absensi)
    //                                                 FROM master_jd_kerja_kyw
    //                                                 JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                                 WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                                     master_absensi.id_karyawan = b.id_karyawan AND
    //                                                     master_absensi.status_absensi = 'Y'),
    //                                                 IF(@id_jam_kerja = 5,
    //                                                 (SELECT MIN(master_absensi.jam_absensi)
    //                                                 FROM master_jd_kerja_kyw
    //                                                 JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                                 WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                                     master_absensi.id_karyawan = b.id_karyawan AND
    //                                                     master_absensi.status_absensi = 'Y' AND
    //                                                     master_absensi.jam_absensi > '12:0:0'),
    //                                                 (SELECT MAX(master_absensi.jam_absensi)
    //                                                 FROM master_jd_kerja_kyw
    //                                                 JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                                 WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                                     master_absensi.id_karyawan = b.id_karyawan AND
    //                                                     master_absensi.status_absensi = 'Y')))
    //                                         ) as jam_masuk,
    //                                         @jam_pulang := (
    //                                         IF((@id_jam_kerja <> 5 AND DAYNAME(@tanggal) <> 'Saturday')  OR (@id_jam_kerja <> 5 AND DAYNAME(@tanggal) = 'Saturday'),
    //                                                 (SELECT MAX(master_absensi.jam_absensi)
    //                                                 FROM master_jd_kerja_kyw
    //                                                 JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                                 WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                                     master_absensi.id_karyawan = b.id_karyawan AND
    //                                                     master_absensi.status_absensi = 'Y'),
    //                                                 IF(@id_jam_kerja = 5 AND DAYNAME(@tanggal) = 'Saturday',
    //                                                 (SELECT MAX(master_absensi.jam_absensi)
    //                                                 FROM master_jd_kerja_kyw
    //                                                 JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                                 WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                                     master_absensi.id_karyawan = b.id_karyawan AND
    //                                                     master_absensi.status_absensi = 'Y'),
    //                                                 (SELECT MIN(master_absensi.jam_absensi)
    //                                                 FROM master_jd_kerja_kyw
    //                                                 JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                                 JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                                 WHERE master_absensi.tanggal_absensi = DATE_ADD(a.tanggal_jadwal, INTERVAL 1 DAY) AND
    //                                                     master_absensi.id_karyawan = b.id_karyawan AND
    //                                                     master_absensi.status_absensi = 'Y')))
    //                                         ) as jam_pulang, @jd_masuk := c.jam_masuk as jd_masuk, @jd_pulang := c.jam_pulang as jd_pulang, @jd_masuk_sabtu := c.jam_masuk_sabtu as jd_masuk_sabtu, @jd_pulang_sabtu := c.jam_pulang_sabtu as jd_pulang_sabtu, @id_surat_ijin := IF(EXISTS(
    //                                         SELECT 'Y' as hasil
    //                                         FROM transaksi_surat_ijin
    //                                         WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
    //                                         ),
    //                                         (SELECT transaksi_surat_ijin.id_surat_ijin
    //                                         FROM transaksi_surat_ijin
    //                                         WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as id_surat_ijin, 
    //                                         @alasan_ijin := IF(EXISTS(
    //                                         SELECT 'Y' as hasil
    //                                         FROM transaksi_surat_ijin
    //                                         WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
    //                                         ),
    //                                         (SELECT transaksi_surat_ijin.alasan_ijin
    //                                         FROM transaksi_surat_ijin
    //                                         WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as alasan_izin,
    //                                         @jam_datang_keluar_ijin := IF(EXISTS(
    //                                         SELECT 'Y' as hasil
    //                                         FROM transaksi_surat_ijin
    //                                         WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
    //                                         ),
    //                                         (SELECT transaksi_surat_ijin.jam_datang_keluar_ijin
    //                                         FROM transaksi_surat_ijin
    //                                         WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as jam_datang_keluar_ijin,
    //                                         @status := IF(DAYNAME(@tanggal) = 'Saturday',
    //                                                 IF(@cuti = 'N',
    //                                                     IF(@jam_masuk <> @jam_pulang,
    //                                                         IF(@id_surat_ijin = 'N',
    //                                                             IF(TIMEDIFF (@jam_masuk, @jd_masuk_sabtu) >= '0:10:0', '0', 
    //                                                             IF(TIMEDIFF (@jam_pulang, @jd_pulang_sabtu) >= '0:0:0', '0', '0')),
    //                                                             '0'), '1'), '0'),
    //                                                 IF(@cuti = 'N',
    //                                                     IF(@jam_masuk <> @jam_pulang,
    //                                                         IF(@id_surat_ijin = 'N',
    //                                                             IF(TIMEDIFF (@jam_masuk, @jd_masuk) >= '0:10:0', '0', 
    //                                                             IF(TIMEDIFF (@jam_pulang, @jd_pulang) >= '0:0:0', '0', '0')),
    //                                                             '0'), '1'), '0')
    //                                                 ) as status,
    //                                     @jumlah := IF(@status = 1, @sum := @sum + 1, @sum := @sum) as sum
    //                                 from master_jd_kerja_kyw as a,
    //                                     master_karyawan as b,
    //                                     master_jam_kerja c,
    //                                     master_divisi d
    //                                 WHERE a.status = 'Y' AND
    //                                     b.id_karyawan = a.id_karyawan AND
    //                                     c.id_jam_kerja = a.id_jam_kerja AND
    //                                     d.id_divisi = b.id_divisi AND
    //                                     IF('".$id."' = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = '".$id."') AND
    //                                     IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = d.id_divisi) AND
    //                                     IF(b.k_tk = 'Kontrak', 
    //                                     IF('".$bulan."' = '1', 
    //                                         a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(".($tahun-1).", '-', 12, '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(".$tahun.", '-', ".$bulan.", '-17'), '%Y-%m-%d'),
    //                                         a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(".$tahun.", '-', ".($bulan-1).", '-18'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(".$tahun.", '-', ".$bulan.", '-17'), '%Y-%m-%d')),
    //                                     IF('".$bulan."' = '1', 
    //                                         a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(".($tahun-1).", '-', 12, '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(".$tahun.", '-', ".$bulan.", '-25'), '%Y-%m-%d'),
    //                                         a.tanggal_jadwal BETWEEN STR_TO_DATE(CONCAT(".$tahun.", '-', ".($bulan-1).", '-26'), '%Y-%m-%d') AND STR_TO_DATE(CONCAT(".$tahun.", '-', ".$bulan.", '-25'), '%Y-%m-%d')))
    //                                 ORDER BY sum DESC
    //                                 LIMIT 1
    //     ";
    //     $query = "SELECT 'adsasdads' as num"; 
    //     $query = "
    //     SET @sum := 0;

    //     SELECT a.id_karyawan, @id_jam_kerja := a.id_jam_kerja as id_jam_kerja, d.id_divisi, d.nama_divisi, @tanggal := a.tanggal_jadwal as tanggal_jadwal, b.nama_karyawan,
    //                                 @cuti :=  IF(EXISTS(
    //                                     SELECT 'Y' as hasil
    //                                     FROM master_jd_kerja_kyw
    //                                     JOIN transaksi_cuti ON transaksi_cuti.id_karyawan = master_jd_kerja_kyw.id_karyawan
    //                                     WHERE (master_jd_kerja_kyw.tanggal_jadwal BETWEEN transaksi_cuti.tanggal_mulai_cuti AND transaksi_cuti.tanggal_akhir_cuti) AND 													  
    //                                         transaksi_cuti.status_cuti = 'Y' AND
    //                                         transaksi_cuti.id_karyawan = a.id_karyawan AND
    //                                         master_jd_kerja_kyw.tanggal_jadwal = a.tanggal_jadwal AND
    //                                         transaksi_cuti.status_cuti = 'Y'
    //                                     ),
    //                                     (
    //                                         SELECT transaksi_cuti.id_cuti
    //                                         FROM master_jd_kerja_kyw
    //                                         JOIN transaksi_cuti ON transaksi_cuti.id_karyawan = master_jd_kerja_kyw.id_karyawan
    //                                         WHERE (master_jd_kerja_kyw.tanggal_jadwal BETWEEN transaksi_cuti.tanggal_mulai_cuti AND transaksi_cuti.tanggal_akhir_cuti) AND 													  
    //                                             transaksi_cuti.status_cuti = 'Y' AND
    //                                             transaksi_cuti.id_karyawan = a.id_karyawan AND
    //                                             master_jd_kerja_kyw.tanggal_jadwal = a.tanggal_jadwal AND
    //                                             transaksi_cuti.status_cuti = 'Y'
    //                                     ), 'N'
    //                                 ) as status_cuti,
    //                                 @jam_masuk := (
    //                                 IF((@id_jam_kerja <> 5 AND DAYNAME(@tanggal) <> 'Saturday') OR (@id_jam_kerja <> 5 AND DAYNAME(@tanggal) = 'Saturday'),
    //                                         (SELECT MIN(master_absensi.jam_absensi)
    //                                         FROM master_jd_kerja_kyw
    //                                         JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                         WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                             master_absensi.id_karyawan = b.id_karyawan AND
    //                                             master_absensi.status_absensi = 'Y'),
    //                                         IF(@id_jam_kerja = 5,
    //                                         (SELECT MIN(master_absensi.jam_absensi)
    //                                         FROM master_jd_kerja_kyw
    //                                         JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                         WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                             master_absensi.id_karyawan = b.id_karyawan AND
    //                                             master_absensi.status_absensi = 'Y' AND
    //                                             master_absensi.jam_absensi > '12:0:0'),
    //                                         (SELECT MAX(master_absensi.jam_absensi)
    //                                         FROM master_jd_kerja_kyw
    //                                         JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                         WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                             master_absensi.id_karyawan = b.id_karyawan AND
    //                                             master_absensi.status_absensi = 'Y')))
    //                                 ) as jam_masuk,
    //                                 @jam_pulang := (
    //                                 IF((@id_jam_kerja <> 5 AND DAYNAME(@tanggal) <> 'Saturday')  OR (@id_jam_kerja <> 5 AND DAYNAME(@tanggal) = 'Saturday'),
    //                                         (SELECT MAX(master_absensi.jam_absensi)
    //                                         FROM master_jd_kerja_kyw
    //                                         JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                         WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                             master_absensi.id_karyawan = b.id_karyawan AND
    //                                             master_absensi.status_absensi = 'Y'),
    //                                         IF(@id_jam_kerja = 5 AND DAYNAME(@tanggal) = 'Saturday',
    //                                         (SELECT MAX(master_absensi.jam_absensi)
    //                                         FROM master_jd_kerja_kyw
    //                                         JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                         WHERE master_absensi.tanggal_absensi = a.tanggal_jadwal AND
    //                                             master_absensi.id_karyawan = b.id_karyawan AND
    //                                             master_absensi.status_absensi = 'Y'),
    //                                         (SELECT MIN(master_absensi.jam_absensi)
    //                                         FROM master_jd_kerja_kyw
    //                                         JOIN master_karyawan ON master_jd_kerja_kyw.Id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_absensi ON master_absensi.id_karyawan = master_karyawan.id_karyawan
    //                                         JOIN master_jam_kerja ON master_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
    //                                         WHERE master_absensi.tanggal_absensi = DATE_ADD(a.tanggal_jadwal, INTERVAL 1 DAY) AND
    //                                             master_absensi.id_karyawan = b.id_karyawan AND
    //                                             master_absensi.status_absensi = 'Y')))
    //                                 ) as jam_pulang, @jd_masuk := c.jam_masuk as jd_masuk, @jd_pulang := c.jam_pulang as jd_pulang, @jd_masuk_sabtu := c.jam_masuk_sabtu as jd_masuk_sabtu, @jd_pulang_sabtu := c.jam_pulang_sabtu as jd_pulang_sabtu, @id_surat_ijin := IF(EXISTS(
    //                                 SELECT 'Y' as hasil
    //                                 FROM transaksi_surat_ijin
    //                                 WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
    //                                 ),
    //                                 (SELECT transaksi_surat_ijin.id_surat_ijin
    //                                 FROM transaksi_surat_ijin
    //                                 WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as id_surat_ijin, 
    //                                 @alasan_ijin := IF(EXISTS(
    //                                 SELECT 'Y' as hasil
    //                                 FROM transaksi_surat_ijin
    //                                 WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
    //                                 ),
    //                                 (SELECT transaksi_surat_ijin.alasan_ijin
    //                                 FROM transaksi_surat_ijin
    //                                 WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as alasan_izin,
    //                                 @jam_datang_keluar_ijin := IF(EXISTS(
    //                                 SELECT 'Y' as hasil
    //                                 FROM transaksi_surat_ijin
    //                                 WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'
    //                                 ),
    //                                 (SELECT transaksi_surat_ijin.jam_datang_keluar_ijin
    //                                 FROM transaksi_surat_ijin
    //                                 WHERE transaksi_surat_ijin.id_karyawan = a.id_karyawan AND transaksi_surat_ijin.tanggal_ijin = @tanggal AND transaksi_surat_ijin.status_ijin = 'Y'), 'N') as jam_datang_keluar_ijin,
    //                                 @status := IF(DAYNAME(@tanggal) = 'Saturday',
    //                                         IF(@cuti = 'N',
    //                                             IF(@jam_masuk <> @jam_pulang,
    //                                                 IF(@id_surat_ijin = 'N',
    //                                                     IF(TIMEDIFF (@jam_masuk, @jd_masuk_sabtu) >= '0:10:0', '0', 
    //                                                     IF(TIMEDIFF (@jam_pulang, @jd_pulang_sabtu) >= '0:0:0', '0', '0')),
    //                                                     '0'), '1'), '0'),
    //                                         IF(@cuti = 'N',
    //                                             IF(@jam_masuk <> @jam_pulang,
    //                                                 IF(@id_surat_ijin = 'N',
    //                                                     IF(TIMEDIFF (@jam_masuk, @jd_masuk) >= '0:10:0', '0', 
    //                                                     IF(TIMEDIFF (@jam_pulang, @jd_pulang) >= '0:0:0', '0', '0')),
    //                                                     '0'), '1'), '0')
    //                                         ) as status,
    //                             IF(@status = 1, @sum := @sum + 1, @sum := @sum) as sum
    //     from master_jd_kerja_kyw as a,
    //         master_karyawan as b,
    //         master_jam_kerja c,
    //         master_divisi d
    //     WHERE a.status = 'Y' AND
    //         b.id_karyawan = a.id_karyawan AND
    //         c.id_jam_kerja = a.id_jam_kerja AND
    //         d.id_divisi = b.id_divisi AND
    //         IF(2017 = '0', a.id_karyawan = a.id_karyawan, a.id_karyawan = '2017') AND
    //         IF('0' = '0', d.id_divisi = d.id_divisi, d.id_divisi = '10') AND
    //         IF(b.k_tk = 'Kontrak', 
    //         IF('1' = '1', 
    //             a.tanggal_jadwal BETWEEN '2020-12-18' AND '2021-1-17',
    //             a.tanggal_jadwal BETWEEN '2021-1-18' AND '2021-2-17'),
    //         IF('1' = '1', 
    //             a.tanggal_jadwal BETWEEN '2020-12-26' AND '2021-1-25',
    //             a.tanggal_jadwal BETWEEN '2021-1-25' AND '2021-2-25'))
    //     ORDER BY sum DESC
    //     LIMIT 1
    //     ";
        
    //     $result = $this->db->query($query); 
    //     return $result->result();  
    // }

    //=============================== Potong Absen =====================================
    public function getMasterPotongAbsen(){
        $query  =   "SELECT l.id_potong_absen, k.nama_karyawan, l.tahun, 
        l.bulan, l.total_hari, l.alasan_potong, l.status_potong, u.username as change_by, 
        DATE_FORMAT(l.change_at,'%Y-%m-%d') as change_at, CONCAT('PTG', LPAD(l.id_potong_absen, 8, '0')) as view_id, 
        k.id_karyawan, k.plant, d.nama_divisi, j.nama_jabatan
        FROM transaksi_potong_absen l 
        JOIN master_karyawan k ON l.id_karyawan = k.id_karyawan 
        JOIN master_divisi d ON k.id_divisi = d.id_divisi
        JOIN master_jabatan j ON k.id_jabatan = j.id_jabatan
        JOIN user_login u ON l.change_by = u.id_user 
        WHERE l.status_potong = 'Y'";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    public function getLastIdPotongAbsen() {
        $query  = "SELECT MAX(id_potong_absen) AS MAX_ID FROM transaksi_potong_absen";
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function inputPotongAbsen($id_potong_absen, $id_karyawan, $tahun, $bulan, $total_hari, $alasan_potong , $status, $change_by, $reason){
        $query = 
        "INSERT INTO transaksi_potong_absen 
        VALUES ('".$id_potong_absen."' , '".$id_karyawan."' , '".$tahun."' , '".$bulan."' , '".$total_hari."' , '".$alasan_potong."' , '".$status."' , '".$change_by."', CURDATE()  );";
        $result = $this->db->query($query);   

        $query2 = 
        "INSERT INTO history_potong_absen(id_potong_absen, id_karyawan, tahun, bulan, total_hari, alasan_potong, status_potong, reason, change_by, change_at) 
        VALUES ('".$id_potong_absen."','".$id_karyawan."', '".$tahun."', '".$bulan."','".$total_hari."','".$alasan_potong."','".$status."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    public function editPotongAbsen($id){
        $query = "SELECT * , CONCAT('PTG', LPAD(id_potong_absen, 8, '0')) as view_id
                    FROM transaksi_potong_absen 
                    WHERE id_potong_absen =".$id['id_potong_absen'];
        $result = $this->db->query($query)->result_array();
        return $result;
    }

    public function editPotongAbsenSave($id_potong_absen, $id_karyawan, $tahun, $bulan, $total_hari, $alasan_potong, $status_potong, $change_by, $reason){
        $query = 
        "UPDATE transaksi_potong_absen
        SET id_potong_absen='".$id_potong_absen."', id_karyawan ='".$id_karyawan."', tahun ='".$tahun."', bulan ='".$bulan."', total_hari='".$total_hari."',alasan_potong='".$alasan_potong."', status_potong='".$status_potong."' ,change_by='".$change_by."', change_at=CURDATE()
        WHERE id_potong_absen='".$id_potong_absen."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_potong_absen(id_potong_absen, id_karyawan, tahun, bulan, total_hari, alasan_potong, status_potong, reason, change_by, change_at) 
        VALUES ('".$id_potong_absen."','".$id_karyawan."', '".$tahun."', '".$bulan."','".$total_hari."','".$alasan_potong."','".$status_potong."','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
        
    }

    public function hapusPotongAbsen($id_potong_absen, $id_karyawan, $change_by, $reason){
        $query = 
        "UPDATE transaksi_potong_absen
        SET status_potong='N', change_by='".$change_by."', change_at=CURDATE()
        WHERE id_potong_absen='".$id_potong_absen."'";
        $result = $this->db->query($query);  

        $query2 = 
        "INSERT INTO history_potong_absen(id_potong_absen, id_karyawan, tahun, bulan, total_hari, alasan_potong, status_potong, reason, change_by, change_at) 
        VALUES ('".$id_potong_absen."','".$id_karyawan."', '-', '-','-','-','N','".$reason."', '".$change_by."', CURDATE());";
        $result = $this->db->query($query2); 
    }

    
    public function checkPotongAbsen($id_karyawan, $tahun, $bulan, $total_hari, $alasan_potong){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM transaksi_potong_absen
        JOIN master_karyawan ON master_karyawan.id_karyawan = transaksi_potong_absen.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND transaksi_potong_absen.tahun = '".$tahun."'
        AND transaksi_potong_absen.bulan = '".$bulan."' 
        AND transaksi_potong_absen.total_hari = '".$total_hari."'
        AND transaksi_potong_absen.alasan_potong = '".$alasan_potong."'
        AND transaksi_potong_absen.status_potong  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }

    public function checkEditPotongAbsen($id_karyawan, $tahun, $bulan, $total_hari, $alasan_potong, $status_potong){
        $query = 
        "SELECT IF(EXISTS(SELECT 'Y'
        FROM transaksi_potong_absen
        JOIN master_karyawan ON master_karyawan.id_karyawan = transaksi_potong_absen.id_karyawan
        WHERE master_karyawan.id_karyawan = '".$id_karyawan."' 
        AND transaksi_potong_absen.tahun = '".$tahun."'
        AND transaksi_potong_absen.bulan = '".$bulan."' 
        AND transaksi_potong_absen.total_hari = '".$total_hari."'
        AND transaksi_potong_absen.alasan_potong = '".$alasan_potong."'
        AND transaksi_potong_absen.status_potong = '".$status_potong."'
        AND transaksi_potong_absen.status_potong  = 'Y'), 'Y', 'N') as hasil";
        
        $result = $this->db->query($query)->result_array();
        return $result;   
    }
    //HISTORY
    //=============================== History Divisi =====================================
    public function getMasterHistoryDivisi(){
        $query  = "SELECT history_divisi.id_divisi, history_divisi.reason, history_divisi.nama_divisi, history_divisi.status_divisi , user_login.username as change_by, history_divisi.change_at, CONCAT('DIV', LPAD(history_divisi.id_divisi, 5, '0')) as view_id
                    FROM history_divisi
                    JOIN user_login ON history_divisi.change_by = user_login.id_user
                    ORDER BY history_divisi.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History Jabatan =====================================
    public function getMasterHistoryJabatan(){
        $query  = "SELECT history_jabatan.id_jabatan, history_jabatan.nama_jabatan , history_jabatan.status_jabatan ,history_jabatan.reason, user_login.username as change_by, history_jabatan.change_at, CONCAT('JAB', LPAD(history_jabatan.id_jabatan, 5, '0')) as view_id
                    FROM history_jabatan
                    JOIN user_login ON history_jabatan.change_by = user_login.id_user
                    ORDER BY history_jabatan.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History Jam Kerja =====================================
    public function getMasterHistoryJamKerja(){
        $query  = "SELECT history_jam_kerja.id_jam_kerja, history_jam_kerja.nama_jam_kerja , IF(history_jam_kerja.jam_masuk = '00:00:00','-', history_jam_kerja.jam_masuk) as jam_masuk, IF(history_jam_kerja.jam_pulang = '00:00:00','-',history_jam_kerja.jam_pulang) as jam_pulang, IF(history_jam_kerja.jam_masuk_sabtu = '00:00:00','-',history_jam_kerja.jam_masuk_sabtu) as jam_masuk_sabtu, IF(history_jam_kerja.jam_pulang_sabtu = '00:00:00','-',history_jam_kerja.jam_pulang_sabtu) as jam_pulang_sabtu , history_jam_kerja.status_jam_kerja , history_jam_kerja.reason, user_login.username as change_by, history_jam_kerja.change_at, CONCAT('JMK', LPAD(history_jam_kerja.id_jam_kerja, 5, '0')) as view_id
                    FROM history_jam_kerja
                    JOIN user_login ON history_jam_kerja.change_by = user_login.id_user
                    ORDER BY history_jam_kerja.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History Jadwal Kerja =====================================
    public function getMasterHistoryJadwalKerja(){
        $query  = "SELECT history_jd_kerja_kyw.id_jadwal, master_karyawan.nama_karyawan, master_jam_kerja.nama_jam_kerja ,IF(history_jd_kerja_kyw.tanggal_jadwal = '0000-00-00','-',history_jd_kerja_kyw.tanggal_jadwal) as tanggal_jadwal , history_jd_kerja_kyw.status, history_jd_kerja_kyw.reason, user_login.username as change_by, history_jd_kerja_kyw.change_at, CONCAT('JDK', LPAD(history_jd_kerja_kyw.id_jadwal, 11, '0')) as view_id
                    FROM history_jd_kerja_kyw
                    JOIN master_karyawan ON history_jd_kerja_kyw.id_karyawan = master_karyawan.id_karyawan
                    JOIN master_jam_kerja ON history_jd_kerja_kyw.id_jam_kerja = master_jam_kerja.id_jam_kerja
                    JOIN user_login ON history_jd_kerja_kyw.change_by = user_login.id_user
                    ORDER BY history_jd_kerja_kyw.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History Kalender =====================================
    public function getMasterHistoryKalender(){
        $query  = "SELECT history_kalender.id_kalender, history_kalender.nama_hari, history_kalender.jenis_hari,  IF(history_kalender.tanggal_mulai = '0000-00-00','-', history_kalender.tanggal_mulai) as tanggal_mulai , IF(history_kalender.tanggal_akhir = '0000-00-00', '-' ,history_kalender.tanggal_akhir) as tanggal_akhir , IF(history_kalender.jumlah_hari = 0 ,'-',history_kalender.jumlah_hari) as jumlah_hari , history_kalender.status_kalender, history_kalender.reason, user_login.username as change_by, history_kalender.change_at, CONCAT('KAL', LPAD(history_kalender.id_kalender, 5, '0')) as view_id
                    FROM history_kalender
                    JOIN user_login ON history_kalender.change_by = user_login.id_user
                    ORDER BY history_kalender.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History Karyawan =====================================
    public function getMasterHistoryKaryawan(){
        $query  =   "SELECT history_karyawan.id_karyawan, history_karyawan.nama_karyawan, history_karyawan.pin , master_divisi.nama_divisi, master_jabatan.nama_jabatan ,
                    history_karyawan.jenis_kelamin_karyawan, history_karyawan.status_karyawan , 
                    history_karyawan.reason, user_login.username as change_by, history_karyawan.change_at, CONCAT('KAR', LPAD(history_karyawan.id_karyawan, 5, '0')) as view_id ,
                    history_karyawan.nik, history_karyawan.no_ktp, history_karyawan.npwp, IF(history_karyawan.tanggal_masuk_karyawan = '0000-00-00','-',history_karyawan.tanggal_masuk_karyawan) as tanggal_masuk_karyawan, IF(history_karyawan.tanggal_keluar_karyawan = '0000-00-00','-',history_karyawan.tanggal_keluar_karyawan) as tanggal_keluar_karyawan,
                    history_karyawan.telp_karyawan, history_karyawan.tempat_lahir_karyawan, IF(history_karyawan.tanggal_lahir_karyawan = '0000-00-00', '-', history_karyawan.tanggal_lahir_karyawan) as tanggal_lahir_karyawan , history_karyawan.alamat_karyawan, IF(history_karyawan.tanggal_pengangkatan = '0000-00-00','-',history_karyawan.tanggal_pengangkatan) as tanggal_pengangkatan,
                    history_karyawan.keterangan, history_karyawan.k_tk, history_karyawan.pendidikan, history_karyawan.pkwt1, history_karyawan.pkwt2 , history_karyawan.gaji_pokok, history_karyawan.tunjangan_jabatan, history_karyawan.bpjs_kesehatan, history_karyawan.plant, history_karyawan.ikut_penggajian, history_karyawan.kawin_tdkkawin
                    FROM history_karyawan
                    JOIN master_divisi ON history_karyawan.id_divisi = master_divisi.id_divisi
                    JOIN master_jabatan ON master_jabatan.id_jabatan = history_karyawan.id_jabatan
                    JOIN user_login ON history_karyawan.change_by = user_login.id_user
                    ORDER BY history_karyawan.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History UMK =====================================
    public function getMasterHistoryUMK(){
        $query  =   "SELECT history_umk.id_umk, IF(history_umk.tahun_umk = 0,'-',history_umk.tahun_umk) as tahun_umk , IF(history_umk.total_umk = 0,'-',history_umk.total_umk) as total_umk, history_umk.status_umk, history_umk.reason, user_login.username as change_by, history_umk.change_at, CONCAT('UMK', LPAD(history_umk.id_umk, 5, '0')) as view_id, history_umk.gaji_per_jam, history_umk.plant
                    FROM history_umk
                    JOIN user_login ON history_umk.change_by = user_login.id_user
                    ORDER BY history_umk.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History USER =====================================
    public function getMasterHistoryUser(){
        $query  = "SELECT history_user_login.id_user, master_karyawan.nama_karyawan, history_user_login.username, history_user_login.password_user, history_user_login.status  ,history_user_login.reason, user_login.username as change_by, history_user_login.change_at, CONCAT('USR', LPAD(history_user_login.id_user, 5, '0')) as view_id
                    FROM history_user_login
                    JOIN user_login ON history_user_login.change_by = user_login.id_user
                    JOIN master_karyawan ON master_karyawan.id_karyawan = history_user_login.id_karyawan
                    ORDER BY history_user_login.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History Lembur =====================================
    public function getMasterHistoryLembur(){
        $query  =   "SELECT history_lembur.id_lembur, master_karyawan.nama_karyawan, master_divisi.nama_divisi, IF(history_lembur.tanggal_lembur = '0000-00-00','-', history_lembur.tanggal_lembur) as tanggal_lembur, IF(history_lembur.jam_mulai = '00:00:00','-', history_lembur.jam_mulai) as jam_mulai, IF(history_lembur.jam_akhir = '00:00:00','-',history_lembur.jam_akhir) as jam_akhir, history_lembur.uraian_kerja , history_lembur.persetujuan, history_lembur.status_lembur ,history_lembur.reason, user_login.username as change_by, history_lembur.change_at, CONCAT('LMB', LPAD(history_lembur.id_lembur, 5, '0')) as view_id, history_lembur.ambil_jam,
                    history_lembur.no_iso, history_lembur.pilih_lembur
                    FROM history_lembur
                    JOIN master_karyawan ON master_karyawan.id_karyawan = history_lembur.id_karyawan
                    JOIN master_divisi ON master_divisi.id_divisi = master_karyawan.id_divisi
                    JOIN user_login ON history_lembur.change_by = user_login.id_user
                    ORDER BY history_lembur.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }
    
    //=============================== History Surat Ijin =====================================
    public function getMasterHistoryIzin(){
        $query  =   "SELECT history_surat_ijin.id_surat_ijin,master_karyawan.nama_karyawan, master_divisi.nama_divisi, history_surat_ijin.tanggal_ijin, history_surat_ijin.alasan_ijin, IF(history_surat_ijin.jam_datang_keluar_ijin = '00:00:00', '-',history_surat_ijin.jam_datang_keluar_ijin) as jam_datang_keluar_ijin , history_surat_ijin.status_ijin,  history_surat_ijin.reason, user_login.username as change_by, history_surat_ijin.change_at, CONCAT('IZN', LPAD(history_surat_ijin.id_surat_ijin, 8, '0')) as view_id, history_surat_ijin.no_iso, history_surat_ijin.pilih_jam
                    FROM history_surat_ijin
                    JOIN master_karyawan ON master_karyawan.id_karyawan = history_surat_ijin.id_karyawan
                    JOIN master_divisi ON master_divisi.id_divisi = master_karyawan.id_divisi
                    JOIN user_login ON history_surat_ijin.change_by = user_login.id_user
                    ORDER BY history_surat_ijin.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History Cuti =====================================
    public function getMasterHistoryCuti(){
        $query  =   "SELECT transaksi_cuti.id_cuti, master_karyawan.nama_karyawan, master_divisi.nama_divisi, 
                    IF(transaksi_cuti.tahun_cuti = 0,'-',transaksi_cuti.tahun_cuti) as tahun_cuti ,
                    IF(transaksi_cuti.ambil_cuti = 0,'-',transaksi_cuti.ambil_cuti) as ambil_cuti , 
                    IF(transaksi_cuti.tanggal_mulai_cuti = '0000-00-00','-',transaksi_cuti.tanggal_mulai_cuti) as tanggal_mulai_cuti, 
                    IF(transaksi_cuti.tanggal_akhir_cuti = '0000-00-00' ,'-', transaksi_cuti.tanggal_akhir_cuti) as tanggal_akhir_cuti, 
                    transaksi_cuti.alasan_cuti, transaksi_cuti.status_cuti,  transaksi_cuti.reason, user_login.username as change_by, 
                    transaksi_cuti.change_at, CONCAT('CUT', LPAD(transaksi_cuti.id_cuti, 8, '0')) as view_id, transaksi_cuti.no_iso
                    FROM history_cuti transaksi_cuti
                    JOIN master_karyawan ON master_karyawan.id_karyawan = transaksi_cuti.id_karyawan
                    JOIN master_divisi ON master_divisi.id_divisi = master_karyawan.id_divisi
                    JOIN user_login ON transaksi_cuti.change_by = user_login.id_user
                    WHERE transaksi_cuti.change_by = user_login.id_user
                    ORDER BY transaksi_cuti.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }

    //=============================== History Potong Absen =====================================
    public function getMasterHistoryPotongAbsen(){
        $query  =   "SELECT history_potong_absen.id_potong_absen,master_karyawan.nama_karyawan, history_potong_absen.tahun, history_potong_absen.bulan, 
                    history_potong_absen.total_hari, history_potong_absen.alasan_potong, history_potong_absen.status_potong,  history_potong_absen.reason, 
                    user_login.username as change_by, history_potong_absen.change_at, 
                    CONCAT('PTG', LPAD(history_potong_absen.id_potong_absen, 8, '0')) as view_id
                    FROM history_potong_absen
                    JOIN master_karyawan ON master_karyawan.id_karyawan = history_potong_absen.id_karyawan
                    JOIN user_login ON history_potong_absen.change_by = user_login.id_user
                    ORDER BY history_potong_absen.change_at DESC";
    	$result = $this->db->query($query)->result_array();
		return $result;
    }
}
