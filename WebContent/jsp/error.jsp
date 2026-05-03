<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
    if (error == null) {
        error = (String) request.getAttribute("error");
    }
    if (error == null) {
        error = "An unknown error occurred.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - CivicWatch</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .error-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        .error-icon {
            font-size: 64px;
            color: #c00;
            margin-bottom: 20px;
        }
        h1 {
            color: #1a1a2e;
            margin-bottom: 15px;
        }
        .error-message {
            background: #fee;
            color: #c00;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            border-left: 4px solid #c00;
            text-align: left;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: #1a1a2e;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
        }
        .btn:hover {
            background: #16213e;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">!</div>
        <h1>Oops! Something went wrong</h1>
        <div class="error-message"><%= error %></div>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn">Go to Dashboard</a>
        <br><br>
        <a href="<%= request.getContextPath() %>/jsp/login.jsp" class="btn">Login</a>
    </div>
</body>
</html>
