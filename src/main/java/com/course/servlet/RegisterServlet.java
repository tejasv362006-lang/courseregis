package com.course.servlet;

import com.course.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/**
 * RegisterServlet.java
 * --------------------
 * Handles new user registration.
 *
 * GET  /register  → show the registration form (register.jsp)
 * POST /register  → validate input, insert user into DB, redirect to login
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    // ── GET – display the registration form ───────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    // ── POST – process the submitted form ─────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Read form parameters
        String name     = req.getParameter("name").trim();
        String email    = req.getParameter("email").trim().toLowerCase();
        String password = req.getParameter("password").trim();

        // 2. Basic server-side validation
        if (name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 3. Insert user into the database using PreparedStatement
        String sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password); // In production: hash with BCrypt

            ps.executeUpdate();

            // 4. Success – redirect to login with a success flag
            resp.sendRedirect(req.getContextPath() + "/login?registered=true");

        } catch (SQLIntegrityConstraintViolationException e) {
            // Email already exists (UNIQUE constraint violated)
            req.setAttribute("error", "An account with this email already exists.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error. Please try again later.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
