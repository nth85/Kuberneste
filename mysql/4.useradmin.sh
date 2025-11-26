1. User Administration
########################
ALL - ALL permissions
ALTER, DROP, CREATE - database, table, index,etc
DROP - database, table, index, etc
EXECUTE - stored procedure
INSERT, DELETE, UPDATE, RENAME - on tables
*- ON all objects
SELECT, SHOW - read-Only permissions
Replication client, replication slave
Grand Permissions

2. Create user account
########################
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/create-dba-user.md

mysql>help create user
mysql>CREATE USER IF NOT EXISTS nth'% or localhost' IDENTIFIED BY 'Password@xxx' PASSWORD EXPIRE NEVER <DEFAULT | INTERVAL N DAY> ACCOUNT UNLOCK;
CREATE USER IF NOT EXISTS nth IDENTIFIED BY 'Password@123' PASSWORD EXPIRE NEVER ACCOUNT UNLOCK;
mysql>GRANT ALL PRIVILEGES ON *.* TO nth WITH GRANT OPTION;
mysql>FLUSH PRIVILEGES;
show grants for bob\G 
select user, host from user;
mysql> CREATE USER john IDENTIFIED BY 'P@ssw0rd' PASSWORD EXPIRE;

3. Connexting to Mysql
########################
mysql --host=192.168.56.160 --user=nth --password
select user();
\s 

mysqlsh --sql --uri=nth@192.168.56.160:3360/world

3. Creating Regular Mysql user on Workbench
############################################
create user john identified by 'Abc@123456' password expire;
#user will recreate password when accept first
ALTER USER john INDENTIFIED BY 'P
'> passworkd134@'
'
4. Grant permissions
############################################
create user john identified by 'Abc@123456' password expire;
GRANT select, insert, update, delete on world.continents to john;
show grants for john;

5. Lock/Unlock Mysql account
############################################
select * from mysql.user;
select user, host, plugin, password_expired, account_locked from mysql.user;
alter user john account lock;
alter user john account unlock;

6. Auth Plugins
############################################
Authentication plugins: mysql_native_password & caching_sha2_password
which one?
Authentication plugin 'caching_sha2_password' cannot be loaded ## when got this error
ALTER user john identified with 'mysql_native_password' by 'password';
#change defaul
[mysqld]
default_authentication_plugin=caching_sha2_password
#or
create user john with 'caching_sha2_password' by 'password';
create user john by 'password';

7. Mysql roles
############################################
Create role if not exists 'reader', 'writer','admin';
create user db_reader, db_writer, db_admin
Permissions:
- reader=SELECT on continents table
- writer=INSERT,UPDATE,DELETE on continents table
- admin=ALL permissions on world database
Grant: reader to db_reader, writer to db_writer,admin to bd_admin
https://github.com/abidmunirmalik/mysql-dba-course/blob/main/mysql-roles.md
HELP CREATE ROLE
CREATE ROLE IF NOT EXISTS READER, WRITER, ADMIN;
GRANT SELECT ON world.continents TO READER;
GRANT INSERT, UPDATE, DELETE ON world.continents TO WRITER;
GRANT ALL ON world.* TO ADMIN;
SHOW GRANTS FOR READER;
SHOW GRANTS FOR WRITER;
SHOW GRANTS FOR ADMIN;
CREATE USER IF NOT EXISTS db_reader IDENTIFIED BY 'P@ssw0rd';
CREATE USER IF NOT EXISTS db_writer IDENTIFIED BY 'P@ssw0rd';
CREATE USER IF NOT EXISTS db_admin IDENTIFIED BY 'P@ssw0rd';
GRANT READER TO db_reader;
GRANT WRITER to db_writer;
GRANT ADMIN to db_admin;
FLUSH PRIVILEGES;

SELECT user, host, plugin, authentication_string from myslq.user;
SELECT user, host, plugin, authentication_string from mysql.user where authentication_string = '';
SELECT user, host, plugin, authentication_string, account_locked from mysql.user where authentication_string = '';
