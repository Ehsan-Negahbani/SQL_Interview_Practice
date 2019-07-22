-- ref: https://sqlzoo.net/wiki/More_JOIN_operations

-- # 1. How many stops are in the database.
SELECT COUNT(id)
FROM stops


-- # 2. Find the id value for the stop 'Craiglockhart'
SELECT id 
FROM stops
WHERE name='Craiglockhart'


-- # 3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT stops.id, stops.name
FROM stops JOIN route
ON (stops.id=route.stop)
WHERE route.num='4' 
AND route.company LIKE '%LRT'


-- # 4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). 
-- Run the query and notice the two services that link these stops have a count of 2. 
-- Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*)=2


-- # 5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. 
-- Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53
AND b.stop = 149


-- # 6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. 
-- Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 
-- If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
AND stopb.name='London Road'


-- # 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
-- Solution from: https://github.com/mrdziuban/SQLZoo/blob/master/9_self_join.sql
SELECT DISTINCT r1.company, r2.num
FROM route AS r1
JOIN route AS r2
ON (r1.company, r1.num) = (r2.company, r2.num)
WHERE r1.stop = 115
AND r2.stop = 137;


-- # 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
-- Solution from: https://github.com/mrdziuban/SQLZoo/blob/master/9_self_join.sql
SELECT r1.company, r1.num
FROM route AS r1
JOIN route AS r2
ON (r1.company, r1.num) = (r2.company, r2.num)
JOIN stops AS s1
ON r1.stop = s1.id
JOIN stops AS s2
ON r2.stop = s2.id
WHERE s1.name = 'Craiglockhart'
AND s2.name = 'Tollcross';

-- # 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. 
-- Include the company and bus no. of the relevant services.
-- Solution from: https://github.com/mrdziuban/SQLZoo/blob/master/9_self_join.sql
SELECT  s2.name, r1.company, r1.num
FROM route AS r1
JOIN route AS r2
ON (r1.company, r1.num) = (r2.company, r2.num)
JOIN stops AS s1
ON r1.stop = s1.id
JOIN stops AS s2
ON r2.stop = s2.id
WHERE s1.name = 'Craiglockhart';

-- # 10. 

