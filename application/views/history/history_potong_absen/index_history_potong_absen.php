<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>History Potong Lain</title>
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
            <h1 class="m-0">History Potong Lain</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">History Potong Lain</li>
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
                    <th>ID Potong Absen</th>
                    <th>Nama Karyawan</th>
                    <th>Tahun</th>
                    <th>Bulan</th>
                    <th>Total Hari</th>
                    <th>Alasan Potong</th>
                    <th>Status Potong</th>
                    <th>Change By</th>
                    <th>Change At</th> 
                    <th>Aksi</th>  
                  </tr>
                  </thead>
                  <tbody>
                  <?php 
                      $seq = 1;
                      foreach ($fetch as $row) {
                        echo "<tr>";
                          echo "<td>".$seq."</td>";
                          echo "<td>".$row['view_id']."</td>";
                          echo "<td>".$row['nama_karyawan']."</td>";
                          echo "<td>".$row['tahun']."</td>";
                          echo "<td>".$row['bulan']."</td>";
                          echo "<td align='right'>".rupiah($row['total_hari'])."</td>";
                          echo "<td>".$row['alasan_potong']."</td>";
                          if($row['status_potong']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          echo "<td>".$row['change_by']."</td>";
                          echo "<td>".$row['change_at']."</td>";
                          echo '<td>
                                    <a href="/payroll/potong_absen/edit/'.$row['id_potong_absen'].'"><button type="button" class="btn btn-block btn-info"><i class="fas fa-edit"></i></button></a>
                                    <a href="" data-toggle="modal" data-target="#exampleModal" 
                                    data-id_potong_absen="'.$row['id_potong_absen'].'"
                                    data-nama_karyawan="'.$row['nama_karyawan'].'"
                                    ><button type="button" class="btn btn-block btn-danger"><i class="fas fa-trash-alt"></i></button></a>
                                 </td>';
                    
                        echo "</tr>";
                        $seq++;
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

<?php

function rupiah($value) {
	$hasil = number_format($value,0,',','.');
	return $hasil;
}?>
</body>
</html>