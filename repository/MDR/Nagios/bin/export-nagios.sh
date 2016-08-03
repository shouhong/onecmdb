#!/bin/bash
# CMDB2NAGIOS Start script 

. ../setenv.sh
echo ============ENVIRONMENT=====================
echo ONECMDB_HOME=$ONECMDB_HOME
echo JAVA_HOME=$JAVA_HOME
echo NAMP_HOME=$NMAP_HOME
echo ONECMDB_URL=$ONECMDB_URL
echo ONECMDB_DESKTOP_URL=$ONECMDB_DESKTOP_URL
echo ============================================

function help {
	echo "CMDB2NAGIOS start script:" 
	echo "Options:"
	echo "--name name - A name for this discovery"
	echo "--mdr_history ALIAS   - Specifies the history entry name."
	echo "--onecmdb_token token - login token from onecmdb."
	echo "--exportDir - directory where result should end up"
	exit -1
}

NAME=default
##
# Parse arguments
##
if [ "$#" == "0" ]
then
	help;
	exit 1;
fi

while [ "$1" != "" ]
do
	  case $1 in
	  --exportDir) shift;EXPORT_DIR="$1"; shift;;
	  --name)	shift; NAME="$1";shift;;
	  --mdr_history) shift;HISTORY="$1";shift;;
	  --onecmdb_token) shift;TOKEN="$1";shift;;
	  --help) help;;
	  *) shift;;
	esac
done


if [ "$TOKEN" == "" ]
then
	echo "No token given!"
	help
fi

echo "EXPORT_DIR=$EXPORT_DIR HISTORY=$HISTORY TOKEN=$TOKEN";

### 
# MAIN Start point
###


##
# Export nagios model to nagios cfg file.
##
echo "Start export nagios config to $EXPORT_DIR..."
"$JAVA_HOME/bin/java" -cp "$ONECMDB_HOME/lib/classloader.jar" org.onecmdb.utils.classloader.RemoteClassLoader "$ONECMDB_URL/remote/classpath/;file:lib/onecmdb-nagios-utils.jar" org.onecmdb.nagios.OneCMDB2Nagios --output $EXPORT_DIR/nagios-export.cfg
if [ "$?" != "0" ]
then
    echo "Export FAILED!"
    exit 1
fi

echo "Execution terminated ok."
exit 0
