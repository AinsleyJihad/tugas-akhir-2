<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Lembur</title>
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
            <h1 class="m-0">Lembur</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item active">Lembur</li>
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
            <h5 class="modal-title" id="exampleModalLabel">Hapus Lembur</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <form action="<?php echo base_url('lembur/hapus')?>" method="post">
            <div class="modal-body">
                <div class="card-body">
                  <p>Apakah anda yakin ingin menghapus lembur ini?</p>
                    <input type="text" class="form-control" id="id_lembur" name="id_lembur" placeholder="ID Lembur" hidden>
                    <div class="form-group">
                      <div class="row">
                          <div class="col-12">
                            <label for="exampleInputEmail1">Nama karyawan</label>
                            <input type="text" class="form-control" id="nama_karyawan" name="nama_karyawan" placeholder="Nama Karyawan" readonly>
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
        <div class="row">
          <div class="col-12">

            <div class="card">
              <div class="card-header">
                <div class="row">
                  <div class="col-2">
                    <a href="/payroll/lembur/input"><button type="button" class="btn btn-block btn-success"><i class="fas fa-plus"></i>  Input Lembur</button></a>
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
                    <th>Print</th>
                    <th>ID Lembur</th>
                    <th>Nama Karyawan</th>
                    <th>Divisi</th>
                    <th>Jabatan</th>
                    <th>Plant</th>
                    <th>Tanggal Lembur</th>
                    <th>Jam Mulai</th>
                    <th>Jam Akhir</th>
                    <th>Jam Lembur</th>
                    <th>Uraian Kerja</th>
                    <th>Persetujuan</th>
                    <th>No Iso</th>
                    <th>Status Lembur</th>
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
                          echo '<td>
                                   <a href="/payroll/lembur/print/'.$row['id_lembur'].'" target="_blank"><button type="button" class="btn btn-block btn-success"><i class="fas fa-print"></i></button></a>
                                </td>';
                          echo "<td>".$row['view_id']."</td>";
                          echo "<td>".$row['nama_karyawan']."</td>";
                          echo "<td>".$row['nama_divisi']."</td>";
                          echo "<td>".$row['nama_jabatan']."</td>";
                          echo "<td>".$row['plant']."</td>";
                          echo "<td>".$row['tanggal_lembur']."</td>";
                          echo "<td>".$row['jam_mulai']."</td>";
                          echo "<td>".$row['jam_akhir']."</td>";
                          echo "<td>".$row['ambil_jam']." Jam</td>";
                          echo "<td>".$row['uraian_kerja']."</td>";
                          echo "<td>".$row['persetujuan']."</td>";
                          echo "<td>".$row['no_iso']."</td>";
                          if($row['status_lembur']=='Y'){
                            echo'<td><button type="button" class="btn btn-block btn-success btn-flat">Aktif</button></td>';
                          }
                          else{
                            echo'<td><button type="button" class="btn btn-block btn-danger btn-flat">Tidak Aktif</button></td>';
                          }
                          echo "<td>".$row['change_by']."</td>";
                          echo "<td>".$row['change_at']."</td>";
                          echo '<td>
                                      <a href="/payroll/lembur/edit/'.$row['id_lembur'].'"><button type="button" class="btn btn-block btn-info"><i class="fas fa-edit"></i></button></a>

                                    <a href="" data-toggle="modal" data-target="#exampleModal" 
                                    data-id_lembur="'.$row['id_lembur'].'"
                                    data-nama_karyawan="'.$row['nama_karyawan'].'"
                                    ><button type="button" class="btn btn-block btn-danger"><i class="fas fa-trash-alt"></i></button></a>
                                   
                                  
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
    var id_lembur = button.data('id_lembur')
    var nama_karyawan = button.data('nama_karyawan')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Hapus Lembur')
    modal.find('#id_lembur').val(id_lembur)
    modal.find('#nama_karyawan').val(nama_karyawan)
  })
</script>
</body>
</html>