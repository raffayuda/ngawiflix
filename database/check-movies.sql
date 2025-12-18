-- Check if there are any movies in the database
SELECT movie_id, title, poster_url, backdrop_url 
FROM movies 
LIMIT 5;

-- Check total count
SELECT COUNT(*) as total_movies FROM movies;

-- Check data types
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'movies' 
AND column_name IN ('poster_url', 'backdrop_url', 'trailer_url');
