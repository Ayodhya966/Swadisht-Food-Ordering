
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.swadisht.util.DBConnection" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String csrfToken = (String) session.getAttribute("csrfToken");
    if (csrfToken == null || csrfToken.isEmpty()) {
        session.invalidate();
        response.sendRedirect("admin-login.jsp");
        return;
    }

    int totalOrders = 0;
    double totalSales = 0.0;

    String searchId = request.getParameter("searchId");
    String filterStatus = request.getParameter("filterStatus");

    boolean hasSearchId = searchId != null
            && searchId.trim().matches("\\d+");

    boolean hasFilterStatus = "Pending".equals(filterStatus)
            || "Preparing".equals(filterStatus)
            || "Out for Delivery".equals(filterStatus)
            || "Delivered".equals(filterStatus);

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swadisht Admin Dashboard</title>

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

        main {
            max-width: 1200px;
            margin: 25px auto;
            padding: 0 18px;
        }

        .dashboard {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin: 20px 0 30px;
        }

        .card {
            background: white;
            border-radius: 10px;
            padding: 22px;
            flex: 1;
            min-width: 200px;
            box-shadow: 0 3px 12px #00000012;
        }

        .card h3 { color: #777; margin-top: 0; }

        .card p {
            font-size: 27px;
            font-weight: bold;
            color: #e85d04;
            margin-bottom: 0;
        }

        .online { color: #16803c !important; }

        .message {
            background: #dcfce7;
            color: #166534;
            padding: 14px;
            border-radius: 7px;
            margin: 15px 0;
        }

        .search-form {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin: 20px 0;
            background: white;
            padding: 18px;
            border-radius: 10px;
        }

        input, select, button, .clear-button {
            padding: 11px 13px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        input { min-width: 170px; }

        button {
            background: #e85d04;
            color: white;
            border: none;
            cursor: pointer;
        }

        button:hover { background: #c94c00; }

        .clear-button {
            background: #eee;
            color: #333;
            text-decoration: none;
            display: inline-block;
        }

        .table-container {
            background: white;
            padding: 15px;
            border-radius: 10px;
            overflow-x: auto;
            box-shadow: 0 3px 12px #00000012;
        }

        table {
            width: 100%;
            min-width: 950px;
            border-collapse: collapse;
        }

        th, td {
            padding: 13px 10px;
            border-bottom: 1px solid #eee;
            text-align: left;
            vertical-align: middle;
        }

        th { background: #fff0e1; color: #8a3500; }
        tr:hover { background: #fffaf5; }

        .status-form {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 145px;
        }

        .status-form select,
        .status-form button { width: 100%; }

        .empty { text-align: center; padding: 25px; }

        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 15px;
            border-radius: 7px;
        }

        .logout-area {
            text-align: center;
            margin: 25px auto;
        }

        .logout-button {
            background: #991b1b;
            padding: 12px 28px;
            font-weight: bold;
        }

        .logout-button:hover { background: #7f1d1d; }

        footer {
            text-align: center;
            padding: 25px;
            color: #777;
        }

        @media (max-width: 600px) {
            main { padding: 0 10px; }

            .search-form { flex-direction: column; }

            .search-form input,
            .search-form select,
            .search-form button,
            .search-form a { width: 100%; }
        }
    </style>
</head>

<body>

<header>
    <h1>Swadisht Admin Dashboard</h1>
    <p>Manage Food Orders and Customer Details</p>
</header>

<main>

    <% if ("1".equals(request.getParameter("updated"))) { %>
        <div class="message">Order status updated successfully!</div>
    <% } %>

    <div class="dashboard">

        <div class="card">
            <h3>Total Orders</h3>
            <p>
                <%
                    try (Connection c = DBConnection.getConnection();
                         PreparedStatement p = c.prepareStatement(
                             "SELECT COUNT(*) FROM orders");
                         ResultSet r = p.executeQuery()) {
                        if (r.next()) totalOrders = r.getInt(1);
                    } catch (Exception e) {
                        application.log("Unable to count orders", e);
                    }
                %>
                <%= totalOrders %>
            </p>
        </div>

        <div class="card">
            <h3>Total Sales</h3>
            <p>
                <%
                    try (Connection c = DBConnection.getConnection();
                         PreparedStatement p = c.prepareStatement(
                             "SELECT COALESCE(SUM(total_amount), 0) FROM orders");
                         ResultSet r = p.executeQuery()) {
                        if (r.next()) totalSales = r.getDouble(1);
                    } catch (Exception e) {
                        application.log("Unable to calculate sales", e);
                    }
                %>
                &#8377;<%= String.format(java.util.Locale.US, "%.2f", totalSales) %>
            </p>
        </div>

        <div class="card">
            <h3>System Status</h3>
            <p class="online">Online</p>
        </div>

    </div>

    <h2>All Orders</h2>

    <form method="get" action="admin.jsp" class="search-form">
        <input type="number"
               name="searchId"
               min="1"
               placeholder="Search by Order ID"
               value="<%= hasSearchId ? searchId : "" %>">

        <select name="filterStatus">
            <option value="">All Statuses</option>
            <option value="Pending" <%= "Pending".equals(filterStatus) ? "selected" : "" %>>Pending</option>
            <option value="Preparing" <%= "Preparing".equals(filterStatus) ? "selected" : "" %>>Preparing</option>
            <option value="Out for Delivery" <%= "Out for Delivery".equals(filterStatus) ? "selected" : "" %>>Out for Delivery</option>
            <option value="Delivered" <%= "Delivered".equals(filterStatus) ? "selected" : "" %>>Delivered</option>
        </select>

        <button type="submit">Search</button>
        <a class="clear-button" href="admin.jsp">Clear</a>
    </form>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Phone</th>
                    <th>Food Items</th>
                    <th>Quantity</th>
                    <th>Total Amount</th>
                    <th>Order Date</th>
                    <th>Status / Update</th>
                </tr>
            </thead>

            <tbody>
            <%
                StringBuilder sql = new StringBuilder(
                    "SELECT o.order_id, c.customer_name, c.phone, " +
                    "GROUP_CONCAT(oi.food_name SEPARATOR ', ') AS foods, " +
                    "COALESCE(SUM(oi.quantity), 0) AS qty, " +
                    "o.total_amount, o.order_date, o.status " +
                    "FROM orders o " +
                    "LEFT JOIN customers c ON o.customer_id = c.customer_id " +
                    "LEFT JOIN order_items oi ON o.order_id = oi.order_id "
                );

                if (hasSearchId || hasFilterStatus) {
                    sql.append("WHERE ");
                    if (hasSearchId) sql.append("o.order_id = ? ");
                    if (hasSearchId && hasFilterStatus) sql.append("AND ");
                    if (hasFilterStatus) sql.append("o.status = ? ");
                }

                sql.append(
                    "GROUP BY o.order_id, c.customer_name, c.phone, " +
                    "o.total_amount, o.order_date, o.status " +
                    "ORDER BY o.order_id DESC"
                );

                boolean found = false;

                try (Connection c = DBConnection.getConnection();
                     PreparedStatement p = c.prepareStatement(sql.toString())) {

                    int index = 1;

                    if (hasSearchId) {
                        p.setInt(index++, Integer.parseInt(searchId.trim()));
                    }

                    if (hasFilterStatus) {
                        p.setString(index++, filterStatus);
                    }

                    try (ResultSet r = p.executeQuery()) {
                        while (r.next()) {
                            found = true;

                            int orderId = r.getInt("order_id");
                            String customerName = r.getString("customer_name");
                            String phone = r.getString("phone");
                            String foods = r.getString("foods");
                            int quantity = r.getInt("qty");
                            double amount = r.getDouble("total_amount");
                            Timestamp orderDate = r.getTimestamp("order_date");
                            String currentStatus = r.getString("status");

                            if (customerName == null) customerName = "-";
                            if (phone == null) phone = "-";
                            if (foods == null) foods = "-";
                            if (currentStatus == null) currentStatus = "Pending";
            %>
                <tr>
                    <td><%= orderId %></td>
                    <td><%= customerName %></td>
                    <td><%= phone %></td>
                    <td><%= foods %></td>
                    <td><%= quantity %></td>
                    <td>&#8377;<%= String.format(java.util.Locale.US, "%.2f", amount) %></td>
                    <td><%= orderDate == null ? "-" : orderDate %></td>
                    <td>
                        <form action="update-order-status"
                              method="post"
                              class="status-form">
                            <input type="hidden" name="orderId" value="<%= orderId %>">

                            <select name="status" required>
                                <option value="Pending" <%= "Pending".equals(currentStatus) ? "selected" : "" %>>Pending</option>
                                <option value="Preparing" <%= "Preparing".equals(currentStatus) ? "selected" : "" %>>Preparing</option>
                                <option value="Out for Delivery" <%= "Out for Delivery".equals(currentStatus) ? "selected" : "" %>>Out for Delivery</option>
                                <option value="Delivered" <%= "Delivered".equals(currentStatus) ? "selected" : "" %>>Delivered</option>
                            </select>

                            <button type="submit">Update Status</button>
                        </form>
                    </td>
                </tr>
            <%
                        }
                    }

                    if (!found) {
            %>
                <tr>
                    <td colspan="8" class="empty">
                        No orders found. Try another Order ID or Status.
                    </td>
                </tr>
            <%
                    }

                } catch (Exception e) {
                    application.log("Admin Panel error", e);
            %>
                <tr>
                    <td colspan="8">
                        <p class="error">
                            Could not load orders. Please check the database
                            connection and Tomcat logs.
                        </p>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <div class="logout-area">
        <form action="admin-logout.jsp" method="post">
            <input type="hidden" name="csrfToken"
                   value="<%= csrfToken %>">
            <button class="logout-button" type="submit">Logout</button>
        </form>
    </div>

</main>

<footer>
    Swadisht Food Ordering System
</footer>

</body>
</html>
