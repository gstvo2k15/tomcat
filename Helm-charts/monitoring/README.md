```
    kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

```
NAME: prometheus-stack
LAST DEPLOYED: Wed Mar 19 17:05:01 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=prometheus-stack"

Get Grafana 'admin' user password by running:

  kubectl --namespace monitoring get secrets prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

Access Grafana local instance:

  export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=prometheus-stack" -oname)
  kubectl --namespace monitoring port-forward $POD_NAME 3000
```

```
kubectl get pods -o wide -n monitoring
NAME                                                     READY   STATUS    RESTARTS   AGE   IP              NODE         NOMINATED NODE   READINESS GATES
alertmanager-prometheus-stack-kube-prom-alertmanager-0   2/2     Running   0          27s   172.16.85.216   k8s-node01   <none>           <none>
prometheus-prometheus-stack-kube-prom-prometheus-0       2/2     Running   0          25s   172.16.85.217   k8s-node01   <none>           <none>
prometheus-stack-grafana-7f7b479ffb-99kvm                2/3     Running   0          37s   172.16.85.212   k8s-node01   <none>           <none>
prometheus-stack-kube-prom-operator-7d999f98d6-xvdgt     1/1     Running   0          37s   172.16.85.213   k8s-node01   <none>           <none>
prometheus-stack-kube-state-metrics-5f6c6568df-qvwxs     1/1     Running   0          37s   172.16.85.214   k8s-node01   <none>           <none>
prometheus-stack-prometheus-node-exporter-nds7b          0/1     Pending   0          37s   <none>          <none>       <none>           <none>
prometheus-stack-prometheus-node-exporter-pb8rb          1/1     Running   0          37s   192.168.1.150   k8s-master   <none>           <none>
prometheus-stack-prometheus-node-exporter-v6jkp          1/1     Running   0          37s   192.168.1.151   k8s-node01   <none>           <none>
prometheus-stack-prometheus-node-exporter-z9xz7          0/1     Pending   0          37s   <none>          <none>       <none>           <none>
```

```
kubectl --namespace monitoring get secrets prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
prom-operator
```

```
kubectl get svc -n monitoring
NAME                                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                       ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   116s
prometheus-operated                         ClusterIP   None             <none>        9090/TCP                     115s
prometheus-stack-grafana                    ClusterIP   10.98.42.145     <none>        80/TCP                       2m7s
prometheus-stack-kube-prom-alertmanager     ClusterIP   10.106.149.116   <none>        9093/TCP,8080/TCP            2m7s
prometheus-stack-kube-prom-operator         ClusterIP   10.104.46.118    <none>        443/TCP                      2m7s
prometheus-stack-kube-prom-prometheus       ClusterIP   10.101.179.244   <none>        9090/TCP,8080/TCP            2m7s
prometheus-stack-kube-state-metrics         ClusterIP   10.106.205.61    <none>        8080/TCP                     2m7s
prometheus-stack-prometheus-node-exporter   ClusterIP   10.106.128.143   <none>        9100/TCP                     2m7s
```


```
kubectl patch svc prometheus-stack-kube-prom-prometheus -n monitoring -p '{"spec": {"type": "NodePort"}}'
kubectl patch svc prometheus-stack-grafana -n monitoring -p '{"spec": {"type": "NodePort"}}'
kubectl patch svc prometheus-stack-kube-prom-alertmanager -n monitoring -p '{"spec": {"type": "NodePort"}}'
kubectl patch svc prometheus-stack-prometheus-node-exporter -n monitoring -p '{"spec": {"type": "NodePort"}}'

kubectl get svc -n monitoring
NAME                                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                         AGE
alertmanager-operated                       ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP      5m11s
prometheus-operated                         ClusterIP   None             <none>        9090/TCP                        5m10s
prometheus-stack-grafana                    NodePort    10.98.42.145     <none>        80:30612/TCP                    5m22s
prometheus-stack-kube-prom-alertmanager     NodePort    10.106.149.116   <none>        9093:30368/TCP,8080:30101/TCP   5m22s
prometheus-stack-kube-prom-operator         ClusterIP   10.104.46.118    <none>        443/TCP                         5m22s
prometheus-stack-kube-prom-prometheus       NodePort    10.101.179.244   <none>        9090:30843/TCP,8080:32481/TCP   5m22s
prometheus-stack-kube-state-metrics         ClusterIP   10.106.205.61    <none>        8080/TCP                        5m22s
prometheus-stack-prometheus-node-exporter   NodePort    10.106.128.143   <none>        9100:30296/TCP                  5m22s
```

```
http://192.168.1.151:30612      grafana
http://192.168.1.151:30368      alertmanager
http://192.168.1.151:30843      prometheus
http://192.168.1.151:30296/metrics  node-exporter


```

```

```


```

```


```

```


```

```
