package com.civicwatch.controller;

import com.civicwatch.model.User;
import com.civicwatch.model.Report;
import com.civicwatch.model.Category;
import com.civicwatch.model.StatusHistory;
import com.civicwatch.service.ReportService;
import com.civicwatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

public class ReportServlet extends HttpServlet {

    private ReportService reportService;
    private static final String UPLOAD_DIR = "uploads";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;

    @Override
    public void init() throws ServletException {
        this.reportService = new ReportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        User user = (User) session.getAttribute("user");

        try {
            switch (action) {
                case "new":
                    showNewReportForm(request, response, user);
                    break;
                case "view":
                    viewReport(request, response, user);
                    break;
                case "list":
                default:
                    listReports(request, response, user);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/jsp/jsp/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (action == null) {
            action = "create";
        }

        try {
            switch (action) {
                case "create":
                    createReport(request, response, user);
                    break;
                case "updateStatus":
                    updateStatus(request, response, user);
                    break;
                case "assign":
                    assignReport(request, response, user);
                    break;
                case "delete":
                    deleteReport(request, response, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/report?action=list");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            listReports(request, response, user);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/jsp/jsp/error.jsp").forward(request, response);
        }
    }

    private void showNewReportForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Category> categories = reportService.getActiveCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/jsp/report-form.jsp").forward(request, response);
    }

    private void listReports(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Report> reports;

        if (user.isAdmin() || user.isCoordinator()) {
            String status = request.getParameter("status");
            String categoryId = request.getParameter("categoryId");
            String search = request.getParameter("search");

            if (search != null && !search.trim().isEmpty()) {
                reports = reportService.searchReports(search);
            } else if (status != null && !status.isEmpty()) {
                reports = reportService.getReportsByStatus(status);
            } else if (categoryId != null && !categoryId.isEmpty()) {
                try {
                    reports = reportService.getReportsByCategoryId(Integer.parseInt(categoryId));
                } catch (NumberFormatException e) {
                    reports = reportService.getAllReports(100, 0);
                }
            } else {
                int page = 1;
                if (request.getParameter("page") != null) {
                    try {
                        page = Integer.parseInt(request.getParameter("page"));
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }
                int limit = 20;
                int offset = (page - 1) * limit;
                reports = reportService.getAllReports(limit, offset);
            }
        } else {
            reports = reportService.getReportsByUserId(user.getId());
        }

        request.setAttribute("reports", reports);
        request.getRequestDispatcher("/jsp/report-list.jsp").forward(request, response);
    }

    private void viewReport(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (!ValidationUtil.isValidId(idParam)) {
            response.sendRedirect(request.getContextPath() + "/report?action=list");
            return;
        }

        int reportId = Integer.parseInt(idParam);
        Report report = reportService.getReportById(reportId);

        if (report == null) {
            request.setAttribute("error", "Report not found");
            request.getRequestDispatcher("/jsp/jsp/error.jsp").forward(request, response);
            return;
        }

        if (!user.isAdmin() && !user.isCoordinator() && report.getUserId() != user.getId()) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/jsp/jsp/error.jsp").forward(request, response);
            return;
        }

        List<StatusHistory> history = reportService.getStatusHistory(reportId);
        request.setAttribute("report", report);
        request.setAttribute("history", history);
        request.getRequestDispatcher("/jsp/report-detail.jsp").forward(request, response);
    }

    private void createReport(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String categoryIdParam = request.getParameter("categoryId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String priority = request.getParameter("priority");

        if (!ValidationUtil.isValidId(categoryIdParam)) {
            throw new IllegalArgumentException("Invalid category");
        }
        if (!ValidationUtil.isValidTitle(title)) {
            throw new IllegalArgumentException("Title must be 5-200 characters");
        }
        if (!ValidationUtil.isValidDescription(description)) {
            throw new IllegalArgumentException("Description must be 10-2000 characters");
        }
        if (!ValidationUtil.isValidLocation(location)) {
            throw new IllegalArgumentException("Location must be 5-255 characters");
        }

        int categoryId = Integer.parseInt(categoryIdParam);
        if (priority == null || priority.isEmpty()) {
            priority = "MEDIUM";
        }

        String imagePath = null;
        if (request.getPart("image") != null) {
            imagePath = handleFileUpload(request, "image");
        }

        int reportId = reportService.createReport(user.getId(), categoryId, title, description,
                                            location, imagePath, priority);

        response.sendRedirect(request.getContextPath() + "/report?action=view&id=" + reportId);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String newStatus = request.getParameter("status");
        String comment = request.getParameter("comment");

        if (!ValidationUtil.isValidId(idParam)) {
            throw new IllegalArgumentException("Invalid report ID");
        }
        if (!ValidationUtil.isValidStatus(newStatus)) {
            throw new IllegalArgumentException("Invalid status");
        }

        int reportId = Integer.parseInt(idParam);
        Report report = reportService.getReportById(reportId);

        if (report == null) {
            throw new IllegalArgumentException("Report not found");
        }

        boolean updated = reportService.updateReportStatus(reportId, newStatus, null, user.getId(), comment);
        if (!updated) {
            throw new RuntimeException("Failed to update status");
        }

        response.sendRedirect(request.getContextPath() + "/report?action=view&id=" + reportId);
    }

    private void assignReport(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String assignedToParam = request.getParameter("assignedTo");

        if (!ValidationUtil.isValidId(idParam)) {
            throw new IllegalArgumentException("Invalid report ID");
        }

        int reportId = Integer.parseInt(idParam);
        Integer assignedTo = null;

        if (assignedToParam != null && !assignedToParam.isEmpty() && ValidationUtil.isValidId(assignedToParam)) {
            assignedTo = Integer.parseInt(assignedToParam);
        }

        reportService.assignReport(reportId, assignedTo, user.getId());

        response.sendRedirect(request.getContextPath() + "/report?action=view&id=" + reportId);
    }

    private void deleteReport(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (!ValidationUtil.isValidId(idParam)) {
            throw new IllegalArgumentException("Invalid report ID");
        }

        int reportId = Integer.parseInt(idParam);
        Report report = reportService.getReportById(reportId);

        if (report == null) {
            throw new IllegalArgumentException("Report not found");
        }

        if (!user.isAdmin() && !user.isCoordinator() && report.getUserId() != user.getId()) {
            throw new IllegalArgumentException("Unauthorized");
        }

        boolean deleted = reportService.deleteReport(reportId);
        if (!deleted) {
            throw new RuntimeException("Failed to delete report");
        }

        response.sendRedirect(request.getContextPath() + "/report?action=list");
    }

    private String handleFileUpload(HttpServletRequest request, String filePartName) throws IOException {
        try {
            javax.servlet.http.Part filePart = request.getPart(filePartName);
            if (filePart == null || filePart.getSize() == 0) {
                return null;
            }

            if (filePart.getSize() > MAX_FILE_SIZE) {
                throw new IllegalArgumentException("File size exceeds 5MB limit");
            }

            String fileName = extractFileName(filePart);
            String extension = "";
            int dotIndex = fileName.lastIndexOf('.');
            if (dotIndex > 0) {
                extension = fileName.substring(dotIndex);
            }

            String newFileName = UUID.randomUUID().toString() + extension;

            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File file = new File(uploadPath, newFileName);
            filePart.write(file.getAbsolutePath());

            return UPLOAD_DIR + "/" + newFileName;
        } catch (Exception e) {
            return null;
        }
    }

    private String extractFileName(javax.servlet.http.Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "unknown";
    }
}
