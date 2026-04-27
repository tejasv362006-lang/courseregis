package com.course.servlet;

import com.course.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

/**
 * DashboardServlet.java
 * ---------------------
 * Loads the courses the logged-in user has enrolled in
 * and forwards the data to dashboard.jsp.
 *
 * GET /dashboard → show the user's personal dashboard
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Guard: user must be logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // SQL: join enrollments with courses to get the user's enrolled courses
        String sql =
            "SELECT c.id, c.title, c.description, c.instructor, c.duration, " +
            "       c.category, e.enrolled_at " +
            "FROM enrollments e " +
            "JOIN courses c ON e.course_id = c.id " +
            "WHERE e.user_id = ? " +
            "ORDER BY e.enrolled_at DESC";

        List<Map<String, Object>> enrolled = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> course = new LinkedHashMap<>();
                    course.put("id",          rs.getInt("id"));
                    course.put("title",       rs.getString("title"));
                    course.put("description", rs.getString("description"));
                    course.put("instructor",  rs.getString("instructor"));
                    course.put("duration",    rs.getString("duration"));
                    course.put("category",    rs.getString("category"));
                    course.put("enrolledAt",  rs.getTimestamp("enrolled_at").toString().substring(0, 10));
                    enrolled.add(course);
                }
            }

            req.setAttribute("enrolledCourses", enrolled);
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not load your dashboard. Please try again.");
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        }
    }
}
