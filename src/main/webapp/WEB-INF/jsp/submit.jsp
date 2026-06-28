<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Submit Complaint - CMS</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Lato:wght@400;700&display=swap" rel="stylesheet">

<!-- Font Awesome (jsDelivr) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css">

</head>
<body class="bg-light" style="font-family: 'Roboto', sans-serif;">

<div class="container vh-100 d-flex justify-content-center align-items-center">
    <div class="card shadow-lg p-4 rounded-4 w-100" style="max-width: 600px; animation: fadeIn 1s ease;">
        <div class="d-flex justify-content-between mb-3">
            <a href="${pageContext.request.contextPath}/complaints" class="btn btn-outline-secondary btn-sm">
                <i class="fas fa-arrow-left me-1"></i> Back to list
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="fas fa-sign-out-alt me-1"></i> Logout
            </a>
        </div>

        <h2 class="text-center text-primary mb-4"><i class="fas fa-edit me-2"></i>Submit Complaint</h2>

        <form method="post" action="${pageContext.request.contextPath}/submit" class="needs-validation" novalidate>

            <div class="mb-3">
                <label for="category" class="form-label fw-semibold">Category</label>
                <select id="category" name="categoryId" class="form-select" required>
                    <option value="" selected disabled>Select Category</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat[0]}">${cat[1]}</option>
                    </c:forEach>
                </select>
                <div class="invalid-feedback">Please select a category.</div>
            </div>

            <div class="mb-3">
                <label for="title" class="form-label fw-semibold">Title</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-heading"></i></span>
                    <input type="text" id="title" name="title" class="form-control" placeholder="Enter complaint title" required>
                </div>
                <div class="invalid-feedback">Title is required.</div>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label fw-semibold">Description</label>
                <textarea id="description" name="description" class="form-control" rows="5" placeholder="Describe your complaint" required></textarea>
                <div class="invalid-feedback">Description cannot be empty.</div>
            </div>

            <div class="mb-3">
                <label for="deadline" class="form-label fw-semibold">Resolution Deadline</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-calendar-alt"></i></span>
                    <input type="date" id="deadline" name="deadline" class="form-control" required>
                </div>
                <div class="invalid-feedback">Please select a resolution deadline.</div>
            </div>

            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-primary btn-lg fw-bold">
                    <i class="fas fa-paper-plane me-2"></i> Submit Complaint
                </button>
            </div>

        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Bootstrap frontend validation
    (() => {
        'use strict'
        const forms = document.querySelectorAll('.needs-validation')
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

    // Fade-in animation
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
