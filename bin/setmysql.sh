cp ./WEB-INF/classes/datasource.xml.tpl ./WEB-INF/classes/datasource.xml
sed -i "s/\${MYSQL_HOST}/$MYSQL_PORT_3306_TCP_ADDR/g" ./WEB-INF/classes/datasource.xml
sed -i "s/\${MYSQL_PORT}/$MYSQL_PORT_3306_TCP_PORT/g" ./WEB-INF/classes/datasource.xml
sed -i "s/\${MYSQL_USER}/root/g" ./WEB-INF/classes/datasource.xml
sed -i "s/\${MYSQL_PASSWORD}/$MYSQL_ENV_MYSQL_ROOT_PASSWORD/g" ./WEB-INF/classes/datasource.xml

rm -rf ../tomcat/webapps/ROOT
$JAVA_HOME/bin/jar uf ../tomcat/webapps/ROOT.war  ./WEB-INF/classes/datasource.xml
