<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    // Guard: must be logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    List<Map<String, Object>> courses =
        (List<Map<String, Object>>) request.getAttribute("courses");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Courses – EduEnroll</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        body { background: #f0f4f8; font-family: 'Segoe UI', sans-serif; }

        /* ── Navbar ── */
        .navbar { background: linear-gradient(135deg, #1a1a2e, #0f3460); }
        .navbar-brand { font-weight: 700; font-size: 1.3rem; }

        /* ── Category badge colours ── */
        .badge-Programming  { background: #e94560; }
        .badge-WebDevelopment { background: #0f3460; }
        .badge-DataScience  { background: #533483; }
        .badge-Cloud        { background: #0099b4; }
        .badge-Design       { background: #e67e22; }
        .badge-Database     { background: #27ae60; }
        .badge-Mobile       { background: #2980b9; }
        .badge-Security     { background: #c0392b; }
        .badge-default      { background: #6c757d; }

        /* ── Cards ── */
        .course-card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            height: 100%;
        }
        .course-card:hover { transform: translateY(-4px); box-shadow: 0 10px 30px rgba(0,0,0,0.14); }
        .course-card .card-header {
            border-radius: 14px 14px 0 0 !important;
            background: linear-gradient(135deg, #1a1a2e, #0f3460);
            color: #fff;
            padding: 1.25rem;
        }
        .enrolled-ribbon {
            display: inline-block;
            background: #27ae60;
            color: #fff;
            font-size: 0.7rem;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 20px;
            letter-spacing: 0.5px;
        }
        .btn-enroll {
            background: linear-gradient(135deg, #e94560, #c62a47);
            border: none;
            color: #fff;
            border-radius: 8px;
            font-weight: 600;
        }
        .btn-enroll:hover { opacity: 0.9; color: #fff; }
        .btn-unenroll {
            background: #6c757d;
            border: none;
            color: #fff;
            border-radius: 8px;
            font-weight: 600;
        }
        .btn-unenroll:hover { background: #5a6268; color: #fff; }

        /* ── Search / filter bar ── */
        #searchInput:focus { border-color: #0f3460; box-shadow: 0 0 0 0.2rem rgba(15,52,96,0.15); }

        /* ── Section header ── */
        .page-heading { color: #1a1a2e; font-weight: 700; }
    </style>
</head>
<body>

<!-- ── Navbar ──────────────────────────────────────────────────────────── -->
<nav class="navbar navbar-expand-lg navbar-dark sticky-top">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/dashboard">
            🎓 EduEnroll
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%= request.getContextPath() %>/courses">
                        <i class="bi bi-collection-play me-1"></i>Courses
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle me-1"></i><%= userName %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
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

<!-- ── Main Content ─────────────────────────────────────────────────────── -->
<div class="container py-4">

    <!-- Page heading + search bar -->
    <div class="row align-items-center mb-4">
        <div class="col-md-6">
            <h2 class="page-heading mb-0">
                <i class="bi bi-collection-play me-2"></i>Available Courses
            </h2>
            <p class="text-muted mt-1">Browse and enrol in courses that interest you.</p>
        </div>
        <div class="col-md-6">
            <input type="text" id="searchInput" class="form-control form-control-lg"
                   placeholder="🔍  Search by title, instructor or category…"
                   oninput="filterCourses()"/>
        </div>
    </div>

    <%-- Error alert --%>
    <% if (error != null) { %>
    <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-1"></i><%= error %></div>
    <% } %>

    <%-- Stats strip --%>
    <% if (courses != null) {
        int totalCourses = courses.size();
        long enrolledCount = courses.stream().filter(c -> Boolean.TRUE.equals(c.get("enrolled"))).count();
    %>
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="card border-0 text-center p-3" style="background:#e8f4fd; border-radius:12px;">
                <div class="fs-3 fw-bold text-primary"><%= totalCourses %></div>
                <div class="text-muted small">Total Courses</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card border-0 text-center p-3" style="background:#e8f8f5; border-radius:12px;">
                <div class="fs-3 fw-bold text-success"><%= enrolledCount %></div>
                <div class="text-muted small">Enrolled</div>
            </div>
        </div>
    </div>

    <!-- Course Grid -->
    <div class="row g-4" id="courseGrid">

        <% for (Map<String, Object> course : courses) {
            boolean enrolled  = Boolean.TRUE.equals(course.get("enrolled"));
            String category   = (String) course.get("category");
            String badgeClass = "badge-" + (category != null ? category.replaceAll("\\s+","") : "default");
        %>
        <div class="col-md-6 col-lg-4 course-item"
             data-title="<%= course.get("title").toString().toLowerCase() %>"
             data-instructor="<%= course.get("instructor").toString().toLowerCase() %>"
             data-category="<%= category != null ? category.toLowerCase() : "" %>">

            <div class="card course-card">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-start">
                        <span class="badge <%= badgeClass %> rounded-pill mb-2">
                            <%= category != null ? category : "General" %>
                        </span>
                        <% if (enrolled) { %>
                        <span class="enrolled-ribbon">✔ Enrolled</span>
                        <% } %>
                    </div>
                    <h6 class="card-title mb-0 fw-semibold"><%= course.get("title") %></h6>
                </div>

                <div class="card-body d-flex flex-column">
                    <p class="card-text text-muted small flex-grow-1">
                        <%= course.get("description") %>
                    </p>
                    <hr class="my-2"/>
                    <div class="small text-muted mb-3">
                        <div><i class="bi bi-person-badge me-1"></i> <%= course.get("instructor") %></div>
                        <div><i class="bi bi-clock me-1"></i> <%= course.get("duration") %></div>
                        <div><i class="bi bi-people me-1"></i> <%= course.get("seats") %> seats available</div>
                    </div>

                    <!-- Enroll / Unenroll button -->
                    <form action="<%= request.getContextPath() %>/enroll" method="post">
                        <input type="hidden" name="courseId" value="<%= course.get("id") %>"/>
                        <% if (enrolled) { %>
                        <input type="hidden" name="action" value="unenroll"/>
                        <button type="submit" class="btn btn-unenroll w-100">
                            <i class="bi bi-x-circle me-1"></i>Unenroll
                        </button>
                        <% } else { %>
                        <input type="hidden" name="action" value="enroll"/>
                        <button type="submit" class="btn btn-enroll w-100">
                            <i class="bi bi-plus-circle me-1"></i>Enroll Now
                        </button>
                        <% } %>
                    </form>
                </div>
            </div>

        </div>
        <% } %>

    </div>

    <!-- No-results message (hidden by default) -->
    <div id="noResults" class="text-center py-5" style="display:none!important;">
        <div style="font-size:3rem;">🔍</div>
        <h5 class="text-muted">No courses match your search.</h5>
    </div>

    <% } else { %>
    <div class="alert alert-info">No courses available at the moment.</div>
    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Live search / filter
    function filterCourses() {
        const q    = document.getElementById('searchInput').value.toLowerCase().trim();
        const items = document.querySelectorAll('.course-item');
        let visible = 0;
        items.forEach(item => {
            const match = item.dataset.title.includes(q)
                       || item.dataset.instructor.includes(q)
                       || item.dataset.category.includes(q);
            item.style.display = match ? '' : 'none';
            if (match) visible++;
        });
        document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';
    }
</script>
</body>
</html>
