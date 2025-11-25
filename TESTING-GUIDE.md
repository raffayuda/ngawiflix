# 🧪 Testing Guide - CinemaX Aplikasi Dinamis

## ✅ Checklist Testing

### 1️⃣ Test Database Connection

**URL:** `http://localhost:8080/pemesanan-tikek-bioskop/test-connection.jsp`

**Expected Result:**
```
✅ Database Connected Successfully!
```

**If Failed:**
- Check PostgreSQL service is running
- Verify password in DatabaseConnection.java
- Verify database "cinemax_db" exists

---

### 2️⃣ Test API Endpoints

#### A. Test Movies API
**URL:** `http://localhost:8080/pemesanan-tikek-bioskop/api/movies`

**Expected Result:**
```json
[
  {
    "movieId": 1,
    "title": "Guardians of Tomorrow",
    "rating": 9.2,
    "genres": ["sci-fi", "action", "adventure"],
    ...
  },
  ...
]
```

**What to Check:**
- ✅ Returns JSON array
- ✅ Contains 10 movies
- ✅ Each movie has all properties (title, rating, poster, etc)

---

#### B. Test Categories API
**URL:** `http://localhost:8080/pemesanan-tikek-bioskop/api/categories`

**Expected Result:**
```json
["action", "adventure", "animation", "comedy", "drama", "fantasy", "horror", "romance", "sci-fi", "thriller"]
```

**What to Check:**
- ✅ Returns array of strings
- ✅ Contains 10 categories

---

#### C. Test Featured Movies API
**URL:** `http://localhost:8080/pemesanan-tikek-bioskop/api/movies?action=featured`

**Expected Result:**
```json
[
  {
    "movieId": 1,
    "title": "Guardians of Tomorrow",
    "isFeatured": true,
    ...
  },
  ...
]
```

**What to Check:**
- ✅ Returns only featured movies (3 movies)
- ✅ All have `isFeatured: true`

---

#### D. Test Schedules API
**URL:** `http://localhost:8080/pemesanan-tikek-bioskop/api/schedules?movieId=1`

**Expected Result:**
```json
[
  {
    "scheduleId": 1,
    "movieId": 1,
    "showDate": "2025-11-01",
    "showTime": "10:00:00",
    "price": 50000,
    "theaterName": "Theater 1",
    ...
  },
  ...
]
```

**What to Check:**
- ✅ Returns schedules for movie ID 1
- ✅ Contains schedule details (date, time, price)
- ✅ Theater information included

---

#### E. Test Seats API
**URL:** `http://localhost:8080/pemesanan-tikek-bioskop/api/seats?scheduleId=1`

**Expected Result:**
```json
[
  {
    "row": "A",
    "seats": [
      {"seatId": 1, "number": 1, "status": "available"},
      {"seatId": 2, "number": 2, "status": "occupied"},
      ...
    ]
  },
  ...
]
```

**What to Check:**
- ✅ Returns grouped seats by row
- ✅ Each seat has seatId, number, status
- ✅ Status is either: available, occupied, or selected

---

### 3️⃣ Test Frontend (Homepage)

**URL:** `http://localhost:8080/pemesanan-tikek-bioskop/`

#### A. Initial Load
**What to Check:**
- ✅ Hero carousel shows 3 featured movies from database
- ✅ Movie grid shows 10 movies from database
- ✅ Filter categories show all categories from database
- ✅ No console errors in browser DevTools

**How to Check Console:**
1. Press F12 (Chrome DevTools)
2. Go to "Console" tab
3. Should see no red errors

---

#### B. Hero Carousel
**What to Test:**
1. Carousel auto-plays every 5 seconds
2. Click left/right arrows to navigate
3. Click indicator dots to jump to specific slide
4. Each slide shows:
   - Movie title
   - Rating
   - Description
   - "Pesan Sekarang" button

**Expected:**
- ✅ Carousel works smoothly
- ✅ All 3 featured movies appear
- ✅ Data comes from database (check movie titles)

---

#### C. Category Filter
**What to Test:**
1. Click "Semua" - shows all 10 movies
2. Click "action" - shows only action movies
3. Click "drama" - shows only drama movies
4. Click other categories

**Expected:**
- ✅ Filter works dynamically
- ✅ Movies are filtered from database
- ✅ No page reload

**Check Network Tab:**
1. F12 → Network tab
2. Click a category
3. Should see request to: `api/movies?category=action`

---

#### D. Search Function
**What to Test:**
1. Click search icon in navbar
2. Type "Guardian" in search box
3. Should filter movies with "Guardian" in title

**Expected:**
- ✅ Search box appears/hides when clicking icon
- ✅ Movies filtered in real-time
- ✅ Search is case-insensitive

**Check Network Tab:**
- Should see request to: `api/movies?search=Guardian`

---

#### E. Movie Detail Modal
**What to Test:**
1. Click any movie card
2. Modal should open with:
   - Movie backdrop image
   - Full title
   - Rating, year, rated, duration
   - Synopsis
   - Genre tags
   - Director name

**Expected:**
- ✅ Modal opens smoothly
- ✅ All data from database displayed
- ✅ Close button works

---

#### F. Seat Selection
**What to Test:**
1. Click a movie to open modal
2. Click "Pilih Kursi" button
3. Should see:
   - Theater layout
   - Screen indicator
   - Seat grid (8 rows × 10 seats)
   - Color legend
   - Available seats (green)
   - Occupied seats (grey)

**Expected:**
- ✅ Seats load from database
- ✅ Shows real availability status
- ✅ Loading indicator appears while fetching

**Check Network Tab:**
- Request to: `api/seats?scheduleId=1`
- Response contains seat data with statuses

---

#### G. Seat Selection Interaction
**What to Test:**
1. Click available seat (green)
   - Should turn red (selected)
   - Seat code added to summary

2. Click selected seat (red)
   - Should turn green (available)
   - Removed from summary

3. Try click occupied seat (grey)
   - Should not change
   - Cannot be selected

4. Select multiple seats
   - All should turn red
   - All listed in summary
   - Total price calculated automatically

**Expected:**
- ✅ Seats can be selected/deselected
- ✅ Occupied seats cannot be selected
- ✅ Summary updates in real-time
- ✅ Total price = number of seats × price per seat

---

#### H. Booking Process
**What to Test:**
1. Select 2-3 seats
2. Click "Konfirmasi Pesanan"
3. Enter customer information:
   - Name
   - Email
   - Phone
4. Submit booking

**Expected:**
- ✅ Prompts for customer info
- ✅ Shows loading indicator
- ✅ Success modal appears
- ✅ Shows booking code (e.g., CX-ABC12345)
- ✅ Shows selected seats
- ✅ Shows total price

**Check Network Tab:**
1. POST request to: `api/bookings`
2. Request body:
```json
{
  "scheduleId": 1,
  "customerName": "John Doe",
  "customerEmail": "john@example.com",
  "customerPhone": "08123456789",
  "seatIds": [1, 2, 3]
}
```
3. Response:
```json
{
  "success": true,
  "bookingCode": "CX-ABC12345",
  "message": "Booking berhasil dibuat!"
}
```

---

#### I. Verify Booking in Database
**Using pgAdmin:**
1. Open pgAdmin
2. Connect to cinemax_db
3. Run query:
```sql
SELECT * FROM bookings ORDER BY created_at DESC LIMIT 5;
```

**Expected:**
- ✅ New booking appears
- ✅ Booking code matches what was shown
- ✅ Customer info saved correctly
- ✅ Total price correct

**Check seats updated:**
```sql
SELECT * FROM seats WHERE seat_id IN (1, 2, 3);
```

**Expected:**
- ✅ Selected seats now have status = 'occupied'

---

### 4️⃣ Responsive Design Test

**What to Test:**
1. Desktop (1920px)
   - Full navigation visible
   - 5 movies per row

2. Tablet (768px)
   - Mobile menu appears
   - 3 movies per row

3. Mobile (375px)
   - Hamburger menu
   - 2 movies per row
   - Touch-friendly buttons

**How to Test:**
1. Press F12 → Toggle device toolbar
2. Select different devices
3. Check layout adapts properly

---

### 5️⃣ Performance Test

**Check Load Times:**
1. F12 → Network tab
2. Refresh page
3. Check:
   - ✅ Movies API < 500ms
   - ✅ Categories API < 200ms
   - ✅ Seats API < 300ms
   - ✅ Total page load < 2s

---

## 🐛 Common Issues & Solutions

### Issue 1: Movies not loading
**Symptoms:** Empty movie grid, no data

**Check:**
1. Browser console for errors
2. Network tab for failed requests
3. Database has movie data:
```sql
SELECT COUNT(*) FROM movies;
-- Should return 10
```

**Solution:**
- Verify API endpoints working
- Check servlet mappings
- Verify JAR files in WEB-INF/lib

---

### Issue 2: Seats not loading
**Symptoms:** "Gagal memuat data kursi" alert

**Check:**
1. Network tab for seats API call
2. Database has seats:
```sql
SELECT COUNT(*) FROM seats WHERE schedule_id = 1;
-- Should return 80
```

**Solution:**
- Check schedule_id is valid
- Verify seats generated for schedule

---

### Issue 3: Booking fails
**Symptoms:** Alert "Terjadi kesalahan saat booking"

**Check:**
1. Network tab → POST to api/bookings
2. Response error message
3. Browser console

**Common Causes:**
- Missing customer info
- Invalid seat IDs
- Database connection lost
- Seats already occupied

**Solution:**
- Check request payload
- Verify seat availability
- Check database logs

---

### Issue 4: CORS errors
**Symptoms:** "Access-Control-Allow-Origin" error

**Solution:**
- This shouldn't happen (same domain)
- If occurs, add CORS headers to servlets

---

## ✅ Final Checklist

- [ ] Database connection successful
- [ ] All API endpoints working
- [ ] Movies load from database
- [ ] Categories filter works
- [ ] Search function works
- [ ] Movie details modal opens
- [ ] Seats load correctly
- [ ] Seat selection works
- [ ] Booking saves to database
- [ ] Success modal shows booking code
- [ ] Responsive design works
- [ ] No console errors
- [ ] Performance is good

---

**Jika semua checklist di atas ✅, aplikasi Anda SUDAH DINAMIS dan SIAP DIGUNAKAN! 🎉**
