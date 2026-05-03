package com.civicwatch.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    private static final Pattern USERNAME_PATTERN = Pattern.compile(
            "^[A-Za-z0-9_-]{3,50}$"
    );

    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
            "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z0-9!@#$%^&*()_+=-]{6,50}$"
    );

    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    public static boolean isValidPassword(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }
        return password.length() >= 6 && password.length() <= 50;
    }

    public static boolean isValidPasswordStrength(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }
        return PASSWORD_PATTERN.matcher(password).matches();
    }

    public static boolean isValidFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return false;
        }
        return fullName.trim().length() >= 2 && fullName.trim().length() <= 100;
    }

    public static boolean isValidTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            return false;
        }
        return title.trim().length() >= 5 && title.trim().length() <= 200;
    }

    public static boolean isValidDescription(String description) {
        if (description == null || description.trim().isEmpty()) {
            return false;
        }
        return description.trim().length() >= 10 && description.trim().length() <= 2000;
    }

    public static boolean isValidLocation(String location) {
        if (location == null || location.trim().isEmpty()) {
            return false;
        }
        return location.trim().length() >= 5 && location.trim().length() <= 255;
    }

    public static boolean isValidRole(String role) {
        if (role == null) {
            return false;
        }
        return "RESIDENT".equals(role) || "ADMIN".equals(role);
    }

    public static boolean isValidStatus(String status) {
        if (status == null) {
            return false;
        }
        return "PENDING".equals(status) || "IN_REVIEW".equals(status)
                || "IN_PROGRESS".equals(status) || "RESOLVED".equals(status);
    }

    public static boolean isValidPriority(String priority) {
        if (priority == null) {
            return false;
        }
        return "LOW".equals(priority) || "MEDIUM".equals(priority)
                || "HIGH".equals(priority) || "CRITICAL".equals(priority);
    }

    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.trim()
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\"", "&quot;")
                .replaceAll("'", "&#x27;")
                .replaceAll("/", "&#x2F;");
    }

    public static String sanitizeHtml(String input) {
        if (input == null) {
            return null;
        }
        return input.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    }

    public static boolean isPositiveNumber(String value) {
        try {
            int num = Integer.parseInt(value);
            return num > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean isValidId(String id) {
        try {
            int num = Integer.parseInt(id);
            return num > 0;
        } catch (NumberFormatException | NullPointerException e) {
            return false;
        }
    }

    public static String getDefaultIfEmpty(String value, String defaultValue) {
        return (value == null || value.trim().isEmpty()) ? defaultValue : value.trim();
    }
}
