## https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/
**Add cert for policy**
- vi /etc/profile
- source /etc/profile
- add cert
- vi /etc/pki/ca-trust/source/anchors/cert.crt
- update-ca-trust

**Add host**
```
cat >> /etc/hosts<< EOF
192.168.56.120 masterk8s-01
192.168.56.121 datak8s-01
EOF
```
```
cat >> /etc/resolv.conf<< EOF
nameserver 203.241.132.34
nameserver 203.241.135.135
EOF
```

**disable swap**
```
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 
sudo swapoff -a 
```

**sysctl params required by setup, params persist across reboots**
```
cat <<EOF | sudo tee /etc/sysctl.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
vm.swappiness=0
EOF
```

**Apply sysctl params without reboot**
```
sudo sysctl --system
```
**Apply sysctl params without reboot**
```
sudo sysctl --system
```
**verify**
```
lsmod | grep br_netfilter
lsmod | grep overlay
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
```
```
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
#load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter
```
**Install containerd**
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install containerd.io
systemctl status contarnerd
systemctl enable contarnerd
systemctl start contarnerd
```
**Install kubeadm**
```
sudo vi /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.k8s.io/pause:3.2"
```
```
systemctl restart containerd
```
**Create repository**
```
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
```
**Install kubelet kubeadm kubectl**
```
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
```
```
yum install -y kubeadm-1.27.0-0.x86_64 kubelet-1.24.0 kubectl-1.24.0
systemctl enable kubelet
systemctl start kubelet
```
**if not run intall  runc**
```
rmp -ivh libseccomp-2.3.1-4.el7-x86_64.rpm
```
# SET NODE MASTER

- init cluster
- kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version 1.21.0 --apiserver-advertise-address 192.168.56.120
```
kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version 1.27.15 --apiserver-advertise-address=192.168.56.120
```
**If not run, run command below**
```
modprobe br_netfilter
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forwa
```
**check cluster**
- file config
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):(id -g) $HOME/.kube/config
```
```
kubectl get pods -n kube-system
kubectl get nodes
```
**instal calico**
- download
```
wget  https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/calico.yaml
kubectl apply -f calico.yaml
```
**Create token for join node data**
```
kubeadm token create --print-join-command
```
**Use token for join other node to cluster**
```
kubeadm join 192.168.56.120:6443 --token fat3ia.hd2lzyo2lg1ctyey --discovery-token-ca-cert-hash sha256:a9d58893b2214adebee7f84e1243872e1426cfecf47068c2bc15555b7f399d5d
```
# install bash nhắc lệnh trong kubectl 
```
yum install bash-completion
vi .bashrc
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi
```
source .bashrc
**verify**
type _init_completion
**kubectl nhac lenh**
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
**user k=kubectl**
```
 echo 'alias k=kubectl' >> .bashrc
 echo 'complete -o default -F __start_kubectl k' >> .bashrc
 source .bashrc
```
