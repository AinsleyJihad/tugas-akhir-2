<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_history_absensi extends CI_Controller {

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
        //$this->load->model('asset_model');
        $this->load->model('login_asset_model');        
        // $this->login_asset_model->CheckLogin();
	}    

	//Dashboard
	public function index()
	{
		$this->load->view('history/history_absensi/index_history_absensi');
	}

}
