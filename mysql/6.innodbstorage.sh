1. InnoDB architecture
#######################
In-Memory Structure:
- Buffer Pool:(nhóm bộ nhớ đệm) Area in main memory where InnoDB caches tables and index data as it is accessd
- Change Buffer: caches changes to non-cluster indexes
- Adaptive Hash index: acts like in-memory db 
- Log Buffer - memory area that holds data to be written to the log files on disk
On-Disk Structure:
- System  Tablespace (không gian bảng hệ thống)
- Doublewrite Buffer files
- Undo Tablespaces
- Redo log files
- File - per - Table - Tablespaces
- General Tablespaces
- Temporary Tablespaces

2. InnoDB Buffer Pool
#######################
- innodb_buffer_pool_size
- innodb_buffer_pool_check_size - 1 for small
- innodb_buffer_pool_chunk_size - 128 default
- innodb_buffer_pool_size = innodb_buffer_pool_chunck_size * innodb_buffer_pool_instances
InnoDB Buffer Pool Status:
- show engine innodb status

echo $((134201344/1024/1024)) = 128Megabyte
show global variables like 'innodb_buffer_pool%';
mysqld --verbose --help | grep -i innodb
innodb-buffer-pool-size
##
ll  /etc/percona/
my.cnf 
innodb.cnf
vi /etc/percona/innodb.cnf
[mysql]
innodb-buffer-pool-size = 256M
systemct restart mysqld

3. InnoDB Logs Buffer
#######################
- InnoDB log buffer allows transactions to run without committing before writing to the log files on disk.
- innodb_log_buffer_size - system variable
- Bigger log buffer size accommodate big transactions to save disk I/O
- Default size is 16MB
InnoDB Log Buffer Too Small?
- innodb_log_waits - Number of times that the log buffer was too small
- await is required for it to be flushed before continuing;
ASSIGNMENTL
check the innoDB log buffer size and see how mnay times this size was not big enough for transactions
hint: 
innodb_log_buffer_size 
innodb_log_waits

show global variables like "innodb_log_buffer_size"; #16MB
show global status like 'innodb_log_waits';
 # value alway =0, if >10 then increase either "innodb_log_buffer_size" size or reduce transaction

4. InnoDB Flush Method
#######################
- Bring the data from in memory to disk
- innodb_flush_method - system variable
- fsync - default flush method, flush data, metadata, and log files - causes double buffering
- O_DSYNC - flush only data file but causes double-buffering
- O_DIRECT - flush only data files, uses fsync with no double_buffering, read-write directly goes to disk
- O_DIRECT_NO_FSYNC - O_DIRECT but skip fsync, not good for XFS FS
# change innoDB flush method to O_DIRECT
hint: innodb_flush_method
mysqld --verbose --help | grep -i flush
vi /etc/percona/innodb.cnf
[mysql]
#buffer pool  size
innodb-buffer-pool-size = 256M
#Flush method
innodb-flush-method = O_DIRECT

systemct restart mysqld

5. Doublewrite Buffer
#######################
- storage area where Innodb write pages flushed from the buffer pool before writing the pages to their proper positions on the innodb data files
- implemented to recover from half-written pages
- in case of OS error, storage issue... innodb can find a good copy of page from doublewrite buffer during crash recovery
- innodb_doublewrite - system variable - enabled by default
- innodb_doublewrite_dir 
- ib_16384_0.dblwr & #ib_16384_1.dblwe - 16384 = 16k (innodb_page_size)
- doublewrite files should be placed on a fastest storage media available
when to disable?
Concerned about performace than data integrity
ASSIGNMENT:
1. disable doublewrite buffer
skip-innodb-doublewrite
2. Enable Doublerwrite buffer with files in new location
set innodb-doublewrite-dir <file_location>

show global variables like 'innodb_doublewrite%';
show global variables like 'innodb_buffer_pool_%';
show global variables like 'innodb_page%';
exit
ll /var/lib/mysql
mysql --verbose --help | grep -i doublewrite

vi /etc/percona/innodb.cnf
[mysql]
#buffer pool  size
innodb-buffer-pool-size = 256M
#Flush method
innodb-flush-method = O_DIRECT
#Disable innodb doublewrite buffer
skip-innodb-doublewrite 

systemct restart mysqld

mkdir /var/log/mysql/doublewrite
vi /etc/percona/innodb.cnf
[mysql]
#buffer pool  size
innodb-buffer-pool-size = 256M
#Flush method
innodb-flush-method = O_DIRECT
#Enable innodb doublewrite buffer
innodb-doublewrite-dir =  /var/log/mysql/doublewrite
systemct stop mysqld
systemct start mysqld

6. Fush Logs transaction commit
#######################
- innodb_flush_log_at_trx_commit - system varible control balance between strict ACID compliance for commit operations and higher performace - I/O related
- 1 default full ACID compliance - Logs are writen and flushed to disk at each transection commit (ko mat du lieu)
- 0 Logs are written and flushed to disk once per second - transaction for which log have not been flushed can be lost in crash
- 2 Logs are written after each transaction commit and flushed to disk once per second - transactions for which log have not been flushed can be lost in crash
Which value to use?
- 1 = safest full ACID compliance - no data lost
- 0 = Nothing is done on commit - better performance but loose data second worth of transections
- 2 = better performace but again loose transactions worth of 1 second
##
mysql
show variables like 'innodb_flush%'; # default 1
exit
vi /etc/percona/innodb.cnf
[mysql]
#buffer pool  size
innodb-buffer-pool-size = 256M
#Flush method
innodb-flush-method = O_DIRECT
#Enable innodb doublewrite buffer
innodb-doublewrite-dir =  /var/log/mysql/doublewrite
#set ting for flushing log transaction
innodb-flush-log-at-trx-commit = 2

7. Redo Logs file
#######################
- All about data recovery by Innodb storage Engine
- ib_logfile0 and ib_logfile1
- innodb_log_file_size - default 50MB
- innodb_log_files_in_group - default 2
- innodb_log_group_home_dir - default to DATA DIR
- innodb_fast_shutdown - SET GLOABL innodb_fast_shutdown =0 ; defaul=1
    +/ 0 = Clean shutdown- Does additional flushing operations, longer time to shutdown but saved time on startup
    +/ 1 = fast shutdown - Shutdown MySQL but read redo log files on startup
#Assignment1:
show global variables like 'innodb_fast_shutdown'; #defaul 1
SET GLOBAL innodb_fast_shutdown = 0;
exit
systemctl stop mysqld
ls /var/lib/mysql/prod # ib_logfile1 and ib_logsfile0
#if delete 2 this when restart mysqld recreate this 2 file.
#Assignment2:
- Change size of redo log file from 50Mb to 100Mb

- Change location of redo log file

Hint:
- innodb_log_file_size
- innodb_log_files_in_group
- innodb_log_group_home_dir
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/innodb-redo-logs.md
sudo vim /etc/percona/innodb.cnf
innodb-log-file-size = 100M
innodb-log-files-in-group = 2
innodb-log-group-home_dir = /var/log/mysql/redologs

7. System tablespace
#######################
- the system tablespace is the storage area for the change buffer
- system tablespace used to contain doublewrite buffer also
- ibdata1 - default name - Created in DATA DIR
- The system tablespace can have one or more data files
- innodb_data_file_path - size and number of system tablespace data files
- innodb_data_file_path=ibdata1:10M:autoextend
#Assignment:
- Add another data file for system tablespace - 10M autoextend
- Move system tablespace to new location
Hint:
innodb_data_file_path=ibdata1:12Mibdata2:10M:autoextent
innodb_data_home__dir=/var/lib/mysql/innodb/
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/system-tablespace.md
sudo mkdir /var/lib/mysql/innodb
sudo mv /var/lib/mysql/prod/ibdata1 /var/lib/mysql/innodb/
sudo chown -R mysql:mysql /var/lib/mysql

sudo vim /etc/percona/innodb.cnf
innodb-data-home-dir  =  /var/lib/mysql/innodb/
innodb-data-file-path = ibdata1:12M;ibdata2:10M:autoextend

sudo systemctl start mysqld.service
sudo ls -l /var/lib/mysql/innodb
SHOW GLOBAL VARIABLES LIKE 'innodb_data%';
SELECT * FROM INFORMATION_SCHEMA.FILES WHERE TABLESPACE_NAME LIKE 'innodb_system'\G

vi /etc/percona/innodb.cnf
[mysql]
#buffer pool  size
innodb-buffer-pool-size = 256M
#Flush method
innodb-flush-method = O_DIRECT
#Enable innodb doublewrite buffer
innodb-doublewrite-dir =  /var/log/mysql/doublewrite
#set ting for flushing log transaction
innodb-flush-log-at-trx-commit = 2
#InnoDB redo log files
innodb-log-file-size = 100M
innodb-log-files-in-group = 2
innodb-log-group-home_dir = /var/log/mysql/redologs
#Innodb system tablespace
innodb-data-home-dir  =  /var/lib/mysql/innodb/
innodb-data-file-path = ibdata1:12M;ibdata2:10M:autoextend

8. Undo tablespace
#######################
- The undo tablespace contains undo logs, which are collections of records containing information about how to undo the latest change by a 
transaction to a clustered index record
- Two default undo tablespace are created when Mysql instance is initiablzed
- A minimum of two undo tablespaces is required
- Default UNDO tablespaces: innodb_undo_001 and innodb_undo_002
- innodb_undo_directory - location of UNDO tablespace
#Assignment: Relocate UNDO tablespaces
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/undo-tablespace.md
sudo mv /var/lib/mysql/prod/undo_* /var/lib/mysql/innodb/
sudo chown -R mysql:mysql /var/lib/mysql
sudo vim /etc/percona/innodb.cnf
innodb-undo-directory  =  /var/lib/mysql/innodb

SHOW GLOBAL VARIABLES LIKE 'innodb_undo%';
select * from information_schema.files where tablespace_name like '%undo%'\G
#
mysql
use world;
select * from contry limit 1;
select count(*) form contry;
START TRANSACTION;
UPDATE contry SET name = '';
show engine innodb status\G
ROLLBACK;  ## if commit then flushing to disk


8. Temporary tablespace
#######################
- Session Temporary Tablespace - user created temporary tables
- Global Temporary Tablespace - stores rollback segments for changes made to user-created temporary tables
- lbtmp1 - create single auto-extending data file in innodb_data_home_dir
- lbtmp1 -default size 12MB
- innodb_temp_data_File_path
##
show global variables like 'innodb_temp_data%'

9. General tablespace
#######################
10. file-per-table tablespace
#######################
show global variables like 'innodb_file_per';
Select name from information_schema.innodb_tablespaces;
ls /var/lib/mysql/prod/world

10. Dedicated MySQL Server
#######################
- if you want InnoDB manages your memory and flush method, then turn on dedicated server
- When enabled, innodb will automatically configure these variables;
    + Innodb_buffer_pool_size
    + innodb_flush_method
    + innodb_log_file_size and innodb_log_files_in_group 
    + innodb_redo_log_capacity
- Innodb_dedicated_server - system variable ON | OFF 
- Only consider enabling it if MYsql instance running on a dedicated server where it can use all availabe system resource
- not recommended if MYsql instance shares system resources with other applications
- Automatic configuration of Buffer Pool:
    + Memory < 1 GB, Buffer Pool size = 128MB
    + Memory> 1 GB but < 4GB Buffer Pool size = Memory * 0.5
    + Memory > 4GB Buffer Pool size = memory * 0.75
## Turning Dedicated Server ON
show global variables like "innodb_dedicated%';
exit
sudo vim /etc/percona/innodb.cnf
innodb-dedicated-server = ON
show global variables like 'innod_flush_method'
show global variables like 'innod_buffer_pool_size';
show global variables like 'innod_log_file';"

10. Overriding Dedicated Server Settings
#######################
show global variables like 'innodb_fast_shutdown';
SET GLOBAL innodb_fast_shutdown = 0;
sudo systemctl stop mysqld
ls -ltr /var/log/mysql/redologs
vi /etc/..
## setting inside config file then overring dedicated.
