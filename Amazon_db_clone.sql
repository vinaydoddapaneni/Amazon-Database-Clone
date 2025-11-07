USE amazon_clone_db;
GO

CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    fullname NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password VARBINARY(256) NOT NULL,
    createat DATETIME DEFAULT GETDATE()
);

INSERT INTO customers (fullname, email, password)
VALUES
('Amit Sharma', 'amit.sharma@example.com', CONVERT(VARBINARY(256), 'Amit@123')),
('Priya Reddy', 'priya.reddy@example.com', CONVERT(VARBINARY(256), 'Priya@2025')),
('Rohit Mehta', 'rohit.mehta@example.com', CONVERT(VARBINARY(256), 'Rohit#99')),
('Sneha Patel', 'sneha.patel@example.com', CONVERT(VARBINARY(256), 'Sneha@pass')),
('Vinay Singh D', 'vinay.singh@example.com', CONVERT(VARBINARY(256), 'Vinay@SQL'));


CREATE TABLE sellers (
    seller_id INT IDENTITY(1,1) PRIMARY KEY,
    seller_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone NVARCHAR(15) UNIQUE NOT NULL,
    password VARBINARY(256) NOT NULL,
    join_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL,
    category_des NVARCHAR(255) NOT NULL
);


CREATE TABLE products (
    product_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    product_name NVARCHAR(200) NOT NULL,
    product_description NVARCHAR(MAX),
    product_price DECIMAL(10,2) CHECK (product_price >= 0),
    product_quantity INT CHECK (product_quantity >= 0),
    product_rating DECIMAL(2,1) CHECK (product_rating BETWEEN 0 AND 5),
    category_id INT FOREIGN KEY REFERENCES categories(category_id),
    seller_id INT FOREIGN KEY REFERENCES sellers(seller_id),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL
);


CREATE TABLE countries (
    country_id INT IDENTITY(1,1) PRIMARY KEY,
    country_name NVARCHAR(100) NOT NULL UNIQUE,
    country_code NVARCHAR(10)
);

CREATE TABLE addresses (
    address_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES customers(customer_id),
    full_address NVARCHAR(500),
    city NVARCHAR(100),
    state NVARCHAR(100),
    postal_code NVARCHAR(20),
    country_id INT FOREIGN KEY REFERENCES countries(country_id)
);


CREATE TABLE orders (
    order_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    order_placed DATETIME DEFAULT GETDATE(),
    customer_id INT FOREIGN KEY REFERENCES customers(customer_id),
    seller_id INT FOREIGN KEY REFERENCES sellers(seller_id),
    address_id INT FOREIGN KEY REFERENCES addresses(address_id),
    total_amount DECIMAL(10,2) CHECK (total_amount >= 0),
    order_status NVARCHAR(50) DEFAULT 'Pending'
);


CREATE TABLE order_details (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES orders(order_id),
    product_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES products(product_id),
    quantity INT CHECK (quantity > 0),
    price_each DECIMAL(10,2) CHECK (price_each > 0),
    total_price AS (quantity * price_each)
);


CREATE TABLE payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES orders(order_id),
    payment_method NVARCHAR(50) CHECK (payment_method IN ('Credit Card','Debit Card','UPI','NetBanking','Wallet','Cash on Delivery')),
    payment_status NVARCHAR(50) CHECK (payment_status IN ('Pending','Completed','Failed','Refunded')),
    payment_date DATETIME DEFAULT GETDATE(),
    amount DECIMAL(10,2) CHECK (amount > 0)
);


CREATE TABLE shipping (
    shipping_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES orders(order_id),
    address_id INT FOREIGN KEY REFERENCES addresses(address_id),
    shipping_status NVARCHAR(50) CHECK (shipping_status IN ('Pending','Dispatched','In Transit','Delivered','Returned')),
    estimated_delivery_date DATE,
    actual_delivery_date DATE
);


CREATE TABLE reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES customers(customer_id),
    product_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES products(product_id),
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5),
    review_text NVARCHAR(MAX),
    review_date DATETIME DEFAULT GETDATE()
);


CREATE TABLE state_master (
    state_id INT IDENTITY(1,1) PRIMARY KEY,
    state_name NVARCHAR(100) NOT NULL,
    country_id INT FOREIGN KEY REFERENCES countries(country_id)
);

CREATE TABLE district_master (
    district_id INT IDENTITY(1,1) PRIMARY KEY,
    district_name NVARCHAR(100) NOT NULL,
    state_id INT FOREIGN KEY REFERENCES state_master(state_id)
);

CREATE TABLE city_master (
    city_id INT IDENTITY(1,1) PRIMARY KEY,
    city_name NVARCHAR(100) NOT NULL,
    district_id INT FOREIGN KEY REFERENCES district_master(district_id)
);

CREATE TABLE zipcode_master (
    zipcode_id INT IDENTITY(1,1) PRIMARY KEY,
    zipcode_number NVARCHAR(10) NOT NULL,
    city_id INT FOREIGN KEY REFERENCES city_master(city_id)
);

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM categories;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;


INSERT INTO sellers (seller_name, email, phone, password)
VALUES
('TechWorld', 'techworld@sellers.com', '9876543210', CONVERT(VARBINARY(256), 'Tech@001')),
('HomeEssentials', 'home@sellers.com', '9876500011', CONVERT(VARBINARY(256), 'Home@002')),
('FashionPlus', 'fashion@sellers.com', '9812345678', CONVERT(VARBINARY(256), 'Fashion@003')),
('SmartElectro', 'smart@sellers.com', '9823456789', CONVERT(VARBINARY(256), 'Smart@004')),
('BookHub', 'books@sellers.com', '9834567890', CONVERT(VARBINARY(256), 'Books@005'));

INSERT INTO categories (category_name, category_des)
VALUES
('Electronics', 'Mobile phones, laptops, and gadgets'),
('Home Appliances', 'Kitchen and household equipment'),
('Fashion', 'Clothing and accessories'),
('Books', 'Educational and entertainment books'),
('Beauty', 'Skincare and cosmetic products');

INSERT INTO categories (category_name, category_des)
VALUES
('Electronics', 'Mobile phones, laptops, and gadgets'),
('Home Appliances', 'Kitchen and household equipment'),
('Fashion', 'Clothing and accessories'),
('Books', 'Educational and entertainment books'),
('Beauty', 'Skincare and cosmetic products');

INSERT INTO products (product_name, product_description, product_price, product_quantity, product_rating, category_id, seller_id)
VALUES
('iPhone 15 Pro', 'Apple smartphone with A17 chip', 129999, 10, 4.8, 1, 1),
('Samsung Galaxy S24', 'Latest Samsung phone with AI features', 84999, 15, 4.6, 1, 4),
('LG Refrigerator 300L', 'Double door, inverter compressor', 42999, 8, 4.4, 2, 2),
('Whirlpool Washing Machine', 'Fully automatic 7kg front load', 35999, 12, 4.2, 2, 2),
('Men’s Leather Jacket', 'Genuine leather, winter wear', 4999, 20, 4.5, 3, 3),
('Women’s Saree', 'Designer silk saree with blouse piece', 2999, 30, 4.3, 3, 3),
('Atomic Habits', 'Self-improvement book by James Clear', 699, 50, 4.9, 4, 5),
('The Alchemist', 'Novel by Paulo Coelho', 499, 40, 4.7, 4, 5),
('Face Moisturizer', 'Hydrating cream for all skin types', 799, 25, 4.6, 5, 5),
('Lipstick Set', 'Pack of 4 matte lipsticks', 999, 35, 4.4, 5, 5);

INSERT INTO countries (country_name, country_code)
VALUES
('India', 'IN'),
('Germany', 'DE'),
('United States', 'US');

INSERT INTO addresses (customer_id, full_address, city, state, postal_code, country_id)
VALUES
(1, '45 MG Road', 'Mumbai', 'Maharashtra', '400001', 1),
(2, '12 Jubilee Hills', 'Hyderabad', 'Telangana', '500033', 1),
(3, '8 Indiranagar', 'Bangalore', 'Karnataka', '560038', 1),
(4, '101 Gariahat Road', 'Kolkata', 'West Bengal', '700019', 1),
(5, '23 Nungambakkam', 'Chennai', 'Tamil Nadu', '600034', 1);

INSERT INTO orders (customer_id, seller_id, address_id, total_amount, order_status)
VALUES
(1, 1, 1, 129999, 'Completed'),
(2, 2, 2, 42999, 'Delivered'),
(3, 3, 3, 4999, 'Dispatched'),
(4, 5, 4, 699, 'Pending'),
(5, 4, 5, 84999, 'Completed');

INSERT INTO order_details (order_id, product_id, quantity, price_each)
SELECT o.order_id, p.product_id, 1, p.product_price
FROM orders o
JOIN products p ON (
    (o.customer_id = 1 AND p.product_name = 'iPhone 15 Pro') OR
    (o.customer_id = 2 AND p.product_name = 'LG Refrigerator 300L') OR
    (o.customer_id = 3 AND p.product_name = 'Men’s Leather Jacket') OR
    (o.customer_id = 4 AND p.product_name = 'Atomic Habits') OR
    (o.customer_id = 5 AND p.product_name = 'Samsung Galaxy S24')
);

INSERT INTO payments (order_id, payment_method, payment_status, amount)
SELECT order_id, 
    CASE WHEN customer_id % 2 = 0 THEN 'Credit Card' ELSE 'UPI' END,
    'Completed',
    total_amount
FROM orders;

INSERT INTO shipping (order_id, address_id, shipping_status, estimated_delivery_date, actual_delivery_date)
SELECT order_id, address_id, 
    CASE order_status 
        WHEN 'Completed' THEN 'Delivered'
        WHEN 'Delivered' THEN 'Delivered'
        WHEN 'Dispatched' THEN 'In Transit'
        ELSE 'Pending'
    END,
    DATEADD(DAY, 5, order_placed),
    CASE WHEN order_status IN ('Completed','Delivered') THEN DATEADD(DAY, 3, order_placed) ELSE NULL END
FROM orders;

INSERT INTO reviews (customer_id, product_id, rating, review_text)
SELECT c.customer_id, p.product_id,
    CASE c.customer_id
        WHEN 1 THEN 4.9
        WHEN 2 THEN 4.6
        WHEN 3 THEN 4.4
        WHEN 4 THEN 4.8
        WHEN 5 THEN 4.7
    END,
    'Excellent product! Very satisfied.'
FROM customers c
JOIN products p ON p.product_id IN (
    SELECT TOP 5 product_id FROM products
);

SELECT * FROM customers;
SELECT * FROM sellers;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM shipping;
SELECT * FROM reviews;


select * from timeformates

drop table timeformates

create table timeformates(
    tf_id uniqueidentifier default newid() primary key,
    tf_date datetime default getdate(),
    tf_title nvarchar(max)
)

insert into timeformates (tf_title)
values ('the too long text'),('All the best in my opition')

select * from timeformates

alter table timeformates
delete tf_time

select * from timeformates

insert into timeformates(tf_title) values
('Too be honest with you'),('Too be honest with you'),('Too be honest with you'),('Too be honest with you')

update timeformates
set tf_title = 'My details are empty'
where tf_id = '60E35311-F1E8-4B0E-9916-B0C677C76671'

select * from timeformates

EXEC xp_instance_regread
    'HKEY_LOCAL_MACHINE',
    'Software\Microsoft\MSSQLServer\MSSQLServer',
    'BackupDirectory';

BACKUP DATABASE amazon_clone_db
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup'
WITH FORMAT, INIT;



select * from sellers
select * from products

select s.seller_id,count(s.seller_id) as no_of_produts from sellers as s
join products as p
on s.seller_id = p.seller_id
group by s.seller_id
order by s.seller_id


select s.seller_id,count(s.seller_id) as no_of_produts from sellers as s
join products as p
on s.seller_id = p.seller_id
group by s.seller_id
order by s.seller_id

create table no_of_products_by_sellers (
    seller_id int,
    no_of_produts int
)
select * from no_of_products_by_sellers

insert into no_of_products_by_sellers (seller_id,no_of_produts) 
select s.seller_id,count(s.seller_id) as no_of_produts from sellers as s
join products as p
on s.seller_id = p.seller_id
group by s.seller_id
order by s.seller_id

select * from no_of_products_by_sellers

truncate table no_of_products_by_sellers

create database agents

use agents

create table customers(
    customer_id int identity(1,1) primary key,
    customer_name varchar(max),
    customer_address varchar(max)
)

create table orders(
    order_id int identity(1,1) primary key,
    order_name varchar(max),
    order_date datetime default getdate(),
    customer_id int foreign key references customers(customer_id)
)

select * from orders
select * from customers


INSERT INTO customers (customer_name, customer_address)
VALUES
('John Doe', '123 Maple Street, New York'),
('Emma Watson', '45 River Road, Chicago'),
('Liam Smith', '89 Pine Avenue, Los Angeles'),
('Sophia Johnson', '67 Lake View, Seattle'),
('Noah Brown', '12 Hill Street, Dallas'),
('Olivia Davis', '90 Park Avenue, San Francisco'),
('William Wilson', '34 Greenfield, Boston'),
('Ava Martinez', '56 Ocean Drive, Miami'),
('James Anderson', '78 Central Street, Denver'),
('Isabella Thomas', '23 Sunset Boulevard, Phoenix');

INSERT INTO orders (order_name, order_date, customer_id)
VALUES
('Laptop Purchase', '2025-10-01', 1),
('Mobile Phone Order', '2025-10-03', 2),
('Headphones', '2025-10-05', 3),
('Smartwatch', '2025-10-06', 4),
('Gaming Console', '2025-10-07', 5),
('Tablet', '2025-10-08', 6),
('Bluetooth Speaker', '2025-10-09', 7),
('Keyboard and Mouse Combo', '2025-10-10', 8),
('Monitor', '2025-10-11', 9),
('External Hard Drive', '2025-10-12', 10);

truncate table customers

select * from orders

create database joins_learn;




select * from orders

insert into orders (customer_id)values (20)

select top 10 c.customer_id,count(c.customer_id) from orders as o 
inner join customers as c
on o.customer_id = c.customer_id
group by c.customer_id
order by count(c.customer_id) DESC

select customer_id, order_count
from (
    select top 10 
        c.customer_id,
        count(c.customer_id) as order_count
    from orders as o
    inner join customers as c
        on o.customer_id = c.customer_id
    group by c.customer_id
    order by count(c.customer_id) desc
) as top_customers
order by customer_id asc;

select * from customers

select * from (
select top 10 c.customer_id,count(c.customer_id) as count_of_cid from orders as o 
inner join customers as c
on o.customer_id = c.customer_id
group by c.customer_id
order by count(c.customer_id) DESC
) as order_customer_id /*where count(customer_id) > 1*/ order by customer_id asc

select sum(o.total_price)/count(o.total_price) as avg_of_totalsum from order_details as o

select avg(o.total_price) as avg_of_totalsum from order_details as o

select total_price+=500 from order_details

select * from order_details

update order_details
set price_each +=500
where price_each = 699.00


update order_details
set price_each -=500
where price_each = 1199.00

select * from order_details











