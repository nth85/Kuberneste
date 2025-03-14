**Get api**

kubectl get nodes --show-labels

kubectl get nodes -l name=k8s-cluster

**Add label into node**

kubectl label nodes <node-name> <label-key>=<label-value>

ex: kubectl label nodes node1 name=k8s-cluster
ex: kubectl label nodes node1 name=k8s-cluster env=production

- delete label out off node:
kubectl label nodes <node-name> <label-key>-

**Selecter node schedule by lable**

spec:
  nodeSelector:
    name: k8s-cluster

- 
