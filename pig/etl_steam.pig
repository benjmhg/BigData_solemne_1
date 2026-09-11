juegos_raw = LOAD '/user/cloudera/proyecto/raw/games_sqoop' USING PigStorage('\t') AS (
    app_id:chararray, name:chararray, release_date:chararray, price:float, 
    dlc_count:int, windows:boolean, mac:boolean, linux:boolean, 
    achievements:int, positive:long, negative:long, 
    median_playtime:int, peak_ccu:long, genres:chararray, supported_languages:chararray
);
juegos_limpios = FILTER juegos_raw BY app_id IS NOT NULL AND price >= 0.0 AND peak_ccu >= 0 AND (positive + negative) > 0;
juegos_transformados = FOREACH juegos_limpios GENERATE app_id, name, price, (price == 0.0 ? 1 : 0) AS is_free_to_play:int, dlc_count, achievements, positive, negative, ((double)positive / (double)(positive + negative)) AS satisfaction_ratio:double, ((mac == true OR linux == true) ? 1 : 0) AS is_multiplatform:int, median_playtime, peak_ccu, genres, supported_languages;
STORE juegos_transformados INTO '/user/cloudera/proyecto/processed/juegos_etiquetados' USING PigStorage('\t');
