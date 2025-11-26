1. Mysql configuration
#######################
mysqld, mysqladmin, mysqlimport, myslqdump, mysql 
program -verbose -help # to get which default option file this programs uses
any program start with -no-default option reads no option file other than .mylogin.cnf
# Option files format:
Option files are plain-text files -except .mylogin.cnf, encrypted by mysql_config_editor
#Option file processing order:
- Global Options: /etc/my.cnf, /etc/mysql/my.cnf
- server only options: $MYSQL_HOME/my.cnf
- user-specific options: ~/.my.cnf
- Client-only options: ~/.mylogin.cnf
##
mysqld --verbose --help less
##
mysql
show variables like '%server%'

vi /etc/my.cnf
[mysqld]
server-id=1
default_authentication_plugin=mysql_native_password
#Data directory
datadir=/var/lib/mysql
#socket file
socket=/var/lib/mysql/mysql.sock
#logs file
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

systemctl restart mysqld
#######################
2. change defaul file config
#####################
create /etc/my.cnf
cp /etc/my.cnf  /etc/mysql/my.cnf
mv /etc/my.cnf /etc/my.cnf.old
restart mysqld
# server still running with new config location

3. Strace & LSOF with mysql
#####################
which option file was read
- stop mysqld server
- start with strace mysqld
- observer the output
#
systemctl stop  mysqld
strace mysqld
systemctl start  mysqld
yum install -y lsof
sudo lsof -u mysql
##

4. Option file inclusions
#####################
Step 1. Modify /etc/my.cnf file to add last line
$ sudo vim /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

!includedir /etc/my.cnf.d/

Step 2. Create /etc/my.cnf.d/<hostname>.cnf file
$ sudo touch /etc/my.cnf.d/$(hostname).cnf

Step 3. Modify file to add line
$ sudo vim /etc/my.cnf.d/$(hostname).cnf
[mysqld]
server-id=10

Step 4. Restart MySQL service
$ sudo systemctl restart mysqld.service

Step 5. Verify Server Id
mysql> show variables like 'server_id';
# server will load all file config at the !includedir /etc/my.cnf.d/ for config service

5. DATA_DIR mysql data directory
#####################
/var/lib/mysql #default
- controlled by datadir option in my.cnf
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/mysql-configuration.md

cd /var/lib/mysql
systemct stop mysqld
mkdir prod
chown -R mysql:mysql prod
mv * prod/
vi /etc/my.cnf
#modify
datadir = /var/lib/mysql/prod
systemctl start mysqld
mysql
show global variables like 'datadir';

6. Binary log files
#####################
Default size is 1GB controlled by max_binlog_size
binlog_expire_logs_seconds # retention days
Enable Binary Logging:
- enabled by default - system variable log_in ON
- log_bin_basename - binlog | mysqld-bin | prod-bin
- log_bin_index - binlog.index | mysqld-bin.index | prod-bin.index
Disable binary logging:
- skip-log-bin | disable-log-bin 
##
mysql 
SHOW BINARY LOGS;
SHOW BINARY EVENTS IN 'binlog.0000004';
#remove binary logs from first to 000003
PURGE BINARY LOGS TO 'binlog.000003';
## disable binary log
vi /etc/my.cnf
disable-log-bin ## add more
systemctl restart mysqld

### Changing Binary Log files location
Step 1. Create directory for Binary log files
$ sudo mkdir -p /var/log/mysql/binlog

Step 2. Add following lines to /etc/my.cnf.d/common.cnf
log-bin=/var/log/mysql/binlog/mysqld-bin
log-bin-index=/var/log/mysql/binlog/mysqld-bin.index

Step 3. Chown directory by mysql
$ sudo chown -R mysql:mysql /var/log/mysql

Step 4. Restart MySQL Server
$ sudo systemctl restart mysqld.service
## Binlog retention
show variables like '%expire%'
echo $((2592000/86400)) =day
mysqld --verbose --help | grep expire_logs
vi /etc/my.cnf
binlog_expire_logs_seconds = 432000 #5day retetion
systemctl restart mysqld
show variables like '%expire%'
#############

7. Error log files
#####################
record of mysqld startup and shutdown tinme
default error log is /var/log/mysqld.log
#change dir log
mkdir /var/log/mysql/errorlog
touch /var/log/mysql/errorlog/mysqld.log
sudo chown -R mysql:mysql /var/log/mysql
vi /etc/my.cnf
log-error = /var/log/mysql/errorlog/mysqld.log
systemctl restart mysqld
## change body time log
mysqld --verbose --help | grep -i timestamp
log-timestamps
vi /etc/my.cnf
log-timestamps = SYSTEM
systemctl restart mysqld

8. Temp Directory ## thu muc tam thoi
#####################
Directory where Mysql stores temporary files
tmpdir default is /tmp , /var/tmp
#
show variables like '%tmp%';
mysqld --verbose --help | grep -i tmp

mkdir /var/log/mysql/tmpdir
sudo chown -R mysql:mysql /var/log/mysql/tmpdir
vi /etc/my.cnf
tmpdir = /var/log/mysql/tmpdir
systemctl restart mysqld
show variables like '%tmp%';