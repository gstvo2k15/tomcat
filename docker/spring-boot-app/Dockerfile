FROM tomcat:9-jdk8

ARG WORKSPACE_DIR=.

RUN groupadd --gid 10001 appgroup \
    && useradd \
       --uid 10001 \
       --gid 10001 \
       --home-dir /usr/local/tomcat \
       --shell /usr/sbin/nologin \
       appuser

COPY --chown=10001:10001 \
    ${WORKSPACE_DIR}/target/uvc.war \
    /usr/local/tomcat/webapps/uvc.war

RUN chown -R 10001:10001 /usr/local/tomcat

USER 10001:10001

EXPOSE 8080

CMD ["catalina.sh", "run"]