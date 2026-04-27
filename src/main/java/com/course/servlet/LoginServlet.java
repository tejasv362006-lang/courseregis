package com.course.servlet;

import com.course.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/**
 * LoginServlet.java
 * -----------------
 * Handles user authentication.
 *
 * GET  /login  → show the login form (login.jsp)
 * POST /login  → validate credentials, create session, redirect to dashboard
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // ── GET – display the login form ──────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    // ── POST – authenticate the user ──────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Read form parameters
        String email    = req.getParameter("email").trim().toLowerCase();
        String password = req.getParameter("password").trim();

        // 2. Basic validation
        if (email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 3. Query the database – use PreparedStatement to prevent SQL injection
        String sql = "SELECT id, name, email FROM users WHERE email = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password); // In production: verify BCrypt hash

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    // 4. Credentials are valid → create an HTTP session
                    HttpSession session = req.getSession(true);        // create new session
                    session.setAttribute("userId",   rs.getInt("id"));
                    session.setAttribute("userName", rs.getString("name"));
                    session.setAttribute("userEmail",rs.getString("email"));
                    session.setMaxInactiveInterval(30 * 60);           // 30-minute timeout

                    // 5. Redirect to the dashboard
                    resp.sendRedirect(req.getContextPath() + "/dashboard");

                } else {
                    // Invalid credentials
                    req.setAttribute("error", "Invalid email or password. Please try again.");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error. Please try again later.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
