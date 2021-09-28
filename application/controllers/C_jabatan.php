<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_jabatan extends CI_Controller {

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
        $data['fetch'] = $this->m_data->getMasterJabatan(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/jabatan/index_jabatan', $data);
        }else{
            $this->LogoutAction();
        }  
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/jabatan/input_jabatan');
        }else{
            $this->LogoutAction();
        }  	
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdJabatan();
		$id_jabatan = $highest_id[0]['MAX_ID']+1;
		$nama_jabatan = $this->input->post('nama_jabatan');
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';

		//check data duplicate
		$hasil_check_array = $this->m_data->checkJabatan($nama_jabatan);
		$hasil_check = $hasil_check_array[0]['hasil'];
		//echo $hasil_check;
		//var_dump($hasil_check_array);

		if($hasil_check == "N") //check apakah data sudah ada
		{
			//echo $id_absensi.", ".$id_karyawan.", ".$tanggal.", ".$jam_absensi.", ".$status_absensi.", ".$change_by.", ".date("Y-m-d")."</br>";
			$data['fetch'] = $this->m_data->inputJabatan($id_jabatan, $nama_jabatan, $status, $change_by, $reason);
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data jabatan berhasil diinput.
		  	</div>');
		}
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data jabatan sudah ada.
		  	</div>');
		}
		redirect("/jabatan/input");
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_jabatan' => $id);
		$data['jabatan'] = $this->m_data->editJabatan($where);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/jabatan/edit_jabatan', $data);
        }else{
            $this->LogoutAction();
        }  	
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_jabatan = $id;
		$nama_jabatan = $this->input->post('nama_jabatan');
		$status_jabatan = $this->input->post('status_jabatan');

		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');
		$hasil_check_array = $this->m_data->checkEditJabatan($nama_jabatan, $status_jabatan);
		$hasil_check = $hasil_check_array[0]['hasil'];
		//echo $hasil_check;
		//var_dump($hasil_check_array);

		if($hasil_check == "N") //check apakah data sudah ada
		{
			$data['fetch'] = $this->m_data->editJabatanSave($id_jabatan, $nama_jabatan, $status_jabatan, $change_by, $reason);
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data jabatan berhasil diedit.
		  	</div>');
			redirect("/jabatan");
		}
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data jabatan sudah ada	.
		  	</div>');
			redirect("/jabatan/edit/".$id_jabatan);
		}

		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_jabatan = $this->input->post('id_jabatan');
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data jabatan berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data jabatan gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusJabatan($id_jabatan, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    redirect("/jabatan");
        }else{
            $this->LogoutAction();
        }  	
	}

}
