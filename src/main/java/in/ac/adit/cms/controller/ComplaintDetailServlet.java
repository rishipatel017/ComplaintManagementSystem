package in.ac.adit.cms.controller;

import in.ac.adit.cms.dao.ComplaintDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/complaint")
public class ComplaintDetailServlet extends javax.servlet.http.HttpServlet {
    private ComplaintDAO dao = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest req, javax.servlet.http.HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/complaints");
            return;
        }
        try {
            int id = Integer.parseInt(idStr);
            req.setAttribute("complaint", dao.getComplaint(id));
            req.getRequestDispatcher("/WEB-INF/jsp/detail.jsp").forward(req, resp);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
