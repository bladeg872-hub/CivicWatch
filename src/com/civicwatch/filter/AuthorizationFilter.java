package com.civicwatch.filter;

import com.civicwatch.model.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class AuthorizationFilter implements Filter {

    private static final Map<String, Set<String>> ROLE_PERMISSIONS = new HashMap<>();

    static {
        Set<String> adminPermissions = new HashSet<>();
        adminPermissions.add("/admin");
        adminPermissions.add("/dashboard");
        adminPermissions.add("/reports");
        adminPermissions.add("/report");
        adminPermissions.add("/users");
        adminPermissions.add("/categories");
        ROLE_PERMISSIONS.put("ADMIN", adminPermissions);

        Set<String> residentPermissions = new HashSet<>();
        residentPermissions.add("/dashboard");
        residentPermissions.add("/reports");
        residentPermissions.add("/report");
        residentPermissions.add("/create");
        ROLE_PERMISSIONS.put("RESIDENT", residentPermissions);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        if (path.equals("/jsp/login.jsp") || path.equals("/jsp/register.jsp") ||
            path.equals("/jsp/error.jsp") || path.startsWith("/css/") ||
            path.startsWith("/js/") || path.startsWith("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        path = path.replaceAll("/.*", "");

        if (path.isEmpty() || path.equals("/")) {
            path = "/";
        }

        HttpSession session = httpRequest.getSession(false);
        if (session == null) {
            httpResponse.sendRedirect(contextPath + "/jsp/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            httpResponse.sendRedirect(contextPath + "/jsp/login.jsp");
            return;
        }

        String userRole = user.getRole();
        Set<String> allowedPaths = ROLE_PERMISSIONS.get(userRole);

        if (allowedPaths == null) {
            allowedPaths = new HashSet<>();
        }

        if (hasPermission(path, allowedPaths)) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(contextPath + "/jsp/error.jsp?error=unauthorized");
        }
    }

    private boolean hasPermission(String path, Set<String> allowedPaths) {
        if (allowedPaths.contains(path)) {
            return true;
        }

        for (String allowed : allowedPaths) {
            if (path.startsWith(allowed)) {
                return true;
            }
        }

        return path.equals("/") || path.isEmpty();
    }

    @Override
    public void destroy() {
    }
}
