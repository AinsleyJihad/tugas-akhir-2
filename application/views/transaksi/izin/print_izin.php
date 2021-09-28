<?php
$view_id = '';
$id_karyawan = '';
$tanggal_ijin = '';
$nama_karyawan = '';
$nama_jabatan = '';
$nama_divisi = '';
$tanggal = '';
$hari = '';
$jam_datang_keluar_ijin = '';
$alasan_ijin = '';
$pilih_jam = '';
$no_iso = '';
foreach($surat_ijin as $s)
{
    if($s['id_surat_ijin'] == $id)
    {
        $view_id = $s['view_id'];
        $id_karyawan = $s['id_karyawan'];
        $nama_karyawan = $s['nama_karyawan'];
        $nama_jabatan = $s['nama_jabatan'];
        $nama_divisi = $s['nama_divisi'];
        $tanggal = $s['tanggal_ijin'];
        $jam_datang_keluar_ijin = $s['jam_datang_keluar_ijin'];
        $alasan_ijin = $s['alasan_ijin'];
        $pilih_jam = $s['pilih_jam'];
        $no_iso = $s['no_iso'];
    }
}

$nama_karyawan = substr($nama_karyawan, 0, 18);
//echo $pilih_jam;



$tanggal = substr($tanggal,8, 2)."-".substr($tanggal,5, 2)."-".substr($tanggal,0, 4);

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

$jam_datang_keluar_ijin = substr($jam_datang_keluar_ijin ,0 , 5);
?>

<!doctype html>
<html><head>
    <title>Surat Ijin Terlambat Datang / Keluar <?php echo $view_id; ?></title>
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
                text: 'PT. Jayamas Medica Industri\n',
                style: 'p1'
            },
            {
                text: 'Jl. Raya By Pass KM 28, Krian - Sidoarjo\n\n',
                style: 'p2'
            },
            {
                text: '\nSURAT IJIN TERLAMBAT DATANG / IJIN KELUAR\n',
                alignment: 'center',
                style: 'p3'
            },
            {
                style: 'ijin',
                color: '#000',
                table: {
                    widths: [101, 1, 120, 83, 1, 56],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'Nama', alignment: 'left', border: [false, false, false, false]}, {text: ':', alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $nama_karyawan ?>', alignment: 'left', border: [false, false, false, false]}, {text: 'Jabatan / Bagian', alignment: 'left', border: [false, false, false, false]}, {text: ':', alignment: 'left', border: [false, false, false, false]}, {text: ['<?php echo $nama_jabatan." /"?>', '\n', '<?php echo $nama_divisi ?>'], rowSpan: 4, alignment: 'left', border: [false, false, false, false]}],
                        [{text: 'Hari / Tanggal', margin: [0, 5, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: ':', margin: [0, 5, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $hari." / ".$tanggal ?>', margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left', border: [false, false, false, false]},{text: '', alignment: 'left', border: [false, false, false, false]}, {text: '', alignment: 'left', border: [false, false, false, false]}, {text: '', alignment: 'left', border: [false, false, false, false]}],
                        [{text: ['Jam ', {text: 'Datang', <?php if($pilih_jam == "Jam Keluar"){echo "decoration: 'lineThrough'";} ?>}, ' / ', {text: 'Keluar', <?php if($pilih_jam == "Jam Datang"){echo "decoration: 'lineThrough'";} ?>}], margin: [0, 5, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: ':', margin: [0, 5, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $jam_datang_keluar_ijin ?>', margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left', border: [false, false, false, false]},{text: '', alignment: 'left', border: [false, false, false, false]}, {text: '', alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $jam_datang_keluar_ijin ?>', alignment: 'left', border: [false, false, false, false]}],
                        [{text: 'Alasan', margin: [0, 5, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: ':', margin: [0, 5, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $alasan_ijin ?>', margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left', border: [false, false, false, false]},{text: '', alignment: 'left', border: [false, false, false, false]}, {text: '', alignment: 'left', border: [false, false, false, false]}, {text: '', alignment: 'left', border: [false, false, false, false]}]
                    ]
                }
		    },
            {
			style: 'ttd',
			color: '#000',
			table: {
				widths: [10, 70, 65, 70, 65, 70, 10], 
				// keepWithHeaderRows: 1,
				body: [
					[{text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Mengetahui,', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Menyetujui,', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Pemohon,', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}],
                    [{text: '', margin: [0, 40, 0, 0], alignment: 'center', border: [false, false, false, false]}, {text: '', margin: [0, 40, 0, 0], alignment: 'center', border: [false, false, false, true]}, {text: '', margin: [0, 40, 0, 0], alignment: 'center', border: [false, false, false, false]}, {text: '', margin: [0, 40, 0, 0], alignment: 'center', border: [false, false, false, true]}, {text: '', margin: [0, 40, 0, 0], alignment: 'center', border: [false, false, false, false]}, {text: '', margin: [0, 40, 0, 0], alignment: 'center', border: [false, false, false, true]}, {text: '', margin: [0, 40, 0, 0], alignment: 'center', border: [false, false, false, false]}],
                    [{text: '<?php echo $no_iso ?>', margin: [0, 4, 0, 0], colSpan: 7, alignment: 'right', border: [false, false, false, false]}, '', '', '', '', '', '']
				]
			}
		}

        ],
        


        styles: {
            p1: {
                fontSize: 12,
                font: 'Times',
                bold: true,
                margin: [-10, -15, 115, 0]
            },
            p2: {
                fontSize: 10,
                font: 'Helvetica',
                margin: [-10, 3, 115, 0]
            },
            p3: {
                fontSize: 12,
                bold: true,
                font: 'Helvetica',
                decoration: 'underline',
                margin: [-10, -5, 115, 0]
            },
            p4: {
                fontSize: 11,
                margin: [-10, 25, 115, 0]
            },
            p5: {
                fontSize: 11,
                margin: [-10, 15, 115, 0]
            },
            p6: {
                fontSize: 11,
                margin: [-10, 2, 115, 0]
            },
            ijin: {
                margin: [-10, 30, 115, 0],
                fontSize: 11
            },
            ttd: {
                margin: [-10, 15, 115, 0],
                fontSize: 11
            }
        },
        defaultStyle: {
            font: 'Helvetica'
        }
    };
    pdfMake.createPdf(docDefinition).download('<?php echo "Surat_Ijin_".$view_id ?>');
    
</script>

<script type="text/javascript">
    setTimeout(
    function ( )
    {
    self.close();
    }, 1000 );
</script>


</html>