package com.swadisht.servlet;

import com.swadisht.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/place-order")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        String name = request.getParameter("customerName");
        String phone = request.getParameter("customerPhone");
        String address = request.getParameter("customerAddress");

        String[] foodNames = request.getParameterValues("foodName");
        String[] quantities = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("price");

        PrintWriter out = response.getWriter();

        if (name == null || name.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()
                || foodNames == null || quantities == null
                || prices == null
                || foodNames.length != quantities.length
                || foodNames.length != prices.length) {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Please enter customer details and food items.");
            return;
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            int customerId;

            String customerSql =
                    "INSERT INTO customers (customer_name, phone, address) "
                    + "VALUES (?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(
                    customerSql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, name.trim());
                ps.setString(2, phone.trim());
                ps.setString(3, address.trim());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new java.sql.SQLException(
                                "Customer ID was not generated.");
                    }
                    customerId = rs.getInt(1);
                }
            }

            double total = 0;

            for (int i = 0; i < foodNames.length; i++) {
                int qty = Integer.parseInt(quantities[i]);
                double price = Double.parseDouble(prices[i]);

                if (qty <= 0 || price < 0) {
                    throw new IllegalArgumentException("Invalid food item.");
                }

                total += qty * price;
            }

            int orderId;

            String orderSql =
                    "INSERT INTO orders (customer_id, total_amount) VALUES (?, ?)";

            try (PreparedStatement ps = con.prepareStatement(
                    orderSql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, customerId);
                ps.setDouble(2, total);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new java.sql.SQLException(
                                "Order ID was not generated.");
                    }
                    orderId = rs.getInt(1);
                }
            }

            String itemSql =
                    "INSERT INTO order_items "
                    + "(order_id, food_name, quantity, price) "
                    + "VALUES (?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(itemSql)) {
                for (int i = 0; i < foodNames.length; i++) {
                    ps.setInt(1, orderId);
                    ps.setString(2, foodNames[i]);

                    int qty = Integer.parseInt(quantities[i]);
                    double price = Double.parseDouble(prices[i]);

                    ps.setInt(3, qty);
                    ps.setDouble(4, price);
                    ps.addBatch();
                }

                ps.executeBatch();
            }

            con.commit();
            out.print("SUCCESS:" + orderId);

        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception ignored) {
                    // Rollback failed.
                }
            }

            getServletContext().log("Unable to save food order.", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("ERROR:Order could not be saved. Please try again.");

        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (Exception ignored) {
                    // Connection close failed.
                }
            }
        }
    }
}

