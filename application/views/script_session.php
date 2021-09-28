public function __construct() {
        parent::__construct();
        $this->load->helper('url');
        //$this->load->model('asset_model');
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