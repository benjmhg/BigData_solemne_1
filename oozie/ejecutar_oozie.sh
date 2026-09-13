# 1. Crear estructura de carpetas en HDFS
hdfs dfs -mkdir -p /user/cloudera/proyecto/raw/games_sqoop
hdfs dfs -mkdir -p /user/cloudera/proyecto/processed
hdfs dfs -mkdir -p /user/cloudera/proyecto/output
hdfs dfs -mkdir -p /user/cloudera/proyecto/scripts
hdfs dfs -mkdir -p /user/cloudera/proyecto/oozie

# 2. Cargar dataset crudo a HDFS (zona raw)
hdfs dfs -put -f /home/cloudera/workspace/BigData_solemne_1/pig/dataset_final_hive.tsv /user/cloudera/proyecto/raw/games_sqoop/part-m-00000

# 3. Subir scripts ejecutables y definicion a HDFS
hdfs dfs -put -f /home/cloudera/workspace/BigData_solemne_1/pig/etl_steam.pig /user/cloudera/proyecto/scripts/
hdfs dfs -put -f /home/cloudera/workspace/BigData_solemne_1/scripts/analisis_steam.sql /user/cloudera/proyecto/scripts/
hdfs dfs -put -f /home/cloudera/workspace/BigData_solemne_1/oozie/workflow.xml /user/cloudera/proyecto/oozie/

# 4. Limpiar carpetas de salida previas
hdfs dfs -rm -r /user/cloudera/proyecto/processed/juegos_etiquetados 2>/dev/null || true
hdfs dfs -rm -r /user/cloudera/proyecto/output/top_satisfaccion 2>/dev/null || true

# 5. Ejecutar workflow en Apache Oozie
echo "Lanzando Workflow en Oozie..."
cd /home/cloudera/workspace/BigData_solemne_1/oozie
oozie job -oozie http://localhost:11000/oozie -config job.properties -run
