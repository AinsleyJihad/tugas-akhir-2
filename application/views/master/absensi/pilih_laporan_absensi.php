<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Pilih Laporan Absensi</title>
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
            <h1 class="m-0">Pilih Laporan Absensi</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/absensi">Absensi</a></li>
              <li class="breadcrumb-item active">Pilih Laporan</li>
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
                <div class="card-body">
                  <div class="row">
                    <div class="col-12">
                    </br>
                      <a href="/payroll/absensi/laporan_semua"><button type="button" class="btn pull-right btn-block btn-success">Tampilkan Semua Laporan Absensi</button></a>
                    </div>
                  </div>
                </div>
                <form action="<?php echo base_url('absensi/laporan') ?>" method="post">
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Karyawan*</label>
                            <select class="custom-select rounded-0" id="id_karyawan" name="id_karyawan" required>
                            <option value="0">Semua</option>
                            <?php
                                foreach($karyawan as $k){ 
                                    echo"<option value='".$k['id_karyawan']."'>".$k['nama_karyawan']." - ".$k['idk']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Divisi*</label>
                            <select class="custom-select rounded-0" id="id_divisi" name="id_divisi" required>
                            <option value="0">Semua</option>
                            <?php
                                foreach($divisi as $d){ 
                                    echo"<option value='".$d['id_divisi']."'>".$d['nama_divisi']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tanggal Awal*</label>
                                    <input type="date" class="form-control" id="tanggal_awal" name="tanggal_awal" placeholder="Tanggal Awal" required>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tanggal Akhir*</label>
                                    <input type="date" class="form-control" id="tanggal_akhir" name="tanggal_akhir" placeholder="Tanggal Akhir" required>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Keterangan*</label>
                            <select class="custom-select rounded-0" id="keterangan" name="keterangan" required>
                            <option value="0">Semua</option>
                            <option value="1">Terlambat</option>
                            <option value="2">Pulang Terlalu Cepat</option>
                            <option value="3">Ijin</option>
                            <option value="4">Cuti</option>
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
      var d = new Date();
      var month = d.getMonth();
      var month_actual = month + 1;

      if (month_actual < 10) {
        month_actual = "0"+month_actual; 
        }

      var day_val = d.getDate();
      if (day_val < 10) {
        day_val = "0"+day_val; 
        }

      document.getElementById("tanggal_awal").value = d.getFullYear()+"-"+ month_actual +"-"+day_val;
      document.getElementById("tanggal_akhir").value = d.getFullYear()+"-"+ month_actual +"-"+day_val;
    });
</script>



</body>
</html>