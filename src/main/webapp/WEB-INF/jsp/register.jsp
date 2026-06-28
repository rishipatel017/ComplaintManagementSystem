<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - CMS</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Lato:wght@400;700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css">

</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-80" style="font-family: 'Roboto', sans-serif;">

    <div class="card shadow-lg p-4 rounded-4" style="width: 100%; max-width: 500px; animation: fadeIn 1s ease;">
        <div class="text-center mb-4">
            <i class="fas fa-user-plus fa-4x text-primary mb-2"></i>
            <h2 class="fw-bold text-primary">Register</h2>
            <p class="text-muted">Create your student or staff account</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/register" class="needs-validation" novalidate>
            <!-- Full Name -->
            <div class="mb-3">
                <label for="fullName" class="form-label fw-semibold">Full Name</label>
                <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter full name" required>
                <div class="invalid-feedback">Please enter your full name.</div>
            </div>

            <!-- Username -->
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">Username</label>
                <input type="text" class="form-control" id="username" name="username" placeholder="Choose a username" required>
                <div class="invalid-feedback">Please choose a username.</div>
            </div>

            <!-- Password -->
            <div class="mb-3">
                <label for="password" class="form-label fw-semibold">Password</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="At least 6 characters" required minlength="6">
                <div class="invalid-feedback">Password must be at least 6 characters.</div>
            </div>

            <!-- Role -->
            <div class="mb-3">
                <label for="role" class="form-label fw-semibold">Role</label>
                <select class="form-select" id="role" name="role" onchange="toggleFields()" required>
                    <option value="student" selected>Student</option>
                    <option value="staff">Staff</option>
                </select>
                <div class="invalid-feedback">Please select your role.</div>
            </div>

            <!-- Student Fields -->
            <div id="studentFields" style="display:block;">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Roll Number</label>
                    <input type="text" class="form-control" name="rollNumber" placeholder="Enter roll number" required>
                    <div class="invalid-feedback">Please enter your roll number.</div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">College Email</label>
                    <input type="email" class="form-control" name="studentEmail" placeholder="name@adit.ac.in" pattern=".+@college\.edu" required>
                    <div class="invalid-feedback">Please enter a valid college email.</div>
                </div>
            </div>

            <!-- Staff Fields -->
            <div id="staffFields" style="display:none;">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Staff ID</label>
                    <input type="text" class="form-control" name="staffId" placeholder="Enter staff ID" required>
                    <div class="invalid-feedback">Please enter staff ID.</div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Verification Code</label>
                    <input type="text" class="form-control" name="verificationCode" placeholder="Enter verification code" required>
                    <div class="invalid-feedback">Verification code is required.</div>
                </div>
            </div>

            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-primary btn-lg fw-bold">
                    <i class="fas fa-user-plus me-2"></i> Register
                </button>
            </div>
        </form>

        <p class="text-center mt-3 text-muted">
            Already have an account? <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold">Login here</a>
        </p>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Toggle Student/Staff Fields -->
    <script>
        function toggleFields() {
            const role = document.getElementById('role').value;
            document.getElementById('studentFields').style.display = (role === 'student') ? 'block' : 'none';
            document.getElementById('staffFields').style.display = (role === 'staff') ? 'block' : 'none';
        }

        // Bootstrap validation
        (() => {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();

        // Fade-in animation
        const style = document.createElement('style');
        style.innerHTML = `
            @keyframes fadeIn {
                0% {opacity: 0; transform: translateY(-20px);}
                100% {opacity: 1; transform: translateY(0);}
            }`;
        document.head.appendChild(style);
    </script>
</body>
</html>
