<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_lembur extends CI_Controller {

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
        $data['fetch'] = $this->m_data->getMasterLembur();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/lembur/index_lembur', $data);
        }else{
            $this->LogoutAction();
        }
	}
	
	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['surat_ijin'] = $this->m_data->getMasterLembur();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' || $_SESSION['role'] == '5'  ){ 
			$this->load->view('transaksi/lembur/input_lembur', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdLembur();
		$id_lembur = $highest_id[0]['MAX_ID']+1;
		$id_karyawan = $this->input->post('id_karyawan');
		$pilih_lembur = $this->input->post('pilih_lembur');
		$tanggal_lembur = $this->input->post('tanggal_lembur');
		$jam_mulai = $this->input->post('jam_mulai');
		$jam_akhir = $this->input->post('jam_akhir');
		$uraian_kerja = $this->input->post('uraian_kerja');
		$no_iso = 'Form / HRD / 013 Rev.01';
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';
		$persetujuan = 'Y';

		$j_jam_mulai = substr($jam_mulai,0, 2);
		$m_jam_mulai = substr($jam_mulai,3, 2);
		$j_jam_akhir = substr($jam_akhir,0, 2);
		$m_jam_akhir = substr($jam_akhir,3, 2);
		//echo "j_jam_mulai : ".$j_jam_mulai."</br>";
		//echo "m_jam_mulai : ".$m_jam_mulai."</br>";
		//echo "j_jam_akhir : ".$j_jam_akhir."</br>";
		//echo "m_jam_akhir : ".$m_jam_akhir."</br>";

		$total_menit_mulai = (((int)$j_jam_mulai*60)+(int)$m_jam_mulai);
		$total_menit_akhir = (((int)$j_jam_akhir*60)+(int)$m_jam_akhir);
		//echo "total menit mulai : ".$total_menit_mulai."</br>";
		//echo "total menit akhir : ".$total_menit_akhir."</br>";

		$hasil_kurang_menit = $total_menit_akhir - $total_menit_mulai;
		$ambil_jam = $hasil_kurang_menit/60;
		// if($pilih_lembur == "Lembur Biasa")
		// {
		// 	if($ambil_jam>=4)
		// 	{
		// 		$ambil_jam = $ambil_jam - 0.5;
		// 	}
		// }else
		// {
		// 	if($ambil_jam>7)
		// 	{
		// 		$ambil_jam = $ambil_jam - 1;
		// 	}
		// }
		//echo "hasil kurang (jam) = ".$ambil_jam."</br>";
		
		if($ambil_jam>=24)
		{
			$ambil_jam = $ambil_jam - 3;
		}
		else if($ambil_jam>=20)
		{
			$ambil_jam = $ambil_jam - 2.5;
		}
		else if($ambil_jam>=16)
		{
			$ambil_jam = $ambil_jam - 2;
		}
		else if($ambil_jam>=12)
		{
			$ambil_jam = $ambil_jam - 1.5;
		}
		else if($ambil_jam>=8)
		{
			$ambil_jam = $ambil_jam - 1;
		}
		else if($ambil_jam>=4)
		{
			$ambil_jam = $ambil_jam - 0.5;
		}
		// echo "hasil kurang (jam) = ".$ambil_jam."</br>";

		/*
		var_dump($id_lembur);
		var_dump($id_karyawan);
		var_dump($tanggal_lembur);
		var_dump($jam_mulai);
		var_dump($jam_akhir);
		var_dump($uraian_kerja);
		var_dump($change_by);
		*/
		
		$hasil_check_array = $this->m_data->checkLembur($id_karyawan, $pilih_lembur, $tanggal_lembur, $jam_mulai, $jam_akhir, $uraian_kerja);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->inputLembur($id_lembur, $id_karyawan, $pilih_lembur, $tanggal_lembur, $jam_mulai, $jam_akhir,$uraian_kerja, $persetujuan , $no_iso, $status, $change_by, $reason, $ambil_jam);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Lembur berhasil diinput.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Lembur sudah ada.
		  	</div>');
		}
		redirect("/lembur/input");
		
	}

	public function edit($id)
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$where = array('id_lembur' => $id);
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['lembur'] = $this->m_data->editLembur($where);
		//$data['id_karyawan_selected'] = $this->m_data->getKaryawanIdSelected($data['user'][0]['id_karyawan']);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/lembur/edit_lembur', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_lembur = $id;
		$id_karyawan = $this->input->post('id_karyawan');
		$pilih_lembur = $this->input->post('pilih_lembur');
		$tanggal_lembur = $this->input->post('tanggal_lembur');
		$jam_mulai = $this->input->post('jam_mulai');
		$jam_akhir = $this->input->post('jam_akhir');
		$uraian_kerja = $this->input->post('uraian_kerja');
		$no_iso = 'Form / HRD / 013 Rev.01';
		$status_lembur = $this->input->post('status_lembur');
		$reason = "Edit";
		$persetujuan = 'Y';
		$change_by = (int)$this->session->userdata('id_user');

		$j_jam_mulai = substr($jam_mulai,0, 2);
		$m_jam_mulai = substr($jam_mulai,3, 2);
		$j_jam_akhir = substr($jam_akhir,0, 2);
		$m_jam_akhir = substr($jam_akhir,3, 2);
		// echo "j_jam_mulai : ".$j_jam_mulai."</br>";
		// echo "m_jam_mulai : ".$m_jam_mulai."</br>";
		// echo "j_jam_akhir : ".$j_jam_akhir."</br>";
		// echo "m_jam_akhir : ".$m_jam_akhir."</br>";

		$total_menit_mulai = (((int)$j_jam_mulai*60)+(int)$m_jam_mulai);
		$total_menit_akhir = (((int)$j_jam_akhir*60)+(int)$m_jam_akhir);
		// echo "total menit mulai : ".$total_menit_mulai."</br>";
		// echo "total menit akhir : ".$total_menit_akhir."</br>";

		$hasil_kurang_menit = $total_menit_akhir - $total_menit_mulai;
		// echo "hasil_kurang_menit : ".$hasil_kurang_menit."</br>";

		$ambil_jam = $hasil_kurang_menit/60;
		// echo "ambil_jam : ".$ambil_jam."</br>";
		// if($pilih_lembur == "Lembur Biasa")
		// {
		// 	if($ambil_jam>=4)
		// 	{
		// 		$ambil_jam = $ambil_jam - 0.5;
		// 	}
		// }else
		// {
		// 	if($ambil_jam>7)
		// 	{
		// 		$ambil_jam = $ambil_jam - 1;
		// 	}
		// }
		// echo "ambil_jam2 : ".$ambil_jam."</br>";
		
		if($ambil_jam>=24)
		{
			$ambil_jam = $ambil_jam - 3;
		}
		else if($ambil_jam>=20)
		{
			$ambil_jam = $ambil_jam - 2.5;
		}
		else if($ambil_jam>=16)
		{
			$ambil_jam = $ambil_jam - 2;
		}
		else if($ambil_jam>=12)
		{
			$ambil_jam = $ambil_jam - 1.5;
		}
		else if($ambil_jam>=8)
		{
			$ambil_jam = $ambil_jam - 1;
		}
		else if($ambil_jam>=4)
		{
			$ambil_jam = $ambil_jam - 0.5;
		}

		//check
		$hasil_check_array = $this->m_data->checkEditLembur($id_karyawan, $pilih_lembur, $tanggal_lembur, $jam_mulai, $jam_akhir, $uraian_kerja, $status_lembur);
		$hasil_check = $hasil_check_array[0]['hasil'];
		
		if($hasil_check == "N") {
			$data['fetch'] = $this->m_data->editLemburSave($id_lembur, $id_karyawan, $pilih_lembur, $tanggal_lembur, $jam_mulai, $jam_akhir, $ambil_jam, $uraian_kerja, $persetujuan , $no_iso, $status_lembur, $change_by, $reason);
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Lembur berhasil diedit.
		  	</div>');
			redirect("/lembur");
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Lembur sudah ada.
		  	</div>');
			redirect("/lembur/edit/".$id_lembur);
		}
		
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_lembur = $this->input->post('id_lembur');
		$karyawan = $this->m_data->getMasterLembur();
		$no_iso = 'Form / HRD / 013 Rev.01';
        $id_karyawan = '';
        //var_dump($karyawan);
        foreach($karyawan as $k){
            if($id_lembur==$k['id_lembur'])
               $id_karyawan = $k['id_karyawan'];
        }
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data Lembur berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Lembur gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusLembur($id_lembur,$id_karyawan, $no_iso, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/lembur");
        }else{
            $this->LogoutAction();
        }
	}

	public function print($id){
		
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		
		$this->load->library('dompdf_gen');
		$data['id'] = $id;
		$data['lembur'] = $this->m_data->getMasterLembur();
		$data['karyawan'] = $this->m_data->getMasterKaryawan();
		$view_id = "";
		foreach($data['lembur'] as $s)
		{
			if($s['id_lembur'] == $id)
			{
				$view_id = $s['view_id'];
			}
		}
		$data['view_id'] = $view_id;
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){
			$this->load->view('transaksi/lembur/print_lembur',$data);
        }else{
            $this->LogoutAction();
        }

		//DOMPDF
		// $paper_size = '';
		// $orientation = 'portrait';
		// $html = $this->output->get_output();
		// // $html= $this->load->view('transaksi/lembur/print_lembur','',true);
		// $this->dompdf->set_paper($paper_size, $orientation);


		// $view_id = "";
		// foreach($data['lembur'] as $s)
		// {
		// 	if($s['id_lembur'] == $id)
		// 	{
		// 		$view_id = $s['view_id'];
		// 	}
		// }
		// $nama_file = "Surat Perintah Lembur ".$view_id;

		// $this->dompdf->load_html($html);
		// // $this->dompdf->render();
		// $this->dompdf->stream($nama_file.".pdf", array('Attachment' =>0));
		
	}

}
