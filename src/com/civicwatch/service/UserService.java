package com.civicwatch.service;

import com.civicwatch.dao.UserDAO;
import com.civicwatch.model.User;
import com.civicwatch.util.ValidationUtil;

import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public int registerUser(String username, String password, String email, String fullName, String role, Integer districtId)
            throws IllegalArgumentException {
        if (!ValidationUtil.isValidUsername(username)) {
            throw new IllegalArgumentException("Invalid username format");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email format");
        }
        if (!ValidationUtil.isValidFullName(fullName)) {
            throw new IllegalArgumentException("Invalid full name");
        }
        if (role != null && !ValidationUtil.isValidRole(role)) {
            throw new IllegalArgumentException("Invalid role");
        }

        try {
            if (userDAO.usernameExists(username)) {
                throw new IllegalArgumentException("Username already exists");
            }
            if (userDAO.emailExists(email)) {
                throw new IllegalArgumentException("Email already exists");
            }

            User user = new User();
            user.setUsername(username.trim());
            user.setPasswordHash(com.civicwatch.util.PasswordHash.hashPassword(password));
            user.setEmail(email.trim().toLowerCase());
            user.setFullName(fullName.trim());
            user.setRole(role != null ? role : "RESIDENT");
            user.setDistrictId(districtId);
            user.setActive(true);

            return userDAO.create(user);
        } catch (SQLException e) {
            throw new RuntimeException("Database error during registration", e);
        }
    }

    public User authenticate(String username, String password) {
        if (username == null || password == null) {
            return null;
        }

        try {
            User user = userDAO.findByUsername(username.trim());
            if (user == null || !user.isActive()) {
                return null;
            }

            String storedHash = user.getPasswordHash();
            if (com.civicwatch.util.PasswordHash.verifyPassword(password, storedHash)) {
                return user;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("Database error during authentication", e);
        }
    }

    public User getUserById(int id) {
        try {
            return userDAO.findById(id);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public User getUserByUsername(String username) {
        try {
            return userDAO.findByUsername(username);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<User> getAllUsers() {
        try {
            return userDAO.findAll();
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<User> getUsersByRole(String role) {
        try {
            return userDAO.findByRole(role);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<User> getActiveUsers() {
        try {
            return userDAO.findActiveUsers();
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean updateUser(User user) {
        try {
            return userDAO.update(user);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        if (!ValidationUtil.isValidPassword(newPassword)) {
            throw new IllegalArgumentException("New password must be at least 6 characters");
        }

        try {
            User user = userDAO.findById(userId);
            if (user == null) {
                return false;
            }

            String storedHash = user.getPasswordHash();
            if (!com.civicwatch.util.PasswordHash.verifyPassword(currentPassword, storedHash)) {
                throw new IllegalArgumentException("Current password is incorrect");
            }

            String newPasswordHash = com.civicwatch.util.PasswordHash.hashPassword(newPassword);
            return userDAO.updatePassword(userId, newPasswordHash);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean resetPassword(int userId, String newPassword) {
        if (!ValidationUtil.isValidPassword(newPassword)) {
            throw new IllegalArgumentException("Invalid password");
        }

        try {
            String newPasswordHash = com.civicwatch.util.PasswordHash.hashPassword(newPassword);
            return userDAO.updatePassword(userId, newPasswordHash);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean deleteUser(int id) {
        try {
            return userDAO.delete(id);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean toggleUserActive(int id, boolean active) {
        try {
            return userDAO.toggleActive(id, active);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean usernameExists(String username) {
        try {
            return userDAO.usernameExists(username);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean emailExists(String email) {
        try {
            return userDAO.emailExists(email);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }
}
