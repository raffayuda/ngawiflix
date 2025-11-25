# 🎬 CinemaX - Quick Start Guide

## Langkah-langkah Setup (Sederhana)

### 1️⃣ Install PostgreSQL & pgAdmin
1. Download PostgreSQL: https://www.postgresql.org/download/windows/
2. Install dengan pengaturan default
3. **CATAT PASSWORD** yang Anda buat untuk user `postgres`
4. pgAdmin akan otomatis ter-install

### 2️⃣ Setup Database

1. **Buka pgAdmin**
2. **Create Database:**
   - Klik kanan "Databases" → Create → Database
   - Name: `cinemax_db`
   - Owner: `postgres`
   - Save

3. **Import Schema:**
   - Klik kanan database `cinemax_db` → Query Tool
   - Buka file `database/schema.sql` dengan notepad
   - Copy SEMUA isi file
   - Paste di Query Tool
   - Klik Execute (F5)
   - ✅ Seharusnya muncul "Query returned successfully"

### 3️⃣ Download Dependencies

Download 2 file JAR ini:

**1. PostgreSQL JDBC Driver:**
```
https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.1/postgresql-42.7.1.jar
```

**2. Gson Library:**
```
https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar
```

**Simpan kedua file di:**
```
src/main/webapp/WEB-INF/lib/
```

### 4️⃣ Konfigurasi Database Connection

Edit file: `src/main/java/com/cinemax/util/DatabaseConnection.java`

Ganti password di baris ini:
```java
private static final String PASSWORD = "admin"; // <-- GANTI dengan password PostgreSQL Anda
```

### 5️⃣ Add JAR to Eclipse

1. Klik kanan project → **Refresh** (F5)
2. Klik kanan project → **Build Path** → **Configure Build Path**
3. Tab **Libraries** → **Add JARs**
4. Browse ke `pemesanan-tikek-bioskop/src/main/webapp/WEB-INF/lib`
5. Pilih KEDUA file JAR
6. **OK** → **Apply and Close**

### 6️⃣ Clean & Run

1. **Project** → **Clean** → Pilih project → **Clean**
2. Klik kanan project → **Run As** → **Run on Server**
3. Pilih Tomcat Server → **Finish**

### 7️⃣ Test Connection

Buka browser:
```
http://localhost:8080/pemesanan-tikek-bioskop/test-connection.jsp
```

- ✅ Jika **"Database Connected Successfully!"** → SUKSES! Lanjut ke langkah 8
- ❌ Jika error → Lihat troubleshooting di bawah

### 8️⃣ Buka Aplikasi

```
http://localhost:8080/pemesanan-tikek-bioskop/
```

🎉 **Selamat! Aplikasi sudah berjalan!**

---

## 🔧 Troubleshooting

### Error: "ClassNotFoundException: org.postgresql.Driver"
✅ **Solusi:**
- Pastikan `postgresql-42.7.1.jar` ada di `WEB-INF/lib`
- Refresh project (F5)
- Clean project (Project → Clean)
- Restart Eclipse

### Error: "Connection refused"
✅ **Solusi:**
- Buka Services (Windows) → cari "postgresql"
- Klik kanan → Start
- Tunggu sampai status "Running"

### Error: "Password authentication failed"
✅ **Solusi:**
- Buka `DatabaseConnection.java`
- Pastikan password sama dengan yang Anda buat saat install PostgreSQL

### Error: "Database cinemax_db does not exist"
✅ **Solusi:**
- Buka pgAdmin
- Create database `cinemax_db`
- Import `schema.sql`

### Compile Error pada Servlet files
✅ **Solusi:**
- Pastikan kedua JAR sudah di-add ke Build Path
- Clean project
- Restart Eclipse

---

## 📁 Struktur File Penting

```
pemesanan-tikek-bioskop/
│
├── database/
│   ├── schema.sql          ⭐ IMPORT INI KE pgAdmin
│   └── queries.sql         (optional - untuk query testing)
│
├── src/main/
│   ├── java/com/cinemax/
│   │   ├── model/          (Java classes untuk data)
│   │   ├── dao/            (Database operations)
│   │   ├── servlet/        (API endpoints)
│   │   └── util/
│   │       └── DatabaseConnection.java  ⭐ EDIT PASSWORD DI SINI
│   │
│   └── webapp/
│       ├── index.jsp       ⭐ HALAMAN UTAMA
│       ├── test-connection.jsp  ⭐ TEST DATABASE
│       └── WEB-INF/
│           └── lib/        ⭐ TARUH JAR FILES DI SINI
│               ├── postgresql-42.7.1.jar
│               └── gson-2.10.1.jar
│
├── README.md               (Dokumentasi lengkap)
├── DEPENDENCIES.md         (Guide download JAR)
└── QUICKSTART.md          ⭐ FILE INI
```

---

## 🎯 Checklist Setup

- [ ] PostgreSQL installed dan running
- [ ] Database `cinemax_db` created
- [ ] File `schema.sql` sudah di-import
- [ ] Password di `DatabaseConnection.java` sudah diganti
- [ ] File `postgresql-42.7.1.jar` ada di `WEB-INF/lib`
- [ ] File `gson-2.10.1.jar` ada di `WEB-INF/lib`
- [ ] Kedua JAR sudah di-add ke Build Path
- [ ] Project sudah di-clean
- [ ] Test connection berhasil (test-connection.jsp)
- [ ] Aplikasi berjalan di browser

---

## 🌟 Fitur Aplikasi

✅ Hero carousel dengan film unggulan
✅ Daftar film dari database PostgreSQL
✅ Filter berdasarkan kategori
✅ Search film
✅ Detail film dengan jadwal tayang
✅ Pemilihan kursi interaktif
✅ Booking tiket online
✅ Responsive design (mobile & desktop)
✅ Modern UI dengan Tailwind CSS
✅ Interactive dengan Alpine.js

---

## 📞 Bantuan

Jika masih ada masalah, cek:
1. README.md - Dokumentasi lengkap
2. DEPENDENCIES.md - Cara download dependencies
3. test-connection.jsp - Test database connection

---

**Happy Coding! 🚀**
