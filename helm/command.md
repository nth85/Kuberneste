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
