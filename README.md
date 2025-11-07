# 🛒 Amazon Database Clone (SQL Project)

This project is a **complete SQL-based simulation of an Amazon-style e-commerce system**, built using **SQL Server Management Studio (SSMS)**.  
It demonstrates my understanding of **database design, normalization (up to 3NF)**, and **data analysis** through SQL queries.

---

## 📊 ER Diagram

Below is the visual representation of the database schema:

![Amazon ER Diagram](https://raw.githubusercontent.com/vinaydoddapaneni/Amazon-Database-Clone/refs/heads/main/images/Amazon_clone_db_img.png)

*This ER diagram displays relationships between key entities such as Customers, Orders, Products, Sellers, and Payments.*

---

## 🧱 Project Overview

The database represents an **e-commerce platform** similar to Amazon.  
It contains all essential modules like customer management, product listings, orders, payments, shipping, and reviews.

---

## 🏗️ Key Features

- 🧩 **16+ relational tables** covering major e-commerce operations  
- 🔐 **Primary & Foreign Keys** used for referential integrity  
- 🧮 **Computed Columns** and **Check Constraints** for data consistency  
- 🧾 **3NF Normalization** to minimize redundancy  
- 💬 **Sample data insertion scripts** included for quick setup  
- 📊 **Analytical SQL queries** to extract business insights (e.g., top sellers, average order value)  
- 💾 Includes **backup commands** for database safety  

---

## 🧰 Technologies Used

| Component | Description |
|------------|-------------|
| **Database** | Microsoft SQL Server |
| **IDE** | SQL Server Management Studio (SSMS) |
| **Language** | T-SQL (Transact-SQL) |
| **Concepts** | RDBMS, Data Normalization (1NF–3NF), Joins, Subqueries |

---

## 📁 Project Structure

**Repository Layout:**

**Amazon-Database-Clone/**
- `Amazon_db_clone.sql` → Main SQL project file  
- `images/Amazon_clone_db_img.png` → ER diagram image  
- `README.md` → Project documentation  

---

## 🧠 Learning Outcomes

Through this project, I learned how to:

- Design normalized relational databases from scratch  
- Use **keys and constraints** effectively  
- Write **analytical SQL queries** for business insights  
- Understand **data relationships** in large-scale systems  
- Apply **real-world logic** in database design  

---

## 💻 Sample Queries

### 🔹 Top Sellers by Product Count
```sql
SELECT s.seller_id, COUNT(p.product_id) AS total_products
FROM sellers s
JOIN products p ON s.seller_id = p.seller_id
GROUP BY s.seller_id
ORDER BY total_products DESC;
