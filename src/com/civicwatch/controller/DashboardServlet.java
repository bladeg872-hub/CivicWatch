package com.civicwatch.controller;

import com.civicwatch.model.User;
import com.civicwatch.model.Report;
import com.civicwatch.model.Category;
import com.civicwatch.service.ReportService;
import com.civicwatch.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    private ReportService reportService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.reportService = new ReportService();
        this.userService = new UserService();
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
        String role = request.getParameter("role");

        if (role == null) {
            role = user.getRole();
        }

        if ("ADMIN".equals(role)) {
            // Admin dashboard stats are computed in AdminServlet
            response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
        } else if ("COORDINATOR".equals(role)) {
            // Coordinator dashboard derives counters from the provided report list
            request.setAttribute("reports", reportService.getAllReports(100, 0));
            request.getRequestDispatcher("/jsp/dashboard-coordinator.jsp").forward(request, response);
        } else {
            // Resident dashboard derives counters from the provided report list
            request.setAttribute("reports", reportService.getReportsByUserId(user.getId()));
            request.getRequestDispatcher("/jsp/dashboard-resident.jsp").forward(request, response);
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

        if ("viewReports".equals(action)) {
            handleViewReports(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    private void handleViewReports(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Report> reports;

        if (user.isAdmin() || user.isCoordinator()) {
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
        } else {
            reports = reportService.getReportsByUserId(user.getId());
        }

        request.setAttribute("reports", reports);
        request.getRequestDispatcher("/jsp/report-list.jsp").forward(request, response);
    }
}
