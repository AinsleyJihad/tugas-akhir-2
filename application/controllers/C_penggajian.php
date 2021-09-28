<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_penggajian extends CI_Controller {

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
		// $data['gaji'] = $this->m_data->getGaji(2021, 1);
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan(); 
		$data['umk'] = $this->m_data->getTahunUmk();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('penggajian/index_penggajian', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['umk'] = $this->m_data->getTahunUmk();
		$data['jabatan'] = $this->m_data->getAllJabatan();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('penggajian/input_penggajian', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function laporan()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_karyawan = $this->input->post('id_karyawan');
		$tahun = $this->input->post('tahun');
		$bulan = $this->input->post('bulan');
		$data['id_karyawan'] = $id_karyawan;
		$data['tahun'] = $tahun;
		$data['bulan'] = $bulan;
		$data['gaji'] = $this->m_data->getGaji($id_karyawan, $tahun, $bulan);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('penggajian/laporan_penggajian', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function tunjangan_keluarga()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();

		

		$id_karyawan = $this->input->post('id_karyawan_tunjangan_keluarga');
		$id = $this->input->post('id_tunjangan_keluarga');
		$tahun = $this->input->post('tahun_tunjangan_keluarga');
		$bulan = $this->input->post('bulan_tunjangan_keluarga');
		$tunjangan_keluarga = $this->input->post('tunjangan_keluarga');
		$change_by = (int)$this->session->userdata('id_user');
		$status = 'Y';
		$reason = 'Input Tunjangan Keluarga';

		$check =  $this->m_data->checkGaji($id_karyawan, $tahun, $bulan)[0]['hasil'];
		

		// echo 'id_gaji = '.$id_gaji.'<br>';
		// echo 'id_karyawan = '.$id_karyawan.'<br>';
		// echo 'tahun = '.$tahun.'<br>';
		// echo 'bulan = '.$bulan.'<br>';
		// echo 'tunjangan_keluarga = '.$tunjangan_keluarga.'<br>';
		// echo 'status = '.$status.'<br>';
		// echo 'reason = '.$reason.'<br>';
		// echo 'change_by = '.$change_by.'<br>';
		// echo 'check = '.$check.'<br>';
		

		if($check == 'N')
		{
			$highest_id = $this->m_data->getLastIdGaji();
			$id_gaji = $highest_id[0]['MAX_ID']+1;
			$data['fetch'] = $this->m_data->inputGajiTunjanganKeluarga($id_gaji, $id_karyawan, $tahun, $bulan, $tunjangan_keluarga, $status, $change_by, $reason);
		}
		else
		{
			$highest_id = $this->m_data->getWhereIdGaji($id_karyawan, $tahun, $bulan);
			$id_gaji = $highest_id[0]['MAX_ID'];
			$data['fetch'] = $this->m_data->editGajiTunjanganKeluarga($id_gaji, $id_karyawan, $tahun, $bulan, $tunjangan_keluarga, $status, $change_by, $reason);
		}

		$data['tahun'] = $tahun;
		$data['bulan'] = $bulan;
		$data['gaji'] = $this->m_data->getGaji($id, $tahun, $bulan);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('penggajian/laporan_penggajian', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function ongkos_bongkar()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();

		

		$id_karyawan = $this->input->post('id_karyawan_ongkos_bongkar');
		$id = $this->input->post('id_ongkos_bongkar');
		$tahun = $this->input->post('tahun_ongkos_bongkar');
		$bulan = $this->input->post('bulan_ongkos_bongkar');
		$ongkos_bongkar = $this->input->post('ongkos_bongkar');
		$change_by = (int)$this->session->userdata('id_user');
		$status = 'Y';
		$reason = 'Input Ongkos Bongkar';

		$check =  $this->m_data->checkGaji($id_karyawan, $tahun, $bulan)[0]['hasil'];
		

		// echo 'id_gaji = '.$id_gaji.'<br>';
		// echo 'id_karyawan = '.$id_karyawan.'<br>';
		// echo 'tahun = '.$tahun.'<br>';
		// echo 'bulan = '.$bulan.'<br>';
		// echo 'tunjangan_keluarga = '.$tunjangan_keluarga.'<br>';
		// echo 'status = '.$status.'<br>';
		// echo 'reason = '.$reason.'<br>';
		// echo 'change_by = '.$change_by.'<br>';
		// echo 'check = '.$check.'<br>';
		

		if($check == 'N')
		{
			$highest_id = $this->m_data->getLastIdGaji();
			$id_gaji = $highest_id[0]['MAX_ID']+1;
			$data['fetch'] = $this->m_data->inputGajiOngkosBongkar($id_gaji, $id_karyawan, $tahun, $bulan, $ongkos_bongkar, $status, $change_by, $reason);
		}
		else
		{
			$highest_id = $this->m_data->getWhereIdGaji($id_karyawan, $tahun, $bulan);
			$id_gaji = $highest_id[0]['MAX_ID'];
			$data['fetch'] = $this->m_data->editGajiOngkosBongkar($id_gaji, $id_karyawan, $tahun, $bulan, $ongkos_bongkar, $status, $change_by, $reason);
		}

		$data['tahun'] = $tahun;
		$data['bulan'] = $bulan;
		$data['gaji'] = $this->m_data->getGaji($id, $tahun, $bulan);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('penggajian/laporan_penggajian', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function ongkos_lain()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();

		

		$id_karyawan = $this->input->post('id_karyawan_ongkos_lain');
		$id = $this->input->post('id_ongkos_lain');
		$tahun = $this->input->post('tahun_ongkos_lain');
		$bulan = $this->input->post('bulan_ongkos_lain');
		$ongkos_lain = $this->input->post('ongkos_lain');
		$change_by = (int)$this->session->userdata('id_user');
		$status = 'Y';
		$reason = 'Input Ongkos Lain';

		$check =  $this->m_data->checkGaji($id_karyawan, $tahun, $bulan)[0]['hasil'];
		

		// echo 'id_gaji = '.$id_gaji.'<br>';
		// echo 'id_karyawan = '.$id_karyawan.'<br>';
		// echo 'tahun = '.$tahun.'<br>';
		// echo 'bulan = '.$bulan.'<br>';
		// echo 'tunjangan_keluarga = '.$tunjangan_keluarga.'<br>';
		// echo 'status = '.$status.'<br>';
		// echo 'reason = '.$reason.'<br>';
		// echo 'change_by = '.$change_by.'<br>';
		// echo 'check = '.$check.'<br>';
		

		if($check == 'N')
		{
			$highest_id = $this->m_data->getLastIdGaji();
			$id_gaji = $highest_id[0]['MAX_ID']+1;
			$data['fetch'] = $this->m_data->inputGajiOngkosLain($id_gaji, $id_karyawan, $tahun, $bulan, $ongkos_lain, $status, $change_by, $reason);
		}
		else
		{
			$highest_id = $this->m_data->getWhereIdGaji($id_karyawan, $tahun, $bulan);
			$id_gaji = $highest_id[0]['MAX_ID'];
			$data['fetch'] = $this->m_data->editGajiOngkosLain($id_gaji, $id_karyawan, $tahun, $bulan, $ongkos_lain, $status, $change_by, $reason);
		}

		$data['tahun'] = $tahun;
		$data['bulan'] = $bulan;
		$data['gaji'] = $this->m_data->getGaji($id, $tahun, $bulan);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('penggajian/laporan_penggajian', $data);
        }else{
            $this->LogoutAction();
        }
	}

	// public function potongAbsen()
	// {
	// 	$this->login_asset_model->CheckLogin();
	// 	$data = $this->CheckSessUser();
	// 	if(count($_POST)>0)
	// 	{
	// 		$id_karyawan = $_POST['id_karyawan'];
	// 		$tahun = $_POST['tahun'];
	// 		$bulan = $_POST['bulan'];
	// 		$data['fetch'] = $this->m_data->getPotongAbsen($id_karyawan, $tahun, $bulan);
	// 		echo json_encode($data['fetch']);
	// 	}
		
	// }

	public function totalLembur()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		if(count($_POST)>0)
		{
			$id_karyawan = $_POST['id_karyawan'];
			$tahun = $_POST['tahun'];
			$bulan = $_POST['bulan'];
			$data['fetch'] = $this->m_data->getGajiLembur($tahun, $bulan, $id_karyawan);
			echo json_encode($data['fetch']);
		}
		
	}

}
