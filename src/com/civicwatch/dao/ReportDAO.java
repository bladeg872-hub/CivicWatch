package com.civicwatch.dao;

import com.civicwatch.model.Report;
import com.civicwatch.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    public int create(Report report) throws SQLException {
        String sql = "INSERT INTO report (user_id, category_id, title, description, location, " +
                     "latitude, longitude, image_path, status, priority, assigned_to) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, report.getUserId());
            stmt.setInt(2, report.getCategoryId());
            stmt.setString(3, report.getTitle());
            stmt.setString(4, report.getDescription());
            stmt.setString(5, report.getLocation());
            if (report.getLatitude() != null) {
                stmt.setBigDecimal(6, report.getLatitude());
            } else {
                stmt.setNull(6, java.sql.Types.DECIMAL);
            }
            if (report.getLongitude() != null) {
                stmt.setBigDecimal(7, report.getLongitude());
            } else {
                stmt.setNull(7, java.sql.Types.DECIMAL);
            }
            if (report.getImagePath() != null) {
                stmt.setString(8, report.getImagePath());
            } else {
                stmt.setNull(8, java.sql.Types.VARCHAR);
            }
            stmt.setString(9, report.getStatus() != null ? report.getStatus() : "PENDING");
            stmt.setString(10, report.getPriority() != null ? report.getPriority() : "MEDIUM");
            if (report.getAssignedTo() != null) {
                stmt.setInt(11, report.getAssignedTo());
            } else {
                stmt.setNull(11, java.sql.Types.INTEGER);
            }
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public Report findById(int id) throws SQLException {
        String sql = "SELECT r.*, c.name as category_name, u.full_name as user_full_name, " +
                   "a.full_name as assigned_to_name FROM report r " +
                   "LEFT JOIN category c ON r.category_id = c.id " +
                   "LEFT JOIN user u ON r.user_id = u.id " +
                   "LEFT JOIN user a ON r.assigned_to = a.id WHERE r.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReport(rs);
                }
            }
        }
        return null;
    }

    public List<Report> findByUserId(int userId) throws SQLException {
        String sql = "SELECT r.*, c.name as category_name, u.full_name as user_full_name, " +
                   "a.full_name as assigned_to_name FROM report r " +
                   "LEFT JOIN category c ON r.category_id = c.id " +
                   "LEFT JOIN user u ON r.user_id = u.id " +
                   "LEFT JOIN user a ON r.assigned_to = a.id WHERE r.user_id = ? ORDER BY r.created_at DESC";
        List<Report> reports = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
        }
        return reports;
    }

    public List<Report> findAll(int limit, int offset) throws SQLException {
        String sql = "SELECT r.*, c.name as category_name, u.full_name as user_full_name, " +
                   "a.full_name as assigned_to_name FROM report r " +
                   "LEFT JOIN category c ON r.category_id = c.id " +
                   "LEFT JOIN user u ON r.user_id = u.id " +
                   "LEFT JOIN user a ON r.assigned_to = a.id ORDER BY r.created_at DESC LIMIT ? OFFSET ?";
        List<Report> reports = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
        }
        return reports;
    }

    public List<Report> findByStatus(String status) throws SQLException {
        String sql = "SELECT r.*, c.name as category_name, u.full_name as user_full_name, " +
                   "a.full_name as assigned_to_name FROM report r " +
                   "LEFT JOIN category c ON r.category_id = c.id " +
                   "LEFT JOIN user u ON r.user_id = u.id " +
                   "LEFT JOIN user a ON r.assigned_to = a.id WHERE r.status = ? ORDER BY r.created_at DESC";
        List<Report> reports = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
        }
        return reports;
    }

    public List<Report> findByCategoryId(int categoryId) throws SQLException {
        String sql = "SELECT r.*, c.name as category_name, u.full_name as user_full_name, " +
                   "a.full_name as assigned_to_name FROM report r " +
                   "LEFT JOIN category c ON r.category_id = c.id " +
                   "LEFT JOIN user u ON r.user_id = u.id " +
                   "LEFT JOIN user a ON r.assigned_to = a.id WHERE r.category_id = ? ORDER BY r.created_at DESC";
        List<Report> reports = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
        }
        return reports;
    }

    public List<Report> search(String keyword) throws SQLException {
        String sql = "SELECT r.*, c.name as category_name, u.full_name as user_full_name, " +
                   "a.full_name as assigned_to_name FROM report r " +
                   "LEFT JOIN category c ON r.category_id = c.id " +
                   "LEFT JOIN user u ON r.user_id = u.id " +
                   "LEFT JOIN user a ON r.assigned_to = a.id " +
                   "WHERE r.title LIKE ? OR r.description LIKE ? OR r.location LIKE ? ORDER BY r.created_at DESC";
        List<Report> reports = new ArrayList<>();
        String searchTerm = "%" + keyword + "%";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
        }
        return reports;
    }

    public boolean update(Report report) throws SQLException {
        String sql = "UPDATE report SET category_id = ?, title = ?, description = ?, location = ?, " +
                   "latitude = ?, longitude = ?, image_path = ?, priority = ?, assigned_to = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, report.getCategoryId());
            stmt.setString(2, report.getTitle());
            stmt.setString(3, report.getDescription());
            stmt.setString(4, report.getLocation());
            if (report.getLatitude() != null) {
                stmt.setBigDecimal(5, report.getLatitude());
            } else {
                stmt.setNull(5, java.sql.Types.DECIMAL);
            }
            if (report.getLongitude() != null) {
                stmt.setBigDecimal(6, report.getLongitude());
            } else {
                stmt.setNull(6, java.sql.Types.DECIMAL);
            }
            if (report.getImagePath() != null) {
                stmt.setString(7, report.getImagePath());
            } else {
                stmt.setNull(7, java.sql.Types.VARCHAR);
            }
            stmt.setString(8, report.getPriority());
            if (report.getAssignedTo() != null) {
                stmt.setInt(9, report.getAssignedTo());
            } else {
                stmt.setNull(9, java.sql.Types.INTEGER);
            }
            stmt.setInt(10, report.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int reportId, String newStatus, Integer assignedTo) throws SQLException {
        String sql = "UPDATE report SET status = ?, assigned_to = ?, resolved_at = " +
                   "(CASE WHEN ? = 'RESOLVED' THEN CURRENT_TIMESTAMP ELSE NULL END) WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            if (assignedTo != null) {
                stmt.setInt(2, assignedTo);
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setString(3, newStatus);
            stmt.setInt(4, reportId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM report WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM report";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int countByUserId(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM report WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM report WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private Report mapResultSetToReport(ResultSet rs) throws SQLException {
        Report report = new Report();
        report.setId(rs.getInt("id"));
        report.setUserId(rs.getInt("user_id"));
        report.setCategoryId(rs.getInt("category_id"));
        report.setTitle(rs.getString("title"));
        report.setDescription(rs.getString("description"));
        report.setLocation(rs.getString("location"));
        report.setLatitude(rs.getBigDecimal("latitude"));
        report.setLongitude(rs.getBigDecimal("longitude"));
        report.setImagePath(rs.getString("image_path"));
        report.setStatus(rs.getString("status"));
        report.setPriority(rs.getString("priority"));
        int assignedTo = rs.getInt("assigned_to");
        if (!rs.wasNull()) {
            report.setAssignedTo(assignedTo);
        }
        report.setCreatedAt(rs.getTimestamp("created_at"));
        report.setUpdatedAt(rs.getTimestamp("updated_at"));
        report.setResolvedAt(rs.getTimestamp("resolved_at"));
        report.setCategoryName(rs.getString("category_name"));
        report.setUserFullName(rs.getString("user_full_name"));
        String assignedToName = rs.getString("assigned_to_name");
        if (assignedToName != null) {
            report.setAssignedToName(assignedToName);
        }
        return report;
    }
}
