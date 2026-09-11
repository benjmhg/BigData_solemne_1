# -*- coding: utf-8 -*-

import json
import codecs

entrada = "/mnt/steam/games.json"
salida = "games_clean.tsv"

columnas = [
    "AppID",
    "Name",
    "Release_date",
    "Estimated_owners",
    "Peak_CCU",
    "Required_age",
    "Price",
    "DiscountDLC_count",
    "Supported_languages",
    "Windows",
    "Mac",
    "Linux",
    "Metacritic_score",
    "User_score",
    "Positive",
    "Negative",
    "Achievements",
    "Recommendations",
    "Average_playtime_forever",
    "Average_playtime_two_weeks",
    "Median_playtime_forever",
    "Median_playtime_two_weeks",
    "Developers",
    "Publishers",
    "Categories",
    "Genres",
    "Tags"
]

def limpiar(valor):
    if valor is None:
        return u""

    if isinstance(valor, list):
        valor = u",".join([unicode(x) for x in valor])
    else:
        valor = unicode(valor)

    valor = valor.replace(u"\t", u" ")
    valor = valor.replace(u"\r", u" ")
    valor = valor.replace(u"\n", u" ")
    valor = u"".join(c for c in valor if ord(c) <= 0xFFFF)
    return valor

with codecs.open(entrada, "r", "utf-8") as f:
    datos = json.load(f)

with codecs.open(salida, "w", "utf-8") as f:

    f.write(u"\t".join(columnas) + u"\n")

    total = 0

    for appid, juego in datos.items():
        fila = [
            appid,
            juego.get("name", ""),
            juego.get("release_date", ""),
            juego.get("estimated_owners", ""),
            juego.get("peak_ccu", 0),
            juego.get("required_age", 0),
            juego.get("price", 0),
            juego.get("dlc_count", 0),
            juego.get("supported_languages", []),
            juego.get("windows", False),
            juego.get("mac", False),
            juego.get("linux", False),
            juego.get("metacritic_score", 0),
            juego.get("user_score", 0),
            juego.get("positive", 0),
            juego.get("negative", 0),
            juego.get("achievements", 0),
            juego.get("recommendations", 0),
            juego.get("average_playtime_forever", 0),
            juego.get("average_playtime_2weeks", 0),
            juego.get("median_playtime_forever", 0),
            juego.get("median_playtime_2weeks", 0),
            juego.get("developers", []),
            juego.get("publishers", []),
            juego.get("categories", []),
            juego.get("genres", []),
            juego.get("tags", [])
        ]

        fila = [limpiar(x) for x in fila]

        f.write(u"\t".join(fila) + u"\n")
        total += 1

print("Proceso terminado")
print("Registros procesados:", total)
print("Archivo generado:", salida)
