<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class login_asset_model extends CI_Model {

    public function __construct() {
        parent::__construct();
    }

    public function LoginAction($user, $password) {
        $sql = "SELECT * FROM user_login WHERE username='".$user."' and password_user='".$password."' ";
		$result=$this->db->query($sql)->result_array();
		return $result;
    }

    public function CheckLogin() {
        $user = $this->session->userdata('user');
        $id_user = $this->session->userdata('id_user');
        if(!isset($user) && !isset($nama_user)) {
                redirect('/');
                exit;
            }
    }

}