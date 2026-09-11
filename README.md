# Proyecto Big Data - Análisis del mercado de videojuegos de Steam

## Módulo de Ingesta y Almacenamiento

Responsable: Benjamín Herrera

Este módulo se encarga de preparar, organizar e ingresar los datos del proyecto hacia el ecosistema Hadoop.

---

## 1. Dataset

Fuente original:

Steam Games Dataset.

El dataset fue obtenido en formato JSON debido a problemas de desplazamiento de columnas detectados en el archivo CSV original.

Cantidad de registros procesados:

140899

Cantidad de columnas seleccionadas:

27

El archivo fue transformado a formato TSV mediante Python para facilitar su carga en MySQL y posteriormente su ingestión con Sqoop.

---

## 2. Estructura HDFS

Se creó la siguiente estructura:

/user/cloudera/proyecto/raw  
/user/cloudera/proyecto/processed  
/user/cloudera/proyecto/staging  
/user/cloudera/proyecto/output  

Objetivo:

- raw: datos originales o recién ingeridos
- processed: datos procesados
- staging: datos intermedios
- output: resultados finales

---

## 3. Sqoop

Sqoop fue utilizado para importar los datos desde MySQL hacia HDFS.

Origen:

MySQL  
Base de datos: steam_project  
Tabla: games  

Destino:

/user/cloudera/proyecto/raw/games_sqoop

Resultado:

140899 registros importados correctamente.

Validación:

Los 140899 registros poseen 27 columnas.

---
## 4. Flume

Apache Flume fue utilizado para simular la ingestión automática de eventos hacia HDFS.

Flujo utilizado:

Spool Directory Source  
↓  
Memory Channel  
↓  
HDFS Sink

Carpeta monitoreada:

/home/cloudera/flume_spool

Destino HDFS:

/user/cloudera/proyecto/raw/flume

Ejemplo de eventos:

1583070|launch|120  
1575230|purchase|1  
684230|launch|85  
2932920|review_positive|1  
2628170|launch|40  

El archivo fue procesado correctamente por Flume y almacenado en HDFS.

---
## 5. Archivos principales

dataset/preparar_dataset.py  
hdfs/comandos_hdfs.sh  
sqoop/import_steam.sh  
flume/flume.conf  

---
