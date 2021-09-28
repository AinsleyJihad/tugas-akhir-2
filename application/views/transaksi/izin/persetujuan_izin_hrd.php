<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Surat Izin</title>
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
            <h1 class="m-0">Surat Izin</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">Surat Izin</li>
            </ol>
          </div><!-- /.col -->
          <!-- /. Lokasi Halaman -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- MODAL -->
    <div class="modal fade" id="exampleModal1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Persetujuan izin</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('izin/persetujuanhrd')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                  <p>Apakah anda yakin ingin menyetujui surat izin ini?</p>
                    <input type="text" class="form-control" id="id_surat_ijin" name="id_surat_ijin" placeholder="ID Surat Ijin" hidden>
                    <div class="form-group">
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">ID karyawan</label>
                            <input type="text" class="form-control" id="id_karyawan" name="id_karyawan" readonly>
                          </div>
                      </div>
                      <div class="row">
                          <div class="col-12">
                            <label for="exampleInputEmail1">Nama karyawan</label>
                            <input type="text" class="form-control" id="nama_karyawan" name="nama_karyawan" placeholder="Nama Karyawan" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Tanggal Izin</label>
                            <input type="text" class="form-control" id="tanggal_ijin" name="tanggal_ijin" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Alasan Izin</label>
                            <input type="text" class="form-control" id="alasan_ijin" name="alasan_ijin" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Pilih Jam</label>
                            <input type="text" class="form-control" id="pilih_jam" name="pilih_jam" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Jam Datang / Keluar Izin</label>
                            <input type="text" class="form-control" id="jam_datang_keluar_ijin" name="jam_datang_keluar_ijin" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Persetujuan Kabag</label>
                            <input type="text" class="form-control" id="persetujuan_kabag" name="persetujuan_kabag" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Persetujuan HRD</label>
                            <input type="text" class="form-control" id="persetujuan_hrd" name="persetujuan_hrd" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">No Iso</label>
                            <input type="text" class="form-control" id="no_iso" name="no_iso" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Status</label>
                            <input type="text" class="form-control" id="status_ijin" name="status_ijin" readonly>
                          </div>
                      </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              <button type="submit" class="btn btn-success">Setujui</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Persetujuan izin</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('izin/penolakanhrd')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                  <p>Apakah anda yakin ingin menolak surat izin ini?</p>
                    <input type="text" class="form-control" id="id_surat_ijin" name="id_surat_ijin" placeholder="ID Surat Ijin" hidden>
                    <div class="form-group">
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">ID karyawan</label>
                            <input type="text" class="form-control" id="id_karyawan" name="id_karyawan" readonly>
                          </div>
                      </div>
                      <div class="row">
                          <div class="col-12">
                            <label for="exampleInputEmail1">Nama karyawan</label>
                            <input type="text" class="form-control" id="nama_karyawan" name="nama_karyawan" placeholder="Nama Karyawan" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Tanggal Izin</label>
                            <input type="text" class="form-control" id="tanggal_ijin" name="tanggal_ijin" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Alasan Izin</label>
                            <input type="text" class="form-control" id="alasan_ijin" name="alasan_ijin" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Pilih Jam</label>
                            <input type="text" class="form-control" id="pilih_jam" name="pilih_jam" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Jam Datang / Keluar Izin</label>
                            <input type="text" class="form-control" id="jam_datang_keluar_ijin" name="jam_datang_keluar_ijin" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Persetujuan Kabag</label>
                            <input type="text" class="form-control" id="persetujuan_kabag" name="persetujuan_kabag" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Persetujuan HRD</label>
                            <input type="text" class="form-control" id="persetujuan_hrd" name="persetujuan_hrd" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">No Iso</label>
                            <input type="text" class="form-control" id="no_iso" name="no_iso" readonly>
                          </div>
                      </div>
                      <div class="row" hidden>
                          <div class="col-12">
                            <label for="exampleInputEmail1">Status</label>
                            <input type="text" class="form-control" id="status_ijin" name="status_ijin" readonly>
                          </div>
                      </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              <button type="submit" class="btn btn-danger">Tolak</button>
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
              <!-- /.card-header -->
              <div class="card-body">
                <?php if($this->session->flashdata('msg')): ?>
                  <p><?php echo $this->session->flashdata('msg'); ?></p>
                <?php unset($_SESSION['msg']); endif; ?>
                <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>No</th>
                    <th>ID Surat Izin</th>
                    <th>Nama Karyawan</th>
                    <th>Divisi</th>
                    <th>Tanggal Izin</th>
                    <th>Alasan Izin</th>
                    <th>Jam Datang/Keluar</th>
                    <th>Persetujuan</th>
                    <th>No Iso</th>
                    <th>Status</th>
                    <th>Change By</th>
                    <th>Change At</th> 
                    <th>Aksi</th>  
                  </tr>
                  </thead>
                  <tbody>
                  <?php 
                      $seq = 1;
                      foreach ($fetch as $row) {
                        echo "<tr>";
                          echo "<td>".$seq."</td>";
                          echo "<td>".$row['view_id']."</td>";
                          echo "<td>".$row['nama_karyawan']."</td>";
                          echo "<td>".$row['nama_divisi']."</td>";
                          echo "<td>".$row['tanggal_ijin']."</td>";
                          echo "<td>".$row['alasan_ijin']."</td>";
                          echo "<td>".$row['jam_datang_keluar_ijin']."</td>";
                          if($row['persetujuan_hrd']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Disetujui</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Belum</button></td>';
                          }
                          echo "<td>".$row['no_iso']."</td>";
                          if($row['status_ijin']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          echo "<td>".$row['change_by']."</td>";
                          echo "<td>".$row['change_at']."</td>";
                          echo '<td>
                                  <div class="row">
                                  <div class="col-6">
                                  <a href="" data-toggle="modal" data-target="#exampleModal1" 
                                  data-id_surat_ijin="'.$row['id_surat_ijin'].'"
                                  data-id_karyawan="'.$row['id_karyawan'].'"
                                  data-nama_karyawan="'.$row['nama_karyawan'].'"
                                  data-tanggal_ijin="'.$row['tanggal_ijin'].'"
                                  data-alasan_ijin="'.$row['alasan_ijin'].'"
                                  data-pilih_jam="'.$row['pilih_jam'].'"
                                  data-jam_datang_keluar_ijin="'.$row['jam_datang_keluar_ijin'].'"
                                  data-persetujuan_kabag="'.$row['persetujuan_kabag'].'"
                                  data-persetujuan_hrd="'.$row['persetujuan_hrd'].'"
                                  data-no_iso="'.$row['no_iso'].'"
                                  data-status_ijin="'.$row['status_ijin'].'"
                                  ><button type="button" class="btn btn-block btn-success"><i class="fas fa-check"></i></button></a>                                  </div>
                                  <div class="col-6">
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                  data-id_surat_ijin="'.$row['id_surat_ijin'].'"
                                  data-id_karyawan="'.$row['id_karyawan'].'"
                                  data-nama_karyawan="'.$row['nama_karyawan'].'"
                                  data-tanggal_ijin="'.$row['tanggal_ijin'].'"
                                  data-alasan_ijin="'.$row['alasan_ijin'].'"
                                  data-pilih_jam="'.$row['pilih_jam'].'"
                                  data-jam_datang_keluar_ijin="'.$row['jam_datang_keluar_ijin'].'"
                                  data-persetujuan_kabag="'.$row['persetujuan_kabag'].'"
                                  data-persetujuan_hrd="'.$row['persetujuan_hrd'].'"
                                  data-no_iso="'.$row['no_iso'].'"
                                  data-status_ijin="'.$row['status_ijin'].'"
                                  ><button type="button" class="btn btn-block btn-danger"><i class="fas fa-times"></i></button></a>
                                  </div>
                                  </div>
                                </td>';
                    
                        echo "</tr>";
                        $seq++;
                        }
                    ?>
                  </tbody>
                  <tfoot>
                  
                  </tfoot>
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
  $('#exampleModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var id_surat_ijin = button.data('id_surat_ijin')
    var id_karyawan = button.data('id_karyawan')
    var nama_karyawan = button.data('nama_karyawan')
    var tanggal_ijin = button.data('tanggal_ijin')
    var alasan_ijin = button.data('alasan_ijin')
    var jam_datang_keluar_ijin = button.data('jam_datang_keluar_ijin')
    var persetujuan_kabag = button.data('persetujuan_kabag')
    var persetujuan_hrd = button.data('persetujuan_hrd')
    var no_iso = button.data('no_iso')
    var status_ijin = button.data('status_ijin')
    var pilih_jam = button.data('pilih_jam')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Persetujuan Surat Ijin')
    modal.find('#id_surat_ijin').val(id_surat_ijin)
    modal.find('#id_karyawan').val(id_karyawan)
    modal.find('#nama_karyawan').val(nama_karyawan)
    modal.find('#tanggal_ijin').val(tanggal_ijin)
    modal.find('#alasan_ijin').val(alasan_ijin)
    modal.find('#jam_datang_keluar_ijin').val(jam_datang_keluar_ijin)
    modal.find('#persetujuan_kabag').val(persetujuan_kabag)
    modal.find('#persetujuan_hrd').val(persetujuan_hrd)
    modal.find('#no_iso').val(no_iso)
    modal.find('#status_ijin').val(status_ijin)
    modal.find('#pilih_jam').val(pilih_jam)
  })

    $('#exampleModal1').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget) // Button that triggered the modal
    var id_surat_ijin = button.data('id_surat_ijin')
    var id_karyawan = button.data('id_karyawan')
    var nama_karyawan = button.data('nama_karyawan')
    var tanggal_ijin = button.data('tanggal_ijin')
    var alasan_ijin = button.data('alasan_ijin')
    var jam_datang_keluar_ijin = button.data('jam_datang_keluar_ijin')
    var persetujuan_kabag = button.data('persetujuan_kabag')
    var persetujuan_hrd = button.data('persetujuan_hrd')
    var no_iso = button.data('no_iso')
    var status_ijin = button.data('status_ijin')
    var pilih_jam = button.data('pilih_jam')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Persetujuan Surat Ijin')
    modal.find('#id_surat_ijin').val(id_surat_ijin)
    modal.find('#id_karyawan').val(id_karyawan)
    modal.find('#nama_karyawan').val(nama_karyawan)
    modal.find('#tanggal_ijin').val(tanggal_ijin)
    modal.find('#alasan_ijin').val(alasan_ijin)
    modal.find('#jam_datang_keluar_ijin').val(jam_datang_keluar_ijin)
    modal.find('#persetujuan_kabag').val(persetujuan_kabag)
    modal.find('#persetujuan_hrd').val(persetujuan_hrd)
    modal.find('#no_iso').val(no_iso)
    modal.find('#status_ijin').val(status_ijin)
    modal.find('#pilih_jam').val(pilih_jam)
  })
</script>
</body>
</html>