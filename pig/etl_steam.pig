juegos_raw = LOAD '/user/cloudera/proyecto/raw/games_sqoop' USING PigStorage('\t') AS (
    name:chararray,
    release_date:chararray,
    price:double,
    is_free_to_play:int,
    dlc_count:int,
    achievements:int,
    positive:long,
    negative:long,
    satisfaction_ratio:double,
    is_multiplatform:int,
    median_playtime:int,
    peak_ccu:long,
    genres:chararray,
    supported_languages:chararray
);


juegos_limpios = FILTER juegos_raw BY 
    name IS NOT NULL AND 
    price IS NOT NULL;


juegos_transformados = FOREACH juegos_limpios GENERATE 
    'APP_' AS appid:chararray,
    name AS name:chararray,
    price AS price:double,
    ((price == 0.0) ? 1 : 0) AS is_free_to_play:int,
    (dlc_count IS NULL ? 0 : dlc_count) AS dlc_count:int,
    (achievements IS NULL ? 0 : achievements) AS achievements:int,
    (positive IS NULL ? 0L : positive) AS positive:long,
    (negative IS NULL ? 0L : negative) AS negative:long,
    (satisfaction_ratio IS NULL ? 0.0 : satisfaction_ratio) AS satisfaction_ratio:double,
    (is_multiplatform IS NULL ? 0 : is_multiplatform) AS is_multiplatform:int,
    (median_playtime IS NULL ? 0 : median_playtime) AS median_playtime:int,
    (peak_ccu IS NULL ? 0L : peak_ccu) AS peak_ccu:long,
    genres AS genres:chararray,
    supported_languages AS supported_languages:chararray;


STORE juegos_transformados INTO '/user/cloudera/proyecto/processed/juegos_etiquetados' USING PigStorage('\t');
