package in.ac.adit.cms.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.ac.adit.cms.dao.ComplaintDAO;

@WebServlet("/admin/complaints")
public class AdminComplaintServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private ComplaintDAO dao = new ComplaintDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// list all complaints for admin/faculty
		try {
			req.setAttribute("complaints", dao.listAllComplaints());
			req.getRequestDispatcher("/WEB-INF/jsp/admin_list.jsp").forward(req, resp);
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}

	// Handle status update and abort (POST)
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession s = req.getSession(false);
		int userId = (Integer) s.getAttribute("userId");
		String action = req.getParameter("action");
		int complaintId = Integer.parseInt(req.getParameter("complaintId"));

		try {
			if ("updateStatus".equals(action)) {
				String status = req.getParameter("status");
				String note = req.getParameter("note");
				dao.updateStatus(complaintId, status, userId, note);
			} else if ("abort".equals(action)) {
				String reason = req.getParameter("reason");
				dao.abortComplaint(complaintId, userId, reason);
			}
			resp.sendRedirect(req.getContextPath() + "/admin/complaints");
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}
}
