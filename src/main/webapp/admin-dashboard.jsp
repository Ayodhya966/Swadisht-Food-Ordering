<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page import="com.swadisht.util.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }

        String text = String.valueOf(value);
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
%>

<%
    if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String csrfToken = (String) session.getAttribute("csrfToken");

    if (csrfToken == null || csrfToken.isEmpty()) {
        response.sendError(
            HttpServletResponse.SC_FORBIDDEN,
            "Session security token is missing. Please log in again."
        );
        return;
    }

    List<String> allowedStatuses = Arrays.asList(
        "Pending",
        "Preparing",
        "Out for Delivery",
        "Delivered",
        "Cancelled"
    );

    String message = "";
    String errorMessage = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String submittedToken = request.getParameter("csrfToken");

        if (submittedToken == null ||
            !java.security.MessageDigest.isEqual(
                csrfToken.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                submittedToken.getBytes(java.nio.charset.StandardCharsets.UTF_8))) {

            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Invalid security token. Please refresh the page."
            );
            return;
        }

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            String orderIdText = request.getParameter("orderId");
            String newStatus = request.getParameter("status");

            try {
                int orderId = Integer.parseInt(orderIdText);

                if (orderId <= 0 || !allowedStatuses.contains(newStatus)) {
                    errorMessage = "Invalid order ID or status.";
                } else {
                    String sql =
                        "UPDATE orders SET status = ? WHERE order_id = ?";

                    try (Connection connection = DBConnection.getConnection();
                         PreparedStatement statement =
                             connection.prepareStatement(sql)) {

                        statement.setString(1, newStatus);
                        statement.setInt(2, orderId);

                        int updated = statement.executeUpdate();

                        if (updated > 0) {
                            message = "Order status updated successfully.";
                        } else {
                            errorMessage = "Order not found.";
                        }
                    }
                }
            } catch (NumberFormatException e) {
                errorMessage = "Invalid order ID.";
            } catch (SQLException e) {
                application.log("Order status update failed.", e);
                errorMessage = "Unable to update order status. Please check the database connection.";
            }
        } else if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("admin-login.jsp");
            return;
        } else {
            errorMessage = "Invalid request.";
        }
    }

    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Swadisht Food Ordering</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 24px;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            color: #222;
        }

        .container {
            max-width: 1200px;
            margin: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 24px;
        }

        h1 {
            margin: 0;
            color: #8b2e16;
        }

        .logout-button,
        .update-button {
            border: none;
            padding: 10px 14px;
            border-radius: 5px;
            cursor: pointer;
            color: white;
            background: #8b2e16;
        }

        .logout-button:hover,
        .update-button:hover {
            background: #64200f;
        }

        .card {
            padding: 20px;
            margin-bottom: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .message {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 16px;
            background: #e5f6e8;
            color: #185c28;
        }

        .error {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 16px;
            background: #fde8e8;
            color: #922020;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 750px;
        }

        th,
        td {
            padding: 13px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #8b2e16;
            color: white;
        }

        select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .empty {
            text-align: center;
            padding: 25px;
            color: #666;
        }

        @media (max-width: 600px) {
            body {
                padding: 12px;
            }
        }
    </style>
</head>

<body>
<div class="container">

    <div class="header">
        <h1>Admin Dashboard</h1>

        <form method="post" action="admin-dashboard.jsp">
            <input type="hidden" name="csrfToken"
                   value="<%= escapeHtml(csrfToken) %>">
            <input type="hidden" name="action" value="logout">
            <button class="logout-button" type="submit">Logout</button>
        </form>
    </div>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= escapeHtml(message) %></div>
    <% } %>

    <% if (!errorMessage.isEmpty()) { %>
        <div class="error"><%= escapeHtml(errorMessage) %></div>
    <% } %>

    <div class="card">
        <h2>Customer Orders</h2>
        <p>View orders and update their delivery status.</p>

        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer ID</th>
                    <th>Total Amount</th>
                    <th>Order Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                </thead>

                <tbody>
                <%
                    String sql =
                        "SELECT order_id, customer_id, total_amount, " +
                        "order_date, status FROM orders ORDER BY order_date DESC";

                    try (Connection connection = DBConnection.getConnection();
                         PreparedStatement statement =
                             connection.prepareStatement(sql);
                         ResultSet rs = statement.executeQuery()) {

                        boolean foundOrders = false;

                        while (rs.next()) {
                            foundOrders = true;

                            int orderId = rs.getInt("order_id");
                            int customerId = rs.getInt("customer_id");
                            boolean customerIdIsNull = rs.wasNull();

                            java.math.BigDecimal amount =
                                rs.getBigDecimal("total_amount");

                            java.sql.Timestamp orderDate =
                                rs.getTimestamp("order_date");

                            String currentStatus = rs.getString("status");

                            if (currentStatus == null) {
                                currentStatus = "Pending";
                            }
                %>
                <tr>
                    <td><%= orderId %></td>

                    <td>
                        <%= customerIdIsNull ? "N/A" : String.valueOf(customerId) %>
                    </td>

                    <td>
                        <%= amount == null ? "N/A" : escapeHtml(amount) %>
                    </td>

                    <td>
                        <%= orderDate == null ? "N/A" : escapeHtml(orderDate) %>
                    </td>

                    <td><%= escapeHtml(currentStatus) %></td>

                    <td>
                        <form method="post" action="admin-dashboard.jsp">
                            <input type="hidden" name="csrfToken"
                                   value="<%= escapeHtml(csrfToken) %>">

                            <input type="hidden" name="action"
                                   value="updateStatus">

                            <input type="hidden" name="orderId"
                                   value="<%= orderId %>">

                            <select name="status" required>
                                <% for (String status : allowedStatuses) { %>
                                    <option value="<%= escapeHtml(status) %>"
                                        <%= status.equals(currentStatus) ? "selected" : "" %>>
                                        <%= escapeHtml(status) %>
                                    </option>
                                <% } %>
                            </select>

                            <button type="submit" class="update-button">
                                Update
                            </button>
                        </form>
                    </td>
                </tr>
                <%
                        }

                        if (!foundOrders) {
                %>
                    <tr>
                        <td colspan="6" class="empty">
                            No orders found.
                        </td>
                    </tr>
                <%
                        }

                    } catch (Exception e) {
                        application.log("Admin dashboard order load failed.", e);
                %>
                    <tr>
                        <td colspan="6" class="empty">
                            Unable to load orders. Please check the database connection.
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>
</body>
</html>
