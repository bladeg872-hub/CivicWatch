package com.civicwatch.service;

import com.civicwatch.dao.ReportDAO;
import com.civicwatch.dao.StatusHistoryDAO;
import com.civicwatch.dao.CategoryDAO;
import com.civicwatch.model.Report;
import com.civicwatch.model.StatusHistory;
import com.civicwatch.model.Category;
import com.civicwatch.util.ValidationUtil;

import java.sql.SQLException;
import java.util.List;

public class ReportService {

    private final ReportDAO reportDAO;
    private final StatusHistoryDAO statusHistoryDAO;
    private final CategoryDAO categoryDAO;

    public ReportService() {
        this.reportDAO = new ReportDAO();
        this.statusHistoryDAO = new StatusHistoryDAO();
        this.categoryDAO = new CategoryDAO();
    }

    public int createReport(int userId, int categoryId, String title, String description,
                        String location, String imagePath, String priority) {
        if (!ValidationUtil.isValidTitle(title)) {
            throw new IllegalArgumentException("Title must be 5-200 characters");
        }
        if (!ValidationUtil.isValidDescription(description)) {
            throw new IllegalArgumentException("Description must be 10-2000 characters");
        }
        if (!ValidationUtil.isValidLocation(location)) {
            throw new IllegalArgumentException("Location must be 5-255 characters");
        }
        if (categoryId <= 0) {
            throw new IllegalArgumentException("Invalid category");
        }

        try {
            Report report = new Report();
            report.setUserId(userId);
            report.setCategoryId(categoryId);
            report.setTitle(ValidationUtil.sanitizeInput(title));
            report.setDescription(ValidationUtil.sanitizeInput(description));
            report.setLocation(ValidationUtil.sanitizeInput(location));
            report.setImagePath(imagePath);
            report.setStatus("PENDING");
            report.setPriority(priority != null ? priority : "MEDIUM");
            report.setAssignedTo(null);

            int reportId = reportDAO.create(report);

            StatusHistory history = new StatusHistory();
            history.setReportId(reportId);
            history.setOldStatus(null);
            history.setNewStatus("PENDING");
            history.setChangedBy(userId);
            history.setComment("Report created");
            statusHistoryDAO.create(history);

            return reportId;
        } catch (SQLException e) {
            throw new RuntimeException("Database error creating report", e);
        }
    }

    public Report getReportById(int id) {
        try {
            return reportDAO.findById(id);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<Report> getReportsByUserId(int userId) {
        try {
            return reportDAO.findByUserId(userId);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<Report> getAllReports(int limit, int offset) {
        try {
            return reportDAO.findAll(limit, offset);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<Report> getReportsByStatus(String status) {
        try {
            return reportDAO.findByStatus(status);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<Report> getReportsByCategoryId(int categoryId) {
        try {
            return reportDAO.findByCategoryId(categoryId);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<Report> searchReports(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllReports(100, 0);
        }
        try {
            return reportDAO.search(keyword.trim());
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean updateReport(Report report) {
        try {
            return reportDAO.update(report);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean updateReportStatus(int reportId, String newStatus, Integer assignedTo, Integer changedBy, String comment) {
        if (!ValidationUtil.isValidStatus(newStatus)) {
            throw new IllegalArgumentException("Invalid status");
        }

        try {
            Report report = reportDAO.findById(reportId);
            if (report == null) {
                return false;
            }

            String oldStatus = report.getStatus();

            if (reportDAO.updateStatus(reportId, newStatus, assignedTo)) {
                StatusHistory history = new StatusHistory();
                history.setReportId(reportId);
                history.setOldStatus(oldStatus);
                history.setNewStatus(newStatus);
                history.setChangedBy(changedBy);
                history.setComment(comment);
                statusHistoryDAO.create(history);
                return true;
            }
            return false;
        } catch (SQLException e) {
            throw new RuntimeException("Database error updating status", e);
        }
    }

    public boolean assignReport(int reportId, Integer assignedTo, Integer assignedBy) {
        try {
            Report report = reportDAO.findById(reportId);
            if (report == null) {
                return false;
            }

            String newStatus = report.isPending() ? "IN_REVIEW" : report.getStatus();

            String comment = "Report assigned to " +
                (assignedTo != null ? "user ID " + assignedTo : "unassigned");

            return updateReportStatus(reportId, newStatus, assignedTo, assignedBy, comment);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public boolean deleteReport(int id) {
        try {
            statusHistoryDAO.deleteByReportId(id);
            return reportDAO.delete(id);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<StatusHistory> getStatusHistory(int reportId) {
        try {
            return statusHistoryDAO.findByReportId(reportId);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public int getTotalReportCount() {
        try {
            return reportDAO.countAll();
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public int getUserReportCount(int userId) {
        try {
            return reportDAO.countByUserId(userId);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public int getReportCountByStatus(String status) {
        try {
            return reportDAO.countByStatus(status);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<Category> getAllCategories() {
        try {
            return categoryDAO.findAll();
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public List<Category> getActiveCategories() {
        try {
            return categoryDAO.findActive();
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }

    public Category getCategoryById(int id) {
        try {
            return categoryDAO.findById(id);
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }
}
