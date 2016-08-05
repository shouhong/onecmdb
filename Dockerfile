FROM ubuntu
RUN mkdir /onecmdb
ADD ./lib /onecmdb/lib
ADD ./repository /onecmdb/repository
ADD ./tomcat /onecmdb/tomcat
ADD ./hsqldb /onecmdb/hsqldb
ADD ./bin /onecmdb/bin
ADD ./etc /onecmdb/etc
ADD ./jre /onecmdb/jre
ADD ./nmap /onecmdb/nmap
ADD ./docker-entrypoint.sh /onecmdb/

RUN chmod +x /onecmdb/docker-entrypoint.sh

ENTRYPOINT ["/onecmdb/docker-entrypoint.sh"]
