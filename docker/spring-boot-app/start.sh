#!/bin/bash
set -e

export NEXUS_USER=$(cat /secrets/username)
export NEXUS_PASS=$(cat /secrets/password)

echo "Downloading WAR file from Nexus..."
curl -u "$NEXUS_USER:$NEXUS_PASS" \
     -o /usr/local/tomcat/webapps/uvc.war \
     "$NEXUS_URL/uvc-${BUILD_NUMBER}.war"

exec catalina.sh run
