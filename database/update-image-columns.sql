-- Update schema to support base64 images
-- Run this SQL in your PostgreSQL database

-- Step 1: Drop the views that depend on the columns
DROP VIEW IF EXISTS v_schedule_details;
DROP VIEW IF EXISTS v_movies_with_categories;

-- Step 2: Alter the columns to TEXT type
ALTER TABLE movies 
ALTER COLUMN poster_url TYPE TEXT,
ALTER COLUMN backdrop_url TYPE TEXT,
ALTER COLUMN trailer_url TYPE TEXT;

-- Step 3: Recreate the views

-- Recreate v_movies_with_categories view
CREATE VIEW v_movies_with_categories AS
SELECT 
    m.movie_id,
    m.title,
    m.description,
    m.poster_url,
    m.backdrop_url,
    m.trailer_url,
    m.director,
    m.duration,
    m.rating,
    m.rated,
    m.release_year,
    m.is_new,
    m.is_featured,
    STRING_AGG(c.category_name, ',') as categories
FROM movies m
LEFT JOIN movie_categories mc ON m.movie_id = mc.movie_id
LEFT JOIN categories c ON mc.category_id = c.category_id
GROUP BY m.movie_id;

-- Recreate v_schedule_details view
CREATE VIEW v_schedule_details AS
SELECT 
    s.schedule_id,
    s.show_date,
    s.show_time,
    s.price,
    m.movie_id,
    m.title as movie_title,
    m.poster_url,
    m.duration,
    m.rated,
    t.theater_id,
    t.theater_name,
    t.location,
    t.total_seats,
    COUNT(CASE WHEN st.status = 'available' THEN 1 END) as available_seats
FROM schedules s
JOIN movies m ON s.movie_id = m.movie_id
JOIN theaters t ON s.theater_id = t.theater_id
LEFT JOIN seats st ON s.schedule_id = st.schedule_id
GROUP BY s.schedule_id, s.show_date, s.show_time, s.price, 
         m.movie_id, m.title, m.poster_url, m.duration, m.rated,
         t.theater_id, t.theater_name, t.location, t.total_seats;

-- Step 4: Verify the changes
SELECT column_name, data_type, character_maximum_length 
FROM information_schema.columns 
WHERE table_name = 'movies' 
AND column_name IN ('poster_url', 'backdrop_url', 'trailer_url');

-- Step 5: Verify both views exist
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_name IN ('v_schedule_details', 'v_movies_with_categories');

