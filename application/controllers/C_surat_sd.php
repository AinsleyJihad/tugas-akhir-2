<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_surat_sd extends CI_Controller {

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
        // $this->login_asset_model->CheckLogin();
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
		$id_user = $data['id_user']; 
        $data['fetch'] = $this->m_data->getMasterSuratSD(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/suratsd/index_suratsd', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
        $data['fetch'] = $this->m_data->getMasterSuratSD(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/suratsd/input_suratsd', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdSuratSD();
		$id_surat = $highest_id[0]['MAX_ID']+1;
		$id_karyawan = $this->input->post('id_karyawan');
		$jenis_surat = $this->input->post('jenis_surat');
		$tanggal_surat = $this->input->post('tanggal_surat');
		$keterangan_surat = ($this->input->post('keterangan_surat'));
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';

		$hasil_check_array = $this->m_data->checkSuratSd($id_karyawan, $jenis_surat, $tanggal_surat, $keterangan_surat);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->inputSuratSD($id_surat, $id_karyawan, $jenis_surat, $tanggal_surat, $keterangan_surat, $status, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat berhasil diinput.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat sudah ada.
		  	</div>');
		}

		redirect("/suratsd/input");
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_surat' => $id);
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['suratsd'] = $this->m_data->editSuratSD($where);
		//echo $data['id_karyawan_selected'][0]['auto_id'];
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/suratsd/edit_suratsd', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_surat = $id;
		//$id_surat = $highest_id[0]['MAX_ID']+1;
		$id_karyawan = $this->input->post('id_karyawan');
		$jenis_surat = $this->input->post('jenis_surat');
		$tanggal_surat = $this->input->post('tanggal_surat');
		$keterangan_surat = ($this->input->post('keterangan_surat'));

		$status_surat = $this->input->post('status_surat');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');

		$hasil_check_array = $this->m_data->checkEditSuratSd($id_karyawan, $jenis_surat, $tanggal_surat, $keterangan_surat, $status_surat);
		$hasil_check = $hasil_check_array[0]['hasil'];

		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->editSuratSDSave($id_surat, $id_karyawan, $jenis_surat, $tanggal_surat, $keterangan_surat, $status_surat, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat berhasil diedit.
		  	</div>');
			redirect("/suratsd");

        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat sudah ada.
		  	</div>');
			redirect("/suratsd/edit/".$id_surat);

		}
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_surat = $this->input->post('id_surat');
		$karyawan = $this->m_data->getMasterSuratSD();
        $id_karyawan = '';
        //var_dump($karyawan);
        foreach($karyawan as $k){
            if($id_surat==$k['id_surat'])
               $id_karyawan = $k['id_karyawan'];
        }
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Surat berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Surat gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusSuratSD($id_surat, $id_karyawan, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/suratsd");
        }else{
            $this->LogoutAction();
        }
	}

}
