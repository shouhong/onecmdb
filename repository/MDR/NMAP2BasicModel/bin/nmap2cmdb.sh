#!/bin/bash
# NMAP2CMDB Start script 

. ../setenv.sh
echo ============ENVIRONMENT=====================
echo ONECMDB_HOME=$ONECMDB_HOME
echo JAVA_HOME=$JAVA_HOME
echo NAMP_HOME=$NMAP_HOME
echo ONECMDB_URL=$ONECMDB_URL
echo ONECMDB_DESKTOP_URL=$ONECMDB_DESKTOP_URL
echo ============================================

function help {
	echo "NMAP2CMDB start script:" 
	echo "Options:"
	echo "--name name - A name for this discovery"
	echo "--mdr_history ALIAS   - Specifies the history entry name."
	echo "--onecmdb_token token - login token from onecmdb."
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

echo "HISTORY=$HISTORY TOKEN=$TOKEN";

### 
# MAIN Start point
###

##
# Transform nmap CI's to cmdb CI's.
##
echo "Transform output." 
"$ONECMDB_HOME/bin/transform.sh"  --url $ONECMDB_URL/webservice/onecmdb --valueMap {network}=$NAME --token $TOKEN --transform conf/nmap2cmdb.xml  --transformType simple --fileSource "$ONECMDB_DESKTOP_URL/onecmdb/export?name=NMAP/nmap.cfg" --sourceType xml  --name nmap2cmdb --output result/nmap2cmdb_result.xml
if [ "$?" != "0" ]
	then
    	echo "Transform FAILED!"
   	 	exit 1
   	 fi

##
# Upload result.
##
if [ "$HISTORY" != "" ] 
then
	echo "Upload result to change manager."
	"$ONECMDB_HOME/bin/upload.sh" --token $TOKEN --postURL $ONECMDB_DESKTOP_URL/onecmdb/change --input result/nmap2cmdb_result.xml --history $HISTORY
	if [ "$?" != "0" ]
	then
    	echo "Upload result to cmdb FAILED!"
   	 	exit 1
   	 fi
fi

echo "Execution terminated ok."
exit 0
