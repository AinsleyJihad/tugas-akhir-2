<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
    class PhpspreadsheetController extends CI_Controller {
    public function __construct(){
        parent::__construct();
        $this->load->helper('form');
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

    public function index(){
        $this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
        $this->load->view('master/spreadsheet');
    }

    public function export(){
        $this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();
        $sheet->setCellValue('A1', 'Hello World !');
        $writer = new Xlsx($spreadsheet);
        $filename = 'name-of-the-generated-file';
        header('Content-Type: application/vnd.ms-excel');
        header('Content-Disposition: attachment;filename="'. $filename .'.xlsx"');
        header('Cache-Control: max-age=0');
        $writer->save('php://output'); // download file
    }

    public function import(){
        $this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
        //jadikkan array
        $file_mimes = array('text/x-comma-separated-values', 'text/comma-separated-values', 'application/octet-stream', 'application/vnd.ms-excel', 'application/x-csv', 'text/x-csv', 'text/csv', 'application/csv', 'application/excel', 'application/vnd.msexcel', 'text/plain', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        if(isset($_FILES['upload_file']['name']) && in_array($_FILES['upload_file']['type'], $file_mimes)) {
            $arr_file = explode('.', $_FILES['upload_file']['name']);
            $extension = end($arr_file);
            if('csv' == $extension){
                $reader = new PhpOffice\PhpSpreadsheet\Reader\Csv();
            } else {
                $reader = new PhpOffice\PhpSpreadsheet\Reader\Xlsx();
            }
            $spreadsheet = $reader->load($_FILES['upload_file']['tmp_name']);
            $sheetData = $spreadsheet->getActiveSheet()->toArray();
            $data['sheetData'] = $spreadsheet->getActiveSheet()->toArray();
            $plant = $_POST['plant'];
            //echo $plant;
            // end jadikkan array
            // print_r($sheetData);
            // $this->load->view('master/absensi/tampil_absensi', $data);
            
            // input ke database
            $seq = 0;
            foreach($sheetData as $row)
            {
                if($seq != 0)
                {
                    //ganti format tanggal dari DD/MM/YYYY ke YYYY-MM-DD
                    $tanggal = $row['3'];
                    $tanggal = substr($tanggal,6, 4)."-".substr($tanggal,3, 2)."-".substr($tanggal,0, 2);
                    //echo $tanggal."</br>";

                    //ID_ABSENSI
                    $highest_id = $this->m_data->getLastIdAbsensi($tanggal); //ambil id akhir pada tanggal $tanggal
                    $id_absensi = $highest_id[0]['MAX_ID']+1; //menambahkan id+1
                    $array_id_absensi = $this->m_data->getIdAbsensi($tanggal, $id_absensi); //jadikan format id YYYYMMDD(LPAD(ID, 8, "0"))
                    $id_absensi = $array_id_absensi[0]['id_absensi']; //ambil data id
                    
                    $pin = $row['0'];
                    $jam_absensi = $row['4'].":00";
                    $nama_mesin = $row['6'];
                    //echo $jam_absensi."</br>";

                    $pinA = $this->m_data->getIdKaryawanPin($pin, $plant);
                    $id_karyawan = $pinA[0]['id_karyawan'];

                    $status_absensi = "Y";
                    $change_by = (int)$this->session->userdata('id_user');
                    
                    $pinA = $this->m_data->getIdKaryawanPin($pin, $plant);
                    $id_karyawan = $pinA[0]['id_karyawan'];

                    //check data duplicate
                    $hasil_check_array = $this->m_data->checkAbsensi($id_karyawan, $tanggal, $jam_absensi);
                    $hasil_check = $hasil_check_array[0]['hasil'];
                    //echo "tanggal : ".$tanggal.", jam : ".$jam_absensi.", ".$hasil_check."</br>";
                    if($hasil_check == "N") //check apakah data sudah ada
                    {
                        //echo $id_absensi.", ".$id_karyawan.", ".$tanggal.", ".$jam_absensi.", ".$status_absensi.", ".$change_by.", ".date("Y-m-d")."</br>";
                        $data['fetch'] = $this->m_data->inputAbsensi($id_absensi, $id_karyawan, $tanggal, $jam_absensi, $status_absensi, $change_by, $nama_mesin);
                    }
                }
                $seq++;
            }
            $this->load->view('master/absensi/tampil_absensi', $data);
            
            
            /*
            echo "<pre>";
            echo "<table>";
            $seq = 1;
            foreach ($sheetData as $row) {
                echo "<tr>";
                echo "<td>".$seq."</td>";
                echo "<td>".$row['0']."</td>";
                echo "<td>".$row['1']."</td>";
                echo "<td>".$row['2']."</td>";
                echo "<td>".$row['3']."</td>";
                echo "<td>".$row['4']."</td>";
                echo "<td>".$row['5']."</td>";
                echo "<td>".$row['6']."</td>";
                echo "<td>".$row['7']."</td>";
                echo "<td>".$row['8']."</td>";
                echo "<td>".$row['9']."</td>";
                echo "<td>".$row['10']."</td>";
                echo "<td>".$row['11']."</td>";
                echo "<td>".$row['12']."</td>";
            
                echo "</tr>";
                $seq++;
                }
            echo "</table>";
            //print_r($sheetData);
            */
        }
    }  
        
    public function import_jadwal(){
        $this->login_asset_model->CheckLogin();
		$data = $this->CheckSessUser();
        //jadikkan array
        $file_mimes = array('text/x-comma-separated-values', 'text/comma-separated-values', 'application/octet-stream', 'application/vnd.ms-excel', 'application/x-csv', 'text/x-csv', 'text/csv', 'application/csv', 'application/excel', 'application/vnd.msexcel', 'text/plain', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        if(isset($_FILES['upload_file']['name']) && in_array($_FILES['upload_file']['type'], $file_mimes)) {
            $arr_file = explode('.', $_FILES['upload_file']['name']);
            $extension = end($arr_file);
            if('csv' == $extension){
                $reader = new PhpOffice\PhpSpreadsheet\Reader\Csv();
            } else {
                $reader = new PhpOffice\PhpSpreadsheet\Reader\Xlsx();
            }
            $spreadsheet = $reader->load($_FILES['upload_file']['tmp_name']);
            $sheetData = $spreadsheet->getActiveSheet()->toArray();
            $data['sheetData'] = $spreadsheet->getActiveSheet()->toArray();
        //end jadikkan array


            //print_r($sheetData);
            //$this->load->view('master/absensi/tampil_absensi', $data);
            
            //input ke database
            
            $seq = 0;
            foreach($sheetData as $row)
            {
                if($seq != 0)
                {
                    //ganti format tanggal dari DD/MM/YYYY ke YYYY-MM-DD
                    $tanggal = $row['3'];
                    //echo $tanggal."</br>";

                    //ID_ABSENSI
                    $highest_id = $this->m_data->getLastIdJadwalKerja(); //ambil id akhir pada tanggal $tanggal
                    $id_jadwal = $highest_id[0]['MAX_ID']+1; //menambahkan id+1
                    
                    $id_karyawan = $row['1'];
                    $id_karyawan = ltrim($id_karyawan,"OUT0");
                    $id_karyawan = ltrim($id_karyawan,"KAR0");

                    $id_jam_kerja = $row['2'];
                    $id_jam_kerja = ltrim($id_jam_kerja,"JMK0");
                    //echo $jam_absensi."</br>";

                    $status = "Y";
                    $change_by = (int)$this->session->userdata('id_user');
                    $reason = "Create";
                    
                    //check data duplicate
                    $hasil_check_array = $this->m_data->checkJadwal($id_karyawan, $tanggal);
                    $hasil_check = $hasil_check_array[0]['hasil'];
                    //echo "tanggal : ".$tanggal.", jam : ".$jam_absensi.", ".$hasil_check."</br>";
                    if($hasil_check == "N") //check apakah data sudah ada
                    {
                        //echo $id_absensi.", ".$id_karyawan.", ".$tanggal.", ".$jam_absensi.", ".$status_absensi.", ".$change_by.", ".date("Y-m-d")."</br>";
                        $data['fetch'] = $this->m_data->inputJadwalKerja($id_jadwal, $id_karyawan, $id_jam_kerja, $tanggal, $status, $change_by, $reason);
                    }
                }
                $seq++;
            }
            
            $this->load->view('master/jadwal_kerja/tampil_jadwal', $data);
            /*
            echo "<table>";
            $seq = 1;
            foreach ($sheetData as $row) {
                echo "<tr>";
                echo "<td>".$seq."</td>";
                echo "<td>".$row['0']."</td>";
                echo "<td>".$row['1']."</td>";
                echo "<td>".$row['2']."</td>";
                echo "<td>".$row['3']."</td>";
                echo "</tr>";
                $seq++;
                }
            echo "</table>";
            //print_r($sheetData);
            */
        }
    }  
}