<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_izin extends CI_Controller {

	/**
	 * Index Page for this controller.
	 *
	 * Maps to the following URL
	 * 		http://example.com/index.php/welcome
	 *	- or -
	 * 		http://example.com/index.php/welcome/index
	 *	- or -
	 * Since this controller is set as the default controller in
	 * config/routes.php, it's displayed at http://example.com/
	 *
	 * So any other public methods not prefixed with an underscore will
	 * map to /index.php/welcome/<method_name>
	 * @see https://codeigniter.com/user_guide/general/urls.html
	 */

	//Constructor
	public function __construct() {
        parent::__construct();
        $this->load->helper('url');
        $this->load->model('m_data');
        $this->load->model('login_asset_model');        
	}    

	public function CheckSessUser() {
        $user = $this->session->userdata('user');
        $id_user = $this->session->userdata('id_user');        
        $data = array ('user' => $user,
                       'id_user' => $id_user);
        return $data;

    }

    public function LogoutAction() {
        $this->session->sess_destroy();
        redirect('/');
        exit; 
	}
	
	public function index()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		//$id_surat_ijin = $data['id_surat_ijin']; 
        $data['fetch'] = $this->m_data->getMasterIzin();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/izin/index_izin', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['surat_ijin'] = $this->m_data->getMasterIzin(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' || $_SESSION['role'] == '5'  ){ 
			$this->load->view('transaksi/izin/input_izin', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdIzin();
		$id_surat_ijin = $highest_id[0]['MAX_ID']+1;
		$id_karyawan = $this->input->post('id_karyawan');
		$tanggal_ijin = $this->input->post('tanggal_ijin');
		$alasan_ijin = $this->input->post('alasan_ijin');
		$pilih_jam = $this->input->post('pilih_jam');
		$jam_datang_keluar_ijin = $this->input->post('jam_datang_keluar_ijin');
		$no_iso = "Form/HRD/018-Rev.01";
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$persetujuan_hrd = 'Y';
		$persetujuan_kabag = 'Y';
		$status = 'Y';
		
		
		/*
		var_dump($id_surat_ijin);
		var_dump($id_karyawan);
		var_dump($tanggal_ijin);
		var_dump($alasan_ijin);
		var_dump($jam_datang_keluar_ijin);
		var_dump($change_by);
		*/
		$hasil_check_array = $this->m_data->checkIzin($id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->inputIzin($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $persetujuan_hrd, $no_iso ,$status, $change_by, $reason );
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat Izin berhasil diinput.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat Izin sudah ada.
		  	</div>');
		}
		redirect("/izin/input");
			
	}

	public function edit($id)
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_surat_ijin' => $id);
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['surat_ijin'] = $this->m_data->editIzin($where);
		//$data['id_karyawan_selected'] = $this->m_data->getKaryawanIdSelected($data['user'][0]['id_karyawan']);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/izin/edit_izin', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_surat_ijin = $id;
		$id_karyawan = $this->input->post('id_karyawan');
		$tanggal_ijin = $this->input->post('tanggal_ijin');
		$alasan_ijin = $this->input->post('alasan_ijin');
		$pilih_jam = $this->input->post('pilih_jam');
		$jam_datang_keluar_ijin = $this->input->post('jam_datang_keluar_ijin');
		$no_iso = "Form/HRD/018-Rev.01";
		$status_ijin = $this->input->post('status_ijin');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');

		$hasil_check_array = $this->m_data->checkIzin($id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->editIzinSave($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $no_iso, $status_ijin, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat Izin berhasil diedit.
		  	</div>');
			redirect("/izin");
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat Izin gagal diedit.
		  	</div>');
			redirect("/izin/edit/".$id_surat_ijin);

		}
		
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_surat_ijin = $this->input->post('id_surat_ijin');
		$karyawan = $this->m_data->getMasterIzin();
		$no_iso = "Form/HRD/018-Rev.01";
        $id_karyawan = '';
        //var_dump($karyawan);
        foreach($karyawan as $k){
            if($id_surat_ijin==$k['id_surat_ijin'])
               $id_karyawan = $k['id_karyawan'];
        }
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat Ijin berhasil diubah.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat Ijin gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusIzin($id_surat_ijin, $id_karyawan , $no_iso, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/izin");
        }else{
            $this->LogoutAction();
        }
	}

	public function indexPersetujuanKabag()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		//$id_surat_ijin = $data['id_surat_ijin']; 
        $data['fetch'] = $this->m_data->getPersetujuanIzinKabag();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '4' ){ 
			$this->load->view('transaksi/izin/persetujuan_izin_kabag', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function persetujuanKabag(){

		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_surat_ijin = $this->input->post('id_surat_ijin');
		$id_karyawan = $this->input->post('id_karyawan');
		$tanggal_ijin = $this->input->post('tanggal_ijin');
		$alasan_ijin = $this->input->post('alasan_ijin');
		$pilih_jam = $this->input->post('pilih_jam');
		$jam_datang_keluar_ijin = $this->input->post('jam_datang_keluar_ijin');
		$no_iso = "Form/HRD/018-Rev.01";
		$status_ijin = $this->input->post('status_ijin');
		$reason = "Kabag Menyetujui";
		$persetujuan_kabag = $this->input->post('persetujuan_kabag');
		$change_by = (int)$this->session->userdata('id_user');
	
		// echo $id_surat_ijin;
		// echo "</br>";
		// echo $id_karyawan;
		// echo "</br>";
		// echo $tanggal_ijin;
		// echo "</br>";
		// echo $alasan_ijin;
		// echo "</br>";
		// echo $pilih_jam;
		// echo "</br>";
		// echo $jam_datang_keluar_ijin;
		// echo "</br>";
		// echo $no_iso;
		// echo "</br>";
		// echo $status_ijin;
		// echo "</br>";
		// echo $reason;
		// echo "</br>";
		// echo $change_by;

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat Ijin berhasil disetujui.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat Ijin gagal disetujui.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->persetujuanKabag($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $no_iso ,$status_ijin, $change_by, $reason );
		redirect("/izin/indexpersetujuankabag");
	}

	public function penolakanKabag(){

		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_surat_ijin = $this->input->post('id_surat_ijin');
		$id_karyawan = $this->input->post('id_karyawan');
		$tanggal_ijin = $this->input->post('tanggal_ijin');
		$alasan_ijin = $this->input->post('alasan_ijin');
		$pilih_jam = $this->input->post('pilih_jam');
		$jam_datang_keluar_ijin = $this->input->post('jam_datang_keluar_ijin');
		$no_iso = "Form/HRD/018-Rev.01";
		$status_ijin = $this->input->post('status_ijin');
		$reason = "Kabag Menolak";
		$persetujuan_kabag = $this->input->post('persetujuan_kabag');
		$change_by = (int)$this->session->userdata('id_user');
	
		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat Ijin berhasil ditolak.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat Ijin gagal ditolak.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->penolakanKabag($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $no_iso ,$status_ijin, $change_by, $reason );
		redirect("/izin/indexpersetujuankabag");
	}

	public function indexPersetujuanHrd()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		//$id_surat_ijin = $data['id_surat_ijin']; 
        $data['fetch'] = $this->m_data->getPersetujuanIzinHRD();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/izin/persetujuan_izin_hrd', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function persetujuanHrd(){

		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_surat_ijin = $this->input->post('id_surat_ijin');
		$id_karyawan = $this->input->post('id_karyawan');
		$tanggal_ijin = $this->input->post('tanggal_ijin');
		$alasan_ijin = $this->input->post('alasan_ijin');
		$pilih_jam = $this->input->post('pilih_jam');
		$jam_datang_keluar_ijin = $this->input->post('jam_datang_keluar_ijin');
		$no_iso = "Form/HRD/018-Rev.01";
		$status_ijin = $this->input->post('status_ijin');
		$reason = "HRD Menyetujui";
		$persetujuan_kabag = $this->input->post('persetujuan_kabag');
		$persetujuan_hrd = $this->input->post('persetujuan_hrd');
		$change_by = (int)$this->session->userdata('id_user');
	
		// echo $id_surat_ijin;
		// echo "</br>";
		// echo $id_karyawan;
		// echo "</br>";
		// echo $tanggal_ijin;
		// echo "</br>";
		// echo $alasan_ijin;
		// echo "</br>";
		// echo $pilih_jam;
		// echo "</br>";
		// echo $jam_datang_keluar_ijin;
		// echo "</br>";
		// echo $persetujuan_kabag;
		// echo "</br>";
		// echo $persetujuan_hrd;
		// echo "</br>";
		// echo $no_iso;
		// echo "</br>";
		// echo $status_ijin;
		// echo "</br>";
		// echo $reason;
		// echo "</br>";
		// echo $change_by;

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat Ijin berhasil disetujui.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat Ijin gagal disetujui.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->persetujuanHrd($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $persetujuan_hrd, $no_iso ,$status_ijin, $change_by, $reason );
		redirect("/izin/indexpersetujuanhrd");
	}

	public function penolakanHrd(){

		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_surat_ijin = $this->input->post('id_surat_ijin');
		$id_karyawan = $this->input->post('id_karyawan');
		$tanggal_ijin = $this->input->post('tanggal_ijin');
		$alasan_ijin = $this->input->post('alasan_ijin');
		$pilih_jam = $this->input->post('pilih_jam');
		$jam_datang_keluar_ijin = $this->input->post('jam_datang_keluar_ijin');
		$no_iso = "Form/HRD/018-Rev.01";
		$status_ijin = $this->input->post('status_ijin');
		$reason = "HRD Menolak";
		$persetujuan_kabag = $this->input->post('persetujuan_kabag');
		$persetujuan_hrd = $this->input->post('persetujuan_hrd');
		$change_by = (int)$this->session->userdata('id_user');
	
		// echo $id_surat_ijin;
		// echo "</br>";
		// echo $id_karyawan;
		// echo "</br>";
		// echo $tanggal_ijin;
		// echo "</br>";
		// echo $alasan_ijin;
		// echo "</br>";
		// echo $pilih_jam;
		// echo "</br>";
		// echo $jam_datang_keluar_ijin;
		// echo "</br>";
		// echo $persetujuan_kabag;
		// echo "</br>";
		// echo $persetujuan_hrd;
		// echo "</br>";
		// echo $no_iso;
		// echo "</br>";
		// echo $status_ijin;
		// echo "</br>";
		// echo $reason;
		// echo "</br>";
		// echo $change_by;

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat Ijin berhasil ditolak.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat Ijin gagal ditolak.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->penolakanHrd($id_surat_ijin, $id_karyawan, $tanggal_ijin, $alasan_ijin, $pilih_jam, $jam_datang_keluar_ijin, $persetujuan_kabag, $persetujuan_hrd, $no_iso ,$status_ijin, $change_by, $reason );
		redirect("/izin/indexpersetujuanhrd");
	}

	public function print($id){
		
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		
		$this->load->library('dompdf_gen');
		$data['id'] = $id;
		$data['surat_ijin'] = $this->m_data->getMasterIzin();
		$data['karyawan'] = $this->m_data->getMasterKaryawan();
		$view_id = "";
		foreach($data['surat_ijin'] as $s)
		{
			if($s['id_surat_ijin'] == $id)
			{
				$view_id = $s['view_id'];
			}
		}
		$data['view_id'] = $view_id;
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/izin/print_izin',$data);
        }else{
            $this->LogoutAction();
        }

		// $paper_size = 'A5';
		// $orientation = 'portrait';
		// $html = $this->output->get_output();
		// $this->dompdf->set_paper($paper_size, $orientation);


		// $view_id = "";
		// foreach($data['surat_ijin'] as $s)
		// {
		// 	if($s['id_surat_ijin'] == $id)
		// 	{
		// 		$view_id = $s['view_id'];
		// 	}
		// }
		// $nama_file = "Surat Izin ".$view_id;

		// $this->dompdf->load_html($html);
		// $this->dompdf->render();
		// $this->dompdf->stream($nama_file.".pdf", array('Attachment' =>0));
	}

}
