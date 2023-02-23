#!/bin/bash 

tabla=$1
campo=$2
if [ "$tabla" == "" ]
then
  echo Uso: $0 {tabla_origen} {boleto_id|fecha_modificacion}
  echo El primer argumento es el nombre de la tabla a copiar
  echo El segundo argumento es el nombre del campo que se usara como referencia
  exit 1
fi

. config
. config.$campo

authtabla="AUTH_$tabla"
AUTH=${!authtabla}

maxval=$(mysql $AUTH_destino -NB -e "select max($campo) from $tabla")
if [ "$maxval" == "NULL" ]
then
  echo "$tabla obteniendo todos los boletos"
  mysqldump $DUMPARGS -t $AUTH --tables $tabla | mysql $COPYARGS $AUTH_destino
else
  echo "$tabla obteniendo boletos $campo>'$maxval'"
  mysqldump $DUMPARGS -t $AUTH --tables $tabla --where "$campo>'$maxval'" | mysql $COPYARGS $AUTH_destino
fi

