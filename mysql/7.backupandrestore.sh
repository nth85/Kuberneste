 1. What do you want to protect?
 - MySQL Instance - Physical Backup
 - Option Files/Configuration Files - Source Control
 - Database(s) - Logical backup
 - Table(s) - Logical Backup

 1. Physical/Cold backup
 ########################
 - Also called Cold Backup - Easy one
 - Physically copy MySQL instance files to a backup device
 - No backup tool is required
 What to backup?
 - All data directory (user-space)
 - All system related tablespaces (system-space)
 - All option files
 What is needed?
 - Clean shutdown nof MySQL service
## ASSIGNMENT: perform a Physical/Cold backup
Hint:
- Clean shutdown Mysql server.
- Copy all related files
- Restart MySql server
#check where are data?
show global variables like 'datadir';
show global variables like 'innodb_data%';
set gloabl innodb_fast_shutdown = 0;
exit
systemctl stop mysqld.service
mkdir /tmp/coldbackup
sudo cp -r /var/lib/mysql/prod /tmp/coldbackup/
sudo cp -r /var/lib/mysql/innodb /tmp/coldbackup/
vi /etc/my.cnf
!includedir /etc/percona
sudo cp /etc/percona/*.cnf /tmp/coldbackup/
ls /var/log/mysql
binlogs doublewrite errorlog redologs tmpdir
# doublewrite don't need backup because stop clean so not data storage into ib_16384_0.dblwr
# redologs: for redo logs when server or error data, so we still don't need backup
# binlogs : all bin logs are the data changes at events in these binry logs and they have been applied to the database, so we actually do not need these either

2. Restore From Physical/Cold backup
########################
show databases;
drop database world;
exit
systemctl stop msyqld
sudo rm -f /var/log/mysql/redologs/in_log*
sudo rm -f /var/log/mysql/binlogs/*
sudo rm -f /var/log/mysql/doublewrite/*
sudo rm -fr /var/lib/mysql/innodb
sudo rm -fr /var/lib/mysql/prod

sudo cp -r /tmp/coldback/prod /var/lib/mysql/
sudo cp -r /tmp/coldback/innodb /var/lib/mysql/
sudo chown -R mysql:mysql /var/lib/mysql

systemctl start mysql.service

3. File needed for cold back
########################
- DATA DIR
- System Tablespaces
- any option/configuration file*.cnf
which files are not part of cold backup:
- redo Log files
- Doublewrite buffer Files
- Banary log Files
- Undo Tablespaces
- Temp files

4. Logical Backup
########################
- Backup of data only
- Can backup database, table
- SQL statements
- A utility is needed to take logical backup
- Generate .sql file
- mysqldump
- mysqlpump
############
mysqldump?
- client utility to performs logical backups
systax:
- mysqldump [options] db_name [tbl_name] > bkup_name.sql
- mysqldump [options] db_name [tbl_name] -where="condition" > bkup_name.sql
- mysqldump [options] db_name --ignore-table=db.tbl_name > bkup_name.sql
- mysqldump [options] --database db1 db2 ... > bkup_name.sql
- mysqldump [options] --all-databases > bkup_name.sqp 
##Assignment
mysqldump world continents > continents.sql
mysqldump world continents --where="cid=5" > ts.sql
mysqldump world --ignore-table=world.continents > no_continents.sql
grep CREATE no_continents.sql
## Restoring from mysqldump
use world;
drop table continents;
mysql world < continents.sql
drop database world;
mysql < world.mysql

############
mysqlpump?
- Paralled processing of databases to speed up the dump process
- Better control over which database objects like tables, sp, user accounts to dump
- compressed output and Dump progress
- by default, mysqlpump dumps all the databases
Syntax:
- mysqlpump [options] db_name [tbl_name] -add-drop-table > bkup_name.sql
- mysqlpump [options] -exclude-databases=% -users > users.sql
- mysqlpump [options] db_name --ignore-table=db.tbl_name > bkup_name.sql
- mysqlpump [options] --database db1 db2 ... -add-drop-database > bkup_name.sql
- mysqlpump [options] --all-databases > bkup_name.sqp 
#Demo1-mysqlpump
mysqlpump world continents > pump.sql