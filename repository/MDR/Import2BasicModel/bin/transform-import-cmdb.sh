#!/bin/bash 
# Transform for import 
# 2009-04-21 
 
. ../setenv.sh 
echo ============ENVIRONMENT===================== 
echo ONECMDB_HOME=$ONECMDB_HOME 
echo JAVA_HOME=$JAVA_HOME 
echo ONECMDB_URL=$ONECMDB_URL 
echo ONECMDB_URL=$ONECMDB_DESKTOP_URL 
echo ============================================ 
 
function help { 
echo "Basic Import start script:" 
echo "Options:" 
echo "--name name - A name for this discovery" 
echo "--mdr_history ALIAS - Specifies the history entry name." 
echo "--onecmdb_token token - login token from onecmdb." 
echo "--importDir - the directory containing nagios cfg files to import" 
exit -1 
} 
 
NAME=default 
 
# Arguments 
if [ "$#" == "0" ] 
then 
help; 
exit 1; 
fi 
 
while [ "$1" != "" ] 
do 
case $1 in 
--importDir) shift; IMPORT_DIR="$1"; shift;; 
--name) shift; NAME="$1";shift;; 
--mdr_history) shift;HISTORY="$1";shift;; 
--onecmdb_token) shift;TOKEN="$1";shift;; 
--help) help;; 
*) shift;; 
esac 
done 
 
if [ "$TOKEN" == "" ] 
then 
echo "No token!" 
help 
fi 
 
echo "HISTORY=$HISTORY TOKEN=$TOKEN"; 
 
# Main 
"$ONECMDB_HOME/bin/transform.sh" --url $ONECMDB_URL/webservice/onecmdb --token $TOKEN --transform conf/transform_$NAME.xml --transformType simple --source conf/source_$NAME.xml --name $NAME --output result/result_$NAME.xml 
if [ "$?" != "0" ] 
then 
echo "transform result to cmdb failed!" 
exit 1 
fi 
 
# Upload 
if [ "$HISTORY" != "" ] 
then 
echo "Upload result to change manager." 
"$ONECMDB_HOME/bin/upload.sh" --token $TOKEN --postURL $ONECMDB_DESKTOP_URL/onecmdb/change --input result/result_$NAME.xml --history $HISTORY 
if [ "$?" != "0" ] 
then 
echo "Upload result to cmdb failed!" 
exit 1 
fi 
fi 
 
echo "Execution terminated!" 
exit 0 
