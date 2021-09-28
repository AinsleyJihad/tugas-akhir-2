<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/*
| -------------------------------------------------------------------------
| URI ROUTING
| -------------------------------------------------------------------------
| This file lets you re-map URI requests to specific controller functions.
|
| Typically there is a one-to-one relationship between a URL string
| and its corresponding controller class/method. The segments in a
| URL normally follow this pattern:
|
|	example.com/class/method/id/
|
| In some instances, however, you may want to remap this relationship
| so that a different class/function is called than the one
| corresponding to the URL.
|
| Please see the user guide for complete details:
|
|	https://codeigniter.com/user_guide/general/routing.html
|
| -------------------------------------------------------------------------
| RESERVED ROUTES
| -------------------------------------------------------------------------
|$route['spreadsheet'] = 'PhpspreadsheetController';
$route['spreadsheet/import'] = 'PhpspreadsheetController/import';
$route['spreadsheet/export'] = 'PhpspreadsheetController/export';
| There are three reserved routes:
|
|	$route['default_controller'] = 'welcome';
|
| This route indicates which controller class should be loaded if the
| URI contains no data. In the above example, the "welcome" class
| would be loaded.
|
|	$route['404_override'] = 'errors/page_missing';
|
| This route will tell the Router which controller/method to use if those
| provided in the URL cannot be matched to a valid route.
|
|	$route['translate_uri_dashes'] = FALSE;
|
| This is not exactly a route, but allows you to automatically route
| controller and method names that contain dashes. '-' isn't a valid
| class or method name character, so it requires translation.
| When you set this option to TRUE, it will replace ALL dashes in the
| controller and method URI segments.
|
| Examples:	my-controller/index	-> my_controller/index
|		my-controller/my-method	-> my_controller/my_method
*/
$route['default_controller'] = 'c_login';
$route['index.php/login'] = 'c_login';
$route['check_login'] = 'c_login/LoginAction';
$route['login_error'] = 'c_login/login_error';
$route['logout'] = 'main/LogoutAction';


//coba spreadsheet
$route['spreadsheet'] = 'PhpspreadsheetController';
$route['spreadsheet/import'] = 'PhpspreadsheetController/import';
$route['spreadsheet/export'] = 'PhpspreadsheetController/export';
$route['spreadsheet/import_jadwal'] = 'PhpspreadsheetController/import_jadwal';

//API v1
//-------------------- Karyawan ------------------------
//$route['api/karyawan'] = 'c_Api_karyawan/index_get';
$route['api/karyawan/input'] = 'c_Api_karyawan/index_post';
// $route['api/karyawan/assass'] = 'c_Api_karyawan/index_get2';
// $route['api/karyawan/(:num)'] = 'c_Api_karyawan/index_get/$1';
// $route['api/karyawan/(:num)/$(:num)'] = 'c_Api_karyawan/index_get3/$1/$2';


//MASTER
//-------------------- Absensi ------------------------
$route['absensi'] = 'c_absensi';
$route['absensi/pilih_laporan'] = 'c_absensi/pilih_laporan';
$route['absensi/laporan'] = 'c_absensi/laporan';
$route['absensi/laporan_semua'] = 'c_absensi/laporan_semua';
$route['absensi/input/save']['post'] = 'c_absensi/save_absensi';
//$route['absensi/print/(:num)'] = 'c_absensi/print/$1';
$route['absensi/print'] = 'c_absensi/print';

//-------------------- Divisi -------------------------
$route['divisi'] = 'c_divisi';
$route['divisi/input'] = 'c_divisi/input';
$route['divisi/input/save']['post'] = 'c_divisi/save';
$route['divisi/edit/(:num)'] = 'c_divisi/edit/$1';
$route['divisi/edit/save/(:num)']['post'] = 'c_divisi/edit_save/$1';
$route['divisi/hapus']['post'] = 'c_divisi/hapus';

//-------------------- Jabatan -------------------------
$route['jabatan'] = 'c_jabatan';
$route['jabatan/input'] = 'c_jabatan/input';
$route['jabatan/input/save']['post'] = 'c_jabatan/save';
$route['jabatan/edit/(:num)'] = 'c_jabatan/edit/$1';
$route['jabatan/edit/save/(:num)']['post'] = 'c_jabatan/edit_save/$1';
$route['jabatan/hapus']['post'] = 'c_jabatan/hapus';

//-------------------- Jam Kerja -------------------------
$route['jam_kerja'] = 'c_jam_kerja';
$route['jam_kerja/input'] = 'c_jam_kerja/input';
$route['jam_kerja/input/save']['post'] = 'c_jam_kerja/save';
$route['jam_kerja/edit/(:num)'] = 'c_jam_kerja/edit/$1';
$route['jam_kerja/edit/save/(:num)']['post'] = 'c_jam_kerja/edit_save/$1';
$route['jam_kerja/hapus']['post'] = 'c_jam_kerja/hapus';

//-------------------- Jadwal Kerja -------------------------
$route['jadwal_kerja'] = 'c_jadwal_kerja';
$route['jadwal_kerja/input'] = 'c_jadwal_kerja/input';
$route['jadwal_kerja/input/save']['post'] = 'c_jadwal_kerja/save';
$route['jadwal_kerja/edit/(:num)'] = 'c_jadwal_kerja/edit/$1';
$route['jadwal_kerja/edit/save/(:num)']['post'] = 'c_jadwal_kerja/edit_save/$1';
$route['jadwal_kerja/hapus']['post'] = 'c_jadwal_kerja/hapus';

//-------------------- Kalender -------------------------
$route['kalender'] = 'c_kalender';
$route['kalender/input'] = 'c_kalender/input';
$route['kalender/input/save']['post'] = 'c_kalender/save';
$route['kalender/edit/(:num)'] = 'c_kalender/edit/$1';
$route['kalender/edit/save/(:num)']['post'] = 'c_kalender/edit_save/$1';
$route['kalender/hapus']['post'] = 'c_kalender/hapus';

//-------------------- Karyawan -------------------------
$route['karyawan'] = 'c_karyawan';
$route['karyawan/input'] = 'c_karyawan/input';
$route['karyawan/input/save']['post'] = 'c_karyawan/save';
$route['karyawan/edit/(:any)'] = 'c_karyawan/edit/$1';
$route['karyawan/edit/save/(:any)']['post'] = 'c_karyawan/edit_save/$1';
$route['karyawan/hapus']['post'] = 'c_karyawan/hapus';

//-------------------- UMK -------------------------
$route['umk'] = 'c_umk';
$route['umk/input'] = 'c_umk/input';
$route['umk/input/save']['post'] = 'c_umk/save';
$route['umk/edit/(:num)'] = 'c_umk/edit/$1';
$route['umk/edit/save/(:num)']['post'] = 'c_umk/edit_save/$1';
$route['umk/hapus']['post'] = 'c_umk/hapus';

//-------------------- User -------------------------
$route['user'] = 'c_user';
$route['user/input'] = 'c_user/input';
$route['user/input/save']['post'] = 'c_user/save';
$route['user/edit/(:num)'] = 'c_user/edit/$1';
$route['user/edit/save/(:num)']['post'] = 'c_user/edit_save/$1';
$route['user/hapus']['post'] = 'c_user/hapus';


//TRANSAKSI
//-------------------- Cuti -------------------------
$route['cuti'] = 'c_cuti';
$route['cuti/input'] = 'c_cuti/input';
$route['cuti/input/save']['post'] = 'c_cuti/save';
$route['cuti/ambilSisaCuti']['post'] = 'c_cuti/ambilSisaCuti';
$route['cuti/edit/(:num)'] = 'c_cuti/edit/$1';
$route['cuti/edit/save/(:num)']['post'] = 'c_cuti/edit_save/$1';
$route['cuti/hapus']['post'] = 'c_cuti/hapus';
$route['cuti/print/(:num)'] = 'c_cuti/print/$1';

//-------------------- Lembur -------------------------
$route['lembur'] = 'c_lembur';
$route['lembur/input'] = 'c_lembur/input';
$route['lembur/input/save']['post'] = 'c_lembur/save';
$route['lembur/edit/(:num)'] = 'c_lembur/edit/$1';
$route['lembur/edit/save/(:num)']['post'] = 'c_lembur/edit_save/$1';
$route['lembur/hapus']['post'] = 'c_lembur/hapus';
$route['lembur/print/(:num)'] = 'c_lembur/print/$1';

//-------------------- Potong Absen -------------------------
$route['potong_absen'] = 'c_potong_absen';
$route['potong_absen/input'] = 'c_potong_absen/input';
$route['potong_absen/input/save']['post'] = 'c_potong_absen/save';
$route['potong_absen/edit/(:num)'] = 'c_potong_absen/edit/$1';
$route['potong_absen/edit/save/(:num)']['post'] = 'c_potong_absen/edit_save/$1';
$route['potong_absen/hapus']['post'] = 'c_potong_absen/hapus';

//-------------------- Surat Sakit Dinas -------------------------
$route['suratsd'] = 'c_surat_sd';
$route['suratsd/input'] = 'c_surat_sd/input';
$route['suratsd/input/save']['post'] = 'c_surat_sd/save';
$route['suratsd/edit/(:num)'] = 'c_surat_sd/edit/$1';
$route['suratsd/edit/save/(:num)']['post'] = 'c_surat_sd/edit_save/$1';
$route['suratsd/hapus']['post'] = 'c_surat_sd/hapus';

//-------------------- Surat Izin -------------------------
$route['izin'] = 'c_izin';
$route['izin/input'] = 'c_izin/input';
$route['izin/input/save']['post'] = 'c_izin/save';
$route['izin/edit/(:num)'] = 'c_izin/edit/$1';
$route['izin/edit/save/(:num)']['post'] = 'c_izin/edit_save/$1';
$route['izin/hapus']['post'] = 'c_izin/hapus';
$route['izin/print/(:num)'] = 'c_izin/print/$1';
$route['izin/indexpersetujuankabag'] = 'c_izin/indexPersetujuanKabag';
$route['izin/persetujuankabag']['post'] = 'c_izin/persetujuanKabag';
$route['izin/penolakankabag']['post'] = 'c_izin/penolakanKabag';
$route['izin/indexpersetujuanhrd'] = 'c_izin/indexPersetujuanHrd';
$route['izin/persetujuanhrd']['post'] = 'c_izin/persetujuanHrd';
$route['izin/penolakanhrd']['post'] = 'c_izin/penolakanHrd';

//PENGGAJIAN
//-------------------- Penggajian -------------------------
$route['penggajian'] = 'c_penggajian';
$route['penggajian/input'] = 'c_penggajian/input';
$route['penggajian/edit'] = 'c_penggajian/edit';
$route['penggajian/totalLembur']['post'] = 'c_penggajian/totalLembur';
//$route['penggajian/potongAbsen']['post'] = 'c_penggajian/potongAbsen';
$route['penggajian/laporan'] = 'c_penggajian/laporan';
$route['penggajian/tunjangan_keluarga'] = 'c_penggajian/tunjangan_keluarga';
$route['penggajian/ongkos_bongkar'] = 'c_penggajian/ongkos_bongkar';
$route['penggajian/ongkos_lain'] = 'c_penggajian/ongkos_lain';

//RINCIAN REKAP LEMBUR
//-------------------- Rincian Rekap Lembur -------------------------
$route['rincian_rekap_lembur'] = 'c_rincian_rekap_lembur';
$route['rincian_rekap_lembur/pilih']['post'] = 'c_rincian_rekap_lembur/pilih';
$route['rincian_rekap_lembur/print/(:num)/(:num)/(:num)'] = 'c_rincian_rekap_lembur/print/$1/$2/$3';

//HISTORY
//-------------------- History Absensi -------------------------
$route['history_absensi'] = 'History/c_history_absensi';


//-------------------- History Divisi -------------------------
$route['history_divisi'] = 'History/c_history_divisi';

//-------------------- History Jabatan -------------------------
$route['history_jabatan'] = 'History/c_history_jabatan';

//-------------------- History Jam Kerja -------------------------
$route['history_jam_kerja'] = 'History/c_history_jam_kerja';

//-------------------- History Jadwal Kerja -------------------------
$route['history_jadwal_kerja'] = 'History/c_history_jadwal_kerja';

//-------------------- History Kalender -------------------------
$route['history_kalender'] = 'History/c_history_kalender';

//-------------------- History Karyawan -------------------------
$route['history_karyawan'] = 'History/c_history_karyawan';

//-------------------- History UMK -------------------------
$route['history_umk'] = 'History/c_history_umk';

//-------------------- History User -------------------------
$route['history_user'] = 'History/c_history_user';

//-------------------- History Lembur -------------------------
$route['history_lembur'] = 'History/c_history_lembur';

//-------------------- History Cuti -------------------------
$route['history_cuti'] = 'History/c_history_cuti';

//-------------------- History Surat Izin -------------------------
$route['history_surat_ijin'] = 'History/c_history_surat_ijin';

//-------------------- History Surat Izin -------------------------
$route['history_potong_absen'] = 'History/c_history_potong_absen';

//-------------------- History Penggajian -------------------------
$route['history_penggajian'] = 'History/c_history_penggajian';

$route['404_override'] = '';
$route['translate_uri_dashes'] = FALSE;
