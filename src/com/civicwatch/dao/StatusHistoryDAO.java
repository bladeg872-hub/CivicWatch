package com.civicwatch.dao;

import com.civicwatch.model.StatusHistory;
import com.civicwatch.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StatusHistoryDAO {

    public int create(StatusHistory statusHistory) throws SQLException {
        String sql = "INSERT INTO status_history (report_id, old_status, new_status, changed_by, comment) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, statusHistory.getReportId());
            stmt.setString(2, statusHistory.getOldStatus());
            stmt.setString(3, statusHistory.getNewStatus());
            stmt.setInt(4, statusHistory.getChangedBy());
            stmt.setString(5, statusHistory.getComment());
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public StatusHistory findById(int id) throws SQLException {
        String sql = "SELECT sh.*, u.full_name as changed_by_name FROM status_history sh " +
                   "LEFT JOIN user u ON sh.changed_by = u.id WHERE sh.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToStatusHistory(rs);
                }
            }
        }
        return null;
    }

    public List<StatusHistory> findByReportId(int reportId) throws SQLException {
        String sql = "SELECT sh.*, u.full_name as changed_by_name FROM status_history sh " +
                   "LEFT JOIN user u ON sh.changed_by = u.id WHERE sh.report_id = ? ORDER BY sh.created_at DESC";
        List<StatusHistory> historyList = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    historyList.add(mapResultSetToStatusHistory(rs));
                }
            }
        }
        return historyList;
    }

    public StatusHistory findLatestByReportId(int reportId) throws SQLException {
        String sql = "SELECT sh.*, u.full_name as changed_by_name FROM status_history sh " +
                   "LEFT JOIN user u ON sh.changed_by = u.id WHERE sh.report_id = ? ORDER BY sh.created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToStatusHistory(rs);
                }
            }
        }
        return null;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM status_history WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteByReportId(int reportId) throws SQLException {
        String sql = "DELETE FROM status_history WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            return stmt.executeUpdate() > 0;
        }
    }

    private StatusHistory mapResultSetToStatusHistory(ResultSet rs) throws SQLException {
        StatusHistory statusHistory = new StatusHistory();
        statusHistory.setId(rs.getInt("id"));
        statusHistory.setReportId(rs.getInt("report_id"));
        statusHistory.setOldStatus(rs.getString("old_status"));
        statusHistory.setNewStatus(rs.getString("new_status"));
        statusHistory.setChangedBy(rs.getInt("changed_by"));
        statusHistory.setComment(rs.getString("comment"));
        statusHistory.setCreatedAt(rs.getTimestamp("created_at"));
        String changedByName = rs.getString("changed_by_name");
        if (changedByName != null) {
            statusHistory.setChangedByName(changedByName);
        }
        return statusHistory;
    }
}
