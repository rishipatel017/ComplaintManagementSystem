package in.ac.adit.cms.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.ac.adit.cms.dao.ComplaintDAO;

@WebServlet("/withdrawComplaint")
public class WithdrawComplaintServlet extends HttpServlet {
	private ComplaintDAO complaintDAO = new ComplaintDAO();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		int userId = (Integer) session.getAttribute("userId");
		String role = (String) session.getAttribute("role");

		if (!"student".equalsIgnoreCase(role)) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		int complaintId = Integer.parseInt(req.getParameter("complaintId"));

		try {
			boolean success = complaintDAO.withdrawComplaint(complaintId, userId);
			if (!success) {
				req.getSession().setAttribute("error",
						"Unable to withdraw complaint. It may not be yours or already resolved.");
			}
			resp.sendRedirect(req.getContextPath() + "/dashboard");
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}
