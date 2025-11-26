-- Update trailer URL for existing movies

-- Update Ayat - ayat Jawa (ID: 11)
UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=7MkAs99O1LQ'
WHERE movie_id = 11;

-- Update other sample movies with trailer URLs
UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=wUn0gAVpCHE'
WHERE title = 'Guardians of Tomorrow';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=MZ8jcv8dmX8'
WHERE title = 'The Last Symphony';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=8hP9D6kZseM'
WHERE title = 'Shadow Warriors';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=d96cjJhvlMA'
WHERE title = 'Midnight Laughter';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=SzgG94Tz2Ak'
WHERE title = 'The Haunting Hour';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=IUBaTXRex90'
WHERE title = 'Love in Paris';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=1RWOpQXTltA'
WHERE title = 'Cyber Revolution';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=QDQfUG6czhg'
WHERE title = 'Family Reunion';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=u6eihvlNJ1c'
WHERE title = 'Storm Chasers';

UPDATE movies 
SET trailer_url = 'https://www.youtube.com/watch?v=zbS23tkbRdk'
WHERE title = 'Silent Whispers';

-- Verify the updates
SELECT movie_id, title, trailer_url FROM movies ORDER BY movie_id;
