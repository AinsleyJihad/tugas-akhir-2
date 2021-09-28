<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Kalender</title>
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
            <h1 class="m-0">Kalender</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">Kalender</li>
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
          <form action="<?php echo base_url('kalender/hapus')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                  <p>Apakah anda yakin ingin menghapus kalender ini?</p>
                    <input type="text" class="form-control" id="id_kalender" name="id_kalender" hidden>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Nama Hari</label>
                          <input type="text" class="form-control" id="nama_hari" name="nama_hari" disabled>
                      </div>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Jenis Hari</label>
                          <input type="text" class="form-control" id="jenis_hari" name="jenis_hari" disabled>
                      </div>
                      <div class="form-group">
                          <div class="row">
                              <div class="col-6">
                                  <label for="exampleInputEmail1">Tanggal Mulai</label>
                                  <input type="text" class="form-control" id="tanggal_mulai" name="tanggal_mulai" disabled>
                              </div>
                              <div class="col-6">
                                  <label for="exampleInputEmail1">Tanggal Akhir</label>
                                  <input type="text" class="form-control" id="tanggal_akhir" name="tanggal_akhir" disabled>
                              </div>
                          </div>
                      </div>
                      <div class="form-group">
                          <label for="exampleInputEmail1">Total Hari</label>
                          <input type="text" class="form-control" id="jumlah_hari" name="jumlah_hari" disabled>
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
                    <a href="/payroll/kalender/input"><button type="button" class="btn btn-block btn-success"><i class="fas fa-plus"></i>  Input Kalender</button></a>
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
                    <th>Nama Hari</th>
                    <th>Jenis Hari</th>
                    <th>Tanggal Mulai</th>
                    <th>Tanggal Akhir</th>
                    <th>Jumlah Hari</th>
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
                          echo "<td>".$row['nama_hari']."</td>";
                          echo "<td>".$row['jenis_hari']."</td>";
                          echo "<td>".$row['tanggal_mulai']."</td>";
                          echo "<td>".$row['tanggal_akhir']."</td>";
                          echo "<td>".$row['jumlah_hari']."</td>";
                          if($row['status_kalender']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          echo "<td>".$row['change_by']."</td>";
                          echo "<td>".$row['change_at']."</td>";
                          echo '<td>
                                  <a href="/payroll/kalender/edit/'.$row['id_kalender'].'"><button type="button" class="btn btn-block btn-info"><i class="fas fa-edit"></i></button></a>
                                  <a href="" data-toggle="modal" data-target="#exampleModal" 
                                      data-id_kalender="'.$row['id_kalender'].'"
                                      data-nama_hari="'.$row['nama_hari'].'"
                                      data-jenis_hari="'.$row['jenis_hari'].'"
                                      data-tanggal_mulai="'.$row['tanggal_mulai'].'"
                                      data-tanggal_akhir="'.$row['tanggal_akhir'].'"
                                      data-jumlah_hari="'.$row['jumlah_hari'].'"
                                      ><button type="button" class="btn btn-block btn-danger"><i class="fas fa-trash-alt"></i></button>
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
    var id_kalender = button.data('id_kalender')
    var nama_hari = button.data('nama_hari')
    var jenis_hari = button.data('jenis_hari')
    var tanggal_mulai = button.data('tanggal_mulai')
    var tanggal_akhir = button.data('tanggal_akhir')
    var jumlah_hari = button.data('jumlah_hari')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Hapus Kalender')
    modal.find('#id_kalender').val(id_kalender)
    modal.find('#nama_hari').val(nama_hari)
    modal.find('#jenis_hari').val(jenis_hari)
    modal.find('#tanggal_mulai').val(tanggal_mulai)
    modal.find('#tanggal_akhir').val(tanggal_akhir)
    modal.find('#jumlah_hari').val(jumlah_hari)
  })
</script>
</body>
</html>