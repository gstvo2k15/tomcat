# Dockerfile
FROM tomcat:9-jdk8

ENV NEXUS_URL=https://nexusgolmolab.duckdns.org/repository/maven-releases
ENV BUILD_NUMBER=latest
ENV NEXUS_USER=default
ENV NEXUS_PASS=default

# Set a non-root user
USER tomcat

# Copy generated WAR in Tomcat webapps deployments
# Script de arranque que descarga el WAR y lo lanza
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Define a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:8080 || exit 1

CMD ["/usr/local/bin/start.sh"]
