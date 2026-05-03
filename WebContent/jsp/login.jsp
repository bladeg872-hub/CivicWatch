<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String registered = request.getParameter("registered");
    String loggedOut = request.getParameter("loggedOut");
    String passwordChanged = request.getParameter("passwordChanged");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CivicWatch</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700&family=Cormorant+Garamond:wght@600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --ink: #132238;
            --ink-soft: #4b5f76;
            --panel: #f8fafc;
            --line: #d8e0ea;
            --brand: #204a87;
            --brand-deep: #16345f;
            --accent: #d38f2a;
            --danger-bg: #fff1f1;
            --danger: #b4232d;
            --success-bg: #edf9f1;
            --success: #1d7a45;
        }
        body {
            font-family: 'Manrope', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #eaf0f7 0%, #dfe8f2 100%);
            color: var(--ink);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 28px;
        }
        .auth-shell {
            width: min(1080px, 100%);
            min-height: 680px;
            border-radius: 24px;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1.08fr 0.92fr;
            background: var(--panel);
            box-shadow: 0 24px 56px rgba(19, 34, 56, 0.2);
        }
        .visual-panel {
            position: relative;
            isolation: isolate;
        }
        .visual-panel img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .visual-panel::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(170deg, rgba(11, 21, 35, 0.12) 0%, rgba(11, 21, 35, 0.58) 100%);
            z-index: 1;
        }
        .visual-panel::after {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            height: 100%;
            width: 40%;
            background: linear-gradient(to right, rgba(11, 21, 35, 0) 0%, rgba(11, 21, 35, 0.35) 62%, rgba(248, 250, 252, 0.98) 100%);
            z-index: 2;
            pointer-events: none;
        }
        .visual-copy {
            position: absolute;
            left: 40px;
            right: 70px;
            bottom: 46px;
            z-index: 3;
            color: #f6f9ff;
        }
        .visual-copy .label {
            display: inline-block;
            margin-bottom: 14px;
            font-size: 12px;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: rgba(246, 249, 255, 0.82);
        }
        .visual-copy h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(34px, 3.4vw, 46px);
            line-height: 1.02;
            margin-bottom: 10px;
            font-weight: 700;
        }
        .visual-copy p {
            max-width: 430px;
            color: rgba(246, 249, 255, 0.86);
            line-height: 1.6;
            font-size: 15px;
        }
        .form-panel {
            padding: 42px 44px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: var(--panel);
        }
        .top-link {
            align-self: flex-end;
            margin-bottom: 24px;
            font-size: 13px;
            color: var(--ink-soft);
            text-decoration: none;
        }
        .top-link:hover { color: var(--brand); }
        .heading h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 40px;
            line-height: 1;
            margin-bottom: 8px;
        }
        .heading p {
            color: var(--ink-soft);
            font-size: 14px;
            margin-bottom: 24px;
        }
        .alert {
            border-radius: 10px;
            padding: 12px 14px;
            margin-bottom: 14px;
            font-size: 13px;
            border: 1px solid transparent;
        }
        .alert-error {
            background: var(--danger-bg);
            color: var(--danger);
            border-color: #f2ccd0;
        }
        .alert-success {
            background: var(--success-bg);
            color: var(--success);
            border-color: #cdebd8;
        }
        .form-group { margin-bottom: 14px; }
        .form-group label {
            display: block;
            font-size: 13px;
            margin-bottom: 7px;
            color: var(--ink);
            font-weight: 600;
        }
        .form-group input {
            width: 100%;
            border: 1px solid var(--line);
            border-radius: 10px;
            padding: 13px 14px;
            background: #ffffff;
            color: var(--ink);
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--brand);
            box-shadow: 0 0 0 3px rgba(32, 74, 135, 0.12);
        }
        .btn {
            width: 100%;
            margin-top: 6px;
            border: none;
            border-radius: 10px;
            padding: 14px;
            background: linear-gradient(135deg, var(--brand) 0%, var(--brand-deep) 100%);
            color: #ffffff;
            font-family: inherit;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 0.01em;
            cursor: pointer;
            transition: transform 0.18s ease, box-shadow 0.18s ease;
            box-shadow: 0 12px 24px rgba(22, 52, 95, 0.2);
        }
        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 16px 28px rgba(22, 52, 95, 0.25);
        }
        .row-links {
            margin-top: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            font-size: 13px;
        }
        .row-links a {
            color: var(--brand);
            text-decoration: none;
            font-weight: 600;
        }
        .row-links a:hover { text-decoration: underline; }
        .home-link {
            margin-top: 10px;
            font-size: 13px;
            color: var(--ink-soft);
        }
        .home-link a {
            color: var(--ink-soft);
            text-decoration: none;
            font-weight: 600;
        }
        .home-link a:hover {
            color: var(--brand);
        }
        .demo {
            margin-top: 20px;
            border-top: 1px solid var(--line);
            padding-top: 14px;
            font-size: 12px;
            color: var(--ink-soft);
        }
        .demo strong {
            display: block;
            color: var(--ink);
            font-size: 12px;
            margin-bottom: 7px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }
        .demo p { margin-bottom: 4px; }
        .demo code {
            font-family: Consolas, monospace;
            color: var(--ink);
            background: #eef3fa;
            padding: 1px 6px;
            border-radius: 5px;
        }
        @media (max-width: 980px) {
            .auth-shell {
                grid-template-columns: 1fr;
                min-height: auto;
            }
            .form-panel {
                order: 1;
                padding: 30px 24px;
            }
            .visual-panel {
                order: 2;
                min-height: 240px;
            }
            .visual-panel::after {
                width: 100%;
                height: 46%;
                top: 0;
                right: auto;
                left: 0;
                background: linear-gradient(to bottom, rgba(248, 250, 252, 0.98) 0%, rgba(11, 21, 35, 0.18) 55%, rgba(11, 21, 35, 0.48) 100%);
            }
            .visual-copy {
                left: 24px;
                right: 24px;
                bottom: 22px;
            }
            .visual-copy h1 { font-size: 32px; }
            .top-link { margin-bottom: 16px; }
        }
    </style>
</head>
<body>
    <div class="auth-shell">
        <section class="visual-panel">
            <img src="<%= request.getContextPath() %>/images/hero-street.jpg" alt="Urban street and infrastructure">
            <div class="visual-copy">
                <span class="label">CivicWatch</span>
                <h1>Public issues, visible progress.</h1>
                <p>Report infrastructure problems and follow every update from pending to resolved.</p>
            </div>
        </section>

        <section class="form-panel">
            <a class="top-link" href="<%= request.getContextPath() %>/index.jsp">Back to home</a>
            <div class="heading">
                <h2>Sign In</h2>
                <p>Access your dashboard to track and manage reports.</p>
            </div>

            <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <% if ("true".equals(registered)) { %>
                <div class="alert alert-success">Registration successful. Please log in.</div>
            <% } %>

            <% if ("true".equals(loggedOut)) { %>
                <div class="alert alert-success">You have been logged out.</div>
            <% } %>

            <% if ("true".equals(passwordChanged)) { %>
                <div class="alert alert-success">Password changed successfully.</div>
            <% } %>

            <form action="<%= request.getContextPath() %>/auth" method="post">
                <input type="hidden" name="action" value="login">

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required placeholder="Enter your username">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="Enter your password">
                </div>

                <button type="submit" class="btn">Login</button>
            </form>

            <div class="row-links">
                <span>New to CivicWatch?</span>
                <a href="<%= request.getContextPath() %>/jsp/register.jsp">Create account</a>
            </div>

            <div class="home-link">
                <a href="<%= request.getContextPath() %>/index.jsp">Visit the home page</a>
            </div>


        </section>
    </div>
</body>
</html>
