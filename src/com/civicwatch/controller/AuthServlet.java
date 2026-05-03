package com.civicwatch.controller;

import com.civicwatch.model.User;
import com.civicwatch.service.AuthService;
import com.civicwatch.service.UserService;
import com.civicwatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthServlet extends HttpServlet {

    private AuthService authService;
    private UserService userService;

    private static String firstNonEmptyParameter(HttpServletRequest request, String name) {
        String[] values = request.getParameterValues(name);
        if (values == null) {
            return null;
        }
        for (String v : values) {
            if (v != null && !v.isEmpty()) {
                return v;
            }
        }
        return null;
    }

    @Override
    public void init() throws ServletException {
        this.authService = new AuthService();
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String contextPath = request.getContextPath();

        if (action == null) {
            action = "login";
        }

        switch (action) {
            case "logout":
                handleLogout(request, response, contextPath);
                break;
            case "register":
                response.sendRedirect(contextPath + "/jsp/register.jsp");
                break;
            default:
                response.sendRedirect(contextPath + "/jsp/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String contextPath = request.getContextPath();

        if (action == null) {
            action = "login";
        }

        try {
            switch (action) {
                case "login":
                    handleLogin(request, response, contextPath);
                    break;
                case "register":
                    handleRegister(request, response, contextPath);
                    break;
                case "changePassword":
                    handleChangePassword(request, response, contextPath);
                    break;
                default:
                    response.sendRedirect(contextPath + "/jsp/login.jsp");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            if (action.equals("register")) {
                request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, String contextPath)
            throws Exception {
        String username = request.getParameter("username");
        String password = firstNonEmptyParameter(request, "password");

        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }

        User user = authService.login(username, password);

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(30 * 60);

        String redirectPath = contextPath + "/dashboard";
        if (user.isAdmin()) {
            redirectPath = contextPath + "/admin?action=dashboard";
        } else if (user.isCoordinator()) {
            redirectPath = contextPath + "/dashboard?role=coordinator";
        } else {
            redirectPath = contextPath + "/dashboard?role=resident";
        }

        response.sendRedirect(redirectPath);
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, String contextPath)
            throws Exception {
        String username = request.getParameter("username");
        String password = firstNonEmptyParameter(request, "password");
        String confirmPassword = firstNonEmptyParameter(request, "confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        if (!ValidationUtil.isValidUsername(username)) {
            throw new IllegalArgumentException("Username must be 3-50 characters (letters, numbers, underscores)");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }
        if (!password.equals(confirmPassword)) {
            throw new IllegalArgumentException("Passwords do not match");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Valid email is required");
        }
        if (!ValidationUtil.isValidFullName(fullName)) {
            throw new IllegalArgumentException("Full name must be 2-100 characters");
        }

        authService.register(username, password, email, fullName);

        response.sendRedirect(contextPath + "/jsp/login.jsp?registered=true");
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, String contextPath)
            throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(contextPath + "/jsp/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String currentPassword = firstNonEmptyParameter(request, "currentPassword");
        String newPassword = firstNonEmptyParameter(request, "newPassword");
        String confirmPassword = firstNonEmptyParameter(request, "confirmPassword");

        if (!ValidationUtil.isValidPassword(newPassword)) {
            throw new IllegalArgumentException("New password must be at least 6 characters");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("New passwords do not match");
        }

        boolean changed = authService.changePassword(user.getId(), currentPassword, newPassword);
        if (!changed) {
            throw new IllegalArgumentException("Failed to change password");
        }

        response.sendRedirect(contextPath + "/dashboard?passwordChanged=true");
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response, String contextPath)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(contextPath + "/jsp/login.jsp?loggedOut=true");
    }
}
