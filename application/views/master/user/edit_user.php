<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Judul Halaman -->
  <title>Edit User</title>
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
            <h1 class="m-0">Edit User</h1>
          </div><!-- /.col -->
          <!-- Lokasi Halaman -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/payroll/main">Home</a></li>
              <li class="breadcrumb-item"><a href="/payroll/user">User</a></li>
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
                <form action="<?php echo base_url('user/edit/save/'.$user[0]['id_user']) ?>" method="post">
                    <div class="card-body">
                        <div class="form-group">
                            <label for="exampleInputEmail1">ID User</label>
                            <input type="text" class="form-control" id="id_user" name="id_user" placeholder="" value="<?php echo $user[0]['view_id'] ?>" disabled>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Nama Karyawan</label>
                            <select class="custom-select rounded-0" id="id_karyawan" name="id_karyawan" required>
                            <?php
                                foreach($karyawan as $k){ 
                                  echo"<option value='".$k['id_karyawan']."'>".$k['nama_karyawan']." - ".$k['id_karyawan']."</option>";
                                } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Username</label>
                            <input type="text" class="form-control" name="username" value="<?php echo $user[0]['username'] ?>" placeholder="Masukkan Username" required>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Password</label>
                            <input type="password" class="form-control" name="password_user" placeholder="Masukkan Password Baru" required>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Pilih Role*</label>
                            <select class="custom-select rounded-0" id="role" name="role" required>
                                <option value="1">Super Admin</option>
                                <option value="2">HRD</option>
                                <option value="3">Direktur Operasional</option>
                                <option value="4">Kabag</option>
                                <option value="5">Karyawan</option>
                                <option value="6">Admin</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Status*</label>
                            <select class="custom-select rounded-0" id="status_user" name="status_user" required>
                                <option value="Y">Aktif</option>
                                <option value="N">Tidak Aktif</option>
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
</script>

<!-- Auto Input Form -->
<script>
  $(document).ready(function () {
    var sum = 0;
    <?php
    foreach($karyawan as $k){ ?>
        if(<?php echo $k['id_karyawan'] ?> == <?php echo $user[0]['id_karyawan'] ?>)
        {
            //console.log('masuk'+sum);
            document.getElementById("id_karyawan").selectedIndex = sum;
        }
        else
        {
            sum = sum + 1;
        }
    <?php
    } ?>

    var status = "<?php echo $user[0]['status'] ?>";
    if(status == "Y")
    {
        document.getElementById("status_user").selectedIndex = 0;
    }
    else
    {
        document.getElementById("status_user").selectedIndex = 1;
    }

    var role = "<?php echo $user[0]['role'] ?>";
        if(role == "1")
        {
            document.getElementById("role").selectedIndex = 0;
        }else if(role == "2")
        {
            document.getElementById("role").selectedIndex = 1;
        }else if(role == "3")
        {
            document.getElementById("role").selectedIndex = 2;
        }else if(role == "4")
        {
            document.getElementById("role").selectedIndex = 3;
        }else if(role == "5")
        {
            document.getElementById("role").selectedIndex = 4;
        }else if(role == "6")
        {
            document.getElementById("role").selectedIndex = 5;
        }
        
  });
</script>

</body>
</html>