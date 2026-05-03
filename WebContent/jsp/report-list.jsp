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
    List<Report> reports = (List<Report>) request.getAttribute("reports");
    if (reports == null) {
        reports = new java.util.ArrayList<>();
    }
    String statusFilter = request.getParameter("status");
    String searchFilter = request.getParameter("search");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px;
        }
        .title-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }
        .title-bar h2 {
            font-size: 28px;
            font-weight: 800;
        }
        .filters {
            background: var(--bg-card);
            padding: 24px;
            border-radius: var(--radius);
            margin-bottom: 32px;
            display: flex;
            gap: 16px;
            align-items: center;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-soft);
        }
        .filters input, .filters select {
            padding: 12px 16px;
            border: 1px solid var(--border-soft);
            border-radius: 10px;
            font-family: inherit;
            background: var(--bg-main);
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
        <div class="title-bar">
            <h2>Infrastructure Reports</h2>
            <a href="<%= request.getContextPath() %>/report?action=new" class="btn">+ New Report</a>
        </div>

        <div class="filters">
            <form action="<%= request.getContextPath() %>/report" method="get">
                <input type="hidden" name="action" value="list">
                <select name="status">
                    <option value="">All Statuses</option>
                    <option value="PENDING" <%= "PENDING".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                    <option value="IN_REVIEW" <%= "IN_REVIEW".equals(statusFilter) ? "selected" : "" %>>In Review</option>
                    <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(statusFilter) ? "selected" : "" %>>In Progress</option>
                    <option value="RESOLVED" <%= "RESOLVED".equals(statusFilter) ? "selected" : "" %>>Resolved</option>
                </select>
                <input type="text" name="search" placeholder="Search reports..." value="<%= searchFilter != null ? searchFilter : "" %>">
                <button type="submit">Filter</button>
            </form>
        </div>

        <% if (reports.isEmpty()) { %>
            <div class="empty">
                <div class="empty-icon">
                    <svg class="icon" style="width: 48px; height: 48px; color: var(--text-muted);" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><rect fill="currentColor" width="8" height="4" x="8" y="2" rx="1" ry="1"/><path fill="currentColor" d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2m4 7h4m-4 5h4m-8-5h.01M8 16h.01"/></g></svg>
                </div>
                <p>No reports found.</p>
                <a href="<%= request.getContextPath() %>/report?action=new" class="btn">Create New Report</a>
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
                                <th>Location</th>
                                <th>Reporter</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Report report : reports) { %>
                                <tr>
                                    <td style="color: var(--gray-500); font-weight: 500;">#<%= report.getId() %></td>
                                    <td><%= report.getTitle() != null && report.getTitle().length() > 50 ? report.getTitle().substring(0, 50) + "..." : report.getTitle() %></td>
                                    <td><%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></td>
                                    <td><span class="status status-<%= report.getStatus() %>"><%= report.getStatus().replace("_", " ") %></span></td>
                                    <td><span class="priority priority-<%= report.getPriority() %>"><%= report.getPriority() %></span></td>
                                    <td><%= report.getLocation() != null && report.getLocation().length() > 30 ? report.getLocation().substring(0, 30) + "..." : report.getLocation() %></td>
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
