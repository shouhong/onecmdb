#!/bin/bash
# NMAP Start script 

. ../setenv.sh
echo ============ENVIRONMENT=====================
echo ONECMDB_HOME=$ONECMDB_HOME
echo JAVA_HOME=$JAVA_HOME
echo NAMP_HOME=$NMAP_HOME
echo ONECMDB_URL=$ONECMDB_URL
echo ONECMDB_DESKTOP_URL=$ONECMDB_DESKTOP_URL
echo ============================================

function help {
	echo "NMAP start script:" 
	echo "Options:"
	echo "--network IPRANGE - Specifies the network, ip range to discover."
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
	  --network) shift; NETWORK="$1"; shift;;
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

##
# Run nmap
##
echo "Start discover network $NETWORK ..."
"$NMAP_HOME/bin/nmap" -T3 -sS -F $NETWORK -oX result/nmap-network-$NAME.xml 
if [ "$?" != "0" ]
then
    echo "Running nmap FAILED!"
    exit 1
fi

##
# Transform nmap xml to cmdb xml.
##
echo "Transform output." 
"$ONECMDB_HOME/bin/transform.sh" --url $ONECMDB_URL/webservice/onecmdb --valueMap {network}=$NAME --token $TOKEN --transform conf/nmap-simple-transform.xml --model conf/nmap-model.xml --fileSource file:result/nmap-network-$NAME.xml --sourceType xml --name nmap-transform --transformType simple --output result/nmap-onecmdb-$NAME.xml
if [ "$?" != "0" ]
then
    echo "Transform nmap result FAILED!"
    exit 1
fi

##
# Upload result.
##
if [ "$HISTORY" != "" ] 
then
	echo "Upload result to change manager."
	"$ONECMDB_HOME/bin/upload.sh" --token $TOKEN --postURL $ONECMDB_DESKTOP_URL/onecmdb/change --input result/nmap-onecmdb-$NAME.xml --history $HISTORY
	if [ "$?" != "0" ]
	then
    	echo "Upload result to cmdb FAILED!"
   	 	exit 1
   	 fi
fi

echo "Execution terminated ok."
exit 0
