<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>History Karyawan</title>
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
            <h1 class="m-0">History Karyawan</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">History Karyawan</li>
            </ol>
          </div><!-- /.col -->
          <!-- /. Lokasi Halaman -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <section class="content">
      <div class="container-fluid">
        <div class="row">
          <div class="col-12">

            <div class="card">
              <div class="card-header">
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>No</th>
                    <th>Id Karyawan</th>
                    <th>Reason</th>
                    <th>Nama Karyawan</th>
                    <th>Pin</th>
                    <th>Jabatan</th>
                    <th>Divisi</th>
                    <th>NIK</th>
                    <th>NO KTP</th>
                    <th>NPWP</th>
                    <th>JK</th>
                    <th>Tanggal Masuk Karyawan</th>
                    <th>Tanggal Keluar Karyawan</th>
                    <th>Status Karyawan</th>
                    <th>Telp Karyawan</th>
                    <th>Tempat Lahir Karyawan</th>
                    <th>Tanggal Lahir Karyawan</th>
                    <th>Alamat Karyawan</th>
                    <th>Tanggal Pengangkatan</th>
                    <th>Keterangan</th>
                    <th>Kontrak / Tetap</th>
                    <th>Pendidikan</th>
                    <th>PWKT 1</th>
                    <th>PWKT 2</th>
                    <th>Ikut Penggajian</th>
                    <th>Gaji Pokok</th>
                    <th>Tunjangan Jabatan</th>
                    <th>BPJS Kesehatan</th>
                    <th>K / TK</th>
                    <th>Change By</th>
                    <th>Change At</th>
                  </tr>
                  </thead>
                  <tbody>
                  <?php 
                      $seq = 1;
                      foreach ($fetch as $row) {
                        echo "<tr>";
                          echo "<td>".$seq."</td>";
                          echo "<td>".$row['view_id']."</td>";
                          echo "<td>".$row['reason']."</td>";
                          echo "<td>".$row['nama_karyawan']."</td>";
                          echo "<td>".$row['pin']."</td>";
                          echo "<td>".$row['nama_jabatan']."</td>";
                          echo "<td>".$row['nama_divisi']."</td>";
                          echo "<td>".$row['nik']."</td>";
                          echo "<td>".$row['no_ktp']."</td>";
                          echo "<td>".$row['npwp']."</td>";
                          echo "<td>".$row['jenis_kelamin_karyawan']."</td>";
                          echo "<td>".$row['tanggal_masuk_karyawan']."</td>";
                          echo "<td>".$row['tanggal_keluar_karyawan']."</td>";
                          if($row['status_karyawan']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else if($row['status_karyawan']=='N'){
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          else{
                            echo '<td></td>';
                          }
                          echo "<td>".$row['telp_karyawan']."</td>";
                          echo "<td>".$row['tempat_lahir_karyawan']."</td>";
                          echo "<td>".$row['tanggal_lahir_karyawan']."</td>";
                          echo "<td>".$row['alamat_karyawan']."</td>";
                          echo "<td>".$row['tanggal_pengangkatan']."</td>";
                          echo "<td>".$row['keterangan']."</td>";
                          if ($row['k_tk'] == 'Kontrak'){
                            echo "<td>".$row['k_tk']."</td>";
                          } else {
                            echo "<td>Tetap</td>";
                          }
                          echo "<td>".$row['pendidikan']."</td>";
                          echo "<td>".$row['pkwt1']."</td>";
                          echo "<td>".$row['pkwt2']."</td>";
                          if($row['ikut_penggajian']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat"><i class="fas fa-check"></i></button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat"><i class="fas fa-times"></i></button></td>';
                          }
                          echo "<td align='right'>".rupiah($row['gaji_pokok'])."</td>";
                          echo "<td align='right'>".rupiah($row['tunjangan_jabatan'])."</td>";
                          if($row['bpjs_kesehatan']=='Y'){
                            echo'<td>Ikut Perusahaan</td>';
                          }
                          else{
                            echo'<td>Mandiri</td>';
                          }
                          echo "<td>".$row['kawin_tdkkawin']."</td>";
                          echo "<td>".$row['change_by']."</td>";
                          echo "<td>".$row['change_at']."</td>";
                        $seq++;
                        echo "</tr>";
                        }
                    ?>
                  </tbody>
                  <tfoot>
                  
                  </tfoot>
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
      "responsive": false, "lengthChange": true, "autoWidth": false,
      "buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"],
      "scrollX": true,
      "paging": false,
    }).buttons().container().appendTo('#example1_wrapper .col-md-6:eq(0)');
    $('#example2').DataTable({
      "paging": true,
      "lengthChange": true,
      "searching": false,
      "ordering": true,
      "info": true,
      "autoWidth": false,
      "responsive": true,
    });
  });
</script>

<?php

function rupiah($value) {
	$hasil = number_format($value,0,',','.');
	return $hasil;
}?>
</body>
</html>