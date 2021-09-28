<?php 

// echo "id_karyawan : ".$id."<br>";
// echo "tahun : ".$tahun."<br>";
// echo "bulan : ".$bulan."<br>";
// print_r($lembur);

$nama = "";
$divisi = "";
$bulan_nama = "";
$plant = "";
$gaji_per_jam = "";
$total_lembur_dan_uang_makan = "";
foreach($karyawan as $k)
{
    if($k['id_karyawan'] == $id)
    {
        $nama = $k['nama_karyawan'];
        $divisi = $k['nama_divisi'];
        $plant = $k['plant'];
    }
}

foreach($umk as $k)
{
    if($k['tahun_umk'] == $tahun)
    {
        if($k['plant'] == $plant)
        {
            $gaji_per_jam = $k['gaji_per_jam'];
        }
    }
}

if($bulan == '1')
    $bulan_nama = 'Januari';
else if($bulan == '2')
    $bulan_nama = 'Februari';
else if($bulan == '3')
    $bulan_nama = 'Maret';
else if($bulan == '4')
    $bulan_nama = 'April';
else if($bulan == '5')
    $bulan_nama = 'Mei';
else if($bulan == '6')
    $bulan_nama = 'Juni';
else if($bulan == '7')
    $bulan_nama = 'Juli';
else if($bulan == '8')
    $bulan_nama = 'Agustus';
else if($bulan == '9')
    $bulan_nama = 'September';
else if($bulan == '10')
    $bulan_nama = 'Oktober';
else if($bulan == '11')
    $bulan_nama = 'Nopember';
else if($bulan == '12')
    $bulan_nama = 'Desember';



$total_jam_lembur = 0;
$u_makan = 0;
$jumlah = 0;

foreach($lembur as $l)
{
    
    $total_jam_lembur = $total_jam_lembur + $l['ambil_jam'];
    if($l['ambil_jam'] >= 3)
    {
        $u_makan = $u_makan + 5000;
    }
    $jumlah++;
    
}

$total_lembur_dan_uang_makan = ($total_jam_lembur*$gaji_per_jam) + $u_makan;

// echo "<center>".$jumlah."</center><br>";

?>

<!doctype html>
<html><head>
    <title>Rincian Rekap Lembur <?php echo $nama_karyawan; ?></title>
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
            //1 Lembar
            <?php if($jumlah <= 12){?>
            {
                text: 'PT. JAYAMAS MEDICA INDUSTRI\n',
                style: 'p1'
            },
            {
                text: 'PERINCIAN REKAP LEMBUR\n\n',
                alignment: 'center',
                style: 'p2'
            },
            {
			style: 'nama',
			color: '#000',
			    table: {
                    widths: [50, 1, 204, 50, 1, 179],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'NAMA', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $nama_karyawan ?>', border: [false, false, false, false], alignment: 'left'}, {text: 'BULAN', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $bulan_nama ?>', border: [false, false, false, false]}],
                        [{text: 'Rp. <?php echo $hasil = number_format($gaji_per_jam,0,',','.'); ?>/jam', border: [false, false, false, false], margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left'}, {text: '', border: [false, false, false, false]}, {text: '', border: [false, false, false, false]}, {text: 'DIVISI', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: ':', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: '<?php echo $divisi ?>', border: [false, false, false, false], margin: [0, 5, 0, 0]}]
				    ]
			    }
            },
            {
			style: 'rekap',
			color: '#000',
			    table: {
                    widths: [20, 75, 45, 45, 45, 160, 65],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'No', alignment: 'center', margin: [0, 6, 0, 0]}, {text: 'Tanggal', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Jam ... s/d Jam ...', colSpan: 2, alignment: 'center', margin: [0, 6, 0, 0]}, '', {text: 'Total Jam', margin: [0, 3, 0, 0], alignment: 'center'}, {text: 'Keterangan (Mengerjakan)', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Paraf / Acc', margin: [0, 6, 0, 0], alignment: 'center'}]
                        <?php 
                            $seq =1;
                            foreach($lembur as $l)
                            { 
                            $tgl = substr($l['tanggal_lembur'],8, 2)."-".substr($l['tanggal_lembur'],5, 2)."-".substr($l['tanggal_lembur'],0, 4);
                        ?>
                       ,[{text: '<?php echo $seq ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $tgl ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_mulai'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_akhir'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['ambil_jam'] ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['uraian_kerja'] ?>', margin: [0, 3, 0, 0]}, '']
                        <?php $seq++; } ?>
                        
                        <?php
                            for($i = $seq; $i <= 12; $i++)
                            { 
                            ?>
                        ,[{text: '<?php echo $i ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '', '', '', '', '']
                        <?php } ?>
                        ,[{text: 'Total jam', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo $total_jam_lembur ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($u_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'Total Lembur & U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($total_lembur_dan_uang_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                    ]
			    }
            },
            {
                style: 'iso',
                color: '#000',
                table: {
                    widths: [37, 114, 47, 114, 47, 79, 22],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Form / HRD/ 014-rev00', italics: true, margin: [0, 5, 0, 0], alignment: 'right', colSpan: 3, border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]} ]
                    ]
                }
            }






            //2 Lembar
            <?php } else if($jumlah<=24){?>
            {
                text: 'PT. JAYAMAS MEDICA INDUSTRI\n',
                style: 'p1'
            },
            {
                text: 'PERINCIAN REKAP LEMBUR\n\n',
                alignment: 'center',
                style: 'p2'
            },
            {
			style: 'nama',
			color: '#000',
			    table: {
                    widths: [50, 1, 204, 50, 1, 179],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'NAMA', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $nama_karyawan ?>', border: [false, false, false, false], alignment: 'left'}, {text: 'BULAN', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $bulan_nama ?>', border: [false, false, false, false]}],
                        [{text: 'Rp. <?php echo $hasil = number_format($gaji_per_jam,0,',','.'); ?>/jam', border: [false, false, false, false], margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left'}, {text: '', border: [false, false, false, false]}, {text: '', border: [false, false, false, false]}, {text: 'DIVISI', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: ':', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: '<?php echo $divisi ?>', border: [false, false, false, false], margin: [0, 5, 0, 0]}]
				    ]
			    }
            },
            {
			style: 'rekap',
			color: '#000',
			    table: {
                    widths: [20, 75, 45, 45, 45, 160, 65],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'No', alignment: 'center', margin: [0, 6, 0, 0]}, {text: 'Tanggal', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Jam ... s/d Jam ...', colSpan: 2, alignment: 'center', margin: [0, 6, 0, 0]}, '', {text: 'Total Jam', margin: [0, 3, 0, 0], alignment: 'center'}, {text: 'Keterangan (Mengerjakan)', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Paraf / Acc', margin: [0, 6, 0, 0], alignment: 'center'}]
                        <?php 
                            $seq = 1;
                            $hitung = 1;
                            foreach($lembur as $l)
                            { 
                            $tgl = substr($l['tanggal_lembur'],8, 2)."-".substr($l['tanggal_lembur'],5, 2)."-".substr($l['tanggal_lembur'],0, 4);
                                if($hitung >= 1 && $hitung <= 12)
                                {
                        ?>
                       ,[{text: '<?php echo $seq ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $tgl ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_mulai'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_akhir'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['ambil_jam'] ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['uraian_kerja'] ?>', margin: [0, 3, 0, 0]}, '']
                        <?php $seq++; } 
                              $hitung++; }?>
                        
                        <?php
                            for($i = $seq; $i <= 12; $i++)
                            { 
                            ?>
                        ,[{text: '<?php echo $i ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '', '', '', '', '']
                        <?php } ?>
                        ,[{text: 'Total jam', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo $total_jam_lembur ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($u_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'Total Lembur & U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($total_lembur_dan_uang_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                    ]
			    }
            },
            {
                style: 'iso',
                color: '#000',
                table: {
                    widths: [37, 114, 47, 114, 47, 79, 22],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Form / HRD/ 014-rev00', italics: true, margin: [0, 5, 0, 0], alignment: 'right', colSpan: 3, border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]} ]
                    ]
                }
            },
            {text:'', pageBreak: 'after'},
            //Halaman 2
            {
                text: 'PT. JAYAMAS MEDICA INDUSTRI\n',
                style: 'p1'
            },
            {
                text: 'PERINCIAN REKAP LEMBUR\n\n',
                alignment: 'center',
                style: 'p2'
            },
            {
			style: 'nama',
			color: '#000',
			    table: {
                    widths: [50, 1, 204, 50, 1, 179],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'NAMA', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $nama_karyawan ?>', border: [false, false, false, false], alignment: 'left'}, {text: 'BULAN', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $bulan_nama ?>', border: [false, false, false, false]}],
                        [{text: 'Rp. <?php echo $hasil = number_format($gaji_per_jam,0,',','.'); ?>/jam', border: [false, false, false, false], margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left'}, {text: '', border: [false, false, false, false]}, {text: '', border: [false, false, false, false]}, {text: 'DIVISI', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: ':', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: '<?php echo $divisi ?>', border: [false, false, false, false], margin: [0, 5, 0, 0]}]
				    ]
			    }
            },
            {
			style: 'rekap',
			color: '#000',
			    table: {
                    widths: [20, 75, 45, 45, 45, 160, 65],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'No', alignment: 'center', margin: [0, 6, 0, 0]}, {text: 'Tanggal', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Jam ... s/d Jam ...', colSpan: 2, alignment: 'center', margin: [0, 6, 0, 0]}, '', {text: 'Total Jam', margin: [0, 3, 0, 0], alignment: 'center'}, {text: 'Keterangan (Mengerjakan)', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Paraf / Acc', margin: [0, 6, 0, 0], alignment: 'center'}]
                        <?php 
                            $seq = 1;
                            $hitung = 1;
                            foreach($lembur as $l)
                            { 
                                $tgl = substr($l['tanggal_lembur'],8, 2)."-".substr($l['tanggal_lembur'],5, 2)."-".substr($l['tanggal_lembur'],0, 4);
                                if($hitung >= 13 && $hitung <= 24)
                                {
                        ?>
                       ,[{text: '<?php echo $seq ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $tgl ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_mulai'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_akhir'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['ambil_jam'] ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['uraian_kerja'] ?>', margin: [0, 3, 0, 0]}, '']
                        <?php $seq++; } 
                              $hitung++; }?>
                        
                        <?php
                            for($i = $seq; $i <= 12; $i++)
                            { 
                            ?>
                        ,[{text: '<?php echo $i ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '', '', '', '', '']
                        <?php } ?>
                        ,[{text: 'Total jam', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo $total_jam_lembur ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($u_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'Total Lembur & U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($total_lembur_dan_uang_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                    ]
			    }
            },
            {
                style: 'iso',
                color: '#000',
                table: {
                    widths: [37, 114, 47, 114, 47, 79, 22],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Form / HRD/ 014-rev00', italics: true, margin: [0, 5, 0, 0], alignment: 'right', colSpan: 3, border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]} ]
                    ]
                }
            }







            //3 Lembar
            <?php } else if($jumlah<=36){?>
            {
                text: 'PT. JAYAMAS MEDICA INDUSTRI\n',
                style: 'p1'
            },
            {
                text: 'PERINCIAN REKAP LEMBUR\n\n',
                alignment: 'center',
                style: 'p2'
            },
            {
			style: 'nama',
			color: '#000',
			    table: {
                    widths: [50, 1, 204, 50, 1, 179],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'NAMA', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $nama_karyawan ?>', border: [false, false, false, false], alignment: 'left'}, {text: 'BULAN', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $bulan_nama ?>', border: [false, false, false, false]}],
                        [{text: 'Rp. <?php echo $hasil = number_format($gaji_per_jam,0,',','.'); ?>/jam', border: [false, false, false, false], margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left'}, {text: '', border: [false, false, false, false]}, {text: '', border: [false, false, false, false]}, {text: 'DIVISI', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: ':', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: '<?php echo $divisi ?>', border: [false, false, false, false], margin: [0, 5, 0, 0]}]
				    ]
			    }
            },
            {
			style: 'rekap',
			color: '#000',
			    table: {
                    widths: [20, 75, 45, 45, 45, 160, 65],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'No', alignment: 'center', margin: [0, 6, 0, 0]}, {text: 'Tanggal', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Jam ... s/d Jam ...', colSpan: 2, alignment: 'center', margin: [0, 6, 0, 0]}, '', {text: 'Total Jam', margin: [0, 3, 0, 0], alignment: 'center'}, {text: 'Keterangan (Mengerjakan)', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Paraf / Acc', margin: [0, 6, 0, 0], alignment: 'center'}]
                        <?php 
                            $seq = 1;
                            $hitung = 1;
                            foreach($lembur as $l)
                            { 
                            $tgl = substr($l['tanggal_lembur'],8, 2)."-".substr($l['tanggal_lembur'],5, 2)."-".substr($l['tanggal_lembur'],0, 4);
                                if($hitung >= 1 && $hitung <= 12)
                                {
                        ?>
                       ,[{text: '<?php echo $seq ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $tgl ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_mulai'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_akhir'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['ambil_jam'] ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['uraian_kerja'] ?>', margin: [0, 3, 0, 0]}, '']
                        <?php $seq++; } 
                              $hitung++; }?>
                        
                        <?php
                            for($i = $seq; $i <= 12; $i++)
                            { 
                            ?>
                        ,[{text: '<?php echo $i ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '', '', '', '', '']
                        <?php } ?>
                        ,[{text: 'Total jam', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo $total_jam_lembur ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($u_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'Total Lembur & U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($total_lembur_dan_uang_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                    ]
			    }
            },
            {
                style: 'iso',
                color: '#000',
                table: {
                    widths: [37, 114, 47, 114, 47, 79, 22],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Form / HRD/ 014-rev00', italics: true, margin: [0, 5, 0, 0], alignment: 'right', colSpan: 3, border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]} ]
                    ]
                }
            },
            {text:'', pageBreak: 'after'},
            //Halaman 2
            {
                text: 'PT. JAYAMAS MEDICA INDUSTRI\n',
                style: 'p1'
            },
            {
                text: 'PERINCIAN REKAP LEMBUR\n\n',
                alignment: 'center',
                style: 'p2'
            },
            {
			style: 'nama',
			color: '#000',
			    table: {
                    widths: [50, 1, 204, 50, 1, 179],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'NAMA', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $nama_karyawan ?>', border: [false, false, false, false], alignment: 'left'}, {text: 'BULAN', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $bulan_nama ?>', border: [false, false, false, false]}],
                        [{text: 'Rp. <?php echo $hasil = number_format($gaji_per_jam,0,',','.'); ?>/jam', border: [false, false, false, false], margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left'}, {text: '', border: [false, false, false, false]}, {text: '', border: [false, false, false, false]}, {text: 'DIVISI', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: ':', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: '<?php echo $divisi ?>', border: [false, false, false, false], margin: [0, 5, 0, 0]}]
				    ]
			    }
            },
            {
			style: 'rekap',
			color: '#000',
			    table: {
                    widths: [20, 75, 45, 45, 45, 160, 65],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'No', alignment: 'center', margin: [0, 6, 0, 0]}, {text: 'Tanggal', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Jam ... s/d Jam ...', colSpan: 2, alignment: 'center', margin: [0, 6, 0, 0]}, '', {text: 'Total Jam', margin: [0, 3, 0, 0], alignment: 'center'}, {text: 'Keterangan (Mengerjakan)', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Paraf / Acc', margin: [0, 6, 0, 0], alignment: 'center'}]
                        <?php 
                            $seq = 1;
                            $hitung = 1;
                            foreach($lembur as $l)
                            { 
                                $tgl = substr($l['tanggal_lembur'],8, 2)."-".substr($l['tanggal_lembur'],5, 2)."-".substr($l['tanggal_lembur'],0, 4);
                                if($hitung >= 13 && $hitung <= 24)
                                {
                        ?>
                       ,[{text: '<?php echo $seq ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $tgl ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_mulai'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_akhir'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['ambil_jam'] ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['uraian_kerja'] ?>', margin: [0, 3, 0, 0]}, '']
                        <?php $seq++; } 
                              $hitung++; }?>
                        
                        <?php
                            for($i = $seq; $i <= 12; $i++)
                            { 
                            ?>
                        ,[{text: '<?php echo $i ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '', '', '', '', '']
                        <?php } ?>
                        ,[{text: 'Total jam', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo $total_jam_lembur ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($u_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'Total Lembur & U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($total_lembur_dan_uang_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                    ]
			    }
            },
            {
                style: 'iso',
                color: '#000',
                table: {
                    widths: [37, 114, 47, 114, 47, 79, 22],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Form / HRD/ 014-rev00', italics: true, margin: [0, 5, 0, 0], alignment: 'right', colSpan: 3, border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]} ]
                    ]
                }
            },
            {text:'', pageBreak: 'after'},
            //Halaman 3
            {
                text: 'PT. JAYAMAS MEDICA INDUSTRI\n',
                style: 'p1'
            },
            {
                text: 'PERINCIAN REKAP LEMBUR\n\n',
                alignment: 'center',
                style: 'p2'
            },
            {
			style: 'nama',
			color: '#000',
			    table: {
                    widths: [50, 1, 204, 50, 1, 179],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'NAMA', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $nama_karyawan ?>', border: [false, false, false, false], alignment: 'left'}, {text: 'BULAN', border: [false, false, false, false]}, {text: ':', border: [false, false, false, false]}, {text: '<?php echo $bulan_nama ?>', border: [false, false, false, false]}],
                        [{text: 'Rp. <?php echo $hasil = number_format($gaji_per_jam,0,',','.'); ?>/jam', border: [false, false, false, false], margin: [0, 5, 0, 0], colSpan: 3, alignment: 'left'}, {text: '', border: [false, false, false, false]}, {text: '', border: [false, false, false, false]}, {text: 'DIVISI', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: ':', border: [false, false, false, false], margin: [0, 5, 0, 0]}, {text: '<?php echo $divisi ?>', border: [false, false, false, false], margin: [0, 5, 0, 0]}]
				    ]
			    }
            },
            {
			style: 'rekap',
			color: '#000',
			    table: {
                    widths: [20, 75, 45, 45, 45, 160, 65],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: 'No', alignment: 'center', margin: [0, 6, 0, 0]}, {text: 'Tanggal', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Jam ... s/d Jam ...', colSpan: 2, alignment: 'center', margin: [0, 6, 0, 0]}, '', {text: 'Total Jam', margin: [0, 3, 0, 0], alignment: 'center'}, {text: 'Keterangan (Mengerjakan)', margin: [0, 6, 0, 0], alignment: 'center'}, {text: 'Paraf / Acc', margin: [0, 6, 0, 0], alignment: 'center'}]
                        <?php 
                            $seq = 1;
                            $hitung = 1;
                            foreach($lembur as $l)
                            { 
                                $tgl = substr($l['tanggal_lembur'],8, 2)."-".substr($l['tanggal_lembur'],5, 2)."-".substr($l['tanggal_lembur'],0, 4);
                                if($hitung >= 25 && $hitung <= 36)
                                {
                        ?>
                       ,[{text: '<?php echo $seq ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $tgl ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_mulai'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo substr($l['jam_akhir'], 0, 5) ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['ambil_jam'] ?>', alignment: 'center', margin: [0, 3, 0, 0]}, {text: '<?php echo $l['uraian_kerja'] ?>', margin: [0, 3, 0, 0]}, '']
                        <?php $seq++; } 
                              $hitung++; }?>
                        
                        <?php
                            for($i = $seq; $i <= 12; $i++)
                            { 
                            ?>
                        ,[{text: '<?php echo $i ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '', '', '', '', '']
                        <?php } ?>
                        ,[{text: 'Total jam', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo $total_jam_lembur ?>', alignment: 'center', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($u_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                        ,[{text: 'Total Lembur & U/ Makan', margin: [70, 3, 0, 0], colSpan: 4, alignment: 'left', border: [false, false, false, false]}, '', '', '', {text: '<?php echo number_format($total_lembur_dan_uang_makan,0,',','.') ?>', alignment: 'right', margin: [0, 3, 0, 0]}, '', '']
                    ]
			    }
            },
            {
                style: 'iso',
                color: '#000',
                table: {
                    widths: [37, 114, 47, 114, 47, 79, 22],
                    // keepWithHeaderRows: 1,
                    body: [
                        [{text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: 'Form / HRD/ 014-rev00', italics: true, margin: [0, 5, 0, 0], alignment: 'right', colSpan: 3, border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]}, {text: '', alignment: 'center', border: [false, false, false, false]} ]
                    ]
                }
            }
            <?php } ?>



        ],
        


        styles: {
            p1: {
                fontSize: 12,
                font: 'Times',
                bold: true,
                margin: [-0, -15, -20, 0]
            },
            p2: {
                fontSize: 15,
                font: 'Times',
                margin: [-0, 12, -20, 0]
            },
            nama: {
                margin: [-0, -5, -20, 0],
                fontSize: 11
            },
            rekap: {
                margin: [-0, 2, -20, 0],
                fontSize: 11
            },
            iso: {
                margin: [-0, -5, -20, 0],
                fontSize: 9
            }
        },
        defaultStyle: {
            font: 'Helvetica'
        }
    };
    pdfMake.createPdf(docDefinition).download('<?php echo "Rincian_Rekap_lembur_".$nama_karyawan."_".$bulan."_".$tahun ?>');
    
</script>

<script type="text/javascript">
    setTimeout(
    function ( )
    {
    self.close();
    }, 1000 );
</script>


</html>