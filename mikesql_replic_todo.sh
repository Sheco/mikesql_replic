#!/bin/bash
# Este script obtiene la lista de taquillas y ejecuta
# la replicación determinada en todas las taquillas al
# mismo tiempo
# Si se va a poner dentro de un cron cada minuto, se 
# recomendaria ponerlo con un timeout de un minuto para
# evitar que se ejecuten varios al mismo tiempo
# timeout 60 ./replic_todo.sh

BASE=$( dirname $0)
cd $BASE

campo=$1
if [ ! -e ./config.$campo ]
then
  echo "Campo de referencia invalido, se puede usar:"
  echo "boleto_id, fecha_modificacion"
  exit 1
fi

. config

# obtener la lista de taquillas
mysql $AUTH_destino -NB -e "select nombre from cmc_taquilla where old_replic=1 and !_hidden" | while read nombre
do ./mikesql_replic.sh caseta$nombre $campo &
done

wait
