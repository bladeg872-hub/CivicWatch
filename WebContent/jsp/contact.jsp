<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.civicwatch.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - CivicWatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 48px 24px;
        }
        .page-header {
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-secondary));
            padding: 64px 40px;
            border-radius: var(--radius-lg);
            margin-bottom: 48px;
            color: white;
            text-align: center;
            box-shadow: var(--shadow-lg);
        }
        .page-header h1 {
            font-size: 48px;
            margin-bottom: 16px;
            font-weight: 800;
        }
        .content-grid {
            display: grid;
            grid-template-columns: 0.8fr 1.2fr;
            gap: 32px;
            margin-bottom: 48px;
        }
        .contact-info {
            background: var(--bg-card);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-soft);
        }
        .contact-item { margin-bottom: 32px; }
        .icon-circle {
            width: 48px;
            height: 48px;
            background: var(--bg-main);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 16px;
            color: var(--brand-primary);
        }
        .contact-form {
            background: var(--bg-card);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-soft);
        }
        .form-group { margin-bottom: 24px; }
        input, textarea {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid var(--border-soft);
            border-radius: 10px;
            font-family: inherit;
            background: var(--bg-main);
            transition: var(--transition);
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: var(--brand-primary);
            background: white;
            box-shadow: 0 0 0 4px rgba(30, 64, 175, 0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />


    <div class="container">
        <div class="back-link">
            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-back">← Back to Dashboard</a>
        </div>

        <% if (successMessage != null) { %>
            <div class="alert alert-success"><%= successMessage %></div>
        <% } %>

        <% if (errorMessage != null) { %>
            <div class="alert alert-error"><%= errorMessage %></div>
        <% } %>

        <div class="page-header">
            <h1>Contact Us</h1>
            <p>We're Here to Help and Listen to Your Feedback</p>
        </div>

        <div class="content-grid">
            <div class="contact-info">
                <h2>Get In Touch</h2>
                
                <div class="contact-item">
                    <div class="icon-circle">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path fill="currentColor" d="m22 7l-8.991 5.727a2 2 0 0 1-2.009 0L2 7"/><rect fill="currentColor" width="20" height="16" x="2" y="4" rx="2"/></g></svg>
                    </div>
                    <h3>Email</h3>
                    <p><a href="mailto:support@civicwatch.local">support@civicwatch.local</a></p>
                    <p style="font-size: 13px; color: var(--gray-500);">Response time: within 24 hours</p>
                </div>

                <div class="contact-item">
                    <div class="icon-circle">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233a14 14 0 0 0 6.392 6.384"/></svg>
                    </div>
                    <h3>Phone</h3>
                    <p><a href="tel:+1-800-CIVICWATCH">+1-800-CIVICWATCH</a></p>
                    <p style="font-size: 13px; color: var(--gray-500);">Monday - Friday, 9 AM - 5 PM EST</p>
                </div>

                <div class="contact-item">
                    <div class="icon-circle">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path fill="currentColor" d="M10 12h4m-4-4h4m0 13v-3a2 2 0 0 0-4 0v3"/><path fill="currentColor" d="M6 10H4a2 2 0 0 0-2 2v7a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-2"/><path fill="currentColor" d="M6 21V5a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v16"/></g></svg>
                    </div>
                    <h3>Office</h3>
                    <p>
                        CivicWatch Headquarters<br/>
                        Public Infrastructure Solutions Inc.<br/>
                        123 Civic Center Road<br/>
                        City Hall District, ST 12345
                    </p>
                </div>

                <div class="contact-item">
                    <div class="icon-circle">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><circle fill="currentColor" cx="12" cy="12" r="10"/><path fill="currentColor" d="M12 6v6l4 2"/></g></svg>
                    </div>
                    <h3>Hours</h3>
                    <p>
                        Monday - Friday: 9:00 AM - 5:00 PM<br/>
                        Saturday: 10:00 AM - 2:00 PM<br/>
                        Sundays & Holidays: Closed
                    </p>
                </div>
            </div>

            <div class="contact-form">
                <h2>Send Us a Message</h2>
                <form method="POST" action="<%= request.getContextPath() %>/contact" onsubmit="return validateForm();">
                    <input type="hidden" name="action" value="send">
                    
                    <div class="form-group">
                        <label for="name">Name</label>
                        <input type="text" id="name" name="name" value="<%= user.getFullName() %>" readonly required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="<%= user.getEmail() %>" readonly required>
                    </div>

                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <input type="text" id="subject" name="subject" placeholder="How can we help?" required>
                    </div>

                    <div class="form-group">
                        <label for="message">Message</label>
                        <textarea id="message" name="message" placeholder="Please describe your inquiry or feedback in detail..." required></textarea>
                    </div>

                    <button type="submit" class="btn">Send Message</button>
                </form>
            </div>
        </div>

        <div style="background: var(--gray-50); padding: 32px; border-radius: var(--radius); text-align: center;">
            <h3 style="color: var(--dark); margin-bottom: 12px;">Have an Infrastructure Issue to Report?</h3>
            <p style="color: var(--gray-700); margin-bottom: 16px;">Instead of contacting us about a specific infrastructure problem, please submit a report directly through the platform. Our coordinators review and prioritize reports from residents like you.</p>
            <a href="<%= request.getContextPath() %>/report?action=new" style="display: inline-flex; align-items: center; gap: 8px; padding: 12px 28px; background: var(--success); color: white; text-decoration: none; border-radius: 10px; font-weight: 500; transition: all 0.2s;">
                + Submit a Report
            </a>
        </div>
    </div>

    <script>
        function validateForm() {
            var subject = document.getElementById('subject').value.trim();
            var message = document.getElementById('message').value.trim();
            
            if (!subject || subject.length < 5) {
                alert('Please enter a subject with at least 5 characters.');
                return false;
            }
            
            if (!message || message.length < 10) {
                alert('Please enter a message with at least 10 characters.');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>
