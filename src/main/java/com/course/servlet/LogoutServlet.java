package com.course.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * LogoutServlet.java
 * ------------------
 * Invalidates the HTTP session and redirects to the login page.
 *
 * GET /logout → clear session and go to login
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate(); // destroy the session and all its attributes
        }
        resp.sendRedirect(req.getContextPath() + "/login?logout=true");
    }
}
