#!/bin/bash
# NAGIOS import Start script 

. ../setenv.sh
echo ============ENVIRONMENT=====================
echo ONECMDB_HOME=$ONECMDB_HOME
echo JAVA_HOME=$JAVA_HOME
echo NAMP_HOME=$NMAP_HOME
echo ONECMDB_URL=$ONECMDB_URL
echo ONECMDB_DESKTOP_URL=$ONECMDB_DESKTOP_URL
echo ============================================

function help {
	echo "NAGIOS Import start script:" 
	echo "Options:"
	echo "--name name - A name for this discovery"
	echo "--mdr_history ALIAS   - Specifies the history entry name."
	echo "--onecmdb_token token - login token from onecmdb."
	echo "--importDir - the directory containing nagios cfg files to import"
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
	  --importDir) shift; IMPORT_DIR="$1"; shift;;
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

echo "NETWORK=$NETWORK HISTORY=$HISTORY TOKEN=$TOKEN";

### 
# MAIN Start point
###

echo "Convert nagios cfg to xml"
"$JAVA_HOME/bin/java" -cp "lib/onecmdb-nagios-utils.jar" org.onecmdb.nagios.Config2XML nagios_configs/example $IMPORT_DIR 
if [ "$?" != "0" ]
then
    echo "Transform FAILED!"
    exit 1
fi

echo "Start import nagios config from $IMPORT_DIR ..."
"$JAVA_HOME/bin/java" -cp "$ONECMDB_HOME/lib/classloader.jar" org.onecmdb.utils.classloader.RemoteClassLoader "$ONECMDB_URL/remote/classpath/;file:lib/onecmdb-nagios-utils.jar" org.onecmdb.nagios.Nagios2OneCMDB --input $IMPORT_DIR --output result/nagios-onecmdb.xml
if [ "$?" != "0" ]
then
    echo "Transform nagios input FAILED!"
    exit 1
fi


##
# Upload result.
##
if [ "$HISTORY" != "" ]  
then
	echo "Upload result to change manager."
	"$ONECMDB_HOME/bin/upload.sh" --token $TOKEN --postURL $ONECMDB_DESKTOP_URL/onecmdb/change --input result/nagios-onecmdb.xml --history $HISTORY
	if [ "$?" != "0" ]
	then
    	echo "Upload result to cmdb FAILED!"
   	 	exit 1
   	 fi
fi

echo "Execution terminated ok."
exit 0
