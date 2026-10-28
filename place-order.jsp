
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.swadisht.util.DBConnection" %>

<%!
    public String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
request.setCharacterEncoding("UTF-8");

String message = "";
String customerName = "";
String phone = "";
String address = "";
String foodName = "";
String quantityText = "";
String orderTotal = "";
String unitPrice = "";

int quantity = 0;
int newOrderId = 0;

if ("POST".equalsIgnoreCase(request.getMethod())) {

    customerName = request.getParameter("customerName");
    phone = request.getParameter("phone");
    address = request.getParameter("address");
    foodName = request.getParameter("foodName");
    quantityText = request.getParameter("quantity");

    try {
        if (customerName == null || customerName.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()
                || quantityText == null) {
            throw new IllegalArgumentException(
                "Please fill in all fields."
            );
        }

        customerName = customerName.trim();
        phone = phone.trim();
        address = address.trim();

        if (customerName.length() > 100
                || phone.length() > 15
                || address.length() > 255) {
            throw new IllegalArgumentException(
                "Please check the length of your information."
            );
        }

        quantity = Integer.parseInt(quantityText);

        if (quantity < 1 || quantity > 50) {
            throw new IllegalArgumentException(
                "Quantity must be between 1 and 50."
            );
        }

        BigDecimal price;

        // Server-side price validation
        switch (foodName == null ? "" : foodName) {

            case "Cheese Pizza":
                price = new BigDecimal("150.00");
                break;

            case "Samosa":
                price = new BigDecimal("30.00");
                break;

            case "Paneer Curry":
                price = new BigDecimal("100.00");
                break;

            case "Veg Biryani":
                price = new BigDecimal("120.00");
                break;

            case "Chicken Curry":
                price = new BigDecimal("180.00");
                break;

            case "Chicken Biryani":
                price = new BigDecimal("200.00");
                break;

            default:
                throw new IllegalArgumentException(
                    "Please select a valid food item."
                );
        }

        BigDecimal total =
            price.multiply(BigDecimal.valueOf(quantity));

        unitPrice = price.toPlainString();
        orderTotal = total.toPlainString();

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                int customerId;

                // Save customer details
                try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO customers " +
                    "(customer_name, phone, address) VALUES (?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS)) {

                    ps.setString(1, customerName);
                    ps.setString(2, phone);
                    ps.setString(3, address);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException(
                                "Could not create customer."
                            );
                        }

                        customerId = keys.getInt(1);
                    }
                }

                // Save order
                try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO orders " +
                    "(customer_id, total_amount, status) " +
                    "VALUES (?, ?, 'Pending')",
                    Statement.RETURN_GENERATED_KEYS)) {

                    ps.setInt(1, customerId);
                    ps.setBigDecimal(2, total);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException(
                                "Could not create order."
                            );
                        }

                        newOrderId = keys.getInt(1);
                    }
                }

                // Save ordered food item
                try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO order_items " +
                    "(order_id, food_name, quantity, price) " +
                    "VALUES (?, ?, ?, ?)")) {

                    ps.setInt(1, newOrderId);
                    ps.setString(2, foodName);
                    ps.setInt(3, quantity);
                    ps.setBigDecimal(4, price);
                    ps.executeUpdate();
                }

                con.commit();
                message = "success";

            } catch (Exception e) {
                con.rollback();
                throw e;

            } finally {
                con.setAutoCommit(true);
            }
        }

    } catch (NumberFormatException e) {
        message = "Please enter a valid quantity.";

    } catch (IllegalArgumentException e) {
        message = e.getMessage();

    } catch (Exception e) {
        application.log("Unable to place order.", e);
        message =
            "Order could not be saved. Please check the database connection.";
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Place Order - Swadisht Food Ordering</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #fff8f0;
            color: #333;
        }

        header {
            background: #e87522;
            color: white;
            text-align: center;
            padding: 25px 15px;
        }

        header h1 {
            margin: 0 0 8px;
        }

        .container {
            max-width: 700px;
            margin: 30px auto;
            padding: 25px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 14px rgba(0,0,0,0.1);
        }

        h2 {
            color: #d96316;
        }

        label {
            display: block;
            margin-top: 16px;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
        }

        button, .button-link {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 18px;
            background: #e87522;
            color: white;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover, .button-link:hover {
            background: #c95d12;
        }

        .success {
            border: 1px solid #b9dfc5;
            background: #f0fff4;
            padding: 20px;
            border-radius: 10px;
        }

        .error {
            background: #fff0f0;
            border: 1px solid #e5aaaa;
            padding: 12px;
            border-radius: 6px;
            color: #a00000;
        }

        .bill-title {
            text-align: center;
            border-bottom: 2px dashed #e87522;
            padding-bottom: 15px;
        }

        .bill-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .bill-table th, .bill-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        .bill-table th {
            background: #fff0df;
        }

        .total {
            text-align: right;
            font-size: 20px;
            font-weight: bold;
            margin-top: 20px;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #c95d12;
            text-decoration: none;
        }

        @media print {
            body {
                background: white;
            }

            header, .no-print, .back-link {
                display: none !important;
            }

            .container {
                max-width: 100%;
                margin: 0;
                padding: 0;
                box-shadow: none;
            }

            .success {
                border: none;
                background: white;
            }

            .bill-table th {
                background: #eee !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
        }
    </style>
</head>

<body>

<header>
    <h1>Swadisht Food Ordering</h1>
    <p>Fresh Food, Happy Mood!</p>
</header>

<div class="container">

<% if ("success".equals(message)) { %>

    <div class="success">

        <div class="bill-title">
            <h2>Swadisht Food Ordering</h2>
            <p>Order Receipt / Bill</p>
            <h3>Order Placed Successfully!</h3>
        </div>

        <p><strong>Order ID:</strong> <%= newOrderId %></p>
        <p><strong>Customer Name:</strong> <%= escapeHtml(customerName) %></p>
        <p><strong>Phone Number:</strong> <%= escapeHtml(phone) %></p>
        <p><strong>Delivery Address:</strong> <%= escapeHtml(address) %></p>
        <p><strong>Status:</strong> Pending</p>

        <table class="bill-table">
            <thead>
                <tr>
                    <th>Food Item</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Amount</th>
                </tr>
            </thead>

            <tbody>
                <tr>
                    <td><%= escapeHtml(foodName) %></td>
                    <td><%= quantity %></td>
                    <td>&#8377;<%= unitPrice %></td>
                    <td>&#8377;<%= orderTotal %></td>
                </tr>
            </tbody>
        </table>

        <p class="total">
            Total Amount: &#8377;<%= orderTotal %>
        </p>

        <p>Thank you for ordering with Swadisht!</p>
        <p>Your order has been saved successfully.</p>

        <div class="no-print">
            <button type="button" onclick="window.print()">
                Print Bill
            </button>

            <a class="button-link"
               href="order-tracking.jsp?orderId=<%= newOrderId %>">
                Track Your Order
            </a>

            <a class="button-link" href="place-order.jsp">
                Place Another Order
            </a>
        </div>

    </div>

<% } else { %>

    <% if (!message.isEmpty()) { %>
        <p class="error"><%= escapeHtml(message) %></p>
    <% } %>

    <h2>Order Information</h2>

    <form method="post" action="place-order.jsp">

        <label for="customerName">Customer Name</label>
        <input id="customerName" name="customerName"
               type="text" maxlength="100" required>

        <label for="phone">Phone Number</label>
        <input id="phone" name="phone"
               type="tel" maxlength="15"
               placeholder="Enter phone number" required>

        <label for="address">Delivery Address</label>
        <input id="address" name="address"
               type="text" maxlength="255"
               placeholder="Enter delivery address" required>

        <label for="foodName">Select Food</label>

        <select id="foodName" name="foodName" required>
            <option value="">-- Select Food Category and Item --</option>

            <optgroup label="🥦 Vegetarian (Veg)">
                <option value="Cheese Pizza">Cheese Pizza - &#8377;150</option>
                <option value="Samosa">Samosa - &#8377;30</option>
                <option value="Paneer Curry">Paneer Curry - &#8377;100</option>
                <option value="Veg Biryani">Veg Biryani - &#8377;120</option>
            </optgroup>

            <optgroup label="🍗 Non-Vegetarian (Non-Veg)">
                <option value="Chicken Curry">Chicken Curry - &#8377;180</option>
                <option value="Chicken Biryani">Chicken Biryani - &#8377;200</option>
            </optgroup>
        </select>

        <label for="quantity">Quantity</label>
        <input id="quantity" name="quantity"
               type="number" min="1" max="50"
               value="1" required>

        <button type="submit">Place Order</button>

    </form>

<% } %>

    <a class="back-link" href="index.jsp">&#8592; Back to Home</a>

</div>

</body>
</html>
