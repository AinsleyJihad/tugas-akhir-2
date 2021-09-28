<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_jam_kerja extends CI_Controller {

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
        $data['fetch'] = $this->m_data->getMasterJamKerja(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/jam_kerja/index_jam_kerja', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/jam_kerja/input_jam_kerja');
        }else{
            $this->LogoutAction();
        }
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdJamKerja();
		$id_jam_kerja = $highest_id[0]['MAX_ID']+1;
		$nama_jam_kerja = $this->input->post('nama_jam_kerja');
		$jam_masuk = $this->input->post('jam_masuk');
		$jam_pulang = $this->input->post('jam_pulang');
		$jam_masuk_sabtu = $this->input->post('jam_masuk_sabtu');
		$jam_pulang_sabtu = $this->input->post('jam_pulang_sabtu');
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';
		$hasil_check_array = $this->m_data->checkJamKerja($nama_jam_kerja, $jam_masuk,$jam_pulang, $jam_masuk_sabtu, $jam_pulang_sabtu);
		$hasil_check = $hasil_check_array[0]['hasil'];
		if($hasil_check == "N") //check apakah data sudah ada
		{
			$data['fetch'] = $this->m_data->inputJamKerja($id_jam_kerja, $nama_jam_kerja, $jam_masuk, $jam_pulang, $jam_masuk_sabtu, $jam_pulang_sabtu, $status, $change_by, $reason);
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data jam kerja berhasil diinput.
		  	</div>');
		}
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data jam kerja sudah ada.
		  	</div>');
		}

		redirect("/jam_kerja/input");
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_jam_kerja' => $id);
		$data['jam_kerja'] = $this->m_data->editJamKerja($where);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/jam_kerja/edit_jam_kerja', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_jam_kerja = $id;
		$nama_jam_kerja = $this->input->post('nama_jam_kerja');
		$jam_masuk = $this->input->post('jam_masuk');
		$jam_pulang = $this->input->post('jam_pulang');
		$jam_masuk_sabtu = $this->input->post('jam_masuk_sabtu');
		$jam_pulang_sabtu = $this->input->post('jam_pulang_sabtu');
		$status_jam_kerja = $this->input->post('status_jam_kerja');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');
		$hasil_check_array = $this->m_data->checkEditJamKerja($nama_jam_kerja, $jam_masuk,$jam_pulang, $jam_masuk_sabtu, $jam_pulang_sabtu, $status_jam_kerja);
		$hasil_check = $hasil_check_array[0]['hasil'];
		if($hasil_check == "N")
		{
			$data['fetch'] = $this->m_data->editJamKerjaSave($id_jam_kerja, $nama_jam_kerja, $jam_masuk, $jam_pulang, $jam_masuk_sabtu, $jam_pulang_sabtu, $status_jam_kerja, $change_by, $reason);
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data jam kerja berhasil diedit.
		  	</div>');
			redirect("/jam_kerja");
		}
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data jam kerja gagal diedit.
		  	</div>');
			redirect("/jam_kerja/edit/".$id_jam_kerja);
		}

		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_jam_kerja = $this->input->post('id_jam_kerja');
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data jam kerja berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data jam kerja gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusJamKerja($id_jam_kerja, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/jam_kerja");
        }else{
            $this->LogoutAction();
        }
	}

}
