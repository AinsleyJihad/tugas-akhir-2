<?php
defined('BASEPATH') OR exit('No direct script access allowed');

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class c_jadwal_kerja extends CI_Controller {

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
		$this->load->helper('form');        
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
        $data['fetch'] = $this->m_data->getMasterJadwalKerja(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/jadwal_kerja/index_jadwal_kerja', $data);
        }else{
            $this->LogoutAction();
        }  
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_user = $data['id_user']; 
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan(); 
		$data['jam_kerja'] = $this->m_data->getAllNamaDanShiftJamKerja();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/jadwal_kerja/input_jadwal_kerja', $data);
        }else{
            $this->LogoutAction();
        }  
	}

	public function save(){
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		
		$id_karyawan = $this->input->post('id_karyawan');
		$id_jam_kerja = $this->input->post('id_jam_kerja');
		//tanggal mulai
		$date = $this->input->post('tanggal_mulai');
		//tanggal akhir
		$end_date = $this->input->post('tanggal_akhir');
		$hari_minggu = $this->input->post('hari_minggu');
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';

		if ($hari_minggu == "true"){
			while (strtotime($date) <= strtotime($end_date)) {
				$day = date('D', strtotime($date));
					$highest_id = $this->m_data->getLastIdJadwalKerja();
					$id_jadwal = $highest_id[0]['MAX_ID']+1;
					//check data duplicate
					$hasil_check_array = $this->m_data->checkJadwal($id_karyawan, $date);
					$hasil_check = $hasil_check_array[0]['hasil'];
					//echo "tanggal : ".$tanggal.", jam : ".$jam_absensi.", ".$hasil_check."</br>";
					//echo $hasil_check;
					if($hasil_check == "N") //check apakah data sudah ada
					{
						//echo $id_absensi.", ".$id_karyawan.", ".$tanggal.", ".$jam_absensi.", ".$status_absensi.", ".$change_by.", ".date("Y-m-d")."</br>";
						$data['fetch'] = $this->m_data->inputJadwalKerja($id_jadwal, $id_karyawan, $id_jam_kerja, $date, $status, $change_by, $reason);
						$this->session->set_flashdata('msg', 
						'<div class="alert alert-success alert-dismissible">
							<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
							<h5><i class="icon fas fa-check"></i> Sukses!</h5>
							Data jadwal kerja berhasil diinput.
						</div>');
					}
					else {
						$this->session->set_flashdata('msg', 
						'<div class="alert alert-danger alert-dismissible">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
						<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
						Data jadwal kerja sudah ada.
						</div>');
					}
					$date = date ("Y-m-d", strtotime("+1 day", strtotime($date)));
					//echo $date.", ".$day."</br>";
			}
			
		}else{
				while (strtotime($date) <= strtotime($end_date)) {
				$day = date('D', strtotime($date));
				if($day != "Sun")
				{
					$highest_id = $this->m_data->getLastIdJadwalKerja();
					$id_jadwal = $highest_id[0]['MAX_ID']+1;
					//check data duplicate
					$hasil_check_array = $this->m_data->checkJadwal($id_karyawan, $date);
					$hasil_check = $hasil_check_array[0]['hasil'];
					//echo "tanggal : ".$tanggal.", jam : ".$jam_absensi.", ".$hasil_check."</br>";
					//echo $hasil_check;
					if($hasil_check == "N") //check apakah data sudah ada
					{
						//echo $id_absensi.", ".$id_karyawan.", ".$tanggal.", ".$jam_absensi.", ".$status_absensi.", ".$change_by.", ".date("Y-m-d")."</br>";
						$data['fetch'] = $this->m_data->inputJadwalKerja($id_jadwal, $id_karyawan, $id_jam_kerja, $date, $status, $change_by, $reason);
						$this->session->set_flashdata('msg', 
						'<div class="alert alert-success alert-dismissible">
							<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
							<h5><i class="icon fas fa-check"></i> Sukses!</h5>
							Data jadwal kerja berhasil diinput.
						</div>');
					}
					else {
						$this->session->set_flashdata('msg', 
						'<div class="alert alert-danger alert-dismissible">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
						<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
						Data jadwal kerja sudah ada.
						</div>');
					}
					
					//echo $date.", ".$day."</br>";
				}
				$date = date ("Y-m-d", strtotime("+1 day", strtotime($date)));
			}
		}
			
			redirect("/jadwal_kerja/input");
			
			
			/*
			if ($data) {
				echo '<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Success alert preview. This alert is dismissable.
				  </div>';
			}
			else {
				echo '<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Danger alert preview. This alert is dismissable. A wonderful serenity has taken possession of my
				entire
				soul, like these sweet mornings of spring which I enjoy with my whole heart.
				  </div>';
			}
			
			*/
		}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_jadwal' => $id);
		$data['jadwal_kerja'] = $this->m_data->editJadwalKerja($where);
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan(); 
		$data['jam_kerja'] = $this->m_data->getAllNamaDanShiftJamKerja();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/jadwal_kerja/edit_jadwal_kerja', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		
		$id_jadwal = $id;
		$id_karyawan = $this->input->post('id_karyawan');
		$id_jam_kerja = $this->input->post('id_jam_kerja');
		$date = $this->input->post('tanggal_jadwal');

		$status = $this->input->post('status_jadwal_kerja');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');

		$hasil_check_array = $this->m_data->checkEditJadwal($id_karyawan, $date, $id_jam_kerja, $status);
		$hasil_check = $hasil_check_array[0]['hasil'];
		//echo "tanggal : ".$tanggal.", jam : ".$jam_absensi.", ".$hasil_check."</br>";
		//echo $hasil_check;
		if($hasil_check == "N") //check apakah data sudah ada
		{
			//echo $id_absensi.", ".$id_karyawan.", ".$tanggal.", ".$jam_absensi.", ".$status_absensi.", ".$change_by.", ".date("Y-m-d")."</br>";
			$data['fetch'] = $this->m_data->editJadwalKerjaSave($id_jadwal, $id_karyawan, $id_jam_kerja, $date, $status, $change_by, $reason);
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data jadwal kerja berhasil diedit.
			</div>');
			redirect("/jadwal_kerja");
		}
		else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
			<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
			<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
			Data jadwal kerja sudah ada.
			</div>');
			redirect("/jadwal_kerja/edit/".$id_jadwal);
		}
		
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_jadwal_kerja = $this->input->post('id_jadwal_kerja');
		$karyawan = $this->m_data->getMasterJadwalKerja();
        $id_karyawan = '';
		$id_jam_kerja = '';
		//echo $id_jadwal_kerja;
        //var_dump($karyawan);
        foreach($karyawan as $k){
            if($id_jadwal_kerja == $k['id_jadwal'])
               $id_karyawan = $k['id_karyawan'];
        }

		foreach($karyawan as $k){
            if($id_jadwal_kerja == $k['id_jadwal'])
               $id_jam_kerja = $k['id_jam_kerja'];
        }
		//echo $id_karyawan;
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data jadwal kerja berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data jadwal kerja gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusJadwalKerja($id_jadwal_kerja, $id_karyawan, $id_jam_kerja, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/jadwal_kerja");
        }else{
            $this->LogoutAction();
        }
	}

}
