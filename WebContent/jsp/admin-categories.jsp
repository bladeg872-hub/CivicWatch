<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.civicwatch.model.User" %>
<%@ page import="com.civicwatch.model.Category" %>
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

    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin — Categories · CivicWatch</title>
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
        .alert-error {
            background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA;
            border-radius: 10px; padding: 12px 16px; margin-bottom: 20px; font-size: 14px;
        }
        .form-card {
            background: var(--bg-card); border-radius: var(--radius);
            border: 1px solid var(--border-soft); box-shadow: var(--shadow);
            padding: 32px; margin-bottom: 32px;
        }
        .form-card h2 { font-size: 18px; font-weight: 800; margin-bottom: 20px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 7px; }
        .form-group input {
            width: 100%; padding: 11px 14px; border: 1px solid var(--border-soft);
            border-radius: 8px; background: var(--bg-main); font-family: inherit;
            font-size: 14px; transition: var(--transition);
        }
        .form-group input:focus {
            outline: none; border-color: var(--brand-primary);
            background: white; box-shadow: 0 0 0 3px rgba(30,64,175,0.1);
        }
        .table-wrap {
            background: var(--bg-card); border-radius: var(--radius);
            border: 1px solid var(--border-soft); box-shadow: var(--shadow); overflow: hidden;
        }
        .table-header { padding: 20px 24px; border-bottom: 1px solid var(--border-soft); }
        .table-header h3 { font-size: 16px; font-weight: 700; }
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
        .btn-danger-link {
            background: none; border: none; color: var(--danger);
            font-size: 13px; font-weight: 600; cursor: pointer; padding: 0;
        }
        .btn-danger-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />

    <div class="container">
        <nav class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin?action=dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin?action=users">Users</a>
            <a href="<%= request.getContextPath() %>/admin?action=categories" class="active">Categories</a>
            <a href="<%= request.getContextPath() %>/admin?action=reports">Reports</a>
        </nav>

        <% if (error != null) { %>
            <div class="alert-error"><%= error %></div>
        <% } %>

        <div class="form-card">
            <h2>Create Category</h2>
            <form method="post" action="<%= request.getContextPath() %>/admin">
                <input type="hidden" name="action" value="createCategory">
                <div class="form-row">
                    <div class="form-group">
                        <label>Name</label>
                        <input name="name" required placeholder="e.g. Roads">
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <input name="description" placeholder="Short description">
                    </div>
                    <div class="form-group">
                        <label>Icon</label>
                        <input name="icon" placeholder="e.g. roads.png">
                    </div>
                </div>
                <button class="btn btn-primary" type="submit">Create Category</button>
            </form>
        </div>

        <div class="table-wrap">
            <div class="table-header"><h3>All Categories</h3></div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Icon</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (categories == null || categories.isEmpty()) { %>
                    <tr><td colspan="5" style="padding: 32px; color: var(--text-muted); text-align: center;">No categories found.</td></tr>
                <% } else { %>
                    <% for (Category c : categories) { %>
                        <tr>
                            <td style="color: var(--text-muted); font-weight: 600;">#<%= c.getId() %></td>
                            <td style="font-weight: 600;"><%= c.getName() %></td>
                            <td><%= c.getDescription() != null ? c.getDescription() : "—" %></td>
                            <td style="color: var(--text-muted);"><%= c.getIcon() != null ? c.getIcon() : "—" %></td>
                            <td>
                                <form method="post" action="<%= request.getContextPath() %>/admin" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteCategory">
                                    <input type="hidden" name="id" value="<%= c.getId() %>">
                                    <button class="btn-danger-link" type="submit" onclick="return confirm('Delete this category?');">Delete</button>
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
