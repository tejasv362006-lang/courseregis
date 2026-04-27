<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- If already logged in, skip to dashboard --%>
<%
    if (session != null && session.getAttribute("userId") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    String error   = (String) request.getAttribute("error");
    String regMsg  = request.getParameter("registered");
    String logMsg  = request.getParameter("logout");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Login – EduEnroll</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
        }
        .card-header {
            background: linear-gradient(135deg, #e94560, #c62a47);
            border-radius: 16px 16px 0 0 !important;
            padding: 2rem;
            text-align: center;
        }
        .brand-icon { font-size: 2.5rem; }
        .btn-primary {
            background: linear-gradient(135deg, #e94560, #c62a47);
            border: none;
            padding: 0.75rem;
            border-radius: 8px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .btn-primary:hover { opacity: 0.9; background: linear-gradient(135deg, #c62a47, #e94560); }
        .form-control { border-radius: 8px; padding: 0.75rem 1rem; border: 1px solid #dee2e6; }
        .form-control:focus { border-color: #e94560; box-shadow: 0 0 0 0.2rem rgba(233,69,96,0.15); }
        .input-group-text { background: #f8f9fa; border-radius: 8px 0 0 8px; }
        a { color: #e94560; }
        a:hover { color: #c62a47; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">

            <div class="card">
                <!-- Header -->
                <div class="card-header text-white">
                    <div class="brand-icon mb-2">🎓</div>
                    <h3 class="mb-0 fw-bold">EduEnroll</h3>
                    <p class="mb-0 opacity-75">Online Course Registration</p>
                </div>

                <!-- Body -->
                <div class="card-body p-4">
                    <h5 class="text-center mb-4 fw-semibold">Welcome Back</h5>

                    <%-- Success / info alerts --%>
                    <% if ("true".equals(regMsg)) { %>
                    <div class="alert alert-success alert-dismissible fade show py-2" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i>
                        Registration successful! Please log in.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>
                    <% if ("true".equals(logMsg)) { %>
                    <div class="alert alert-info alert-dismissible fade show py-2" role="alert">
                        <i class="bi bi-info-circle-fill me-1"></i>
                        You have been logged out.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>
                    <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show py-2" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i>
                        <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <!-- Login Form -->
                    <form action="<%= request.getContextPath() %>/login" method="post" novalidate>

                        <div class="mb-3">
                            <label for="email" class="form-label fw-medium">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" id="email" name="email"
                                       class="form-control" placeholder="you@example.com"
                                       required autocomplete="email"/>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-medium">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" id="password" name="password"
                                       class="form-control" placeholder="••••••••"
                                       required autocomplete="current-password"/>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Log In
                        </button>
                    </form>

                    <hr class="my-4"/>
                    <p class="text-center mb-0">
                        Don't have an account?
                        <a href="<%= request.getContextPath() %>/register" class="fw-semibold">Register here</a>
                    </p>
                </div>
            </div>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
