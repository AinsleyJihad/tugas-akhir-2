<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_umk extends CI_Controller {

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
        $data['fetch'] = $this->m_data->getMasterUmk(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/umk/index_umk', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/umk/input_umk');
        }else{
            $this->LogoutAction();
        }
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdUmk();
		$id_umk = $highest_id[0]['MAX_ID']+1;
		$tahun_umk = $this->input->post('tahun_umk');
		$total_umk = $this->input->post('jumlah_umk');
		$gaji_per_jam = $this->input->post('gaji_per_jam');
		$plant = $this->input->post('plant');
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';

		//check data duplicate
		$hasil_check_array = $this->m_data->checkUmk($tahun_umk, $plant);
		$hasil_check = $hasil_check_array[0]['hasil'];

		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->inputUmk($id_umk, $tahun_umk, $total_umk, $gaji_per_jam, $plant, $status, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data UMK berhasil diinput.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data UMK sudah ada.
		  	</div>');
		}

		redirect("/umk/input");
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_umk' => $id);
		$data['umk'] = $this->m_data->editUmk($where);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/umk/edit_umk', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_umk = $id;
		$tahun_umk = $this->input->post('tahun_umk');
		$total_umk = $this->input->post('total_umk');
		$gaji_per_jam = $this->input->post('gaji_per_jam');
		$status_umk = $this->input->post('status_umk');
		$plant = $this->input->post('plant');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');

		//check data duplicate
		$hasil_check_array = $this->m_data->checkEditUmk($tahun_umk, $total_umk, $gaji_per_jam, $plant, $status_umk);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->editUmkSave($id_umk, $tahun_umk, $total_umk, $gaji_per_jam, $plant, $status_umk, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data UMK berhasil diedit.
		  	</div>');
			redirect("/umk");
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data UMK sudah ada.
		  	</div>');
			redirect("/umk/edit/".$id_umk);
		}
		
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_umk = $this->input->post('id_umk');
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data UMK berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data UMK gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusUmk($id_umk, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/umk");
        }else{
            $this->LogoutAction();
        }
	}

}
