CREATE DATABASE Netflix_project;

USE Netflix_project;
describe Netflix;
CREATE TABLE Netflix (
    show_id VARCHAR(10),
    type VARCHAR(20),
    title VARCHAR(255),
    director VARCHAR(255),
    cast VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in VARCHAR(255),
    description VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'
INTO TABLE Netflix
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS;

SELECT * FROM Netflix LIMIT 10;

SELECT COUNT(*) AS Total_Count from Netflix;

SELECT DISTINCT(Type) FROM Netflix;

-- Bussiness Problem
SELECT * FROM Netflix LIMIT 10;

SELECT count(*) FROM Netflix;

-- Count the Number of Movies vs TV Shows
SELECT TYPE, COUNT(*) as Total FROM Netflix
GROUP BY TYPE;

-- Find the Most Common Rating for Movies and TV Shows
With CTE as (
SELECT Type, Rating, Count(*) as Count_Rating,
row_number() over (partition by Type order by Count(*) DESC) as rn
 FROM netflix
Group By Type, Rating)

Select Type, Rating, Count_Rating from CTE
Where rn = 1;

-- List All Movies Released in a Specific Year (e.g., 2020)
Select * from Netflix
Where release_year = 2020 and type = 'Movie';

-- Identify the Longest Movie
Select * from Netflix 
Where Type = 'Movie'
	and 
    Duration = (Select Max(Duration) from Netflix);

-- Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
order by date_added;

-- Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- List All TV Shows with More Than 5 Seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- Find each year and the average numbers of content release in India on netflix.
SELECT * FROM Netflix LIMIT 10;
Select 
	Year(STR_TO_DATE(date_added, '%M %d, %Y') ) as year, 
    count(*) as total_show,
	Round((count(*)/ (Select count(*) from Netflix where country = 'India')) * 100, 2) as Avg_content
from Netflix
where country = 'India'
Group by 1
order by Avg_content Desc
LIMIT 5;

-- List All Movies that are Documentaries
SELECT * FROM Netflix LIMIT 10;
Select * from Netflix
where listed_in like '%Documentaries%';

-- Find All Content Without a Director
Select * from Netflix
where Trim(director) = '' or director IS NULL;

SET SQL_SAFE_UPDATES = 0;
update netflix
set director = null
where Trim(director) = '' or director IS NULL;

-- Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
Select * from Netflix 
where cast like '%Salman Khan%'
	and STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 10 YEAR);

-- Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;






