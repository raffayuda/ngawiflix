-- Database Schema for CinemaX Ticket Booking System
-- PostgreSQL Database

-- Drop tables if exist (for fresh installation)
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS seats CASCADE;
DROP TABLE IF EXISTS schedules CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS theaters CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

-- Create Categories Table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Movies Table
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    poster_url TEXT,
    backdrop_url TEXT,
    trailer_url TEXT,
    director VARCHAR(100),
    duration INTEGER, -- in minutes
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 10),
    rated VARCHAR(10), -- 13+, 17+, etc
    release_year INTEGER,
    is_new BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Movie-Category Relationship (Many-to-Many)
CREATE TABLE movie_categories (
    movie_id INTEGER REFERENCES movies(movie_id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, category_id)
);

-- Create Theaters Table
CREATE TABLE theaters (
    theater_id SERIAL PRIMARY KEY,
    theater_name VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    total_seats INTEGER DEFAULT 80,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Schedules Table
CREATE TABLE schedules (
    schedule_id SERIAL PRIMARY KEY,
    movie_id INTEGER REFERENCES movies(movie_id) ON DELETE CASCADE,
    theater_id INTEGER REFERENCES theaters(theater_id) ON DELETE CASCADE,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Seats Table
CREATE TABLE seats (
    seat_id SERIAL PRIMARY KEY,
    schedule_id INTEGER REFERENCES schedules(schedule_id) ON DELETE CASCADE,
    row_letter CHAR(1) NOT NULL,
    seat_number INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'selected', 'occupied')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(schedule_id, row_letter, seat_number)
);

-- Create Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('user', 'admin')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, email, password, full_name, phone, role) VALUES
('admin', 'admin@cinemax.com', 'admin123', 'Administrator', '081234567890', 'admin');

-- Create Bookings Table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL,
    schedule_id INTEGER REFERENCES schedules(schedule_id) ON DELETE CASCADE,
    booking_code VARCHAR(20) NOT NULL UNIQUE,
    total_seats INTEGER NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'pending' CHECK (booking_status IN ('pending', 'confirmed', 'cancelled')),
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Booking Details Table (for seat information)
CREATE TABLE booking_details (
    booking_detail_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id) ON DELETE CASCADE,
    seat_id INTEGER REFERENCES seats(seat_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Sample Categories
INSERT INTO categories (category_name) VALUES 
('action'),
('drama'),
('comedy'),
('horror'),
('sci-fi'),
('romance'),
('thriller'),
('adventure'),
('fantasy'),
('animation');

-- Insert Sample Movies
INSERT INTO movies (title, description, poster_url, backdrop_url, director, duration, rating, rated, release_year, is_new, is_featured) VALUES
('Guardians of Tomorrow', 'Sebuah petualangan epik melintasi galaksi untuk menyelamatkan umat manusia dari ancaman alien yang misterius.', 
 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', 
 'https://image.tmdb.org/t/p/original/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg', 
 'James Cameron', 148, 9.2, '13+', 2025, TRUE, TRUE),

('The Last Symphony', 'Kisah inspiratif seorang pianis muda yang berjuang meraih mimpinya di tengah tekanan keluarga dan masyarakat.',
 'https://image.tmdb.org/t/p/w500/qNBAXBIQlnOThrVvA6mA2B5ggV6.jpg',
 'https://image.tmdb.org/t/p/original/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg',
 'Damien Chazelle', 135, 8.8, '17+', 2025, TRUE, TRUE),

('Shadow Warriors', 'Pertempuran sengit antara pasukan elit melawan organisasi teroris internasional yang mengancam perdamaian dunia.',
 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
 'https://image.tmdb.org/t/p/original/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg',
 'Christopher Nolan', 165, 9.0, '17+', 2024, FALSE, TRUE),

('Midnight Laughter', 'Komedi romantis tentang dua orang yang bertemu secara tidak sengaja di tengah malam dan petualangan lucu mereka.',
 'https://image.tmdb.org/t/p/w500/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg',
 'https://image.tmdb.org/t/p/original/4HodYYKEIsGOdinkGi2Ucz6X9i0.jpg',
 'Judd Apatow', 112, 7.9, '13+', 2024, FALSE, FALSE),

('The Haunting Hour', 'Horror psikologis yang menegangkan tentang keluarga yang pindah ke rumah tua dengan masa lalu kelam.',
 'https://image.tmdb.org/t/p/w500/9xeEGUZjgiKlI69jwIOi0hjKUIk.jpg',
 'https://image.tmdb.org/t/p/original/hZkgoQYus5vegHoetLkCJzb17zJ.jpg',
 'Ari Aster', 125, 8.3, '17+', 2025, TRUE, FALSE),

('Love in Paris', 'Kisah cinta yang indah di kota Paris antara seorang pelukis dan seorang penulis.',
 'https://image.tmdb.org/t/p/w500/yOm993lsJyPmBodlYjgpPwMfUt.jpg',
 'https://image.tmdb.org/t/p/original/yF1eOkaYvwiORauRCPWznV9xVvi.jpg',
 'Richard Linklater', 118, 8.1, '13+', 2024, FALSE, FALSE),

('Cyber Revolution', 'Di masa depan dystopian, seorang hacker genius melawan sistem AI yang menguasai dunia.',
 'https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg',
 'https://image.tmdb.org/t/p/original/zP515p6ObjCJiZ3JxtyHdcvZSXT.jpg',
 'Denis Villeneuve', 152, 8.7, '17+', 2025, TRUE, FALSE),

('Family Reunion', 'Komedi keluarga tentang reuni keluarga yang kacau balau namun penuh kehangatan.',
 'https://image.tmdb.org/t/p/w500/fiVW06jE7z9YnO4trhaMEdclSiC.jpg',
 'https://image.tmdb.org/t/p/original/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg',
 'Nancy Meyers', 105, 7.6, '13+', 2024, FALSE, FALSE),

('Storm Chasers', 'Tim ilmuwan berani menghadapi badai tornado terbesar dalam sejarah untuk menyelamatkan kota.',
 'https://image.tmdb.org/t/p/w500/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
 'https://image.tmdb.org/t/p/original/xJHokMbljvjADYdit5fK5VQsXEG.jpg',
 'Jan de Bont', 138, 8.4, '13+', 2025, TRUE, FALSE),

('Silent Whispers', 'Drama mendalam tentang seorang detektif yang menyelidiki kasus pembunuhan berantai misterius.',
 'https://image.tmdb.org/t/p/w500/rktDFPbfHfUbArZ6OOOKsXcv0Bm.jpg',
 'https://image.tmdb.org/t/p/original/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg',
 'David Fincher', 128, 8.9, '17+', 2024, FALSE, FALSE);

-- Insert Movie-Category Relationships
INSERT INTO movie_categories (movie_id, category_id) VALUES
-- Guardians of Tomorrow
(1, 5), (1, 1), (1, 8),
-- The Last Symphony
(2, 2),
-- Shadow Warriors
(3, 1), (3, 7),
-- Midnight Laughter
(4, 3), (4, 6),
-- The Haunting Hour
(5, 4), (5, 7),
-- Love in Paris
(6, 6), (6, 2),
-- Cyber Revolution
(7, 5), (7, 1),
-- Family Reunion
(8, 3), (8, 2),
-- Storm Chasers
(9, 1), (9, 8),
-- Silent Whispers
(10, 2), (10, 7);

-- Insert Sample Theaters
INSERT INTO theaters (theater_name, location, total_seats) VALUES
('Theater 1', 'Lantai 2', 80),
('Theater 2', 'Lantai 2', 80),
('Theater 3', 'Lantai 3', 100),
('IMAX Theater', 'Lantai 4', 120);

-- Insert Sample Schedules (for the next 7 days)
INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES
-- Guardians of Tomorrow
(1, 1, CURRENT_DATE, '10:00:00', 50000),
(1, 1, CURRENT_DATE, '13:00:00', 50000),
(1, 2, CURRENT_DATE, '16:00:00', 50000),
(1, 4, CURRENT_DATE, '19:00:00', 75000),
-- The Last Symphony
(2, 2, CURRENT_DATE, '11:00:00', 50000),
(2, 3, CURRENT_DATE, '14:00:00', 60000),
(2, 3, CURRENT_DATE, '17:00:00', 60000),
-- Shadow Warriors
(3, 3, CURRENT_DATE, '12:00:00', 60000),
(3, 4, CURRENT_DATE, '15:00:00', 75000),
(3, 4, CURRENT_DATE, '20:00:00', 75000);

-- Function to generate seats for a schedule
CREATE OR REPLACE FUNCTION generate_seats_for_schedule(p_schedule_id INTEGER, p_total_seats INTEGER DEFAULT 80)
RETURNS VOID AS $$
DECLARE
    v_row_letter CHAR(1);
    v_seat_num INTEGER;
    v_rows_count INTEGER;
    v_seats_per_row INTEGER;
BEGIN
    v_seats_per_row := 10;
    v_rows_count := CEIL(p_total_seats::DECIMAL / v_seats_per_row);
    
    FOR i IN 0..(v_rows_count - 1) LOOP
        v_row_letter := CHR(65 + i); -- A, B, C, ...
        
        FOR j IN 1..v_seats_per_row LOOP
            -- Randomly set some seats as occupied (30% chance)
            INSERT INTO seats (schedule_id, row_letter, seat_number, status)
            VALUES (
                p_schedule_id, 
                v_row_letter, 
                j,
                CASE WHEN RANDOM() > 0.7 THEN 'occupied' ELSE 'available' END
            );
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Generate seats for all existing schedules
DO $$
DECLARE
    schedule_rec RECORD;
BEGIN
    FOR schedule_rec IN SELECT schedule_id, total_seats FROM schedules s JOIN theaters t ON s.theater_id = t.theater_id LOOP
        PERFORM generate_seats_for_schedule(schedule_rec.schedule_id, schedule_rec.total_seats);
    END LOOP;
END $$;

-- Create indexes for better performance
CREATE INDEX idx_movies_title ON movies(title);
CREATE INDEX idx_movies_rating ON movies(rating DESC);
CREATE INDEX idx_schedules_date ON schedules(show_date);
CREATE INDEX idx_seats_schedule ON seats(schedule_id);
CREATE INDEX idx_bookings_code ON bookings(booking_code);

-- Create View for Movie with Categories
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

-- Create View for Schedule Details
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

COMMENT ON DATABASE postgres IS 'CinemaX Ticket Booking Database';
