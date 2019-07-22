-- ref: https://leetcode.com/problemset/all/?search=sql&difficulty=Easy



-- # 1. Suppose that a website contains two tables, the Customers table and the Orders table. 
-- Write a SQL query to find all customers who never order anything.
--
-- Table Customers:
-- +----+-------+
-- | Id | Name  |
-- +----+-------+
-- | 1  | Joe   |
-- | 2  | Henry |
-- | 3  | Sam   |
-- | 4  | Max   |
-- +----+-------+
--
--Table Orders:
-- +----+------------+
-- | Id | CustomerId |
-- +----+------------+
-- | 1  | 3          |
-- | 2  | 1          |
-- +----+------------+
--
-- Using the above tables as example, return the following:
-- +-----------+
-- | Customers |
-- +-----------+
-- | Henry     |
-- | Max       |
-- +-----------+

-- Solution1: 
SELECT Name as Customers
FROM Customers
WHERE Customers.Id NOT IN (
SELECT CustomerId
From Orders);

-- Solution2:
SELECT Name AS 'Customers'
FROM Customers c
LEFT JOIN Orders o
ON c.Id = o.CustomerId
WHERE o.CustomerId IS NULL

-- Solution 3:
SELECT Name AS Customers
FROM customers c
WHERE NOT EXISTS (SELECT * FROM Orders o WHERE o.CustomerId=c.id)


-- I tried using '<> ANY' instead of 'NOT IN', but it does not return the correct answer.




-- # 2. 
