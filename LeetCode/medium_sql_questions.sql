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



-- # 4. DExchange Seats
-- Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.
-- The column id is continuous increment.
-- Mary wants to change seats for the adjacent students.
-- Can you write a SQL query to output the result for Mary?
 
-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Abbot   |
-- |    2    | Doris   |
-- |    3    | Emerson |
-- |    4    | Green   |
-- |    5    | Jeames  |
-- +---------+---------+
-- For the sample input, the output is:
 

-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Doris   |
-- |    2    | Abbot   |
-- |    3    | Green   |
-- |    4    | Emerson |
-- |    5    | Jeames  |
-- +---------+---------+

--Note:
-- If the number of students is odd, there is no need to change the last one's seat.

-- Solution 1 (It works, except does not return the last entry that has odd seat number)
SELECT s1.id, s2.student
FROM seat s1 JOIN seat s2
ON s1.id=s2.id-1
WHERE s1.id%2=1

UNION
SELECT s2.id, s1.student
FROM seat s1 JOIN seat s2
ON s1.id=s2.id-1
WHERE s1.id%2=1

ORDR By 1
-- I can not further UNION it with a table containing only the last row (Jeames in the example above).
-- SQL was complaining about using s1 alias in third UNION. I just changed it to s3 and it workd.
-- Here is the solution:

SELECT s1.id, s2.student -- self join, 
FROM seat s1 JOIN seat s2
ON s1.id=s2.id-1
WHERE (s1.id%2=1) -- putting adjacent seats together

UNION
SELECT s2.id, s1.student -- same self join as above, but selecting difefernt elements from it
FROM seat s1 JOIN seat s2
ON s1.id=s2.id-1
WHERE s1.id%2=1 -- -- putting adjacent seats together

-- Third UNION concatenates the last student's details if its seat number is odd. 
UNION
SELECT s3.id, s3.student
FROM seat s3
WHERE s3.id = ( 
    SELECT MAX(s3.id) -- subquery to find the last row in table
    FROM seat s3
)
AND
s3.id%2=1 -- check to see if seat number is odd


ORDER BY 1
