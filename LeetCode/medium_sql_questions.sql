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

