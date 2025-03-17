# Dockerfile
FROM tomcat:9-jdk8

# Variable ARG opcional si quieres parametrizar el nombre del WAR
ARG artifact=target/uvc.war

# Copiamos el WAR dentro de la carpeta webapps de Tomcat
COPY ${artifact} /usr/local/tomcat/webapps/uvc.war
