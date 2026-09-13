# Crear las tablas en Hive
CREATE EXTERNAL TABLE IF NOT EXISTS steam_games (
    app_id INT,
    name STRING,
    release_date STRING,
    estimated_owners STRING,
    peak_ccu INT,
    required_age INT,
    price FLOAT,
    dlc_count INT,
    about_the_game STRING,
    supported_languages STRING,
    full_audio_languages STRING,
    reviews STRING,
    header_image STRING,
    website STRING,
    support_url STRING,
    support_email STRING,
    windows BOOLEAN,
    mac BOOLEAN,
    linux BOOLEAN,
    metacritic_score INT,
    metacritic_url STRING,
    user_score INT,
    positive INT,
    negative INT,
    score_rank STRING,
    achievements INT,
    recommendations INT,
    notes STRING,
    avg_playtime_forever INT,
    avg_playtime_2weeks INT,
    median_playtime_forever INT,
    median_playtime_2weeks INT,
    developers STRING,
    publishers STRING,
    categories STRING,
    genres STRING,
    tags STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/cloudera/'
TBLPROPERTIES ("skip.header.line.count"="1");

# Comando de administración exclusivo de Impala para que puede ver la tabla
INVALIDATE METADATA;

# Tabla procesada
CREATE DATABASE IF NOT EXISTS steam_analytics;
USE steam_analytics;

DROP TABLE IF EXISTS steam_games_processed;

CREATE EXTERNAL TABLE steam_games_processed (
    appid STRING,
    name STRING,
    price DOUBLE,
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

# Consulta Analítica 1: Código de comparación entre Hive e Impala
SELECT 
    CASE WHEN price = 0 THEN 'Free-to-Play' ELSE 'De Pago' END AS modelo,
    COUNT(*) AS total_juegos
FROM steam_games
GROUP BY CASE WHEN price = 0 THEN 'Free-to-Play' ELSE 'De Pago' END;


# Consulta Analítica 2: Precio vs. Recomendación del Público (promedio)
SELECT 
    CASE 
        WHEN price = 0 THEN 'Gratis'
        WHEN price <= 10 THEN 'Economico ($0-$10)'
        WHEN price <= 30 THEN 'Medio ($10-$30)'
        ELSE 'Alto (>$30)'
    END AS rango_precio,
    AVG(recommendations) AS promedio_recomendaciones
FROM steam_games
GROUP BY 1
ORDER BY promedio_recomendaciones DESC;

# Consulta Analítica 3: Exclusividad en Plataformas.
SELECT 
    CASE 
        WHEN windows = true AND mac = true AND linux = true THEN 'Windows + Mac + Linux'
        WHEN windows = true AND (mac = true OR linux = true) THEN 'Multiplataforma Parcial'
        WHEN windows = false AND (mac = true AND linux = true) THEN 'Multiplataforma Parcial'
        WHEN mac = true AND (windows = false AND linux = false) THEN 'Exclusivo Mac'
        WHEN linux = true AND (windows = false AND mac = false) THEN 'Exclusivo Mac'
        ELSE 'Exclusivo Windows'
    END AS plataforma,
    COUNT(*) AS total_juegos
FROM steam_games
GROUP BY 1;
# Consulta Analitica 4: Rango de Precio vs. Porcentaje Promedio de Satisfacción (Calculada sobre la tabla procesada por Pig con satisfaction_ratio)
SELECT 
    CASE 
        WHEN price = 0 THEN 'Gratis (Free-to-Play)'
        WHEN price <= 10 THEN 'Economico ($0-$10)'
        WHEN price <= 30 THEN 'Medio ($10-$30)'
        ELSE 'Alto (>$30)'
    END AS rango_precio,
    ROUND(AVG(satisfaction_ratio) * 100, 2) AS porcentaje_satisfaccion_promedio,
    COUNT(*) AS total_titulos
FROM steam_analytics.steam_games_processed
GROUP BY 1
ORDER BY porcentaje_satisfaccion_promedio DESC;

# Consulta Analítica 5: Retención y Tiempo de Juego Promedio por Género
SELECT 
    genres,
    ROUND(AVG(median_playtime), 2) AS promedio_minutos_jugados,
    COUNT(*) AS total_juegos
FROM steam_analytics.steam_games_processed
WHERE genres IS NOT NULL AND genres != ''
GROUP BY genres
HAVING COUNT(*) > 100
ORDER BY promedio_minutos_jugados DESC
LIMIT 10;
# Consulta Analítica 6: Influencia de los Sistemas de Logros en la Recepción Positiva
SELECT 
    CASE 
        WHEN achievements > 0 THEN 'Con Logros'
        ELSE 'Sin Logros'
    END AS grupo_logros,
    ROUND(AVG(positive), 2) AS promedio_resenas_positivas,
    COUNT(*) AS total_juegos
FROM steam_analytics.steam_games_processed
GROUP BY 1
ORDER BY promedio_resenas_positivas DESC;
