<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.civicwatch.model.User" %>
<%@ page import="com.civicwatch.model.Category" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
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
    <title>New Report - CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 48px 24px;
        }
        .form-card {
            background: var(--bg-card);
            padding: 48px;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-soft);
        }
        .form-header {
            margin-bottom: 40px;
            text-align: center;
        }
        .form-header h2 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 12px;
        }
        .form-group { margin-bottom: 24px; }
        .form-group label {
            display: block;
            font-weight: 700;
            margin-bottom: 8px;
            font-size: 14px;
            color: var(--text-main);
        }
        input, select, textarea {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid var(--border-soft);
            border-radius: 10px;
            font-family: inherit;
            background: var(--bg-main);
            transition: var(--transition);
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: var(--brand-primary);
            background: white;
            box-shadow: 0 0 0 4px rgba(30, 64, 175, 0.1);
        }
        .file-upload {
            border: 2px dashed var(--border-soft);
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
            background: var(--bg-main);
            display: block;
        }
        .file-upload:hover {
            border-color: var(--brand-primary);
            background: white;
        }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />


    <div class="container">
        <div class="form-card">
            <div class="form-header">
                <h2>Report an Infrastructure Issue</h2>
                <p>Help improve your community by reporting problems you observe.</p>
            </div>

            <% if (error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/report" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="create">

                <div class="form-group">
                    <label for="categoryId">Category <span class="required">*</span></label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">Select a category</option>
                        <% if (categories != null) {
                            for (Category cat : categories) { %>
                                <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                            <% }
                        } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="title">Title <span class="required">*</span></label>
                    <input type="text" id="title" name="title" required minlength="5" maxlength="200"
                           placeholder="Brief description of the issue">
                </div>

                <div class="form-group">
                    <label for="description">Description <span class="required">*</span></label>
                    <textarea id="description" name="description" required minlength="10" maxlength="2000"
                              placeholder="Provide details about the issue, including when you noticed it and any relevant information..."></textarea>
                </div>

                <div class="form-group">
                    <label for="location">Location <span class="required">*</span></label>
                    <input type="text" id="location" name="location" required minlength="5" maxlength="255"
                           placeholder="Specific address or location description">
                    <p class="help">Example: 123 Main Street, near the park entrance</p>
                </div>

                <div class="form-group">
                    <label for="priority">Priority</label>
                    <select id="priority" name="priority">
                        <option value="LOW">Low - Minor inconvenience</option>
                        <option value="MEDIUM" selected>Medium - Needs attention soon</option>
                        <option value="HIGH">High - Urgent issue</option>
                        <option value="CRITICAL">Critical - Safety hazard</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="image">Photo (optional)</label>
                    <label class="file-upload" for="image">
                        <input type="file" id="image" name="image" accept="image/*">
                        <div class="file-upload-icon">
                            <svg class="icon" style="width: 32px; height: 32px; color: #64748B;" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path d="M13.997 4a2 2 0 0 1 1.76 1.05l.486.9A2 2 0 0 0 18.003 7H20a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1.997a2 2 0 0 0 1.759-1.048l.489-.904A2 2 0 0 1 10.004 4z"/><circle cx="12" cy="13" r="3"/></g></svg>
                        </div>
                        <p>Click to upload or drag and drop<br><span style="font-size: 12px; color: #94A3B8;">PNG, JPG up to 5MB</span></p>
                    </label>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn">Submit Report</button>
                    <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
