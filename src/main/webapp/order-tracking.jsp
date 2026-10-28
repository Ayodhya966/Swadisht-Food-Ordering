
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.swadisht.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Your Order - Swadisht</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #fff7ed;
            color: #333;
        }
        header {
            background: #e85d04;
            color: white;
            padding: 22px;
            text-align: center;
        }
        .container {
            max-width: 650px;
            margin: 40px auto;
            padding: 25px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px #00000015;
        }
        h2 { color: #d9480f; text-align: center; }
        form { display: flex; gap: 10px; margin: 25px 0; }
        input {
            flex: 1;
            min-width: 0;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            background: #e85d04;
            color: white;
            border: 0;
            border-radius: 6px;
            padding: 12px 18px;
            cursor: pointer;
        }
        .result {
            margin-top: 20px;
            padding: 18px;
            background: #fff7ed;
            border-radius: 8px;
            overflow-wrap: anywhere;
        }
        .status { color: #d9480f; font-weight: bold; }
        .error { color: #b91c1c; text-align: center; }
        a { color: #d9480f; }
        @media (max-width: 480px) {
            form { flex-direction: column; }
        }
    </style>
</head>
<body>
<header>
    <h1>Swadisht Food Ordering</h1>
    <p>Track your delicious food order</p>
</header>

<div class="container">
    <h2>Track Your Order</h2>
    <p>Enter your Order ID to check the current status.</p>

    <form method="get" action="order-tracking.jsp">
        <input type="number" name="orderId" min="1"
               placeholder="Enter Order ID" required>
        <button type="submit">Track Order</button>
    </form>

    <%
        String orderIdText = request.getParameter("orderId");

        if (orderIdText != null && orderIdText.matches("\\d+")) {
            String sql = "SELECT o.order_id, o.total_amount, o.order_date, o.status, " +
                         "c.customer_name FROM orders o " +
                         "JOIN customers c ON o.customer_id = c.customer_id " +
                         "WHERE o.order_id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, Integer.parseInt(orderIdText));

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
    %>
        <div class="result">
            <h3>Order Details</h3>
            <p><strong>Order ID:</strong> <%= rs.getInt("order_id") %></p>
            <p><strong>Customer:</strong>
                <%= rs.getString("customer_name") %></p>
            <p><strong>Total:</strong>
                &#8377;<%= rs.getBigDecimal("total_amount") %></p>
            <p><strong>Order Date:</strong>
                <%= rs.getTimestamp("order_date") %></p>
            <p><strong>Status:</strong>
                <span class="status"><%= rs.getString("status") %></span>
            </p>
        </div>
    <%
                    } else {
    %>
        <p class="error">Order ID not found. Please check and try again.</p>
    <%
                    }
                }
            } catch (Exception e) {
                application.log("Unable to track order.", e);
    %>
        <p class="error">Unable to retrieve order details. Please try again later.</p>
    <%
            }
        } else if (orderIdText != null) {
    %>
        <p class="error">Please enter a valid numeric Order ID.</p>
    <%
        }
    %>

    <p><a href="index.jsp">← Back to Home</a></p>
</div>
</body>
</html>
