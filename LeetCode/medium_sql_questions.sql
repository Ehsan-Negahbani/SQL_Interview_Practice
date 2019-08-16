-- # 1. CONSECUETIVE NUMBERS
-- Write a SQL query to find all numbers that appear at least three times consecutively.

-- +----+-----+
-- | Id | Num |
-- +----+-----+
-- | 1  |  1  |
-- | 2  |  1  |
-- | 3  |  1  |
-- | 4  |  2  |
-- | 5  |  1  |
-- | 6  |  2  |
-- | 7  |  2  |
-- +----+-----+
-- For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

-- +-----------------+
-- | ConsecutiveNums |
-- +-----------------+
-- | 1               |
-- +-----------------+

-- solution 1 (my solution)
SELECT DISTINCT Num ConsecutiveNums
FROM Logs
WHERE Id=ANY(
              SELECT l1.Id
              FROM Logs l1 JOIN Logs l2 JOIN Logs l3
              ON l3.Id=l2.Id+1 AND l2.Id=l1.Id+1
              WHERE l1.Num=l2.Num AND l2.Num=l3.Num
            )
            
            
-- # 2. Nth Highest Salary
-- Write a SQL query to get the nth highest salary from the Employee table
-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+
-- For example, given the above Employee table, the nth highest salary where n = 2 is 200. 
-- If there is no nth highest salary, then the query should return null.
-- +------------------------+
-- | getNthHighestSalary(2) |
-- +------------------------+
-- | 200                    |
-- +------------------------+

-- Solution 1:
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
 DECLARE M INT;
SET M=N-1; 
  RETURN (
      # Write your MySQL query statement below.
      SELECT DISTINCT Salary getNthHighestSalary
      FROM Employee
      ORDER BY Salary DESC
      LIMIT 1 OFFSET M
  );
END


-- # 3. Department Higheswt Salary
-- The Employee table holds all employees. 
-- Every employee has an Id, a salary, and there is also a column for the department Id.

-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
-- | 1  | Joe   | 70000  | 1            |
-- | 2  | Jim   | 90000  | 1            |
-- | 3  | Henry | 80000  | 2            |
-- | 4  | Sam   | 60000  | 2            |
-- | 5  | Max   | 90000  | 1            |
-- +----+-------+--------+--------------+
-- The Department table holds all departments of the company.

-- +----+----------+
-- | Id | Name     |
-- +----+----------+
-- | 1  | IT       |
-- | 2  | Sales    |
-- +----+----------+

-- Write a SQL query to find employees who have the highest salary in each of the departments. 
-- For the above tables, your SQL query should return the following rows (order of rows does not matter).

-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Jim      | 90000  |
-- | Sales      | Henry    | 80000  |
-- +------------+----------+--------+

-- Solution 1 (my solution)
-- Challenge was knowing how to compare two columnsof a table with another table
-- The solution uses a JOIN (easy part) and a subquery (Easy) with comparison (Challenging)
SELECT d.Name Department, e1.Name Employee, e1.Salary Salary
FROM employee e1 JOIN Department d
ON e1.DepartmentId=d.Id
WHERE (e1.Salary, e1.DepartmentId) = ANY(
    SELECT  MAX(e1.Salary), e1.DepartmentId
    FROM Employee e1
    GROUP BY e1.DepartmentId
    )
