select *
from GlobalYouTubeStatistics

-- Devide video views by 1000000000
SELECT 
	"video views" / 1000000000 AS video_views_bn
FROM GlobalYouTubeStatistics

ALTER TABLE GlobalYouTubeStatistics
ADD video_views_bn float

UPDATE GlobalYouTubeStatistics
SET video_views_bn = "video views" / 1000000000

-- How many video view of each category
SELECT
	category,
	COUNT(video_views_bn) AS video_views_count
FROM GlobalYouTubeStatistics
GROUP BY category
ORDER BY COUNT(video_views_bn) DESC

-- How many video view per total view in percent

DROP TABLE if exists #temp_total_view
CREATE TABLE #temp_total_view
(
	total_view float
)
INSERT INTO #temp_total_view
SELECT
	COUNT(video_views_bn) as total_views
FROM GlobalYouTubeStatistics

SELECT
	total_view
FROM #temp_total_view

SELECT 
	category,
	video_views_bn,
	(video_views_bn / (	SELECT
							total_view
						FROM #temp_total_view 
					 )) * 100 AS percent_share
FROM GlobalYouTubeStatistics
ORDER BY percent_share DESC

-- How many youtuber in each country
SELECT
	Country,
	COUNT(Country) AS Country_count
FROM GlobalYouTubeStatistics
GROUP BY Country
ORDER BY Country_count DESC

-- How many video view in each country
SELECT
	country,
	COUNT(video_views_bn) AS video_views_count
FROM GlobalYouTubeStatistics
GROUP BY country 
ORDER BY video_views_count DESC

-- How long the channel age since the created year. (Channel age)
SELECT 
	2023 - created_year AS channel_age
FROM GlobalYouTubeStatistics

ALTER TABLE GlobalYouTubeStatistics
ADD channel_age int

UPDATE GlobalYouTubeStatistics
SET channel_age = (2023 - created_year)

-- Find avg subscriber per year
SELECT
	subscribers / channel_age AS avg_subs_year
FROM GlobalYouTubeStatistics

ALTER TABLE GlobalYouTubeStatistics
ADD avg_subs_year float

UPDATE GlobalYouTubeStatistics
SET avg_subs_year = subscribers / channel_age

-- Basic statistics
-- unique youtuber
SELECT
	DISTINCT(youtuber)
FROM GlobalYouTubeStatistics

-- avg
SELECT
	avg(subscribers),
	avg(video_views_bn)
FROM GlobalYouTubeStatistics

--common category
SELECT
	category,
	COUNT(category) AS category_count
FROM GlobalYouTubeStatistics
GROUP BY category
ORDER BY category_count DESC

--
SELECT *
FROM GlobalYouTubeStatistics



