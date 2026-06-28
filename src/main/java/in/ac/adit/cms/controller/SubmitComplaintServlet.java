package in.ac.adit.cms.controller;

import java.io.IOException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.ac.adit.cms.dao.ComplaintDAO;

@WebServlet("/submit")
public class SubmitComplaintServlet extends javax.servlet.http.HttpServlet {
	private ComplaintDAO dao = new ComplaintDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO: load categories dynamically from DB (for simplicity, hardcoded here or
		// implement CategoryDAO)
		req.setAttribute("categories", new String[][] { { "1", "IT" }, { "2", "FACILITY" }, { "3", "ADMIN" } });
		req.getRequestDispatcher("/WEB-INF/jsp/submit.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		int userId = (Integer) session.getAttribute("userId");
		int categoryId = Integer.parseInt(req.getParameter("categoryId"));
		String title = req.getParameter("title");
		String description = req.getParameter("description");
		String deadlineStr = req.getParameter("deadline"); // yyyy-MM-dd

		Date deadline = null;
		try {
			if (deadlineStr != null && !deadlineStr.trim().isEmpty()) {
				deadline = Date.valueOf(deadlineStr);
			}
		} catch (Exception ignore) {
		}

		try {
			dao.createComplaint(userId, categoryId, title, description, deadline);
			resp.sendRedirect(req.getContextPath() + "/complaints");
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}
}
