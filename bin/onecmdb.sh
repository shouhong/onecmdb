#!/bin/bash
#
# Simple script to run OneCMDB server
#
SPLASH=true
[ "$1" = "--no-verbose" -o "$1" = "-nv" ] && { 
    SPLASH=false; 
    shift
}

$SPLASH && {
    echo "Lokomo OneCMDB"
    echo "=============="
    echo 
    echo "Copyright (C) Lokomo Systems AB"
    echo "Lokomo OneCMDB comes with ABSOLUTELY NO WARRANTY. This is free software,"
    echo "and you are welcome to redistribute it under certain conditions; for"
    echo "details  see \`LICENSE' in the installation folder."
    echo
    echo "----------------------------------------------------------------------"
}

# Trivial location indentifiers
ONECMDB_HOME=$(cd $(dirname $0); cd ..; pwd)
if [ -f $ONECMDB_HOME/bin/setenv.sh ]
then
	. $ONECMDB_HOME/bin/setenv.sh
fi

#JAVA_HOME=$ONECMDB_HOME/jre
#HSQLDB_HOME=$ONECMDB_HOME/hsqldb
#JAVA_OPTS=-Xmx1024M

# make sure variables can be reached by sub shells
#export ONECMDB_HOME JAVA_HOME JAVA_OPTS HSQLDB_HOME

# Special Tomcat options
export CATALINA_OPTS="-Djava.awt.headless=true"

if [ $# -ne 1 ]; then
    echo
    echo >&2 "Usage: $(basename $0) [--no-verbose] start|stop"
    exit 1
fi
if [ $1 = start ]; then
    # HSQLDB
    if [ "$START_HSQLDB" = "true" ]
    then 
   	 	(
    		cd $HSQLDB_HOME
    		./demo/runServer.sh >./data/stdout.log &
    	)
    fi		

    # Tomcat (we need to start with a known CWD)
    ( 
	cd "$ONECMDB_HOME"
	./tomcat/bin/startup.sh
    )

    $SPLASH && {
	echo "----------------------------------------------------------------------"
	echo 
	echo "Lokomo OneCMDB is now starting. Look for log information in"
	echo "\`$ONECMDB_HOME/tomcat/logs'."
	echo
	echo "To open the OneCMDB Web GUI, point your browser to"
	echo
	echo "    $ONECMDB_DESKTOP_URL"
	echo 
	echo "Please report feature requsets and bugs at"
	echo 
	echo "   http://sourceforge.net/tracker/?group_id=176340"
	echo
	echo "Have fun!"
	echo 
	echo
    }

elif [ $1 = stop ]; then
    $SPLASH && {
	echo "----------------------------------------------------------------------"
	echo
	echo "Lokomo OneCMDB is now stopping."
	echo
    }
    # Tomcat
    $ONECMDB_HOME/tomcat/bin/shutdown.sh

    # HSQLDB
    if [ "$START_HSQLDB" = "true" ]
    then 
    	$JAVA_HOME/bin/java -jar $HSQLDB_HOME/lib/hsqldb.jar \
		--rcFile $ONECMDB_HOME/etc/sqltool.rc --sql "SHUTDOWN" onecmdb
	fi
fi




