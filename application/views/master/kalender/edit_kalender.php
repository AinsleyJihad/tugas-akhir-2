<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Edit Kalender</title>
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
            <h1 class="m-0">Edit Kalender</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/kalender">Kalender</a></li>
              <li class="breadcrumb-item active">Edit</li>
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
        <!-- Small boxes (Stat box) -->
        <div class="row">
          <div class="col-12">
            <div class="card">
              <!-- /.card-header -->
              <div class="card-body">
                <?php if($this->session->flashdata('msg')): ?>
                  <p><?php echo $this->session->flashdata('msg'); ?></p>
                <?php unset($_SESSION['msg']); endif; ?>
                <form action="<?php echo base_url('kalender/edit/save/'.$kalender[0]['id_kalender']) ?>" method="post">
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">ID Kalender</label>
                            <input type="text" class="form-control" id="id_kalender" name="id_kalender" placeholder="" value="<?php echo $kalender[0]['view_id'] ?>" disabled>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Hari*</label>
                            <input type="text" class="form-control" id="nama_hari" name="nama_hari" placeholder="Masukkan Nama Hari" value="<?php echo $kalender[0]['nama_hari'] ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Pilih Jenis Hari*</label>
                            <select class="custom-select rounded-0" id="jenis_hari" name="jenis_hari" required>
                                <option>Hari Libur</option>
                                <option>Cuti Bersama</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tanggal Mulai*</label>
                                    <input type="date" name="tanggal_mulai" class="form-control" value="<?php echo $kalender[0]['tanggal_mulai'] ?>" placeholder="Tanggal Mulai" required>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tanggal Akhir*</label>
                                    <input type="date" name="tanggal_akhir" class="form-control" value="<?php echo $kalender[0]['tanggal_akhir'] ?>" placeholder="Tanggal Akhir" required>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Status*</label>
                            <select class="custom-select rounded-0" id="status_kalender" name="status_kalender" required>
                                <option value="Y">Aktif</option>
                                <option value="N">Tidak Aktif</option>
                            </select>
                        </div>
                    </div>
                    <!-- /.card-body -->

                    <div class="card-footer">
                    <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>
              </div>
              <!-- /.card-body -->
            </div>
            <!-- /.card -->
          </div>

          
        </div>
        <!-- /.row -->
        <!-- Main row -->
        <div class="row">
          <!-- Left col -->
          <section class="col-lg-7 connectedSortable">
            
          </section>
          <!-- /.Left col -->
          <!-- right col (We are only adding the ID to make the widgets sortable)-->
          <section class="col-lg-5 connectedSortable">

            
          </section>
          <!-- right col -->
        </div>
        <!-- /.row (main row) -->
      </div><!-- /.container-fluid -->
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
      "responsive": true, "lengthChange": false, "autoWidth": false,
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

<!-- Auto Input Form -->
<script>
$(document).ready(function () {

  var jh = "<?php echo $kalender[0]['jenis_hari'] ?>";
  if(jh == "Hari Libur")
  {
      document.getElementById("jenis_hari").selectedIndex = 0;
      //selectElement('status_divisi', 'Y');
  }
  else
  {
      document.getElementById("jenis_hari").selectedIndex = 1;
      //selectElement('status_divisi', 'N');
  }

  
  var status = "<?php echo $kalender[0]['status_kalender'] ?>";
  if(status == "Y")
  {
      document.getElementById("status_kalender").selectedIndex = 0;
      //selectElement('status_divisi', 'Y');
  }
  else
  {
      document.getElementById("status_kalender").selectedIndex = 1;
      //selectElement('status_divisi', 'N');
  }
});
</script>
</body>
</html>