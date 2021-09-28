<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_kalender extends CI_Controller {

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
        $data['fetch'] = $this->m_data->getMasterKalender(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/kalender/index_kalender', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/kalender/input_kalender');
        }else{
            $this->LogoutAction();
        }
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdKalender();
		$id_kalender = $highest_id[0]['MAX_ID']+1;
		$nama_hari = $this->input->post('nama_hari');
		$jenis_hari = $this->input->post('jenis_hari');
		$tanggal_mulai = $this->input->post('tanggal_mulai');
		$tanggal_akhir = $this->input->post('tanggal_akhir');
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';
		//check data duplicate
		$hasil_check_array = $this->m_data->checkKalender($nama_hari, $jenis_hari, $tanggal_mulai, $tanggal_akhir);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->inputKalender($id_kalender, $jenis_hari, $tanggal_mulai, $tanggal_akhir, $status, $change_by, $reason, $nama_hari);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data kalender berhasil diinput.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data kalender sudah ada.
		  	</div>');
		}

		redirect("/kalender/input");
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_kalender' => $id);
		$data['kalender'] = $this->m_data->editKalender($where);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/kalender/edit_kalender', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_kalender = $id;
		$nama_hari = $this->input->post('nama_hari');
		$jenis_hari = $this->input->post('jenis_hari');
		$tanggal_mulai = $this->input->post('tanggal_mulai');
		$tanggal_akhir = $this->input->post('tanggal_akhir');
		$status_kalender = $this->input->post('status_kalender');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');
		$hasil_check_array = $this->m_data->checkEditKalender($nama_hari, $jenis_hari, $tanggal_mulai, $tanggal_akhir, $status_kalender);
		$hasil_check = $hasil_check_array[0]['hasil'];

		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->editKalenderSave($id_kalender, $jenis_hari, $tanggal_mulai, $tanggal_akhir ,$status_kalender, $change_by, $reason, $nama_hari);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data kalender berhasil diedit.
		  	</div>');
			redirect("/kalender");
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data kalender sudah ada.
		  	</div>');
			redirect("/kalender/edit/".$id_kalender);
		}
		
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_kalender = $this->input->post('id_kalender');
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data kalender berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data kalender gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusKalender($id_kalender, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/kalender");
        }else{
            $this->LogoutAction();
        }
	}

}
