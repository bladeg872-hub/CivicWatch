<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.civicwatch.model.User" %>
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

    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin — Statistics · CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container { max-width: 1200px; margin: 0 auto; padding: 40px; }
        .admin-nav { display: flex; gap: 8px; margin-bottom: 32px; border-bottom: 1px solid var(--border-soft); }
        .admin-nav a {
            padding: 10px 20px; font-size: 14px; font-weight: 600;
            color: var(--text-muted); border-radius: 8px 8px 0 0;
            text-decoration: none; transition: var(--transition);
        }
        .admin-nav a:hover { color: var(--brand-primary); background: var(--bg-main); }
        .admin-nav a.active { color: var(--brand-primary); border-bottom: 2px solid var(--brand-primary); }
        .page-title { font-size: 22px; font-weight: 800; margin-bottom: 24px; }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
        }
        .stat-card {
            background: var(--bg-card);
            border-radius: var(--radius);
            border: 1px solid var(--border-soft);
            box-shadow: var(--shadow);
            padding: 32px 24px;
            text-align: center;
            transition: var(--transition);
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .stat-label {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.08em; color: var(--text-muted); margin-bottom: 12px;
        }
        .stat-value { font-size: 48px; font-weight: 800; color: var(--brand-primary); line-height: 1; }
        .stat-card.pending   .stat-value { color: #DC2626; }
        .stat-card.in-review .stat-value { color: #D97706; }
        .stat-card.in-progress .stat-value { color: #2563EB; }
        .stat-card.resolved  .stat-value { color: #059669; }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />

    <div class="container">
        <nav class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin?action=dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin?action=users">Users</a>
            <a href="<%= request.getContextPath() %>/admin?action=categories">Categories</a>
            <a href="<%= request.getContextPath() %>/admin?action=reports">Reports</a>
            <a href="<%= request.getContextPath() %>/admin?action=statistics" class="active">Statistics</a>
        </nav>

        <div class="page-title">System Statistics</div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total Reports</div>
                <div class="stat-value"><%= (stats != null && stats.get("total") != null) ? stats.get("total") : 0 %></div>
            </div>
            <div class="stat-card pending">
                <div class="stat-label">Pending</div>
                <div class="stat-value"><%= (stats != null && stats.get("pending") != null) ? stats.get("pending") : 0 %></div>
            </div>
            <div class="stat-card in-review">
                <div class="stat-label">In Review</div>
                <div class="stat-value"><%= (stats != null && stats.get("inReview") != null) ? stats.get("inReview") : 0 %></div>
            </div>
            <div class="stat-card in-progress">
                <div class="stat-label">In Progress</div>
                <div class="stat-value"><%= (stats != null && stats.get("inProgress") != null) ? stats.get("inProgress") : 0 %></div>
            </div>
            <div class="stat-card resolved">
                <div class="stat-label">Resolved</div>
                <div class="stat-value"><%= (stats != null && stats.get("resolved") != null) ? stats.get("resolved") : 0 %></div>
            </div>
        </div>
    </div>
</body>
</html>
