package com.cinemax.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Simple password hashing utility using SHA-256 with salt
 * For production, consider using BCrypt library
 */
public class PasswordUtil {
    
    private static final String HASH_ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Hash a password with a randomly generated salt
     */
    public static String hashPassword(String password) {
        try {
            // Generate random salt
            byte[] salt = generateSalt();
            
            // Hash password with salt
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Combine salt and hash
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
            
            // Encode to Base64
            return Base64.getEncoder().encodeToString(combined);
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Verify a password against a hashed password
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        try {
            // Decode the stored hash
            byte[] combined = Base64.getDecoder().decode(hashedPassword);
            
            // Extract salt
            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);
            
            // Extract hash
            byte[] storedHash = new byte[combined.length - SALT_LENGTH];
            System.arraycopy(combined, SALT_LENGTH, storedHash, 0, storedHash.length);
            
            // Hash the input password with the extracted salt
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt);
            byte[] inputHash = md.digest(password.getBytes());
            
            // Compare hashes
            return MessageDigest.isEqual(storedHash, inputHash);
            
        } catch (Exception e) {
            // If decoding fails or hash format is wrong, might be plain text password
            // For backward compatibility during migration
            return password.equals(hashedPassword);
        }
    }
    
    /**
     * Generate random salt
     */
    private static byte[] generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return salt;
    }
    
    /**
     * Check if a password is already hashed
     */
    public static boolean isHashed(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }
        
        try {
            byte[] decoded = Base64.getDecoder().decode(password);
            // If it's a valid Base64 and has the expected length, it's likely hashed
            return decoded.length > SALT_LENGTH;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}
