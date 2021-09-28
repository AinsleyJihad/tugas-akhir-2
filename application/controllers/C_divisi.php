<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_divisi extends CI_Controller {

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
        $data['fetch'] = $this->m_data->getMasterDivisi();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/divisi/index_divisi', $data);
        }else{
            $this->LogoutAction();
        }   
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
        $data = $this->CheckSessUser();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/divisi/input_divisi');
        }else{
            $this->LogoutAction();
        }   	
	}

	public function save(){
		//$con = mysqli_connect("localhost","root","","payroll");

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		/*
		$getID = mysqli_query($con, "SELECT MAX(id_divisi) AS max FROM divisi");
		$row = mysqli_fetch_row($getID);
		$highest_id = $row['max'];
		*/
		$highest_id = $this->m_data->getLastIdDivisi();
		$id_divisi = $highest_id[0]['MAX_ID']+1;
		//var_dump($id_divisi);
		$nama_divisi = $this->input->post('nama_divisi');
		//var_dump($nama_divisi);
		$change_by = (int)$this->session->userdata('id_user');
		//var_dump ($change_by);
		$reason = "Create";
		//var_dump($reason);
		$status = 'Y';
		//var_dump($status);'
		//check data duplicate
		$hasil_check_array = $this->m_data->checkDivisi($nama_divisi);
		$hasil_check = $hasil_check_array[0]['hasil'];
		if($hasil_check == "N") //check apakah data sudah ada
		{
			//echo $id_absensi.", ".$id_karyawan.", ".$tanggal.", ".$jam_absensi.", ".$status_absensi.", ".$change_by.", ".date("Y-m-d")."</br>";
			$data['fetch'] = $this->m_data->inputDivisi($id_divisi, $nama_divisi, $status, $change_by, $reason);
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data divisi berhasil masuk.
		  	</div>');
		}
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data divisi sudah ada.
		  	</div>');
		}
		redirect("/divisi/input");
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_divisi' => $id);
		$data['divisi'] = $this->m_data->editDivisi($where);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/divisi/edit_divisi', $data);
        }else{
            $this->LogoutAction();
        }  
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_divisi = $id;
		$nama_divisi = $this->input->post('nama_divisi');
		$status_divisi = $this->input->post('status_divisi');

		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');
		//check data duplicate
		$hasil_check_array = $this->m_data->checkEditDivisi($nama_divisi, $status_divisi);
		$hasil_check = $hasil_check_array[0]['hasil'];
		if($hasil_check == "N") //check apakah data sudah ada
		{
			$data['fetch'] = $this->m_data->editDivisiSave($id_divisi, $nama_divisi, $status_divisi, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data divisi berhasil diedit.
		  	</div>');
			redirect("/divisi");
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data divisi sudah ada.
		  	</div>');
			redirect("/divisi/edit/".$id_divisi);
		}

		
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_divisi = $this->input->post('id_divisi');
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data divisi berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data divisi gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusDivisi($id_divisi, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/divisi");
        }else{
            $this->LogoutAction();
        }  
	}

	

}
