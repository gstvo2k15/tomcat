
`tar -xvzf ingress-tomcat.tar.gz`

`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.crds.yaml`

`kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/main/config/manifests/metallb-native.yaml`

`helm install ingress-tomcat ./ingress-tomcat --namespace ingress-nginx --create-namespace`

`kubectl get all -n ingress-nginx`
```
NAME                            READY   STATUS    RESTARTS   AGE
pod/cm-acme-http-solver-jfbjf   1/1     Running   0          35s
```

`kubectl get svc -n ingress-nginx`
```
NAME                        TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
cm-acme-http-solver-dq2wm   NodePort   10.101.24.129   <none>        8089:32740/TCP   54s
```

`kubectl get secrets -n ingress-nginx | grep ingress-tomcat`
```
sh.helm.release.v1.ingress-tomcat.v1   helm.sh/release.v1   1      70s
```

`helm upgrade --install ingress-tomcat ./ingress-tomcat --namespace ingress-nginx --create-namespace`


```
kubectl get pods -o wide -n ingress-nginx
NAME                        READY   STATUS    RESTARTS   AGE     IP              NODE         NOMINATED NODE   READINESS GATES
cm-acme-http-solver-8ckt4   1/1     Running   0          5m33s   172.16.85.202   k8s-node01   <none>           <none>

stern . -n ingress-nginx --tail 50
+ cm-acme-http-solver-8ckt4 › acmesolver
cm-acme-http-solver-8ckt4 acmesolver I0319 16:20:15.051777       1 solver.go:52] "starting listener" logger="cert-manager.acmesolver" expected_domain="helmgolmolab.duckdns.org" expected_token="2C_Rz2tbXyzZebKOv8Gil4rZQF607XkbEKSR4gOsZKw" expected_key="2C_Rz2tbXyzZebKOv8Gil4rZQF607XkbEKSR4gOsZKw.iDH70iea7FR2MF7PvOJ0Bf0wvaEYSC8VM8IJr4d7uS4" listen_port=8089

kubectl get svc -n ingress-nginx
NAME                        TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
cm-acme-http-solver-df46v   NodePort   10.101.146.52    <none>        8089:30703/TCP   6m4s
tomcat-service              NodePort   10.106.198.232   <none>        8080:30080/TCP   6m9s

curl -I http://192.168.1.121:30080/

curl: (7) Failed to connect to 192.168.1.121 port 30080 after 3090 ms: Could not connect to server

ip a s |grep 192
    inet 192.168.1.151

kubectl get deployments -n ingress-nginx
No resources found in ingress-nginx namespace.

kubectl get pods -A | grep tomcat

```

### Solving issue about ingress-nginx

```
helm upgrade --install ingress-tomcat ./ingress-tomcat --namespace ingress-nginx --create-namespace
Release "ingress-tomcat" has been upgraded. Happy Helming!
NAME: ingress-tomcat
LAST DEPLOYED: Wed Mar 19 16:30:27 2025
NAMESPACE: ingress-nginx
STATUS: deployed
REVISION: 3
TEST SUITE: None
```
```
kubectl get pods -n ingress-nginx
NAME                        READY   STATUS    RESTARTS   AGE
cm-acme-http-solver-8ckt4   1/1     Running   0          11m
tomcat-cf8fc7747-s9xv8      1/1     Running   0          66s
```
```
stern . -n ingress-nginx --tail 50
+ tomcat-cf8fc7747-s9xv8 › tomcat
+ cm-acme-http-solver-8ckt4 › acmesolver
tomcat-cf8fc7747-s9xv8 tomcat NOTE: Picked up JDK_JAVA_OPTIONS:  --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.util.concurrent=ALL-UNNAMED --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.157 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version name:   Apache Tomcat/9.0.102
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.165 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          Mar 3 2025 19:33:14 UTC
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.166 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version number: 9.0.102.0
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.166 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.167 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            6.11.0-19-generic
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.168 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.168 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /opt/java/openjdk
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.168 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           21.0.6+7-LTS
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.171 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Eclipse Adoptium
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.174 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /usr/local/tomcat
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.175 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /usr/local/tomcat
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.197 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang=ALL-UNNAMED
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.202 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang.invoke=ALL-UNNAMED
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang.reflect=ALL-UNNAMED
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.204 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.io=ALL-UNNAMED
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.206 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util=ALL-UNNAMED
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.208 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util.concurrent=ALL-UNNAMED
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.210 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.212 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.213 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.214 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djdk.tls.ephemeralDHKeySize=2048
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.215 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.protocol.handler.pkgs=org.apache.catalina.webresources
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.216 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dsun.io.useCanonCaches=false
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.217 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dorg.apache.catalina.security.SecurityListener.UMASK=0027
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.217 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dignore.endorsed.dirs=
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.217 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/usr/local/tomcat
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.218 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/usr/local/tomcat
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.218 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/usr/local/tomcat/temp
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.245 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent Loaded Apache Tomcat Native library [1.3.1] using APR version [1.7.2].
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.247 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent APR capabilities: IPv6 [true], sendfile [true], accept filters [false], random [true], UDS [true].
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.248 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent APR/OpenSSL configuration: useAprConnector [false], useOpenSSL [true]
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:58.255 INFO [main] org.apache.catalina.core.AprLifecycleListener.initializeSSL OpenSSL successfully initialized [OpenSSL 3.0.13 30 Jan 2024]
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:59.005 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:59.056 INFO [main] org.apache.catalina.startup.Catalina.load Server initialization in [1425] milliseconds
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:59.153 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service [Catalina]
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:59.155 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet engine: [Apache Tomcat/9.0.102]
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:59.177 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:30:59.300 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [236] milliseconds
cm-acme-http-solver-8ckt4 acmesolver I0319 16:20:15.051777       1 solver.go:52] "starting listener" logger="cert-manager.acmesolver" expected_domain="helmgolmolab.duckdns.org" expected_token="2C_Rz2tbXyzZebKOv8Gil4rZQF607XkbEKSR4gOsZKw" expected_key="2C_Rz2tbXyzZebKOv8Gil4rZQF607XkbEKSR4gOsZKw.iDH70iea7FR2MF7PvOJ0Bf0wvaEYSC8VM8IJr4d7uS4" listen_port=8089
```

```
kubectl get pods -n ingress-nginx
NAME                        READY   STATUS    RESTARTS   AGE
cm-acme-http-solver-8ckt4   1/1     Running   0          28m
tomcat-cf8fc7747-s9xv8      1/1     Running   0          18m

kubectl cp /root/uvc.war -n ingress-nginx $(kubectl get pod -n ingress-nginx -l app=tomcat -o jsonpath="{.items[0].metadata.name}"):/usr/local/tomcat/webapps/

stern . -n ingress-nginx --tail 20
+ cm-acme-http-solver-8ckt4 › acmesolver
+ tomcat-cf8fc7747-s9xv8 › tomcat
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.lang.reflect.Constructor.newInstanceWithCaller(Constructor.java:502)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.lang.reflect.Constructor.newInstance(Constructor.java:486)
tomcat-cf8fc7747-s9xv8 tomcat           at org.apache.tomcat.util.compat.Jre9Compat.jarFileNewInstance(Jre9Compat.java:206)
tomcat-cf8fc7747-s9xv8 tomcat           ... 35 more
tomcat-cf8fc7747-s9xv8 tomcat   Caused by: java.util.zip.ZipException: zip END header not found
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.util.zip.ZipFile$Source.findEND(ZipFile.java:1649)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.util.zip.ZipFile$Source.initCEN(ZipFile.java:1657)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.util.zip.ZipFile$Source.<init>(ZipFile.java:1495)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.util.zip.ZipFile$Source.get(ZipFile.java:1458)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.util.zip.ZipFile$CleanableResource.<init>(ZipFile.java:724)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.util.zip.ZipFile.<init>(ZipFile.java:251)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.util.zip.ZipFile.<init>(ZipFile.java:180)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/java.util.jar.JarFile.<init>(JarFile.java:345)
tomcat-cf8fc7747-s9xv8 tomcat           at java.base/jdk.internal.reflect.DirectConstructorHandleAccessor.newInstance(DirectConstructorHandleAccessor.java:62)
tomcat-cf8fc7747-s9xv8 tomcat           ... 38 more
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:48:52.161 INFO [Catalina-utility-2] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/uvc.war] has finished in [836] ms
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:49:12.189 INFO [Catalina-utility-1] org.apache.catalina.startup.HostConfig.undeploy Undeploying context [/uvc]
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:49:12.197 INFO [Catalina-utility-1] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/webapps/uvc.war]
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:49:24.645 INFO [Catalina-utility-1] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.
tomcat-cf8fc7747-s9xv8 tomcat 19-Mar-2025 16:49:26.148 INFO [Catalina-utility-1] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/uvc.war] has finished in [13,950] ms
cm-acme-http-solver-8ckt4 acmesolver I0319 16:20:15.051777       1 solver.go:52] "starting listener" logger="cert-manager.acmesolver" expected_domain="helmgolmolab.duckdns.org" expected_token="2C_Rz2tbXyzZebKOv8Gil4rZQF607XkbEKSR4gOsZKw" expected_key="2C_Rz2tbXyzZebKOv8Gil4rZQF607XkbEKSR4gOsZKw.iDH70iea7FR2MF7PvOJ0Bf0wvaEYSC8VM8IJr4d7uS4" listen_port=8089
```


`curl -ik http://192.168.1.151:30080/uvc/`
```
HTTP/1.1 200
    <title>Univiewer Console 7.00.21</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <style type="text/css">

<div class="requirement">
  <p>Click on GO to start UniViewer Console.<br />
  Make sure that you have Java installed on your computer (Supported Java versions are listed in the compatibility matrix).<br />
  If you don't, you can download Java from the <a href="http://www.java.com/" name="www.java.com">Official Java Website</a>.</p>
 </div>
```


