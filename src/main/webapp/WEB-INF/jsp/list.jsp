<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.sql.Date"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>My Complaints - CMS</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Lato:wght@400;700&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css">

<style>
    th { cursor: pointer; }
    th.sort-asc::after { content: " ▲"; }
    th.sort-desc::after { content: " ▼"; }

    @keyframes fadeIn {
        0% {opacity: 0; transform: translateY(-20px);}
        100% {opacity: 1; transform: translateY(0);}
    }
</style>

</head>
<body class="bg-light" style="font-family: 'Roboto', sans-serif;">

<div class="container py-5" style="animation: fadeIn 1s ease;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary"><i class="fas fa-list me-2"></i>My Complaints</h2>
        <div>
            <a href="${pageContext.request.contextPath}/submit" class="btn btn-success btn-sm me-2">
                <i class="fas fa-plus me-1"></i> New Complaint
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="fas fa-sign-out-alt me-1"></i> Logout
            </a>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle mb-0" id="complaintsTable">
                <thead class="table-primary">
                    <tr>
                        <th onclick="sortTable(0)">ID</th>
                        <th onclick="sortTable(1)">Category</th>
                        <th onclick="sortTable(2)">Description</th>
                        <th onclick="sortTable(3)">Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="complaint" items="${complaints}">
                        <tr>
                            <td>${complaint.id}</td>
                            <td>${complaint.category}</td>
                            <td>${complaint.description}</td>
                            <td>
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${complaint.status == 'OPEN'}">bg-warning</c:when>
                                        <c:when test="${complaint.status == 'IN_PROGRESS'}">bg-info</c:when>
                                        <c:when test="${complaint.status == 'RESOLVED'}">bg-success</c:when>
                                        <c:when test="${complaint.status == 'CLOSED'}">bg-secondary</c:when>
                                        <c:when test="${complaint.status == 'ABORTED'}">bg-danger</c:when>
                                    </c:choose>
                                    text-white px-2 py-1">
                                    ${complaint.status}
                                </span>
                            </td>
                            <td>
                                <!-- View Details -->
                                <a href="${pageContext.request.contextPath}/complaint?id=${complaint.id}"  class="btn btn-primary btn-sm me-1">
                                   <i class="fas fa-eye me-1"></i> View
                                </a>

                                <!-- Withdraw Action -->
                                <c:if test="${complaint.status == 'OPEN' || complaint.status == 'IN_PROGRESS'}">
                                    <form action="${pageContext.request.contextPath}/withdrawComplaint" method="post" style="display:inline;">
                                        <input type="hidden" name="complaintId" value="${complaint.id}" />
                                        <button type="submit" class="btn btn-outline-danger btn-sm" 
                                            onclick="return confirm('Are you sure you want to withdraw this complaint?');">
                                            <i class="fas fa-times-circle me-1"></i> Withdraw
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <c:if test="${empty complaints}">
        <div class="alert alert-info mt-3">
            No complaints found.
        </div>
    </c:if>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Sorting script -->
<script>
let sortDirection = [];
function sortTable(n) {
    const table = document.getElementById("complaintsTable");
    let rows, switching, i, x, y, shouldSwitch;
    switching = true;

    if(sortDirection[n] === undefined) sortDirection[n] = true;

    while (switching) {
        switching = false;
        rows = table.rows;
        for (i = 1; i < (rows.length - 1); i++) {
            shouldSwitch = false;
            x = rows[i].getElementsByTagName("TD")[n];
            y = rows[i + 1].getElementsByTagName("TD")[n];
            let xContent = x.textContent || x.innerText;
            let yContent = y.textContent || y.innerText;

            if(n === 0){
                xContent = parseInt(xContent);
                yContent = parseInt(yContent);
            } else {
                xContent = xContent.toLowerCase();
                yContent = yContent.toLowerCase();
            }

            if (sortDirection[n] ? (xContent > yContent) : (xContent < yContent)) {
                shouldSwitch = true;
                break;
            }
        }
        if (shouldSwitch) {
            rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
            switching = true;
        }
    }
    sortDirection[n] = !sortDirection[n];

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
