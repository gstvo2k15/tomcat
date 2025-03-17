# Dockerfile
FROM tomcat:9-jdk8

# Copy generated WAR in Tomcat webapps deployments
COPY ${WORKSPACE_DIR}/target/uvc.war /usr/local/tomcat/webapps/
