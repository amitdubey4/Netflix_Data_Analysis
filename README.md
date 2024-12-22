# Netflix_Data_Analysis

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using MYSQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
```sql
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

```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT TYPE, COUNT(*) as Total FROM Netflix
GROUP BY TYPE;
```

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
With CTE as (
SELECT Type, Rating, Count(*) as Count_Rating,
row_number() over (partition by Type order by Count(*) DESC) as rn
 FROM netflix
Group By Type, Rating)

Select Type, Rating, Count_Rating from CTE
Where rn = 1;
```

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
Select * from Netflix
Where release_year = 2020 and type = 'Movie';
```

### 4. Identify the Longest Movie

```sql
Select * from Netflix 
Where Type = 'Movie'
	and 
    Duration = (Select Max(Duration) from Netflix);
```


### 5. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
order by date_added;
```


### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';
```


### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
```

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```


### 11. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SET SQL_SAFE_UPDATES = 0;
update netflix
set director = null
where Trim(director) = '';

SELECT * 
FROM netflix
WHERE director IS NULL;
```

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
Select * from Netflix 
where cast like '%Salman Khan%'
	and STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 10 YEAR);
```

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.






