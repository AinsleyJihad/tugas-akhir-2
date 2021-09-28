<?php $uri = "asset/template/adminLTE/";
$user = $this->session->userdata('user');
$id_user = $this->session->userdata('id_user');
?>

<aside class="main-sidebar sidebar-dark-primary elevation-4">

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) -->
      <div class="image">
          <img src="<?php echo base_url('asset/icon/jmi_c.png')?>" class="img-circle elevation-2" alt="User Image" style="width: 110px; height: 110px; display: block; margin-left: auto; margin-right: auto; margin-top: 10%;">
          <a style="display: block; margin-left: auto; margin-right: auto; width: 25%; margin-top: 8%;"><?php echo $user ?></a>
        </div>
      <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        <!-- <div class="image">
          <img src="<?php echo base_url('asset/icon/user.png')?>" class="img-circle elevation-2" alt="User Image">
        </div>
        <div class="info">
          <a href="#" class="d-block"><?php echo $user ?></a>
        </div> -->
      </div>

      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
          
          <li class="nav-item">
            <a href="/payroll/main" class="nav-link">
              <i class="nav-icon fas fa-tachometer-alt"></i>
              <p>Dashboard</p>
            </a>
          </li>
          <?php if($_SESSION['role'] == '2'){ ?>
          <!-- Data Master -->
          <li class="nav-item menu-close">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-folder-open"></i>
              <p>
                Master Data
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <?php $this->load->view('layout/isi_sidebar/data_master')?>
            </ul>
          </li>

          <!-- Data Transaksi -->
          <li class="nav-item menu-close">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-money-bill-wave"></i>
              <p>
                Transaksi
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <?php $this->load->view('layout/isi_sidebar/data_transaksi')?>
            </ul>
          </li>
          
          
          
           <!-- Data Rekap Lembur -->
           <li class="nav-item">
            <a href="/payroll/rincian_rekap_lembur" class="nav-link">
              <i class="nav-icon fas fa-briefcase"></i>
              <p>Rincian Rekap Lembur</p>
            </a>
          </li>

          <!-- Data History -->
          <li class="nav-item menu-close">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-history"></i>
              <p>
                History
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <?php $this->load->view('layout/isi_sidebar/history')?>
            </ul>
          </li>

          <?php } elseif($_SESSION['role'] == '5' ){ ?>
          <!-- Data Transaksi -->
          <li class="nav-item">
            <a href="/payroll/lembur/input" class="nav-link">
              <i class="fas fa-briefcase nav-icon"></i>
                <p>Lembur</p>
            </a>
          </li>
          <li class="nav-item">
            <a href="/payroll/cuti/input" class="nav-link">
              <i class="fas fa-sticky-note nav-icon"></i>
              <p>Cuti</p>
            </a>
          </li>
          <li class="nav-item">
            <a href="/payroll/izin/input" class="nav-link">
              <i class="fas fa-envelope nav-icon"></i>
              <p>Surat Ijin</p>
            </a>
          </li>    

          <?php }elseif($_SESSION['role'] == '4' ) { ?>
          <li class="nav-item">
            <a href="/payroll/izin/indexpersetujuankabag" class="nav-link">
              <i class="fas fa-envelope nav-icon"></i>
              <p>Persetujuan Surat Ijin Kabag</p>
            </a>
          </li> 

          <?php }elseif($_SESSION['role'] == '1' ) { ?> 
            <li class="nav-item menu-close">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-folder-open"></i>
              <p>
                Master Data
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <?php $this->load->view('layout/isi_sidebar/data_master')?>
            </ul>
          </li>

          <!-- Data Transaksi -->
          <li class="nav-item menu-close">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-money-bill-wave"></i>
              <p>
                Transaksi
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <?php $this->load->view('layout/isi_sidebar/data_transaksi')?>
            </ul>
          </li>
          
          <!-- <li class="nav-item">
            <a href="/payroll/izin/indexpersetujuanhrd" class="nav-link">
              <i class="fas fa-envelope nav-icon"></i>
              <p>Persetujuan Surat Ijin HRD</p>
            </a>
          </li> 

          <li class="nav-item">
            <a href="/payroll/izin/indexpersetujuankabag" class="nav-link">
              <i class="fas fa-envelope nav-icon"></i>
              <p>Persetujuan Surat Ijin Kabag</p>
            </a>
          </li>  -->
          
           <!-- Data Rekap Lembur -->
           <li class="nav-item">
            <a href="/payroll/rincian_rekap_lembur" class="nav-link">
              <i class="nav-icon fas fa-briefcase"></i>
              <p>Rincian Rekap Lembur</p>
            </a>
          </li>

          <!-- Data History -->
          <li class="nav-item menu-close">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-history"></i>
              <p>
                History
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <?php $this->load->view('layout/isi_sidebar/history')?>
            </ul>
          </li>

          
          <?php } ?> 
        </ul>
      </nav>
      <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
  </aside>