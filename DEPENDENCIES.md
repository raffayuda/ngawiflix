# Download Dependencies

## 1. PostgreSQL JDBC Driver

### Cara 1: Manual Download
1. Kunjungi: https://jdbc.postgresql.org/download/
2. Download versi terbaru (misalnya: `postgresql-42.7.1.jar`)
3. Simpan di `src/main/webapp/WEB-INF/lib/`

### Cara 2: Maven Repository
1. Kunjungi: https://mvnrepository.com/artifact/org.postgresql/postgresql
2. Pilih versi terbaru
3. Download JAR file

**Direct Link:**
```
https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.1/postgresql-42.7.1.jar
```

## 2. Gson Library

### Cara 1: Manual Download
1. Kunjungi: https://github.com/google/gson
2. Download release terbaru

### Cara 2: Maven Repository
1. Kunjungi: https://mvnrepository.com/artifact/com.google.code.gson/gson
2. Download JAR file

**Direct Link:**
```
https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar
```

## 3. Servlet API (Opsional)

Jika menggunakan Tomcat, servlet-api sudah include. 
Jika perlu manual, download dari:
```
https://mvnrepository.com/artifact/javax.servlet/javax.servlet-api
```

## Struktur Folder WEB-INF/lib

Setelah download semua, struktur folder harus seperti ini:

```
src/main/webapp/WEB-INF/lib/
├── postgresql-42.7.1.jar
└── gson-2.10.1.jar
```

## Menambahkan ke Eclipse Build Path

1. **Refresh Project**
   - Klik kanan pada project
   - Pilih **Refresh** (F5)

2. **Add to Build Path**
   - Klik kanan pada project
   - Pilih **Build Path** → **Configure Build Path**
   - Tab **Libraries**
   - Klik **Add JARs** (BUKAN Add External JARs)
   - Navigate ke `pemesanan-tikek-bioskop/src/main/webapp/WEB-INF/lib`
   - Pilih semua JAR files
   - Klik **OK**
   - Klik **Apply and Close**

3. **Clean and Build**
   - Menu **Project** → **Clean**
   - Pilih project
   - Klik **Clean**

## Verifikasi

Cek apakah JAR sudah ada di:
- **Package Explorer** → Project → **Referenced Libraries**

Jika sudah ada, compile error akan hilang.

## Troubleshooting

### JAR tidak muncul di Referenced Libraries
- Pastikan JAR ada di folder `WEB-INF/lib`
- Refresh project (F5)
- Restart Eclipse

### Masih ada compile error
- Clean project (Project → Clean)
- Rebuild project
- Restart Eclipse

### ClassNotFoundException saat run
- Pastikan JAR ada di `WEB-INF/lib` (bukan di tempat lain)
- Clean and redeploy ke Tomcat
- Restart Tomcat server
