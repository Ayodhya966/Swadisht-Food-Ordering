
package com.swadisht.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            System.getenv().getOrDefault(
                    "SWADISHT_DB_URL",
                    "jdbc:mysql://localhost:3306/swadisht_db"
            );

    private static final String USER =
            System.getenv("SWADISHT_DB_USER");

    private static final String PASSWORD =
            System.getenv("SWADISHT_DB_PASSWORD");

    public static Connection getConnection() throws SQLException {

        if (USER == null || USER.isBlank()
                || PASSWORD == null || PASSWORD.isBlank()) {
            throw new SQLException(
                    "Database credentials are not configured. "
                    + "Set SWADISHT_DB_USER and SWADISHT_DB_PASSWORD."
            );
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL JDBC Driver not found. Check pom.xml.",
                    e
            );
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void main(String[] args) {
        try (Connection connection = getConnection()) {
            System.out.println("Database Connected Successfully!");
        } catch (SQLException e) {
            System.out.println("Database Connection Failed!");
            System.err.println(e.getMessage());
        }
    }
}

