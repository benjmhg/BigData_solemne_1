CREATE DATABASE IF NOT EXISTS steam_analytics;
USE steam_analytics;

CREATE EXTERNAL TABLE steam_games_processed (
    appid STRING,
    name STRING,
    price FLOAT,
    is_free_to_play INT,
    dlc_count INT,
    achievements INT,
    positive BIGINT,
    negative BIGINT,
    satisfaction_ratio DOUBLE,
    is_multiplatform INT,
    median_playtime INT,
    peak_ccu BIGINT,
    genres STRING,
    supported_languages STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/cloudera/proyecto/processed/juegos_etiquetados';

INSERT OVERWRITE DIRECTORY '/user/cloudera/proyecto/output/top_satisfaccion'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
SELECT name, price, satisfaction_ratio, peak_ccu
FROM steam_games_processed
ORDER BY satisfaction_ratio DESC
LIMIT 10;
