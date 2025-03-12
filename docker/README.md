1. Start compose:

    `docker compose up -d`

2. Copy an example war to webapps folder:

    `cp /root/uvc.war /root/tomcat/webapps/`

3. Verify with logs if have been deployed properly:

    `docker compose logs -f --tail=15`
   ```
    tomcat-standalone-1     | 12-Mar-2025 16:51:28.784 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/     webapps/uvc.war]

    tomcat-cluster-node2-1  | 12-Mar-2025 16:51:29.176 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/webapps/uvc.   war]
    tomcat-cluster-node2-1  | 12-Mar-2025 16:51:47.838 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable    debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and    JSP compilation time.
    tomcat-cluster-node2-1  | 12-Mar-2025 16:51:51.331 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/   uvc.war] has finished in [22,154] ms
    tomcat-cluster-node2-1  | 12-Mar-2025 16:51:51.347 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
    tomcat-cluster-node2-1  | 12-Mar-2025 16:51:51.413 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [22397] milliseconds

    nginx-load-balancer-1   | /docker-entrypoint.sh: Configuration complete; ready for start up
    nginx-load-balancer-1   | 192.168.1.81 - - [12/Mar/2025:16:54:28 +0000] "GET /uvc/ HTTP/1.1" 200 1362 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101   Firefox/136.0"
    nginx-load-balancer-1   | 192.168.1.81 - - [12/Mar/2025:16:54:28 +0000] "GET /uvc/images/go.gif HTTP/1.1" 200 1958 "http://192.168.1.121/uvc/" "Mozilla/5.0 (Windows NT 10.0;   Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    nginx-load-balancer-1   | 192.168.1.81 - - [12/Mar/2025:16:54:29 +0000] "GET /uvc/images/bg.gif HTTP/1.1" 200 123 "http://192.168.1.121/uvc/" "Mozilla/5.0 (Windows NT 10.0;    Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    nginx-load-balancer-1   | 192.168.1.81 - - [12/Mar/2025:16:54:29 +0000] "GET /uvc/images/splash-uv-2.png HTTP/1.1" 200 42450 "http://192.168.1.121/uvc/" "Mozilla/5.0 (Windows  NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    tomcat-standalone-1     | 12-Mar-2025 16:51:47.560 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable    debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and    JSP compilation time.

    tomcat-standalone-1     | 12-Mar-2025 16:51:50.970 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/   uvc.war] has finished in [22,185] ms
    tomcat-standalone-1     | 12-Mar-2025 16:51:50.987 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
    tomcat-standalone-1     | 12-Mar-2025 16:51:51.035 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [22499] milliseconds
    
    tomcat-cluster-node1-1  | 12-Mar-2025 16:51:28.183 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/webapps/uvc.   war]
    tomcat-cluster-node1-1  | 12-Mar-2025 16:51:48.472 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable    debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and    JSP compilation time.
    tomcat-cluster-node1-1  | 12-Mar-2025 16:51:51.489 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/   uvc.war] has finished in [23,306] ms
    tomcat-cluster-node1-1  | 12-Mar-2025 16:51:51.494 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
    tomcat-cluster-node1-1  | 12-Mar-2025 16:51:51.511 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [23459] milliseconds
   ```

