-- Cargar los datos desde HDFS (Asegúrate de que la ruta coincida con donde tus compañeros de HDFS/Sqoop dejaron el archivo)
juegos_raw = LOAD '/user/hadoop/steam/raw/steam_games.csv' USING PigStorage(',') AS (
    app_id:chararray, name:chararray, release_date:chararray, price:float, 
    dlc_count:int, windows:boolean, mac:boolean, linux:boolean, 
    achievements:int, positive:long, negative:long, 
    median_playtime:int, peak_ccu:long, genres:chararray, supported_languages:chararray
);

-- Filtrar registros nulos o inválidos (Limpieza ETL)
juegos_limpios = FILTER juegos_raw BY 
    app_id IS NOT NULL AND 
    price >= 0.0 AND 
    peak_ccu >= 0 AND 
    (positive + negative) > 0;

-- Transformar y crear columnas calculadas útiles para responder las preguntas del negocio
juegos_transformados = FOREACH juegos_limpios GENERATE 
    app_id, 
    name, 
    price, 
    (price == 0.0 ? 1 : 0) AS is_free_to_play:int, -- Bandera para la pregunta de F2P vs Pago
    dlc_count, 
    achievements, 
    positive, 
    negative, 
    ((double)positive / (double)(positive + negative)) AS satisfaction_ratio:double, -- Para la pregunta de satisfacción
    ((mac == true OR linux == true) ? 1 : 0) AS is_multiplatform:int, -- Para la pregunta de multiplataforma
    median_playtime, 
    peak_ccu,
    genres,
    supported_languages;

-- Guardar los datos limpios y transformados de vuelta en HDFS para que el módulo de Hive los consuma
STORE juegos_transformados INTO '/user/hadoop/steam/processed/juegos_etiquetados' USING PigStorage(',');
