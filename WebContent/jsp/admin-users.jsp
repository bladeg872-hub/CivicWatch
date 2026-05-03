<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
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

    List<User> users = (List<User>) request.getAttribute("users");
    String selectedRole = (String) request.getAttribute("selectedRole");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin — Users · CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container { max-width: 1400px; margin: 0 auto; padding: 40px; }
        .admin-nav { display: flex; gap: 8px; margin-bottom: 32px; border-bottom: 1px solid var(--border-soft); }
        .admin-nav a {
            padding: 10px 20px; font-size: 14px; font-weight: 600;
            color: var(--text-muted); border-radius: 8px 8px 0 0;
            text-decoration: none; transition: var(--transition);
        }
        .admin-nav a:hover { color: var(--brand-primary); background: var(--bg-main); }
        .admin-nav a.active { color: var(--brand-primary); border-bottom: 2px solid var(--brand-primary); }
        .page-title { font-size: 22px; font-weight: 800; margin-bottom: 6px; }
        .page-subtitle { color: var(--text-muted); font-size: 14px; margin-bottom: 24px; }
        .alert-error {
            background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA;
            border-radius: 10px; padding: 12px 16px; margin-bottom: 20px; font-size: 14px;
        }
        .filter-bar {
            background: var(--bg-card); border-radius: var(--radius);
            border: 1px solid var(--border-soft); box-shadow: var(--shadow);
            padding: 20px 24px; margin-bottom: 24px;
            display: flex; align-items: center; gap: 16px;
        }
        .filter-bar label { font-size: 13px; font-weight: 600; white-space: nowrap; }
        .filter-bar select {
            padding: 9px 14px; border: 1px solid var(--border-soft);
            border-radius: 8px; background: var(--bg-main); font-family: inherit;
            font-size: 14px; cursor: pointer; transition: var(--transition);
        }
        .filter-bar select:focus { outline: none; border-color: var(--brand-primary); }
        .table-wrap {
            background: var(--bg-card); border-radius: var(--radius);
            border: 1px solid var(--border-soft); box-shadow: var(--shadow); overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        th {
            background: var(--bg-main); padding: 14px 20px; text-align: left;
            font-weight: 700; color: var(--text-muted); font-size: 11px;
            text-transform: uppercase; letter-spacing: 0.06em;
            border-bottom: 1px solid var(--border-soft);
        }
        td { padding: 16px 20px; border-bottom: 1px solid var(--border-soft); font-size: 14px; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: var(--bg-main); }
        .role-badge {
            padding: 3px 10px; border-radius: 999px; font-size: 11px;
            font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em;
        }
        .role-ADMIN        { background: #EEF2FF; color: #4338CA; }
        .role-COORDINATOR  { background: #FFFBEB; color: #B45309; }
        .role-RESIDENT     { background: #ECFDF5; color: #059669; }
        .active-yes { color: #059669; font-weight: 700; }
        .active-no  { color: #DC2626; font-weight: 700; }
        .action-link {
            background: none; border: none; font-size: 13px; font-weight: 600;
            cursor: pointer; padding: 0; transition: var(--transition);
        }
        .action-link.disable { color: var(--warning); }
        .action-link.enable  { color: var(--success); }
        .action-link.delete  { color: var(--danger); }
        .action-link:hover { text-decoration: underline; }
        .divider { color: var(--border-soft); margin: 0 6px; }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />

    <div class="container">
        <nav class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin?action=dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin?action=users" class="active">Users</a>
            <a href="<%= request.getContextPath() %>/admin?action=categories">Categories</a>
            <a href="<%= request.getContextPath() %>/admin?action=reports">Reports</a>
        </nav>

        <% if (error != null) { %>
            <div class="alert-error"><%= error %></div>
        <% } %>

        <div class="page-title">User Management</div>
        <div class="page-subtitle">Filter, enable/disable, or remove users from the system.</div>

        <div class="filter-bar">
            <label for="role-filter">Filter by role</label>
            <form method="get" action="<%= request.getContextPath() %>/admin" style="display:flex; align-items:center; gap:12px;">
                <input type="hidden" name="action" value="users">
                <select id="role-filter" name="role" onchange="this.form.submit()">
                    <option value="" <%= (selectedRole == null || selectedRole.isEmpty()) ? "selected" : "" %>>All Roles</option>
                    <option value="ADMIN"       <%= "ADMIN".equals(selectedRole)       ? "selected" : "" %>>Admin</option>
                    <option value="COORDINATOR" <%= "COORDINATOR".equals(selectedRole) ? "selected" : "" %>>Coordinator</option>
                    <option value="RESIDENT"    <%= "RESIDENT".equals(selectedRole)    ? "selected" : "" %>>Resident</option>
                </select>
            </form>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Active</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (users == null || users.isEmpty()) { %>
                    <tr><td colspan="7" style="padding:32px; color:var(--text-muted); text-align:center;">No users found.</td></tr>
                <% } else { %>
                    <% for (User u : users) { %>
                        <tr>
                            <td style="color:var(--text-muted); font-weight:600;">#<%= u.getId() %></td>
                            <td style="font-weight:700;"><%= u.getUsername() %></td>
                            <td><%= u.getFullName() %></td>
                            <td style="color:var(--text-muted);"><%= u.getEmail() %></td>
                            <td><span class="role-badge role-<%= u.getRole() %>"><%= u.getRole() %></span></td>
                            <td>
                                <span class="<%= u.isActive() ? "active-yes" : "active-no" %>">
                                    <%= u.isActive() ? "Yes" : "No" %>
                                </span>
                            </td>
                            <td>
                                <form method="post" action="<%= request.getContextPath() %>/admin" style="display:inline;">
                                    <input type="hidden" name="action" value="toggleUserActive">
                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                    <input type="hidden" name="active" value="<%= u.isActive() ? "false" : "true" %>">
                                    <button class="action-link <%= u.isActive() ? "disable" : "enable" %>" type="submit">
                                        <%= u.isActive() ? "Disable" : "Enable" %>
                                    </button>
                                </form>
                                <span class="divider">|</span>
                                <form method="post" action="<%= request.getContextPath() %>/admin" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                    <button class="action-link delete" type="submit" onclick="return confirm('Permanently delete this user?');">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
