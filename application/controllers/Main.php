<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class main extends CI_Controller {

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

	//Dashboard
	public function index()
	{
		$this->login_asset_model->CheckLogin();
		$this->CheckSessUser();
		$data['karyawan'] = $this->m_data->getTotalKaryawan(); 
        $data['ijin'] = $this->m_data->getTotalSuratIjin();
        $data['cuti'] = $this->m_data->getTotalCuti();
        $this->load->view('dashboard', $data);
	}

	//Master
	//Master_Absensi
	public function indexAbsensi()
	{
		$this->load->view('master/absensi/index_absensi');
	}

	
}
