package com.civicwatch.controller;

import com.civicwatch.model.User;
import com.civicwatch.model.Report;
import com.civicwatch.model.Category;
import com.civicwatch.model.District;
import com.civicwatch.service.ReportService;
import com.civicwatch.service.UserService;
import com.civicwatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class AdminServlet extends HttpServlet {

    private UserService userService;
    private ReportService reportService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
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

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        try {
            switch (action) {
                case "users":
                    manageUsers(request, response);
                    break;
                case "categories":
                    manageCategories(request, response);
                    break;
                case "reports":
                    manageReports(request, response);
                    break;
                case "statistics":
                    showStatistics(request, response);
                    break;
                default:
                    showDashboard(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
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
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/jsp/error.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "createUser":
                    createUser(request, response);
                    break;
                case "updateUser":
                    updateUser(request, response);
                    break;
                case "deleteUser":
                    deleteUser(request, response);
                    break;
                case "toggleUserActive":
                    toggleUserActive(request, response);
                    break;
                case "createCategory":
                    createCategory(request, response);
                    break;
                case "updateCategory":
                    updateCategory(request, response);
                    break;
                case "deleteCategory":
                    deleteCategory(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int totalUsers = userService.getAllUsers().size();
        int totalReports = reportService.getTotalReportCount();
        int pendingReports = reportService.getReportCountByStatus("PENDING");
        int resolvedReports = reportService.getReportCountByStatus("RESOLVED");

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalReports", totalReports);
        request.setAttribute("pendingReports", pendingReports);
        request.setAttribute("resolvedReports", resolvedReports);

        // Populate the "Recent Reports" table on the admin dashboard
        List<Report> recentReports = reportService.getAllReports(20, 0);
        request.setAttribute("reports", recentReports);

        request.getRequestDispatcher("/jsp/dashboard-admin.jsp").forward(request, response);
    }

    private void manageUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        List<User> users;

        if (role != null && !role.isEmpty()) {
            users = userService.getUsersByRole(role);
        } else {
            users = userService.getAllUsers();
        }

        request.setAttribute("users", users);
        request.setAttribute("selectedRole", role);
        request.getRequestDispatcher("/jsp/admin-users.jsp").forward(request, response);
    }

    private void manageCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = reportService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/jsp/admin-categories.jsp").forward(request, response);
    }

    private void manageReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Report> reports = reportService.getAllReports(100, 0);
        request.setAttribute("reports", reports);
        request.getRequestDispatcher("/jsp/admin-reports.jsp").forward(request, response);
    }

    private void showStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", reportService.getTotalReportCount());
        stats.put("pending", reportService.getReportCountByStatus("PENDING"));
        stats.put("inReview", reportService.getReportCountByStatus("IN_REVIEW"));
        stats.put("inProgress", reportService.getReportCountByStatus("IN_PROGRESS"));
        stats.put("resolved", reportService.getReportCountByStatus("RESOLVED"));

        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/jsp/admin-statistics.jsp").forward(request, response);
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String districtIdParam = request.getParameter("districtId");

        if (!ValidationUtil.isValidUsername(username)) {
            throw new IllegalArgumentException("Invalid username");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException("Invalid password");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email");
        }
        if (!ValidationUtil.isValidFullName(fullName)) {
            throw new IllegalArgumentException("Invalid full name");
        }
        if (!ValidationUtil.isValidRole(role)) {
            throw new IllegalArgumentException("Invalid role");
        }

        Integer districtId = null;
        if (districtIdParam != null && !districtIdParam.isEmpty()) {
            districtId = Integer.parseInt(districtIdParam);
        }

        userService.registerUser(username, password, email, fullName, role, districtId);

        response.sendRedirect(request.getContextPath() + "/admin?action=users");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("id");
        String role = request.getParameter("role");
        String activeParam = request.getParameter("isActive");

        if (!ValidationUtil.isValidId(idParam)) {
            throw new IllegalArgumentException("Invalid user ID");
        }

        int userId = Integer.parseInt(idParam);
        User existingUser = userService.getUserById(userId);

        if (existingUser == null) {
            throw new IllegalArgumentException("User not found");
        }

        if (role != null && ValidationUtil.isValidRole(role)) {
            existingUser.setRole(role);
        }

        if (activeParam != null) {
            existingUser.setActive("true".equals(activeParam) || "on".equals(activeParam));
        }

        userService.updateUser(existingUser);

        response.sendRedirect(request.getContextPath() + "/admin?action=users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("id");

        if (!ValidationUtil.isValidId(idParam)) {
            throw new IllegalArgumentException("Invalid user ID");
        }

        int userId = Integer.parseInt(idParam);
        userService.deleteUser(userId);

        response.sendRedirect(request.getContextPath() + "/admin?action=users");
    }

    private void toggleUserActive(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("id");
        String activeParam = request.getParameter("active");

        if (!ValidationUtil.isValidId(idParam)) {
            throw new IllegalArgumentException("Invalid user ID");
        }

        int userId = Integer.parseInt(idParam);
        boolean active = "true".equals(activeParam);

        userService.toggleUserActive(userId, active);

        response.sendRedirect(request.getContextPath() + "/admin?action=users");
    }

    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");

        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Category name is required");
        }

        com.civicwatch.dao.CategoryDAO categoryDAO = new com.civicwatch.dao.CategoryDAO();
        Category category = new Category();
        category.setName(name.trim());
        category.setDescription(description);
        category.setIcon(icon);
        category.setActive(true);
        categoryDAO.create(category);

        response.sendRedirect(request.getContextPath() + "/admin?action=categories");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");

        if (!ValidationUtil.isValidId(idParam)) {
            throw new IllegalArgumentException("Invalid category ID");
        }

        int categoryId = Integer.parseInt(idParam);
        com.civicwatch.dao.CategoryDAO categoryDAO = new com.civicwatch.dao.CategoryDAO();
        Category category = categoryDAO.findById(categoryId);

        if (category == null) {
            throw new IllegalArgumentException("Category not found");
        }

        if (name != null && !name.trim().isEmpty()) {
            category.setName(name.trim());
        }
        category.setDescription(description);
        category.setIcon(icon);

        categoryDAO.update(category);

        response.sendRedirect(request.getContextPath() + "/admin?action=categories");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("id");

        if (!ValidationUtil.isValidId(idParam)) {
            throw new IllegalArgumentException("Invalid category ID");
        }

        int categoryId = Integer.parseInt(idParam);
        com.civicwatch.dao.CategoryDAO categoryDAO = new com.civicwatch.dao.CategoryDAO();
        categoryDAO.delete(categoryId);

        response.sendRedirect(request.getContextPath() + "/admin?action=categories");
    }
}
