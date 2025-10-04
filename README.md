# Netflix Movies and TV Shows Data Analysis using SQL
<img width="2226" height="678" alt="logo Netflix" src="https://github.com/user-attachments/assets/ccb3f3e1-4367-4a8e-88a7-05a80bfb15a9" />

## Overview
This project involves a comprehensive analysis of **Netflix's movies and TV shows** data using **SQL**. The goal is to extract valuable insights and answer various business questions based on the dataset.


## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select type,
count(*) as Total_content
from [Netflix Project].[dbo].[netflix_titles]
group by type
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
select type,
rating
from 
(
	select type,
	rating,
	count(*) as cnt,
	rank() over(partition by type order by count(*) desc) as ranking
	from [Netflix Project].[dbo].[netflix_titles]
	group by type,rating
) as sub
where ranking=1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select *
from [Netflix Project].[dbo].[netflix_titles]
where type='Movie'
and release_year=2020
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select *
from(
SELECT TOP 5 
    LTRIM(RTRIM(value)) AS country, 
	count(*) as cnt
	from  [Netflix Project].[dbo].[netflix_titles]
	CROSS APPLY STRING_SPLIT(country, ',')
	GROUP BY LTRIM(RTRIM(value))
	ORDER BY cnt DESC
) as sub
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT top 1 *
FROM [Netflix Project].[dbo].[netflix_titles]
  WHERE type = 'Movie' 
  AND duration LIKE '%min'
  ORDER BY cast( REPLACE (duration, ' min', '') as int) DESC;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select *
from [Netflix Project].[dbo].[netflix_titles]
where cast(date_added as date)>=DATEADD(year,-5,cast(GETDATE() as date))
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select director from [Netflix Project].[dbo].[netflix_titles]
select * 
from [Netflix Project].[dbo].[netflix_titles]
where director like'%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM [Netflix Project].[dbo].[netflix_titles]
WHERE type = 'TV Show'
  AND duration LIKE '%Season%'
  AND duration LIKE '%Seasons%'
  AND CAST(REPLACE(REPLACE(duration, 'Seasons', ''), 'Season', '') AS INT) > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select 
	LTRIM(RTRIM(value)) AS Genre,
	count(*) as content_items
	from  [Netflix Project].[dbo].[netflix_titles]
	CROSS APPLY STRING_SPLIT(listed_in, ',')
	GROUP BY LTRIM(RTRIM(value))
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select year(cast(date_added as date)) as Year,
count(*) as content_release,
round(cast(count(*) as float)/(select count(*) *1.0 
								from  [Netflix Project].[dbo].[netflix_titles] 
								where country like'%India%' )*100,2)
from [Netflix Project].[dbo].[netflix_titles]
where country like'%India%'
group by year(cast(date_added as date));
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select *
from  [Netflix Project].[dbo].[netflix_titles]
where type='Movie'
and listed_in like'%documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select * from  [Netflix Project].[dbo].[netflix_titles]
where [cast] like '%Salman Khan%'
and release_year>= YEAR(DATEADD(year,-10,GETDATE()));
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
select top 10
	LTRIM(RTRIM(value)) AS Actors,
	count(*) as content_items
	from  [Netflix Project].[dbo].[netflix_titles]
	CROSS APPLY STRING_SPLIT([cast], ',')
	where country = 'India'
	GROUP BY LTRIM(RTRIM(value)) 
	order by content_items desc
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
With Categorize_Table as (
select * ,
	case
		when description like '%kill%' or description like '%violence%' then 'Content_Bad' else 'Content_Good'
	end as Categorize
	from [Netflix Project].[dbo].[netflix_titles]
) 
select  
	Categorize,
	count(*) as Total_Content
from Categorize_Table
group by  Categorize
order by Total_Content desc
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

