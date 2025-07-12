
```bash
kubectl create namespace tomcat-ns

kubectl -n kube-system get daemonset kube-proxy

kubectl -n kube-system get pods -l k8s-app=kube-proxy -o wide

lsmod | grep ip_vs

modprobe ip_vs
modprobe ip_vs_rr
modprobe ip_vs_wrr
modprobe ip_vs_sh
modprobe nf_conntrack_ipv4 || modprobe nf_conntrack

lsmod | grep ip_vs
kubectl -n kube-system delete pod kube-proxy-22f4r
ipvsadm -Ln

apt install ipvsadm -yqq
```

`http://192.168.1.151:30080/`



### Create example war
```bash
mkdir -p hello-war/src/main/java/com/example
mkdir -p hello-war/src/main/webapp/WEB-INF

cat <<EOF > hello-war/src/main/java/com/example/HelloServlet.java
package com.example;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class HelloServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/plain");
        response.getWriter().println("Hello k8s tomcat lab");
    }
}
EOF


cat <<EOF> hello-war/src/main/webapp/WEB-INF/web.xml
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         version="3.1">
    <servlet>
        <servlet-name>HelloServlet</servlet-name>
        <servlet-class>com.example.HelloServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>HelloServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
</web-app>
EOF
```

`docker run --rm -v "$PWD/hello-war":/app -w /app maven:3.8-jdk-8 mvn clean package`


```bash
[INFO] Packaging webapp
[INFO] Assembling webapp [hello-war] in [/app/target/hello]
[INFO] Processing war project
[INFO] Copying webapp resources [/app/src/main/webapp]
[INFO] Webapp assembled in [43 msecs]
[INFO] Building war: /app/target/hello.war
[INFO] WEB-INF/web.xml already added, skipping
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  11.900 s
[INFO] Finished at: 2025-07-12T11:33:42Z
[INFO] ------------------------------------------------------------------------

root@k8s-node01:~# ls -ltr hello-war/target/hello.war
-rw-r--r-- 1 root root 2842 Jul 12 11:33 hello-war/target/hello.war
```


```bash
cat <<EOF> Dockerfile
FROM tomcat:8.5-jre8-alpine
COPY hello-war/target/hello.war /usr/local/tomcat/webapps/

EOF

docker login

https://hub.docker.com/repositories/gstvo2k15

docker tag hello-tomcat-k8s:1.0 gstvo2k15/hello-tomcat-k8s:1.0
docker push gstvo2k15/hello-tomcat-k8s:1.0
```

`http://192.168.1.151:30080/hello/`
