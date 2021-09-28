<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Penggajian</title>
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
            <h1 class="m-0">Penggajian</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">Penggajian</li>
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
                <!-- <div class="row">
                  <div class="col-2">
                    <a href="/payroll/penggajian/input"><button type="button" class="btn btn-block btn-success"><i class="fas fa-plus"></i>  Input Gaji</button></a>
                  </div>
                </div> -->
                <h4>Pilih Laporan Penggajian</h4>
                
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                
              <form action="/payroll/penggajian/laporan" method="post">
                    <div class="form-group">
                            <label for="exampleInputEmail1">Nama Karyawan*</label>
                            <select class="custom-select rounded-0" id="id_karyawan" name="id_karyawan" required>
                            <option value="0">Semua</option>
                            <?php
                                foreach($karyawan as $k){ 
                                    echo"<option value='".$k['id_karyawan']."'>".$k['nama_karyawan']." - ".$k['id_karyawan']."</option>";
                                } ?>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="exampleInputEmail1">Pilih Tahun*</label>
                            <select class="custom-select rounded-0" name="tahun" id="tahun" required>
                              <?php
                                foreach($umk as $k){ 
                                  echo"<option value='".$k['tahun_umk']."'>".$k['tahun_umk']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Pilih Bulan*</label>
                            <select class="custom-select rounded-0" id="bulan" name="bulan" required>
                                <option value="1">Januari</option>
                                <option value="2">Februari</option>
                                <option value="3">Maret</option>
                                <option value="4">April</option>
                                <option value="5">Mei</option>
                                <option value="6">Juni</option>
                                <option value="7">Juli</option>
                                <option value="8">Agustus</option>
                                <option value="9">September</option>
                                <option value="10">Oktober</option>
                                <option value="11">November</option>
                                <option value="12">Desember</option>
                            </select>
                        </div>
                    <!-- /.card-body -->
                    </div>
                    <div class="card-footer">
                    <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>

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

  <!-- <script>
  $(function () {
    $("#example1").DataTable({
      "responsive": false, "lengthChange": false, "autoWidth": true,
      "buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"],
      "scrollX": true,
      "paging": false,
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
  </script> -->

<!-- <script>
  $( document ).ready(function() {
    <?php 
    // $seq = 0;
    // foreach($gaji as $g)
    // { 
    ?>
      var potong_days<?php //echo $seq; ?> = document.getElementById("potong_days<?php //echo $seq; ?>").innerText;
      var potong_value<?php //echo $seq; ?> = document.getElementById("potong_value<?php //echo $seq; ?>").innerText;
      var sub_total<?php //echo $seq; ?> = document.getElementById("sub_total<?php //echo $seq; ?>").innerText;
      var gaji_dibayar<?php //echo $seq; ?> = document.getElementById("gaji_dibayar<?php //echo $seq; ?>").innerText;

      console.log("potong_days<?php //echo $seq; ?> = "+potong_days<?php //echo $seq; ?>);
      console.log("potong_value<?php //echo $seq; ?> = "+potong_value<?php //echo $seq; ?>);
      console.log("sub_total<?php //echo $seq; ?> = "+sub_total<?php //echo $seq; ?>);
      console.log("gaji_dibayar<?php //echo $seq; ?> = "+gaji_dibayar<?php //echo $seq; ?>);
      console.log("");

      var url = "<?php //echo base_url('penggajian/potongAbsen')?>";
      var id_karyawan = "<?php //echo $g['id_karyawan']; ?>";
      var tahun = "<?php //echo $g['tahun_ini']; ?>";
      var bulan = "<?php //echo $g['bulan_ini']; ?>";
      console.log("url = "+url);
      console.log("id_karyawan = "+id_karyawan);
      console.log("tahun = "+tahun);
      console.log("bulan = "+bulan);
      var ok = false;
      $.ajax(
        {
          type: "POST",
          url: url,
          data: {'id_karyawan': id_karyawan, 'tahun': tahun, 'bulan': bulan},
          dataType: 'json',
          success: function(data){
            console.log(data);
            console.log("masuk");
            //ok = true;
            //document.getElementById('total_lembur').value = data[0].sum;
          }
        }
      )

      // if(ok == false)
      //   console.log('sadge');

      console.log("");
      console.log("");




    <?php
      //$seq++;
    //}
    ?>

    //console.log("fffff");

    


  });
</script> -->
</body>
</html>