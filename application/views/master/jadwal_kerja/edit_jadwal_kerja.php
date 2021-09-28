<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Edit Jadwal Kerja</title>
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
            <h1 class="m-0">Edit Jadwal Kerja</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/jadwal_kerja">Jadwal Kerja</a></li>
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
                <form action="<?php echo base_url('jadwal_kerja/edit/save/'.$jadwal_kerja[0]['id_jadwal']) ?>" method="post">
                    <div class="card-body">
                      <?php if($this->session->flashdata('msg')): ?>
                        <p><?php echo $this->session->flashdata('msg'); ?></p>
                      <?php unset($_SESSION['msg']); endif; ?>
                        <div class="form-group">
                            <label for="exampleInputEmail1">ID Jadwal Kerja</label>
                            <input type="text" class="form-control" id="id_jadwal" name="id_jadwal" placeholder="" value="<?php echo $jadwal_kerja[0]['view_id'] ?>" disabled>
                        </div>

                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Karyawan*</label>
                            <select class="custom-select rounded-0" id="id_karyawan" name="id_karyawan" required>
                            <?php
                                foreach($karyawan as $k){ 
                                    echo"<option value='".$k['id_karyawan']."'>".$k['nama_karyawan']." - ".$k['idk']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tanggal*</label>
                            <input type="date" class="form-control" id="tanggal_jadwal" name="tanggal_jadwal" value="<?php echo $jadwal_kerja[0]['tanggal_jadwal'] ?>" placeholder="Tanggal Jadwal" required>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Jam Kerja*</label>
                            <select class="custom-select rounded-0" id="id_jam_kerja" name="id_jam_kerja" onchange="myFunction(this.value)" required>
                            <?php
                                foreach($jam_kerja as $jk){ 
                                    echo"<option value='".$jk['id_jam_kerja']."'>".$jk['nama_jam_kerja']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Masuk</label>
                                    <input type="time" class="form-control" id="jam_masuk" name="jam_masuk" placeholder="Jam Masuk" readonly>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Pulang</label>
                                    <input type="time" class="form-control" id="jam_pulang" name="jam_pulang" placeholder="Jam Pulang" readonly>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Masuk Sabtu</label>
                                    <input type="time" class="form-control" id="jam_masuk_sabtu" name="jam_masuk_sabtu" placeholder="Jam Masuk" readonly>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Pulang Sabtu</label>
                                    <input type="time" class="form-control" id="jam_pulang_sabtu" name="jam_pulang_sabtu" placeholder="Jam Pulang" readonly>
                                </div>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="exampleInputEmail1">Status*</label>
                            <select class="custom-select rounded-0" id="status_jadwal_kerja" name="status_jadwal_kerja" required>
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
        var sum = 0;
        <?php
        foreach($karyawan as $k){ ?>
            if(<?php echo $k['id_karyawan'] ?> == <?php echo $jadwal_kerja[0]['id_karyawan'] ?>)
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

        sum = 0;
        <?php
        foreach($jam_kerja as $j){ ?>
            if(<?php echo $j['id_jam_kerja'] ?> == <?php echo $jadwal_kerja[0]['id_jam_kerja'] ?>)
            {
                //console.log('masuk'+sum);
                document.getElementById("id_jam_kerja").selectedIndex = sum;
                document.getElementById("jam_masuk").value = "<?php echo $j['jam_masuk'] ?>";
                document.getElementById("jam_pulang").value = "<?php echo $j['jam_pulang'] ?>";
                document.getElementById("jam_masuk_sabtu").value = "<?php echo $j['jam_masuk_sabtu'] ?>";
                document.getElementById("jam_pulang_sabtu").value = "<?php echo $j['jam_pulang_sabtu'] ?>";
            }
            else
            {
                sum = sum + 1;
            }
        <?php
        } ?>

        var status = "<?php echo $jadwal_kerja[0]['status'] ?>";
        if(status == "Y")
        {
            document.getElementById("status_jadwal_kerja").selectedIndex = 0;
            //selectElement('status_divisi', 'Y');
        }
        else
        {
            document.getElementById("status_jadwal_kerja").selectedIndex = 1;
            //selectElement('status_divisi', 'N');
        }
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