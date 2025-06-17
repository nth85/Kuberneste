**nslookup phân giải các địa chỉ ip**
```
nslookup 24h.com.vn
```
**Base linux**
```
uname -a
uptime
stat /etc/rsyslog.conf #check date modify, chang, access
top /htop
df -h
du -sh *
free -h
ls -al
find . -name "foo"
grep -r "bar"

ip a
ss -tuln
cur -I URL
telnet ip port

chmod +x file
chown user:user file

tar -xzvf file.tar.gz
tar -tf file.tar.gz # chec detail file
tar -zcf newnamefile.tar.gz file1 file2 # zip file

scp file user@host:/path

```
**Create repo local on Redhat8**
```
vi /etc/yum.repo/local.repo
[local-BaseOS]
name=DVD for RHEL - BaseOS
baseurl=file:///mnt/cdrom/BaseOS/
enable=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[local-AppStream]
name=DVD for RHEL - AppStream/
baseurl=file:///mnt/cdrom/AppStream/
enable=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

mkdir /mnt/cdrom
mount /dev/sr0 /mnt/cdrom
yum clean all
yum repolist
```
**curl noproxy**
``` 
curl --noproxy '*' https://dantri.com.vn
```

https://tailscale.com/kb/1476/install-ubuntu-2404

**mount disk <2TB**
```
printf "p\nn\np\n1\n\n\nt\n8e\np\nw" | sudo fdisk /dev/sdb
pvcreate /dev/sdb1
vgcreate VG00 /dev/sdb1
lvcreate -l 100%FREE -n LV_data VG00
mkfs.xfs /dev/VG00/LV_data
mkdir /data
echo "/dev/mapper/VG00-LV_data /data xfs defaults 0 0" >> /etc/fstab
mount -a 

sudo chown -R cmpprod:cmpprod /data 
## verify disk mounted
df -h 
```
**mount disk >2TB**
```
sudo parted /dev/sdb
mklabel gpt
mkpart primary 2048s -1
Ignore
quit

printf "p\nn\np\n1\n\n\nt\n8e\np\nw" | sudo fdisk /dev/sdb
pvcreate /dev/sdb1
vgcreate VG00 /dev/sdb1
lvcreate -l 100%FREE -n LV_data VG00
mkfs.xfs /dev/VG00/LV_data
mkdir /data
echo "/dev/mapper/VG00-LV_data /data xfs defaults 0 0" >> /etc/fstab
mount -a 

sudo chown -R cmpprod:cmpprod /data 
## verify disk mounted
df -h 
```
**Create "cmpprod" User**
```
groupadd -g 1001 cmpprod
useradd -m -g 1001 -u 1001 -c cmpprod -s /bin/bash cmpprod
touch /home/cmpprod/.rhosts
echo "export TMOUT=1800" >> /home/cmpprod/.bash_profile
echo "umask 0022" >> /home/cmpprod/.bash_profile
echo "cmpprod ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/cmpprod
passwd cmpprod
```
**firewall and selinux**
```
systemctl stop firewalld
systemctl disable firewalld
sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/sysconfig/selinux
```
**rsyslog**
- into config of service HAproxy
```
logging:
  diver: "syslog"
  options:
    syslog-address: "tcp://172.27.16.167:514"
    syslog-facility: "local0"
```
- logrotate
```
cd /etc/logrotate.d/
vi haproxy_logrotae
/haproxy/logs/*.log {
    su root root
    monthly
    missingok
    rotate 6
    dateformat -%Y%m
    dateyesterday
    dateext
    compress
    delaycompress
    notifempty
    copytruncate
}
sudo logrotate -d /etc/logrotate.conf
sudo logrotate -d /etc/logrotate.d/haproxy_logrotate  # option -f run now not wait time, -v print scem detail information --debug
sudo logrotate -f /etc/logrotate.d/haproxy_logrotate
```
**Check config modify**
```
lscpu
lsmem

stat /etc/file #check time file modify

crontab -e
sudo crontab -e -u cmpprod
crontab -l
which crontab

sysctl vm.swappiness
vi /etc/sysctl.config
vm.swappiness=1

lsblk --output NAME,KNAME,TYPE,MAJ:MIN,FSTYPE,SIZE,RA,MOUNTPOINT,LABEL
blockdev --setra 256 /dev/dm-2

du -Sh --time /data/* | sort -rh | head -n 20

sudo chage -d 2025422 nt.huy
sudo change -M 90 nt.huy

bash -x filescript.sh

journalctl -xefu
journalctl -u rsyslog -f

cp -a /file   /tmp/flie$(data "+%Y%m%d_%H%M")

ansible all -m ping -i inventories/hosts
ansible-playbook -i inventories/hosts playbook -k

ll alh

zip -r logstash.zip logstash

tar -zcf namefile.tar.gz file1 file2...
tar -tf file.tar.gz # check noi dung file
tar -zxvf file.tar.gz 
- check cpu
ps -aux --sort=-pcpu | head -n 10 ## check cpu
```
**FIND FILE**
```
sudo su -
cd /etc/
grep -lr "myhostname" *
```
- Back up filke
```
cp -a file /tmp/file$(date "+%Y%m%d_%H%M").back
```
**SSH**
- ssh use key
```
ssh root@192.168.56.111 -i file-key.pem
```
- Run Ansibale warning "sftp transfer mechanism failed on IP" check on server remote
```
sudo cat /etc/ssh/sshd_config | grep Subsystem
Subsystemsftp/usr/libexec/openssh/sftp-#server
```
```
vi /etc/hosts.deny
vi /etc/hosts.allow
```
- Crate ssh-keygen
```
cd /home/user/.ssh
ssh-copy-id 192.168.56.100
ssh-copy-id root@192.168.56.101
ssh
```
**check sync between server and NTP server**
```
chronyc sources -n
chronyc tracking
```
**see log.gz file on server**
```
zcat logstash-plain-...log.gz
```
**Watch stop 2 s**
```
watch -n 2 "du -sh /data/ls/queue/""
```
**Journal**
```
journalctl -xefu
journalctl -u rsyslog -f
cat /etc/systemd/journal.conf
```
**Local repo**
```
[LocalRepo]
name=Local
baseurl=file:///mnt/cdrom
enabled=1
gpgcheck=1
gpgkey=file:///mnt/cdrom/
```
**Grep line**
```
netstat -npa | grep -i etcd | grep -i 2379 | wc -l

```
**gioi han thoi gian chay lenh**
```
timeout -s 9 10 top
timelimit -t10 top
```

**Ansible**
```
ansible all -m ping -i inventories/hosts
ansible-playbook -i inventories/hosts playbook -k

ll -alh
cd .ansible
```







