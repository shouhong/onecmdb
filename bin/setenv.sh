#!/bin/bash
#
# Setup OneCMDB envorinment variables
ONECMDB_HOME=$(cd $(dirname $0); cd ..; pwd)
export ONECMDB_HOME

export TOMCAT_HOME=$ONECMDB_HOME/tomcat
export NMAP_HOME=$ONECMDB_HOME/nmap
export JAVA_HOME=$ONECMDB_HOME/jre
export HSQLDB_HOME=$ONECMDB_HOME/hsqldb
export START_HSQLDB=true
export JAVA_OPTS=-Xmx1024M
export ONECMDB_URL=http://localhost:8080
export ONECMDB_DESKTOP_URL=http://localhost:8080/onecmdb-desktop
