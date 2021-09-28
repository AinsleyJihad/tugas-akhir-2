<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Laporan Absensi</title>
  <!--  script header -->
  <?php $this->load->view('layout/script_header')?>
  <!--  /.script header -->
  
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

  <!-- Navbar -->
  <?php $this->load->view('layout/header')?>
  <!-- /.navbar -->

  <!-- Main Sidebar Container -->
  <?php $this->load->view('layout/sidebar')?>
  <!-- /. Main Sidebar Container -->

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Laporan Absensi</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/absensi">Absensi</a></li>
              <li class="breadcrumb-item active">Laporan</li>
            </ol>
          </div><!-- /.col -->
          <!-- /. Lokasi Halaman -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- MODAL1 -->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">New message</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <form action="<?php echo base_url('absensi/input/save')?>" method="post">
              <div class="card-body">
                  <input type="text" class="form-control" id="id_karyawan" name="id_karyawan" placeholder="Nama Karyawan" hidden>
                  <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">Divisi</label>
                          <input type="text" class="form-control" id="id_divisi" name="id_divisi" placeholder="Divisi" readonly>
                        </div>
                    </div>
                  </div>
                  <div class="form-group">
                      <div class="row">
                          <div class="col-6">
                              <label for="exampleInputEmail1">Tanggal masuk</label>
                              <input type="date" class="form-control" id="tanggal_masuk" name="tanggal_masuk" placeholder="Tanggal Masuk">
                          </div>
                          <div class="col-6">
                              <label for="exampleInputEmail1">Jam Masuk</label>
                              <input type="time" class="form-control" id="jam_masuk" name="jam_masuk" placeholder="Jam Masuk" value="07:00" required>
                          </div>
                      </div>
                  </div>
                  <div class="form-group">
                      <div class="row">
                          <div class="col-6">
                              <label for="exampleInputEmail1">Tanggal pulang</label>
                              <input type="date" class="form-control" id="tanggal_pulang" name="tanggal_pulang" placeholder="Tanggal Pulang">
                          </div>
                          <div class="col-6">
                              <label for="exampleInputEmail1">Jam Pulang</label>
                              <input type="time" class="form-control" id="jam_pulang" name="jam_pulang" placeholder="Jam Pulang" value="15:00" required>
                          </div>
                      </div>
                  </div>
              </div>
            
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Edit</button>
          </div>
          </form>
        </div>
      </div>
    </div>
    <!-- End Modal -->

    <!-- MODAL2 -->
    <div class="modal fade" id="exampleModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">New message</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
              <div class="card-body">
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">ID Surat Ijin</label>
                          <input type="text" class="form-control" id="id_surat_ijin" name="id_surat_ijin" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">Tanggal Ijin</label>
                          <input type="text" class="form-control" id="tanggal" name="tanggal" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">Alasan Ijin</label>
                          <input type="text" class="form-control" id="alasan_ijin" name="alasan_ijin" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">Jam Datang / Keluar Ijin</label>
                          <input type="text" class="form-control" id="jam_datang_keluar_ijin" name="jam_datang_keluar_ijin" readonly>
                        </div>
                    </div>
                </div>
                  
              </div>
            
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <!-- End Modal -->

    <!-- MODAL3 -->
    <div class="modal fade" id="exampleModal3" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">New message</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
              <div class="card-body">
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">ID Cuti</label>
                          <input type="text" class="form-control" id="c_id_cuti" name="c_id_cuti" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">Nama Karyawan</label>
                          <input type="text" class="form-control" id="c_nama_karyawan" name="c_nama_karyawan" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">Nama Divisi</label>
                          <input type="text" class="form-control" id="c_divisi" name="c_divisi" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-6">
                          <label for="exampleInputEmail1">Tanggal Mulai Cuti</label>
                          <input type="text" class="form-control" id="c_tanggal_mulai" name="c_tanggal_mulai" readonly>
                        </div>
                        <div class="col-6">
                          <label for="exampleInputEmail1">Tanggal Akhir Cuti</label>
                          <input type="text" class="form-control" id="c_tanggal_akhir" name="c_tanggal_akhir" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">Ambil Cuti</label>
                          <input type="text" class="form-control" id="c_ambil_cuti" name="c_ambil_cuti" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-12">
                          <label for="exampleInputEmail1">Alasan Cuti</label>
                          <input type="text" class="form-control" id="c_alasan_cuti" name="c_alasan_cuti" readonly>
                        </div>
                    </div>
                </div>
                
                  
              </div>
            
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <!-- End Modal -->

    <!-- Main content -->
    <section class="content">
      <div class="container-fluid">
        <div class="row">
          <div class="col-12">

            <div class="card">
              <div class="card-header">
                <div class="row">
                  <div class="col-6">
                    <h5>  <?php 
                            if($laporan[2]=="1000-01-01" && $laporan[3]==date('Y-m-d'))
                            {
                              echo "<b>Nama Karyawan :</b> Semua</br>";
                              echo "<b>Nama Divisi :</b> Semua</br>";
                              echo "<b>Tanggal :</b> Semua</br>";
                            }
                            else{
                              if($laporan[0] == '0')
                              {
                                  echo "<b>Nama Karyawan :</b> Semua</br>";
                              }
                              else
                              {
                                foreach($karyawan as $k)
                                {
                                  if($k['id_karyawan'] == $laporan[0])
                                    echo "<b>Nama Karyawan :</b> ".$k['nama_karyawan']."</br>";
                                }
                              }

                              if($laporan[1] == '0')
                              {
                                  echo "<b>Nama Divisi :</b> Semua</br>";
                              }
                              else
                              {
                                foreach($divisi as $d)
                                {
                                  if($d['id_divisi'] == $laporan[1])
                                    echo "<b>Nama Divisi :</b> ".$d['nama_divisi']."</br>";
                                }
                              }

                              echo "<b>Tanggal :</b> ".date("d/m/Y", strtotime($laporan[2]))." - ".date("d/m/Y", strtotime($laporan[3]))."</br>";
                            }
                          ?>
                    </h5>
                  </div>
                  <div class="col-6">
                  <div class="kolom">
                    <div class='box red'></div>
                      <span>= Terlambat / pulang terlalu cepat</span>
                    </div>

                    <div class="kolom">
                      <div class='box yellow'></div>
                      <span>= Data absensi ada yang kurang</span>
                    </div>

                    <div class="kolom">
                      <div class='box green'></div>
                      <span>= Ada surat ijin / Cuti</span>
                    </div>

                    <div class="kolom">
                      <div class='box blue'></div>
                      <span>= Hari Libur / Cuti Bersama</span>
                    </div>
                </div>
                <div class="col-1">
                    <a href="/payroll/absensi/print"><button type="button" class="btn btn-block btn-success"><i class="fas fa-print"></i>  Print </button></a>
                </div>
                
                
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr style='vertical-align: middle; text-align: center;'>
                    <th>No</th>
                    <th>Nama Karyawan</th>
                    <th>Divisi</th>
                    <th>Jabatan</th>
                    <th>Plant</th>
                    <th>Tanggal Absensi</th>
                    <th>Jam Masuk</th>
                    <th>Jam Pulang</th>
                    <th>Status /</br>Alasan Ijin</th>
                    <th>Aksi</th>
                  </tr>
                  </thead>
                  <tbody>
                  <?php 
                    $seq = 1;
                    $seq2 = 1;
                    foreach ($fetch as $row) {
                      if($keterangan == 0){
                        $text = $row['nama_karyawan'];
                      if($row['id_surat_ijin'] != "N" || $row['status'] == "Cuti")
                        echo "<tr style='background-color: #80ffaa'>";
                      elseif($row['status'] == "-")
                        echo "<tr>";
                      elseif($row['status'] == "Data Absensi Ada Yang Kurang")
                        echo "<tr style='background-color: #ffff66'>";
                      elseif($row['status'] == "Hari Libur" || $row['status'] == "Cuti Bersama")
                        echo "<tr style='background-color: #6666ff'>";
                      else
                        echo "<tr style='background-color: #ff6666'>";

                        echo "<td style='vertical-align: middle; text-align: center;'>".$seq2."</td>";
                        $seq2++;
                        echo "<td style='vertical-align: middle;'>".$row['nama_karyawan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_divisi']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_jabatan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['plant']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['tanggal_jadwal']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_masuk']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_pulang']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['status']."</td>";
                        if($row['status'] == "Data Absensi Ada Yang Kurang")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                  data-whatever="'.$text.'" 
                                  data-id="'.$row['id_karyawan'].'" 
                                  data-nama_karyawan="'.$row['nama_karyawan'].'" 
                                  data-id_divisi="'.$row['id_divisi'].'"
                                  data-nama_divisi="'.$row['nama_divisi'].'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-jam_masuk="'.$row['jam_masuk'].'" 
                                  data-jam_pulang="'.$row['jam_pulang'].'"
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <i class="fas fa-edit"></i>  Edit</button></a>
                                </td>';
                        }
                        elseif($row['id_surat_ijin'] != "N")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal2" 
                                  data-whatever="'.$text.'" 
                                  data-id_surat_ijin="'.("IZN".str_pad($row['id_surat_ijin'],8,"0",STR_PAD_LEFT)).'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-alasan_ijin="'.$row['status'].'" 
                                  data-jam_datang_keluar_ijin="'.$row['jam_datang_keluar_ijin'].'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Ijin</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                        }
                        elseif($row['status'] == "Cuti")
                        {
                          $c_id_cuti = "";
                          $c_nama_karyawan = "";
                          $c_divisi = "";
                          $c_tahun_cuti = "";
                          $c_tanggal_mulai = "";
                          $c_tanggal_akhir = "";
                          $c_ambil_cuti = "";
                          $c_alasan_cuti = "";
                          foreach($cuti as $c)
                          {
                            if($row['status_cuti'] == $c['id_cuti'])
                            {
                              $c_id_cuti = $c['id_cuti'];
                              $c_nama_karyawan = $c['nama_karyawan'];
                              $c_divisi = $c['nama_divisi'];
                              $c_tahun_cuti = $c['tahun_cuti'];
                              $c_tanggal_mulai = $c['tanggal_mulai_cuti'];
                              $c_tanggal_akhir = $c['tanggal_akhir_cuti'];
                              $c_ambil_cuti = $c['ambil_cuti'];
                              $c_alasan_cuti = $c['alasan_cuti'];
                            }
                          }
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal3" 
                                  data-whatever="'.$text.'" 
                                  data-c_id_cuti="'.("CUT".str_pad($c_id_cuti,8,"0",STR_PAD_LEFT)).'" 
                                  data-c_nama_karyawan="'.$c_nama_karyawan.'" 
                                  data-c_divisi="'.$c_divisi.'" 
                                  data-c_tahun_cuti="'.$c_tahun_cuti.'" 
                                  data-c_tanggal_mulai="'.$c_tanggal_mulai.'" 
                                  data-c_tanggal_akhir="'.$c_tanggal_akhir.'" 
                                  data-c_ambil_cuti="'.$c_ambil_cuti.'" 
                                  data-c_alasan_cuti="'.$c_alasan_cuti.'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Cuti</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                        }
                        else
                        {
                          echo '<td></td>';
                        }
                      }elseif($keterangan == 1 && $row['status'] == "Terlambat"){
                        $text = $row['nama_karyawan'];
                      if($row['id_surat_ijin'] != "N" || $row['status'] == "Cuti")
                        echo "<tr style='background-color: #80ffaa'>";
                      elseif($row['status'] == "-")
                        echo "<tr>";
                      elseif($row['status'] == "Data Absensi Ada Yang Kurang")
                        echo "<tr style='background-color: #ffff66'>";
                      elseif($row['status'] == "Hari Libur" || $row['status'] == "Cuti Bersama")
                        echo "<tr style='background-color: #6666ff'>";
                      else
                        echo "<tr style='background-color: #ff6666'>";

                        echo "<td style='vertical-align: middle; text-align: center;'>".$seq2."</td>";
                        $seq2++;
                        echo "<td style='vertical-align: middle;'>".$row['nama_karyawan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_divisi']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_jabatan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['plant']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['tanggal_jadwal']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_masuk']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_pulang']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['status']."</td>";
                        if($row['status'] == "Data Absensi Ada Yang Kurang")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                  data-whatever="'.$text.'" 
                                  data-id="'.$row['id_karyawan'].'" 
                                  data-nama_karyawan="'.$row['nama_karyawan'].'" 
                                  data-id_divisi="'.$row['id_divisi'].'"
                                  data-nama_divisi="'.$row['nama_divisi'].'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-jam_masuk="'.$row['jam_masuk'].'" 
                                  data-jam_pulang="'.$row['jam_pulang'].'"
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <i class="fas fa-edit"></i>  Edit</button></a>
                                </td>';
                        }
                        elseif($row['id_surat_ijin'] != "N")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal2" 
                                  data-whatever="'.$text.'" 
                                  data-id_surat_ijin="'.("IZN".str_pad($row['id_surat_ijin'],8,"0",STR_PAD_LEFT)).'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-alasan_ijin="'.$row['status'].'" 
                                  data-jam_datang_keluar_ijin="'.$row['jam_datang_keluar_ijin'].'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Ijin</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                        }
                        elseif($row['status'] == "Cuti")
                        {
                          $c_id_cuti = "";
                          $c_nama_karyawan = "";
                          $c_divisi = "";
                          $c_tahun_cuti = "";
                          $c_tanggal_mulai = "";
                          $c_tanggal_akhir = "";
                          $c_ambil_cuti = "";
                          $c_alasan_cuti = "";
                          foreach($cuti as $c)
                          {
                            if($row['status_cuti'] == $c['id_cuti'])
                            {
                              $c_id_cuti = $c['id_cuti'];
                              $c_nama_karyawan = $c['nama_karyawan'];
                              $c_divisi = $c['nama_divisi'];
                              $c_tahun_cuti = $c['tahun_cuti'];
                              $c_tanggal_mulai = $c['tanggal_mulai_cuti'];
                              $c_tanggal_akhir = $c['tanggal_akhir_cuti'];
                              $c_ambil_cuti = $c['ambil_cuti'];
                              $c_alasan_cuti = $c['alasan_cuti'];
                            }
                          }
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal3" 
                                  data-whatever="'.$text.'" 
                                  data-c_id_cuti="'.("CUT".str_pad($c_id_cuti,8,"0",STR_PAD_LEFT)).'" 
                                  data-c_nama_karyawan="'.$c_nama_karyawan.'" 
                                  data-c_divisi="'.$c_divisi.'" 
                                  data-c_tahun_cuti="'.$c_tahun_cuti.'" 
                                  data-c_tanggal_mulai="'.$c_tanggal_mulai.'" 
                                  data-c_tanggal_akhir="'.$c_tanggal_akhir.'" 
                                  data-c_ambil_cuti="'.$c_ambil_cuti.'" 
                                  data-c_alasan_cuti="'.$c_alasan_cuti.'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Cuti</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                        }
                        else
                        {
                          echo '<td></td>';
                        }
                      }elseif($keterangan == 2 && $row['status'] == "Pulang Terlalu Cepat" ){
                        $text = $row['nama_karyawan'];
                      if($row['id_surat_ijin'] != "N" || $row['status'] == "Cuti")
                        echo "<tr style='background-color: #80ffaa'>";
                      elseif($row['status'] == "-")
                        echo "<tr>";
                      elseif($row['status'] == "Data Absensi Ada Yang Kurang")
                        echo "<tr style='background-color: #ffff66'>";
                      elseif($row['status'] == "Hari Libur" || $row['status'] == "Cuti Bersama")
                        echo "<tr style='background-color: #6666ff'>";
                      else
                        echo "<tr style='background-color: #ff6666'>";

                        echo "<td style='vertical-align: middle; text-align: center;'>".$seq2."</td>";
                        $seq2++;
                        echo "<td style='vertical-align: middle;'>".$row['nama_karyawan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_divisi']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_jabatan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['plant']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['tanggal_jadwal']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_masuk']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_pulang']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['status']."</td>";
                        if($row['status'] == "Data Absensi Ada Yang Kurang")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                  data-whatever="'.$text.'" 
                                  data-id="'.$row['id_karyawan'].'" 
                                  data-nama_karyawan="'.$row['nama_karyawan'].'" 
                                  data-id_divisi="'.$row['id_divisi'].'"
                                  data-nama_divisi="'.$row['nama_divisi'].'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-jam_masuk="'.$row['jam_masuk'].'" 
                                  data-jam_pulang="'.$row['jam_pulang'].'"
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <i class="fas fa-edit"></i>  Edit</button></a>
                                </td>';
                        }
                        elseif($row['id_surat_ijin'] != "N")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal2" 
                                  data-whatever="'.$text.'" 
                                  data-id_surat_ijin="'.("IZN".str_pad($row['id_surat_ijin'],8,"0",STR_PAD_LEFT)).'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-alasan_ijin="'.$row['status'].'" 
                                  data-jam_datang_keluar_ijin="'.$row['jam_datang_keluar_ijin'].'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Ijin</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                        }
                        elseif($row['status'] == "Cuti")
                        {
                          $c_id_cuti = "";
                          $c_nama_karyawan = "";
                          $c_divisi = "";
                          $c_tahun_cuti = "";
                          $c_tanggal_mulai = "";
                          $c_tanggal_akhir = "";
                          $c_ambil_cuti = "";
                          $c_alasan_cuti = "";
                          foreach($cuti as $c)
                          {
                            if($row['status_cuti'] == $c['id_cuti'])
                            {
                              $c_id_cuti = $c['id_cuti'];
                              $c_nama_karyawan = $c['nama_karyawan'];
                              $c_divisi = $c['nama_divisi'];
                              $c_tahun_cuti = $c['tahun_cuti'];
                              $c_tanggal_mulai = $c['tanggal_mulai_cuti'];
                              $c_tanggal_akhir = $c['tanggal_akhir_cuti'];
                              $c_ambil_cuti = $c['ambil_cuti'];
                              $c_alasan_cuti = $c['alasan_cuti'];
                            }
                          }
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal3" 
                                  data-whatever="'.$text.'" 
                                  data-c_id_cuti="'.("CUT".str_pad($c_id_cuti,8,"0",STR_PAD_LEFT)).'" 
                                  data-c_nama_karyawan="'.$c_nama_karyawan.'" 
                                  data-c_divisi="'.$c_divisi.'" 
                                  data-c_tahun_cuti="'.$c_tahun_cuti.'" 
                                  data-c_tanggal_mulai="'.$c_tanggal_mulai.'" 
                                  data-c_tanggal_akhir="'.$c_tanggal_akhir.'" 
                                  data-c_ambil_cuti="'.$c_ambil_cuti.'" 
                                  data-c_alasan_cuti="'.$c_alasan_cuti.'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Cuti</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                        }
                        else
                        {
                          echo '<td></td>';
                        }
                      }elseif($keterangan == 3 && $row['id_surat_ijin'] != "N"){
                        $text = $row['nama_karyawan'];
                      if($row['id_surat_ijin'] != "N" || $row['status'] == "Cuti")
                        echo "<tr style='background-color: #80ffaa'>";
                      elseif($row['status'] == "-")
                        echo "<tr>";
                      elseif($row['status'] == "Data Absensi Ada Yang Kurang")
                        echo "<tr style='background-color: #ffff66'>";
                      elseif($row['status'] == "Hari Libur" || $row['status'] == "Cuti Bersama")
                        echo "<tr style='background-color: #6666ff'>";
                      else
                        echo "<tr style='background-color: #ff6666'>";

                        echo "<td style='vertical-align: middle; text-align: center;'>".$seq2."</td>";
                        $seq2++;
                        echo "<td style='vertical-align: middle;'>".$row['nama_karyawan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_divisi']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_jabatan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['plant']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['tanggal_jadwal']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_masuk']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_pulang']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['status']."</td>";
                        if($row['status'] == "Data Absensi Ada Yang Kurang")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                  data-whatever="'.$text.'" 
                                  data-id="'.$row['id_karyawan'].'" 
                                  data-nama_karyawan="'.$row['nama_karyawan'].'" 
                                  data-id_divisi="'.$row['id_divisi'].'"
                                  data-nama_divisi="'.$row['nama_divisi'].'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-jam_masuk="'.$row['jam_masuk'].'" 
                                  data-jam_pulang="'.$row['jam_pulang'].'"
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <i class="fas fa-edit"></i>  Edit</button></a>
                                </td>';
                        }
                        elseif($row['id_surat_ijin'] != "N")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal2" 
                                  data-whatever="'.$text.'" 
                                  data-id_surat_ijin="'.("IZN".str_pad($row['id_surat_ijin'],8,"0",STR_PAD_LEFT)).'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-alasan_ijin="'.$row['status'].'" 
                                  data-jam_datang_keluar_ijin="'.$row['jam_datang_keluar_ijin'].'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Ijin</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                        }
                        elseif($row['status'] == "Cuti")
                        {
                          $c_id_cuti = "";
                          $c_nama_karyawan = "";
                          $c_divisi = "";
                          $c_tahun_cuti = "";
                          $c_tanggal_mulai = "";
                          $c_tanggal_akhir = "";
                          $c_ambil_cuti = "";
                          $c_alasan_cuti = "";
                          foreach($cuti as $c)
                          {
                            if($row['status_cuti'] == $c['id_cuti'])
                            {
                              $c_id_cuti = $c['id_cuti'];
                              $c_nama_karyawan = $c['nama_karyawan'];
                              $c_divisi = $c['nama_divisi'];
                              $c_tahun_cuti = $c['tahun_cuti'];
                              $c_tanggal_mulai = $c['tanggal_mulai_cuti'];
                              $c_tanggal_akhir = $c['tanggal_akhir_cuti'];
                              $c_ambil_cuti = $c['ambil_cuti'];
                              $c_alasan_cuti = $c['alasan_cuti'];
                            }
                          }
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal3" 
                                  data-whatever="'.$text.'" 
                                  data-c_id_cuti="'.("CUT".str_pad($c_id_cuti,8,"0",STR_PAD_LEFT)).'" 
                                  data-c_nama_karyawan="'.$c_nama_karyawan.'" 
                                  data-c_divisi="'.$c_divisi.'" 
                                  data-c_tahun_cuti="'.$c_tahun_cuti.'" 
                                  data-c_tanggal_mulai="'.$c_tanggal_mulai.'" 
                                  data-c_tanggal_akhir="'.$c_tanggal_akhir.'" 
                                  data-c_ambil_cuti="'.$c_ambil_cuti.'" 
                                  data-c_alasan_cuti="'.$c_alasan_cuti.'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Cuti</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                                
                        }
                        else
                        {
                          echo '<td></td>';
                        }
                      }elseif($keterangan == 4 && $row['status'] == "Cuti"){
                        $text = $row['nama_karyawan'];
                      if($row['id_surat_ijin'] != "N" || $row['status'] == "Cuti")
                        echo "<tr style='background-color: #80ffaa'>";
                      elseif($row['status'] == "-")
                        echo "<tr>";
                      elseif($row['status'] == "Data Absensi Ada Yang Kurang")
                        echo "<tr style='background-color: #ffff66'>";
                      elseif($row['status'] == "Hari Libur" || $row['status'] == "Cuti Bersama")
                        echo "<tr style='background-color: #6666ff'>";
                      else
                        echo "<tr style='background-color: #ff6666'>";

                        echo "<td style='vertical-align: middle; text-align: center;'>".$seq2."</td>";
                        $seq2++;
                        echo "<td style='vertical-align: middle;'>".$row['nama_karyawan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_divisi']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['nama_jabatan']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['plant']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['tanggal_jadwal']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_masuk']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['jam_pulang']."</td>";
                        echo "<td style='vertical-align: middle; text-align: center;'>".$row['status']."</td>";
                        if($row['status'] == "Data Absensi Ada Yang Kurang")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                  data-whatever="'.$text.'" 
                                  data-id="'.$row['id_karyawan'].'" 
                                  data-nama_karyawan="'.$row['nama_karyawan'].'" 
                                  data-id_divisi="'.$row['id_divisi'].'"
                                  data-nama_divisi="'.$row['nama_divisi'].'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-jam_masuk="'.$row['jam_masuk'].'" 
                                  data-jam_pulang="'.$row['jam_pulang'].'"
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <i class="fas fa-edit"></i>  Edit</button></a>
                                </td>';
                        }
                        elseif($row['id_surat_ijin'] != "N")
                        {
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal2" 
                                  data-whatever="'.$text.'" 
                                  data-id_surat_ijin="'.("IZN".str_pad($row['id_surat_ijin'],8,"0",STR_PAD_LEFT)).'" 
                                  data-tanggal="'.$row['tanggal_jadwal'].'" 
                                  data-alasan_ijin="'.$row['status'].'" 
                                  data-jam_datang_keluar_ijin="'.$row['jam_datang_keluar_ijin'].'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Ijin</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                        }
                        elseif($row['status'] == "Cuti")
                        {
                          $c_id_cuti = "";
                          $c_nama_karyawan = "";
                          $c_divisi = "";
                          $c_tahun_cuti = "";
                          $c_tanggal_mulai = "";
                          $c_tanggal_akhir = "";
                          $c_ambil_cuti = "";
                          $c_alasan_cuti = "";
                          foreach($cuti as $c)
                          {
                            if($row['status_cuti'] == $c['id_cuti'])
                            {
                              $c_id_cuti = $c['id_cuti'];
                              $c_nama_karyawan = $c['nama_karyawan'];
                              $c_divisi = $c['nama_divisi'];
                              $c_tahun_cuti = $c['tahun_cuti'];
                              $c_tanggal_mulai = $c['tanggal_mulai_cuti'];
                              $c_tanggal_akhir = $c['tanggal_akhir_cuti'];
                              $c_ambil_cuti = $c['ambil_cuti'];
                              $c_alasan_cuti = $c['alasan_cuti'];
                            }
                          }
                          echo '<td style="vertical-align: middle;">
                                  <a href="" data-toggle="modal" data-target="#exampleModal3" 
                                  data-whatever="'.$text.'" 
                                  data-c_id_cuti="'.("CUT".str_pad($c_id_cuti,8,"0",STR_PAD_LEFT)).'" 
                                  data-c_nama_karyawan="'.$c_nama_karyawan.'" 
                                  data-c_divisi="'.$c_divisi.'" 
                                  data-c_tahun_cuti="'.$c_tahun_cuti.'" 
                                  data-c_tanggal_mulai="'.$c_tanggal_mulai.'" 
                                  data-c_tanggal_akhir="'.$c_tanggal_akhir.'" 
                                  data-c_ambil_cuti="'.$c_ambil_cuti.'" 
                                  data-c_alasan_cuti="'.$c_alasan_cuti.'" 
                                  ><button type="button" class="btn btn-block btn-primary">
                                  <div class="row">
                                    <div class="col-12">
                                      <i class="fas fa-file-alt fa-lg"></i>
                                    </div>
                                    <div class="col-12">
                                      Surat Cuti</button>
                                    </div>
                                  </div>
                                  </a>
                                </td>';
                                
                        }
                        else
                        {
                          echo '<td></td>';
                        }
                      }
                      
                      echo "</tr>";
                      $seq++;
                    }
                  ?>
                  </tbody>
                </table>
              </div>
              <!-- /.card-body -->
            </div>
            <!-- /.card -->
          </div>
          <!-- /.col -->
        </div>
        <!-- /.row -->
      </div>
      <!-- /.container-fluid -->
    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

  <!-- footer -->
  <?php $this->load->view('layout/footer')?>
  <!-- footer -->

  <script>
  $(function () {
    $("#example1").DataTable({
      "responsive": true, "lengthChange": true, "autoWidth": false,
      "buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"]
    }).buttons().container().appendTo('#example1_wrapper .col-md-6:eq(0)');
    $('#example2').DataTable({
      "paging": true,
      "lengthChange": false,
      "searching": false,
      "ordering": true,
      "info": true,
      "autoWidth": false,
      "responsive": true,
    });
  });
</script>

<script>
  $('#exampleModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var recipient = button.data('whatever') // Extract info from data-* attributes
    var id_karyawan = button.data('id')
    var nama_divisi = button.data('nama_divisi')
    var tanggal = button.data('tanggal')
    var jam_masuk = button.data('jam_masuk')
    var jam_pulang = button.data('jam_pulang')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Edit Laporan Absensi ' + recipient)
    modal.find('#id_karyawan').val(id_karyawan)
    modal.find('#id_divisi').val(nama_divisi)
    modal.find('#tanggal_masuk').val(tanggal)
    modal.find('#tanggal_pulang').val(tanggal)
    modal.find('#jam_masuk').val(jam_masuk)
    modal.find('#jam_pulang').val(jam_pulang)
  })
</script>

<script>
  $('#exampleModal2').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var recipient = button.data('whatever') // Extract info from data-* attributes
    var id_surat_ijin = button.data('id_surat_ijin')
    var tanggal = button.data('tanggal')
    var alasan_ijin = button.data('alasan_ijin')
    var jam_datang_keluar_ijin = button.data('jam_datang_keluar_ijin')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Surat Ijin ' + recipient)
    modal.find('#id_surat_ijin').val(id_surat_ijin)
    modal.find('#tanggal').val(tanggal)
    modal.find('#alasan_ijin').val(alasan_ijin)
    modal.find('#jam_datang_keluar_ijin').val(jam_datang_keluar_ijin)
  })
</script>

<script>
  $('#exampleModal3').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var recipient = button.data('whatever') // Extract info from data-* attributes
    var c_id_cuti = button.data('c_id_cuti')
    var c_nama_karyawan = button.data('c_nama_karyawan')
    var c_divisi = button.data('c_divisi')
    var c_tahun_cuti = button.data('c_tahun_cuti')
    var c_tanggal_mulai = button.data('c_tanggal_mulai')
    var c_tanggal_akhir = button.data('c_tanggal_akhir')
    var c_ambil_cuti = button.data('c_ambil_cuti')
    var c_alasan_cuti = button.data('c_alasan_cuti')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Surat Cuti ' + recipient)
    modal.find('#c_id_cuti').val(c_id_cuti)
    modal.find('#c_nama_karyawan').val(c_nama_karyawan)
    modal.find('#c_divisi').val(c_divisi)
    modal.find('#c_tahun_cuti').val(c_tahun_cuti)
    modal.find('#c_tanggal_mulai').val(c_tanggal_mulai)
    modal.find('#c_tanggal_akhir').val(c_tanggal_akhir)
    modal.find('#c_ambil_cuti').val(c_ambil_cuti)
    modal.find('#c_alasan_cuti').val(c_alasan_cuti)
  })
</script>

<style>
.kolom {
    display : flex;
    align-items : center;
    margin-bottom: 0px;
}
.box {
  height: 20px;
  width: 20px;
  border: 1px solid #1a1a00;
  margin-right : 5px;
}

.red {
  background-color: #ff6666;
}

.yellow {
  background-color: #ffff66;
}

.green {
  background-color: #80ffaa;
}

.blue {
  background-color: #6666ff;
}
</style>
</body>
</html>