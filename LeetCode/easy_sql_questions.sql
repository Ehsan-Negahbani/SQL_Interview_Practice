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




-- # 2. There is a table World:
-- +-----------------+------------+------------+--------------+---------------+
-- | name            | continent  | area       | population   | gdp           |
-- +-----------------+------------+------------+--------------+---------------+
-- | Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
-- | Albania         | Europe     | 28748      | 2831741      | 12960000      |
-- | Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
-- | Andorra         | Europe     | 468        | 78115        | 3712000       |
-- | Angola          | Africa     | 1246700    | 20609294     | 100990000     |
-- +-----------------+------------+------------+--------------+---------------+
-- A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.
-- Write a SQL solution to output big countries' name, population and area.
-- Solution 1:
SELECT name, population, area
FROM World
WHERE (area>3000000 OR population >25000000)
--Solution 2 using Union, which is faster at least in this exmple:
SELECT name, population, area
FROM World
WHERE area > 3000000 

UNION

SELECT name, population, area
FROM World
WHERE population > 25000000


-- # 3. Delete Duplicate Emails:
-- Write a SQL query to delete all duplicate email entries in a table named Person, 
-- keeping only unique emails based on its smallest Id.
-- +----+------------------+
-- | Id | Email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- | 3  | john@example.com |
-- +----+------------------+
-- Id is the primary key column for this table.
-- For example, after running your query, the above Person table should have the following rows:

-- +----+------------------+
-- | Id | Email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- +----+------------------+

-- Solution1:
DELETE p1.* FROM Person p1 JOIN
    Person p2 on p1.email=p2.email
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id
    
-- Solution2 (the poiont is to use a temp table since you can not modify the primary key column on the main table):
DELETE FROM Person
WHERE Id NOT IN (
  SELECT * FROM (
    SELECT Min(Id)
    FROM Person
    GROUP BY Email
  ) Tmp
)

-- # 4. Second Highest Salary:
-- Write a SQL query to get the second highest salary from the employee table.
-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+

-- For example, given the above Employee table, the query should return 200 as the second highest salary. 
-- If there is no second highest salary, then the query should return null.
-- +---------------------+
-- | SecondHighestSalary |
-- +---------------------+
-- | 200                 |
-- +---------------------+

-- Solution1 (RUNTIME = 174 ms): 
SELECT Max(Salary) as SecondHighestSalary
FROM Employee
WHERE Salary =ANY
(
SELECT Salary
FROM Employee
WHERE Salary<
(
    SELECT MAX(Salary)
    FROM Employee
)
)

--Solution2 (RUNTIME = 74 ms): 
SELECT DISTINCT Salary AS SecondHighestSalary
FROM Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1

-- However, this solution will be judged as 'Wrong Answer' 
-- if there is no such second highest salary since there might be only one record in this table.
-- To overcome this issue, we can take this as a temp table:

-- Solution 3 (RUNTIME = 132 ms)
SELECT(
    SELECT DISTINCT Salary 
    FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1
    ) AS SecondHighestSalary
    
-- Solution 4 (RUNTIME = 139 ms)
SELECT max(Salary) SecondHighestSalary
FROM Employee
WHERE Salary<(SELECT max(Salary) FROM Employee)

















