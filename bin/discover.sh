#!/bin/bash
#
# Discover network using nmap, transform output and import to OneCMDB.
# Connecting to OneCMDB using WSDL interface.
#
# Trivial location indentifiers
ONECMDB_HOME=$(cd $(dirname $0); cd ..; pwd)
JAVA_HOME=$ONECMDB_HOME/jre
HSQLDB_HOME=$ONECMDB_HOME/hsqldb
TOMCAT_HOME=$ONECMDB_HOME/tomcat

# This the network that will be discoverd by nmap.
NETWORK=192.168.1.1/24


echo Discover network equipment and open ports. 
echo This OneCMDB-function uses NMAP.
echo NOTE: OneCMDB must be started before proceeding.
echo
echo The following network will be discovered: ${NETWORK}
echo You may change this setting by editing the following file:
echo $0 file. 
echo
echo This discover process will take some time depending on the size of the network.
echo
echo Press return to continue...
read $i

# Run NMAP....
echo "Start discover network ${network} ..."
${ONECMDB_HOME}/nmap/bin/nmap -T3 -sS -O -F ${NETWORK} -oX ${ONECMDB_HOME}/discovery/network.xml

# Transform result.
echo "Transform discover network to CI....."
${ONECMDB_HOME}/bin/transform.sh --input file:${ONECMDB_HOME}/discovery/network.xml --name nmap-transform --output ${ONECMDB_HOME}/discovery/onecmdb-network-instances.xml

# Import result.
echo "Import discover network to CI....."
${ONECMDB_HOME}/bin/import.sh --input file:${ONECMDB_HOME}/discovery/onecmdb-network-instances.xml

echo 
echo "The network discovery is now completed and the result"
echo "has been imported into your current OneCMDB model."
echo "You may run the discover-function again later to detect"
echo "possible changes in your network."
echo 

