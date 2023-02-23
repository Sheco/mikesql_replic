## Introduccion

Este repositorio incluye unos scripts para copiar una tabla de mysql de un host a otro.

Es basicamente un wrapper al rededor de mysqldump, lo único que hace de especial
es que primero se conecta al servidor destino (llamado `destino` aquí) para obtener el
valor mas alto del campo de referencia de la tabla a copiar, para luego ejecutar 
mysqldump en el servidor de origén copiando todos los elementos cuyo valor del campo de referencia
sea mayor al que se obtuvo anteriormente.

Este dump es enviado por una pipa directo al mysql del servidor destino, el cual
insertará los elementos en la base de datos.

El campo de referencia puede ser `boleto_id` o `fecha_modificacion`.


## Personalización
Se puede personalizar la configuracion para soportar mas tipos de campo de referencia
creando el archivo `config.campo` con valores similares a los otros dos.

## Instalación
Clonar este repositorio en algún lugar de un servidor.

## Configuración
Es necesario editar un archivo de configuración que contiene los argumentos de 
autenticación para conectarse a mysql de los distintos servidores.

Por ejemplo
```
AUTH_destino="-h 127.0.0.1 -u user2 password2"
AUTH_tablaorigen="-h 192.168.0.3 -u user3 password3"
```

En este ejemplo, la variable `AUTH_destino` incluye las credenciales para conectarse
al servidor destino, que probablemente sea el host local.

La variable `AUTH_tablaorigen` incluye las credenciales para conectarse al servidor que
contendra la tabla `tablaorigen`

Es necesario crear varias entradas `AUTH_` segun el nombre de la tabla a copiar, por ejemplo 
`AUTH_casetaAAA`, `AUTH_otratabla`.

## Uso

Una vez que tenemos bien configuradas las credenciales para conectarse a todos los
hosts, podemos usar el script mikesql_replic siguiendo la siguiente guía:

```
Uso: $0 {tablaorigen} {boleto_id|fecha_modificacion}
El primer argumento es el nombre de la tabla a copiar
El segundo argumento es el nombre del campo que se usara como referencia
```

## Ejecutar con toda una serie de servidores

Incluido en este repositorio, hay otro script, mikesql_replic_todo que sirve de 
conveniencia, pues se conecta al servidor destino y obtiene una lista de tablas
que quiere copiar y por cada una de estas, ejecuta el mikesql_replic.

## Errores

Si la tabla origen tiene una cantidad diferente de columnas, 
comaprada con la tabla destino, se generará el siguiente Errores

```
ERROR 1136 (21S01) at line 24: Column count doesn't match value count at row 1
```



