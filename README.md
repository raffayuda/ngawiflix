# CinemaX - Aplikasi Pemesanan Tiket Bioskop

## Setup Database PostgreSQL

### 1. Install PostgreSQL
- Download dan install PostgreSQL dari https://www.postgresql.org/download/
- Install pgAdmin 4 (biasanya sudah termasuk dalam instalasi PostgreSQL)

### 2. Buat Database
1. Buka pgAdmin
2. Klik kanan pada **Databases** → **Create** → **Database**
3. Nama database: `cinemax_db`
4. Owner: `postgres`
5. Klik **Save**

### 3. Jalankan Script Database
1. Klik kanan pada database `cinemax_db`
2. Pilih **Query Tool**
3. Buka file `database/schema.sql`
4. Copy seluruh isinya dan paste ke Query Tool
5. Klik tombol **Execute** (F5)
6. Script akan membuat:
   - Semua tabel (movies, schedules, seats, bookings, dll)
   - Sample data (10 film, jadwal, kursi)
   - Views dan indexes

### 4. Konfigurasi Koneksi Database

Edit file `src/main/java/com/cinemax/util/DatabaseConnection.java`:

```java
private static final String URL = "jdbc:postgresql://localhost:5432/cinemax_db";
private static final String USER = "postgres";
private static final String PASSWORD = "your_password_here"; // Ganti dengan password PostgreSQL Anda
```

## Setup Project

### 1. Dependencies yang Diperlukan

Tambahkan dependencies berikut ke `WEB-INF/lib/`:

1. **PostgreSQL JDBC Driver**
   - Download: https://jdbc.postgresql.org/download/
   - File: `postgresql-42.7.1.jar` (atau versi terbaru)

2. **Gson (untuk JSON)**
   - Download: https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar
   - File: `gson-2.10.1.jar`

3. **Servlet API** (jika belum ada)
   - Biasanya sudah ada di Tomcat
   - File: `servlet-api.jar`

### 2. Struktur Project

```
pemesanan-tikek-bioskop/
├── src/main/
│   ├── java/com/cinemax/
│   │   ├── model/          (Movie, Schedule, Seat, Booking)
│   │   ├── dao/            (MovieDAO, ScheduleDAO, SeatDAO, BookingDAO)
│   │   ├── servlet/        (MovieServlet, ScheduleServlet, etc)
│   │   └── util/           (DatabaseConnection)
│   └── webapp/
│       ├── index.jsp       (Halaman utama)
│       └── WEB-INF/
│           └── lib/        (Letakkan JAR files di sini)
└── database/
    └── schema.sql          (Database schema)
```

### 3. Cara Menambahkan JAR ke Project Eclipse

1. Download semua JAR files yang diperlukan
2. Copy JAR files ke folder `src/main/webapp/WEB-INF/lib/`
3. Di Eclipse, klik kanan project → **Build Path** → **Configure Build Path**
4. Tab **Libraries** → **Add JARs** (bukan Add External JARs)
5. Pilih semua JAR di folder `WEB-INF/lib`
6. Klik **Apply and Close**

## API Endpoints

### Movies
- `GET /api/movies` - Get all movies
- `GET /api/movies?action=featured` - Get featured movies
- `GET /api/movies?category=action` - Get movies by category
- `GET /api/movies?search=keyword` - Search movies
- `GET /api/movies?movieId=1` - Get movie by ID

### Categories
- `GET /api/categories` - Get all categories

### Schedules
- `GET /api/schedules` - Get today's schedules
- `GET /api/schedules?movieId=1` - Get schedules by movie
- `GET /api/schedules?scheduleId=1` - Get schedule by ID

### Seats
- `GET /api/seats?scheduleId=1` - Get seats by schedule

### Bookings
- `POST /api/bookings` - Create new booking
  ```json
  {
    "scheduleId": 1,
    "customerName": "John Doe",
    "customerEmail": "john@example.com",
    "customerPhone": "08123456789",
    "seatIds": [1, 2, 3]
  }
  ```
- `GET /api/bookings?bookingCode=CX-ABC123` - Get booking by code
- `GET /api/bookings?email=john@example.com` - Get bookings by email

## Cara Menjalankan

1. Pastikan PostgreSQL sudah running
2. Database sudah dibuat dan schema sudah dijalankan
3. JAR dependencies sudah ditambahkan
4. Jalankan project di Tomcat
5. Buka browser: `http://localhost:8080/pemesanan-tikek-bioskop/`

## Testing Koneksi Database

Anda bisa test koneksi database dengan membuat JSP test sederhana:

```jsp
<%@ page import="com.cinemax.util.DatabaseConnection" %>
<%
    boolean connected = DatabaseConnection.testConnection();
    out.println(connected ? "Database Connected!" : "Connection Failed!");
%>
```

## Troubleshooting

### Error: ClassNotFoundException: org.postgresql.Driver
- Pastikan postgresql-*.jar sudah ada di WEB-INF/lib
- Clean and rebuild project

### Error: Connection refused
- Pastikan PostgreSQL service sedang running
- Check port 5432 (default PostgreSQL port)
- Verify username dan password di DatabaseConnection.java

### Error: Database "cinemax_db" does not exist
- Buat database dulu di pgAdmin
- Jalankan schema.sql

## Fitur-fitur

✅ Homepage dengan hero carousel
✅ Daftar film dari database
✅ Filter berdasarkan kategori
✅ Pencarian film
✅ Detail film dengan jadwal
✅ Pemilihan kursi interaktif
✅ Booking tiket
✅ Responsive design
✅ Modern UI/UX

## Database Schema

### Tables:
- **movies** - Data film
- **categories** - Kategori film
- **movie_categories** - Relasi film & kategori
- **theaters** - Data bioskop
- **schedules** - Jadwal tayang
- **seats** - Data kursi
- **bookings** - Data pemesanan
- **booking_details** - Detail pemesanan
- **users** - Data user (untuk fitur login nanti)

## Next Steps (Optional)

1. Implementasi fitur login/register
2. Payment gateway integration
3. QR Code untuk tiket
4. Email notification
5. Admin panel untuk manage movies
6. Rating & review system
7. Loyalty program
