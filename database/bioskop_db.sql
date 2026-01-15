BEGIN;

-- =========================
-- TABLE: users
-- =========================
CREATE TABLE IF NOT EXISTS public.users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: movies
-- =========================
CREATE TABLE IF NOT EXISTS public.movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    poster_url TEXT,
    backdrop_url TEXT,
    trailer_url TEXT,
    director VARCHAR(100),
    duration INTEGER,
    rating NUMERIC(2,1),
    rated VARCHAR(10),
    release_year INTEGER,
    is_new BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: categories
-- =========================
CREATE TABLE IF NOT EXISTS public.categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: theaters
-- =========================
CREATE TABLE IF NOT EXISTS public.theaters (
    theater_id SERIAL PRIMARY KEY,
    theater_name VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    total_seats INTEGER DEFAULT 80,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: schedules
-- =========================
CREATE TABLE IF NOT EXISTS public.schedules (
    schedule_id SERIAL PRIMARY KEY,
    movie_id INTEGER,
    theater_id INTEGER,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: seats
-- =========================
CREATE TABLE IF NOT EXISTS public.seats (
    seat_id SERIAL PRIMARY KEY,
    schedule_id INTEGER,
    row_letter CHAR(1) NOT NULL,
    seat_number INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT seats_schedule_unique
        UNIQUE (schedule_id, row_letter, seat_number)
);

-- =========================
-- TABLE: bookings
-- =========================
CREATE TABLE IF NOT EXISTS public.bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    schedule_id INTEGER,
    booking_code VARCHAR(20) NOT NULL UNIQUE,
    total_seats INTEGER NOT NULL,
    total_price NUMERIC(10,2) NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'pending',
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: booking_details
-- =========================
CREATE TABLE IF NOT EXISTS public.booking_details (
    booking_detail_id SERIAL PRIMARY KEY,
    booking_id INTEGER,
    seat_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: movie_categories
-- =========================
CREATE TABLE IF NOT EXISTS public.movie_categories (
    movie_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    CONSTRAINT movie_categories_pkey
        PRIMARY KEY (movie_id, category_id)
);

-- =========================
-- FOREIGN KEYS
-- =========================
ALTER TABLE public.movie_categories
    ADD CONSTRAINT movie_categories_movie_id_fkey
    FOREIGN KEY (movie_id)
    REFERENCES public.movies (movie_id)
    ON DELETE CASCADE;

ALTER TABLE public.movie_categories
    ADD CONSTRAINT movie_categories_category_id_fkey
    FOREIGN KEY (category_id)
    REFERENCES public.categories (category_id)
    ON DELETE CASCADE;

ALTER TABLE public.schedules
    ADD CONSTRAINT schedules_movie_id_fkey
    FOREIGN KEY (movie_id)
    REFERENCES public.movies (movie_id)
    ON DELETE CASCADE;

ALTER TABLE public.schedules
    ADD CONSTRAINT schedules_theater_id_fkey
    FOREIGN KEY (theater_id)
    REFERENCES public.theaters (theater_id)
    ON DELETE CASCADE;

ALTER TABLE public.seats
    ADD CONSTRAINT seats_schedule_id_fkey
    FOREIGN KEY (schedule_id)
    REFERENCES public.schedules (schedule_id)
    ON DELETE CASCADE;

ALTER TABLE public.bookings
    ADD CONSTRAINT bookings_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users (user_id)
    ON DELETE SET NULL;

ALTER TABLE public.bookings
    ADD CONSTRAINT bookings_schedule_id_fkey
    FOREIGN KEY (schedule_id)
    REFERENCES public.schedules (schedule_id)
    ON DELETE CASCADE;

ALTER TABLE public.booking_details
    ADD CONSTRAINT booking_details_booking_id_fkey
    FOREIGN KEY (booking_id)
    REFERENCES public.bookings (booking_id)
    ON DELETE CASCADE;

ALTER TABLE public.booking_details
    ADD CONSTRAINT booking_details_seat_id_fkey
    FOREIGN KEY (seat_id)
    REFERENCES public.seats (seat_id)
    ON DELETE CASCADE;

COMMIT;
