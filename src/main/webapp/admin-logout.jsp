
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendError(405, "POST method required.");
        return;
    }

    String expectedToken = (String) session.getAttribute("csrfToken");
    String postedToken = request.getParameter("csrfToken");

    if (expectedToken == null || postedToken == null
            || !expectedToken.equals(postedToken)) {
        response.sendError(403, "Invalid security token.");
        return;
    }

    session.invalidate();
    response.sendRedirect("admin-login.jsp");
%>
