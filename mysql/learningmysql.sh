sudo yum update
##First of all, import the latest MySQL GPG key to your system.
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 
sudo yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm 
## start mysql and check
sudo yum install mysql-community-server 
sudo systemctl start mysqld 
## check defaul password
grep 'temporary password' /var/log/mysqld.log
Pass mysql and root Mysql@123
mysql -u root -p
=====================================================================================================================
### relational database design are FLAT and RELATIONAL 
FLAT is something like an Excel file

1. Sao lưu database trong mysql: 
sudo mysqldump -u [user] -p[database_name] > [filename].sql 

2. Để sao lưu toàn bộ Hệ thống quản lý database:
mysqldump --all-databases --single-transaction --quick --lock-tables=false > full-backup-$(date +%F).sql -u root -p

Sử dụng lệnh SHOW GRANTS để kiểm tra những tài khoản nào có quyền truy cập vào những gì. Sau đó, sử dụng lệnh REVOKE để loại bỏ những đặc quyền không cần thiết.


systemctl status mysqld
mysql -u root -p  ## access password

mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass4!';  ## change password
====================================================================================
show databases;
show tables;
select * from user;
select user, host from user;

 create user root@'%' identified by 'Abc@123#';
 grant all privileges on *.* to root@'%';
 
 select user, host from user;
 ===================================================================================
USE intro_sql;
select id,employee_id,city,country from customers 
SELECT company_name as 'Company Name' from customers; ## report with new name 'Company Name'.

select distinct country from customers;  ## report all country just distinct countries that data set
### SQL WHERE
SELECT id, company_name, phone FROM customers
WHERE country = 'france';

SELECT id, order_date,shipper,freight FROM orders
WHERE freight >=100;
---> <> NOT EQUAL, BETWEEN BETWEEN A RANGE, LIKE : TEST is a string contains a specified pattern, IN : multiple potential values
SELECT id,company_name, region, country FROM customers
WHERE country = 'USA' AND region = 'OR';

### MSQL COMMENTS
*/ this is
a multiline
comment */

-- Returns all the customers in the OR, USA
### FILTERING DATES
SELECT id, order_date, shipper, freight FROM orders
WHERE order_date >= '2019-01-01' AND order_date <= '2019-12-31';
#Or WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31';
### WITH OR STATEMENT
SELECT country FROM customers
WHERE country = 'USA' OR country = 'Germany';
### SQL ORDER BY SORTING
SELECT id, company_name, country FROM customers
ORDER BY country ASC;
ORDER BY country DESC;  # dao nguoc lai

SELECT id, company_name, country FROM customers
ORDER BY country DESC, company_name ASC;

SELECT product_name AS 'Product', category, unit_price as 'Price' FROM products
ORDER BY Price ASC;
------------------------------------------------------------------------
##Section7: Grouping SQL data
SELECT country FROM customers
GROUP BY country;

SELECT distinct category, units_in_stock from products;
# SQL group by calculation
SELECT category, SUM(units_in_stock) AS 'Total Stock' from products
GROUP BY category;

SELECT category, MAX(units_in_stock) AS 'Total Stock' from products   ## or MIN
GROUP BY category;
## SQL GROUP BY FILTERS
SELECT category, SUM(units_in_stock) AS 'Total Stock' from products
GROUP BY category
HAVING SUM(units_in_stock) > 300;
------------------------------------------------------------------
### Creating a MYSQL database;
CREATE DATABASE AwesomeDatabase;
# DELETE DATABASE (Drop)
DROP DATABASE AwesomeDatabase;
## create tables
CREATE TABLE awesome_table(
id INT,
first_name VARCHAR(255),
last_name VARCHAR(255),
dept VARCHAR(255)
);
## DELETE tables
DROP TABLE awesome_table;
## TABLE CONSTRAINT NOT NULL
CREATE TABLE awesome_table(
id INT NOT NULL,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255),
dept VARCHAR(255)
);
## COLUMN AUTO INCREMENT
CREATE TABLE awesome_table(
id INT NOT NULL AUTO INCREMENT,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255),
dept VARCHAR(255)
);
## TABLE PRIMARY KEY
## COLUMN AUTO INCREMENT
CREATE TABLE awesome_table(
id INT NOT NULL AUTO INCREMENT,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255),
dept VARCHAR(255),
PRIMARY KEY (id)
);

CREATE TABLE awesome_customers(
  id INT NOT NULL AUTO_INCREMENT,
  company_name VARCHAR(255),
  country VARCHAR(255),
  emp_id INT,
  PRIMARY KEY (id),
  FOREIGN KEY (emp_id) REFERENCES awesome_employees(id)
);
----------------------------------------------------------------
### INSERT INTO NEW RECORD
USE AwesomeDatabase;
INSERT INTO awesome_employees (first_name,last_name,dept)
VALUE ('Donald', 'Duck', 'IT');

INSERT INTO awesome_employees
VALUE ( default, 'Donald', 'Duck', 'IT');

INSERT INTO shippers (shipper_name, phone)
VALUES ('Speedy Express', '503 555-9831'),
('United Package', '503 555-3199'),
('Federal Shipping', '503 555-9931');

SELECT * FROM shippers;
---------------------------------------------
#### SQL INNER JOIN
SELECT employees.id,customers.employee_id, employees.first_name, employees.dept, customers.company_name, customers.phone
FROM employees
INNER JOIN customers ON employees.id = customers.employee_id;
## SQL LEFT and RIGHT JOIN
SELECT employees.id,customers.employee_id, employees.first_name, employees.dept, customers.company_name, customers.phone
FROM employees
RIGHT JOIN customers ON employees.id = customers.employee_id; ##or LEFT JOIN....
## SQL NULL
SELECT employees.id,customers.employee_id, employees.first_name, employees.dept, customers.company_name, customers.phone
FROM employees
RIGHT JOIN customers ON employees.id = customers.employee_id
WHERE employees.first_name IS NULL;
--
SELECT customers.id, customers.company_name as 'Company', customers.country, orders.order_date as 'Order Date', orders.shipper, orders.freight
FROM customers
INNER JOIN orders ON customers.id = orders.customer_id