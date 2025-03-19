```
helm package elk
Successfully packaged chart and saved it to: /root/tomcat/Helm-charts/elk-1.0.0.tgz

helm upgrade elk elk-1.0.0.tgz -n elk --create-namespace
Release "elk" has been upgraded. Happy Helming!
NAME: elk
LAST DEPLOYED: Wed Mar 19 18:19:30 2025
NAMESPACE: elk
STATUS: deployed
REVISION: 4
TEST SUITE: None

kubectl get svc -o wide -n elk
NAME            TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
elasticsearch   NodePort   10.107.83.122   <none>        9200:30092/TCP   16m   app=elasticsearch
kibana          NodePort   10.101.8.40     <none>        5601:30094/TCP   16m   app=kibana
logstash        NodePort   10.97.121.163   <none>        5044:30093/TCP   16m   app=logstash
```