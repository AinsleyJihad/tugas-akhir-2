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

    <!-- MODAL -->
    <div class="modal fade" id="modal_tunjangan_keluarga" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Masukkan Tunjangan Keluarga</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('penggajian/tunjangan_keluarga')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">ID Karyawan</label>
                        <input type="text" class="form-control" name="id_karyawan_tunjangan_keluarga" id="id_karyawan_tunjangan_keluarga" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">ID Pilih</label>
                        <input type="text" class="form-control" name="id_tunjangan_keluarga" id="id_tunjangan_keluarga" value="<?php echo $id_karyawan ?>" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                      <div class="row">
                        <div class="col-6">
                          <label for="exampleInputEmail1">Tahun</label>
                          <input type="text" class="form-control" name="tahun_tunjangan_keluarga" id="tahun_tunjangan_keluarga" value="<?php echo $tahun ?>" readonly></input>
                        </div>
                        <div class="col-6">
                          <label for="exampleInputEmail1">Bulan</label>
                          <input type="text" class="form-control" name="bulan_tunjangan_keluarga" id="bulan_tunjangan_keluarga" value="<?php echo $bulan ?>" readonly></input>
                        </div>
                      </div>
                    </div>
                    <div class="form-group">
                        <label for="exampleInputEmail1">Tunjangan Keluarga*</label>
                        <input type="number" class="form-control" name="tunjangan_keluarga" id="tunjangan_keluarga" placeholder="Masukkan Tunjangan Keluarga" min="0" required>
                        </input>
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


    <!-- MODAL -->
    <div class="modal fade" id="modal_ongkos_bongkar" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Masukkan Ongkos Bongkar</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('penggajian/ongkos_bongkar')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">ID Karyawan</label>
                        <input type="text" class="form-control" name="id_karyawan_ongkos_bongkar" id="id_karyawan_ongkos_bongkar" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">ID Pilih</label>
                        <input type="text" class="form-control" name="id_ongkos_bongkar" id="id_ongkos_bongkar" value="<?php echo $id_karyawan ?>" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                      <div class="row">
                        <div class="col-6">
                          <label for="exampleInputEmail1">Tahun</label>
                          <input type="text" class="form-control" name="tahun_ongkos_bongkar" id="tahun_ongkos_bongkar" value="<?php echo $tahun ?>" readonly></input>
                        </div>
                        <div class="col-6">
                          <label for="exampleInputEmail1">Bulan</label>
                          <input type="text" class="form-control" name="bulan_ongkos_bongkar" id="bulan_ongkos_bongkar" value="<?php echo $bulan ?>" readonly></input>
                        </div>
                      </div>
                    </div>
                    <div class="form-group">
                        <label for="exampleInputEmail1">Ongkos Bongkar* </label>
                        <input type="number" class="form-control" name="ongkos_bongkar" id="ongkos_bongkar" placeholder="Masukkan Ongkos Bongkar" min="0" required>
                        </input>
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

    <!-- MODAL -->
    <div class="modal fade" id="modal_ongkos_lain" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Masukkan Ongkos Lain</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('penggajian/ongkos_lain')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">ID Karyawan</label>
                        <input type="text" class="form-control" name="id_karyawan_ongkos_lain" id="id_karyawan_ongkos_lain" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                        <label for="exampleInputEmail1">ID Pilih</label>
                        <input type="text" class="form-control" name="id_ongkos_lain" id="id_ongkos_lain" value="<?php echo $id_karyawan ?>" readonly>
                        </input>
                    </div>
                    <div class="form-group" hidden>
                      <div class="row">
                        <div class="col-6">
                          <label for="exampleInputEmail1">Tahun</label>
                          <input type="text" class="form-control" name="tahun_ongkos_lain" id="tahun_ongkos_lain" value="<?php echo $tahun ?>" readonly></input>
                        </div>
                        <div class="col-6">
                          <label for="exampleInputEmail1">Bulan</label>
                          <input type="text" class="form-control" name="bulan_ongkos_lain" id="bulan_ongkos_lain" value="<?php echo $bulan ?>" readonly></input>
                        </div>
                      </div>
                    </div>
                    <div class="form-group">
                        <label for="exampleInputEmail1">Ongkos Lain-lain* </label>
                        <input type="number" class="form-control" name="ongkos_lain" id="ongkos_lain" placeholder="Masukkan Ongkos Lain-lain" min="0" required>
                        </input>
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
        <div class="row">
          <div class="col-12">

            <div class="card">
              <div class="card-header">
                <!-- <div class="row">
                  <div class="col-2">
                    <a href="/payroll/penggajian/input"><button type="button" class="btn btn-block btn-success"><i class="fas fa-plus"></i>  Input Gaji</button></a>
                  </div>
                </div> -->
                
                
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>No</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>ID KARYAWAN</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>NIK</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>NAMA KARYAWAN</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>DIVISI</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>JABATAN</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>PLANT</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>STATUS KARYAWAN</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>GAJI POKOK</b></th>
                    <th colspan="10" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>PENAMBAH GAJI</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>SUB TOTAL GAJI</b></th>
                    <th colspan="6" style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>TIDAK MASUK DI PERHITUNGAN GAJI</b></th>
                    <th colspan="8" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>PENGURANG GAJI</b></th>
                    <th rowspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#FFFF99"><b>GAJI DIBAYAR</b></th>
                  </tr>
                  <tr>
                    <th rowspan="3" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>Tunjangan Jabatan <?php echo $gaji[0]['tahun_ini'] ?></b></th>
                    <th rowspan="3" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>Tunjangan Keluarga <?php echo $gaji[0]['tahun_ini'] ?></b></th>
                    <th colspan="3" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>LEMBUR LIBUR</b></th>
                    <th colspan="3" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>LEMBUR BIASA</b></th>
                    <th rowspan="3" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>Ongkos Bongkar</b></th>
                    <th rowspan="3" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>Lain-lain</b></th>
                    <th colspan="6" style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>BPJS TANGGUNGAN PERUSAHAAN</b></th>
                    <th colspan="4" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>BPJS TANGGUNGAN KARYAWAN</b></th>
                    <th colspan="2" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>POTONGAN ABSEN</b></th>
                    <th rowspan="3" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>POTONGAN LAIN</b></th>
                    <th rowspan="3" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>SUB TOTAL PENGURANG GAJI</b></th>
                    </tr>
                  <tr>
                    <th rowspan="2" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>JAM PERIOD A</b></th>
                    <th rowspan="2" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>JAM PERIOD B</b></th>
                    <th rowspan="2" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>VALUE</b></th>
                    <th rowspan="2" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>JAM PERIOD A</b></th>
                    <th rowspan="2" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>JAM PERIOD B</b></th>
                    <th rowspan="2" style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>VALUE</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>JKK</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>JHT</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>JKM</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>JP</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>BPJS KESEHATAN</b></th>
                    <th style="vertical-align: middle; text-align: center;" rowspan="2" bgcolor="#FABF8F"><b>TOTAL</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>JHT</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>JP</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>BPJS KESEHATAN</b></th>
                    <th style="vertical-align: middle; text-align: center;" rowspan="2" bgcolor="#8DB3E2"><b>TOTAL</b></th>
                    <th style="vertical-align: middle; text-align: center;" rowspan="2" bgcolor="#8DB3E2"><b>DAYS</b></th>
                    <th style="vertical-align: middle; text-align: center;" rowspan="2" bgcolor="#8DB3E2"><b>VALUE</b></th>
                    </tr>
                  <tr>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>0.89%</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>3.70%</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>0.3%</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>2%</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#FABF8F"><b>4%</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>2%</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>1%</b></th>
                    <th style="vertical-align: middle; text-align: center;" bgcolor="#8DB3E2"><b>1%</b></th>
                  </tr>
                  
                  <!-- <tr>
                    <th rowspan="3">No</th>
                    <th rowspan="3">ID Karyawan</th>
                    <th rowspan="3">NIK</th>
                    <th rowspan="3">Nama Karyawan</th>
                    <th rowspan="3">Status Karyawan</th>
                    <th rowspan="3">Gaji Pokok</th>
                    <th colspan="10">Penambah Gaji</th>
                    <th rowspan="3">Sub Total Gaji</th>
                    <th colspan="6">Tidak Masuk Perhitungan Gaji</th>
                    <th colspan="8">Pengurang Gaji</th>
                    <th rowspan="3">Gaji Dibayar</th>   
                  </tr>
                  <tr>
                    <th rowspan="2">Tunjangan Jabatan</th>
                    <th rowspan="2">Tunjangan Keluarga</th>
                    <th colspan="3">Lembur Libur</th>
                    <th colspan="3">Lembur Biasa  </th>
                    <th rowspan="2">Ongkos Bongkar</th>
                    <th rowspan="2">Lain-lain</th>
                    <th colspan="6">BPJS Tanggungan Perusahaan</th>
                    <th colspan="4">BPJS Tanggungan Karyawan</th>
                    <th colspan="2">Potongan Absen</th>
                    <th rowspan="2">Potongan Lain</th>
                    <th rowspan="2">Sub Total Pengurangan Gaji</th>
                  </tr>
                  <tr>
                    <th>Jam Periode A</th>
                    <th rowspan="2">Tunjangan Keluarga</th>
                    <th colspan="3" rowspan="2">Lembur Libur</th>
                    <th colspan="3" rowspan="2">Lembur Biasa  </th>
                    <th rowspan="2">Ongkos Bongkar</th>
                    <th rowspan="2">Lain-lain</th>
                    <th colspan="6">BPJS Tanggungan Perusahaan</th>
                    <th colspan="4">BPJS Tanggungan Karyawan</th>
                    <th colspan="2">Potongan Absen</th>
                    <th rowspan="2">Potongan Lain</th>
                    <th rowspan="2">Sub Total Pengurangan Gaji</th>
                  </tr> -->
                  </thead>
                  <tbody>
                  <?php 
                      $seq = 1;
                      foreach ($gaji as $row) {
                        echo "<tr>";
                          echo "<td>".$seq."</td>";
                          echo '<td>'.$row['view_id'].'</td>';
                          echo "<td>".$row['nik']."</td>";
                          echo "<td>".$row['nama_karyawan']."</td>";
                          echo "<td>".$row['nama_divisi']."</td>";
                          echo "<td>".$row['nama_jabatan']."</td>";
                          echo "<td>".$row['plant']."</td>";
                          if($row['status_karyawan']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          echo "<td>".rupiah($row['gaji_pokok'])."</td>";
                          echo "<td>".rupiah($row['tunjangan_jabatan'])."</td>";

                          if($row['tunjangan_keluarga']=='N'){
                            echo '<td>
                                    <a href="" data-toggle="modal" data-target="#modal_tunjangan_keluarga"
                                    data-id="'.$row["id_karyawan"].'" >
                                      <button type="button" class="btn btn-block btn-primary btn-flat"><i class="fas fa-edit"></i><br>Input</button>
                                    </a>
                                  </td>';
                          }
                          else{
                            echo "<td>".rupiah($row['tunjangan_keluarga'])."</td>";
                          }

                          echo "<td>".$row['jam_lembur_libur_a']."</td>";
                          echo "<td>".$row['jam_lembur_libur_b']."</td>";
                          echo "<td>".rupiah($row['value_lembur_libur'])."</td>";
                          echo "<td>".$row['jam_lembur_biasa_a']."</td>";
                          echo "<td>".$row['jam_lembur_biasa_b']."</td>";
                          echo "<td>".rupiah($row['value_lembur_biasa'])."</td>";

                          if($row['ongkos_bongkar']=='N'){
                            echo '<td>
                                    <a href="" data-toggle="modal" data-target="#modal_ongkos_bongkar"
                                    data-id="'.$row["id_karyawan"].'" >
                                      <button type="button" class="btn btn-block btn-primary btn-flat"><i class="fas fa-edit"></i><br>Input</button>
                                    </a>
                                  </td>';
                          }
                          else{
                            echo "<td>".rupiah($row['ongkos_bongkar'])."</td>";
                          }


                          if($row['ongkos_lain']=='N'){
                            echo '<td>
                                    <a href="" data-toggle="modal" data-target="#modal_ongkos_lain"
                                    data-id="'.$row["id_karyawan"].'" >
                                    <button type="button" class="btn btn-block btn-primary btn-flat"><i class="fas fa-edit"></i><br>Input</button>
                                    </a>
                                  </td>';
                          }
                          else{
                            echo "<td>".rupiah($row['ongkos_lain'])."</td>";
                          }

                          echo "<td>".rupiah($row['sub_total_gaji'])."</td>";
                          echo "<td>".rupiah($row['bpjs_p_jkk'])."</td>";
                          echo "<td>".rupiah($row['bpjs_p_jht'])."</td>";
                          echo "<td>".rupiah($row['bpjs_p_jkm'])."</td>";
                          echo "<td>".rupiah($row['bpjs_p_jp'])."</td>";
                          echo "<td>".rupiah($row['bpjs_p_kesehatan'])."</td>";
                          echo "<td>".rupiah($row['bpjs_p_total'])."</td>";
                          echo "<td>".rupiah($row['bpjs_k_jht'])."</td>";
                          echo "<td>".rupiah($row['bpjs_k_jp'])."</td>";
                          echo "<td>".rupiah($row['bpjs_k_kesehatan'])."</td>";
                          echo "<td>".rupiah($row['bpjs_k_total'])."</td>";
                          echo "<td id='potong_days".($seq-1)."'>".$row['potongan_absen_days']."</td>";
                          echo "<td id='potong_value".($seq-1)."'>".rupiah($row['potongan_absen_value'])."</td>";
                          echo "<td>".rupiah($row['potongan_lain'])."</td>";
                          echo "<td id='sub_total".($seq-1)."'>".rupiah($row['sub_total_pengurang_gaji'])."</td>";
                          echo "<td id='gaji_dibayar".($seq-1)."'>".rupiah($row['gaji_dibayar'])."</td>";
                          // if($row['status_cuti']=='Y'){
                          //   echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          // }
                          // else{
                          //   echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          // }
                          // echo "<td>".$row['change_by']."</td>";
                          // echo "<td>".$row['change_at']."</td>";
                          // echo '<td>
                          //         <div class="row">
                          //           <div class="col-1">
                          //           </div>
                          //           <div class="col-5">
                          //             <a href="/payroll/cuti/edit/'.$row['id_cuti'].'"><button type="button" class="btn btn-block btn-info"><i class="fas fa-edit"></i></button></a>
                          //           </div>
                          //           <div class="col-5">
                          //           <a href="" data-toggle="modal" data-target="#exampleModal" 
                          //           data-id_cuti="'.$row['id_cuti'].'"
                          //           data-nama_karyawan="'.$row['nama_karyawan'].'"
                          //           ><button type="button" class="btn btn-block btn-danger"><i class="fas fa-trash-alt"></i></button></a>
                          //           </div>
                          //           <div class="col-1">
                          //           </div>
                          //         </div>
                          //       </td>';
                    
                        echo "</tr>";
                        $seq++;
                        }
                    ?>
                  </tbody>
                </table>
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





  <script>
  $('#modal_tunjangan_keluarga').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var id_karyawan = button.data('id');
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('#id_karyawan_tunjangan_keluarga').val(id_karyawan)
  })

  $('#modal_ongkos_bongkar').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var id_karyawan = button.data('id');
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('#id_karyawan_ongkos_bongkar').val(id_karyawan)
  })

  $('#modal_ongkos_lain').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var id_karyawan = button.data('id');
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('#id_karyawan_ongkos_lain').val(id_karyawan)
  })

  // $('#modal_tunjangan_keluarga').on('show.bs.modal', function (event) {
  //   var id_karyawan = button.data('id');
  //   var modal = $(this)
  //   modal.find('#id_karyawan_tunjangan_keluarga').val(id_karyawan)
  // })

  // $('#modal_ongkos_bongkar').on('show.bs.modal', function (event) {
  //   var modal = $(this);
  // })

  // $('#modal_ongkos_lain').on('show.bs.modal', function (event) {
  //   var modal = $(this);
  // })
  </script>



  <script>
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
  </script>



  

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

<?php

function rupiah($value) {
	$hasil = number_format($value,0,',','.');
	return $hasil;
}?>
</body>
</html>
