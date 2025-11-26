1. Storage Engines:
##################
show enines
install plugin engine SONAME 'engine.so' - install
uninstall plugin engine - uninstall

2. Exploring storage Engines
#####################
mysql> show engines;
mysql> show engines\G 
show variables like '%plugin%';
exit && sudo ls /usr/lib64/mysql/plugin/

3. FEDERATED STORAGE ENGINE:
################
Disable by default
linked server - Microsoft SQL server
database link - Oracle
Syntax:
create table employee_salaries (
    Employess_id int,
    employee_salary int
    ) ENGINE = FEDERATED
    CONNEXTION ='mysql://db_user@target-server:3306/employees/employee_salaries';

4. MEMORY STORAGE ENGINE:
################
Called HEAP in older versions, MEMORY will write table data in memory
Use case:
- static tables - lookup
- Temporary Tables
Caveats:
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/memory-engine.md
mysql> SELECT TABLE_NAME,TABLE_TYPE,ENGINE,TABLE_ROWS,CREATE_TIME FROM INFORMATION_SCHEMA.TABLES WHERE ENGINE='MEMORY';
sudo systemctl stop mysqld && sudo systemctl start mysqld
use world;
show tables;

5. BLACKHOLE STORAGE ENGINE:
################
whatever goes into it then nerver comes back
mysql
CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=BLACKHOLE;
SELECT * FROM continents; # empty

5. CSV STORAGE ENGINE:
################
Storage table in text files using comma-separated values format
Does not support transactions
CSV files are not indexed
Use case: when data need to be shared with other applications that also sue CSV format
Syntax: 
CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=CSV;
mysql> show create table coninents\G

INSERT INTO continents(cid,cname) 
VALUES
 (1,'Asia'),
 (2,'Africa'),
 (3,'Europe'),
 (4,'North America'),
 (5,'South America'),
 (6,'Australia'),
 (7,'Antarctica');
select * from continents;
exit
sudo ls /var/lib/mysql/world
sudo file /var/lib/mysql/word/continents.CSV
cat world/continents.CSV

5. MyISAM STORAGE ENGINE:
################
MyISAM = My + ISAM = indexed sequential Access Method
CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=MyISAM;
START TRANSACTION;
select * from continents;
UPDATE continents SET cname='ant' WHERE cid=7;
ROLLBACK;
show warnings; # soe non-ransactional changed tables couldn't rolled back

6. ARCHIVE STORAGE ENGINE:
################
Produces special-purpose tables that store large amounts ò un-indexed data in very small
Create .ARZ file with same name as table name, uses gzip to compress rows
No DELETE orr UPDATE operation
CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=ARCHIVE;
create index inx_cname ON continents(cname); ## ERROR
delete from continents where cid=4; ## ERROR
exit
ls /var/lib/mysql/workd
continents.ARZ file

7. InnoDB STORAGE ENGINE:
################
ACID compliant storage ingine that support all types of transactions
COMMIT and ROLLBACK, recovery,...
CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL);
show create table continents\G 
select * from continents;
START TRAMSSACTOPM;
UPDATE coninents SET cname = 'ant' WHERE cid=7;
ROLLBACK;
CREATE INDEX idx_name ON continents (cname);
START TRAMSSACTOPM;
UPDATE coninents SET cname = 'ant' WHERE cid=7;
select * from continents;  ## secssion other not delete until commit.
commit;
#
8. Very useful command check the status
################
mysql
show engine innodb status\G 
secssion1: 
UPDATE coninents SET cname = 'ant' WHERE cid=7;
secssion2: 
delete from continents WHERE cid =7;

9. switching STORAGE ENGINE:
################
mysql 
CREATE TABLE continents ( cid int NOT NULL, cname VARCHAR(25) NOT NULL) ENGINE=MyISAM;
show create table continents\G 
show table status LIKE 'continents'\G 
select table_name, engine from information_schema.tables where table_name='continents';
INSERT INTO continents(cid,cname) 
VALUES
 (1,'Asia'),
 (2,'Africa'),
 (3,'Europe'),
 (4,'North America'),
 (5,'South America'),
 (6,'Australia'),
 (7,'Antarctica');

ALERT TABLE continents ENGINE = 'InnoDB'
#recheck
show table status LIKE 'continents'\G ## Engine: InnooDB

10. Installing new STORAGE ENGINE:
################
mysql
show variables like '%plugin%'
exit
ls /usr/lib64/mysql/plugin/
mysql
install plugin EXAMPLE SONAME 'ha_example.so';
show engines\G 
uninstall plugin EXAMPLE;

11. Disable STORAGE ENGINE:
################
mysql
show variables like '%disable%'
exit 
vi /etc/my.cnf
disabled_storage_engines = "MyISAM,BLACKHOLE,MEMORY,ARCHIVE"
systemctl restart mysqld

mysql
use world;
Create table demo(id INT) ENGINE=MyISAM;
