
# 🛒 E-Commerce Data Analysis Using SQL

This project explores an e-commerce database using **advanced SQL queries** to uncover deep business insights related to sales performance, customer behavior, order patterns, product value, and growth metrics.
It includes  real-world analytical questions and answers, all written using **MySQL**, and demonstrates the power of SQL for Business Intelligence. 



## 📁 Project File

- [`IGBURUKE_GODSFAVOUR.sql`](./IGBURUKE_GODSFAVOUR.sql) — Contains all queries with comments

---

## 🧠 Business Questions Answered

1. Total sales by employee  
2. Top 5 customers by revenue  
3. Monthly sales trend (1997)  
4. Average order fulfillment time by employee  
5. Customers in London and their sales  
6. Customers with multiple orders on the same day  
7. Average discount per product  
8. Products ordered by each customer  
9. Employee sales ranking  
10. Sales by country and category  
11. Year-over-year growth in product sales  
12. Order quantity percentile ranking  
13. Products sold but never reordered  
14. Most valuable product by category  
15. Complex order filter: total > $100 & ≥5% discount

---

## 🛠 Tools Used

- **SQL (MySQL)**
- Window functions: `RANK()`, `PERCENT_RANK()`, `LAG()`
- CTEs (Common Table Expressions)
- Aggregate functions and joins
- CASE statements and conditional logic

---

## 📊 Key Insights

- Identified top revenue-generating employees and customers
- Tracked monthly and year-over-year sales growth
- Highlighted top-selling products per category
- Flagged products ordered only once (never reordered)
- Evaluated discount trends and fulfillment timelines

---

## 📊 Sample Query Outputs

Below are a few examples of results generated from the project:

### 🔹 1. Total Sales by Employee

| LastName  | FirstName | Total_Sales |
|-----------|-----------|-------------|
| Peacock   | Margaret  | 9635.76     |
| Davolio   | Nancy     | 5199.59     |
| Leverling | Janet     | 4914.34     |

---

### 🔹 2. Top 5 Customers by Revenue

| CustomerName                          | Total_Spent |
|--------------------------------------|-------------|
| Ernst Handel                          | 3640.12     |
| QUICK-Stop                            | 2160.08     |
| Frankenversand                        | 1965.11     |

---

### 🔹 3. Monthly Sales Trend for 1997

| Month | TotalSales |
|-------|------------|
| Jan   | 6221.80    |
| Feb   | 2089.78    |

---

### 🔹 13. Products Sold Only Once

| ProductID | ProductName                 | No_ofOrder |
|-----------|-----------------------------|------------|
| 9         | Mishi Kobe Niku             | 1          |
| 48        | Chocolade                   | 1          |
| 67        | Laughing Lumberjack Lager   | 1          |

> 🔎 See full results in [`QUERY OUTPUT.docx`](./QUERY%20OUTPUT.docx)


## 🔗 Author

**Godsfavour Igburuke**  
Data Analyst | SQL | Excel | Power BI  
📧 https://www.linkedin.com/in/godsfavourigburuke/  

