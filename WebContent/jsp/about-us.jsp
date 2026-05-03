<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.civicwatch.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - CivicWatch</title>
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
            letter-spacing: -0.02em;
        }
        .page-header p {
            font-size: 18px;
            opacity: 0.9;
        }
        .content-section {
            background: var(--bg-card);
            padding: 40px;
            border-radius: var(--radius);
            margin-bottom: 32px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-soft);
        }
        .content-section h2 {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 20px;
            color: var(--brand-primary);
        }
        .values-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-top: 32px;
        }
        .value-card {
            background: var(--bg-main);
            padding: 32px;
            border-radius: var(--radius);
            text-align: center;
            border: 1px solid var(--border-soft);
            transition: var(--transition);
        }
        .value-card:hover { transform: translateY(-4px); }
        .value-icon { font-size: 40px; margin-bottom: 16px; }
        .value-card h3 { font-weight: 800; margin-bottom: 12px; }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />


    <div class="container">
        <div class="back-link">
            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-back">← Back to Dashboard</a>
        </div>

        <div class="page-header">
            <h1>About CivicWatch</h1>
            <p>Building Transparency and Trust in Our Communities</p>
        </div>

        <div class="content-section">
            <h2>Our Mission</h2>
            <p>
                CivicWatch is dedicated to empowering residents with a transparent platform to report public infrastructure issues 
                and track their resolution. We believe that when communities have visibility into infrastructure problems and their 
                status, it fosters accountability, encourages swift action, and builds trust between residents and local authorities.
            </p>
            <p>
                Our mission is to bridge the gap between residents and government services, making it easier than ever to improve 
                our shared public spaces. Whether it's a pothole on your street, broken lighting in your neighborhood, or any other 
                infrastructure concern, CivicWatch ensures your voice is heard and your issues are tracked to resolution.
            </p>
        </div>

        <div class="content-section">
            <h2>Our Core Values</h2>
            <div class="values-grid">
                <div class="value-card">
                    <div class="value-icon">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path fill="currentColor" d="M2.062 12.348a1 1 0 0 1 0-.696a10.75 10.75 0 0 1 19.876 0a1 1 0 0 1 0 .696a10.75 10.75 0 0 1-19.876 0"/><circle fill="currentColor" cx="12" cy="12" r="3"/></g></svg>
                    </div>
                    <h3>Transparency</h3>
                    <p>Complete visibility into issue status and resolution timelines</p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 14a1 1 0 0 1-.78-1.63l9.9-10.2a.5.5 0 0 1 .86.46l-1.92 6.02A1 1 0 0 0 13 10h7a1 1 0 0 1 .78 1.63l-9.9 10.2a.5.5 0 0 1-.86-.46l1.92-6.02A1 1 0 0 0 11 14z"/></svg>
                    </div>
                    <h3>Empowerment</h3>
                    <p>Giving residents the power to drive change in their communities</p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path fill="currentColor" d="m11 17l2 2a1 1 0 1 0 3-3"/><path fill="currentColor" d="m14 14l2.5 2.5a1 1 0 1 0 3-3l-3.88-3.88a3 3 0 0 0-4.24 0l-.88.88a1 1 0 1 1-3-3l2.81-2.81a5.79 5.79 0 0 1 7.06-.87l.47.28a2 2 0 0 0 1.42.25L21 4"/><path fill="currentColor" d="m21 3l1 11h-2M3 3L2 14l6.5 6.5a1 1 0 1 0 3-3M3 4h8"/></g></svg>
                    </div>
                    <h3>Accountability</h3>
                    <p>Holding authorities accountable for timely issue resolution</p>
                </div>
            </div>
        </div>

        <div class="content-section">
            <h2>How CivicWatch Works</h2>
            <ul>
                <li><strong>Report Issues:</strong> Residents submit detailed reports with descriptions, photos, and location information about infrastructure problems they discover.</li>
                <li><strong>Categorization:</strong> Issues are automatically categorized (Roads, Lighting, Sanitation, etc.) for easy organization and prioritization.</li>
                <li><strong>Track Progress:</strong> Follow your report from submission through resolution with real-time status updates and coordinator communication.</li>
                <li><strong>Community Coordination:</strong> Coordinators review, prioritize, and manage reports while keeping residents informed about progress.</li>
                <li><strong>Administration:</strong> Administrators oversee system operations, manage users, and ensure smooth workflow management.</li>
            </ul>
        </div>

        <div class="content-section">
            <h2>Why Choose CivicWatch?</h2>
            <ul>
                <li>Simple and intuitive interface designed for all residents</li>
                <li>Photo evidence support for clearer issue documentation</li>
                <li>Real-time status tracking and updates</li>
                <li>Role-based dashboards tailored to your needs</li>
                <li>Secure and reliable platform built with enterprise standards</li>
                <li>Community-focused approach to infrastructure improvement</li>
            </ul>
        </div>

        <div class="content-section">
            <h2>Get Started Today</h2>
            <p>
                Start making a difference in your community. Report infrastructure issues, collaborate with coordinators, 
                and help build a better, more transparent public space. Every report counts!
            </p>
            <a href="<%= request.getContextPath() %>/report?action=new" class="btn">+ Report an Issue</a>
        </div>
    </div>
</body>
</html>
