FROM rabbitmq:management
MAINTAINER Chair of Software Engineering <se2-it@informatik.uni-wuerzburg.de>

# install needed packages for containernet, see https://github.com/containernet/containernet/wiki/Tutorial:-Getting-Started#custom-image
RUN apt-get update && apt-get install -y \
    net-tools \
    iputils-ping \
    iproute2 \
    telnet telnetd \
    iperf

COPY apache-tomcat-8.5.24.zip /apache.zip
COPY rabbitmq.config /etc/rabbitmq/
COPY custom_definitions.json /etc/rabbitmq/

RUN apt-get update
RUN apt-get install unzip
RUN unzip /apache.zip
RUN chmod -R +x /apache-tomcat-8.5.24
RUN apt-get -y install default-jre-headless

COPY target/*.war /apache-tomcat-8.5.24/webapps/logs.war

EXPOSE 8080

#Login for rabbitmq webui is admin:nimda
CMD  rabbitmq-server start -detached && sleep 10 && /apache-tomcat-8.5.24/bin/startup.sh && echo '<% response.sendRedirect("/logs/index"); %>' > /apache-tomcat-8.5.24/webapps/ROOT/index.jsp && sleep infinity
