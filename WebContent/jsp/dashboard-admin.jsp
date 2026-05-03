<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.civicwatch.model.User" %>
<%@ page import="com.civicwatch.model.Report" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    if (!user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/jsp/error.jsp?error=unauthorized");
        return;
    }
    List<Report> allReports = (List<Report>) request.getAttribute("reports");
    if (allReports == null) {
        allReports = new java.util.ArrayList<>();
    }
    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer totalReports = (Integer) request.getAttribute("totalReports");
    Integer pendingReports = (Integer) request.getAttribute("pendingReports");
    Integer resolvedReports = (Integer) request.getAttribute("resolvedReports");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px;
        }
        .welcome {
            background: var(--bg-card);
            padding: 32px;
            border-radius: var(--radius);
            margin-bottom: 32px;
            border: 1px solid var(--border-soft);
            box-shadow: var(--shadow);
        }
        .welcome h2 {
            font-size: 28px;
            font-weight: 800;
            color: var(--brand-primary);
            margin-bottom: 8px;
        }
        .nav-tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 40px;
            border-bottom: 1px solid var(--border-soft);
            padding-bottom: 4px;
        }
        .nav-tab {
            padding: 12px 24px;
            font-weight: 700;
            font-size: 14px;
            color: var(--text-muted);
            border-radius: 10px 10px 0 0;
            transition: var(--transition);
        }
        .nav-tab:hover {
            color: var(--brand-primary);
            background: var(--bg-main);
        }
        .nav-tab.active {
            color: var(--brand-primary);
            border-bottom: 2px solid var(--brand-primary);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            margin-bottom: 48px;
        }
        .stat-card {
            background: var(--bg-card);
            padding: 32px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-soft);
            text-align: center;
        }
        .stat-card h3 {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 12px;
        }
        .stat-card .value {
            font-size: 40px;
            font-weight: 800;
            color: var(--brand-primary);
        }
        .table-container {
            background: var(--bg-card);
            border-radius: var(--radius);
            border: 1px solid var(--border-soft);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: var(--bg-main);
            padding: 16px 24px;
            text-align: left;
            font-weight: 700;
            color: var(--text-muted);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 1px solid var(--border-soft);
        }
        td {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-soft);
            font-size: 14px;
        }
        tr:hover { background: var(--bg-main); }
        .status {
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }
        .status-PENDING { background: #FEF2F2; color: #EF4444; }
        .status-RESOLVED { background: #ECFDF5; color: #10B981; }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />


    <div class="container">
        <div class="welcome">
            <h2>System Administration</h2>
            <p>Manage users, categories, and monitor system performance.</p>
        </div>

        <div class="nav-tabs">
            <a href="<%= request.getContextPath() %>/admin?action=dashboard" class="nav-tab active">Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin?action=users" class="nav-tab">Users</a>
            <a href="<%= request.getContextPath() %>/admin?action=categories" class="nav-tab">Categories</a>
            <a href="<%= request.getContextPath() %>/admin?action=reports" class="nav-tab">Reports</a>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Users</h3>
                <div class="value"><%= totalUsers != null ? totalUsers : 0 %></div>
            </div>
            <div class="stat-card">
                <h3>Total Reports</h3>
                <div class="value"><%= totalReports != null ? totalReports : 0 %></div>
            </div>
            <div class="stat-card">
                <h3>Pending</h3>
                <div class="value"><%= pendingReports != null ? pendingReports : 0 %></div>
            </div>
            <div class="stat-card">
                <h3>Resolved</h3>
                <div class="value"><%= resolvedReports != null ? resolvedReports : 0 %></div>
            </div>
        </div>

        <h3 style="margin-bottom: 15px; color: #333;">Recent Reports</h3>
        <% if (allReports == null || allReports.isEmpty()) { %>
            <p>No reports found.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Priority</th>
                        <th>Reporter</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Report report : allReports) { %>
                        <tr>
                            <td>#<%= report.getId() %></td>
                            <td><%= report.getTitle() != null && report.getTitle().length() > 40 ? report.getTitle().substring(0, 40) + "..." : report.getTitle() %></td>
                            <td><%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></td>
                            <td><span class="status status-<%= report.getStatus() %>"><%= report.getStatus() %></span></td>
                            <td><%= report.getPriority() %></td>
                            <td><%= report.getUserFullName() != null ? report.getUserFullName() : "N/A" %></td>
                            <td><%= report.getCreatedAt() != null ? report.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/report?action=view&id=<%= report.getId() %>" class="btn btn-small">View</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
