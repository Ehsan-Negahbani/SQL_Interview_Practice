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




-- # 5. Combine Two Tables
-- Table: Person:
-- -- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | PersonId    | int     |
-- | FirstName   | varchar |
-- | LastName    | varchar |
-- +-------------+---------+
-- PersonId is the primary key column for this table.

-- Table: address
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | AddressId   | int     |
-- | PersonId    | int     |
-- | City        | varchar |
-- | State       | varchar |
-- +-------------+---------+
-- AddressId is the primary key column for this table.

-- Write a SQL query for a report that provides the following information for each person in the Person table, 
-- regardless if there is an address for each of those people:

-- FirstName, LastName, City, State

-- Solution (EASY):
SELECT FirstName, LastName, City, State
From Person P 
Left Join Address A
On P.PersonId=A.PersonId



-- # 6. EMPLOYEES EARNING MORE THAN THEIR MANAGERS (HARD!)
-- The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

-- +----+-------+--------+-----------+
-- | Id | Name  | Salary | ManagerId |
-- +----+-------+--------+-----------+
-- | 1  | Joe   | 70000  | 3         |
-- | 2  | Henry | 80000  | 4         |
-- | 3  | Sam   | 60000  | NULL      |
-- | 4  | Max   | 90000  | NULL      |
-- +----+-------+--------+-----------+
-- Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

-- +----------+
-- | Employee |
-- +----------+
-- | Joe      |
-- +----------+

-- Solution 1:
SELECT
    a.Name AS 'Employee'
FROM
    Employee AS a,
    Employee AS b
WHERE
    a.ManagerId = b.Id
        AND a.Salary > b.Salary


-- Solution 2:
SELECT a.Name AS Employee
FROM Employee As a JOIN Employee AS b
ON a.ManagerID=b.Id
AND a.Salary>b.Salary



-- # 7. NOT BORING MOVIEWS
-- X city opened a new cinema, many people would like to go to this cinema. 
-- The cinema also gives out a poster indicating the movies’ ratings and descriptions.
-- Please write a SQL query to output movies with an 
-- odd numbered ID and a description that is not 'boring'. 
-- Order the result by rating.
-- 
-- For example, table cinema:
-- 
-- +---------+-----------+--------------+-----------+
-- |   id    | movie     |  description |  rating   |
-- +---------+-----------+--------------+-----------+
-- |   1     | War       |   great 3D   |   8.9     |
-- |   2     | Science   |   fiction    |   8.5     |
-- |   3     | irish     |   boring     |   6.2     |
-- |   4     | Ice song  |   Fantacy    |   8.6     |
-- |   5     | House card|   Interesting|   9.1     |
-- +---------+-----------+--------------+-----------+
-- For the example above, the output should be:
-- +---------+-----------+--------------+-----------+
-- |   id    | movie     |  description |  rating   |
-- +---------+-----------+--------------+-----------+
-- |   5     | House card|   Interesting|   9.1     |
-- |   1     | War       |   great 3D   |   8.9     |
-- +---------+-----------+--------------+-----------+

-- solution 1
SELECT * 
FROM cinema
WHERE id%2<>0
-- WHERE mod(id, 2)=1
AND description<>'boring'
ORDER BY rating DESC

-- # 8. DUPLICATE EMAILS
-- Write a SQL query to find all duplicate emails in a table named Person.
-- 
-- +----+---------+
-- | Id | Email   |
-- +----+---------+
-- | 1  | a@b.com |
-- | 2  | c@d.com |
-- | 3  | a@b.com |
-- +----+---------+
-- For example, your query should return the following for the above table:
-- 
-- +---------+
-- | Email   |
-- +---------+
-- | a@b.com |
-- +---------+
-- Note: All emails are in lowercase.

-- solution 1
SELECT DISTINCT p1.Email
FROM Person p1 join Person p2
ON p1.Id<>p2.Id AND p1.Email=p2.Email

-- solution 2 (sub-optimal)
SELECT DISTINCT p1.Email
FROM Person p1, Person p2
WHERE p1.Id<>p2.Id AND p1.Email=p2.Email

-- Solution 3 (no join)
SELECT Email
FROM PERSON
GROUP BY Email
HAVING COUNT(1) > 1


-- # 9. RISING TEMPERATURE
-- Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.
-- 
-- +---------+------------------+------------------+
-- | Id(INT) | RecordDate(DATE) | Temperature(INT) |
-- +---------+------------------+------------------+
-- |       1 |       2015-01-01 |               10 |
-- |       2 |       2015-01-02 |               25 |
-- |       3 |       2015-01-03 |               20 |
-- |       4 |       2015-01-04 |               30 |
-- +---------+------------------+------------------+
-- For example, return the following Ids for the above Weather table:
-- 
-- +----+
-- | Id |
-- +----+
-- |  2 |
-- |  4 |
-- +----+














