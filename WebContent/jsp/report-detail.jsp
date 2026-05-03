<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.civicwatch.model.User" %>
<%@ page import="com.civicwatch.model.Report" %>
<%@ page import="com.civicwatch.model.StatusHistory" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    Report report = (Report) request.getAttribute("report");
    List<StatusHistory> history = (List<StatusHistory>) request.getAttribute("history");
    if (history == null) {
        history = new java.util.ArrayList<>();
    }
    if (report == null) {
        response.sendRedirect(request.getContextPath() + "/report?action=list");
        return;
    }
    boolean canManage = user.isAdmin() || user.isCoordinator();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report #<%= report.getId() %> - CivicWatch</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary: #4F46E5;
            --primary-dark: #4338CA;
            --secondary: #64748B;
            --success: #10B981;
            --warning: #F59E0B;
            --danger: #EF4444;
            --info: #3B82F6;
            --dark: #1E293B;
            --gray-50: #F8FAFC;
            --gray-100: #F1F5F9;
            --gray-200: #E2E8F0;
            --gray-300: #CBD5E1;
            --gray-500: #64748B;
            --gray-700: #334155;
            --white: #FFFFFF;
            --shadow: 0 1px 3px rgba(0,0,0,0.1), 0 1px 2px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05);
            --radius: 12px;
        }
        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #F0F4FF 0%, #E8F0FE 100%);
            min-height: 100vh;
            color: var(--gray-700);
        }
        .header {
            background: var(--white);
            border-bottom: 1px solid var(--gray-200);
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .header-logo {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .header-logo .icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }
        .header-logo h1 {
            font-size: 20px;
            color: var(--dark);
            font-weight: 700;
        }
        .header .nav-links {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .header a {
            color: var(--gray-500);
            text-decoration: none;
            font-size: 14px;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.2s;
        }
        .header a:hover {
            background: var(--gray-100);
            color: var(--dark);
        }
        .container {
            max-width: 1000px;
            margin: 32px auto;
            padding: 0 24px;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--gray-500);
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 20px;
            transition: all 0.2s;
        }
        .back-link:hover {
            color: var(--primary);
        }
        .card {
            background: var(--white);
            padding: 28px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 24px;
        }
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 24px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--gray-100);
        }
        .card-header h2 {
            color: var(--dark);
            font-size: 22px;
            font-weight: 600;
        }
        .report-meta {
            display: flex;
            gap: 12px;
        }
        .status {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .status-PENDING { background: #FEF2F2; color: #DC2626; }
        .status-IN_REVIEW { background: #FFFBEB; color: #D97706; }
        .status-IN_PROGRESS { background: #EFF6FF; color: #2563EB; }
        .status-RESOLVED { background: #ECFDF5; color: #059669; }
        .priority {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .priority-LOW { background: var(--gray-100); color: var(--gray-600); }
        .priority-MEDIUM { background: #EFF6FF; color: #2563EB; }
        .priority-HIGH { background: #FFFBEB; color: #D97706; }
        .priority-CRITICAL { background: #FEF2F2; color: #DC2626; }
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        .detail-item {
            padding: 16px;
            background: var(--gray-50);
            border-radius: 10px;
        }
        .detail-item.full-width {
            grid-column: span 2;
        }
        .detail-label {
            font-size: 12px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 500;
            margin-bottom: 6px;
        }
        .detail-value {
            font-size: 15px;
            color: var(--dark);
            font-weight: 500;
        }
        .image-preview {
            max-width: 100%;
            max-height: 400px;
            border-radius: 10px;
            margin-top: 16px;
        }
        .actions {
            display: flex;
            gap: 16px;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid var(--gray-100);
            flex-wrap: wrap;
        }
        .form-group {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .form-group select, .form-group input {
            padding: 12px 16px;
            border: 1px solid var(--gray-200);
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
        }
        .form-group select:focus, .form-group input:focus {
            outline: none;
            border-color: var(--primary);
        }
        .btn {
            padding: 12px 24px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.2s;
        }
        .btn:hover {
            background: var(--primary-dark);
        }
        .btn-secondary {
            background: var(--gray-100);
            color: var(--gray-700);
        }
        .btn-secondary:hover {
            background: var(--gray-200);
        }
        .history-card {
            padding: 0;
        }
        .history-card h3 {
            padding: 20px 28px;
            color: var(--dark);
            font-size: 18px;
            font-weight: 600;
            border-bottom: 1px solid var(--gray-100);
        }
        .history-list {
            padding: 16px 28px 28px;
        }
        .history-item {
            display: flex;
            gap: 16px;
            padding: 16px 0;
            border-bottom: 1px solid var(--gray-100);
        }
        .history-item:last-child {
            border-bottom: none;
        }
        .history-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--gray-100);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gray-500);
            flex-shrink: 0;
        }
        .history-content {
            flex: 1;
        }
        .history-status {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 4px;
        }
        .history-meta {
            font-size: 13px;
            color: var(--gray-500);
        }
        .history-comment {
            margin-top: 8px;
            padding: 12px;
            background: var(--gray-50);
            border-radius: 8px;
            font-size: 14px;
            color: var(--gray-700);
            font-style: italic;
        }
        .empty {
            text-align: center;
            padding: 40px;
            color: var(--gray-500);
        }
        @media (max-width: 640px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }
            .detail-item.full-width {
                grid-column: span 1;
            }
            .actions {
                flex-direction: column;
            }
            .form-group {
                width: 100%;
            }
            .header {
                padding: 12px 16px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-logo">
            <div class="icon">CW</div>
            <h1>CivicWatch</h1>
        </div>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/report?action=list">Reports</a>
            <a href="<%= request.getContextPath() %>/auth?action=logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <a href="<%= request.getContextPath() %>/report?action=list" class="back-link">
            <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m12 19l-7-7l7-7m7 7H5"/></svg>
            Back to Reports
        </a>

        <div class="card">
            <div class="card-header">
                <h2><%= report.getTitle() %></h2>
                <div class="report-meta">
                    <span class="status status-<%= report.getStatus() %>"><%= report.getStatus().replace("_", " ") %></span>
                    <span class="priority priority-<%= report.getPriority() %>"><%= report.getPriority() %></span>
                </div>
            </div>

            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">Category</div>
                    <div class="detail-value"><%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Location</div>
                    <div class="detail-value"><%= report.getLocation() %></div>
                </div>
                <div class="detail-item full-width">
                    <div class="detail-label">Description</div>
                    <div class="detail-value"><%= report.getDescription() %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Reported By</div>
                    <div class="detail-value"><%= report.getUserFullName() != null ? report.getUserFullName() : "N/A" %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Created</div>
                    <div class="detail-value"><%= report.getCreatedAt() != null ? report.getCreatedAt().toString().substring(0, 19).replace("T", " ") : "N/A" %></div>
                </div>
            </div>

            <% if (report.getImagePath() != null) { %>
                <div style="margin-top: 20px;">
                    <div class="detail-label">Image</div>
                    <img src="<%= request.getContextPath() + "/" + report.getImagePath() %>" alt="Report image" class="image-preview">
                </div>
            <% } %>

            <% if (canManage) { %>
                <div class="actions">
                    <form action="<%= request.getContextPath() %>/report" method="post">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="id" value="<%= report.getId() %>">
                        <div class="form-group">
                            <select name="status">
                                <option value="PENDING" <%= "PENDING".equals(report.getStatus()) ? "selected" : "" %>>Pending</option>
                                <option value="IN_REVIEW" <%= "IN_REVIEW".equals(report.getStatus()) ? "selected" : "" %>>In Review</option>
                                <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(report.getStatus()) ? "selected" : "" %>>In Progress</option>
                                <option value="RESOLVED" <%= "RESOLVED".equals(report.getStatus()) ? "selected" : "" %>>Resolved</option>
                            </select>
                            <input type="text" name="comment" placeholder="Add a comment...">
                            <button type="submit" class="btn">Update Status</button>
                        </div>
                    </form>
                </div>
            <% } %>
        </div>

        <div class="card history-card">
            <h3>Status History</h3>
            <% if (history.isEmpty()) { %>
                <div class="empty">No history available.</div>
            <% } else { %>
                <div class="history-list">
                    <% for (StatusHistory h : history) { %>
                        <div class="history-item">
                            <div class="history-icon">
                                <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path d="M3 12a9 9 0 1 0 9-9a9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5m4-1v5l4 2"/></g></svg>
                            </div>
                            <div class="history-content">
                                <div class="history-status">
                                    <%= h.getOldStatus() != null ? h.getOldStatus().replace("_", " ") : "Created" %> 
                                    <svg class="icon" style="margin: 0 4px;" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14m-7-7l7 7l-7 7"/></svg>
                                    <%= h.getNewStatus().replace("_", " ") %>
                                </div>
                                <div class="history-meta">
                                    By <%= h.getChangedByName() != null ? h.getChangedByName() : "User #" + h.getChangedBy() %> on <%= h.getCreatedAt() != null ? h.getCreatedAt().toString().substring(0, 19).replace("T", " ") : "N/A" %>
                                </div>
                                <% if (h.getComment() != null && !h.getComment().isEmpty()) { %>
                                    <div class="history-comment"><%= h.getComment() %></div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
