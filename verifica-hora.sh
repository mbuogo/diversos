#!/bin/bash

rm -rf /opt/suporte/scripts/scom/monitorias/logs/VerificaHora.log

DataServidor=$(date | awk '{print substr($4,1,5)}' | sed 's/.//3')

DataNTP=$(ntpdate -q dominio.net | sed -n '3p' | awk '{print substr($3,1,5)}' | sed 's/.//3')

ServidorAdiantado=1

if [ $DataNTP -gt $DataServidor ]
then
        DiferencaMinutos=$(echo $DataNTP-$DataServidor | bc)
        ServidorAdiantado=0

else
        DiferencaMinutos=$(echo $DataServidor-$DataNTP | bc)
fi


if [ "$DiferencaMinutos" -gt "1" ]&&[ "$ServidorAdiantado" == "0" ]
then
        echo "ERRO: O Servidor está " $DiferencaMinutos " minutos atrasado em relação ao servidor de NTP." >> /opt/suporte/scripts/scom/monitorias/logs/VerificaHora.log

elif [ "$DiferencaMinutos" -gt "1" ]&&[ "$ServidorAdiantado" == "1" ]
then
         echo "ERRO: O Servidor está " $DiferencaMinutos " minutos adiantado  em relação ao servidor de NTP." >> /opt/suporte/scripts/scom/monitorias/logs/VerificaHora.log

fi
