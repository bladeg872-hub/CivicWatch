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
    List<Report> myReports = (List<Report>) request.getAttribute("reports");
    if (myReports == null) {
        myReports = new java.util.ArrayList<>();
    }
    int total = myReports.size();
    int pending = (int) myReports.stream().filter(r -> "PENDING".equals(r.getStatus())).count();
    int inProgress = (int) myReports.stream().filter(r -> "IN_PROGRESS".equals(r.getStatus())).count();
    int resolved = (int) myReports.stream().filter(r -> "RESOLVED".equals(r.getStatus())).count();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px;
        }
        .welcome {
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-secondary));
            padding: 48px;
            border-radius: var(--radius-lg);
            margin-bottom: 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }
        .welcome h2 {
            font-size: 32px;
            margin-bottom: 12px;
            font-weight: 800;
            letter-spacing: -0.02em;
        }
        .welcome p {
            opacity: 0.9;
            font-size: 16px;
        }
        .actions {
            display: flex;
            gap: 16px;
            margin-bottom: 40px;
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
            transition: var(--transition);
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
        }
        .stat-card .label {
            color: var(--text-muted);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .stat-card .value {
            font-size: 40px;
            font-weight: 800;
            color: var(--brand-primary);
        }
        .section-header {
            margin-bottom: 24px;
        }
        .section-header h3 {
            font-size: 20px;
            font-weight: 800;
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
        tr:last-child td { border-bottom: none; }
        tr:hover { background: var(--bg-main); }
        .status {
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .status-PENDING { background: #FEF2F2; color: #EF4444; }
        .status-IN_REVIEW { background: #FFFBEB; color: #F59E0B; }
        .status-IN_PROGRESS { background: #EFF6FF; color: #3B82F6; }
        .status-RESOLVED { background: #ECFDF5; color: #10B981; }
        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 640px) {
            .stats-grid { grid-template-columns: 1fr; }
            .container { padding: 24px; }
        }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />


    <div class="container">
        <div class="welcome">
            <h2>Welcome back, <%= user.getFullName().split(" ")[0] %>!</h2>
            <p>Your voice matters. Report infrastructure issues and help build a better community.</p>
        </div>

        <div class="actions">
            <a href="<%= request.getContextPath() %>/report?action=new" class="btn">+ Report an Issue</a>
            <a href="<%= request.getContextPath() %>/report?action=list" class="btn btn-secondary">View All Reports</a>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="label">Total Reports</div>
                <div class="value"><%= total %></div>
            </div>
            <div class="stat-card">
                <div class="label">Pending</div>
                <div class="value"><%= pending %></div>
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
        <% if (myReports.isEmpty()) { %>
            <div class="card">
                <div class="empty">
                    <div class="empty-icon">
                        <svg class="icon" style="width: 48px; height: 48px; color: var(--text-muted);" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><rect fill="currentColor" width="8" height="4" x="8" y="2" rx="1" ry="1"/><path fill="currentColor" d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2m4 7h4m-4 5h4m-8-5h.01M8 16h.01"/></g></svg>
                    </div>
                    <p>No reports yet. Be the first to report an issue in your community!</p>
                    <a href="<%= request.getContextPath() %>/report?action=new" class="btn">Create Your First Report</a>
                </div>
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
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Report report : myReports) { %>
                                <tr>
                                    <td style="color: var(--gray-500); font-weight: 500;">#<%= report.getId() %></td>
                                    <td><a href="<%= request.getContextPath() %>/report?action=view&id=<%= report.getId() %>"><%= report.getTitle() %></a></td>
                                    <td><%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></td>
                                    <td><span class="status status-<%= report.getStatus() %>"><%= report.getStatus().replace("_", " ") %></span></td>
                                    <td style="font-weight: 500;"><%= report.getPriority() %></td>
                                    <td style="color: var(--gray-500);"><%= report.getCreatedAt() != null ? report.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
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
