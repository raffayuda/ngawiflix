    -- Additional Schedules for All Movies
    -- Run this SQL in pgAdmin to add schedules for all 10 movies

    -- Movie 4: Eternal Night
    INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES
    (4, 1, CURRENT_DATE, '11:30:00', 50000),
    (4, 2, CURRENT_DATE, '14:30:00', 50000),
    (4, 3, CURRENT_DATE, '17:30:00', 60000),
    (4, 4, CURRENT_DATE, '20:30:00', 75000);

    -- Movie 5: Desert Storms
    INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES
    (5, 1, CURRENT_DATE, '12:30:00', 50000),
    (5, 2, CURRENT_DATE, '15:30:00', 50000),
    (5, 3, CURRENT_DATE, '18:30:00', 60000);

    -- Movie 6: Love in Paris
    INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES
    (6, 1, CURRENT_DATE, '10:30:00', 50000),
    (6, 2, CURRENT_DATE, '13:30:00', 50000),
    (6, 3, CURRENT_DATE, '16:30:00', 60000),
    (6, 4, CURRENT_DATE, '19:30:00', 75000);

    -- Movie 7: Silent Whispers
    INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES
    (7, 1, CURRENT_DATE, '11:00:00', 50000),
    (7, 2, CURRENT_DATE, '14:00:00', 50000),
    (7, 3, CURRENT_DATE, '17:00:00', 60000),
    (7, 4, CURRENT_DATE, '21:00:00', 75000);

    -- Movie 8: Code Red
    INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES
    (8, 1, CURRENT_DATE, '09:30:00', 50000),
    (8, 2, CURRENT_DATE, '12:30:00', 50000),
    (8, 3, CURRENT_DATE, '15:30:00', 60000),
    (8, 4, CURRENT_DATE, '18:30:00', 75000);

    -- Movie 9: The Forgotten Kingdom
    INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES
    (9, 1, CURRENT_DATE, '10:15:00', 50000),
    (9, 2, CURRENT_DATE, '13:15:00', 50000),
    (9, 3, CURRENT_DATE, '16:15:00', 60000),
    (9, 4, CURRENT_DATE, '19:15:00', 75000);

    -- Movie 10: Ocean's Fury
    INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES
    (10, 1, CURRENT_DATE, '11:45:00', 50000),
    (10, 2, CURRENT_DATE, '14:45:00', 50000),
    (10, 3, CURRENT_DATE, '17:45:00', 60000),
    (10, 4, CURRENT_DATE, '20:45:00', 75000);

    -- Generate seats for the newly added schedules
    DO $$
    DECLARE
        schedule_rec RECORD;
    BEGIN
        FOR schedule_rec IN 
            SELECT s.schedule_id, t.total_seats 
            FROM schedules s 
            JOIN theaters t ON s.theater_id = t.theater_id 
            WHERE s.schedule_id NOT IN (SELECT DISTINCT schedule_id FROM seats)
        LOOP
            PERFORM generate_seats_for_schedule(schedule_rec.schedule_id, schedule_rec.total_seats);
        END LOOP;
    END $$;

    -- Verify schedules
    SELECT 
        m.title as movie_title,
        COUNT(s.schedule_id) as total_schedules
    FROM movies m
    LEFT JOIN schedules s ON m.movie_id = s.movie_id
    GROUP BY m.movie_id, m.title
    ORDER BY m.movie_id;
