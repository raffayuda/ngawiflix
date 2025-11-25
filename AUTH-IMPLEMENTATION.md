# Authentication & Authorization System

## Overview
Sistem autentikasi dan otorisasi dengan 2 role: **User** dan **Admin**

## Features Implemented

### 1. Authentication Features
- ✅ **Login** - User dapat login dengan username/email dan password
- ✅ **Register** - Pendaftaran user baru
- ✅ **Logout** - Keluar dari sistem
- ✅ **Session Management** - Auto-login jika session masih aktif

### 2. Role-Based Access Control

#### User Role (Default)
- ✅ Browse movies
- ✅ View schedules
- ✅ Book tickets (harus login)
- ❌ Tidak bisa akses admin panel

#### Admin Role
- ✅ Semua fitur User
- ✅ Akses ke Admin Panel
- ✅ CRUD Movies (struktur sudah disiapkan)
- ✅ CRUD Schedules (struktur sudah disiapkan)
- ✅ CRUD Theaters (struktur sudah disiapkan)
- ✅ CRUD Categories (struktur sudah disiapkan)

## Database Changes

### Schema Updates
File: `database/schema.sql`

```sql
-- Users table updated with role field
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

-- Default admin user
INSERT INTO users (username, email, password, full_name, phone, role) VALUES
('admin', 'admin@cinemax.com', 'admin123', 'Administrator', '081234567890', 'admin');
```

## Backend Implementation

### 1. User Model
**File:** `src/main/java/com/cinemax/model/User.java`

Properties:
- userId
- username
- email
- password
- fullName
- phone
- role (user/admin)
- isActive
- createdAt
- updatedAt

Helper Methods:
- `isAdmin()` - Check if user is admin
- `isUser()` - Check if user is regular user

### 2. User DAO
**File:** `src/main/java/com/cinemax/dao/UserDAO.java`

Methods:
- `login(username, password)` - Authenticate user
- `register(User)` - Create new user
- `usernameExists(username)` - Check username availability
- `emailExists(email)` - Check email availability
- `getUserById(userId)` - Get user by ID
- `getAllUsers()` - Get all users (admin only)
- `updateUser(User)` - Update user profile
- `updatePassword(userId, newPassword)` - Change password
- `deleteUser(userId)` - Soft delete user

### 3. Auth Servlet
**File:** `src/main/java/com/cinemax/servlet/AuthServlet.java`

Endpoints:
- **POST** `/api/auth?action=login` - Login
- **POST** `/api/auth?action=register` - Register
- **POST** `/api/auth?action=logout` - Logout
- **GET** `/api/auth?action=check` - Check session

## Frontend Implementation

### 1. Index.jsp Updates

#### Navigation Bar
- Tombol "Masuk" untuk user yang belum login
- User menu dropdown untuk user yang sudah login:
  - Profile
  - My Tickets
  - Admin Panel (hanya untuk admin)
  - Logout

#### Login/Register Modal
- Modal responsif dengan 2 mode: Login dan Register
- Form validation
- Toggle antara login dan register
- Auto close setelah berhasil login/register

#### Auth State Management (Alpine.js)
```javascript
// State variables
currentUser: null,          // Data user yang login
showLoginModal: false,      // Toggle modal login/register
loginMode: 'login',         // 'login' or 'register'

// Auth functions
checkSession()             // Check if user logged in
login(formData)           // Login user
register(formData)        // Register new user
logout()                  // Logout user
```

#### Booking Protection
Sebelum confirm booking, sistem akan:
1. Check apakah user sudah login
2. Jika belum login → tampilkan login modal
3. Jika sudah login → lanjut proses booking

### 2. Admin Panel
**File:** `src/main/webapp/admin.jsp`

Features:
- Sidebar navigation
- Tab-based content management
- Protected route (hanya admin yang bisa akses)
- CRUD interface untuk:
  - Movies
  - Schedules
  - Theaters
  - Categories

## Security Notes

⚠️ **PENTING - Untuk Production:**

1. **Password Hashing**: 
   - Saat ini password disimpan plain text
   - Harus di-hash menggunakan BCrypt atau algoritma yang aman
   - Update `UserDAO.java` dan `AuthServlet.java`

2. **SQL Injection**:
   - Sudah menggunakan PreparedStatement ✅
   
3. **Session Security**:
   - Session timeout: 1 jam
   - Gunakan HTTPS di production
   - Tambahkan CSRF protection

4. **Input Validation**:
   - Frontend validation sudah ada ✅
   - Perlu backend validation tambahan

## Testing Guide

### Default Admin Account
```
Username: admin
Email: admin@cinemax.com
Password: admin123
```

### Test Scenarios

#### 1. Login Test
1. Buka website
2. Klik tombol "Masuk"
3. Masukkan kredensial admin
4. Verify: Tombol berubah jadi user menu

#### 2. Register Test
1. Klik "Masuk"
2. Klik "Daftar Sekarang"
3. Isi form registrasi
4. Submit
5. Verify: Auto-login dan modal tertutup

#### 3. Booking Protection Test
1. Logout (jika sudah login)
2. Pilih film
3. Pilih jadwal dan kursi
4. Klik "Konfirmasi Pesanan"
5. Verify: Modal login muncul

#### 4. Admin Access Test
1. Login sebagai admin
2. Klik user menu
3. Verify: Ada menu "Panel Admin"
4. Klik "Panel Admin"
5. Verify: Redirect ke admin.jsp

#### 5. User Access Test
1. Register/Login sebagai user biasa
2. Klik user menu
3. Verify: Tidak ada menu "Panel Admin"
4. Coba akses admin.jsp langsung
5. Verify: Redirect ke index.jsp

## API Endpoints Summary

### Authentication API

#### Login
```
POST /api/auth?action=login
Parameters:
- username: string (username atau email)
- password: string

Response:
{
    "success": true,
    "message": "Login berhasil",
    "user": {
        "userId": 1,
        "username": "admin",
        "email": "admin@cinemax.com",
        "fullName": "Administrator",
        "phone": "081234567890",
        "role": "admin"
    }
}
```

#### Register
```
POST /api/auth?action=register
Parameters:
- username: string
- email: string
- password: string
- fullName: string (optional)
- phone: string (optional)

Response:
{
    "success": true,
    "message": "Registrasi berhasil",
    "user": { ... }
}
```

#### Logout
```
POST /api/auth?action=logout

Response:
{
    "success": true,
    "message": "Logout berhasil"
}
```

#### Check Session
```
GET /api/auth?action=check

Response:
{
    "success": true,
    "loggedIn": true,
    "user": { ... }
}
```

## Next Steps

### Immediate (Critical)
1. ✅ Implement password hashing
2. ✅ Add server-side validation
3. ✅ Implement CRUD for Movies
4. ✅ Implement CRUD for Schedules
5. ✅ Implement CRUD for Theaters
6. ✅ Implement CRUD for Categories

### Short Term
1. Add "Forgot Password" feature
2. Add email verification
3. Add user profile page
4. Add "My Tickets" page
5. Add booking history

### Long Term
1. Implement OAuth (Google, Facebook login)
2. Add 2FA (Two-Factor Authentication)
3. Add user roles management
4. Add audit logs
5. Add admin dashboard with statistics

## File Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── cinemax/
│   │           ├── dao/
│   │           │   └── UserDAO.java          ✅ NEW
│   │           ├── model/
│   │           │   └── User.java             ✅ NEW
│   │           └── servlet/
│   │               └── AuthServlet.java      ✅ NEW
│   └── webapp/
│       ├── index.jsp                         ✅ UPDATED
│       └── admin.jsp                         ✅ NEW
└── database/
    └── schema.sql                            ✅ UPDATED
```

## Troubleshooting

### Issue: Login gagal
- Check database connection
- Verify username/password benar
- Check users table di database
- Check console untuk error

### Issue: Session tidak persist
- Check session timeout configuration
- Clear browser cookies
- Check servlet session management

### Issue: Admin panel tidak bisa diakses
- Verify role di database adalah 'admin'
- Check session attribute 'user'
- Check admin.jsp page directive

### Issue: Modal login tidak muncul
- Check Alpine.js loaded
- Check showLoginModal variable
- Check browser console untuk error

## License & Credits

Created for CinemaX Ticket Booking System
Date: November 2, 2025
