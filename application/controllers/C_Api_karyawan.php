<?php

require APPPATH . '/libraries/REST_Controller.php';

class C_Api_karyawan extends REST_Controller {

    function __construct($config = 'rest') {
        parent::__construct($config);
        $this->load->database();
        $this->load->helper('url');
        $this->load->model('m_data');
        $this->load->model('login_asset_model');      
    }

    //show data karyawan
    // function index_get() {
    //     //$where = array('id_karyawan' => $id);
    //     $karyawan = $this->m_data->getMasterKaryawan();
    //     $this->response('$karyawan', 200);
    // }

    function index_get() {
        $id = $this->get('id');
        $where = array('id_karyawan' => $id);
        $karyawan = $this->m_data->getApiMasterKaryawan($id);
        $data['id'] = $where;
        $this->response($karyawan, 200);
    }

    // function get_k($id) {
    //     //$where = array('id_karyawan' => $id);
    //     $karyawan = $this->m_data->getApiMasterKaryawan($id);
    //     $this->response($karyawan, 200);
    // }

    // public function index_get($id = 0)
	// {
    //     if(!empty($id)){
    //         $data = $this->db->get_where("master_karyawan", ['id_karyawan' => $id_karyawan])->row_array();
    //     }else{
    //         $data = $this->db->get("master_karyawan")->result();
    //     }
     
    //     $this->response($data, REST_Controller::HTTP_OK);
	// }


    // insert karyawan
    public function index_post()
    {
        //$input = $this->input->post();
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

		$change_by = (int)$this->session->userdata('id_user');
		$reason = "Create";
		$status = 'Y';

		if($gaji_pokok == ''){
			$gaji_pokok = 'NULL';
		}
		
		$hasil_check_array = $this->m_data->checkKaryawan($nama_karyawan, $id_jabatan, $id_divisi, $nik, $no_ktp, $tanggal_masuk_karyawan);
		$hasil_check = $hasil_check_array[0]['hasil'];
		if($hasil_check == "N")
		{
			if($keterangan == "Karyawan"){
				$data['fetch'] = $this->m_data->inputKaryawan($auto_id, $pin, $id_jabatan, $id_divisi, $nama_karyawan,
						 $nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $telp_karyawan,
						$tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $tanggal_pengangkatan,
						$keterangan, $k_tk, $pendidikan, $pkwt1, $pkwt2,$gaji_pokok, $status, $change_by, $reason);
			}
			else{
				$data['fetch'] = $this->m_data->inputKaryawanOutsourcing($auto_id, $pin, $id_jabatan, $id_divisi, $nama_karyawan,
						 $nik, $no_ktp, $npwp, $jenis_kelamin_karyawan, $tanggal_masuk_karyawan, $telp_karyawan,
						$tempat_lahir_karyawan, $tanggal_lahir_karyawan, $alamat_karyawan, $tanggal_pengangkatan,
						$keterangan, $k_tk, $pendidikan, $pkwt1, $pkwt2,$gaji_pokok, $status, $change_by, $reason);
			}
            $this->session->set_flashdata('msg', 
			'<div class="alert alert-success alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-check"></i> Sukses!</h5>
				Data karyawan berhasil diinput.
		  	</div>');
        }
        else {
			$this->session->set_flashdata('msg', 
			'<div class="alert alert-danger alert-dismissible">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h5><i class="icon fas fa-ban"></i> Gagal!</h5>
				Data karyawan sudah ada.
		  	</div>');
		}
        
        $this->response($data, 200);
        
    } 

    // update data mahasiswa
    function index_put() {
        $nim = $this->put('nim');
        $data = array(
                    'nim'       => $this->put('nim'),
                    'nama'      => $this->put('nama'),
                    'id_jurusan'=> $this->put('id_jurusan'),
                    'alamat'    => $this->put('alamat'));
        $this->db->where('nim', $nim);
        $update = $this->db->update('mahasiswa', $data);
        if ($update) {
            $this->response($data, 200);
        } else {
            $this->response(array('status' => 'fail', 502));
        }
    }

    // delete mahasiswa
    function index_delete() {
        $nim = $this->delete('nim');
        $this->db->where('nim', $nim);
        $delete = $this->db->delete('mahasiswa');
        if ($delete) {
            $this->response(array('status' => 'success'), 201);
        } else {
            $this->response(array('status' => 'fail', 502));
        }
    }

}