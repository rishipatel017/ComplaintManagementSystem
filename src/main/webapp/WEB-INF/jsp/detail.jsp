<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<title>Complaint Detail - CMS</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Lato:wght@400;700&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css">

<style>
@keyframes fadeIn {
  0% {opacity: 0; transform: translateY(-20px);}
  100% {opacity: 1; transform: translateY(0);}
}
</style>
</head>
<body class="bg-light" style="font-family: 'Roboto', sans-serif;">

<div class="container py-4">
  <div class="mb-3 d-flex justify-content-between align-items-center">
    <div>
      <a href="${pageContext.request.contextPath}/complaints" class="btn btn-outline-secondary btn-sm me-1">
        <i class="fas fa-arrow-left me-1"></i> Back to list
      </a>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary btn-sm me-1">
        <i class="fas fa-tachometer-alt me-1"></i> Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
        <i class="fas fa-sign-out-alt me-1"></i> Logout
      </a>
    </div>
  </div>

  <div class="card shadow-lg p-4 rounded-4 mb-4" style="animation: fadeIn 1s ease;">
    <h2 class="text-primary mb-3"><i class="fas fa-info-circle me-2"></i>Complaint Detail</h2>

    <c:if test="${empty complaint}">
      <div class="alert alert-warning">Complaint not found.</div>
    </c:if>

    <c:if test="${not empty complaint}">
      <div class="mb-2"><strong>Title:</strong> ${complaint.title}</div>
      <div class="mb-2"><strong>Category:</strong> ${complaint.category}</div>
      <div class="mb-2"><strong>Submitted by:</strong> ${complaint.user_name}</div>
      <div class="mb-2"><strong>Created at:</strong> ${complaint.created_at}</div>
      <div class="mb-2"><strong>Status:</strong> <span class="badge bg-info">${complaint.status}</span></div>
      <div class="mb-2"><strong>Deadline:</strong> ${complaint.deadline}</div>
      <hr/>
      <div class="mb-3"><strong>Description:</strong>
        <div class="border p-2 rounded bg-white"><pre>${complaint.description}</pre></div>
      </div>

      <c:if test="${not empty complaint.abort_reason}">
        <div class="alert alert-danger"><strong>Abort Reason:</strong> ${complaint.abort_reason}</div>
      </c:if>

      <c:if test="${not empty complaint.resolved_at}">
        <div class="mb-2"><strong>Resolved at:</strong> ${complaint.resolved_at}</div>
      </c:if>

      <!-- Feedback Form -->
      <c:if test="${complaint.status == 'RESOLVED' && (empty complaint.feedback_text) && (sessionScope.userId == complaint.user_id)}">
        <hr/>
        <h3 class="text-secondary mb-3"><i class="fas fa-comment-dots me-2"></i>Give Feedback</h3>
        <c:if test="${not empty error}">
          <div class="alert alert-danger">${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/complaint/feedback" class="needs-validation" novalidate>
          <input type="hidden" name="complaintId" value="${complaint.id}"/>
          <input type="hidden" name="csrf" value="${sessionScope.CSRF_TOKEN}"/>

          <div class="mb-3">
            <label for="rating" class="form-label fw-semibold">Rating (1-5)</label>
            <input type="number" id="rating" name="rating" min="1" max="5" class="form-control" pattern="^[1-5]$" required>
            <div class="invalid-feedback">Please provide a rating between 1 and 5.</div>
          </div>

          <div class="mb-3">
            <label for="feedback" class="form-label fw-semibold">Feedback</label>
            <textarea id="feedback" name="feedback" rows="5" class="form-control" pattern=".{5,500}" placeholder="Enter your feedback (5-500 chars)" required></textarea>
            <div class="invalid-feedback">Feedback must be between 5 and 500 characters.</div>
          </div>

          <div class="d-grid mt-3">
            <button type="submit" class="btn btn-primary btn-lg fw-bold">
              <i class="fas fa-paper-plane me-2"></i> Submit Feedback
            </button>
          </div>
        </form>
      </c:if>

      <!-- Show Feedback if exists -->
      <c:if test="${not empty complaint.feedback_text}">
        <hr/>
        <div class="mb-2"><strong>Your Feedback:</strong></div>
        <div class="mb-2"><strong>Rating:</strong> ${complaint.feedback_rating}</div>
        <div class="border p-2 rounded bg-white"><pre>${complaint.feedback_text}</pre></div>
      </c:if>
    </c:if>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Frontend Validation -->
<script>
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
</script>

</body>
</html>
