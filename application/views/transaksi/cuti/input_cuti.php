<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Input Cuti</title>
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
            <h1 class="m-0">Input Cuti</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/cuti">Cuti</a></li>
              <li class="breadcrumb-item active">Input</li>
            </ol>
          </div><!-- /.col -->
          <!-- /. Lokasi Halaman -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- MODAL -->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Input Cuti</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('cuti/input/save')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                  <p id="judul_modal_2">Apakah anda yakin ingin input cuti?</p>
                  <p id="m_sisa_cuti_baru">Sisa cuti baru: ""</p>
                    <input type="text" class="form-control" id="m_id_karyawan" name="m_id_karyawan" placeholder="ID Karyawan" hidden>
                    <div class="form-group" hidden>
                      <div class="row">
                          <div class="col-12">
                            <label for="exampleInputEmail1">Tahun Cuti</label>
                            <input type="text" class="form-control" id="m_tahun_cuti" name="m_tahun_cuti" placeholder="Tahun Cuti" readonly>
                          </div>
                      </div>
                    </div>
                    <div class="form-group" hidden>
                      <div class="row">
                        <div class="col-6">
                          <label for="exampleInputEmail1">Sisa Cuti Tahun Kemarin</label>
                          <input type="text" class="form-control" name="m_sisa_cuti_tahun_kemarin" id="m_sisa_cuti_tahun_kemarin" placeholder="Masukkan nama karyawan dan tahun cuti" readonly></input>
                        </div>
                        <div class="col-6">
                          <label for="exampleInputEmail1">Sisa Cuti Tahun Ini</label>
                          <input type="text" class="form-control" name="m_sisa_cuti_tahun_ini" id="m_sisa_cuti_tahun_ini" placeholder="Masukkan nama karyawan dan tahun cuti" readonly></input>
                        </div>
                      </div>
                    </div>
                    <div class="form-group" hidden>
                      <div class="row">
                        <div class="col-6">
                            <label for="exampleInputEmail1">Tanggal Mulai Cuti</label>
                            <input type="text" class="form-control" name="m_tanggal_mulai" id="m_tanggal_mulai" placeholder="Tanggal Mulai" readonly>
                        </div>
                        <div class="col-6">
                            <label for="exampleInputEmail1">Tanggal Akhir Cuti</label>
                            <input type="text" class="form-control" name = "m_tanggal_akhir" id="m_tanggal_akhir" placeholder="Tanggal Akhir" readonly>
                        </div>
                      </div>
                    </div>
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">Total Ambil Cuti </label>
                        <input type="text" class="form-control" name="m_total_ambil" id="m_total_ambil" placeholder="Total Ambil" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">Alasan Cuti</label>
                        <input type="text" class="form-control" name="m_alasan_cuti" id="m_alasan_cuti" placeholder="Alasan Cuti" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">Ambil Cuti Tahun Sekarang</label>
                        <input type="text" class="form-control" name="m_ambil_cuti_tahun_sekarang" id="m_ambil_cuti_tahun_sekarang" placeholder="Ambil Cuti Tahun Sekarang" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                      <div class="row">
                        <div class="col-6">
                            <label for="exampleInputEmail1">Ambil Tahun Kemarin</label>
                            <input type="text" class="form-control" name="m_ambil_tahun_kemarin" id="m_ambil_tahun_kemarin" placeholder="Ambil Tahun Kemarin" readonly>
                        </div>
                        <div class="col-6">
                            <label for="exampleInputEmail1">Ambil Tahun Ini</label>
                            <input type="text" class="form-control" name = "m_ambil_tahun_ini" id="m_ambil_tahun_ini" placeholder="Ambil Tahun Ini" readonly>
                        </div>
                      </div>
                    </div>
                    <div class="form-group" hidden>
                      <div class="row">
                        <div class="col-6">
                          <label for="exampleInputEmail1">Sisa Cuti Lama Tahun Kemarin</label>
                          <input type="text" class="form-control" name="m_sisa_cuti_lama_tahun_kemarin" id="m_sisa_cuti_lama_tahun_kemarin" readonly></input>
                        </div>
                        <div class="col-6">
                          <label for="exampleInputEmail1">Sisa Cuti Lama Tahun Ini</label>
                          <input type="text" class="form-control" name="m_sisa_cuti_lama_tahun_ini" id="m_sisa_cuti_lama_tahun_ini" readonly></input>
                        </div>
                      </div>
                    </div>
                    <div class="form-group" hidden>
                      <div class="row">
                        <div class="col-6">
                          <label for="exampleInputEmail1">Sisa Cuti Baru Tahun Kemarin</label>
                          <input type="text" class="form-control" name="m_sisa_cuti_baru_tahun_kemarin" id="m_sisa_cuti_baru_tahun_kemarin" readonly></input>
                        </div>
                        <div class="col-6">
                          <label for="exampleInputEmail1">Sisa Cuti Baru Tahun Ini</label>
                          <input type="text" class="form-control" name="m_sisa_cuti_baru_tahun_ini" id="m_sisa_cuti_baru_tahun_ini" readonly></input>
                        </div>
                      </div>
                    </div>

                </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              <button type="submit" id="m_submit" class="btn btn-success">Input</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <!-- End Modal -->

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
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Karyawan</label>
                            <select class="custom-select rounded-0" name="id_karyawan" id="id_karyawan" onchange="ambilsisa()" required>
                            <?php
                                foreach($karyawan as $k){ 
                                  echo"<option value='".$k['id_karyawan']."'>".$k['nama_karyawan']." - ".$k['idk']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tahun Cuti* </label>
                            <input type="Number" class="form-control" name = "tahun_cuti" id="tahun_cuti" placeholder="Masukkan Tahun Cuti " onchange="ambilsisa()" required>
                            </input>
                        </div>
                        <div class="form-group">
                          <div class="row">
                            <div class="col-6">
                              <label for="exampleInputEmail1">Sisa Cuti Tahun Kemarin</label>
                              <input type="text" class="form-control" name="sisa_cuti_tahun_kemarin" id="sisa_cuti_tahun_kemarin" placeholder="Masukkan nama karyawan dan tahun cuti" readonly></input>
                            </div>
                            <div class="col-6">
                              <label for="exampleInputEmail1">Sisa Cuti Tahun Ini</label>
                              <input type="text" class="form-control" name="sisa_cuti_tahun_ini" id="sisa_cuti_tahun_ini" placeholder="Masukkan nama karyawan dan tahun cuti" readonly></input>
                            </div>
                          </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tanggal Mulai Cuti*</label>
                                    <input type="date" class="form-control" name="tanggal_mulai" id="tanggal_mulai" placeholder="Tanggal Mulai" onchange="ambiltotal()" required>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tanggal Akhir Cuti*</label>
                                    <input type="date" class="form-control" name = "tanggal_akhir" id="tanggal_akhir" placeholder="Tanggal Akhir" onchange="ambiltotal()" required>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Total Ambil Cuti </label>
                            <input type="text" class="form-control" name="total_ambil" id="total_ambil" placeholder="Masukkan tanggal mulai dan akhir cuti" min="0" readonly>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Alasan Cuti* </label>
                            <input type="text" class="form-control" name="alasan_cuti" id="alasan_cuti" placeholder="Masukkan Alasan Cuti" min="0" onchange="check()"  required>
                            </input>
                        </div>
                    </div>
                    <!-- /.card-body -->

                    <div class="card-footer">
                      <a href="" data-toggle="modal" data-target="#exampleModal" 
                      ><button type="submit" id="submit" class="btn btn-primary" disabled>Submit</button></a>
                    </div>
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
  $('#exampleModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var id_karyawan = document.getElementById("id_karyawan").value;
    var tahun_cuti = document.getElementById("tahun_cuti").value;
    var sisa_cuti_tahun_ini = document.getElementById("sisa_cuti_tahun_ini").value;
    var sisa_cuti_tahun_kemarin = document.getElementById("sisa_cuti_tahun_kemarin").value;
    var tanggal_mulai = document.getElementById("tanggal_mulai").value;
    var tanggal_akhir = document.getElementById("tanggal_akhir").value;
    var total_ambil = document.getElementById("total_ambil").value;
    var alasan_cuti = document.getElementById("alasan_cuti").value;
    // var sisa_cuti_lama_tahun_kemarin = document.getElementById("sisa_cuti_lama_tahun_kemarin").value;
    // var sisa_cuti_lama_tahun_ini = document.getElementById("sisa_cuti_lama_tahun_ini").value;
    // var sisa_cuti_baru_tahun_kemarin = document.getElementById("sisa_cuti_baru_tahun_kemarin").value;
    // var sisa_cuti_baru_tahun_ini = document.getElementById("sisa_cuti_baru_tahun_ini").value;
    console.log("id_karyawan : "+id_karyawan);
    console.log("tahun_cuti : "+tahun_cuti);
    console.log("sisa_cuti_tahun_ini : "+sisa_cuti_tahun_ini);
    console.log("sisa_cuti_tahun_kemarin : "+sisa_cuti_tahun_kemarin);
    console.log("tanggal_mulai : "+tanggal_mulai);
    console.log("tanggal_akhir : "+tanggal_akhir);
    console.log("total_ambil : "+total_ambil);
    console.log("alasan_cuti : "+alasan_cuti);

    document.getElementById('m_id_karyawan').value = id_karyawan;
    document.getElementById('m_tahun_cuti').value = tahun_cuti;
    document.getElementById('m_sisa_cuti_tahun_ini').value = sisa_cuti_tahun_ini;
    document.getElementById('m_sisa_cuti_tahun_kemarin').value = sisa_cuti_tahun_kemarin;
    document.getElementById('m_tanggal_mulai').value = tanggal_mulai;
    document.getElementById('m_tanggal_akhir').value = tanggal_akhir;
    document.getElementById('m_total_ambil').value = total_ambil;
    document.getElementById('m_alasan_cuti').value = alasan_cuti;
    // document.getElementById('m_sisa_cuti_lama_tahun_kemarin').value = sisa_cuti_lama_tahun_kemarin;
    // document.getElementById('m_sisa_cuti_lama_tahun_ini').value = sisa_cuti_lama_tahun_ini;
    // document.getElementById('m_sisa_cuti_baru_tahun_kemarin').value = sisa_cuti_baru_tahun_kemarin;
    // document.getElementById('m_sisa_cuti_baru_tahun_ini').value = sisa_cuti_baru_tahun_ini;


    //ambil bulan check apakah mei atau di bawahnya
    var bulan = tanggal_akhir.substring(5,7);
    bulan =  parseInt(bulan, 10);
    //console.log("bulan : "+bulan);
    if(bulan <= 5)
    {
      if(parseInt(sisa_cuti_tahun_kemarin) - parseInt(total_ambil) >= 0)
      {
        var m_sisa_cuti_baru = parseInt(sisa_cuti_tahun_kemarin) - parseInt(total_ambil);
        var tahun_ambil = parseInt(tahun_cuti, 10)-1;
        console.log(tahun_ambil);
        console.log("Sisa cuti baru: "+m_sisa_cuti_baru+"hari ("+parseInt(tahun_ambil)+")");
        document.getElementById("judul_modal_2").innerHTML = "Apakah anda yakin ingin input cuti?";
        document.getElementById("m_sisa_cuti_baru").innerHTML = "Sisa cuti baru: "+m_sisa_cuti_baru+" hari ("+tahun_ambil+")";
        document.getElementById('m_ambil_cuti_tahun_sekarang').value = "N";
        document.getElementById('m_ambil_tahun_kemarin').value = total_ambil;
        document.getElementById('m_ambil_tahun_ini').value = "0";
        document.getElementById("m_submit").disabled = false;
        document.getElementById('m_sisa_cuti_lama_tahun_kemarin').value = sisa_cuti_tahun_kemarin;
        document.getElementById('m_sisa_cuti_baru_tahun_kemarin').value = m_sisa_cuti_baru;
        document.getElementById('m_sisa_cuti_lama_tahun_ini').value = sisa_cuti_tahun_ini;
        document.getElementById('m_sisa_cuti_baru_tahun_ini').value = sisa_cuti_tahun_ini;
      }
      else if(parseInt(sisa_cuti_tahun_kemarin, 10) + parseInt(sisa_cuti_tahun_ini, 10) - parseInt(total_ambil, 10) >= 0){
        var m_sisa_cuti_baru = parseInt(sisa_cuti_tahun_kemarin, 10) - parseInt(total_ambil, 10);
        var m_sisa_cuti_baru_2 = parseInt(sisa_cuti_tahun_ini, 10) + parseInt(m_sisa_cuti_baru, 10);
        var sisa_cuti_baru_tahun_ini = m_sisa_cuti_baru_2;
        var sisa_cuti_baru_tahun_kemarin = 0;
        m_ambil_tahun_ini = 0 - parseInt(m_sisa_cuti_baru, 10);
        m_sisa_cuti_baru = 0;
        var tahun_ambil = parseInt(tahun_cuti, 10)-1;
        var tahun_ambil_2 = tahun_cuti;
        console.log("Sisa cuti baru: "+m_sisa_cuti_baru+"hari ("+tahun_ambil+")");
        console.log("Sisa cuti baru: "+m_sisa_cuti_baru_2+"hari ("+tahun_ambil_2+")");
        document.getElementById("judul_modal_2").innerHTML = "Apakah anda yakin ingin input cuti?";
        document.getElementById("m_sisa_cuti_baru").innerHTML = "Sisa cuti baru: "+m_sisa_cuti_baru+" hari ("+tahun_ambil+")</br>Sisa cuti baru: "+m_sisa_cuti_baru_2+" hari ("+tahun_ambil_2+")";
        document.getElementById('m_ambil_cuti_tahun_sekarang').value = "Y&N";
        document.getElementById('m_ambil_tahun_kemarin').value = sisa_cuti_tahun_kemarin;
        document.getElementById('m_ambil_tahun_ini').value = m_ambil_tahun_ini;
        document.getElementById("m_submit").disabled = false;
        document.getElementById('m_sisa_cuti_lama_tahun_kemarin').value = sisa_cuti_tahun_kemarin;
        document.getElementById('m_sisa_cuti_baru_tahun_kemarin').value = sisa_cuti_baru_tahun_kemarin;
        document.getElementById('m_sisa_cuti_lama_tahun_ini').value = sisa_cuti_tahun_ini;
        document.getElementById('m_sisa_cuti_baru_tahun_ini').value = sisa_cuti_baru_tahun_ini;
      }
      else
      {
        document.getElementById("judul_modal_2").innerHTML = "";
        document.getElementById("m_sisa_cuti_baru").innerHTML = "Anda mengambil cuti melebihi dari sisa cuti.";
        document.getElementById('m_ambil_tahun_kemarin').value = "0";
        document.getElementById('m_ambil_tahun_ini').value = "0";
        document.getElementById("m_submit").disabled = true;
      }
    }
    else
    {
      if(parseInt(sisa_cuti_tahun_ini, 10) - parseInt(total_ambil, 10) >= 0)
      {
        var m_sisa_cuti_baru = parseInt(sisa_cuti_tahun_ini, 10) - parseInt(total_ambil, 10);
        var tahun_ambil = tahun_cuti;
        console.log("Sisa cuti baru: "+m_sisa_cuti_baru+"hari ("+tahun_ambil+")");
        document.getElementById("judul_modal_2").innerHTML = "Apakah anda yakin ingin input cuti?";
        document.getElementById("m_sisa_cuti_baru").innerHTML = "Sisa cuti baru: "+m_sisa_cuti_baru+" hari ("+tahun_ambil+")";
        document.getElementById('m_ambil_cuti_tahun_sekarang').value = "Y";
        document.getElementById('m_ambil_tahun_kemarin').value = "0";
        document.getElementById('m_ambil_tahun_ini').value = total_ambil;
        document.getElementById("m_submit").disabled = false;
        document.getElementById('m_sisa_cuti_lama_tahun_kemarin').value = sisa_cuti_tahun_kemarin;
        document.getElementById('m_sisa_cuti_baru_tahun_kemarin').value = sisa_cuti_tahun_kemarin;
        document.getElementById('m_sisa_cuti_lama_tahun_ini').value = sisa_cuti_tahun_ini;
        document.getElementById('m_sisa_cuti_baru_tahun_ini').value = m_sisa_cuti_baru;
        //console.log("aaaaaaaaaaaaaaa");
      }
      else
      {
        //console.log("bbbbbbbbbbbbb");
        document.getElementById("judul_modal_2").innerHTML = "";
        document.getElementById("m_sisa_cuti_baru").innerHTML = "Anda mengambil cuti melebihi dari sisa cuti.";
        document.getElementById('m_ambil_tahun_kemarin').value = "0";
        document.getElementById('m_ambil_tahun_ini').value = "0";
        document.getElementById("m_submit").disabled = true;
      }
    }
    
    
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Input Cuti')
    
  })
</script>

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

function ambilsisa() {
  var url = "<?php echo base_url('cuti/ambilSisaCuti')?>";
  var x = document.getElementById("tahun_cuti").value;
  var y = document.getElementById("id_karyawan").value;
  if(x!="" && y!="")
  {
    if(x > 999 && x < 10000)
    {
      $.ajax(
      {
        type: "POST",
        url: url,
        data: {'id_karyawan': y, 'tahun': x},
        dataType: 'json',
        success: function(data){
          console.log(data);
          document.getElementById('sisa_cuti_tahun_kemarin').value = data[0].sisa_cuti_tahun_kemarin;
          document.getElementById('sisa_cuti_tahun_ini').value = data[0].sisa_cuti_tahun_ini;
        }
      })
    }
    else
    {
      document.getElementById('sisa_cuti_tahun_kemarin').value = "Tahun harus 4 digit";
      document.getElementById('sisa_cuti_tahun_ini').value = "Tahun harus 4 digit";
    }
  }
  else if(x=="" && y!="")
  {
    document.getElementById('sisa_cuti_tahun_kemarin').value = "Masukkan tahun cuti";
    document.getElementById('sisa_cuti_tahun_ini').value = "Masukkan tahun cuti";
  }
  else if(x!="" && y=="")
  {
    document.getElementById('sisa_cuti_tahun_kemarin').value = "Masukkan Karyawan";
    document.getElementById('sisa_cuti_tahun_ini').value = "Masukkan Karyawan";
  }
  else
  {
    document.getElementById('sisa_cuti_tahun_kemarin').value = "Masukkan nama karyawan dan tahun cuti";
    document.getElementById('sisa_cuti_tahun_ini').value = "Masukkan nama karyawan dan tahun cuti";
  }
  check();

  //document.getElementById("sisa_cuti").innerHTML = "You selected: " + x;

  <?php
  /*
  foreach($cuti as $c){ ?>
      if(<?php echo $c['id_karyawan'] ?> == y )
      {
          if(<?php echo $c['tahun_cuti'] ?> == x)
          {
            document.getElementById('sisa_cuti').value = "<?php echo $c['sisa_cuti'] ?>";
          }
      }
  <?php
  } 
  */?>
}

function ambiltotal() {
  var x = document.getElementById("tanggal_mulai").value;
  var y = document.getElementById("tanggal_akhir").value;

  if(x!="" && y!=""){
    var x_tahun = x.substring(0,4);
    var x_bulan = x.substring(5,7);
    var x_tanggal = x.substring(8,10);
    //x_tahun = x_tahun*365;
    //x_bulan = x_bulan*30;
    var y_tahun = y.substring(0,4);
    var y_bulan = y.substring(5,7);
    var y_tanggal = y.substring(8,10);
    //y_tahun = y_tahun*365;
    //y_bulan = y_bulan*30;

    
    //console.log(total_hari );
    //console.log(y_bulan );
    //console.log("");
    var date1 = new Date(x_bulan+"/"+x_tanggal+"/"+x_tahun); 
    console.log(date1);
    var date2 = new Date(y_bulan+"/"+y_tanggal+"/"+y_tahun); 
    console.log(date2);
    var total_hari = ((date2.getTime() - date1.getTime()) / (1000 * 3600 * 24)) + 1;

    if(total_hari <= 0)
    {
      document.getElementById('total_ambil').value = "Tanggal akhir tidak boleh kurang dari tanggal mulai";
    }
    else
    {
      document.getElementById('total_ambil').value = total_hari;
    }

  }
  else if(x=="" && y!="")
  {
    document.getElementById('total_ambil').value = "Masukkan tanggal mulai cuti";
  }
  else if(x!="" && y=="")
  {
    document.getElementById('total_ambil').value = "Masukkan tanggal akhir cuti";
  }
  else
  {
    document.getElementById('total_ambil').value = "Masukkan tanggal mulai dan akhir cuti";
  }
  check();
}


function check(){
  var id_karyawan = document.getElementById("id_karyawan").value;
  var tahun_cuti = document.getElementById("tahun_cuti").value;
  var sisa_cuti_tahun_ini = document.getElementById("sisa_cuti_tahun_ini").value;
  var sisa_cuti_tahun_kemarin = document.getElementById("sisa_cuti_tahun_kemarin").value;
  var tanggal_mulai = document.getElementById("tanggal_mulai").value;
  var tanggal_akhir = document.getElementById("tanggal_akhir").value;
  var total_ambil = document.getElementById("total_ambil").value;
  var alasan_cuti = document.getElementById("alasan_cuti").value;

  /*
  if(id_karyawan == "")
  {
    off();
  }
  
  if(tahun_cuti == "")
  {
    off();
  }
    
  if(sisa_cuti_tahun_ini == "")
  {
    off();
  }
  else if(sisa_cuti_tahun_ini == "Masukkan tahun cuti")
  {
    off();
  }
  else if(sisa_cuti_tahun_ini == "Masukkan Karyawan")
  {
    off();
  }
  else if(sisa_cuti_tahun_ini == "Masukkan nama karyawan dan tahun cuti")
  {
    off();
  }
  else if((int)sisa_cuti_tahun_ini <= 0)
  {
    off();
  }
  */
  if(id_karyawan != "" &&
     tahun_cuti != "" &&
     sisa_cuti_tahun_ini != "" &&
     sisa_cuti_tahun_kemarin != "" &&
     tanggal_mulai != "" &&
     tanggal_akhir != "" &&
     total_ambil != "" &&
     alasan_cuti != ""
    )
  {
    if(total_ambil != "Tanggal akhir tidak boleh kurang dari tanggal mulai")
    {
      if(tahun_cuti > 999 && tahun_cuti < 10000)
      {
        document.getElementById("submit").disabled = false;
      }
      else
      {
        document.getElementById("submit").disabled = true;
      }
      
    }
    else 
    {
      document.getElementById("submit").disabled = true;
    }
  }
  else
  {
    document.getElementById("submit").disabled = true;
  }

}
</script>

</body>
</html>