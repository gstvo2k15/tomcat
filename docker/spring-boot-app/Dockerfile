FROM tomcat:9-jdk8

ARG WORKSPACE_DIR=.

COPY ${WORKSPACE_DIR}/target/uvc.war \
     /usr/local/tomcat/webapps/uvc.war

USER 0:0

EXPOSE 8080

CMD ["catalina.sh", "run"]
