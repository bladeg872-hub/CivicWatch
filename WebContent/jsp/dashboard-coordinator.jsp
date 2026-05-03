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
    List<Report> allReports = (List<Report>) request.getAttribute("reports");
    if (allReports == null) {
        allReports = new java.util.ArrayList<>();
    }
    int total = allReports.size();
    int pending = (int) allReports.stream().filter(r -> "PENDING".equals(r.getStatus())).count();
    int inReview = (int) allReports.stream().filter(r -> "IN_REVIEW".equals(r.getStatus())).count();
    int inProgress = (int) allReports.stream().filter(r -> "IN_PROGRESS".equals(r.getStatus())).count();
    int resolved = (int) allReports.stream().filter(r -> "RESOLVED".equals(r.getStatus())).count();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Coordinator Dashboard - CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px;
        }
        .welcome {
            background: linear-gradient(135deg, var(--brand-accent), #D97706);
            padding: 48px;
            border-radius: var(--radius-lg);
            margin-bottom: 40px;
            color: white;
            box-shadow: var(--shadow-lg);
        }
        .welcome h2 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 12px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            margin-bottom: 48px;
        }
        .stat-card {
            background: var(--bg-card);
            padding: 24px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-soft);
            transition: var(--transition);
        }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-card .label {
            color: var(--text-muted);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .stat-card .value {
            font-size: 32px;
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
            border-bottom: 1px solid var(--border-soft);
        }
        td {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border-soft);
            font-size: 14px;
        }
        .status {
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }
        .status-PENDING { background: #FEF2F2; color: #DC2626; }
        .status-IN_REVIEW { background: #FFFBEB; color: #D97706; }
        .status-IN_PROGRESS { background: #EFF6FF; color: #2563EB; }
        .status-RESOLVED { background: #ECFDF5; color: #059669; }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />


    <div class="container">
        <div class="welcome">
            <h2>Coordinator Dashboard</h2>
            <p>Manage and track all infrastructure reports in your jurisdiction.</p>
        </div>

        <div class="actions">
            <a href="<%= request.getContextPath() %>/report?action=list" class="btn">View All Reports</a>
            <a href="<%= request.getContextPath() %>/report?action=list&status=PENDING" class="btn btn-secondary">Pending</a>
            <a href="<%= request.getContextPath() %>/report?action=list&status=IN_PROGRESS" class="btn btn-secondary">In Progress</a>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="label">Total</div>
                <div class="value"><%= total %></div>
            </div>
            <div class="stat-card">
                <div class="label">Pending</div>
                <div class="value"><%= pending %></div>
            </div>
            <div class="stat-card">
                <div class="label">In Review</div>
                <div class="value"><%= inReview %></div>
            </div>
            <div class="stat-card">
                <div class="label">In Progress</div>
                <div class="value"><%= inProgress %></div>
            </div>
            <div class="stat-card">
                <div class="label">Resolved</div>
                <div class="value"><%= resolved %></div>
            </div>
        </div>

        <div class="section-header">
            <h3>Recent Reports</h3>
        </div>
        <% if (allReports.isEmpty()) { %>
            <div class="card">
                <div class="empty">No reports found.</div>
            </div>
        <% } else { %>
            <div class="card">
                <div class="table-container">
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
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Report report : allReports) { %>
                                <tr>
                                    <td style="color: var(--gray-500); font-weight: 500;">#<%= report.getId() %></td>
                                    <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><%= report.getTitle() != null && report.getTitle().length() > 40 ? report.getTitle().substring(0, 40) + "..." : report.getTitle() %></td>
                                    <td><%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></td>
                                    <td><span class="status status-<%= report.getStatus() %>"><%= report.getStatus().replace("_", " ") %></span></td>
                                    <td><span class="priority priority-<%= report.getPriority() %>"><%= report.getPriority() %></span></td>
                                    <td><%= report.getUserFullName() != null ? report.getUserFullName() : "N/A" %></td>
                                    <td style="color: var(--gray-500);"><%= report.getCreatedAt() != null ? report.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                    <td><a href="<%= request.getContextPath() %>/report?action=view&id=<%= report.getId() %>">View</a></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>
