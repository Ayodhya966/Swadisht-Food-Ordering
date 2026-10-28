package com.swadisht.servlet;

import com.swadisht.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/update-order-status")
public class UpdateOrderStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");
HttpSession adminSession = request.getSession(false);

if (adminSession == null ||
        !Boolean.TRUE.equals(adminSession.getAttribute("isAdmin"))) {
    response.sendRedirect("admin-login.jsp");
    return;
}
        String orderIdText = request.getParameter("orderId");
        

        String status = request.getParameter("status");

        String[] allowedStatuses = {
            "Pending",
            "Preparing",
            "Out for Delivery",
            "Delivered"
        };

        boolean validStatus = false;

        if (status != null) {
            for (String allowed : allowedStatuses) {
                if (allowed.equals(status)) {
                    validStatus = true;
                    break;
                }
            }
        }

        if (orderIdText == null || !orderIdText.matches("\\d+")
                || !validStatus) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid order ID or status.");
            return;
        }

        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(orderIdText));

            int updated = ps.executeUpdate();

           if (updated > 0) {
    response.sendRedirect("admin.jsp?updated=1");
} else {
    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
    response.getWriter().write("Order not found.");
}

} catch (SQLException e) {
    getServletContext().log("Unable to update order status.", e);
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    response.getWriter().write("Could not update order status.");
}
}
}

