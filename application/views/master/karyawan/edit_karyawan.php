<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Edit Karyawan</title>
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
            <h1 class="m-0">Edit Karyawan</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/karyawan">Karyawan</a></li>
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
                <form action="<?php echo base_url('karyawan/edit/save/'.$karyawan[0]['id_karyawan']) ?>" method="post">
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">ID Karyawan</label>
                            <input type="text" class="form-control" id="id_karyawan" name="id_karyawan" placeholder="" value="<?php echo $karyawan[0]['view_id'] ?>" disabled>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Karyawan*</label>
                            <input type="text" class="form-control" name="nama_karyawan" value="<?php echo $karyawan[0]['nama_karyawan'] ?>" placeholder="Masukkan Nama Karyawan" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PIN Absensi*</label>
                            <input type="Number" class="form-control" name="pin" placeholder="Masukkan PIN Absensi" value="<?php echo $karyawan[0]['pin'] ?>" min="0" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jabatan*</label>
                            <select class="custom-select rounded-0" id="id_jabatan" name="id_jabatan" required>
                                <?php
                                foreach($jabatan as $j){ 
                                  echo"<option value='".$j['id_jabatan']."'>".$j['nama_jabatan']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Divisi*</label>
                            <select class="custom-select rounded-0" id="id_divisi" name="id_divisi" required>
                              <?php
                              foreach($divisi as $d){ 
                                echo"<option value='".$d['id_divisi']."'>".$d['nama_divisi']."</option>";
                              } ?>
                            </select>
                        </div>
                        <!-- 
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jam Kerja*</label>
                            <select class="custom-select rounded-0" id="id_jam_kerja" name="id_jam_kerja" required>
                              <?php
                              /*
                              foreach($shift as $k){ 
                                echo"<option value='".$k['id_jam_kerja']."'>".$k['nama_jam_kerja']." (".$k['jam_masuk']." - ".$k['jam_pulang'].")</option>";
                              } */?>
                            </select>
                        </div>
                        -->
                        <div class="form-group">
                            <label for="exampleInputEmail1">NIK</label>
                            <input type="number" class="form-control" name="nik" placeholder="Masukkan NIK" title="Harus Angka" value="<?php echo $karyawan[0]['nik'] ?>"> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">No. KTP*</label>
                            <input type="text" class="form-control" name="no_ktp" placeholder="Masukkan No. KTP" title="Harus Angka dan 16 Digit" pattern="[0-9]{16}" value="<?php echo $karyawan[0]['no_ktp'] ?>" required> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">NPWP</label>
                            <input type="text" class="form-control" name="npwp" placeholder="Masukkan NPWP (Tidak Wajib)" value="<?php echo $karyawan[0]['npwp'] ?>" title="Harus Angka dan 16 Digit" pattern="[0-9]{15}"> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jenis Kelamin*</label>
                            <select class="custom-select rounded-0" id="jenis_kelamin_karyawan" name="jenis_kelamin_karyawan" required>
                                <option value="L">Laki-laki</option>
                                <option value="P">Perempuan</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tanggal Masuk*</label>
                            <input type="date" class="form-control" name="tanggal_masuk_karyawan" value="<?php echo $karyawan[0]['tanggal_masuk_karyawan'] ?>" required> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tanggal Keluar</label>
                            <input type="date" class="form-control" name="tanggal_keluar_karyawan" value="<?php echo $karyawan[0]['tanggal_keluar_karyawan'] ?>"> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tanggal Pengangkatan</label>
                            <input type="date" class="form-control" name="tanggal_pengangkatan" value="<?php echo $karyawan[0]['tanggal_pengangkatan'] ?>"> 
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">No. Telpon</label>
                            <input type="number" class="form-control" name="telp_karyawan" placeholder="Masukkan No. Telpon (Tidak Wajib)" title="" value="<?php echo $karyawan[0]['telp_karyawan'] ?>" pattern="[0-9]{15}" min="0"> 
                            </input>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tempat Lahir</label>
                                    <input type="text" class="form-control" name="tempat_lahir_karyawan" value="<?php echo $karyawan[0]['tempat_lahir_karyawan'] ?>" placeholder="Tempat Lahir (Tidak Wajib)">
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Tanggal Lahir</label>
                                    <input type="date" class="form-control" name="tanggal_lahir_karyawan" value="<?php echo $karyawan[0]['tanggal_lahir_karyawan'] ?>" placeholder="Tanggal Lahir (Tidak Wajib)">
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Alamat</label>
                            <input type="text" class="form-control" name="alamat_karyawan" value="<?php echo $karyawan[0]['alamat_karyawan'] ?>" placeholder="Masukkan Alamat (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Pendidikan</label>
                            <input type="text" class="form-control" name="pendidikan" value="<?php echo $karyawan[0]['pendidikan'] ?>" placeholder="Masukkan Pendidikan (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Kontrak / Tetap*</label>
                            <select class="custom-select rounded-0" id="k_tk" name="k_tk" required>
                                <option value="Kontrak">Kontrak</option>
                                <option value="Tidak Kontrak">Tetap</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Jenis Karyawan*</label>
                            <select class="custom-select rounded-0" id="keterangan" name="keterangan" required>
                                <option value="Karyawan">Karyawan</option>
                                <option value="Outsourcing">Outsourcing</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PKWT 1</label>
                            <input type="text" class="form-control" name="pkwt1" value="<?php echo $karyawan[0]['pkwt1'] ?>" placeholder="Masukkan PKWT 1 (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PKWT 2</label>
                            <input type="text" class="form-control" name="pkwt2" value="<?php echo $karyawan[0]['pkwt2'] ?>" placeholder="Masukkan PKWT 2 (Tidak Wajib)">
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
                            <input type="text" class="form-control" name="kawin_tdkkawin" id="kawin_tdkkawin" value="<?php echo $karyawan[0]['kawin_tdkkawin'] ?>" placeholder="Masukkan Kawin atau Tidak Kawin" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Gaji Pokok (Diisi jika gaji pokok tidak sama dengan UMK)</label>
                            <input type="number" class="form-control" name="gaji_pokok" id="gaji_pokok" value="<?php echo $karyawan[0]['gaji_pokok'] ?>" placeholder="Masukkan Gaji Pokok (Tidak Wajib)">
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Status*</label>
                            <select class="custom-select rounded-0" id="status_karyawan" name="status_karyawan" required>
                                <option value="Y">Aktif</option>
                                <option value="N">Tidak Aktif</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Tunjangan Jabatan*</label>
                            <input type="number" class="form-control" name="tunjangan_jabatan" id="tunjangan_jabatan" placeholder="Masukkan Tunjangan Jabatan" value="<?php echo $karyawan[0]['tunjangan_jabatan'] ?>" min="0" required>
                            </input>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">BPJS KESEHATAN*</label>
                            <select class="custom-select rounded-0" name="bpjs_kesehatan" id="bpjs_kesehatan" required>
                                <option value="Y">Ikut Perusahaan</option>
                                <option value="N">Mandiri</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">PLANT*</label>
                            <select class="custom-select rounded-0" name="plant" id="plant" required>
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

<!-- Auto Input Form -->
<script>
    $(document).ready(function () {

      var sum = 0;
      <?php
      foreach($jabatan as $j){ ?>
          if(<?php echo $j['id_jabatan']; ?> == <?php echo $karyawan[0]['id_jabatan']; ?>)
          {
              //console.log('masuk'+sum);
              document.getElementById("id_jabatan").selectedIndex = sum;
              console.log("masuk");
          }
          else
          {
              sum = sum + 1;
              console.log("tidak masuk");
          }
      <?php
      } ?>

      
      sum = 0;
      <?php
      foreach($divisi as $d){ ?>
          if(<?php echo $d['id_divisi']; ?> == <?php echo $karyawan[0]['id_divisi']; ?>)
          {
              //console.log('masuk'+sum);
              document.getElementById("id_divisi").selectedIndex = sum;
          }
          else
          {
              sum = sum + 1;
          }
      <?php
      } ?>

      //document.getElementById("id_jabatan").selectedIndex = "<?php //echo $karyawan[0]['id_jabatan'] ?>"-1;
      //document.getElementById("id_divisi").selectedIndex = "<?php //echo $karyawan[0]['id_divisi'] ?>"-1;
      //document.getElementById("id_jam_kerja").selectedIndex = "<?php/* echo $karyawan[0]['id_jam_kerja'] */?>"-1;

      if("<?php echo $karyawan[0]['jenis_kelamin_karyawan'] ?>" == "L")
      {
          document.getElementById("jenis_kelamin_karyawan").selectedIndex = 0;
      }
      else
      {
          document.getElementById("jenis_kelamin_karyawan").selectedIndex = 1;
      }

      if("<?php echo $karyawan[0]['keterangan'] ?>" == "Karyawan")
      {
          document.getElementById("keterangan").selectedIndex = 0;
      }
      else
      {
          document.getElementById("keterangan").selectedIndex = 1;
      }
      

      if("<?php echo $karyawan[0]['k_tk'] ?>" == "Kontrak")
      {
          document.getElementById("k_tk").selectedIndex = 0;
      }
      else
      {
          document.getElementById("k_tk").selectedIndex = 1;
      }
      
      if("<?php echo $karyawan[0]['plant'] ?>" == "Krian")
      {
          document.getElementById("plant").selectedIndex = 0;
      }
      else if("<?php echo $karyawan[0]['plant'] ?>" == "Mojoagung")
      {
          document.getElementById("plant").selectedIndex = 1;
      }
      else
      {
          document.getElementById("plant").selectedIndex = 2;
      }

      if("<?php echo $karyawan[0]['bpjs_kesehatan'] ?>" == "Y")
      {
          document.getElementById("bpjs_kesehatan").selectedIndex = 0;
      }
      else
      {
          document.getElementById("bpjs_kesehatan").selectedIndex = 1;
      }

      if("<?php echo $karyawan[0]['ikut_penggajian'] ?>" == "Y")
      {
          document.getElementById("ikut_penggajian").selectedIndex = 0;
      }
      else
      {
          document.getElementById("ikut_penggajian").selectedIndex = 1;
      }

      if("<?php echo $karyawan[0]['status_karyawan'] ?>" == "Y")
      {
          document.getElementById("status_karyawan").selectedIndex = 0;
      }
      else
      {
          document.getElementById("status_karyawan").selectedIndex = 1;
      }
  });
</script>
</body>
</html>