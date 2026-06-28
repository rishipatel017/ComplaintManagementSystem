package in.ac.adit.cms.controller;

import java.io.IOException;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import in.ac.adit.cms.dao.UserDAO;
import in.ac.adit.cms.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private UserDAO userDao = new UserDAO();
		private static final String STUDENT_EMAIL_REGEX = "^[A-Za-z0-9._%+-]+@adit\\.ac\\.in$";

	private static final String STAFF_VERIFICATION_CODE = "ADIT-STAFF-2025"; // ✅ store securely in DB or config

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Add cache headers to protect page if needed
		resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		resp.setHeader("Pragma", "no-cache");
		resp.setDateHeader("Expires", 0);

		// Forward to JSP
		req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String fullName = req.getParameter("fullName");
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		String role = req.getParameter("role");

		String rollNumber = req.getParameter("rollNumber");
		String studentEmail = req.getParameter("studentEmail");
		String staffId = req.getParameter("staffId");
		String verificationCode = req.getParameter("verificationCode");

		try {
			// ✅ Validate based on role
			if ("student".equalsIgnoreCase(role)) {
				if (rollNumber == null || rollNumber.trim().isEmpty() || studentEmail == null
						|| !Pattern.matches(STUDENT_EMAIL_REGEX, studentEmail)) {
					req.setAttribute("error", "Invalid roll number or college email.");
					req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
					return;
				}
			} else if ("staff".equalsIgnoreCase(role)) {
				if (staffId == null || staffId.trim().isEmpty() || !STAFF_VERIFICATION_CODE.equals(verificationCode)) {
					req.setAttribute("error", "Invalid staff ID or verification code.");
					req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
					return;
				}
			} else {
				req.setAttribute("error", "Invalid role selected.");
				req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
				return;
			}

			// ✅ Proceed with registration
			if (userDao.userExists(username)) {
				req.setAttribute("error", "Username already exists.");
				req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
				return;
			}

			User u = new User();
			u.setFullName(fullName);
			u.setUsername(username);
			u.setPassword(password);
			u.setRole(role);
			u.setRollNumber(rollNumber);
			u.setEmail(studentEmail);
			u.setStaffId(staffId);

			userDao.register(u);
			resp.sendRedirect(req.getContextPath() + "/login");

		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}
