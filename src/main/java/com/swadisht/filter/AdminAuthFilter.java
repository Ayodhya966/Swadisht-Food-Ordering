package com.swadisht.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Admin pages ani admin servlets sathi ek central login check.
 * URL mapping web.xml madhe aahe. Login nasel tar admin-login.jsp la redirect.
 */
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Admin pages browser/proxy cache madhe rahu naye (logout nantar Back button sathi pan)
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false); // navin session banvat nahi
        boolean loggedIn = session != null
                && Boolean.TRUE.equals(session.getAttribute("isAdmin"));

        if (!loggedIn) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        chain.doFilter(req, res);
    }
}