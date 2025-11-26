sudo yum update
##First of all, import the latest MySQL GPG key to your system.
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql
sudo rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
#download https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
yum install /tmp/mysql80-community-release-el7-3.noarch.rpm
## install mysql if error GKEY
yum install mysql-community-server --nogpgcheck -y

## start mysql and check
sudo yum install mysql-community-server 
sudo systemctl start mysqld 
## check defaul password
grep 'temporary password' /var/log/mysqld.log
Pass mysql and root Mysql@123
mysql -u root -p
###################################################
## reset password root
systemctl stop mysqld
sudo mysqld --skip-grant-tables &
mysqld --skip-grant-tables --user=mysql &
 mysql -u root

FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Mysql@123';
exit;

sudo mysqladmin -u root -p shutdown
sudo systemctl start mysqld
sudo systemctl status mysqld
mysql -u root
password: 


## change password for root
mysql_secure_installation
##
vim /etc/my.cnf
#add line under [mysqld]:
server-id=1 
#log_bin=/var/log/mysql/mysql-bin.log 
#binlog_do_db=replication_database`

#with:
server-id để xác định các mysql server, nếu không khai báo thông số này mysql server sẽ mặc định server-id là 0 hay 
nếu đặt server-id trên các mysql server giống nhau thì sẽ không nhận các kết nối từ các server mysql khác.
log_bin để khai báo file log ghi lại các thay đổi dữ liệu
binlog_do_db để xác định database sẽ được replication
### ON MASTER MYSQL
mysql -u root -p 
# create user replication
##############################################
# config with mysql > 8.0
vi /etc/my.cnf
default_authentication_plugin=mysql_native_password  ## add line
#################################################################
#create user
CREATE USER 'mysql'@'%' IDENTIFIED BY 'Mysql123@';
GRANT REPLICATION SLAVE ON *.* TO 'mysql'@'%';

flush privileges;

mysql> show master status; 
154


#### ON SLAVE MYSQL
vim /etc/my.cnf
[mysqld]
server-id=2
#relay-log=/var/lib/mysql/relay-bin.log
#binlog-do-db=replication_database
systemctl restart mysqld

CHANGE MASTER TO MASTER_HOST='192.168.56.160',
MASTER_USER='mysql',
MASTER_PASSWORD='Mysql123@',
MASTER_LOG_FILE='binlog.000007',
MASTER_LOG_POS=879;

mysql> start slave;
show slave status\G
stop slave;
================================================
##note
#check UUID if cron vm box, change UUID of slave
cd /var/lib/mysql
vi auto.cnf 
[auto]
#server-uuid=13a012b4-9834-11ef-bf93-0800279ca14f
systemctl restart mysqld
## service will create again UUID in auto.cnf file
## check action replication
start slave;
show slave status\G
stop slave;
#######################
#Check cluster mysql
1. Master node:
show master status;
show slave hosts;
2. Slave node;
show slave status\G 


########################
Link study:
https://sdsv.udemy.com/course/becoming-a-production-mysql-dba/learn/lecture/35023446#overview
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/install-mysql-amazon-linux.md

MYSQL File types
1. Data directory:
    datadir: default location: /var/lib/mysql
    ls -ltr /var/lib/mysql
2. Log files:
    default location: var/log/mysqld.log
3. Gloabl Configuration file:
    default local:  etc/my.cnf

#MYSQL executable programs
ls /usr/bin/mysql*
mysql
mysqladmin
mysqlbinlog

#Mysql shell commands
help:   \h or \?
quit:   \q 
status:     \s 
system:     \!
use:    \u  # use another databse
source: \.  # execute SQL file
prompt: \R  # change mysql prompt
edit:   

system df -h
system free -m
system pidof mysqld

system vi server.sql
SELECT @@hostname, @@version;
source server.sql
SELECT @@hostname, @@server_id;

#MYSQL socker file
mysql.sock: manages connections to the mysql server, location default is /var/lib/mysql
local connecttion = UNIX socker - remote connection = TCP/IP 
mysql.sock.lock and add pid 
sudo ls -ltr /var/lib/mysql 
pidof mysqld
cat /var/lib/mysql/mysql.sock.lock
##if delete this file then not connect to mysql, so need restart mysql for recreate file

## MYSQL global variables, setup for last long affect the whole SQL server operation
Global scope and SESSION scope
show global variables;
show global variables LIKE 'max_connections';
SET GLOBAL max_connections=300;

## MYSQL SESSION variables; setup for 1 session affect only the current session
show session variables;
show session variables like 'sql_mode';
SET SESSION sql_mode = NO_ZERO_IN_DATE;
exit
show session variables like 'sql_mode'; ## reset again first

## Seting system variables help:
dev.mysql .com/doc/refman/8.0/en/innodb-parameters.html
############################
# MYSQL show command:
1. SHOW statements:
SHOW DATABASES;
show tables like '%view%';
show binary logs;
show binlog events;
show engines;
show create table |user|database;
show errors;
show warnings;
show events;
show triggers;
show processlist;

show databases;
+----------------------+
| Database             |
+----------------------+
| information_schema   |
| mysql                |
| performance_schema   |
| replication_database |
| sys                  |
| test1                |
+----------------------+
use sys;
show tables;
show tables from mysql;
 
### MYSQL system databases
information_schema ## no insert, update, delete operations
mysql  ##               
performance_schema   |  ## information about events waits, database locks, memory allocation
replication_database | 
sys ##  database host summary about memory, storage, io
test1 

use information_schema;
show tables;
describe engines;
show processlist;
desc PROCESSLIST;
select id, user, host, db, time from processlist;
+----+-----------------+----------------------+--------------------+------+
| id | user            | host                 | db                 | time |
+----+-----------------+----------------------+--------------------+------+
| 16 | root            | localhost            | information_schema |    0 |
|  5 | event_scheduler | localhost            | NULL               | 8896 |
| 13 | mysql           | 192.168.56.161:38416 | NULL               | 8311 |
+----+-----------------+----------------------+--------------------+------+

use mysql
show tables;
select user, host from user;

use information_schema
select * from file_instances;

use sys;
select * from host_summary;

######################
# MYSQL connections;
localhost-connection
- localhost
- root@localhost 
specific-host-connection 
- host or IP address webserver01 or 192.168.10.10
- app_user@webserver01
any-host-connection:
- % #any location
- dba@%

use mysql
show tables;
desc user;
select user, host from user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| mysql            | %         | #any location
| slave            | %         |
| mysql.infoschema | localhost | # only from localhost
| mysql.session    | localhost |
| mysql.sys        | localhost |
| root             | localhost |
+------------------+-----------+

###########
##MYSQL SHELL
##MYSQL Workbench install PC window for remote.
mysqlsh 
syntax: mysqlsh>\connect -mysql user@server:port # bob@centos7:3306


