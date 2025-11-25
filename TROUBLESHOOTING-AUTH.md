# Troubleshooting Login & Register Issues

## Masalah yang Ditemukan

### 1. ❌ Error 404 - `/api/auth:1` not found
**Penyebab**: Endpoint servlet tidak terdaftar atau aplikasi belum di-deploy ulang

**Solusi**:
1. **Clean & Rebuild Project**:
   ```bash
   # Di Eclipse/STS
   Project → Clean → Clean All Projects
   Project → Build Project
   ```

2. **Restart Server**:
   - Stop Tomcat server
   - Clean Tomcat work directory
   - Start server lagi

3. **Verify Deployment**:
   - Pastikan file `.class` ter-generate di folder `target/classes`
   - Check apakah `AuthServlet.class` ada di:
     ```
     target/classes/com/cinemax/servlet/AuthServlet.class
     ```

4. **Test Endpoint**:
   - Buka browser: `http://localhost:8080/pemesanan-tikek-bioskop/api/test`
   - Harus return: `{"success": true, "message": "API is working!"}`
   - Jika berhasil, test: `http://localhost:8080/pemesanan-tikek-bioskop/api/auth?action=check`

### 2. ❌ SyntaxError: Unexpected token '<'
**Penyebab**: Server mengembalikan HTML error page, bukan JSON

**Solusi**:
- Ini terjadi karena servlet tidak ditemukan (error 404)
- Fix error 404 terlebih dahulu
- Check console server untuk error stack trace

### 3. ✅ Password Hashing - FIXED!
**Implementasi**:
- ✅ Created `PasswordUtil.java` - SHA-256 with salt
- ✅ Updated `UserDAO.login()` - Support hashed & plain text
- ✅ Updated `UserDAO.register()` - Auto hash new passwords
- ✅ Backward compatible - Old plain text passwords still work

## Step-by-Step Fix

### Step 1: Verify Database
```sql
-- Check if users table exists
SELECT * FROM users;

-- Should show admin user
-- If not, run schema.sql again
```

### Step 2: Clean & Build
1. Right-click project → **Maven** → **Update Project**
2. Check "Force Update of Snapshots/Releases"
3. Click OK
4. **Project** → **Clean**
5. **Project** → **Build All**

### Step 3: Deploy to Tomcat
1. Right-click project → **Run As** → **Run on Server**
2. Or manually:
   - Right-click server → **Add and Remove**
   - Add your project
   - Click **Finish**

### Step 4: Check Server Console
Look for these lines:
```
AuthServlet - POST request received
Action: login
Login attempt - Username: admin
Login result - User found: true
Response: {"success":true,"message":"Login berhasil",...}
```

### Step 5: Test in Browser

#### Test 1: Server is running
```
URL: http://localhost:8080/pemesanan-tikek-bioskop/
Expected: Should show CinemaX homepage
```

#### Test 2: Test endpoint
```
URL: http://localhost:8080/pemesanan-tikek-bioskop/api/test
Expected: {"success": true, "message": "API is working!"}
```

#### Test 3: Check session
```
URL: http://localhost:8080/pemesanan-tikek-bioskop/api/auth?action=check
Expected: {"success":true,"loggedIn":false,"user":null}
```

#### Test 4: Login via Browser Console
```javascript
// Open browser console (F12)
fetch('/pemesanan-tikek-bioskop/api/auth', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
        action: 'login',
        username: 'admin',
        password: 'admin123'
    })
})
.then(r => r.json())
.then(data => console.log(data));
```

Expected Response:
```json
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

## Common Issues

### Issue: "Class not found" in server console
**Fix**:
1. Check Maven dependencies
2. Run: Maven → Update Project
3. Rebuild project

### Issue: "Cannot find symbol: Gson"
**Fix**:
1. Check `pom.xml` has gson dependency
2. Maven → Update Project
3. Rebuild

### Issue: "jakarta.servlet cannot be resolved"
**Fix**:
1. Check Tomcat version (need 10+ for Jakarta)
2. Check pom.xml has jakarta.servlet-api
3. Server Runtime: Add Tomcat 10

### Issue: Login form submission but no response
**Fix**:
1. Open browser DevTools (F12) → Network tab
2. Try login again
3. Check the request to `/api/auth`
4. Look at:
   - Status Code (should be 200)
   - Response body (should be JSON)
   - Request payload (should have username, password, action)

### Issue: Password in database is plain text
**Solution**:
The system now supports BOTH:
- ✅ Plain text passwords (for existing data)
- ✅ Hashed passwords (for new registrations)

When you register NEW users, passwords will be hashed automatically.
Old users with plain text passwords can still login (backward compatible).

To migrate existing passwords:
1. Users login normally with plain text password
2. Ask them to change password
3. Or delete old users and re-register

## Files Modified/Created

### Created:
1. ✅ `PasswordUtil.java` - Password hashing utility
2. ✅ `TestServlet.java` - For testing API endpoints
3. ✅ `update-passwords.sql` - Database migration script

### Modified:
1. ✅ `UserDAO.java` - Added password hashing
2. ✅ `AuthServlet.java` - Added logging for debugging

## Next Steps After Fix

1. **Test Login**:
   - Username: `admin`
   - Password: `admin123`

2. **Test Register**:
   - Create new user
   - Password will be hashed automatically

3. **Check Database**:
   ```sql
   SELECT username, password, role FROM users;
   ```
   - New users should have Base64 encoded password (hashed)
   - Old users might still have plain text (will migrate on password change)

4. **Production Deployment**:
   - Consider using BCrypt instead of SHA-256
   - Add rate limiting for login attempts
   - Add CAPTCHA for security
   - Use HTTPS

## Support

If issues persist:
1. Check server console for errors
2. Check browser console for JavaScript errors
3. Verify database connection
4. Ensure Tomcat 10+ is being used
5. Check if port 8080 is available

## Testing Checklist

- [ ] Server starts without errors
- [ ] `/api/test` returns JSON
- [ ] `/api/auth?action=check` returns JSON
- [ ] Can login with admin credentials
- [ ] Can register new user
- [ ] New user password is hashed in database
- [ ] Can logout
- [ ] Session persists across page refresh
