**Install by script**
```
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
**download helm version**
```
https://github.com/helm/helm/releases
```
```
tar -zxvf helm-v3.0.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
helm version
```

**add repo**
```
helm repo add my-repo https://charts.bitnami.com/bitnami
helm repo update
helm repo list
helm search repo elastic
```
**remove repo**
```
helm repo remove elastic
```
**pull kustomization**
```
helm template --vadi... --output-dir . -f values.yaml --namespace logstash logging bitnami/logstash
```
**helm install**
```
helm install happy-panda bitnami/wordpress
helm install -f values.yaml bitnami/wordpress --generate-name
```
- status
``` 
helm status happy-panda
```
- check values befor install
```
helm show values bitnami/wordpress
```
- helm update
```
helm upgrade -f panda.yaml happy-panda bitnami/wordpress
helm get values happy-panda
helm rollback happy-panda 1
```
**helm uninstall**
```
helm uninstall happy-panda
helm list
helm list --all

```


