<?php
defined('BASEPATH') OR exit('No direct script access allowed');

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Dompdf\Dompdf;
use Dompdf\Options;

class c_absensi extends CI_Controller {

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
		$this->load->helper('form');
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
        $data['fetch'] = $this->m_data->getMasterAbsensi();
        if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/absensi/index_absensi', $data);
        }else{
            $this->LogoutAction();
        }
        
	}

    public function pilih_laporan()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
        $id_user = $data['id_user']; 
        $data['karyawan'] = $this->m_data->getAllNamaKaryawan(); 
        $data['divisi'] = $this->m_data->getAllNamaDivisi(); 
        //print_r($data['fetch']);
        if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/absensi/pilih_laporan_absensi', $data);
        }else{
            $this->LogoutAction();
        }
	}

    public function laporan()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
        $id_user = $data['id_user'];
        $id_karyawan = $this->input->post('id_karyawan');
        $id_divisi = $this->input->post('id_divisi');
        $tanggal_awal = $this->input->post('tanggal_awal');
        $tanggal_akhir = $this->input->post('tanggal_akhir');
        $keterangan = $this->input->post('keterangan');
        /*
        echo "id_user = ".$id_user."</br>";
        echo "id_karyawan = ".$id_karyawan."</br>";
        echo "id_divisi = ".$id_divisi."</br>";
        echo "tanggal_awal = ".$tanggal_awal."</br>";
        echo "tanggal_akhir = ".$tanggal_akhir."</br>";
        */
        $data['karyawan'] = $this->m_data->getAllNamaKaryawan(); 
        $data['divisi'] = $this->m_data->getAllNamaDivisi(); 
        $data['surat_ijin'] = $this->m_data->getMasterIzin(); 
        $data['laporan'] = array($id_karyawan, $id_divisi, $tanggal_awal, $tanggal_akhir);
        $data['cuti'] = $this->m_data->getMasterCuti(); 
        $data['keterangan'] = $keterangan; 
        $data['fetch'] = $this->m_data->getMasterLaporanAbsensi($id_karyawan, $id_divisi, $tanggal_awal, $tanggal_akhir);
		//print_r($data['fetch']);
        if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/absensi/laporan_absensi', $data);
        }else{
            $this->LogoutAction();
        }   
	}

    public function laporan_semua()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
        $id_user = $data['id_user'];
        $id_karyawan = '0';
        $id_divisi = '0';
        $tanggal_awal = '1000-01-01';
        $tanggal_akhir = date("Y-m-d");
        $keterangan = '0';
        /*
        echo "id_user = ".$id_user."</br>";
        echo "id_karyawan = ".$id_karyawan."</br>";
        echo "id_divisi = ".$id_divisi."</br>";
        echo "tanggal_awal = ".$tanggal_awal."</br>";
        echo "tanggal_akhir = ".$tanggal_akhir."</br>";
        */
        
        $data['karyawan'] = $this->m_data->getAllNamaKaryawan(); 
        $data['divisi'] = $this->m_data->getAllNamaDivisi(); 
        $data['surat_ijin'] = $this->m_data->getMasterIzin(); 
        $data['laporan'] = array($id_karyawan, $id_divisi, $tanggal_awal, $tanggal_akhir);
        $data['cuti'] = $this->m_data->getMasterCuti(); 
        $data['keterangan'] = $keterangan; 
        $data['fetch'] = $this->m_data->getMasterLaporanAbsensi($id_karyawan, $id_divisi, $tanggal_awal, $tanggal_akhir);
		//print_r($data['fetch']);
        if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
		    $this->load->view('master/absensi/laporan_absensi', $data);
        }else{
            $this->LogoutAction();
        }  
	}

    public function save_absensi()
    {
        $this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
        $id_karyawan = $this->input->post('id_karyawan');
        $nama_mesin = "Edit";
        $status_absensi = "Y";
        $change_by = (int)$this->session->userdata('id_user');
        

        //masuk
        $tanggal_masuk = $this->input->post('tanggal_masuk');
        $jam_masuk = $this->input->post('jam_masuk');
        $highest_id_masuk = $this->m_data->getLastIdAbsensi($tanggal_masuk); //ambil id akhir pada tanggal $tanggal
        $id_absensi_masuk = $highest_id_masuk[0]['MAX_ID']+1; //menambahkan id+1
        $array_id_absensi_masuk = $this->m_data->getIdAbsensi($tanggal_masuk, $id_absensi_masuk); //jadikan format id YYYYMMDD(LPAD(ID, 8, "0"))
        $id_absensi_masuk = $array_id_absensi_masuk[0]['id_absensi']; //ambil data id
        //check masuk apakah data ada
        $hasil_check_array = $this->m_data->checkAbsensi($id_karyawan, $tanggal_masuk, $jam_masuk);
        $hasil_check_masuk = $hasil_check_array[0]['hasil'];
        //echo "tanggal : ".$tanggal.", jam : ".$jam_absensi.", ".$hasil_check."</br>";
        if($hasil_check_masuk == "N") //check apakah data sudah ada
        {
            //echo "Masuk </br>".$id_absensi_masuk.", ".$id_karyawan.", ".$tanggal_masuk.", ".$jam_masuk.", ".$status_absensi.", ".$change_by.", ".$nama_mesin.", ".date("Y-m-d")."</br>";
            $data['fetch'] = $this->m_data->inputAbsensi($id_absensi_masuk, $id_karyawan, $tanggal_masuk, $jam_masuk, $status_absensi, $change_by, $nama_mesin);
        }

        //pulang
        $tanggal_pulang = $this->input->post('tanggal_pulang');
        $jam_pulang = $this->input->post('jam_pulang');
        $highest_id_pulang = $this->m_data->getLastIdAbsensi($tanggal_pulang); //ambil id akhir pada tanggal $tanggal
        $id_absensi_pulang = $highest_id_pulang[0]['MAX_ID']+1; //menambahkan id+1
        $array_id_absensi_pulang = $this->m_data->getIdAbsensi($tanggal_pulang, $id_absensi_pulang); //jadikan format id YYYYMMDD(LPAD(ID, 8, "0"))
        $id_absensi_pulang = $array_id_absensi_pulang[0]['id_absensi']; //ambil data id
        //check masuk apakah data ada
        $hasil_check_array = $this->m_data->checkAbsensi($id_karyawan, $tanggal_pulang, $jam_pulang);
        $hasil_check_pulang = $hasil_check_array[0]['hasil'];
        //echo "tanggal : ".$tanggal.", jam : ".$jam_absensi.", ".$hasil_check."</br>";
        if($hasil_check_pulang == "N") //check apakah data sudah ada
        {
            //echo "Pulang </br>".$id_absensi_pulang.", ".$id_karyawan.", ".$tanggal_pulang.", ".$jam_pulang.", ".$status_absensi.", ".$change_by.", ".$nama_mesin.", ".date("Y-m-d")."</br>";
            $data['fetch'] = $this->m_data->inputAbsensi($id_absensi_pulang, $id_karyawan, $tanggal_pulang, $jam_pulang, $status_absensi, $change_by, $nama_mesin);
        }

        if ($hasil_check_masuk != "N" && $hasil_check_pulang != "N") {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-warning alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-exclamation"></i> Warning!</h5>
				Data Jadwal Masuk dan Jadwal Pulang Tidak diedit.
		  	</div>');
            
        }
        else if($hasil_check_masuk != "N" && $hasil_check_pulang == "N") {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-warning alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
              <h5><i class="icon fas fa-exclamation"></i> Warning!</h5>
              Data Jadwal Masuk Tidak diedit.
            </div>'
            .
            '<div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
            <h5><i class="icon fas fa-check"></i> Sukses!</h5>
            Data Jadwal Pulang Berhasil diedit.
            </div>');
		}
        else if($hasil_check_masuk == "N" && $hasil_check_pulang != "N") {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
            <h5><i class="icon fas fa-check"></i> Sukses!</h5>
            Data Jadwal Masuk Berhasil diedit.
            </div>'
            .
            '<div class="alert alert-warning alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
              <h5><i class="icon fas fa-exclamation"></i> Warning!</h5>
              Data Jadwal Pulang Tidak diedit.
            </div>'
            );
		}
        else{
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
            <h5><i class="icon fas fa-check"></i> Sukses!</h5>
            Data Jadwal Masuk dan Pulang Berhasil diedit.
            </div>'
            );
		}
        redirect("/absensi");
    }

    //DOMPDF
    public function print(){
        $this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		
		$this->load->library('dompdf_gen');
		$paper_size = 'A4';
		$orientation = 'portrait';
		$html = $this->output->get_output();
		$this->dompdf->set_paper($paper_size, $orientation);

		$view_id = "";
		$nama_file = "Laporan Absensi ".$view_id;

		$this->dompdf->load_html($html);
		$this->dompdf->render();
		$this->dompdf->stream($nama_file.".pdf", array('Attachment' =>0));
        $this->load->view('master/absensi/print_absensi',$data);
    }
}
