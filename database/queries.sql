-- Query untuk melihat semua film
SELECT * FROM v_movies_with_categories;

-- Query untuk melihat jadwal hari ini
SELECT * FROM v_schedule_details WHERE show_date = CURRENT_DATE;

-- Query untuk melihat kursi yang tersedia
SELECT schedule_id, COUNT(*) as available_seats
FROM seats
WHERE status = 'available'
GROUP BY schedule_id;

-- Query untuk melihat booking terbaru
SELECT b.*, 
       m.title as movie_title,
       STRING_AGG(s.row_letter || s.seat_number, ', ') as seats
FROM bookings b
JOIN schedules sc ON b.schedule_id = sc.schedule_id
JOIN movies m ON sc.movie_id = m.movie_id
LEFT JOIN booking_details bd ON b.booking_id = bd.booking_id
LEFT JOIN seats s ON bd.seat_id = s.seat_id
GROUP BY b.booking_id, m.title
ORDER BY b.created_at DESC;

-- Query untuk statistik
SELECT 
    (SELECT COUNT(*) FROM movies) as total_movies,
    (SELECT COUNT(*) FROM bookings) as total_bookings,
    (SELECT COUNT(*) FROM seats WHERE status = 'occupied') as total_seats_occupied,
    (SELECT SUM(total_price) FROM bookings WHERE booking_status = 'confirmed') as total_revenue;

-- Query untuk film terpopuler (berdasarkan booking)
SELECT m.title, COUNT(b.booking_id) as total_bookings
FROM movies m
JOIN schedules s ON m.movie_id = s.movie_id
LEFT JOIN bookings b ON s.schedule_id = b.schedule_id
GROUP BY m.movie_id, m.title
ORDER BY total_bookings DESC
LIMIT 10;
