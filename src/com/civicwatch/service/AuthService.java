package com.civicwatch.service;

import com.civicwatch.model.User;
import com.civicwatch.util.PasswordHash;

public class AuthService {

    private final UserService userService;

    public AuthService() {
        this.userService = new UserService();
    }

    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }

        User user = userService.authenticate(username, password);
        if (user == null) {
            throw new IllegalArgumentException("Invalid username or password");
        }

        return user;
    }

    public int register(String username, String password, String email, String fullName) {
        return register(username, password, email, fullName, null, null);
    }

    public int register(String username, String password, String email, String fullName, String role, Integer districtId) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required");
        }

        // UserService performs password validation + hashing.
        return userService.registerUser(username, password, email, fullName, role, districtId);
    }

    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        return userService.changePassword(userId, currentPassword, newPassword);
    }

    public boolean resetPassword(int userId, String newPassword) {
        return userService.resetPassword(userId, newPassword);
    }

    public User getUserById(int userId) {
        return userService.getUserById(userId);
    }

    public User getUserByUsername(String username) {
        return userService.getUserByUsername(username);
    }

    public boolean isAuthorized(User user, String requiredRole) {
        if (user == null) {
            return false;
        }

        String userRole = user.getRole();
        if (userRole == null) {
            return false;
        }

        switch (requiredRole) {
            case "ADMIN":
                return "ADMIN".equals(userRole);
            case "RESIDENT":
                return "ADMIN".equals(userRole) || "RESIDENT".equals(userRole);
            default:
                return false;
        }
    }

    public boolean hasRole(User user, String role) {
        if (user == null || role == null) {
            return false;
        }
        return role.equals(user.getRole());
    }

    public boolean isAdmin(User user) {
        return hasRole(user, "ADMIN");
    }


}
