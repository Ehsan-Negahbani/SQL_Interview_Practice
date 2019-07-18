-- ref: https://sqlzoo.net/wiki/More_JOIN_operations

-- # 1. List the films where the yr is 1962 [Show id, title].
SELECT id, title
FROM movie
WHERE yr=1962

-- # 2. Give year of 'Citizen Kane'.
SELECT yr 
FROM movie
WHERE title = 'Citizen Kane'

-- # 3. List all of the Star Trek movies, include the id, 
-- title and yr (all of these movies include the words Star 
-- Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'

-- # 4. What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close'

-- # 5. What is the id of the film 'Casablanca'
SELECT id 
FROM movie 
WHERE title='Casablanca'

-- # 6. Obtain the cast list for 'Casablanca'.
-- The cast list is the names of the actors who were in the movie.
-- Use movieid=11768, (or whatever value you got from the previous question)
SELECT name
FROM actor JOIN casting on id=actorid
WHERE movieid=11768

-- # 7. Obtain the cast list for the film 'Alien'
-- topic: ------------ Subqueries --------------
SELECT name
FROM actor JOIN casting on id=actorid
WHERE movieid=(
                SELECT id
                FROM movie
                WHERE title='alien'
                )
   
 -- # 8. List the films in which 'Harrison Ford' has appeared
 -- topic: ---------- joining more than 2 tables ------------
 SELECT title
FROM movie m JOIN casting on m.id=movieid JOIN actor a on a.id=actorid
WHERE name='Harrison Ford'

-- # 9. List the films where 'Harrison Ford' has appeared - 
-- but not in the starring role. [Note: the ord field of casting 
-- gives the position of the actor. 
-- If ord=1 then this actor is in the starring role]
-- solution 1:
SELECT title
FROM movie m JOIN casting on m.id=movieid JOIN actor a on a.id=actorid
WHERE name='Harrison Ford'
AND ord>1
-- solution 2:
SELECT title 
FROM movie 
WHERE id = ANY (
                    SELECT movieid 
                    FROM casting JOIN actor on id=actorid 
                    WHERE name='Harrison Ford'
                    AND ord<>1 
                  )
                  
-- # 10. List the films together with the leading star for all 1962 films.
SELECT title, name
FROM movie m JOIN casting on m.id = movieid JOIN actor a on a.id=actorid
WHERE ord=1
AND yr = 1962

-- # 11. Which were the busiest years for 'John Travolta', 
-- show the year and the number of movies he made each year for 
-- any year in which he made more than 2 movies.
-- topic: ---------- HAVING ----------
-- solution from: https://github.com/mrdziuban/SQLZoo/blob/master/7_more_join_operations.sql
SELECT movie.yr, COUNT(*)
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'John Travolta'
GROUP BY movie.yr
HAVING COUNT(movie.title) > 2;

-- # 12. List the film title and the leading actor for 
-- all of the films 'Julie Andrews' played in.
SELECT movie.title, actor.name
FROM movie 
JOIN casting on movie.id=movieid
JOIN actor on actor.id=actorid
WHERE ord=1
-- a subquery that gives the movie id for movies Julie Andrew played:
AND movie.id IN(
                SELECT m.id as movie_id
                FROM movie m 
                JOIN casting ON m.id=movieid 
                JOIN actor a on a.id=actorid
                WHERE a.name = 'Julie Andrews'
)

-- # 13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
-- My solution:
-- Create a table (tab2) with columns of actor name and number of movies being star at. 
-- Then join tab2 with "actor", and select the rows wehre tab2.star_count>=30
SELECT actor.name
FROM actor
JOIN(
    SELECT name, COUNT(name) star_count
    FROM actor 
    JOIN casting 
    ON actor.id=actorid
    WHERE ord=1
    GROUP BY name
    ) tab2
ON actor.name=tab2.name
WHERE tab2.star_count>=30
ORDER BY actor.name

-- # 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT movie.title, COUNT(name) cast_count
FROM movie 
JOIN casting
ON movie.id=movieid
JOIN actor ON actor.id=actorid
WHERE yr=1978
GROUP BY movie.title
ORDER BY cast_count desc, movie.title

-- # 15. List all the people who have worked with 'Art Garfunkel'.
SELECT name
FROM actor  JOIN casting ON actor.id=actorid
JOIN movie ON movie.id=movieid
WHERE movie.id = ANY(
SELECT movie.id 
FROM movie  JOIN casting ON movie.id=movieid
JOIN actor ON actor.id=actorid
WHERE name='Art Garfunkel')
AND name<>'Art Garfunkel'
