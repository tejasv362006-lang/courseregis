package com.course.servlet;

import com.course.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/**
 * EnrollServlet.java
 * ------------------
 * Handles course enrollment and un-enrollment.
 *
 * POST /enroll?action=enroll    → enroll the user in a course
 * POST /enroll?action=unenroll  → remove the enrollment
 *
 * After the action the user is redirected back to the courses page.
 */
@WebServlet("/enroll")
public class EnrollServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Guard: user must be logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Read parameters
        int    userId   = (int) session.getAttribute("userId");
        String courseIdStr = req.getParameter("courseId");
        String action      = req.getParameter("action"); // "enroll" or "unenroll"

        // 3. Validate courseId
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/courses?error=invalid");
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/courses?error=invalid");
            return;
        }

        // 4. Execute the appropriate SQL
        if ("unenroll".equals(action)) {
            // Remove the enrollment record
            String sql = "DELETE FROM enrollments WHERE user_id = ? AND course_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            // Default action: enroll
            // INSERT IGNORE silently skips if the user is already enrolled (UNIQUE key)
            String sql = "INSERT IGNORE INTO enrollments (user_id, course_id) VALUES (?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 5. Redirect back to the courses list
        resp.sendRedirect(req.getContextPath() + "/courses");
    }
}
