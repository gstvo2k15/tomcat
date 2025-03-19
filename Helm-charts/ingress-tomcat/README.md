
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











