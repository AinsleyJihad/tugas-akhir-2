<!doctype html>
<html>
        <head>
            <title>Laporan Absensi</title>
        </head>
    <body>
        <div class="col-sm-6">
            <h1 class="m-0">Laporan Absensi</h1>
        </div>
        <div class="col-6">
            <h5> <?php 
                if($laporan[2]=="1000-01-01" && $laporan[3]==date('Y-m-d'))
                {
                   echo "<b>Nama Karyawan :</b> Semua</br>";
                   echo "<b>Nama Divisi :</b> Semua</br>";
                   echo "<b>Tanggal :</b> Semua</br>";
                }
                else{
                    if($laporan[0] == '0')
                    {
                      echo "<b>Nama Karyawan :</b> Semua</br>";
                    }
                    else
                    {
                        foreach($karyawan as $k)
                        {
                          if($k['id_karyawan'] == $laporan[0])
                            echo "<b>Nama Karyawan :</b> ".$k['nama_karyawan']."</br>";
                        }
                    }

                    if($laporan[1] == '0')
                    {
                      echo "<b>Nama Divisi :</b> Semua</br>";
                    }
                    else
                    {
                        foreach($divisi as $d)
                        {
                            if($d['id_divisi'] == $laporan[1])
                                echo "<b>Nama Divisi :</b> ".$d['nama_divisi']."</br>";
                        }
                    }

                    echo "<b>Tanggal :</b> ".date("d/m/Y", strtotime($laporan[2]))." - ".date("d/m/Y", strtotime($laporan[3]))."</br>";
                }
                ?>
            </h5>
        </div>
    </body>
    
    <style>
        .p1 {
            /* font-family: "Times New Roman", Times, serif; */
            font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
            font-size: 14px;
            margin-top: -20px;
        }

        .p2 {
            font-family: Calibri,Candara,Segoe,Segoe UI,Optima,Arial,sans-serif; 
            font-size: 10px;
            margin-top: 0px;
        }

        .p3 {
            font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
            font-size: 18px;
            margin-top: 0px;
        }

        .p4 {
            font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
            font-size: 12px;
            margin-top: 20px;
            text-align: right;
        }

        .p5 {
            font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
            font-size: 12px;
            text-align: left;
        }

        .sturdy {
            font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
            font-size: 12px;
        }

        .line {
            border-top: 1px solid black;
            width: 100px;
            margin-left: 115px;
            margin-top: 50px;
        }

        .container {
            margin-top: 0px;
            margin-bottom: 0px;
            margin-left: 30px;
            margin-right: 30px;
        }
        

        
    </style>
</html>
