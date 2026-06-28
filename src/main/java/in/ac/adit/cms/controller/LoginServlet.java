package in.ac.adit.cms.controller;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.ac.adit.cms.dao.UserDAO;
import in.ac.adit.cms.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private UserDAO userDao = new UserDAO();
	private static final int SESSION_TIMEOUT_SECONDS = 30 * 60; // 30 minutes

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session != null && session.getAttribute("userId") != null) {
			String role = (String) session.getAttribute("role");
			resp.sendRedirect(req.getContextPath() + "/dashboard");
			return;
		}

		// Explicit cache headers for login page
		resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		resp.setHeader("Pragma", "no-cache");
		resp.setDateHeader("Expires", 0);

		req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String username = req.getParameter("username");
		String password = req.getParameter("password");

		try {
			User user = userDao.authenticate(username, password);
			if (user != null) {
				// Protect against session fixation: invalidate old session and create a new one
				HttpSession oldSession = req.getSession(false);
				if (oldSession != null)
					oldSession.invalidate();

				HttpSession session = req.getSession(true);
				session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);
				session.setAttribute("userId", user.getId());
				session.setAttribute("username", user.getUsername());
				session.setAttribute("fullName", user.getFullName());
				session.setAttribute("role", user.getRole());

				// CSRF token for forms
				String csrf = UUID.randomUUID().toString();
				session.setAttribute("CSRF_TOKEN", csrf);

				// Set session cookie flags (HttpOnly, Secure if request is secure)
				Cookie[] cookies = req.getCookies();
				// Note: container normally sets HttpOnly; but we ensure Secure flag if request
				// is secure
				if (req.isSecure()) {
					Cookie jsession = new Cookie("JSESSIONID", session.getId());
					jsession.setHttpOnly(true);
					jsession.setSecure(true);
					jsession.setPath(req.getContextPath());
					resp.addCookie(jsession);
				}
				resp.sendRedirect(req.getContextPath() + "/dashboard");
			} else {
				req.setAttribute("error", "Invalid username or password");
				req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
			}
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}
}
