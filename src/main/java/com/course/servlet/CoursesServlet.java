package com.course.servlet;

import com.course.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

/**
 * CoursesServlet.java
 * -------------------
 * Fetches all courses from the database and forwards them to courses.jsp.
 * Also marks which courses the logged-in user has already enrolled in.
 *
 * GET /courses → show the course catalogue
 */
@WebServlet("/courses")
public class CoursesServlet extends HttpServlet {

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

        // SQL: fetch all courses and flag whether the current user is enrolled
        String sql =
            "SELECT c.*, " +
            "       (SELECT COUNT(*) FROM enrollments e " +
            "        WHERE e.course_id = c.id AND e.user_id = ?) AS enrolled " +
            "FROM courses c " +
            "ORDER BY c.category, c.title";

        List<Map<String, Object>> courses = new ArrayList<>();

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
                    course.put("seats",       rs.getInt("seats"));
                    course.put("enrolled",    rs.getInt("enrolled") > 0); // true/false
                    courses.add(course);
                }
            }

            req.setAttribute("courses", courses);
            req.getRequestDispatcher("/courses.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not load courses. Please try again.");
            req.getRequestDispatcher("/courses.jsp").forward(req, resp);
        }
    }
}
