which mysql
ls -ltr /usr/bin/mysql
file /usr/bin/mysql
===================
sudo grep password /var/log/mysqld.log ## get password mysql first
mysql -u root -p 
SELECT @@hostname, @server_id, @@version;
==========================
## Data Directory
- Also known as datadir
- Default location: /var/lib/mysql
## Log file
- Default location is: /var/log/mysqld.log 
## Global Configuration file:
- Default location is: /etc/my.cnf
- contains all the configuration setting that will be loaded when server starts
---
sudo ls -ltr /var/lib/mysql
grep mysql /etc/passwd
---
sudo ls -ltr /var/log 
================================
##Mysql executable programs
rpm -qa | grep -i mysql
ls /usr/bin/mysql*
=============================================================
###MYSQL Shell commands
help:  \h or \?
quit:   quits or exits from Mysql shell - \q
status:   shortcut is \s 
system:  \!
use:  \u for short
source: \. execute sql file
prompt: \R  change mysql prompt
edit: 
=============================================================
###MYSQL socket file
mysql.sock
- default location is /var/lib/mysql
- local connection = UNIX socket - Remote connection = TCP/IP

sudo ls -ltr /var/lib/mysql
## have two file mysql.sock and mysql.sock.lock -- if delete this 2 files then not connect to mysql, so need restart mysql service and auto create again two files.
===============================================================
### Mysql global variables
-- global variables affect the overall operation of mys SQL server, and each global variable has a default, set and initialize each gloable variable when it starts.

show global variables; ## have 689 global variables
show global variables LIKE 'max_connections';
show global variables LIKE 'max_connec%';
# change valua 
SET GLOBAL max_connections=300; ## but if restart mysql server then it again default (150).
show global variables LIKE 'max_connections';
# i want to make it a permanent.
### Mysql session variables.
-- session variables only affect the current session that i am logged in right after i quit my session, the session variables value goes back to what it was before.
SHOW SESSION variables;
show session variables LIKE 'sql_mode';

SET SESSION sql_mode = NO_ENGINE_SUBSTITUTION;
--and \q and connect again into mysql, it was before.
--------------------------------------------------------------------
## Getting system variables help;
https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_unique_checks
###
### SHOW command######################################
SHOW DATABASES;
SHOW TABLES LIKE '%view%';
SHOW BINARY LOGS;
SHOW BINLOG EVENTS;
SHOW BINLOG EVENTS;
SHOW ENGINES;
SHOW CREATE TABLE | USER | DATABASE;
SHOW ERRORS;
SHOW WARNINGS;
SHOW EVENTS;
SHOW TRIGGERS;
SHOW processlist;
### MYSQL System Databases
show databases;
use information_schema;
show tables;
## MYSQL connection
### MYSQL local vs remote connections.
################################################################
## Section4: BASIC MYSQL database Administration
1. Mysql config editor.## login to mysql without credentials
#set auto access mysql not add password
mysql_config_editor set --help
mysql_config_editor set --user=root --password --login-path=client
mysql_config_editor print
mysql -u root -p
2.## Mysql admin program.
mysqladmin version
mysqladmin ping
mysqladmin create employyes
### Mysql excute sql files
USE employees;
CREATE TABLE IF NOT EXISTS staff (
  id in NOT NULL AUTO_INCREMENT PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  title VARCHAR(50) NULL,
  isActive CHAR(1) NOT NULL DEFAULT 'Y'  
);
# have 4 excute file into mysql database
1. access in mysql
mysql
mysql> use employees
mysql> source employees.sql
show tables;
drop table staff;
2. run command######################################
mysql --host=localhost < employees.sql
...
3. on mysql server 
vi employees.sh 
mysql --host=localhost <$1
chmod u+x employees.sh 
bash employees.sh employees.sql 
4. on mysql server
cat employees.sql | mysql
### 49 Executing SQL commands from Terminal.
mysql --execute="SELECT @@hostname, @@version"
mysql --execute="SELECT @@hostname, @@version;SELECT user, host from mysql.user"
mysql -e "SELECT @@hostname, @@version;SELECT user, host from mysql.user"

mysql -h 192.168.56.160 -u bob -p -e "SELECT @@hostname. now();" ## add password
5.### import staff.txt file
# create staff.txt file
vi staff.txt
John  Doe  Manager Y
Johny Doe  DBA     Y
Tom   Doe  Analyst Y
Tommy Doe  Tester  Y
# access mysql and check tables 
show databases;
use employees;
show tables;
\q
mysqlimport employees staff.txt 
## have errors :mysqlimport: Error: 1290, The MySQL server is running with the --secure-file-priv option so it cannot execute this statement, when using table: staff
mysql
show variables like 'secure_file_priv'
## and move file to value
\! df -h
\! mv staff.txt /var/lib/mysql-files/staff.txt
mysqlimport employees /var/lib/mysql-files/staff.txt
mysqlimport: Error: 1366, Incorrect integer value: 'John  Doe  Manager Y' for column 'id' at row 1, when using table: staff
mysql
use employees;
desc staff;
+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| id       | int(11)      | NO   | PRI | NULL    | auto_increment |
| fname    | varchar(255) | NO   |     | NULL    |                |
| lname    | varchar(255) | NO   |     | NULL    |                |
| title    | varchar(50)  | YES  |     | NULL    |                |
| isActive | char(1)      | NO   |     | Y       |                |
+----------+--------------+------+-----+---------+----------------+
5 rows in set (0.01 sec)
mysqlimport --help;

mysqlimport --columns=fname,lname,title,isActive --delete employees /var/lib/mysql-files/staff.txt
## note: between columns is tab not space
vi staff.txt
John    Doe     Manager Y
Johny   Doe     DBA     Y
Tom     Doe     Analyst Y
Tommy   Doe     Tester  Y
mysqlimport --columns=fname,lname,title,isActive --delete employees /var/lib/mysql-files/staff.txt
employees.staff: Records: 4  Deleted: 0  Skipped: 0  Warnings: 0

use employees;
mysql> select * from staff;
+----+-------+-------+---------+----------+
| id | fname | lname | title   | isActive |
+----+-------+-------+---------+----------+
|  1 | John  | Doe   | Manager | Y        |
|  2 | Johny | Doe   | DBA     | Y        |
|  3 | Tom   | Doe   | Analyst | Y        |
|  4 | Tommy | Doe   | Tester  | Y        |
+----+-------+-------+---------+----------+
4 rows in set (0.00 sec)
### Maintaining integrity with mysqlcheck
mysqlcheck employees staff
### mysql mysqlshow displaying useful imformation
 mysqlshow intro_sql;
 mysqlshow employees staff;
 mysqlshow employees staff id
## Mysql timezone data \\ Load time zone tables into mysql
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql mysql
use mysql;
select count(*) from time_zone;
select count(*) from time_zone_name limit 5;
##--------------------------------
## MYSQL example databases/ Download workd database
wget https://downloads.mysql.com/docs/world-db.zip
unzip world-db.zip
cd world-db
mysql < world.sql
#### Invetigate when database was dropped (Dieu tra khi co so du lieu bi soa)
mysql
## drop one database 
drop databases employees
mysql> show binary logs;
ERROR 1381 (HY000): You are not using binary logging
## modify file my.cfg=====================================================================
vi /etc/my.cfg
bind-address= 192.168.0.6
#binlog-do-db=exampledb
server-id=1
log-bin=/var/lib/mysql/log-bin.log
# systemctl restart mysqld
mysql 
show binary logs;
 Log_name       | File_size |
+----------------+-----------+
| log-bin.000001 |       177 |
| log-bin.000002 |       337 |
| log-bin.000003 |       154 
\q
sudo mysqlbinlog /var/lib/mysql/log-bin.000003 > events.log
grep -i DROP events.log
grep -B 4 -A 5 -i DROP events.log  ## cho 4 dong truoc va 5 dong sau tu DROP 

============================================================================================
## Section 5: Mysql Storage Engines 
show emgines;
show engines\G
show variables like '%plugin%';
sudo ls /usr/lib64/mysql/plugin/
---------------------------------
## MEMORY Storage engine;
MYSQL MEMORY STORAGE ENGINE DEMO
CREATE TABLE IN MEMORY STORAGE ENGINE

CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=MEMORY;
SELECT * FROM continents;
# 
INSERT INTO continents(cid,cname) 
VALUES
 (1,'Asia'),
 (2,'Africa'),
 (3,'Europe'),
 (4,'North America'),
 (5,'South America'),
 (6,'Australia'),
 (7,'Antarctica');
#GET TABLE INFORMATION FROM INFORMATION_SCHEMA
SELECT TABLE_NAME,TABLE_TYPE,ENGINE,TABLE_ROWS,CREATE_TIME FROM INFORMATION_SCHEMA.TABLES WHERE ENGINE='MEMORY';
#RESTART MYSQL SERVICE
sudo systemctl stop mysqld && sudo systemctl start mysqld
#OBSERVE THE MEMORY TABLE
use world;
show tables;
SELECT * FROM continents; ## not information, because restart MYSQL clear RAM
--------------
# Blackhole storage engine:
drop table  continents;  ## delete table.
CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=BLACKHOLE;
INSERT INTO continents(cid,cname) 
VALUES
 (1,'Asia'),
 (2,'Africa'),
 (3,'Europe'),
 (4,'North America'),
 (5,'South America'),
 (6,'Australia'),
 (7,'Antarctica');

mysql> select * from continents;
Empty set (0.00 sec)  ## The result will be always empty set.
-----------------
##CSV STORAGE ENGINE;
CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=CSV;

show create table continents\g
INSERT INTO continents(cid,cname) 
VALUES
 (1,'Asia'),
 (2,'Africa'),
 (3,'Europe'),
 (4,'North America'),
 (5,'South America'),
 (6,'Australia'),
 (7,'Antarctica');
 
SELECT * FROM continents;
\q 
sudo ls /var/lib/mysql/world/
sudo file /var/lib/mysql/world/continents.CSV 
sudo cat /var/lib/mysql/world/continents.CSV
---------------------------------------
## MyISAM Storage engine;

mysql> CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=MyISAM;
show create table continents;
INSERT INTO continents(cid,cname) 
VALUES
 (1,'Asia'),
 (2,'Africa'),
 (3,'Europe'),
 (4,'North America'),
 (5,'South America'),
 (6,'Australia'),
 (7,'Antarctica');
SELECT * FROM continents;

START TRANSACTION;
UPDATE continents SET cname='ant' WHERE cid=7;

ROLLBACK;  ## but i will see and it could not roll back.
SELECT * FROM continents;
-------------------------------------
## ARCHIVE STORAGE ENGINE.
mysql> CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=ARCHIVE;
INSERT INTO continents(cid,cname) 
VALUES
 (1,'Asia'),
 (2,'Africa'),
 (3,'Europe'),
 (4,'North America'),
 (5,'South America'),
 (6,'Australia'),
 (7,'Antarctica');
SELECT * FROM continents;
show create table continents;
create index idc_cname ON continents(cname);
ERROR 1071 (42000): Specified key was too long; max key length is 8 bytes

delete from continents where cid=4;
ERROR 1031 (HY000): Table storage engine for 'continents' doesn't have this option
'# 
#Day la du lieu luu ở dạng tệp nén, nên ko thể xóa, hay chèn thêm thông tin vào.
-------------------------------------------------
#### InnoDB Storage Engine;
mysql> CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL)
INSERT INTO continents(cid,cname) 
VALUES
 (1,'Asia'),
 (2,'Africa'),
 (3,'Europe'),
 (4,'North America'),
 (5,'South America'),
 (6,'Australia'),
 (7,'Antarctica');
Show create table continents;
select * from continents;
START TRANSACTION;
UPDATE continents SET cname='ant' WHERE cid=7;
SELECT * FROM continents;
ROLLBACK;
-------------------------------------------
#CHECKing storage engine status;
show engine innodb status\G
commit;
## Switching storage Engine;
###############################################################################################
###MYSQL USER ADMINISTRANTION
1. DBA Account:
2. MYSQL Permissions:
3. WITH GRANT OPTION
4. Create DBA Account.
help create user
CREATE USER IF NOT EXISTS bob  IDENTIFIED BY 'P@ssw0rd123' PASSWORD EXPIRE NEVER ACCOUNT UNLOCK;
GRANT ALL PRIVILEGES ON *.* TO bob WITH GRANT OPTION;   ## Cấp full quyền với *.*
FLUSH PRIVILEGES;   # xóa các đặc quyền để các bản cấp quyền có thể kích hoạt lại
show grants for bob\G   ## Hiển thị các quyền của bob
## access wirh use bob
mysql -u bob -p 
select user();
\s 
#### Creating Regular MySQL users;