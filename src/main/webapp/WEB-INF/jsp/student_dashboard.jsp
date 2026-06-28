<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Dashboard - CMS</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Lato:wght@400;700&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css">

<style>
/* Entrance Animation */
@keyframes fadeInUp {
    0% { opacity: 0; transform: translateY(20px);}
    100% { opacity: 1; transform: translateY(0);}
}

/* Card Hover Effects */
.card-hover {
    transition: transform 0.3s ease, box-shadow 0.3s ease, border 0.3s ease;
    border: 2px solid transparent; /* default no border */
}
.card-hover:hover {
    transform: translateY(-10px) scale(1.05); /* slightly bigger */
    box-shadow: 0 25px 35px rgba(0,0,0,0.2);
    border: 2px solid #0d6efd; /* primary color outline */
}

/* Icon Bounce on Hover */
.card-hover:hover i {
    animation: bounce 0.6s;
}

/* Bounce Keyframes */
@keyframes bounce {
    0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
    40% { transform: translateY(-10px); }
    60% { transform: translateY(-5px); }
}

/* Staggered animation delays for cards */
.card-animated {
    opacity: 0;
    animation: fadeInUp 0.8s forwards;
}
.card-animated:nth-child(1) { animation-delay: 0.1s; }
.card-animated:nth-child(2) { animation-delay: 0.2s; }
.card-animated:nth-child(3) { animation-delay: 0.3s; }
.card-animated:nth-child(4) { animation-delay: 0.4s; }
.card-animated:nth-child(5) { animation-delay: 0.5s; }
</style>

</head>
<body class="bg-light" style="font-family: 'Roboto', sans-serif;">

<div class="container py-5">

    <!-- Personalized Greeting -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-4">
        <h1 class="text-primary fw-bold">
            <i class="fas fa-tachometer-alt me-2"></i> Welcome, ${sessionScope.fullName}!
        </h1>
        <div class="mt-2 mt-md-0">
            <a href="${pageContext.request.contextPath}/submit" class="btn btn-success btn-sm me-2">
                <i class="fas fa-plus-circle me-1"></i> New Complaint
            </a>
            <a href="${pageContext.request.contextPath}/complaints" class="btn btn-outline-primary btn-sm me-2">
                <i class="fas fa-list me-1"></i> My Complaints
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="fas fa-sign-out-alt me-1"></i> Logout
            </a>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row g-4 row-cols-1 row-cols-sm-2 row-cols-md-5">
        <div class="col d-flex">
            <div class="card text-center shadow-sm p-3 rounded-4 bg-white card-animated card-hover flex-fill h-100">
                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                    <i class="fas fa-folder-open fa-2x text-warning mb-2"></i>
                    <h5 class="card-title fw-bold">Open</h5>
                    <p class="card-text fs-4">${stats.OPEN != null ? stats.OPEN : 0}</p>
                </div>
            </div>
        </div>

        <div class="col d-flex">
            <div class="card text-center shadow-sm p-3 rounded-4 bg-white card-animated card-hover flex-fill h-100">
                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                    <i class="fas fa-spinner fa-2x text-info mb-2"></i>
                    <h5 class="card-title fw-bold">In Progress</h5>
                    <p class="card-text fs-4">${stats.IN_PROGRESS != null ? stats.IN_PROGRESS : 0}</p>
                </div>
            </div>
        </div>

        <div class="col d-flex">
            <div class="card text-center shadow-sm p-3 rounded-4 bg-white card-animated card-hover flex-fill h-100">
                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                    <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                    <h5 class="card-title fw-bold">Resolved</h5>
                    <p class="card-text fs-4">${stats.RESOLVED != null ? stats.RESOLVED : 0}</p>
                </div>
            </div>
        </div>

        <div class="col d-flex">
            <div class="card text-center shadow-sm p-3 rounded-4 bg-white card-animated card-hover flex-fill h-100">
                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                    <i class="fas fa-lock fa-2x text-secondary mb-2"></i>
                    <h5 class="card-title fw-bold">Closed</h5>
                    <p class="card-text fs-4">${stats.CLOSED != null ? stats.CLOSED : 0}</p>
                </div>
            </div>
        </div>

        <div class="col d-flex">
            <div class="card text-center shadow-sm p-3 rounded-4 bg-white card-animated card-hover flex-fill h-100">
                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                    <i class="fas fa-exclamation-triangle fa-2x text-danger mb-2"></i>
                    <h5 class="card-title fw-bold">Overdue</h5>
                    <p class="card-text fs-4">${stats.OVERDUE != null ? stats.OVERDUE : 0}</p>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
