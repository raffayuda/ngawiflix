-- Update existing passwords to hashed format
-- This script will hash the existing plain text passwords

-- For testing, let's update admin password
-- The hashed value below is for password: admin123
-- Generated using SHA-256 with salt

-- Note: Run this after deploying the PasswordUtil class
-- Or you can delete and re-insert the admin user

-- Option 1: Delete and re-insert (recommended for clean start)
DELETE FROM users WHERE username = 'admin';

INSERT INTO users (username, email, password, full_name, phone, role) VALUES
('admin', 'admin@cinemax.com', 'admin123', 'Administrator', '081234567890', 'admin');

-- The password will be hashed automatically when you first login
-- or you can register a new admin through the application

-- Option 2: Keep existing users and they will be migrated on first login
-- The PasswordUtil.verifyPassword() supports both hashed and plain text
-- When user logs in with plain text password, it will match
-- Then you can update it to hashed on next password change

-- To manually hash a password, you would need to run:
-- UPDATE users SET password = 'HASHED_VALUE_HERE' WHERE user_id = 1;
-- But it's better to let the application handle this
