package com.course.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBConnection.java
 * -----------------
 * Utility class to provide MySQL database connections.
 * Uses a static method so all servlets can reuse it.
 */
public class DBConnection {    private static final Logger logger = Logger.getLogger(DBConnection.class.getName());
    // ── DATABASE CONFIGURATION ────────────────────────────────────────────────
    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/course_registration"
            + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static final String DB_USER = "root";       // change if needed
    private static final String DB_PASSWORD = "root";   // 🔴 change this to your real password
    // ─────────────────────────────────────────────────────────────────────────

    // Load MySQL JDBC Driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[DBConnection] MySQL Driver Loaded Successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection ERROR] MySQL JDBC Driver NOT FOUND!");
            System.err.println("➡ Make sure mysql-connector-j.jar is inside WEB-INF/lib");
            logger.log(Level.SEVERE, "MySQL JDBC Driver not found", e);
        }
    }

    /**
     * Get database connection
     */
    public static Connection getConnection() {
        try {
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            if (con != null) {
                System.out.println("[DBConnection] Connected to database successfully");
            }

            return con;

        } catch (SQLException e) {
            System.err.println("[DBConnection ERROR] Failed to connect to database!");
            System.err.println("➡ Check:");
            System.err.println("   1. MySQL is running");
            System.err.println("   2. Database name is correct");
            System.err.println("   3. Username/password are correct");
            logger.log(Level.SEVERE, "Failed to connect to database", e);
            return null;
        }
    }
}