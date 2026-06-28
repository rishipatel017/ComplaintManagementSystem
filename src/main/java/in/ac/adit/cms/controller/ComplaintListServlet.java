package in.ac.adit.cms.controller;

import in.ac.adit.cms.dao.ComplaintDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/complaints")
public class ComplaintListServlet extends javax.servlet.http.HttpServlet {
    private ComplaintDAO dao = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest req, javax.servlet.http.HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int userId = (Integer) s.getAttribute("userId");
        try {
            req.setAttribute("complaints", dao.listComplaintsByUser(userId));
            req.setAttribute("today", new java.sql.Date(System.currentTimeMillis()));
            req.getRequestDispatcher("/WEB-INF/jsp/list.jsp").forward(req, resp);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
