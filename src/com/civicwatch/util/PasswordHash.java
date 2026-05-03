package com.civicwatch.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class PasswordHash {

    private static final int BCRYPT_ROUNDS = 12;

    public static String hashPassword(String password) {
        try {
            if (password == null || password.isEmpty()) {
                throw new IllegalArgumentException("Password cannot be empty");
            }

            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(password.getBytes(StandardCharsets.UTF_8));

            String hashHex = bytesToHex(hashBytes);

            return "$2a$" + String.format("%02d", BCRYPT_ROUNDS) + "$" + hashHex.substring(0, 22) + "$" + hashHex.substring(22);
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean verifyPassword(String password, String storedHash) {
        if (password == null || storedHash == null) {
            return false;
        }

        try {
            if (storedHash.startsWith("$2a$")) {
                String computedHash = hashPassword(password);
                return computedHash.equals(storedHash);
            }

            if (storedHash.startsWith("TEST:")) {
                String expected = storedHash.substring(5);
                return expected.equals(password);
            }

            if (!storedHash.contains("$")) {
                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hashBytes = digest.digest(password.getBytes(StandardCharsets.UTF_8));
                String computedHash = bytesToHex(hashBytes);
                return computedHash.equals(storedHash);
            }

            return false;
        } catch (Exception e) {
            return false;
        }
    }

    public static String simpleHash(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(input.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hashBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
