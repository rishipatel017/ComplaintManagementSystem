<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Admin Dashboard - CMS</title>

<!-- Bootstrap 5 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Lato:wght@400;700&display=swap"
	rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css">

<style>
th {
	cursor: pointer;
}

th.sort-asc::after {
	content: " ▲";
}

th.sort-desc::after {
	content: " ▼";
}

@
keyframes fadeIn { 0% {
	opacity: 0;
	transform: translateY(-20px);
}
100
%
{
opacity
:
1;
transform
:
translateY(
0
);
}
}
</style>
</head>
<body class="bg-light" style="font-family: 'Roboto', sans-serif;">

	<div class="container py-4">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2 class="text-primary">
				<i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard
			</h2>
			<div>
				Welcome, <strong>${sessionScope.fullName}</strong> | <a
					href="${pageContext.request.contextPath}/admin/complaints"
					class="btn btn-outline-secondary btn-sm me-1"><i
					class="fas fa-list me-1"></i> Manage Complaints</a> <a
					href="${pageContext.request.contextPath}/logout"
					class="btn btn-outline-danger btn-sm"><i
					class="fas fa-sign-out-alt me-1"></i> Logout</a>
			</div>
		</div>

		<!-- Complaint Stats -->
		<div class="card shadow-sm p-3 mb-4 rounded-4"
			style="animation: fadeIn 1s ease;">
			<h4 class="text-secondary mb-3">
				<i class="fas fa-chart-bar me-2"></i> Complaint Stats
			</h4>
			<div class="row text-center">
				<div class="col">
					<span class="badge bg-primary fs-6">Open: ${stats.OPEN}</span>
				</div>
				<div class="col">
					<span class="badge bg-info fs-6">In Progress:
						${stats.IN_PROGRESS}</span>
				</div>
				<div class="col">
					<span class="badge bg-success fs-6">Resolved:
						${stats.RESOLVED}</span>
				</div>
				<div class="col">
					<span class="badge bg-secondary fs-6">Closed:
						${stats.CLOSED}</span>
				</div>
				<div class="col">
					<span class="badge bg-danger fs-6">Overdue: ${stats.OVERDUE}</span>
				</div>
			</div>
		</div>

		<!-- Audit Report Form -->
		<div class="card shadow-sm p-3 mb-4 rounded-4"
			style="animation: fadeIn 1.2s ease;">
			<h4 class="text-secondary mb-3">
				<i class="fas fa-file-pdf me-2"></i> Audit Report
			</h4>
			<form action="${pageContext.request.contextPath}/audit-report"
				method="get" class="needs-validation" novalidate>
				<div class="row g-3 align-items-center">
					<div class="col-md-4">
						<label for="status" class="form-label fw-semibold">Filter
							by Status</label> <select id="status" name="status" class="form-select"
							pattern="^(ALL|OPEN|IN_PROGRESS|RESOLVED|CLOSED)$" required>
							<option value="">Select Status</option>
							<option value="ALL">All</option>
							<option value="OPEN">Open</option>
							<option value="IN_PROGRESS">In Progress</option>
							<option value="RESOLVED">Resolved</option>
							<option value="CLOSED">Closed</option>
						</select>
						<div class="invalid-feedback">Please select a valid status.</div>
					</div>
					<div class="col-md-2 align-self-end">
						<button type="submit" class="btn btn-primary w-100 mt-2">
							<i class="fas fa-download me-1"></i> Generate PDF
						</button>
					</div>
				</div>
			</form>
		</div>

		<!-- Example Audit Report Table -->
		<div class="card shadow-sm p-3 rounded-4"
			style="animation: fadeIn 1.4s ease;">
			<h4 class="text-secondary mb-3">
				<i class="fas fa-table me-2"></i> Recent Complaints
			</h4>
			<table class="table table-hover table-striped" id="complaintsTable">
				<thead class="table-light">
					<tr>
						<th onclick="sortTable(0)">ID</th>
						<th onclick="sortTable(1)">Title</th>
						<th onclick="sortTable(2)">Owner</th>
						<th onclick="sortTable(3)">Category</th>
						<th onclick="sortTable(4)">Status</th>
						<th onclick="sortTable(5)">Deadline</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="c" items="${complaints}">
						<tr>
							<td>${c.id}</td>
							<td>${c.title}</td>
							<td>${c.createdByName}</td>
							<td>${c.category}</td>
							<td>${c.status}</td>
							<td>${c.deadline}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

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

// Table Sorting
let sortDirection = [];
function sortTable(n) {
    const table = document.getElementById("complaintsTable");
    let switching = true, i, rows, x, y, shouldSwitch;
    if(sortDirection[n] === undefined) sortDirection[n] = true;

    while(switching){
        switching = false;
        rows = table.rows;
        for(i=1;i<rows.length-1;i++){
            shouldSwitch = false;
            x = rows[i].getElementsByTagName("TD")[n];
            y = rows[i+1].getElementsByTagName("TD")[n];
            let xContent = x.textContent || x.innerText;
            let yContent = y.textContent || y.innerText;

            if(n===0){ // numeric sort for ID
                xContent = parseInt(xContent);
                yContent = parseInt(yContent);
            }

            if(sortDirection[n] ? (xContent > yContent) : (xContent < yContent)){
                shouldSwitch = true;
                break;
            }
        }
        if(shouldSwitch){
            rows[i].parentNode.insertBefore(rows[i+1], rows[i]);
            switching = true;
        }
    }
    sortDirection[n] = !sortDirection[n];

    // Update header arrows
    const headers = table.getElementsByTagName("TH");
    for(let h=0; h<headers.length; h++){
        headers[h].classList.remove("sort-asc","sort-desc");
        if(h===n){
            headers[h].classList.add(sortDirection[n] ? "sort-asc":"sort-desc");
        }
    }
}
</script>
</body>
</html>
