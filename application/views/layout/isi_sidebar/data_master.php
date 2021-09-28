<?php if($_SESSION['role'] == '2'){ ?>
<li class="nav-item">
    <a href="/payroll/absensi" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Absensi</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/divisi" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Divisi</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/jabatan" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Jabatan</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/jam_kerja" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Jam Kerja</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/jadwal_kerja" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Jadwal Kerja</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/kalender" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Kalender</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/karyawan" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Karyawan</p>
    </a>
</li>
<!-- <li class="nav-item">
    <a href="/payroll/umk" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>UMK</p>
    </a>
</li> -->

<?php } elseif($_SESSION['role'] == '1') { ?>

    <li class="nav-item">
    <a href="/payroll/absensi" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Absensi</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/divisi" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Divisi</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/jabatan" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Jabatan</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/jam_kerja" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Jam Kerja</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/jadwal_kerja" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Jadwal Kerja</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/kalender" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Kalender</p>
    </a>
</li>
<li class="nav-item">
    <a href="/payroll/karyawan" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>Karyawan</p>
    </a>
</li>
<!-- <li class="nav-item">
    <a href="/payroll/umk" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>UMK</p>
    </a>
</li> -->
<li class="nav-item">
    <a href="/payroll/user" class="nav-link">
        <i class="far fa-circle nav-icon"></i>
        <p>User</p>
    </a>
</li>
<?php } ?>