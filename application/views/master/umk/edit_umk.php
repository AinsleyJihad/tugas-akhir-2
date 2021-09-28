<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Edit UMK</title>
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
            <h1 class="m-0">Edit UMK</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/umk">UMK</a></li>
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
                <form action="<?php echo base_url('umk/edit/save/'.$umk[0]['id_umk']) ?>" method="post">
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">ID UMK</label>
                            <input type="text" class="form-control" id="id_umk" name="id_umk" placeholder="" value="<?php echo $umk[0]['view_id'] ?>" disabled>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tahun UMK*</label>
                            <input type="Number" class="form-control" name="tahun_umk" value="<?php echo $umk[0]['tahun_umk'] ?>" placeholder="Masukkan Tahun UMK" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jumlah UMK*</label>
                            <input type="Number" class="form-control" name="total_umk" value="<?php echo $umk[0]['total_umk'] ?>" placeholder="Masukkan Jumlah UMK" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Gaji Per Jam*</label>
                            <input type="Number" class="form-control" name="gaji_per_jam" id="gaji_per_jam" value="<?php echo $umk[0]['gaji_per_jam'] ?>" placeholder="Masukkan Jumlah UMK" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PLANT*</label>
                            <select class="custom-select rounded-0" name="plant" id="plant" required>
                                <option value="Krian">Krian</option>
                                <option value="Mojoagung">Mojoagung</option>
                                <option value="Lamongan">Lamongan</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Status*</label>
                            <select class="custom-select rounded-0" id="status_umk" name="status_umk" required>
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
        var status = "<?php echo $umk[0]['status_umk'] ?>";
        if(status == "Y")
        {
            document.getElementById("status_umk").selectedIndex = 0;
        }
        else
        {
            document.getElementById("status_umk").selectedIndex = 1;
        }
        });

        if("<?php echo $umk[0]['plant'] ?>" == "Krian")
        {
          document.getElementById("plant").selectedIndex = 0;
        }
        else if("<?php echo $umk[0]['plant'] ?>" == "Mojoagung")
        {
          document.getElementById("plant").selectedIndex = 1;
        }
        else
        {
          document.getElementById("plant").selectedIndex = 2;
        }
</script>
</body>
</html>