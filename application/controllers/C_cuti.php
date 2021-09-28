<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_cuti extends CI_Controller {

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
		$data['fetch'] = $this->m_data->getMasterCuti();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/cuti/index_cuti', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' || $_SESSION['role'] == '5'  ){ 
			$this->load->view('transaksi/cuti/input_cuti', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function ambilSisaCuti()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		if(count($_POST)>0)
		{
			$id_karyawan = $_POST['id_karyawan'];
			$tahun = $_POST['tahun'];
			$data['fetch'] = $this->m_data->getSisaCuti($tahun, $id_karyawan);
			echo json_encode($data['fetch']);
		}
		
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$highest_id = $this->m_data->getLastIdCuti();
		$id_cuti = $highest_id[0]['MAX_ID']+1;
		$id_karyawan = $this->input->post('m_id_karyawan');
		$tahun_cuti = $this->input->post('m_tahun_cuti');
		$tanggal_mulai = $this->input->post('m_tanggal_mulai');
		$tanggal_akhir = $this->input->post('m_tanggal_akhir');
		$alasan_cuti = $this->input->post('m_alasan_cuti');
		$ambil_cuti_tahun_sekarang = $this->input->post('m_ambil_cuti_tahun_sekarang');
		$ambil_tahun_kemarin = $this->input->post('m_ambil_tahun_kemarin');
		$ambil_tahun_ini = $this->input->post('m_ambil_tahun_ini');
		$no_iso = "Form / HRD / 017-Rev.00";
		$sisa_cuti_lama_tahun_kemarin = $this->input->post('m_sisa_cuti_lama_tahun_kemarin');
		$sisa_cuti_lama_tahun_ini = $this->input->post('m_sisa_cuti_lama_tahun_ini');
		$sisa_cuti_baru_tahun_kemarin = $this->input->post('m_sisa_cuti_baru_tahun_kemarin');
		$sisa_cuti_baru_tahun_ini = $this->input->post('m_sisa_cuti_baru_tahun_ini');
		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';

		//echo "change_by : ".$change_by."</br>";

		// echo $sisa_cuti_lama_tahun_kemarin;
		// echo '</br>';
		// echo $sisa_cuti_lama_tahun_ini;
		// echo '</br>';
		// echo $m_sisa_cuti_baru_tahun_kemarin;
		// echo '</br>';
		// echo $m_sisa_cuti_baru_tahun_ini;
		/*
		echo "id_cuti : ".$id_cuti."</br>";
		echo "id_karyawan : ".$id_karyawan."</br>";
		echo "tahun_cuti : ".$tahun_cuti."</br>";
		echo "tanggal_mulai : ".$tanggal_mulai."</br>";
		echo "tanggal_akhir : ".$tanggal_akhir."</br>";
		echo "alasan_cuti : ".$alasan_cuti."</br>";
		echo "ambil_cuti_tahun_sekarang : ".$ambil_cuti_tahun_sekarang."</br>";
		echo "ambil_tahun_kemarin : ".$ambil_tahun_kemarin."</br>";
		echo "ambil_tahun_ini : ".$ambil_tahun_ini."</br>";
		echo "change_by : ".$change_by."</br>";
		echo "reason : ".$reason."</br>";
		echo "status : ".$status."</br>";
		*/
	
			if($ambil_cuti_tahun_sekarang == "N")
		{
			$hasil_check_array = $this->m_data->checkCuti($id_karyawan, $tahun_cuti, $tanggal_mulai, $tanggal_akhir, $ambil_tahun_kemarin, $alasan_cuti);
			$hasil_check = $hasil_check_array[0]['hasil'];
			if($hasil_check == "N") {
			$ambil_cuti = $ambil_tahun_kemarin;
			$sisa_cuti_lama = $sisa_cuti_lama_tahun_kemarin;
			$sisa_cuti_baru = $sisa_cuti_baru_tahun_kemarin;
			$data['fetch'] = $this->m_data->inputCuti($id_cuti, $id_karyawan, $tahun_cuti,  $sisa_cuti_lama, $sisa_cuti_baru, $tanggal_mulai, $tanggal_akhir, $alasan_cuti, $ambil_cuti, $ambil_cuti_tahun_sekarang, $no_iso,  $status, $change_by, $reason);
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data cuti berhasil diinput.
		  	</div>');
			}else {
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-danger alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
					Data cuti gagal diinput.
				  </div>');
			}
		}
		else if($ambil_cuti_tahun_sekarang == "Y")
		{
			$hasil_check_array = $this->m_data->checkCuti($id_karyawan, $tahun_cuti, $tanggal_mulai, $tanggal_akhir, $ambil_tahun_ini, $alasan_cuti);
			$hasil_check = $hasil_check_array[0]['hasil'];
			if($hasil_check == "N") {
			$ambil_cuti = $ambil_tahun_ini;
			$sisa_cuti_lama = $sisa_cuti_lama_tahun_ini;
			$sisa_cuti_baru = $sisa_cuti_baru_tahun_ini;
			$data['fetch'] = $this->m_data->inputCuti($id_cuti, $id_karyawan, $tahun_cuti, $sisa_cuti_lama, $sisa_cuti_baru, $tanggal_mulai, $tanggal_akhir, $alasan_cuti, $ambil_cuti, $ambil_cuti_tahun_sekarang, $no_iso,  $status, $change_by, $reason);
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data cuti berhasil diinput.
		  	</div>');
			}else {
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-danger alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
					Data cuti gagal diinput.
				  </div>');
			}
		}
		else
		{
			
			$ambil_cuti_tahun_sekarang = "N";
			$ambil_tanggal = date_create($tanggal_akhir);
			$ambil_cuti = $ambil_tahun_kemarin;
			$sisa_cuti_lama = $sisa_cuti_lama_tahun_kemarin;
			$sisa_cuti_baru = $sisa_cuti_baru_tahun_kemarin;
			$tanggal_akhir_new = date_sub($ambil_tanggal,date_interval_create_from_date_string($ambil_tahun_ini." days"));
			$tanggal_akhir_new = date_format($tanggal_akhir_new,"Y-m-d");
			//var_dump($tanggal_akhir_new)."</br>";
			

			$id_cuti1 = $id_cuti;
			$id_karyawan1 = $id_karyawan;
			$tahun_cuti1 = $tahun_cuti;
			$sisa_cuti_lama1 = $sisa_cuti_lama;
			$sisa_cuti_baru1 = $sisa_cuti_baru;
			$tanggal_mulai1 = $tanggal_mulai;
			$tanggal_akhir_new1 = $tanggal_akhir_new;
			$alasan_cuti1 = $alasan_cuti;
			$ambil_cuti1 = $ambil_cuti;
			$ambil_cuti_tahun_sekarang1 = $ambil_cuti_tahun_sekarang;
			$no_iso1 = $no_iso;
			$status1 = $status;
			$change_by1 = $change_by;
			$reason1 = $reason;
			
			
			
			
			//$id_cuti = $id_cuti+1;
			$ambil_cuti_tahun_sekarang = "Y";
			$ambil_tanggal = date_create($tanggal_mulai);
			$ambil_cuti = $ambil_tahun_ini;
			$sisa_cuti_lama = $sisa_cuti_lama_tahun_ini;
			$sisa_cuti_baru = $sisa_cuti_baru_tahun_ini;
			$tanggal_mulai_new = date_add($ambil_tanggal,date_interval_create_from_date_string($ambil_tahun_kemarin." days"));
			$tanggal_mulai_new = date_format($tanggal_mulai_new,"Y-m-d");
			//var_dump($tanggal_mulai_new)."</br>";

			$id_cuti2 = $id_cuti;
			$id_karyawan2 = $id_karyawan;
			$tahun_cuti2 = $tahun_cuti;
			$sisa_cuti_lama2 = $sisa_cuti_lama;
			$sisa_cuti_baru2 = $sisa_cuti_baru;
			$tanggal_mulai_new2 = $tanggal_mulai_new;
			$tanggal_akhir2 = $tanggal_akhir;
			$alasan_cuti2 = $alasan_cuti;
			$ambil_cuti2 = $ambil_cuti;
			$no_iso2 = $no_iso;
			$ambil_cuti_tahun_sekarang2 = $ambil_cuti_tahun_sekarang;
			$status2 = $status;
			$change_by2 = $change_by;
			$reason2 = $reason;
			$id_cuti2 = $id_cuti+1;

			$hasil_check_array = $this->m_data->checkCuti($id_karyawan1, $tahun_cuti1, $tanggal_mulai1, $tanggal_akhir_new1, $ambil_tahun_ini1, $alasan_cuti1);
			$hasil_check = $hasil_check_array[0]['hasil'];
			if($hasil_check == "N") {
				$hasil_check_array2 = $this->m_data->checkCuti($id_karyawan2, $tahun_cuti2, $tanggal_mulai_new2, $tanggal_akhir2, $ambil_tahun_ini2, $alasan_cuti2);
				$hasil_check2 = $hasil_check_array2[0]['hasil'];
				if($hasil_check2 == "N"){
					$data['fetch'] = $this->m_data->inputCuti($id_cuti1, $id_karyawan1, $tahun_cuti1,$sisa_cuti_lama1, $sisa_cuti_baru1,  $tanggal_mulai1, $tanggal_akhir_new1, $alasan_cuti1, $ambil_cuti1, $ambil_cuti_tahun_sekarang1, $no_iso1, $status1, $change_by1, $reason1);
					$data['fetch'] = $this->m_data->inputCuti($id_cuti2, $id_karyawan2, $tahun_cuti2,$sisa_cuti_lama2, $sisa_cuti_baru2, $tanggal_mulai_new2, $tanggal_akhir2, $alasan_cuti2, $ambil_cuti2, $ambil_cuti_tahun_sekarang2, $no_iso2, $status2, $change_by2, $reason2);
					$this->session->set_flashdata('msg', 
					'<div class="alert alert-success alert-dismissible">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
						<h5><i class="icon fas fa-check"></i> Sukses!</h5>
						Data cuti berhasil diinput.
					  </div>');
				}else {
					$this->session->set_flashdata('msg', 
					'<div class="alert alert-danger alert-dismissible">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
						<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
						Data cuti gagal diinput.
					  </div>');
				}
				
			}
			else {
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-danger alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
					Data cuti gagal diinput.
				  </div>');
			}
		/*
		$data['fetch'] = $this->m_data->inputCuti($id_cuti, $id_karyawan, $tahun_cuti, $tanggal_mulai, $tanggal_akhir, $alasan_cuti, $ambil_cuti, $ambil_cuti_tahun_sekarang, $status, $change_by, $reason);
		*/
        
		
	}
	redirect("/cuti/input");
}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_cuti' => $id);
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['cuti'] = $this->m_data->editCuti($where);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/cuti/edit_cuti', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_cuti = $id;
		$id_karyawan = $this->input->post('m_id_karyawan');
		$tahun_cuti = $this->input->post('m_tahun_cuti');
		// $ambil_tahun_kemarin = $this->input->post('m_ambil_tahun_kemarin');
		// $ambil_tahun_ini = $this->input->post('m_ambil_tahun_ini');
		$ambil_cuti = $this->input->post('m_total_ambil');
		$tanggal_mulai_cuti = $this->input->post('m_tanggal_mulai');
		$tanggal_akhir_cuti = $this->input->post('m_tanggal_akhir');
		$alasan_cuti = $this->input->post('m_alasan_cuti');
		$persetujuan_cuti = "Y";
		$sisa_cuti_lama_tahun_kemarin = $this->input->post('m_sisa_cuti_lama_tahun_kemarin');
		$sisa_cuti_lama_tahun_ini = $this->input->post('m_sisa_cuti_lama_tahun_ini');
		$sisa_cuti_baru_tahun_kemarin = $this->input->post('m_sisa_cuti_baru_tahun_kemarin');
		$sisa_cuti_baru_tahun_ini = $this->input->post('m_sisa_cuti_baru_tahun_ini');
		$ambil_tahun_sekarang = $this->input->post('m_ambil_cuti_tahun_sekarang');
		$status_cuti = $this->input->post('m_status_cuti');
		$no_iso = "Form / HRD / 017-Rev.00";
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');

		// echo "id_cuti : ".$id_cuti."</br>";
		// echo "id_karyawan : ".$id_karyawan."</br>";
		// echo "tahun_cuti : ".$tahun_cuti."</br>";
		// echo "ambil_cuti : ".$ambil_cuti."</br>";
		// echo "tanggal_mulai_cuti : ".$tanggal_mulai_cuti."</br>";
		// echo "alasan_cuti : ".$alasan_cuti."</br>";
		// echo "persetujuan_cuti : ".$persetujuan_cuti."</br>";
		// echo "ambil_tahun_sekarang : ".$ambil_tahun_sekarang."</br>";
		// echo "status_cuti : ".$status_cuti."</br>";
		// echo "reason : ".$reason."</br>";
		// echo "change_by : ".$change_by."</br>";

			if($ambil_tahun_sekarang == "N")
		{
			$hasil_check_array = $this->m_data->checkEditCuti($id_karyawan, $tahun_cuti, $tanggal_mulai_cuti, $tanggal_akhir_cuti, $ambil_cuti, $alasan_cuti, $status_cuti);
			$hasil_check = $hasil_check_array[0]['hasil'];
			if($hasil_check == "N") {
				// $ambil_cuti = $ambil_tahun_kemarin;
				$sisa_cuti_lama = $sisa_cuti_lama_tahun_kemarin;
				$sisa_cuti_baru = $sisa_cuti_baru_tahun_kemarin;
				$data['fetch'] = $this->m_data->editCutiSave($id_cuti, $id_karyawan, $tahun_cuti, $sisa_cuti_lama, $sisa_cuti_baru, $ambil_cuti, $tanggal_mulai_cuti, $tanggal_akhir_cuti, $alasan_cuti, $persetujuan_cuti, $ambil_tahun_sekarang, $no_iso, $status_cuti, $change_by, $reason);
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-success alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-check"></i> Sukses!</h5>
					Data cuti berhasil diedit.
				  </div>');
				redirect("/cuti");
			}
			else {
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-danger alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
					Data cuti gagal diedit.
				  </div>');
				redirect("/cuti/edit/".$id_cuti);
			}
		}else if($ambil_tahun_sekarang == "Y")
		{
			$hasil_check_array = $this->m_data->checkEditCuti($id_karyawan, $tahun_cuti, $tanggal_mulai_cuti, $tanggal_akhir_cuti, $ambil_cuti, $alasan_cuti, $status_cuti);
			$hasil_check = $hasil_check_array[0]['hasil'];
			if($hasil_check == "N") {
				// $ambil_cuti = $ambil_tahun_ini;
				$sisa_cuti_lama = $sisa_cuti_lama_tahun_ini;
				$sisa_cuti_baru = $sisa_cuti_baru_tahun_ini;
				$data['fetch'] = $this->m_data->editCutiSave($id_cuti, $id_karyawan, $tahun_cuti, $sisa_cuti_lama, $sisa_cuti_baru, $ambil_cuti, $tanggal_mulai_cuti, $tanggal_akhir_cuti, $alasan_cuti, $persetujuan_cuti, $ambil_tahun_sekarang, $no_iso, $status_cuti, $change_by, $reason);
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-success alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-check"></i> Sukses!</h5>
					Data cuti berhasil diedit.
				  </div>');
				redirect("/cuti");
			}
			else {
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-danger alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
					Data cuti gagal diedit.
				  </div>');
				redirect("/cuti/edit/".$id_cuti);
			}
		}
		
	}

	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_cuti = $this->input->post('id_cuti');
		$karyawan = $this->m_data->getMasterCuti();
		$no_iso = "Form/HRD/017-Rev.00";
        $id_karyawan = '';
        //var_dump($karyawan);
        foreach($karyawan as $k){
            if($id_cuti==$k['id_cuti']){
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
				Data Cuti berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data Cuti gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusCuti($id_cuti, $id_karyawan, $no_iso, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/cuti");
        }else{
            $this->LogoutAction();
        }
	}

	public function print($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		
		$this->load->library('dompdf_gen');
		$data['id'] = $id;
		$data['cuti'] = $this->m_data->getMasterCuti();
		$data['karyawan'] = $this->m_data->getMasterKaryawan();
		$view_id = "";
		foreach($data['cuti'] as $s)
		{
			if($s['id_cuti'] == $id)
			{
				$view_id = $s['view_id'];
			}
		}
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/cuti/print_cuti',$data);
        }else{
            $this->LogoutAction();
        }

		//DOMPDF
		// $paper_size = '';
		// $orientation = 'portrait';
		// $html = $this->output->get_output();
		// $this->dompdf->set_paper($paper_size, $orientation);


		// $view_id = "";
		// foreach($data['cuti'] as $s)
		// {
		// 	if($s['id_cuti'] == $id)
		// 	{
		// 		$view_id = $s['view_id'];
		// 	}
		// }
		// $nama_file = "Permohonan Cuti ".$view_id;

		// $this->dompdf->load_html($html);
		// $this->dompdf->render();
		// $this->dompdf->stream($nama_file.".pdf", array('Attachment' =>0));
	}

}
