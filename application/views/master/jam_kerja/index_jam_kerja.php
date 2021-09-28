<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Jam Kerja</title>
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
            <h1 class="m-0">Jam Kerja</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">Jam Kerja</li>
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
            <h5 class="modal-title" id="exampleModalLabel">Hapus Jam Kerja</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('jam_kerja/hapus')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                  <p>Apakah anda yakin ingin menghapus Jam Kerja ini?</p>
                    <input type="text" class="form-control" id="id_jam_kerja" name="id_jam_kerja" placeholder="ID Jam Kerja" hidden>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Shift Kerja</label>
                            <input type="text" class="form-control" id="nama_jam_kerja" name="nama_jam_kerja" disabled>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Masuk</label>
                                    <input type="text" class="form-control" id="jam_masuk" name="jam_masuk" disabled>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Pulang</label>
                                    <input type="text" class="form-control" id="jam_pulang" name="jam_pulang" disabled>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Masuk Sabtu</label>
                                    <input type="text" class="form-control" id="jam_masuk_sabtu" name="jam_masuk_sabtu" disabled>
                                </div>
                                <div class="col-6">
                                    <label for="exampleInputEmail1">Jam Pulang Sabtu</label>
                                    <input type="text" class="form-control" id="jam_pulang_sabtu" name="jam_pulang_sabtu" disabled>
                                </div>
                            </div>
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
                    <a href="/payroll/jam_kerja/input"><button type="button" class="btn btn-block btn-success"><i class="fas fa-plus"></i>  Input Jam Keja</button></a>
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
                    <th>ID Jam Kerja</th>
                    <th>Nama Shift Kerja</th>
                    <th>Jam Masuk</th>
                    <th>Jam Pulang</th>
                    <th>Jam Masuk Sabtu</th>
                    <th>Jam Pulang Sabtu</th>
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
                          echo "<td>".$row['nama_jam_kerja']."</td>";
                          echo "<td>".$row['jam_masuk']."</td>";
                          echo "<td>".$row['jam_pulang']."</td>";
                          echo "<td>".$row['jam_masuk_sabtu']."</td>";
                          echo "<td>".$row['jam_pulang_sabtu']."</td>";
                          if($row['status_jam_kerja']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          echo "<td>".$row['change_by']."</td>";
                          echo "<td>".$row['change_at']."</td>";
                          echo '<td>
                                  <a href="/payroll/jam_kerja/edit/'.$row['id_jam_kerja'].'"><button type="button" class="btn btn-block btn-info"><i class="fas fa-edit"></i></button></a>
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                      data-id_jam_kerja="'.$row['id_jam_kerja'].'"
                                      data-nama_jam_kerja="'.$row['nama_jam_kerja'].'"
                                      data-jam_masuk="'.$row['jam_masuk'].'"
                                      data-jam_pulang="'.$row['jam_pulang'].'"
                                      data-jam_masuk_sabtu="'.$row['jam_masuk_sabtu'].'"
                                      data-jam_pulang_sabtu="'.$row['jam_pulang_sabtu'].'"
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
    var id_jam_kerja = button.data('id_jam_kerja')
    var nama_jam_kerja = button.data('nama_jam_kerja')
    var jam_masuk = button.data('jam_masuk')
    var jam_pulang = button.data('jam_pulang')
    var jam_masuk_sabtu = button.data('jam_masuk_sabtu')
    var jam_pulang_sabtu = button.data('jam_pulang_sabtu')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Hapus Jam Kerja')
    modal.find('#id_jam_kerja').val(id_jam_kerja)
    modal.find('#nama_jam_kerja').val(nama_jam_kerja)
    modal.find('#jam_masuk').val(jam_masuk)
    modal.find('#jam_pulang').val(jam_pulang)
    modal.find('#jam_masuk_sabtu').val(jam_masuk_sabtu)
    modal.find('#jam_pulang_sabtu').val(jam_pulang_sabtu)
  })
</script>
</body>
</html>