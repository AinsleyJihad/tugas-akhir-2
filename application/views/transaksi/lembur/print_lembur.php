
<?php


$view_id = '';
$nama_karyawan = '';
$nama_divisi = '';
$nama_jabatan = '';
$tanggal = '';
$jam_mulai = '';
$jam_akhir = '';
$uraian_kerja = '';
$tanggal_buat = '';
$no_iso = '';
foreach($lembur as $s)
{
    if($s['id_lembur'] == $id)
    {
        $view_id = $s['view_id'];
        $nama_karyawan = $s['nama_karyawan'];
        $nama_divisi = $s['nama_divisi'];
        $nama_jabatan = $s['nama_jabatan'];
        $tanggal = $s['tanggal_lembur'];
        $jam_mulai = $s['jam_mulai'];
        $jam_akhir = $s['jam_akhir'];
        $uraian_kerja = $s['uraian_kerja'];
        $tanggal_buat = $s['change_at'];
        $no_iso = $s['no_iso'];
    }
}

//ambil 2 nama awal
$nama = $nama_karyawan;
$check1 = strpos($nama, " ");
if($check1 == "")
{
	$nama = $nama;
}
else
{
	$nama1 = substr($nama, 0, $check1+1);
	$nama2 = substr($nama, $check1+1);
    //echo "nama 1 : ".$nama1."<br>";
    //echo "nama 2 : ".$nama2."<br>";
    $check2 = strpos($nama2, " ");
    //echo "check 2 : ".$check2."<br>";
    if($check2 == "")
    {
    	$nama = $nama;
    }
    else
    {
        $nama2 = substr($nama2, 0, $check2);
        //echo "nama 1 : ".$nama1."<br>";
        //echo "nama 2 : ".$nama2."<br>";
        $nama = $nama1.$nama2;
    }
}
//echo "<br>";
//echo "nama Fix : ".$nama."<br>";
$nama_karyawan = $nama;


$jam_mulai = substr($jam_mulai, 0, 5);
$jam_akhir = substr($jam_akhir, 0, 5);

$tanggal_buat = substr($tanggal_buat,8, 2)."-".substr($tanggal_buat,5, 2)."-".substr($tanggal_buat,0, 4);
// $tanggal_mulai = substr($tanggal_mulai,8, 2)."-".substr($tanggal_mulai,5, 2)."-".substr($tanggal_mulai,0, 4);
// $tanggal_akhir = substr($tanggal_akhir,8, 2)."-".substr($tanggal_akhir,5, 2)."-".substr($tanggal_akhir,0, 4);


// $timestamp = strtotime('2020-12-28');
$timestamp = strtotime($tanggal);

$hari = date('D', $timestamp);

if($hari == 'Sun')
    $hari = 'Minggu';
else if($hari == 'Sat')
    $hari = 'Sabtu';
else if($hari == 'Fri')
    $hari = 'Jumat';
else if($hari == 'Thu')
    $hari = 'Kamis';
else if($hari == 'Wed')
    $hari = 'Rabu';
else if($hari == 'Tue')
    $hari = 'Selasa';
else if($hari == 'Mon')
    $hari = 'Senin';

$tanggal = substr($tanggal,8, 2)."-".substr($tanggal,5, 2)."-".substr($tanggal,0, 4);

$uraian_kerja = substr($uraian_kerja, 0, 20);
/*
$jam_datang_keluar_ijin = substr($jam_datang_keluar_ijin ,0 , 5);
*/
?>

<!doctype html>
<html><head>
    <title>Surat Perintah Lembur <?php echo $view_id; ?></title>
  </head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.71/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.71/vfs_fonts.js"></script>
    
<body>


    
</body>
<script>
    pdfMake.fonts = {
        Helvetica: {
            normal: '<?php echo base_url('asset/font/arial.TTF')?>',
            bold: '<?php echo base_url('asset/font/arial_bold.ttf')?>',
            italics: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-Italic.ttf',
            bolditalics: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-MediumItalic.ttf'
        },
        Times: {
            normal: '<?php echo base_url('asset/font/times_new_roman_bold.TTF')?>',
            bold: '<?php echo base_url('asset/font/times_new_roman_bold.TTF')?>',
            italics: '<?php echo base_url('asset/font/times_new_roman_bold.TTF')?>',
            bolditalics: '<?php echo base_url('asset/font/times_new_roman_bold.TTF')?>'
        }
    };

    var docDefinition ={
        content: [
            {
                text: 'PT. JAYAMAS MEDICA INDUSTRI\n',
                style: 'p1'
            },
            {
                text: 'Jl. Raya By Pass KM 28, Krian - Sidoarjo\n\n',
                style: 'p2'
            },
            {
                text: 'SURAT PERINTAH LEMBUR\n\n',
                alignment: 'center',
                style: 'p3'
            },
            {
                columns: [
                    {
                        width: 60,
                        text: 'Hari / Tgl',
                        margin: [-20, 0, 0, 0],
                        fontSize: 9
                    },
                    {
                        width: 10,
                        text: ':',
                        fontSize: 9
                    },
                    {
                        width: '*',
                        text: '<?php echo $hari.' / '.$tanggal; ?>',
                        fontSize: 9
                    },
                ]
            },
            {
                columns: [
                    {
                        width: 60,
                        text: 'Divisi',
                        margin: [-20, 5, 0, 0],
                        fontSize: 9
                    },
                    {
                        width: 10,
                        text: ':',
                        margin: [0, 5, 0, 0],
                        fontSize: 9
                    },
                    {
                        width: '*',
                        text: '<?php echo $nama_divisi; ?>',
                        margin: [0, 5, 0, 0],
                        fontSize: 9
                    },
                ]
            },
            {
			style: 'tableExample',
			color: '#000',
			table: {
				widths: [25, 130, 60, 60, 165, 60],
				// keepWithHeaderRows: 1,
				body: [
					[{text: 'No', rowSpan: 2, alignment: 'center', margin: [0, 5, 0, 0]}, {text: 'Nama', rowSpan: 2, margin: [0, 5, 0, 0], alignment: 'center'}, {text: 'Jam', colSpan: 2, alignment: 'center'}, '', {text: 'Uraian Kerja', rowSpan: 2, margin: [0, 5, 0, 0], alignment: 'center'}, {text: 'TTD', rowSpan: 2, margin: [0, 5, 0, 0], alignment: 'center'}],
					['', '', {text: 'Mulai', alignment: 'center'}, {text: 'Akhir', alignment: 'center'}, '', '']
		
				]
			}
		},
		{
			style: 'isiTable',
			color: '#000',
			table: {
				widths: [25, 130, 60, 60, 165, 60],
				// keepWithHeaderRows: 1,
				body: [
					[{text: '1', alignment: 'center'}, {text: '<?php echo $nama_karyawan ?>', alignment: 'center'}, {text: '<?php echo $jam_mulai ?>', alignment: 'center'}, {text: '<?php echo $jam_akhir ?>', alignment: 'center'}, {text: '<?php echo $uraian_kerja; ?>', alignment: 'center'}, {text: '', alignment: 'center'}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}],
					['', '', '', '', '', {text: '', margin: [0, 10, 0, 0]}]
				]
			}
		},
		{text: 'Krian, <?php echo $tanggal_buat ?>', margin: [-20, 0, 0, 0], fontSize: 9},
		{
			style: 'ttd',
			color: '#000',
			table: {
				widths: [32, 114, 42, 114, 42, 114, 32],
				// keepWithHeaderRows: 1,
				body: [
					[{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Menyetujui', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Mengetahui', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}],
					[{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, true]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, true]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, true]}, {text: '', alignment: 'center', border: [false, false, false, false], margin: [0, 40, 0, 0]} ],
					[{text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Kabag.', margin: [0, 2, 0, 0], alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Direktur Operasional', margin: [0, 2, 0, 0], alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'HRD', margin:[0, 2, 0, 0], alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]} ],
					[{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '<?php echo $no_iso ?>', margin: [0, 10, 0, 0], alignment: 'right', colSpan: 3, border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]} ]
				]
			}
		}

        ],
        


        styles: {
            p1: {
                fontSize: 12,
                bold: true,
                margin: [-20, -20, -20, 0]
            },
            p2: {
                fontSize: 10,
                font: 'Helvetica',
                margin: [-20, 3, -20, 0]
            },
            p3: {
                fontSize: 14,
                font: 'Times',
                margin: [-20, 0, -20, 0]
            },
            p4: {
                fontSize: 10,
                margin: [-20, 0, -20, 0]
            },
            tableExample: {
                margin: [-20, 8, -20, 0],
                fontSize: 10
            },
            isiTable: {
                margin: [-20, 5, -20, 10],
                fontSize: 10
            },
            ttd: {
                margin: [-20, 5, -20, 0],
                fontSize: 10
            }
        },
        defaultStyle: {
            font: 'Helvetica'
        }
    };
    pdfMake.createPdf(docDefinition).download('<?php echo "Surat_Perintah_Lembur_".$view_id ?>');
    
</script>

<script type="text/javascript">
    setTimeout(
    function ( )
    {
    self.close();
    }, 1000 );
</script>


</html>