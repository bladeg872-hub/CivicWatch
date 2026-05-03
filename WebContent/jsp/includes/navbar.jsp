<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.civicwatch.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
%>
<nav class="navbar">
    <div class="nav-container">
        <a href="<%= contextPath %>/" class="nav-logo">
            <div class="logo-mark">CW</div>
            <span>CivicWatch</span>
        </a>

        <div class="nav-links">
            <% if (navUser == null) { %>
                <a href="<%= contextPath %>/" class="nav-item">Home</a>
            <% } else { %>
                <a href="<%= contextPath %>/dashboard" class="nav-item">Dashboard</a>
                <a href="<%= contextPath %>/report?action=list" class="nav-item">My Reports</a>
            <% } %>
            <a href="<%= contextPath %>/jsp/about-us.jsp" class="nav-item">About Us</a>
            <a href="<%= contextPath %>/jsp/contact.jsp" class="nav-item">Contact</a>
        </div>

        <div class="nav-actions">
            <% if (navUser == null) { %>
                <a href="<%= contextPath %>/jsp/login.jsp" class="btn btn-ghost">Login</a>
                <a href="<%= contextPath %>/jsp/register.jsp" class="btn btn-primary">Sign Up</a>
            <% } else { %>
                <div class="user-profile">
                    <div class="user-avatar">
                        <%= navUser.getFullName().substring(0,1).toUpperCase() %>
                    </div>
                    <div class="user-info">
                        <span class="name"><%= navUser.getFullName() %></span>
                        <span class="role"><%= navUser.getRole() %></span>
                    </div>
                </div>
                <a href="<%= contextPath %>/auth?action=logout" class="btn btn-danger">Logout</a>
            <% } %>
        </div>
    </div>
</nav>
