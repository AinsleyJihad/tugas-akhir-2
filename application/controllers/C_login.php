<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class C_login extends CI_Controller {

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

	 // checking login session 
	 public function __construct() {
        parent::__construct();
        //$this->load->model('asset_model');
        $this->load->model('login_asset_model');        
    }        
    public function index() {
        $this->login();
    }

    public function login()
	{
		$this->load->view('login/login');
    }
    
    public function login_error()
	{
		$this->load->view('login/login_error');
	}
    
    public function LoginAction() {
        $mysqli = new mysqli("localhost","root","","payroll");
        $user = $this->input->post('user');
        $password = md5($this->input->post('password'));
        if ($user && $password) {
            $sql = "SELECT * FROM user_login WHERE username='".$user."' and password_user='".$password."' ";
            $result = mysqli_query($mysqli, $sql);
            $LoginAction = $this->login_asset_model->LoginAction($user, $password);
            if (mysqli_num_rows($result)==0) {
                redirect('login_error'); 
            }
            elseif ($LoginAction[0]['status'] == 'Y') {
                $data = array(
                    'user'=> $LoginAction[0]['username'],
                    'id_user'=> $LoginAction[0]['id_user'], 
                    'role'=> $LoginAction[0]['role']);                
                    $this->session->set_userdata($data);
                    redirect('main'); 
                    return TRUE;
                    
            }
            else {
                $this->session->sess_destroy();
                // redirect('auth');
                return FALSE;
                // exit;           
            }

        }

	}
	
	
}
