<?php

$view_id = '';
$tanggal_cuti = '';
$nama_karyawan = '';
$nama_jabatan = '';
// $nama_divisi = '';
$tanggal_mulai = '';
$tanggal_akhir = '';
// $hari = '';
// $jam_datang_keluar_ijin = '';
$alasan_cuti = '';
$ambil_cuti = '';
$sisa_cuti_lama = '';
$sisa_cuti_baru = '';
$no_iso = '';
foreach($cuti as $s)
{
    if($s['id_cuti'] == $id)
    {
        $view_id = $s['view_id'];
        // $id_karyawan = $s['id_karyawan'];
        $nama_karyawan = $s['nama_karyawan'];
        $nama_jabatan = $s['nama_jabatan'];
        // $nama_divisi = $s['nama_divisi'];
        $tanggal_cuti = $s['change_at'];
        $tanggal_mulai = $s['tanggal_mulai_cuti'];
        $tanggal_akhir = $s['tanggal_akhir_cuti'];
        // $jam_datang_keluar_ijin = $s['jam_datang_keluar_ijin'];
        $alasan_cuti = $s['alasan_cuti'];
        $ambil_cuti = $s['ambil_cuti'];
        $sisa_cuti_lama = $s['sisa_cuti_lama'];
        $sisa_cuti_baru = $s['sisa_cuti_baru'];
        $no_iso = $s['no_iso'];
    }
}
$tanggal_cuti = substr($tanggal_cuti,8, 2)."-".substr($tanggal_cuti,5, 2)."-".substr($tanggal_cuti,0, 4);
$tanggal_mulai = substr($tanggal_mulai,8, 2)."-".substr($tanggal_mulai,5, 2)."-".substr($tanggal_mulai,0, 4);
$tanggal_akhir = substr($tanggal_akhir,8, 2)."-".substr($tanggal_akhir,5, 2)."-".substr($tanggal_akhir,0, 4);

/*
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
*/
?>



<!doctype html>
<html><head>
    <title>Permohonan Cuti <?php echo $view_id; ?></title>
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
                text: 'PERMOHONAN CUTI\n\n',
                alignment: 'center',
                style: 'p3'
            },
            {
                text: 'Krian, <?php echo $tanggal_cuti; ?>',
                alignment: 'right',
                style: 'p4'
            },
            {
                style: 'cuti',
                color: '#000',
                table: {
                    widths: [105, 1, 100],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'Sisa Cuti', alignment: 'left', border: [false, false, false, false]}, {text: ':', alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $sisa_cuti_lama ?>', alignment: 'left', border: [false, false, false, false]}],
                        [{text: 'Cuti Yang Diajukan', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: ':', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $ambil_cuti ?>', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, true]}],
                        [{text: 'Sisa Cuti yang baru', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: ':', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $sisa_cuti_baru ?>', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, false]}],
                    ]
                }
		    },
            {
                text: 'Yang bertanda tangan di bawah ini :\n\n',
                style: 'p5'
            },
            {
                style: 'nama_jabatan',
                color: '#000',
                table: {
                    widths: [60, 1, 600],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'Nama', alignment: 'left', border: [false, false, false, false]}, {text: ':', alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $nama_karyawan ?>', alignment: 'left', border: [false, false, false, false]}],
                        [{text: 'Jabatan', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: ':', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, false]}, {text: '<?php echo $nama_jabatan ?>', margin: [0, 7, 0, 0], alignment: 'left', border: [false, false, false, false]}],
                    ]
                }
		    },
            {
                text: '\nBersama ini kami mengajukan cuti tahunan selama <?php echo $ambil_cuti; ?> hari,',
                style: 'p6'
            }
            ,
            {
                text: '\nmulai tanggal <?php echo $tanggal_mulai; ?> s/d tanggal <?php echo $tanggal_akhir; ?>',
                style: 'p6'
            },
            {
                text: '\nKeperluan : <?php echo $alasan_cuti; ?>',
                style: 'p6'
            },
            {
                text: '\nSekian Permohonan kami, dan terimakasih atas kebijaksanaannya.',
                style: 'p6'
            },
            {
			style: 'ttd',
			color: '#000',
			table: {
				widths: [60, 100, 140, 100, 60],
				// keepWithHeaderRows: 1,
				body: [
					[{text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Pemohon', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Menyetujui,', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}],
                    [{text: '', margin: [0, 40, 0, 0], alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, true]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, true]}, {text: '', alignment: 'center', border: [false, false, false, false]}],
                    [{text: '<?php echo $no_iso ?>', margin: [0, 7, 0, 0],colSpan: 5, alignment: 'right', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}],
				]
			}
		}

        ],
        


        styles: {
            p1: {
                fontSize: 12,
                bold: true,
                margin: [0, -10, 0, 0]
            },
            p2: {
                fontSize: 10,
                font: 'Helvetica',
                margin: [0, 3, 0, 0]
            },
            p3: {
                fontSize: 16,
                bold: true,
                font: 'Helvetica',
                margin: [0, 0, 0, 0]
            },
            p4: {
                fontSize: 11,
                margin: [0, 0, 0, 0]
            },
            p5: {
                fontSize: 11,
                margin: [6, 15, 0, 0]
            },
            p6: {
                fontSize: 11,
                margin: [6, 2, 0, 0]
            },
            cuti: {
                margin: [0, 7, 0, 0],
                fontSize: 11
            },
            nama_jabatan: {
                margin: [0, 0, 0, 0],
                fontSize: 11
            },
            ttd: {
                margin: [6, 10, 0, 0],
                fontSize: 11
            }
        },
        defaultStyle: {
            font: 'Helvetica'
        }
    };
    pdfMake.createPdf(docDefinition).download('<?php echo "Permohonan_Cuti_".$view_id ?>');
    
</script>

<script type="text/javascript">
    setTimeout(
    function ( )
    {
    self.close();
    }, 1000 );
</script>


</html>