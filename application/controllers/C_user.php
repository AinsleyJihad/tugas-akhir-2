<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_user extends CI_Controller {

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
        $data['fetch'] = $this->m_data->getMasterUser(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/user/index_user', $data);
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
			$this->load->view('master/user/input_user', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdUser();
		$id_user = $highest_id[0]['MAX_ID']+1;
		$id = $this->input->post('id');
		$username = $this->input->post('username');
		$role = $this->input->post('role');
		$password = md5($this->input->post('password'));
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';

		// echo $id_user;
		// echo "</br>";
		// echo $id;
		// echo "</br>";
		// echo $username;
		// echo "</br>";
		// echo $role;
		// echo "</br>";
		// echo $change_by;
		//check
		$hasil_check_array = $this->m_data->checkUser($id, $username, $role);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->inputUser($id_user, $id, $username, $password, $role, $status, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data User berhasil diinput.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data User sudah ada.
		  	</div>');
		}

		redirect("/user/input");
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_user' => $id);
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['user'] = $this->m_data->editUser($where);
		$data['id_karyawan_selected'] = $this->m_data->getKaryawanIdSelected($data['user'][0]['id_karyawan']);
		//echo $data['id_karyawan_selected'][0]['auto_id'];
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/user/edit_user', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_user = $id;
		$id_karyawan = $this->input->post('id_karyawan');
		$username = $this->input->post('username');
		$role = $this->input->post('role');
		$password_user = $this->input->post('password_user');

		$status_user = $this->input->post('status_user');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');

		$hasil_check_array = $this->m_data->checkEditUser($id_karyawan, $username, $password_user, $role, $status_user);
		$hasil_check = $hasil_check_array[0]['hasil'];

		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->editUserSave($id_user, $id_karyawan, $username, $password_user, $role, $status_user, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data User berhasil diedit.
		  	</div>');
			redirect("/user");

        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data User sudah ada.
		  	</div>');
			redirect("/user/edit/".$id_user);

		}
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_user = $this->input->post('id_user');
		$karyawan = $this->m_data->getMasterUser();
        $id_karyawan = '';
        //var_dump($karyawan);
        foreach($karyawan as $k){
            if($id_user==$k['id_user'])
               $id_karyawan = $k['id_karyawan'];
        }
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data User berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data User gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusUser($id_user, $id_karyawan, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/user");
        }else{
            $this->LogoutAction();
        }
	}

}
