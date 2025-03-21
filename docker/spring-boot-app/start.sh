#!/bin/bash
set -e

echo "Download WAR from Nexus..."
curl -u "${NEXUS_USER}:${NEXUS_PASS}" -o /usr/local/tomcat/webapps/uvc.war \
  "${NEXUS_URL}/uvc-${BUILD_NUMBER}.war"

echo "Starting Tomcat..."
catalina.sh run
