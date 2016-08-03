#!/bin/bash

# Trivial location indentifiers
ONECMDB_HOME=$(cd $(dirname $0); cd ..; pwd)
if [ -f $ONECMDB_HOME/bin/setenv.sh ]
then
	. $ONECMDB_HOME/bin/setenv.sh
fi
#JAVA_HOME=$ONECMDB_HOME/jre
#HSQLDB_HOME=$ONECMDB_HOME/hsqldb
#TOMCAT_HOME=$ONECMDB_HOME/tomcat


#cd $ONECMDB_HOME
$JAVA_HOME/bin/java -cp "$ONECMDB_HOME/lib/modrepl.jar" \
    org.onecmdb.utils.modrepl.Main \
    "$ONECMDB_HOME/etc/models" \
    "$HSQLDB_HOME" \
    "$TOMCAT_HOME"

    






