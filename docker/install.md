**Setup docker lên centos 7**
```
sudo yum update -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
**Install Docker Engine**
```
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
 sudo systemctl start docker
```
**start docker**
```
 sudo systemctl start docker
  sudo systemctl enable docker
```
** test**
```
sudo docker run hello-world
```
**Install docker compose**
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
```
sudo chmod +x /usr/local/bin/docker-compose
```
*Test**
```
docker-compose --version
```


