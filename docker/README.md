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

## ArgoCD problems with minikube and MetalLB with ingress-nginx

`minikube status`
```
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

`kubectl get svc -n argocd`
```
NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                         AGE
argocd-applicationset-controller   ClusterIP      10.107.92.63     <none>          7000/TCP                        23h
argocd-dex-server                  ClusterIP      10.99.194.30     <none>          5556/TCP,5557/TCP               23h
argocd-redis                       ClusterIP      10.111.117.215   <none>          6379/TCP                        23h
argocd-repo-server                 ClusterIP      10.106.98.174    <none>          8081/TCP                        23h
argocd-server                      LoadBalancer   10.108.223.125   192.168.1.222   9980:31593/TCP,9943:32409/TCP   20h
cm-acme-http-solver-vptj5          NodePort       10.99.2.219      <none>          8089:31390/TCP                  14h
```

`kubectl get svc -n argocd -o wide`
```
NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                         AGE   SELECTOR
argocd-applicationset-controller   ClusterIP      10.107.92.63     <none>          7000/TCP                        23h   app.kubernetes.io/instance=argocd,app.kubernetes.io/name=argocd-applicationset-controller
argocd-dex-server                  ClusterIP      10.99.194.30     <none>          5556/TCP,5557/TCP               23h   app.kubernetes.io/instance=argocd,app.kubernetes.io/name=argocd-dex-server
argocd-redis                       ClusterIP      10.111.117.215   <none>          6379/TCP                        23h   app.kubernetes.io/instance=argocd,app.kubernetes.io/name=argocd-redis
argocd-repo-server                 ClusterIP      10.106.98.174    <none>          8081/TCP                        23h   app.kubernetes.io/instance=argocd,app.kubernetes.io/name=argocd-repo-server
argocd-server                      LoadBalancer   10.108.223.125   192.168.1.222   9980:31593/TCP,9943:32409/TCP   20h   app.kubernetes.io/name=argocd-server
cm-acme-http-solver-vptj5          NodePort       10.99.2.219      <none>          8089:31390/TCP                  14h   acme.cert-manager.io/http-domain=2362378830,acme.cert-manager.io/http-token=1024200259,acme.cert-manager.io/http01-solver=true
```

`kubectl get pods -n argocd`
```
NAME                                                READY   STATUS    RESTARTS      AGE
argocd-application-controller-0                     1/1     Running   2 (30m ago)   23h
argocd-applicationset-controller-74959d5557-klknh   1/1     Running   2 (30m ago)   23h
argocd-dex-server-9f84ccbf4-h9x7l                   1/1     Running   2 (30m ago)   23h
argocd-notifications-controller-6474d7d4b6-hrjkm    1/1     Running   2 (30m ago)   23h
argocd-redis-5964bcc74-k8wbq                        1/1     Running   2 (30m ago)   23h
argocd-repo-server-b47f56ddf-xmr77                  1/1     Running   2 (30m ago)   23h
argocd-server-58fb97fd56-hr866                      1/1     Running   2 (30m ago)   20h
cm-acme-http-solver-6fsxr                           1/1     Running   1 (30m ago)   14h
```

`minikube service argocd-server -n argocd --url`
```
http://192.168.49.2:31593
http://192.168.49.2:32409
```

`curl -I http://192.168.49.2:31593`
```
HTTP/1.1 307 Temporary Redirect
Content-Type: text/html; charset=utf-8
Location: https://192.168.49.2:31593/
Date: Wed, 19 Mar 2025 09:10:06 GMT
```

`curl -I http://192.168.49.2:32409`
```
HTTP/1.1 307 Temporary Redirect
Content-Type: text/html; charset=utf-8
Location: https://192.168.49.2:32409/
Date: Wed, 19 Mar 2025 09:10:15 GMT
```

### Changing metallb and ingress to NodePort
```
kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.96.95.170   192.168.1.223   80:30228/TCP,443:31313/TCP   18h
ingress-nginx-controller-admission   ClusterIP      10.100.4.251   <none>          443/TCP                      18h


kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec": {"type": "NodePort"}}'
service/ingress-nginx-controller patched


kubectl get svc -n ingress-nginx
NAME                                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.96.95.170   <none>        80:30228/TCP,443:31313/TCP   18h
ingress-nginx-controller-admission   ClusterIP   10.100.4.251   <none>        443/TCP                      18h


minikube ip
192.168.49.2

       proxy_pass        https://192.168.49.2:31593;

kubectl get ingress -n argocd
NAME                        CLASS    HOSTS                        ADDRESS        PORTS     AGE
argocd-ingress              nginx    argocdgolmolab.duckdns.org   192.168.49.2   80, 443   17h
cm-acme-http-solver-ntpfl   <none>   argocdgolmolab.duckdns.org   192.168.49.2   80        117m
```

### With real SSL for this endpoint using local nginx as reverseproxy
```
sudo certbot --nginx -d argocdgolmolab.duckdns.org --agree-tos --email gstvo2k15@gmail.com

Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for argocdgolmolab.duckdns.org

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/argocdgolmolab.duckdns.org/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/argocdgolmolab.duckdns.org/privkey.pem
This certificate expires on 2025-06-17.



sudo mv /etc/nginx/conf.d/minikube.conf /etc/nginx/conf.d/minikube.conf.bak


cat <<EOF > /etc/nginx/conf.d/argocdgolmolab.conf
# --- Redirección de HTTP a HTTPS ---
server {
    listen 80;
    server_name argocdgolmolab.duckdns.org;
    return 302 https://argocdgolmolab.duckdns.org;
}

# --- Servidor HTTPS con Let's Encrypt ---
server {
    listen 443 ssl;
    server_name argocdgolmolab.duckdns.org;

    ssl_certificate     /etc/letsencrypt/live/argocdgolmolab.duckdns.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/argocdgolmolab.duckdns.org/privkey.pem;

    location / {
       # Tu ArgoCD está en https://192.168.49.2:31593
       proxy_pass        https://192.168.49.2:31593;
       proxy_ssl_verify  off;

       # Cabeceras básicas sin variables raras:
       proxy_set_header  Host $http_host;
       proxy_set_header  X-Real-IP $remote_addr;
       proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

EOF

cat -A /etc/nginx/conf.d/argocdgolmolab.conf

sudo apt install -yqq dos2unix
dos2unix /etc/nginx/conf.d/argocdgolmolab.conf

nginx -t

systemctl reload nginx
```
