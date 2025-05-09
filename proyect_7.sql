USE proyect_7;

SELECT * FROM athlete_events;

-- 1. ¿Cuántos juegos Olímpicos se han celebrado?
SELECT COUNT(DISTINCT Year) AS Total_games FROM athlete_events;

-- 2. Enumera todos los juegos Olímpicos celebrados hasta ahora
SELECT DISTINCT Games FROM athlete_events;

-- 3. Menciona el número total de naciones que participaron en cada juego Olímpico
SELECT Games, COUNT(DISTINCT NOC) AS Total_Naciones FROM athlete_events
GROUP BY Games
ORDER BY Games DESC;

-- 4. ¿En qué año se vio el mayor y menor número de países participando en los juegos Olímpicos?
(SELECT Year, COUNT(DISTINCT NOC) AS NumeroPaisesMax FROM athlete_events
GROUP BY Year
ORDER BY NumeroPaisesMax DESC LIMIT 1)
UNION
(SELECT Year, COUNT(DISTINCT NOC) AS NumeroPaisesMin FROM athlete_events
GROUP BY Year
ORDER BY NumeroPaisesMin ASC LIMIT 1);

-- 5. ¿Qué nación ha participado en todos los juegos Olímpicos? --
SELECT NOC, COUNT(DISTINCT Year) AS Num_Participaciones
FROM athlete_events
GROUP BY NOC
HAVING Num_Participaciones = (
  SELECT COUNT(DISTINCT Year) FROM athlete_events);

-- 6. Identifica el deporte que se jugó en todas las olimpiadas de verano
SELECT Sport FROM (
    SELECT Sport, COUNT(DISTINCT Games) AS Num_Juegos
    FROM athlete_events
    WHERE Season = 'Summer'
    GROUP BY Sport
) AS Sub
WHERE Num_Juegos = (
    SELECT COUNT(DISTINCT Games)
    FROM athlete_events
    WHERE Season = 'Summer'
);

-- 7. Identifica el deporte que se jugó en todos los juegos Olímpicos de verano
SELECT DISTINCT Sport
FROM athlete_events
WHERE Season = 'Summer'
GROUP BY Sport
HAVING COUNT(DISTINCT Year) = (SELECT COUNT(DISTINCT Year) FROM athlete_events
                                WHERE Season = 'Summer');

-- 8. Obten el número total de deportes jugados en cada Juego Olímpico
SELECT * FROM athlete_events;

SELECT Games,COUNT(DISTINCT Sport) AS Tota_Juegos FROM athlete_events
GROUP BY Games;

-- 9. Encuentra la proporción de atletas masculinos y femeninos que participaron
SELECT * FROM athlete_events;

SELECT Year,
	   ROUND(MaleCount/TotalCount,2) AS Male_Propotion,
       ROUND(FemaleCount/TotalCount,2) AS Female_Propotion
FROM (
SELECT Year,
       COUNT(*) AS TotalCount,
       SUM(CASE WHEN Sex = 'M' THEN 1 ELSE 0 END) AS MaleCount,
       SUM(CASE WHEN Sex = 'F' THEN 1 ELSE 0 END) AS FemaleCount
       FROM athlete_events
       GROUP BY Year) AS sq1
ORDER BY Year;


-- 10. Busque los 5 mejores atletas que han ganado la mayor cantidad de medallas de oro--
SELECT Name, COUNT(Medal) AS Oro_Ganadas FROM athlete_events
WHERE Medal = 'Gold'
GROUP BY Name
ORDER BY Oro_Ganadas DESC LIMIT 5;

-- 11. Obten los 5 mejores atletas que han ganado la mayoría de las medallas (oro/plata/bronce)

SELECT
     Name,
     SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS GOLD,
     SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
     SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze,
     COUNT(*) AS total_medals
FROM athlete_events
WHERE Medal IN ('Gold','Silver','Bronze')
GROUP BY name
ORDER BY total_medals DESC
LIMIT 5;

-- 12. Obten los 5 países más exitosos en los Juegos Olímpicos -- 
-- El éxito se define por el número de medallas ganadas --

SELECT * FROM athlete_events;

SELECT
      Team AS Country,
      SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
      SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
      SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze,
      COUNT(*) AS total_medals
FROM athlete_events
WHERE Medal IN ('Gold','Silver','Bronze')
GROUP BY Team 
ORDER BY total_medals DESC 
LIMIT 5;

-- 13. Enumera el número de medallas de oro, plata y bronce por cada país --

SELECT
      Team AS Country,
      SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
      SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
      SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze,
      COUNT(*) AS total_medals
FROM athlete_events
WHERE Medal IN ('Gold','Silver','Bronze')
GROUP BY Team 
ORDER BY Country;

-- 14. Enumera el número total de medallas de oro, plata y bronce ganadas por cada país en relación con cada Juego Olímpico
SELECT * FROM athlete_events;

SELECT 
      Team AS Country,
      Year AS Olimpic_year,
      SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
      SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
      SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
FROM athlete_events
WHERE Medal IN ('Gold','Silver','Bronze')
GROUP BY Team, Year
ORDER BY Country, Olimpic_year;

-- 15. Identifica qué país ganó la mayoría de las medallas de oro, plata y bronce en cada Juego Olímpico
SELECT * FROM athlete_events;

SELECT 
      Year,
	  Medal_Type,
      Winning_Country,
      Medal_Count,
      RANK() OVER(PARTITION BY Year, Medal_Type ORDER BY Medal_Count DESC) AS Country_Rank
FROM (                 SELECT 
                       Year,
                       Team AS Winning_Country,
                       Medal,
                       COUNT(*) AS Medal_Count,
                       CASE
                           WHEN Medal = 'Gold' THEN 'Gold'
                           WHEN Medal = 'Silver' THEN 'Silver'
                           WHEN Medal = 'Bronze' THEN 'Bronze'
	                   END AS Medal_Type
			   FROM athlete_events
               WHERE Medal IN('Gold', 'Silver', 'Bronze')
               GROUP BY Year, Winning_Country, Medal) AS MedalCounts;

 -- 16. ¿En qué deportes/eventos India ha ganado la mayor cantidad de medallas?
 
SELECT 
       Sport,
       Event,
       SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
       SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
       SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
FROM athlete_events
WHERE Team = 'India' AND Medal IN ('Gold','Silver','Bronze')
GROUP BY Sport, Event
ORDER BY Gold DESC, Silver DESC, Bronze DESC;

-- 17. Desglosa todos los Juegos Olimpicos en los que India ganó medallas en hockey
-- y cuántas medallas ganó en ada uno de ellos

SELECT 
       Year AS Olympic_Year,
       COUNT(*) AS Total_medals,
       SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
       SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
       SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
FROM athlete_events
WHERE Team = 'India' AND Medal IN ('Gold','Silver','Bronze') AND Sport = 'Hockey'
GROUP BY Year
ORDER BY Olympic_Year;