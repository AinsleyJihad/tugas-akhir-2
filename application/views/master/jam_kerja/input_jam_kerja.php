<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Input Jam Kerja</title>
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
            <h1 class="m-0">Input Jam Kerja</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/jam_kerja">Jam Kerja</a></li>
              <li class="breadcrumb-item active">Input</li>
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
                <form action="<?php echo base_url('jam_kerja/input/save')?>" method="post">
                    <div class="card-body">
                      <?php if($this->session->flashdata('msg')): ?>
                        <p><?php echo $this->session->flashdata('msg'); ?></p>
                      <?php unset($_SESSION['msg']); endif; ?>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Shift Kerja*</label>
                            <input type="text" class="form-control" name="nama_jam_kerja" placeholder="Masukkan Nama Jam Kerja" required>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Masuk*</label>
                                    <input type="time" class="form-control" name="jam_masuk" placeholder="Jam Masuk" required>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Pulang*</label>
                                    <input type="time" class="form-control" name="jam_pulang" placeholder="Jam Pulang" required>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Masuk Sabtu*</label>
                                    <input type="time" class="form-control" name="jam_masuk_sabtu" placeholder="Jam Masuk" required>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Pulang Sabtu*</label>
                                    <input type="time" class="form-control" name="jam_pulang_sabtu" placeholder="Jam Pulang" required>
                                </div>
                            </div>
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

<script>
function myFunction(val) {
    <?php
    foreach($jam_kerja as $jk){ ?>
        if(val == <?php echo $jk['id_jam_kerja'] ?>)
        {
            document.getElementById('jam_masuk').value = "<?php echo $jk['jam_masuk'] ?>";
            document.getElementById('jam_pulang').value = "<?php echo $jk['jam_pulang'] ?>";
            document.getElementById('jam_masuk_sabtu').value = "<?php echo $jk['jam_masuk_sabtu'] ?>";
            document.getElementById('jam_pulang_sabtu').value = "<?php echo $jk['jam_pulang_sabtu'] ?>";
        }
    <?php
    } ?>
}
</script>
</body>
</html>