<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Input Penggajian</title>
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
            <h1 class="m-0">Input Penggajian</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/penggajian">Penggajian</a></li>
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
                <form action="/payroll/cuti" method="post">
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Karyawan*</label>
                            <select class="custom-select rounded-0" name="id_karyawan" id="id_karyawan" onchange="lemburTunjangan()" required>
                            <option value=''>Pilih Karyawan...</option>
                              <?php
                              foreach($karyawan as $k){ 
                                echo"<option value='".$k['id_karyawan']."'>".$k['nama_karyawan']." - ".$k['id_karyawan']."</option>";
                              } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tahun*</label>
                            <select class="custom-select rounded-0" name="tahun" id="tahun" onchange="getGPdanTotalLembur()" required>
                              <option value=''>Pilih Tahun...</option>
                              <?php
                                foreach($umk as $k){ 
                                  echo"<option value='".$k['tahun_umk']."'>".$k['tahun_umk']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Pilih Bulan*</label>
                            <select class="custom-select rounded-0" id="bulan" name="bulan" onchange="getTotalLembur()" required>
                                <option value=''>Pilih Bulan...</option>
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
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tanggal Gaji*</label>
                            <input type="date" class="form-control" placeholder="Tanggal Mulai" required>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Total Lembur</label>
                            <input type="text" class="form-control" id="total_lembur" name="total_lembur" placeholder="Lembur" onchange="totalGaji()" readonly>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tunjangan Jabatan</label>
                            <input type="text" class="form-control" id="tunjangan_jabatan" name="tunjangan_jabatan" placeholder="Tunjangan Jabatan" onchange="totalGaji()" readonly>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tunjangan Keluarga</label>
                            <input type="number" class="form-control" id="tunjangan_keluarga" name ="tunjangan_keluarga" min="0" placeholder="Tunjangan Keluarga (Tidak Wajib)" onchange="totalGaji()">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Ongkos Bongkar</label>
                            <input type="Number" class="form-control" id="ongkos_bongkar" name ="ongkos_bongkar" min="0" placeholder="Ongkos Bongkar (Tidak Wajib)" onchange="totalGaji()">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Ongkos Lain Lain</label>
                            <input type="number" class="form-control" id="ongkos_lain" name ="ongkos_lain" min="0" placeholder="Ongkos Lain Lain (Tidak Wajib)" onchange="totalGaji()">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Gaji Pokok</label>
                            <input type="text" class="form-control" id="gaji_pokok" name ="gaji_pokok" min="0" placeholder="Gaji Pokok" readonly>
                            </input>
                        </div>
                        <div class="form-group">
                          <div class="row">
                            <div class="col-6">
                              <label for="exampleInputEmail1">BPJS Kesehatan</label>
                              <input type="text" class="form-control" id="bpjs_kesehatan" name ="bpjs_kesehatan" min="0" placeholder="Gaji Pokok" readonly>
                              </input>
                            </div>
                            <div class="col-6">
                              <label for="exampleInputEmail1">BPJS Ketenagakerjaan</label>
                              <input type="text" class="form-control" id="bpjs_ketenagakerjaan" name ="bpjs_ketenagakerjaan" min="0" placeholder="Gaji Pokok" readonly>
                              </input>
                            </div>
                          </div>
                        </div>















                        <div class="form-group">
                            <label for="exampleInputEmail1">Total Gaji</label>
                            <input type="text" class="form-control" id="total_gaji" name="total_gaji" placeholder="Total Gaji" readonly>
                            </input>
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

function lemburTunjangan(){
  var id_karyawan = document.getElementById("id_karyawan").value;
  var tahun = document.getElementById("tahun").value;
  var bulan = document.getElementById("bulan").value;
  if(id_karyawan != '')
  {
    //console.log(id_karyawan);
    <?php
    foreach($jabatan as $j){ 
      foreach($karyawan as $k){ ?>
        if(id_karyawan == <?php echo $k['id_karyawan'] ?>)
        {
          if(<?php echo $j['id_jabatan'] ?> == <?php echo $k['id_jabatan'] ?> )
          {
            document.getElementById('tunjangan_jabatan').value = "<?php echo $j['tunjangan_jabatan'] ?>";
            totalGaji();
          }
        }
      <?php
      }
    } 
    ?>
    if(tahun != '' && bulan != '')
      getTotalLembur();
  }
  
}



function getGPdanTotalLembur(){
  var id_karyawan = document.getElementById("id_karyawan").value;
  var tahun = document.getElementById("tahun").value;
  var bulan = document.getElementById("bulan").value;
  if(tahun != '')
  {
    <?php 
    foreach($umk as $u) 
    { ?>
      if(tahun == <?php echo $u['tahun_umk'] ?>)
      {
        var gaji_pokok = <?php echo $u['total_umk'] ?>;
        var bpjs_kesehatan = <?php echo $u['total_umk'] ?>;
        var bpjs_ketenagakerjaan = <?php echo $u['total_umk'] ?>;

        document.getElementById('bpjs_kesehatan').value = gaji_pokok;
        document.getElementById('bpjs_ketenagakerjaan').value = gaji_pokok;
        document.getElementById('gaji_pokok').value = gaji_pokok;
      }
    <?php 
    } ?>
  }

  if(tahun != '' && bulan != '')
      getTotalLembur();
}




function getTotalLembur(){
  var id_karyawan = document.getElementById("id_karyawan").value;
  var tahun = document.getElementById("tahun").value;
  var bulan = document.getElementById("bulan").value;
  if(id_karyawan != '' && tahun != '' && bulan != '')
  {
    //console.log(id_karyawan+" "+id_umk+" "+bulan);
    var url = "<?php echo base_url('penggajian/totalLembur')?>";
    $.ajax(
      {
        type: "POST",
        url: url,
        data: {'id_karyawan': id_karyawan, 'tahun': tahun, 'bulan': bulan},
        dataType: 'json',
        success: function(data){
          console.log(data);
          document.getElementById('total_lembur').value = data[0].total_lembur;
          totalGaji();
        }
      }
    )
  }

}

function totalGaji(){
    //console.log('aa');
    var tunjangan_jabatan = document.getElementById("tunjangan_jabatan").value;
    var tunjangan_keluarga = document.getElementById("tunjangan_keluarga").value;
    var ongkos_bongkar = document.getElementById("ongkos_bongkar").value;
    var ongkos_lain = document.getElementById("ongkos_lain").value;
    var total_lembur = document.getElementById("total_lembur").value;

    // console.log("tunjangan_jabatan : "+tunjangan_jabatan);
    // console.log("tunjangan_keluarga : "+tunjangan_keluarga);
    // console.log("ongkos_bongkar : "+ongkos_bongkar);
    // console.log("ongkos_lain : "+ongkos_lain);
    // console.log("total_lembur : "+total_lembur);

    
    if(tunjangan_jabatan == ''){
      tunjangan_jabatan = 0;
    }

    if(tunjangan_keluarga == ''){
      tunjangan_keluarga = 0;
    }
    
    if(ongkos_bongkar == ''){
      ongkos_bongkar = 0;
    }

    if(ongkos_lain == ''){
      ongkos_lain = 0;
    }

    if(total_lembur == ''){
      total_lembur = 0;
    }

    console.log("tunjangan_jabatan : "+tunjangan_jabatan);
    console.log("tunjangan_keluarga : "+tunjangan_keluarga);
    console.log("ongkos_bongkar : "+ongkos_bongkar);
    console.log("ongkos_lain : "+ongkos_lain);
    console.log("total_lembur : "+total_lembur);

    var total_gaji = parseInt(tunjangan_jabatan, 10) + 
                     parseInt(tunjangan_keluarga,10) +
                     parseInt(ongkos_bongkar, 10) +
                     parseInt(ongkos_lain, 10) +
                     parseInt(total_lembur, 10);

    console.log("total_gaji : "+total_gaji);
    document.getElementById('total_gaji').value = total_gaji;
    

  }



</script>
</body>
</html>