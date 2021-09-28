<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Jadwal Kerja</title>
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
            <h1 class="m-0">Jadwal Kerja</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">Jadwal Kerja</li>
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
            <h5 class="modal-title" id="exampleModalLabel">Hapus Jadwal Kerja</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('jadwal_kerja/hapus')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                  <p>Apakah anda yakin ingin menghapus Jadwal Kerja ini?</p>
                    <input type="text" class="form-control" id="id_jadwal_kerja" name="id_jadwal_kerja" hidden>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Nama Karyawan</label>
                          <input type="text" class="form-control" id="nama_karyawan" name="nama_karyawan" disabled>
                      </div>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Tanggal</label>
                          <input type="text" class="form-control" id="tanggal_jadwal" name="tanggal_jadwal" disabled>
                      </div>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Nama Jam Kerja</label>
                          <input type="text" class="form-control" id="nama_jam_kerja" name="nama_jam_kerja" disabled>
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
                  <div class="col-3">
                    <a href="/payroll/jadwal_kerja/input"><button type="button" class="btn btn-block btn-success"><i class="fas fa-plus"></i>  Input Jadwal Kerja</button></a>
                  </div>
                  <div class="col-9">
                  </div>
                  <div class="col-12">
                  <?php echo form_open_multipart('spreadsheet/import_jadwal',array('name' => 'spreadsheet')); ?>
                      <table style="margin-top: 10px;">
                          <tr>
                            <td><input type="file" size="40px" name="upload_file" /></td>
                            <td class="error"><?php echo form_error('name'); ?></td>
                            <td><input type="submit" value="Upload Jadwal"/></td>
                          </tr>
                      </table>
                    <?php echo form_close();?>
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
                    <th>ID Jadwal Kerja</th>
                    <th>Nama Karyawan</th>
                    <th>Nama Jam Kerja</th>
                    <th>Tanggal</th>
                    <th>Status</th>
                    <th>Changed By</th>
                    <th>Changed At</th>
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
                          echo "<td>".$row['nama_jam_kerja']."</td>";
                          echo "<td>".$row['tanggal_jadwal']."</td>";
                          if($row['status']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          echo "<td>".$row['change_by']."</td>";
                          echo "<td>".$row['change_at']."</td>";
                          echo '<td>
                                  <a href="/payroll/jadwal_kerja/edit/'.$row['id_jadwal'].'"><button type="button" class="btn btn-block btn-info"><i class="fas fa-edit"></i></button></a>
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                      data-id_jadwal_kerja="'.$row['id_jadwal'].'"
                                      data-nama_karyawan="'.$row['nama_karyawan'].'"
                                      data-nama_jam_kerja="'.str_replace("</br>"," ",$row['nama_jam_kerja']).'"
                                      data-tanggal_jadwal="'.$row['tanggal_jadwal'].'"
                                      ><button type="button" class="btn btn-block btn-danger"><i class="fas fa-trash-alt"></i></button></a>
                                </td>';
                    
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
      "responsive": true, "lengthChange": true, "autoWidth": false,
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
    var id_jadwal_kerja = button.data('id_jadwal_kerja')
    var nama_karyawan = button.data('nama_karyawan')
    var nama_jam_kerja = button.data('nama_jam_kerja')
    var tanggal_jadwal = button.data('tanggal_jadwal')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Hapus Jadwal Kerja')
    modal.find('#id_jadwal_kerja').val(id_jadwal_kerja)
    modal.find('#nama_karyawan').val(nama_karyawan)
    modal.find('#nama_jam_kerja').val(nama_jam_kerja)
    modal.find('#tanggal_jadwal').val(tanggal_jadwal)
  })
</script>

</body>
</html>