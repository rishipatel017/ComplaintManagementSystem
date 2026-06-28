<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Admin - Manage Complaints</title>

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
        <h2 class="text-primary"><i class="fas fa-tasks me-2"></i>All Complaints</h2>
        <div>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary btn-sm me-2">
                <i class="fas fa-home me-1"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="fas fa-sign-out-alt me-1"></i> Logout
            </a>
        </div>
    </div>

    <!-- Filter Form -->
    <div class="card mb-4 p-3">
        <form method="get" action="${pageContext.request.contextPath}/admin/complaints" class="row g-3 align-items-center">
            <div class="col-auto">
                <label for="statusFilter" class="col-form-label fw-semibold">Filter by Status:</label>
            </div>
            <div class="col-auto">
                <select name="status" id="statusFilter" class="form-select">
                    <option value="">All</option>
                    <option value="OPEN" ${param.status == 'OPEN' ? 'selected' : ''}>OPEN</option>
                    <option value="IN_PROGRESS" ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                    <option value="RESOLVED" ${param.status == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                    <option value="CLOSED" ${param.status == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
                    <option value="ABORTED" ${param.status == 'ABORTED' ? 'selected' : ''}>ABORTED</option>
                </select>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-filter me-1"></i> Apply</button>
                <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-secondary btn-sm"><i class="fas fa-redo me-1"></i> Reset</a>
            </div>
        </form>
    </div>

    <!-- Complaints Table -->
    <div class="card shadow-sm p-3">
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle" id="complaintsTable">
                <thead class="table-primary">
                    <tr>
                        <th onclick="sortTable(0)">ID</th>
                        <th onclick="sortTable(1)">Title</th>
                        <th onclick="sortTable(2)">Owner</th>
                        <th onclick="sortTable(3)">Category</th>
                        <th onclick="sortTable(4)">Status</th>
                        <th onclick="sortTable(5)">Deadline</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${complaints}">
                        <tr>
                            <td>${c.id}</td>
                            <td><c:out value="${c.title}" /></td>
                            <td><c:out value="${c.createdByName}" /></td>
                            <td><c:out value="${c.category}" /></td>
                            <td>
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${c.status == 'OPEN'}">bg-warning</c:when>
                                        <c:when test="${c.status == 'IN_PROGRESS'}">bg-info</c:when>
                                        <c:when test="${c.status == 'RESOLVED'}">bg-success</c:when>
                                        <c:when test="${c.status == 'CLOSED'}">bg-secondary</c:when>
                                        <c:when test="${c.status == 'ABORTED'}">bg-danger</c:when>
                                    </c:choose>
                                    text-white px-2 py-1">
                                    ${c.status}
                                </span>
                            </td>
                            <td><c:out value="${c.deadline}" /></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/complaint?id=${c.id}" class="btn btn-primary btn-sm me-1">
                                    <i class="fas fa-eye me-1"></i> View
                                </a>

                                <form method="post" action="${pageContext.request.contextPath}/admin/complaints" style="display:inline;">
                                    <input type="hidden" name="complaintId" value="${c.id}" />
                                    <input type="hidden" name="action" value="updateStatus" />
                                    <select name="status" class="form-select form-select-sm d-inline w-auto" required>
                                        <option value="OPEN">OPEN</option>
                                        <option value="IN_PROGRESS">IN_PROGRESS</option>
                                        <option value="RESOLVED">RESOLVED</option>
                                        <option value="CLOSED">CLOSED</option>
                                    </select>
                                    <input type="text" name="note" placeholder="Note (optional)" class="form-control form-control-sm d-inline w-auto"/>
                                    <button type="submit" class="btn btn-success btn-sm mt-1"><i class="fas fa-check me-1"></i> Update</button>
                                </form>

                                <form method="post" action="${pageContext.request.contextPath}/admin/complaints" style="display:inline;">
                                    <input type="hidden" name="complaintId" value="${c.id}" />
                                    <input type="hidden" name="action" value="abort" />
                                    <input type="text" name="reason" placeholder="Abort reason" class="form-control form-control-sm d-inline w-auto" required/>
                                    <button type="submit" class="btn btn-danger btn-sm mt-1"><i class="fas fa-ban me-1"></i> Abort</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <c:if test="${empty complaints}">
        <div class="alert alert-info mt-3">No complaints found for the selected status.</div>
    </c:if>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Table Sorting -->
<script>
let sortDirection = [];
function sortTable(n) {
    const table = document.getElementById("complaintsTable");
    let switching = true;
    if(sortDirection[n] === undefined) sortDirection[n] = true;

    while (switching) {
        switching = false;
        const rows = table.rows;
        for (let i = 1; i < rows.length - 1; i++) {
            let shouldSwitch = false;
            let x = rows[i].getElementsByTagName("TD")[n];
            let y = rows[i + 1].getElementsByTagName("TD")[n];
            let xContent = x.textContent || x.innerText;
            let yContent = y.textContent || y.innerText;
            if(n === 0){ xContent = parseInt(xContent); yContent = parseInt(yContent); }
            if(sortDirection[n] ? (xContent > yContent) : (xContent < yContent)) { shouldSwitch = true; break; }
        }
        if (shouldSwitch) {
            rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
            switching = true;
        }
    }

    sortDirection[n] = !sortDirection[n];
    const headers = table.getElementsByTagName("TH");
    for(let h=0; h<headers.length; h++){ headers[h].classList.remove("sort-asc","sort-desc"); if(h===n){ headers[h].classList.add(sortDirection[n] ? "sort-asc":"sort-desc"); }}
}
</script>

</body>
</html>
