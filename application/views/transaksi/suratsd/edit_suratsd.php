<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Edit Surat SD</title>
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
            <h1 class="m-0">Edit Surat SD</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/suratsd">Surat SD</a></li>
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
                <form action="<?php echo base_url('suratsd/edit/save/'.$suratsd[0]['id_surat']) ?>" method="post">
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">ID Surat SD</label>
                            <input type="text" class="form-control" id="id_surat" name="id_surat" min="0" value="<?php echo $suratsd[0]['view_id'] ?>" disabled>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Pilih Karyawan*</label>
                            <select class="custom-select rounded-0" id="id_karyawan" name="id_karyawan" required>
                              <?php
                                foreach($karyawan as $k){ 
                                  echo"<option value='".$k['id_karyawan']."'>".$k['nama_karyawan']." - ".$k['id_karyawan']."</option>";
                                } 
                              ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jenis Surat*</label>
                            <select class="custom-select rounded-0" name="jenis_surat" id="jenis_surat" required>
                                <option value="Surat Sakit">Surat Sakit</option>
                                <option value="Surat Dinas">Surat Dinas</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tanggal Surat*</label>
                            <input type="date" class="form-control" id="tanggal_surat" name="tanggal_surat" placeholder="Masukkan tanggal surat" value="<?php echo $suratsd[0]['tanggal_surat'] ?>" min="0" step="any" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Keterangan Surat*</label>
                            <input type="text" class="form-control" id="keterangan_surat" name="keterangan_surat" placeholder="Masukkan keterangan surat" value="<?php echo $suratsd[0]['keterangan_surat'] ?>" min="0" step="any" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Status*</label>
                            <select class="custom-select rounded-0" id="status_surat" name="status_surat" required>
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
<script>
    $(document).ready(function () {

        var sum = 0;
        <?php
        foreach($karyawan as $k){ ?>
            if(<?php echo $k['id_karyawan'] ?> == <?php echo $suratsd[0]['id_karyawan'] ?>)
            {
                //console.log('masuk'+sum);
                document.getElementById("id_karyawan").selectedIndex = sum;
            }
            else
            {
                sum = sum + 1;
            }
        <?php
        } ?>

        var status = "<?php echo $suratsd[0]['status_surat'] ?>";
        if(status == "Y")
        {
            document.getElementById("status_surat").selectedIndex = 0;
        }
        else
        {
            document.getElementById("status_surat").selectedIndex = 1;
        }
        
        status = "<?php echo $suratsd[0]['jenis_surat'] ?>";
        if(status == "Surat Sakit")
        {
            document.getElementById("jenis_surat").selectedIndex = 0;
        }
        else
        {
            document.getElementById("jenis_surat").selectedIndex = 1;
        }

        });
</script>
</body>
</html>