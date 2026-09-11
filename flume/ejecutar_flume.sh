#!/bin/bash

# Iniciar agente Apache Flume
# Source: Spool Directory
# Channel: Memory
# Sink: HDFS

flume-ng agent \
--conf /etc/flume-ng/conf \
--conf-file /home/cloudera/workspace/BigData_solemne_1/flume/flume.conf \
--name agent1 \
-Dflume.root.logger=INFO,console
