-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows

select 
	type,
	count(show_id) 
from netflix
group by 1


2. Find the most common rating for movies and TV shows

select
	type,
	rating,
	count(show_id)
from netflix
group by 1,2
order by 3 desc


3. List all movies released in a specific year (e.g., 2020)

select 
	release_year,
	title
from netflix
where 
	release_year = 2020 
	and 
	type = 'Movie'
group by 1,2


4. Find the top 5 countries with the most content on Netflix

select 
	unnest(string_to_array(country,',')) as new_country,
	count(show_id)
from netflix
group by 1
order by 2 desc
limit 5


5. Identify the longest movie

select 
	title,
	duration
from netflix
where 
	type = 'Movie'
	and
	duration is not null
order by split_part(duration,' ',1)::int desc


6. Find content added in the last 5 years

select 
	title,
	date_added
from netflix
where 
	to_date(date_added,'month dd, yyyy') >= current_date - interval '5 years'


7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from
(select 
	title,
	director,
	unnest(string_to_array(director,',')) as director_name
from netflix)
where director_name = 'Rajiv Chilaka'

2nd method

select
	title,
	director
from netflix
where director like '%Rajiv Chilaka%'


8. List all TV shows with more than 5 seasons

select 
	title,
	duration
from netflix
where 
	type = 'TV Show'
	and
	split_part(duration,' ',1)::int >= 5


9. Count the number of content items in each genre

select
	unnest(string_to_array(listed_in,', ')) as genre,
	count(show_id) as total_content
from netflix
group  by 1
order by 2 desc


10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select 
	extract(year from to_date(date_added,'month dd, yyyy')) as release_year,
	count(*) as totoal_content,
	cast(count(*)::numeric/(select count(*) from netflix where country like '%India%')::numeric *100 as numeric (10,2))as avg_content_per_year
from netflix
where 
	extract(year from to_date(date_added,'month dd, yyyy')) is not null
	and 
	country like '%India%'
group by 1
order by 3 desc


11. List all movies that are documentaries

select * from (
		select
			title,
			unnest(string_to_array(listed_in,', ')) as genre
		from netflix)
	where genre like '%Documentaries%'


12. Find all content without a director

select * from netflix
where director is null


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select count(*) from netflix
where 
	casts like '%Salman Khan%'
	and
	to_date(date_added,'month dd, yyyy') >= current_date - interval '10 years'


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
	unnest(string_to_array(casts,', ')) as actors,
	count(*) as total_movies
from netflix
where country like '%India%'
group by 1
order by 2 desc


15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

select
	case
		when description like '%kill%' then 'Bad_content'
		when description like '%violence%' then 'Bad_content'
		else 'Good_content'
		end as lebel,
	count(*) as total_movies
from netflix
group by 1
