USE proyect_7;

SELECT * FROM athlete_events;

-- 1. How many Olympic Games have been held?
SELECT COUNT(DISTINCT Year) AS Total_games FROM athlete_events;

-- 2. Lists all the Olympic games held so far
SELECT DISTINCT Games FROM athlete_events;

-- 3. Mention the total number of nations that participated in each Olympic game
SELECT Games, COUNT(DISTINCT NOC) AS Total_Naciones FROM athlete_events
GROUP BY Games
ORDER BY Games DESC;

-- 4. In which year did the largest and smallest number of countries participate in the Olympic Games?
(SELECT Year, COUNT(DISTINCT NOC) AS NumeroPaisesMax FROM athlete_events
GROUP BY Year
ORDER BY NumeroPaisesMax DESC LIMIT 1)
UNION
(SELECT Year, COUNT(DISTINCT NOC) AS NumeroPaisesMin FROM athlete_events
GROUP BY Year
ORDER BY NumeroPaisesMin ASC LIMIT 1);

-- 5. Which nation has participated in all the Olympics? --
SELECT NOC, COUNT(DISTINCT Year) AS Num_Participaciones
FROM athlete_events
GROUP BY NOC
HAVING Num_Participaciones = (
  SELECT COUNT(DISTINCT Year) FROM athlete_events);

-- 6. Identifies the sport that was played in all summer Olympics
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

-- 7. Identifies the sport that was played in all the Summer Olympics
SELECT DISTINCT Sport
FROM athlete_events
WHERE Season = 'Summer'
GROUP BY Sport
HAVING COUNT(DISTINCT Year) = (SELECT COUNT(DISTINCT Year) FROM athlete_events
                                WHERE Season = 'Summer');

-- 8. Get the total number of sports played in each Olympic Game
SELECT * FROM athlete_events;

SELECT Games,COUNT(DISTINCT Sport) AS Tota_Juegos FROM athlete_events
GROUP BY Games;

-- 9. Find the ratio of male and female athletes who participated
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


-- 10. Look for the top 5 athletes who have won the most gold medals--
SELECT Name, COUNT(Medal) AS Oro_Ganadas FROM athlete_events
WHERE Medal = 'Gold'
GROUP BY Name
ORDER BY Oro_Ganadas DESC LIMIT 5;

-- 11. Get the top 5 athletes who have won most medals (gold/silver/bronze)

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


-- 12. Get the 5 most successful countries in the Olympics -- 
-- Success is defined by the number of medals won --

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

-- 13. List the number of gold, silver and bronze medals for each country --

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

-- 14. List the total number of gold, silver and bronze medals won by each country in relation to each Olympic Game
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

-- 15. Identify which country won the most gold, silver and bronze medals in each Olympic Game
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

 -- 16. In which sports/events has India won the most medals?
 
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

-- 17. Break down all the Olympic Games in which India won medals in hockey
-- and how many medals did one of them win in ada

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
