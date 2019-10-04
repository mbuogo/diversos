#PowerShell Comparação de Data e Hora


$localLog="C:\Scripts\scom\logs\VerificaHora.log"

$NTPExterno="a.st1.ntp.br"
$NTPInterno="unimed-ners.net"

if ((Test-Path $localLog) -eq "True")
{
del $localLog
}

$servidores="servidor1.net,servidor2.net" -split ' '
 

foreach ($servidor in $servidores)
{
    
    if (($servidor -eq "ad.nett") -or ($servidor -eq "ad2.net"))
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

