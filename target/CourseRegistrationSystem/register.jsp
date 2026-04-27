<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session != null && session.getAttribute("userId") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Register – EduEnroll</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .card { border: none; border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,0.4); }
        .card-header {
            background: linear-gradient(135deg, #0f3460, #533483);
            border-radius: 16px 16px 0 0 !important;
            padding: 2rem;
            text-align: center;
        }
        .btn-success {
            background: linear-gradient(135deg, #0f3460, #533483);
            border: none;
            padding: 0.75rem;
            border-radius: 8px;
            font-weight: 600;
        }
        .btn-success:hover { opacity: 0.9; }
        .form-control { border-radius: 8px; padding: 0.75rem 1rem; }
        .form-control:focus { border-color: #533483; box-shadow: 0 0 0 0.2rem rgba(83,52,131,0.2); }
        .input-group-text { background: #f8f9fa; border-radius: 8px 0 0 8px; }
        a { color: #e94560; }
        a:hover { color: #c62a47; }
        .strength-bar { height: 4px; border-radius: 2px; transition: width 0.3s, background 0.3s; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">

            <div class="card">
                <div class="card-header text-white">
                    <div style="font-size:2.5rem" class="mb-2">🎓</div>
                    <h3 class="mb-0 fw-bold">EduEnroll</h3>
                    <p class="mb-0 opacity-75">Create your free account</p>
                </div>

                <div class="card-body p-4">

                    <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show py-2">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i><%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/register"
                          method="post" id="regForm" novalidate>

                        <!-- Full Name -->
                        <div class="mb-3">
                            <label for="name" class="form-label fw-medium">Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" id="name" name="name"
                                       class="form-control" placeholder="Jane Doe"
                                       minlength="2" required/>
                            </div>
                            <div class="invalid-feedback">Please enter your full name.</div>
                        </div>

                        <!-- Email -->
                        <div class="mb-3">
                            <label for="email" class="form-label fw-medium">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" id="email" name="email"
                                       class="form-control" placeholder="you@example.com"
                                       required/>
                            </div>
                            <div class="invalid-feedback">Please enter a valid email.</div>
                        </div>

                        <!-- Password -->
                        <div class="mb-1">
                            <label for="password" class="form-label fw-medium">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" id="password" name="password"
                                       class="form-control" placeholder="Min. 6 characters"
                                       minlength="6" required oninput="checkStrength(this.value)"/>
                                <button class="btn btn-outline-secondary" type="button"
                                        onclick="togglePwd('password', this)">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback">Password must be at least 6 characters.</div>
                        </div>

                        <!-- Password strength indicator -->
                        <div class="mb-3">
                            <div class="bg-light rounded" style="height:4px;">
                                <div id="strengthBar" class="strength-bar" style="width:0;background:#e74c3c;"></div>
                            </div>
                            <small id="strengthText" class="text-muted"></small>
                        </div>

                        <!-- Confirm Password -->
                        <div class="mb-4">
                            <label for="confirm" class="form-label fw-medium">Confirm Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                <input type="password" id="confirm"
                                       class="form-control" placeholder="Repeat password"
                                       required oninput="checkMatch()"/>
                                <button class="btn btn-outline-secondary" type="button"
                                        onclick="togglePwd('confirm', this)">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div id="matchMsg" class="form-text"></div>
                        </div>

                        <button type="submit" class="btn btn-success w-100 text-white">
                            <i class="bi bi-person-plus-fill me-1"></i> Create Account
                        </button>
                    </form>

                    <hr class="my-4"/>
                    <p class="text-center mb-0">
                        Already have an account?
                        <a href="<%= request.getContextPath() %>/login" class="fw-semibold">Log in</a>
                    </p>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Client-side password strength indicator
    function checkStrength(val) {
        const bar  = document.getElementById('strengthBar');
        const text = document.getElementById('strengthText');
        if (val.length === 0) { bar.style.width='0'; text.textContent=''; return; }
        let score = 0;
        if (val.length >= 6)  score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val)) score++;
        if (/[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;
        const levels = [
            {w:'20%', c:'#e74c3c', t:'Very weak'},
            {w:'40%', c:'#e67e22', t:'Weak'},
            {w:'60%', c:'#f1c40f', t:'Fair'},
            {w:'80%', c:'#2ecc71', t:'Strong'},
            {w:'100%',c:'#27ae60', t:'Very strong'}
        ];
        const l = levels[Math.min(score, 4)];
        bar.style.width = l.w;
        bar.style.background = l.c;
        text.textContent = l.t;
        text.style.color = l.c;
    }

    // Check that both passwords match before enabling submit
    function checkMatch() {
        const pwd  = document.getElementById('password').value;
        const conf = document.getElementById('confirm').value;
        const msg  = document.getElementById('matchMsg');
        if (conf.length === 0) { msg.textContent = ''; return; }
        if (pwd === conf) {
            msg.textContent = '✔ Passwords match';
            msg.className = 'form-text text-success';
        } else {
            msg.textContent = '✘ Passwords do not match';
            msg.className = 'form-text text-danger';
        }
    }

    // Toggle password visibility
    function togglePwd(fieldId, btn) {
        const field = document.getElementById(fieldId);
        const icon  = btn.querySelector('i');
        if (field.type === 'password') {
            field.type = 'text';
            icon.className = 'bi bi-eye-slash';
        } else {
            field.type = 'password';
            icon.className = 'bi bi-eye';
        }
    }

    // Bootstrap form validation + match check on submit
    document.getElementById('regForm').addEventListener('submit', function (e) {
        const pwd  = document.getElementById('password').value;
        const conf = document.getElementById('confirm').value;
        if (pwd !== conf) {
            e.preventDefault();
            document.getElementById('matchMsg').textContent = '✘ Passwords do not match';
            document.getElementById('matchMsg').className = 'form-text text-danger';
        }
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        this.classList.add('was-validated');
    });
</script>
</body>
</html>
