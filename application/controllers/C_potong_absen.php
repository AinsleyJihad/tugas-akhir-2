<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_potong_absen extends CI_Controller {

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
		$data = $this->CheckSessUser();
		$data['fetch'] = $this->m_data->getMasterPotongAbsen();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/potong_absen/index_potong_absen', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/potong_absen/input_potong_absen', $data);
        }else{
            $this->LogoutAction();
        }
	}

	
	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdPotongAbsen();
		$id_potong_absen = $highest_id[0]['MAX_ID']+1;
		$id_karyawan = $this->input->post('id_karyawan');
		$tahun = $this->input->post('tahun');
        $bulan = $this->input->post('bulan');
        $total_hari = $this->input->post('total_hari');
		$alasan_potong = $this->input->post('alasan_potong');
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';
		
		
		/*
		var_dump($id_surat_ijin);
		var_dump($id_karyawan);
		var_dump($tanggal_ijin);
		var_dump($alasan_ijin);
		var_dump($jam_datang_keluar_ijin);
		var_dump($change_by);
		*/
		$hasil_check_array = $this->m_data->checkPotongAbsen($id_karyawan, $tahun, $bulan, $total_hari, $alasan_potong);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->inputPotongAbsen($id_potong_absen, $id_karyawan, $tahun, $bulan, $total_hari, $alasan_potong , $status, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data potong absen berhasil diinput.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data potong absen sudah ada.
		  	</div>');
		}
		redirect("/potong_absen/input");
			
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_potong_absen' => $id);
        $data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['potong_absen'] = $this->m_data->editPotongAbsen($where);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/potong_absen/edit_potong_absen', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_potong_absen = $id;
		$id_karyawan = $this->input->post('id_karyawan');
		$tahun = $this->input->post('tahun');
		$bulan = $this->input->post('bulan');
		$total_hari = $this->input->post('total_hari');
		$alasan_potong = $this->input->post('alasan_potong');
		$status_potong = $this->input->post('status_potong');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');
		$hasil_check_array = $this->m_data->checkEditPotongAbsen($id_karyawan, $tahun, $bulan, $total_hari, $alasan_potong, $status_potong);
		$hasil_check = $hasil_check_array[0]['hasil'];

		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->editPotongAbsenSave($id_potong_absen, $id_karyawan, $tahun, $bulan, $total_hari, $alasan_potong, $status_potong, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data potong absen berhasil diedit.
		  	</div>');
			redirect("/potong_absen");
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data potong absen sudah ada.
		  	</div>');
			redirect("/potong_absen/edit/".$id_potong_absen);
		}
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_potong_absen = $this->input->post('id_potong_absen');
		$karyawan = $this->m_data->getMasterPotongAbsen();
        $id_karyawan = '';
        //var_dump($karyawan);
        foreach($karyawan as $k){
            if($id_potong_absen==$k['id_potong_absen']){
               $id_karyawan = $k['id_karyawan'];
			}
        }
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Potong Absen berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Potong Absen gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusPotongAbsen($id_potong_absen, $id_karyawan, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/potong_absen");
        }else{
            $this->LogoutAction();
        }
	}


}
