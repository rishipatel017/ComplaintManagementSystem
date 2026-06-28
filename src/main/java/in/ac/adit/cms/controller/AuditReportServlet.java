package in.ac.adit.cms.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import in.ac.adit.cms.dao.ComplaintDAO;
import in.ac.adit.cms.model.Complaint;

@WebServlet("/audit-report")
public class AuditReportServlet extends HttpServlet {

	private ComplaintDAO complaintDAO = new ComplaintDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("role") == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		String role = (String) session.getAttribute("role");
		if (!"admin".equalsIgnoreCase(role) && !"staff".equalsIgnoreCase(role)) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		String statusFilter = req.getParameter("status");
		if (statusFilter == null)
			statusFilter = "ALL";

		try {
			// fetch complaints based on filter
			List<Complaint> complaints = complaintDAO.getComplaintsForAudit(statusFilter);

			// Set PDF response headers
			resp.setContentType("application/pdf");
			resp.setHeader("Content-Disposition", "attachment; filename=audit_report.pdf");

			Document document = new Document();
			PdfWriter.getInstance(document, resp.getOutputStream());
			document.open();

			// Title
			Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
			Paragraph title = new Paragraph("Complaint Audit Report", titleFont);
			title.setAlignment(Element.ALIGN_CENTER);
			document.add(title);
			document.add(new Paragraph(" "));
			document.add(new Paragraph("Status Filter: " + statusFilter));
			document.add(new Paragraph("Generated on: " + new java.util.Date()));
			document.add(new Paragraph(" "));

			// Table
			PdfPTable table = new PdfPTable(5);
			table.setWidthPercentage(100);
			table.addCell("ID");
			table.addCell("Title");
			table.addCell("Status");
			table.addCell("Created By");
			table.addCell("Created At");

			for (Complaint c : complaints) {
				table.addCell(String.valueOf(c.getId()));
				table.addCell(c.getTitle());
				table.addCell(c.getStatus());
				table.addCell(c.getCreatedByName());
				table.addCell(c.getCreatedAt().toString());
			}

			document.add(table);
			document.close();

		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}
}
