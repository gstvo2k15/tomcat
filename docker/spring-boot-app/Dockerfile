FROM tomcat:9-jdk8

ENV NEXUS_URL=https://nexusgolmolab.duckdns.org/repository/maven-releases \
    BUILD_NUMBER=latest \
    NEXUS_USER=default \
    NEXUS_PASS=default

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

USER tomcat

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:8080 || exit 1

CMD ["/usr/local/bin/start.sh"]
