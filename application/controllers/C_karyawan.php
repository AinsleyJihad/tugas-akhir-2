<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class c_karyawan extends CI_Controller {

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
		$id_user = $data['id_user']; 
        $data['fetch'] = $this->m_data->getMasterKaryawan(); 
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/karyawan/index_karyawan', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function input()
	{
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$data['jabatan'] = $this->m_data->getAllNamaJabatan();
		$data['divisi'] = $this->m_data->getAllNamaDivisi();
		//$data['shift'] = $this->m_data->getAllNamaDanShiftJamKerja();
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/karyawan/input_karyawan', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function save(){

		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		
		$highest_id = $this->m_data->getLastIdKaryawan();
		$auto_id = $highest_id[0]['MAX_ID']+1;
		$pin = $this->input->post('pin_karyawan');
		// $id_jabatan = $this->input->post('jabatan_karyawan');
		$id_jabatan = $this->input->post('nama_jabatan');
		//$id_divisi = $this->input->post('divisi_karyawan');
		$id_divisi = $this->input->post('nama_divisi');
		$nama_karyawan = $this->input->post('nama_karyawan');
		//$id_jam_kerja = $this->input->post('jam_kerja_karyawan');
		$nik = $this->input->post('nik_karyawan');
		$no_ktp = $this->input->post('ktp_karyawan');
		$npwp = $this->input->post('npwp_karyawan');
		$jenis_kelamin_karyawan = $this->input->post('jk_karyawan');
		//var_dump($jenis_kelamin_karyawan);
		$tanggal_masuk_karyawan = $this->input->post('tanggal_masuk_karyawan');
		$telp_karyawan = $this->input->post('telp_karyawan');
		$tempat_lahir_karyawan = $this->input->post('tempat_lahir_karyawan');
		$tanggal_lahir_karyawan = $this->input->post('tanggal_lahir_karyawan');
		$tanggal_pengangkatan = "";
		$keterangan = $this->input->post('jenis_karyawan');
		$alamat_karyawan = $this->input->post('alamat_karyawan');
		$k_tk = $this->input->post('kontrak_tidak_kontrak_karyawan');
		$pendidikan = $this->input->post('pendidikan_karyawan');
		$pkwt1 = $this->input->post('pkwt1_karyawan');
		$pkwt2 = $this->input->post('pkwt2_karyawan');
		$gaji_pokok = $this->input->post('gaji_pokok');
		$tunjangan_jabatan = $this->input->post('tunjangan_jabatan');
		$bpjs_kesehatan = $this->input->post('bpjs_kesehatan');
		$plant = $this->input->post('plant');
		$ikut_penggajian = $this->input->post('ikut_penggajian');
		$kawin_tdkkawin = $this->input->post('kawin_tdkkawin');

		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';

		if($gaji_pokok == ''){
			$gaji_pokok = 'NULL';
		}
		
		$hasil_check_array = $this->m_data->checkKaryawan($nama_karyawan, $id_jabatan, $id_divisi, $nik, $no_ktp, $tanggal_masuk_karyawan , $tunjangan_jabatan, $bpjs_kesehatan, $kawin_tdkkawin );
		$hasil_check = $hasil_check_array[0]['hasil'];
		if($hasil_check == "N")
		{
			$hasil_check_array = $this->m_data->checkPin($pin, $plant);
			$hasil_check1 = $hasil_check_array[0]['hasil'];
			if($hasil_check1 == 'N')
			{
				if($keterangan == "Karyawan")
				{ 
					$data['fetch'] = $this->m_data->inputKaryawan($auto_id, $pin, $id_jabatan, $id_divisi, $nama_karyawan,
							$nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $telp_karyawan,
							$tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $tanggal_pengangkatan,
							$keterangan, $k_tk, $pendidikan, $pkwt1, $pkwt2,$gaji_pokok,$tunjangan_jabatan,$bpjs_kesehatan, $plant,$ikut_penggajian,$kawin_tdkkawin, $status, $change_by, $reason);
				}
				else
				{
					$data['fetch'] = $this->m_data->inputKaryawanOutsourcing($auto_id, $pin, $id_jabatan, $id_divisi, $nama_karyawan,
							$nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $telp_karyawan,
							$tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $tanggal_pengangkatan,
							$keterangan, $k_tk, $pendidikan, $pkwt1, $pkwt2,$gaji_pokok,$tunjangan_jabatan,$bpjs_kesehatan, $plant,$ikut_penggajian,$kawin_tdkkawin, $status, $change_by, $reason);
				}
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-success alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-check"></i> Sukses!</h5>
					Data karyawan berhasil diinput.
				  </div>');
			}else{
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-danger alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
					Pin telah dipakai.
				</div>');
			}
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data karyawan sudah ada.
		  	</div>');
		}

		redirect("/karyawan/input");
	}

	public function edit($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$where = array('id_karyawan' => $id);
		$data['jabatan'] = $this->m_data->getAllNamaJabatan();
		$data['divisi'] = $this->m_data->getAllNamaDivisi();
		//$data['shift'] = $this->m_data->getAllNamaDanShiftJamKerja();
		$data['karyawan'] = $this->m_data->editKaryawan($where);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			$this->load->view('master/karyawan/edit_karyawan', $data);
        }else{
            $this->LogoutAction();
        }
	}

	public function edit_save($id){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_karyawan = $id;
		$pin = $this->input->post('pin');
		$id_jabatan = $this->input->post('id_jabatan');
		$nama_jabatan = $this->input->post('nama_jabatan');
		$id_divisi = $this->input->post('id_divisi');
		$nama_divisi = $this->input->post('nama_divisi');
		$nama_karyawan = $this->input->post('nama_karyawan');
		//$id_jam_kerja = $this->input->post('id_jam_kerja');
		$nik = $this->input->post('nik');
		$no_ktp = $this->input->post('no_ktp');
		$npwp = $this->input->post('npwp');
		$jenis_kelamin_karyawan = $this->input->post('jenis_kelamin_karyawan');
		$tanggal_masuk_karyawan = $this->input->post('tanggal_masuk_karyawan');
		$tanggal_keluar_karyawan = $this->input->post('tanggal_keluar_karyawan');
		$tanggal_pengangkatan = $this->input->post('tanggal_pengangkatan');
		$telp_karyawan = $this->input->post('telp_karyawan');
		$tempat_lahir_karyawan = $this->input->post('tempat_lahir_karyawan');
		$tanggal_lahir_karyawan = $this->input->post('tanggal_lahir_karyawan');
		$alamat_karyawan = $this->input->post('alamat_karyawan');
		$keterangan = $this->input->post('keterangan');
		$k_tk = $this->input->post('k_tk');
		$pendidikan = $this->input->post('pendidikan');
		$pkwt1 = $this->input->post('pkwt1');
		$pkwt2 = $this->input->post('pkwt2');
		$gaji_pokok = $this->input->post('gaji_pokok');
		$tunjangan_jabatan = $this->input->post('tunjangan_jabatan');
		$bpjs_kesehatan = $this->input->post('bpjs_kesehatan');
		$plant = $this->input->post('plant');
		$ikut_penggajian = $this->input->post('ikut_penggajian');
		$kawin_tdkkawin = $this->input->post('kawin_tdkkawin');

		$status_karyawan = $this->input->post('status_karyawan');
		$reason = "Edit";
		$change_by = (int)$this->session->userdata('id_user');
		if($gaji_pokok == ''){
			$gaji_pokok = 'NULL';
		}
		
		$hasil_check_array = $this->m_data->checkEditKaryawan($nama_karyawan, $id_jabatan, $id_divisi, $nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $tanggal_keluar_karyawan, $tanggal_pengangkatan, $telp_karyawan, $tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $pendidikan, $k_tk, $keterangan, $pkwt1, $pkwt2, $gaji_pokok, $tunjangan_jabatan, $bpjs_kesehatan, $plant, $ikut_penggajian, $kawin_tdkkawin, $status_karyawan);
		$hasil_check = $hasil_check_array[0]['hasil'];
		// echo $nama_karyawan;
		// echo "</br>";
		// echo $nama_jabatan;
		// echo "</br>";
		// echo $nama_divisi;
		// echo "</br>";
		// echo $nik;
		// echo "</br>";
		// echo $no_ktp;
		// echo "</br>";
		// echo $tanggal_masuk_karyawan;
		//echo $bpjs_kesehatan;
		if($hasil_check == "N") 
		{
			$hasil_check_array = $this->m_data->checkPinEdit($pin, $plant, $id);
			$hasil_check1 = $hasil_check_array[0]['hasil'];
			if($hasil_check1 == 'N')
			{
				$data['fetch'] = $this->m_data->editKaryawanSave($id_karyawan, $pin, $id_jabatan, $id_divisi, $nama_karyawan, $nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $tanggal_keluar_karyawan, $telp_karyawan, $tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $keterangan, $k_tk, $pendidikan, $pkwt1, $pkwt2, $gaji_pokok, $tunjangan_jabatan, $bpjs_kesehatan, $plant, $ikut_penggajian, $kawin_tdkkawin, $status_karyawan, $change_by, $reason, $tanggal_pengangkatan);
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-success alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-check"></i> Sukses!</h5>
					Data karyawan berhasil diedit.
				</div>');
				redirect("/karyawan");
			}else
			{
				$this->session->set_flashdata('msg', 
				'<div class="alert alert-danger alert-dismissible">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
					Pin telah dipakai.
					</div>');
				redirect("/karyawan/edit/".$id_karyawan);
			}
        }
        else 
		{
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data karyawan sudah ada.
		  	</div>');
			redirect("/karyawan/edit/".$id_karyawan);
		}
		
		
	}
	
	public function hapus(){
		$this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
		$id_karyawan = $this->input->post('id_karyawan');
		$karyawan = $this->m_data->getMasterKaryawan();
        $id_divisi = '';
		$id_jabatan = '';
        //var_dump($karyawan);
        foreach($karyawan as $k){
            if($id_karyawan==$k['id_karyawan']){
				$id_divisi = $k['id_divisi'];
				$id_jabatan = $k['id_jabatan'];
			}
              
        }
		$reason = "Hapus";
		$change_by = (int)$this->session->userdata('id_user');

		if ($data) {
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data karyawan berhasil dihapus.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data karyawan gagal dihapus.
		  	</div>');
		}
		$data['fetch'] = $this->m_data->hapusKaryawan($id_karyawan,$id_jabatan,$id_divisi, $change_by, $reason);
		if($_SESSION['role'] == '1' || $_SESSION['role'] == '2' ){ 
			redirect("/karyawan");
        }else{
            $this->LogoutAction();
        }
	}
}