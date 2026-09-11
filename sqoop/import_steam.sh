#!/bin/bash

sqoop import \
--connect jdbc:mysql://localhost:3306/steam_project \
--username root \
--password cloudera \
--table games \
--target-dir /user/cloudera/proyecto/raw/games_sqoop \
--fields-terminated-by '\t' \
--num-mappers 1

