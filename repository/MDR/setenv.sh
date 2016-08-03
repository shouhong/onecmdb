#!/bin/bash
#
# Setup OneCMDB envorinment variables
. ../../../bin/setenv.sh

export ONECMDB_HOME=`(cd ../../..; pwd)`
export TOMCAT_HOME=`(cd ../../..; pwd)`/tomcat
export NMAP_HOME=`(cd ../../..; pwd)`/nmap
export JAVA_HOME=`(cd ../../..; pwd)`/jre
