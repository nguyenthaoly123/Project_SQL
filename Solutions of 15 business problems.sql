-- Table
select * from [Netflix Project].[dbo].[netflix_titles]

-- 15 Business Problem

--1 Count the number of Movies and TV shows 
select type,
count(*) as Total_content
from [Netflix Project].[dbo].[netflix_titles]
group by type

--2. Find the most common rating for movies and TV shows
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

--3.List all movies released in a specific year (e.g., 2020)
select *
from [Netflix Project].[dbo].[netflix_titles]
where type='Movie'
and release_year=2020
  
--4.Find the top 5 countries with the most content on Netflix
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

--5.Identify the longest movie
SELECT top 1 *
FROM [Netflix Project].[dbo].[netflix_titles]
WHERE type = 'Movie' 
  AND duration LIKE '%min'
ORDER BY cast( REPLACE (duration, ' min', '') as int) DESC;

--6. Find content added in the last 5 years
select *
from [Netflix Project].[dbo].[netflix_titles]
where cast(date_added as date)>=DATEADD(year,-5,cast(GETDATE() as date))

--7 Find all the movies/TV shows by director 'Rajiv Chilaka'!
select director from [Netflix Project].[dbo].[netflix_titles]
select * 
from [Netflix Project].[dbo].[netflix_titles]
where director like'%Rajiv Chilaka%'

--8. List all TV shows with more than 5 seasons
SELECT *
FROM [Netflix Project].[dbo].[netflix_titles]
WHERE type = 'TV Show'
  AND duration LIKE '%Season%'
  AND CAST(REPLACE(REPLACE(duration, 'Seasons', ''), 'Season', '') AS INT) > 5;


--9 Count the number of content items in each genre
select 
	LTRIM(RTRIM(value)) AS Genre,
	count(*) as content_items
	from  [Netflix Project].[dbo].[netflix_titles]
	CROSS APPLY STRING_SPLIT(listed_in, ',')
	GROUP BY LTRIM(RTRIM(value))

--10.Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release !
select year(cast(date_added as date)) as Year,
count(*) as content_release,
round(cast(count(*) as float)/(select count(*) *1.0 
								from  [Netflix Project].[dbo].[netflix_titles] 
								where country like'%India%' )*100,2)
from [Netflix Project].[dbo].[netflix_titles]
where country like'%India%'
group by year(cast(date_added as date))

-- 11. List all movies that are documentaries
select *
from  [Netflix Project].[dbo].[netflix_titles]
where type='Movie'
and listed_in like'%documentaries%'

-- 12. Find all content without a director
select * from [Netflix Project].[dbo].[netflix_titles]
where director is NULL

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from  [Netflix Project].[dbo].[netflix_titles]
where [cast] like '%Salman Khan%'
and release_year>= YEAR(DATEADD(year,-10,GETDATE()));

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select top 10
	LTRIM(RTRIM(value)) AS Actors,
	count(*) as content_items
	from  [Netflix Project].[dbo].[netflix_titles]
	CROSS APPLY STRING_SPLIT([cast], ',')
	where country = 'India'
	GROUP BY LTRIM(RTRIM(value)) 
	order by content_items desc

/* 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in  the description field. 
Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.*/
select * from [Netflix Project].[dbo].[netflix_titles]