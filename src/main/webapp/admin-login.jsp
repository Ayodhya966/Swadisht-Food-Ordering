
<%@ page import="com.swadisht.util.AdminAuth" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Arrays" %>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String expectedUsername = System.getenv("SWADISHT_ADMIN_USERNAME");

        if (expectedUsername != null
                && !expectedUsername.isBlank()
                && expectedUsername.equals(username)
                && AdminAuth.verifyPassword(password)) {

            request.changeSessionId();
            session.setAttribute("isAdmin", Boolean.TRUE);

            byte[] csrfBytes = new byte[32];
            new SecureRandom().nextBytes(csrfBytes);
            String csrfToken = Base64.getEncoder()
                    .encodeToString(csrfBytes);
            session.setAttribute("csrfToken", csrfToken);

            response.sendRedirect("admin-dashboard.jsp");
            return;
        }

        request.setAttribute("loginError",
                "Username or password is wrong.");
    }
%>
<!DOCTYPE html>
<html lang="mr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Login - Swadisht</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #fff7ed;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .login-box {
            background: white;
            width: 90%;
            max-width: 390px;
            padding: 28px;
            border-radius: 14px;
            box-shadow: 0 4px 20px #00000018;
        }
        h2 { text-align: center; color: #b45309; }
        label { display: block; margin-top: 16px; }
        input {
            width: 100%;
            padding: 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 7px;
        }
        button {
            width: 100%;
            margin-top: 22px;
            padding: 12px;
            background: #b45309;
            color: white;
            border: 0;
            border-radius: 7px;
            cursor: pointer;
        }
        .error { color: #b91c1c; text-align: center; }
    </style>
</head>
<body>
    <main class="login-box">
        <h2>Swadisht Admin Login</h2>

        <% if (request.getAttribute("loginError") != null) { %>
            <p class="error">Username किंवा password चुकीचा आहे.</p>
        <% } %>

        <form method="post" action="admin-login.jsp">
            <label for="username">Admin Username</label>
            <input id="username" name="username"
                   type="text" autocomplete="username"
                   maxlength="100" required>

            <label for="password">Password</label>
            <input id="password" name="password"
                   type="password"
                   autocomplete="current-password"
                   maxlength="200" required>

            <button type="submit">Login</button>
        </form>
    </main>
</body>
</html>
