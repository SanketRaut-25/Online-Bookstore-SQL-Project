-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
use OnlineBookstore;

-- Create Tables
create table Books(
Book_ID serial primary key,
title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_year int,
Price numeric(10,2),
Stock int
);

create table Customers(
Customer_ID serial primary key,
Name varchar(100),
Email varchar(50),
Phone varchar(15),
City varchar(50),
Country varchar (150)
);

create table Orders(
Order_ID serial primary key,
Customer_ID int references Customers(Customer_ID),
Book_ID int references Books(Book_ID),
Order_Date date,
Quantity int,
Total_Amount numeric(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
 load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Books.csv'
 into table Books
 fields terminated by ','
 enclosed by '"'
 lines terminated by '\n'
 ignore 1 rows 
 (Book_ID , Title, Author, Genre, Published_year, Price, Stock);
 
-- Import Data into Customers Table 
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
into table Customers
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(Customer_ID, Name, Email, Phone, City, Country);

-- Import Data into Orders Table 
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv'
into table Orders
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows 
(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount);
 
-- 1) Retrieve all books in the "Fiction" genre:
select * from Books
where Genre = 'Fiction';

-- 2) Find books published after the year 1950:
select * from Books
where Published_Year > 1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers 
WHERE country='Canada';

-- 4) Show orders placed in November 2023:
select * from Orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select sum(Stock) as Total_Stocks
from Books;

-- 6) Find the details of the most expensive book:
select * from Books order by Price desc limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from Orders
where Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where total_amount > 20;

-- 9) List all genres available in the Books table:
select distinct genre from Books;

-- 10) Find the book with the lowest stock:
select * from Books
 order by Stock
 limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(Total_amount)as revenue
from Orders;


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select b.Genre, sum(o.Quantity) as Total_bookes_Sold
from Orders o 
join Books b on o.book_id = b.book_id
group by b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as avg_price
from books
where	Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
select o.customer_id ,c.name, count(o.order_id) as order_count
from orders o
join customers c on o.customer_id=c.customer_id
group by o.customer_id ,c.name
having count(o.order_id)>=2;

-- 4) Find the most frequently ordered book:
select o.Book_id, b.title,  count(o.order_id) as order_count
from orders o
join books b on o.book_id= b.book_id
group by o.book_id, b.title
order by order_count desc
limit 5 ;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books
where Genre = 'Fantasy'
order by price desc 
limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select b.author, sum(o.quantity) as total_books_sold
from orders o 
join books b on o.book_id = b.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located:
select distinct c.city, total_amount 
from orders o
join customers c on o.customer_id = c.customer_id
where o.total_amount >30;

-- 8) Find the customer who spent the most on orders:
select c.name , c.customer_id , sum(o.total_amount) as total_spent
from orders o
join customers c on o.customer_id = c.customer_id
group by c.name,c.customer_id
order by total_spent desc limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
select b.book_id, b.title,b.stock , coalesce(sum(o.quantity),0) as order_quantity ,
 b.stock -coalesce(sum(o.quantity),0) as remaining_quantity
from books b 
left join orders o on b.book_id=o.book_id
group by b.book_id;


