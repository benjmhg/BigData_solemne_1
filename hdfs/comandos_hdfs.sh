#!/bin/bash

# Crear estructura principal del proyecto en HDFS
hdfs dfs -mkdir -p /user/cloudera/proyecto/raw
hdfs dfs -mkdir -p /user/cloudera/proyecto/processed
hdfs dfs -mkdir -p /user/cloudera/proyecto/staging
hdfs dfs -mkdir -p /user/cloudera/proyecto/output

# Ver estructura
hdfs dfs -ls /user/cloudera/proyecto
