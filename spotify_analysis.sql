-- // show all datas

select * from spotify;

-- Easy Questions
/*
-- 1. Retrieve the names of all tracks that hvae more than 1 billion streams.
-- 2. List all albums along with their respective artists.
-- 3. Get the total number of comments for tracks where liscensed = True.
-- 4. Find all tracks that belong to the album type single.
-- 5. count the total number of tracks by each artist.

-- Medium questions

-- 1. Calculate the average danceability of tracks in each album.
-- 2. Find the top 5 tracks with the highest energy values.
-- 3. List all tracks along with their views and likes where official_video = TRUE.
-- 4. For each album, calculate the total views of all associated tracks.
-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.

-- Advanced questions
-- 1. Find the top 3 most-viewed tracks for each artist using window functions.
-- 2. Write a query to find tracks where the liveness score is above the average.
-- 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
-- 4. Find tracks where the energy to liveness ratio is greater than 1.2.
-- 5. calculate the cumulative sum of likes for tracks ordered by the number of views , using window function.
*/


-- Easy Questions:

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify 
where stream > 1000000000;

-- 2. List all albums along with their respective artists.

select distinct (album) , artist from spotify;

-- 3. Get the total number of comments for tracks where liscensed = True.

select sum(comments) from spotify
where licensed = true;

-- 4. Find all tracks that belong to the album type single.

select * from spotify
where album_type = 'single';

-- 5. count the total number of tracks by each artist.

select artist , count(artist) as total_numbers from spotify 
group by artist
order by 2 asc ;


-- Medium questions

-- 1. Calculate the average danceability of tracks in each album.

select album, avg(danceability) as avg_danceability 
from spotify
group by album
order by avg_danceability desc;

-- 2. Find the top 5 tracks with the highest energy values.

select track , max(energy) as high_energy from spotify
group by 1 order by high_energy desc
limit 5;

-- 3. List all tracks along with their views and likes where official_video = TRUE.


select track , 
sum(views) as total_views,
sum(likes) as total_likes
from spotify 
where official_video = true
group by 1 
order by 2 desc
limit 10;

-- 4. For each album, calculate the total views of all associated tracks.

select album,track,sum(views) as total_views 
from spotify
group by 1,2 
order by total_views desc;

-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from (select track,
coalesce(sum(case when most_playedon = 'Spotify' then stream end),0)as spotify_streamed,
coalesce(sum(case when most_playedon ='Youtube' then stream end),0) as youtube_streamed
from spotify
group by 1) as t1 
where spotify_streamed > youtube_streamed 
and youtube_streamed <> 0 
limit 10;

-- Advanced questions

-- 1. Find the top 3 most-viewed tracks for each artist using window functions.

select * from (select artist,
track,
sum(views) as total_views,
Dense_Rank() over(partition by artist order by sum(views) desc) as top3_mostly_viewed
from spotify
group by 1,2
order by artist, total_views desc)
as trimed_data
where top3_mostly_viewed <=3;

-- 2. Write a query to find tracks where the liveness score is above the average.

select track ,artist,  liveness from spotify where liveness >(

select avg(liveness) from spotify);

-- 3.  Use a WITH clause to calculate the difference between the highest and lowest energy values 
-- for tracks in each album.


with cte as (select album,
max(energy) as high_energy_levels,
min(energy) as low_energy_levels from spotify
group by 1)

select album ,
high_energy_levels - low_energy_levels as energy_difference 
from cte 
order by energy_difference desc  ;

-- 4. Find tracks where the energy to liveness ratio is greater than 1.2.

with cte as (select album,energy,energy/nullif(liveness,0) as ratio_liveness from spotify)
select * from cte where ratio_liveness > 1.2 order by ratio_liveness desc;

-- 5. calculate the cumulative sum of likes for tracks ordered by the number of views , using window function.

select 
track, 
sum(likes) over( order by views desc ) as liked_tracks 
from spotify ;




























