#PowerShell Comparação de Data e Hora


$localLog="C:\Scripts\scom\logs\VerificaHora.log"

$NTPExterno="a.st1.ntp.br"
$NTPInterno="unimed-ners.net"

if ((Test-Path $localLog) -eq "True")
{
del $localLog
}

$servidores="sun101.unimed-ners.net sun102.unimed-ners.net sun27.unimed-ners.net sun32.unimed-ners.net sun31.unimed-ners.net sun28.unimed-ners.net sun40.unimed-ners.net sun142.unimed-ners.net sun177.unimed-ners.net mssql-c2.unimed-ners.net sun21.unimed-ners.net sun22.unimed-ners.net sun23.unimed-ners.net sun24.unimed-ners.net sun47.unimed-ners.net sun87.unimed-ners.net sun88.unimed-ners.net sun84.unimed-ners.net sun85.unimed-ners.net" -split ' '
 

foreach ($servidor in $servidores)
{
    
    if (($servidor -eq "sun31.unimed-ners.net") -or ($servidor -eq "sun32.unimed-ners.net"))
    {

        $dataServidor = Invoke-Command -ComputerName $servidor -ScriptBlock {get-date}
        $dataServidor = $dataServidor -split ' ' -replace "[. , :]"
        $dataServidor = $dataServidor[1]
        $dataServidor = $dataServidor.substring(0,4)

        $dataNTP = w32tm /stripchart /computer:$NTPExt /dataonly /samples:1
        $dataNTP = $dataNTP -split ' ' -replace "[. , :]"
        $dataNTP = $dataNTP[11]
        $dataNTP = $dataNTP.substring(0,4)

     }
     else
     {
        
        $dataServidor = Invoke-Command -ComputerName $servidor -ScriptBlock {get-date}
        $dataServidor = $dataServidor -split ' ' -replace "[. , :]"
        $dataServidor = $dataServidor[1]
        $dataServidor = $dataServidor.substring(0,4)

        $dataNTP = w32tm /stripchart /computer:$NTPInterno /dataonly /samples:1
        $dataNTP = $dataNTP -split ' ' -replace "[. , :]"
        $dataNTP = $dataNTP[11]
        $dataNTP = $dataNTP.substring(0,4)
      }


    $servidorAdiantado="1"


    if ($dataNTP -gt $dataServidor)
    {
         $diferencaMinutos=$dataNTP-$dataServidor
         $servidorAdiantado="0"
    }
    else
    {
         $diferencaMinutos=$dataServidor-$dataNTP
    }


    if (($diferencaMinutos -gt "1") -and ($servidorAdiantado -eq "0"))
    {
        echo "ERRO: O Servidor $servidor está $diferencaMinutos minutos atrasado em relação ao servidor de NTP." >> $localLog
    }

    elseif (($diferencaMinutos -gt "1") -and ($servidorAdiantado -eq "1"))
    {
        echo "ERRO: O Servidor $servidor está $diferencaMinutos minutos adiantado em relação ao servidor de NTP." >> $localLog
    }


}

