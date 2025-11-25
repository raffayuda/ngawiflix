# Quick Start - Authentication System

## 🚀 Fitur yang Telah Ditambahkan

### ✅ Login & Register System
- Modal login/register yang muncul saat:
  - Klik tombol "Masuk" di navbar
  - Klik tombol "Konfirmasi Pesanan" (jika belum login)
- Form validasi lengkap
- Auto-login setelah registrasi

### ✅ Role-Based Access
- **User Role**: Bisa browse dan booking tiket
- **Admin Role**: Bisa akses admin panel + booking tiket

### ✅ Protected Features
- Booking tiket memerlukan login
- Admin panel hanya untuk admin

## 📁 File yang Dibuat/Diubah

### Backend
1. `src/main/java/com/cinemax/model/User.java` ✅ NEW
2. `src/main/java/com/cinemax/dao/UserDAO.java` ✅ NEW
3. `src/main/java/com/cinemax/servlet/AuthServlet.java` ✅ NEW

### Frontend
4. `src/main/webapp/index.jsp` ✅ UPDATED
   - Navbar dengan user menu
   - Modal login/register
   - Auth functions (checkSession, login, register, logout)
   - Booking protection

5. `src/main/webapp/admin.jsp` ✅ NEW
   - Admin panel dengan sidebar
   - Tabs untuk Movies, Schedules, Theaters, Categories
   - Protected route (admin only)

### Database
6. `database/schema.sql` ✅ UPDATED
   - Tambah field `role` dan `is_active` di table users
   - Insert default admin user

## 🔐 Default Admin Account

```
Username: admin
Email: admin@cinemax.com
Password: admin123
```

## 🎯 Cara Menggunakan

### Untuk User Biasa:
1. Klik tombol "Masuk" di navbar
2. Klik "Daftar Sekarang"
3. Isi form registrasi
4. Otomatis login dan bisa booking tiket

### Untuk Admin:
1. Login dengan akun admin (lihat di atas)
2. Klik user menu di navbar
3. Klik "Panel Admin"
4. Akses CRUD untuk Movies, Schedules, Theaters, Categories

## ⚙️ Next Steps

Admin panel sudah siap dengan struktur UI, tetapi CRUD functionality masih perlu diimplementasi:

1. **Movies CRUD** - Tambah, edit, hapus film
2. **Schedules CRUD** - Atur jadwal tayang
3. **Theaters CRUD** - Kelola teater/studio
4. **Categories CRUD** - Kelola kategori film

## 📝 Notes

⚠️ **IMPORTANT**: 
- Password saat ini disimpan sebagai plain text
- Untuk production, harus di-hash dengan BCrypt
- Dokumentasi lengkap ada di `AUTH-IMPLEMENTATION.md`

## 🐛 Testing

Jalankan database schema dulu:
```bash
psql -U postgres -d cinemax -f database/schema.sql
```

Lalu test:
1. Register user baru
2. Login dengan user tersebut
3. Logout dan login dengan admin
4. Akses admin panel
5. Coba booking tiket (harus login dulu)
