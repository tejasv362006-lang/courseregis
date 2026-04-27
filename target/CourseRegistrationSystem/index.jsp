<%-- index.jsp – Root welcome page. Redirects logged-in users to dashboard. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // If a session exists, send to dashboard; otherwise to login
    if (session != null && session.getAttribute("userId") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
