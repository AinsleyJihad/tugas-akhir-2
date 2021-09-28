<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Absensi</title>
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
            <h1 class="m-0">Absensi</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">Absensi</li>
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
            <?php if($this->session->flashdata('msg')): ?>
              <p><?php echo $this->session->flashdata('msg'); ?></p>
            <?php unset($_SESSION['msg']); endif; ?>
              <div class="card-header">
                <div class="row">
                  <div class="col-8">
                    <h4 class="m-0">Input Absensi</h4>
                    <?php echo form_open_multipart('spreadsheet/import',array('name' => 'spreadsheet')); ?>
                      <table style="margin-top: 10px;">
                          <tr>
                            <td><input type="file" size="40px" name="upload_file" placeholder="Plant" /></td>
                            <td class="error"><?php echo form_error('name'); ?></td>
                            <td>
                              <select name="plant">
                                <option value="Mojoagung">Mojoagung</option>
                                <option value="Krian">Krian</option>
                                <option value="Lamongan">Lamongan</option>
                              </select>
                            </td>
                            <td><input type="submit" value="Upload Absensi"/></td>
                          </tr>
                          <!-- <tr>
                            <td><input type="text" size="40px" name="plant" /></td>
                            <td></td>
                            <td></td>
                          </tr> -->
                      </table>
                    <?php echo form_close();?>
                  </div>
                  <div class="col-4">
                  </br>
                    <a href="/payroll/absensi/pilih_laporan"><button type="button" class="btn pull-right btn-block btn-success">Laporan Absensi</button></a>
                  </div>
                </div>
                
                
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>No</th>
                    <th>ID Absensi</th>
                    <th>Nama Karyawan</th>
                    <th>Divisi</th>
                    <th>Jabatan</th>
                    <th>Plant</th>
                    <th>Tanggal Absensi</th>
                    <th>Jam Absensi</th>
                    <th>Nama Mesin</th>
                    <th>Status Absensi</th>
                    <th>Changed By</th>
                    <th>Changed At</th>
                  </tr>
                  </thead>
                  <tbody>
                  <?php 
                      $seq = 1;
                      foreach ($fetch as $row) {
                        echo "<tr>";
                          echo "<td>".$seq."</td>";
                          echo "<td>".$row['id_absensi']."</td>";
                          echo "<td>".$row['nama_karyawan']."</td>";
                          echo "<td>".$row['nama_divisi']."</td>";
                          echo "<td>".$row['nama_jabatan']."</td>";
                          echo "<td>".$row['plant']."</td>";
                          echo "<td>".$row['tanggal_absensi']."</td>";
                          echo "<td>".$row['jam_absensi']."</td>";
                          echo "<td>".$row['nama_mesin']."</td>";
                          if($row['status_absensi']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          echo "<td>".$row['change_by']."</td>";
                          echo "<td>".$row['change_at']."</td>";
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
</body>
</html>