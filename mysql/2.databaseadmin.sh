

## set permission are managed for use
Link study:
https://sdsv.udemy.com/course/becoming-a-production-mysql-dba/learn/lecture/35023446#overview

#Check cluster mysql
1. Master node:
show master status;
show slave hosts;
2. Slave node;
show slave status\G 

## set permission are managed for use
mysql>
CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'password';
- Host is important; it's usually 'localhost' or '% for any host.
GRANT ALL PRIVILEGES ON world TO 'myuser'@'%';
GRANT ALL PRIVILEGES ON world TO 'myuser'@'localhost';
- Privileges can include SELECT, INSERT, UPDATE, DELETE, etc. 
- Check permissions with SHOW GRANTS FOR 'mysql'@'%';
GRANT SELECT, INSERT, UPDATE ON mydatabase.* TO 'username'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost'; # all database
# grant privileges on a specific table
GRANT SELECT, DELETE ON mydatabase.mytable TO 'username'@'localhost';
# reloaded;
FLUSH PRIVILEGES;

# Revoke permissions:
REVOKE privileges ON database_name.table_name FROM 'username'@'host';
# Verify the permissions
SHOW GRANTS FOR 'username'@'localhost';

###MySQL config editor
mysql_config_editor: stores authentication credentials in path file .mylogin.cnf - encryted
.mylogin.cnf:
[client]
user = root
password = 
host = localhost

[prod]
user = bob
password = password
host = proddb01
#
Syntax: 
mysql_config_editor set login-path=client -user=root -password
mysql_config_editor --help
mysql_config_editor set --user=root --password --login-path=client
mysql_config_editor print
mysql ## login into mysql
mysql> select user();
#######
#MYSQL Admin Program
mysqladmin 
shutdown
create <database_name>
current status
ping if mysql is alive
start replica
stop replica
systax: mysqladmin options command
ex:
mysqladmin status # ping create database, drop database
##
[root@master-mysql ~]# mysqladmin create employees
##
##MYSQL execute SQL file
source: 
- from within mysql shell - using \. or source
- mysql> source file.sql or mysql> \. file.sql
mysql: inpt .sql file
- mysql -shot=host_name -user-user_name -password= database_name < file.sql
shell script: create an executable shell script and executing it
- mysql -host=host name database_name < $1
pope method: 
- cat filename.sql | mysql
systax:
mysql> source employees.sql
mysql --host=localhost employees < employees.sql
bash employees.sh employess.sql
cat employess.sql | mysql 

https://github.com/abidmunirmalik/mysql-dba-course/blob/main/execute-sql-files.md
mysql>source employees.sql
mysql>\. employees.sql

mysql --host=localhost employees < employees.sql

vi employees.sh
msyql --host=localhost employees < $1
chmod u+x employees.sh
bash employees.sh employees.sql

cat employees.sql | mysql --host=localhost

cat employees.sql
USE employees;
CREATE TABLE IF NOT EXISTS staff (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL,
    title VARCHAR(50) NULL,
    isActive CHAR(1) NOT NULL DEFAULT 'Y' 
);

mysql> source employees.sql
mysql> show tables; 
mysql> drop table staff;
########
# Executing SQL Commands
mysql -e "SELECT @@hostname, @@version"
mysql -e "SELECT @@hostname, @@version;SELECT user, host from mysql.user"
mysql -h IP_address -u root -p -e "SELECT @@hostname, now ();"

## MYSQL mysqlimport
mysqlimport [options] database file1.txt [file2.txt] ...
import data drictory configuration
secure_file_priv - denoted a directory from which data files can be loaded

cat staff.txt
john<TAB>Doe<TAB>Manager<TAB>Y
johny   Doe DBA     Y
Tom     Doe Analyst Y
Tommy   Doe Tester  Y

mysqlimport employees staff.txt
mysqlimport: Error: 1290, The MySQL server is running with the --secure-file-priv option so it cannot execute this statement, when using table: staff
mysql 
mysql> show variables like 'secure_file-priv'
/var/lib/mysql-files/ 
mysql> \! sudo mv staff.txt /var/lib/mysql-files/staff.txt
exit
[root@master-mysql ~]# mysqlimport employees /var/lib/mysql-files/staff.txt
mysql> use employees;
mysql> desc staff;
exit
mysqlimport --help
-c, --cloumns=name ## provide the columns that we readly want to
mysqlimport --columns=fname,lname,title,isActive --delete employees /var/lib/mysql-files/staff.txt

### MYSQL mysqlcheck
mysqlcheck is a table maintenance program
Table will be locked while mysqlcheck is  running - no db operations
syntax: 
mysqlcheck [options] db_name table_name
mysqlcheck employeess staff

#### MYSQL mysqlshow
display database, table, and column information
syntax: mysqlshow  options db_name table_name
mysqlshow options db_name table_name [column_name]
mysqlshow employees staff id 

### MYSQL Timezone Data
mysql_tzinfo_to_sql # loads the time zone data from zoneinfo database into system mysql database, typical locations on linux is /usr/share/zoneinfo
Timezone Tables:
Time_zone
Time_zone_name
Time_zone_transition
Time_zone_transition_type
Time_zone_leap_second
syntax:
mysql_tzinfo_to_sql zoneinfo_database | mysql [options] db_name
ex: 
ls /usr/share/zoneinfo
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql mysql
mysql
mysql> use mysql;
show tables;
select count(*) from time_zone;
select * from time_zone_name limit 5;

###MYSQL example databases
Free to download and use
ex: employees, world, sakila 
url: 
https://dev.mysql.com/doc/index-other.html 
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/world-db.md

Steps:
- download world-db.zip
wget https://downloads.mysql.com/docs/world-db.zip
- unzip
unzip world-db.zip
- exccute world.sql with mysql client
mysql < world.sql
- verify
mysql> use world;
mysql>show tables;
mysql>SELECT * FROM country LIMIT 5;

####MYSQL mysqlbinlog
#Any changes in the database is recorded in a server file called binay log file
syntax:
mysql> show binary logs
show binlog event in "binary_log_file"
mysqlbinlog [options] binary_log_file 
mysqlbinlog /path/to/binary_log_file > file.log
grep -i DROP file.log
ex:
show binary logs;
exit
sudo mysqlbinlog /var/lib/mysql/binlog.000008 > events.log
grep -A 4 -B 5 -i DROP event.log



