package in.ac.adit.cms.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.ac.adit.cms.dao.ComplaintDAO;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ComplaintDAO dao = new ComplaintDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession s = req.getSession(false);
		if (s == null || s.getAttribute("userId") == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		resp.setHeader("Pragma", "no-cache");
		resp.setDateHeader("Expires", 0);

		int userId = (Integer) s.getAttribute("userId");
		String role = (String) s.getAttribute("role");

		try {
			req.setAttribute("stats", dao.getDashboardStats(userId, role));

			// 🆕 load complaints for student dashboard
			if ("student".equalsIgnoreCase(role)) {
				req.setAttribute("complaints", dao.getComplaint(userId));
				req.getRequestDispatcher("/WEB-INF/jsp/student_dashboard.jsp").forward(req, resp);
			} else {
				req.getRequestDispatcher("/WEB-INF/jsp/admin_dashboard.jsp").forward(req, resp);
			}
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}

}
