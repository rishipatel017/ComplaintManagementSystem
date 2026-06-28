package in.ac.adit.cms.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.ac.adit.cms.dao.ComplaintDAO;

@WebServlet("/complaint/feedback")
public class FeedbackServlet extends HttpServlet {
	private ComplaintDAO dao = new ComplaintDAO();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession s = req.getSession(false);
		if (s == null || s.getAttribute("userId") == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		int userId = (Integer) s.getAttribute("userId");

		// basic CSRF check
		String csrf = req.getParameter("csrf");
		String sessionCsrf = (String) s.getAttribute("CSRF_TOKEN");
		if (sessionCsrf == null || !sessionCsrf.equals(csrf)) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
			return;
		}

		int complaintId = Integer.parseInt(req.getParameter("complaintId"));
		String feedback = req.getParameter("feedback");
		int rating = 0;
		try {
			rating = Integer.parseInt(req.getParameter("rating"));
		} catch (Exception ignored) {
		}

		try {
			boolean ok = dao.addFeedback(complaintId, feedback, rating, userId);
			if (ok)
				resp.sendRedirect(req.getContextPath() + "/complaints");
			else {
				req.setAttribute("error", "Unable to add feedback");
				req.getRequestDispatcher("/WEB-INF/jsp/detail.jsp").forward(req, resp);
			}
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}
}
