# Dockerfile
FROM tomcat:9-jdk8

# Set a non-root user
USER tomcat

# Copy generated WAR in Tomcat webapps deployments
COPY ${WORKSPACE_DIR}/target/uvc.war /usr/local/tomcat/webapps/

# Define a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:8080 || exit 1
