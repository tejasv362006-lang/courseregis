<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName  = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    List<Map<String, Object>> enrolled =
        (List<Map<String, Object>>) request.getAttribute("enrolledCourses");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard – EduEnroll</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        body { background: #f0f4f8; font-family: 'Segoe UI', sans-serif; }

        .navbar { background: linear-gradient(135deg, #1a1a2e, #0f3460); }
        .navbar-brand { font-weight: 700; font-size: 1.3rem; }

        /* Hero / welcome card */
        .hero-card {
            background: linear-gradient(135deg, #0f3460 0%, #533483 100%);
            border-radius: 16px;
            color: #fff;
            padding: 2.5rem 2rem;
            position: relative;
            overflow: hidden;
        }
        .hero-card::after {
            content: '🎓';
            position: absolute;
            right: 2rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 5rem;
            opacity: 0.15;
        }

        /* Stat tiles */
        .stat-tile {
            border: none;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.07);
            text-align: center;
            padding: 1.5rem 1rem;
        }
        .stat-icon { font-size: 2rem; margin-bottom: 0.4rem; }

        /* Enrolled course rows */
        .enroll-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            transition: transform 0.15s;
        }
        .enroll-card:hover { transform: translateY(-3px); }
        .enroll-card .card-body { padding: 1.25rem 1.5rem; }

        .category-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            display: inline-block;
            background: #0f3460;
            margin-right: 6px;
        }

        .btn-browse {
            background: linear-gradient(135deg, #e94560, #c62a47);
            border: none;
            color: #fff;
            border-radius: 8px;
            font-weight: 600;
            padding: 0.65rem 1.5rem;
        }
        .btn-browse:hover { opacity: 0.9; color: #fff; }

        .section-title { color: #1a1a2e; font-weight: 700; }
    </style>
</head>
<body>

<!-- ── Navbar ──────────────────────────────────────────────────────────── -->
<nav class="navbar navbar-expand-lg navbar-dark sticky-top">
    <div class="container">
        <a class="navbar-brand" href="#">🎓 EduEnroll</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="<%= request.getContextPath() %>/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/courses">
                        <i class="bi bi-collection-play me-1"></i>Courses
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle me-1"></i><%= userName %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><span class="dropdown-item-text small text-muted"><%= userEmail %></span></li>
                        <li><hr class="dropdown-divider"/></li>
                        <li>
                            <a class="dropdown-item text-danger"
                               href="<%= request.getContextPath() %>/logout">
                                <i class="bi bi-box-arrow-right me-1"></i>Logout
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ── Main ─────────────────────────────────────────────────────────────── -->
<div class="container py-4">

    <%-- Error alert --%>
    <% if (error != null) { %>
    <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-1"></i><%= error %></div>
    <% } %>

    <!-- Welcome hero -->
    <div class="hero-card mb-4">
        <h2 class="fw-bold mb-1">Welcome back, <%= userName %>! 👋</h2>
        <p class="mb-3 opacity-75">Here's a summary of your learning journey.</p>
        <a href="<%= request.getContextPath() %>/courses" class="btn btn-light fw-semibold">
            <i class="bi bi-compass me-1"></i>Explore More Courses
        </a>
    </div>

    <!-- Stats row -->
    <% int enrolledCount = (enrolled != null) ? enrolled.size() : 0; %>
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="card stat-tile" style="background:#e8f4fd;">
                <div class="stat-icon">📚</div>
                <div class="fs-2 fw-bold text-primary"><%= enrolledCount %></div>
                <div class="text-muted small">Enrolled Courses</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card stat-tile" style="background:#fef9e7;">
                <div class="stat-icon">⏱️</div>
                <div class="fs-2 fw-bold text-warning">–</div>
                <div class="text-muted small">Hours Completed</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card stat-tile" style="background:#e8f8f5;">
                <div class="stat-icon">🏅</div>
                <div class="fs-2 fw-bold text-success">0</div>
                <div class="text-muted small">Certificates</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card stat-tile" style="background:#fdf2f8;">
                <div class="stat-icon">🌟</div>
                <div class="fs-2 fw-bold text-danger">Active</div>
                <div class="text-muted small">Status</div>
            </div>
        </div>
    </div>

    <!-- Enrolled courses section -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="section-title mb-0">
            <i class="bi bi-journals me-2"></i>My Enrolled Courses
        </h4>
        <a href="<%= request.getContextPath() %>/courses" class="btn btn-browse btn-sm">
            <i class="bi bi-plus-lg me-1"></i>Browse Courses
        </a>
    </div>

    <% if (enrolled == null || enrolled.isEmpty()) { %>
    <!-- Empty state -->
    <div class="card border-0 rounded-4 text-center py-5"
         style="box-shadow: 0 4px 20px rgba(0,0,0,0.07);">
        <div style="font-size:3.5rem">📋</div>
        <h5 class="mt-3 text-muted">You haven't enrolled in any courses yet.</h5>
        <p class="text-muted small">Click the button above to explore what's available.</p>
        <div>
            <a href="<%= request.getContextPath() %>/courses" class="btn btn-browse">
                <i class="bi bi-compass me-1"></i>Explore Courses
            </a>
        </div>
    </div>

    <% } else { %>
    <div class="row g-3">
        <% for (Map<String, Object> course : enrolled) { %>
        <div class="col-md-6 col-lg-4">
            <div class="card enroll-card h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <span class="badge bg-success rounded-pill">Enrolled</span>
                        <small class="text-muted"><%= course.get("enrolledAt") %></small>
                    </div>
                    <h6 class="fw-bold mb-1"><%= course.get("title") %></h6>
                    <p class="text-muted small mb-2"><%= course.get("description") %></p>
                    <hr class="my-2"/>
                    <div class="small text-muted">
                        <div><i class="bi bi-person-badge me-1"></i><%= course.get("instructor") %></div>
                        <div><i class="bi bi-clock me-1"></i><%= course.get("duration") %></div>
                        <div>
                            <i class="bi bi-tag me-1"></i>
                            <span class="badge bg-secondary rounded-pill"><%= course.get("category") %></span>
                        </div>
                    </div>
                    <!-- Unenroll -->
                    <form action="<%= request.getContextPath() %>/enroll" method="post" class="mt-3">
                        <input type="hidden" name="courseId" value="<%= course.get("id") %>"/>
                        <input type="hidden" name="action" value="unenroll"/>
                        <button type="submit" class="btn btn-outline-danger btn-sm w-100"
                                onclick="return confirm('Unenroll from this course?')">
                            <i class="bi bi-x-circle me-1"></i>Unenroll
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
