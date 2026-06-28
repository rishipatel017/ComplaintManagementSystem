<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - CMS</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
   <!-- Google Fonts (Roboto + Lato) -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Lato:wght@400;700&display=swap" rel="stylesheet">

    <!-- Font Awesome (official jsDelivr CDN) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css">

    <!-- Favicon -->
    <link rel="icon" href="https://cdn-icons-png.flaticon.com/512/2922/2922510.png" type="image/png">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100" style="font-family: 'Roboto', sans-serif;">

    <div class="card shadow-lg p-4 rounded-4" style="width: 100%; max-width: 420px; animation: fadeIn 1s ease;">
        <div class="text-center mb-4">
            <i class="fas fa-user-circle fa-4x text-primary mb-2"></i>
            <h2 class="fw-bold text-primary">CMS Login</h2>
            <p class="text-muted">Securely access your dashboard</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Login Form -->
        <form method="post" action="${pageContext.request.contextPath}/login" novalidate>
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">Username</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa fa-user"></i></span>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username" required>
                </div>
                <div class="invalid-feedback">Please enter your username.</div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label fw-semibold">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required minlength="6">
                </div>
                <div class="invalid-feedback">Password must be at least 6 characters.</div>
            </div>

            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-primary btn-lg fw-bold">
                    <i class="fas fa-sign-in-alt me-2"></i> Login
                </button>
            </div>
        </form>

        <p class="text-center mt-3 text-muted">
            Don't have an account? <a href="${pageContext.request.contextPath}/register" class="text-primary fw-semibold">Register here</a>
        </p>
    </div>

    <!-- Bootstrap 5 JS (required for alerts & components) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Frontend Form Validation -->
    <script>
        (() => {
            'use strict'
            const forms = document.querySelectorAll('form')
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })();

        // Fade-in animation (Bootstrap animation alternative)
        const style = document.createElement('style')
        style.innerHTML = `
        @keyframes fadeIn {
            0% {opacity: 0; transform: translateY(-20px);}
            100% {opacity: 1; transform: translateY(0);}
        }`
        document.head.appendChild(style)
    </script>

</body>
</html>
