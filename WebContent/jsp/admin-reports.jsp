<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.civicwatch.model.User" %>
<%@ page import="com.civicwatch.model.Report" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    if (!currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/jsp/error.jsp?error=unauthorized");
        return;
    }

    List<Report> reports = (List<Report>) request.getAttribute("reports");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin — Reports · CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container { max-width: 1400px; margin: 0 auto; padding: 40px; }
        .admin-nav { display: flex; gap: 8px; margin-bottom: 32px; border-bottom: 1px solid var(--border-soft); padding-bottom: 0; }
        .admin-nav a {
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-muted);
            border-radius: 8px 8px 0 0;
            text-decoration: none;
            transition: var(--transition);
        }
        .admin-nav a:hover { color: var(--brand-primary); background: var(--bg-main); }
        .admin-nav a.active { color: var(--brand-primary); border-bottom: 2px solid var(--brand-primary); }
        .page-title { font-size: 22px; font-weight: 800; margin-bottom: 6px; }
        .page-subtitle { color: var(--text-muted); font-size: 14px; margin-bottom: 28px; }
        .alert-error {
            background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA;
            border-radius: 10px; padding: 12px 16px; margin-bottom: 20px; font-size: 14px;
        }
        .table-wrap {
            background: var(--bg-card);
            border-radius: var(--radius);
            border: 1px solid var(--border-soft);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        th {
            background: var(--bg-main);
            padding: 14px 20px;
            text-align: left;
            font-weight: 700;
            color: var(--text-muted);
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            border-bottom: 1px solid var(--border-soft);
        }
        td { padding: 16px 20px; border-bottom: 1px solid var(--border-soft); font-size: 14px; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: var(--bg-main); }
        .status { padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .status-PENDING    { background: #FEF2F2; color: #DC2626; }
        .status-IN_REVIEW  { background: #FFFBEB; color: #D97706; }
        .status-IN_PROGRESS{ background: #EFF6FF; color: #2563EB; }
        .status-RESOLVED   { background: #ECFDF5; color: #059669; }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />

    <div class="container">
        <nav class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin?action=dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin?action=users">Users</a>
            <a href="<%= request.getContextPath() %>/admin?action=categories">Categories</a>
            <a href="<%= request.getContextPath() %>/admin?action=reports" class="active">Reports</a>
        </nav>

        <% if (error != null) { %>
            <div class="alert-error"><%= error %></div>
        <% } %>

        <div class="page-title">All Reports</div>
        <div class="page-subtitle">Showing up to 100 latest reports across all users.</div>

        <div class="table-wrap">
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
                <% if (reports == null || reports.isEmpty()) { %>
                    <tr><td colspan="8" style="padding: 32px; color: var(--text-muted); text-align: center;">No reports found.</td></tr>
                <% } else { %>
                    <% for (Report r : reports) { %>
                        <tr>
                            <td style="color: var(--text-muted); font-weight: 600;">#<%= r.getId() %></td>
                            <td><%= r.getTitle() != null ? r.getTitle() : "" %></td>
                            <td><%= r.getCategoryName() != null ? r.getCategoryName() : "N/A" %></td>
                            <td><span class="status status-<%= r.getStatus() %>"><%= r.getStatus().replace("_", " ") %></span></td>
                            <td><%= r.getPriority() %></td>
                            <td><%= r.getUserFullName() != null ? r.getUserFullName() : "N/A" %></td>
                            <td style="color: var(--text-muted);"><%= r.getCreatedAt() != null ? r.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                            <td><a class="btn btn-primary" style="font-size: 13px; padding: 7px 14px;" href="<%= request.getContextPath() %>/report?action=view&id=<%= r.getId() %>">View</a></td>
                        </tr>
                    <% } %>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
