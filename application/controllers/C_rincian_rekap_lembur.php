<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_rincian_rekap_lembur extends CI_Controller {

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
        $data['karyawan'] = $this->m_data->getAllNamaKaryawan();
		$data['umk'] = $this->m_data->getTahunUmk();
		$data['jabatan'] = $this->m_data->getAllJabatan();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/rincian_rekap_lembur/index_rincian_rekap_lembur', $data);
        }else{
            $this->LogoutAction();
        }
	}

    public function pilih()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		//$id_surat_ijin = $data['id_surat_ijin']; 
        $id = $_POST['id_karyawan'];
        $tahun = $_POST['tahun'];
        $bulan = $_POST['bulan'];
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect('rincian_rekap_lembur/print/'.$id."/".$tahun."/".$bulan);
        }else{
            $this->LogoutAction();
        }
	}

	public function print($id, $tahun, $bulan){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		
		$this->load->library('dompdf_gen');
		$data['id'] = $id;
        $data['tahun'] = $tahun;
        $data['bulan'] = $bulan;
		$data['lembur'] = $this->m_data->getRincianLembur($id, $tahun, $bulan);
		$data['karyawan'] = $this->m_data->getMasterKaryawan();
		$data['umk'] = $this->m_data->getMasterUmk();
		foreach($data['karyawan'] as $s)
		{
			if($s['id_karyawan'] == $id)
			{
				$nama_karyawan = $s['nama_karyawan'];
			}
		}
		$data['nama_karyawan'] = $nama_karyawan;
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('transaksi/rincian_rekap_lembur/print_rincian_rekap_lembur',$data);
        }else{
            $this->LogoutAction();
        }

		// $paper_size = '';
		// $orientation = 'portrait';
		// $html = $this->output->get_output();
		// $this->dompdf->set_paper($paper_size, $orientation);


		// $nama_karyawan = "";
		// foreach($data['karyawan'] as $s)
		// {
		// 	if($s['id_karyawan'] == $id)
		// 	{
		// 		$nama_karyawan = $s['nama_karyawan'];
		// 	}
		// }
		// $nama_file = "Rincian Rekap Lembur ".$nama_karyawan." ".$tahun."-".$bulan;
		// $this->dompdf->load_html($html);
		// $this->dompdf->render();
		// $this->dompdf->stream($nama_file.".pdf", array('Attachment' =>0));
	}

}
