<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Karyawan</title>
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
            <h1 class="m-0">Karyawan</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">Karyawan</li>
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
            <h5 class="modal-title" id="exampleModalLabel">Hapus Kalender</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('karyawan/hapus')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                  <p>Apakah anda yakin ingin menghapus Karyawan ini?</p>
                    <input type="text" class="form-control" id="id_karyawan" name="id_karyawan" hidden>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Nama Karyawan</label>
                          <input type="text" class="form-control" id="nama_karyawan" name="nama_karyawan" disabled>
                      </div>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Divisi</label>
                          <input type="text" class="form-control" id="nama_divisi" name="nama_divisi" disabled>
                      </div>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Jabatan</label>
                          <input type="text" class="form-control" id="nama_jabatan" name="nama_jabatan" disabled>
                      </div>
                </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              <button type="submit" class="btn btn-danger">Hapus</button>
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
              <div class="card-header">
                <div class="row">
                  <div class="col-2">
                    <a href="/payroll/karyawan/input"><button type="button" class="btn btn-block btn-success"><i class="fas fa-plus"></i>  Input Karyawan</button></a>
                  </div>
                </div>
                
                
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <?php if($this->session->flashdata('msg')): ?>
                  <p><?php echo $this->session->flashdata('msg'); ?></p>
                <?php unset($_SESSION['msg']); endif; ?>
                <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>No</th>
                    <th>Aksi</th>
                    <th>Id Karyawan</th>
                    <th>Nama Karyawan</th>
                    <th>Pin</th>
                    <th>Divisi</th>
                    <th>Jabatan</th>
                    <th>Plant</th>
                    <th>NIK</th>
                    <th>Status Karyawan</th>
                  </tr>
                  </thead>
                  <tbody>
                  <?php 
                      $seq = 1;
                      foreach ($fetch as $row) {
                        echo "<tr>";
                          echo "<td>".$seq."</td>";
                          echo '<td>  
                                  <a href="/payroll/karyawan/edit/'.$row['id_karyawan'].'"><button type="button" class="btn btn-block btn-info"><i class="fas fa-edit"></i></button></a>
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                      data-id_karyawan="'.$row['id_karyawan'].'"
                                      data-nama_karyawan="'.$row['nama_karyawan'].'"
                                      data-nama_jabatan="'.$row['nama_jabatan'].'"
                                      data-nama_divisi="'.$row['nama_divisi'].'"
                                      ><button type="button" class="btn btn-block btn-danger"><i class="fas fa-trash-alt"></i></button>
                                </td>';
                          echo "<td>".$row['view_id']."</td>";
                          echo "<td>".$row['nama_karyawan']."</td>";
                          echo "<td>".$row['pin']."</td>";
                          echo "<td>".$row['nama_divisi']."</td>";
                          echo "<td>".$row['nama_jabatan']."</td>";
                          echo "<td>".$row['plant']."</td>";
                          echo "<td>".$row['nik']."</td>";
                          if($row['status_karyawan']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          
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
      "responsive": false, "lengthChange": true, "autoWidth": false,
      "buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"],
      "scrollX": true,
      "paging": false,
    }).buttons().container().appendTo('#example1_wrapper .col-md-6:eq(0)');
    $('#example2').DataTable({
      "paging": true,
      "lengthChange": true,
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
    var id_karyawan = button.data('id_karyawan')
    var nama_karyawan = button.data('nama_karyawan')
    var nama_jabatan = button.data('nama_jabatan')
    var nama_divisi = button.data('nama_divisi')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Hapus Karyawan')
    modal.find('#id_karyawan').val(id_karyawan)
    modal.find('#nama_karyawan').val(nama_karyawan)
    modal.find('#nama_jabatan').val(nama_jabatan)
    modal.find('#nama_divisi').val(nama_divisi)
  })
</script>

<?php

function rupiah($value) {
	$hasil = number_format($value,0,',','.');
	return $hasil;
}?>
</body>
</html>