<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Input Karyawan</title>
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
            <h1 class="m-0">Input Karyawan</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/karyawan">Karyawan</a></li>
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
                <?php if($this->session->flashdata('msg')): ?>
                  <p><?php echo $this->session->flashdata('msg'); ?></p>
                <?php unset($_SESSION['msg']); endif; ?>
                <form action="<?php echo base_url('karyawan/input/save')?>" method="post">
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Karyawan*</label>
                            <input type="text" class="form-control" name="nama_karyawan" placeholder="Masukkan Nama Karyawan" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PIN Absensi*</label>
                            <input type="Number" class="form-control" name="pin_karyawan" placeholder="Masukkan PIN Absensi" min="0" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jabatan*</label>
                            <select class="custom-select rounded-0" name="nama_jabatan" required>
                                <?php
                                foreach($jabatan as $j){ 
                                  echo"<option value='".$j['id_jabatan']."'>".$j['nama_jabatan']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Divisi*</label>
                            <select class="custom-select rounded-0" name="nama_divisi" required>
                              <?php
                              foreach($divisi as $d){ 
                                echo"<option value='".$d['id_divisi']."'>".$d['nama_divisi']."</option>";
                              } ?>
                            </select>
                        </div>
                        <!--
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jam Kerja*</label>
                            <select class="custom-select rounded-0" name="jam_kerja_karyawan" required>
                              <?php /*
                              foreach($shift as $k){ 
                                echo"<option value='".$k['id_jam_kerja']."'>".$k['nama_jam_kerja']." (".$k['jam_masuk']." - ".$k['jam_pulang'].")</option>";
                              } */ ?>
                            </select>
                        </div>
                        -->
                        <div class="form-group">
                            <label for="exampleInputEmail1">NIK</label>
                            <input type="number" class="form-control" name="nik_karyawan" placeholder="Masukkan NIK" title="Harus Angka"> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">No. KTP*</label>
                            <input type="text" class="form-control" name="ktp_karyawan" placeholder="Masukkan No. KTP" title="Harus Angka dan 16 Digit" pattern="[0-9]{16}" required> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">NPWP</label>
                            <input type="text" class="form-control" name="npwp_karyawan" placeholder="Masukkan NPWP (Tidak Wajib)" title="Harus Angka dan 16 Digit" pattern="[0-9]{15}"> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jenis Kelamin*</label>
                            <select class="custom-select rounded-0" name="jk_karyawan" required>
                                <option value="L">Laki-laki</option>
                                <option value="P">Perempuan</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tanggal Masuk*</label>
                            <input type="date" class="form-control" name="tanggal_masuk_karyawan" required> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">No. Telpon</label>
                            <input type="number" class="form-control" name="telp_karyawan" placeholder="Masukkan No. Telpon (Tidak Wajib)" title="" pattern="[0-9]{15}" min="0"> 
                            </input>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tempat Lahir</label>
                                    <input type="text" class="form-control" name="tempat_lahir_karyawan" placeholder="Tempat Lahir (Tidak Wajib)">
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tanggal Lahir</label>
                                    <input type="date" class="form-control" name="tanggal_lahir_karyawan" placeholder="Tanggal Lahir (Tidak Wajib)">
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Alamat</label>
                            <input type="text" class="form-control" name="alamat_karyawan" placeholder="Masukkan Alamat (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Pendidikan</label>
                            <input type="text" class="form-control" name="pendidikan_karyawan" placeholder="Masukkan Pendidikan (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Kontrak / Tetap*</label>
                            <select class="custom-select rounded-0" name="kontrak_tidak_kontrak_karyawan">
                                <option value="Kontrak">Kontrak</option>
                                <option value="Tidak Kontrak">Tetap</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jenis Karyawan*</label>
                            <select class="custom-select rounded-0" name="jenis_karyawan" required>
                                <option>Karyawan</option>
                                <option>Outsourcing</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PKWT 1</label>
                            <input type="text" class="form-control" name="pkwt1_karyawan" placeholder="Masukkan PKWT 1 (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PKWT 2</label>
                            <input type="text" class="form-control" name="pkwt2_karyawan" placeholder="Masukkan PKWT 2 (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Ikut Penggajian*</label>
                            <select class="custom-select rounded-0" name="ikut_penggajian" id="ikut_penggajian" required>
                                <option value="Y">Ikut</option>
                                <option value="N">Tidak Ikut</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Kawin / Tidak Kawin*</label>
                            <input type="text" class="form-control" name="kawin_tdkkawin" id="kawin_tdkkawin" placeholder="Masukkan Kawin atau Tidak Kawin" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Gaji Pokok (Diisi jika gaji pokok tidak sama dengan UMK)</label>
                            <input type="number" class="form-control" name="gaji_pokok" id="gaji_pokok" placeholder="Masukkan Gaji Pokok (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tunjangan Jabatan*</label>
                            <input type="number" class="form-control" name="tunjangan_jabatan" id="tunjangan_jabatan" placeholder="Masukkan Tunjangan Jabatan" min="0" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">BPJS KESEHATAN*</label>
                            <select class="custom-select rounded-0" name="bpjs_kesehatan" required>
                                <option value="Y">Ikut Perusahaan</option>
                                <option value="N">Mandiri</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PLANT*</label>
                            <select class="custom-select rounded-0" name="plant" required>
                                <option value="Krian">Krian</option>
                                <option value="Mojoagung">Mojoagung</option>
                                <option value="Lamongan">Lamongan</option>
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
</body>
</html>