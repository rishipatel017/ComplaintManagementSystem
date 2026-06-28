package in.ac.adit.cms.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import in.ac.adit.cms.model.Complaint;
import in.ac.adit.cms.util.DBUtil;

public class ComplaintDAO {

	public int createComplaint(int userId, int categoryId, String title, String description, Date deadline)
			throws SQLException {
		String sql = "INSERT INTO complaints (user_id, category_id, title, description, resolution_deadline) VALUES (?, ?, ?, ?, ?)";
		try (Connection c = DBUtil.getConnection();
				PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, userId);
			ps.setInt(2, categoryId);
			ps.setString(3, title);
			ps.setString(4, description);
			if (deadline != null)
				ps.setDate(5, deadline);
			else
				ps.setNull(5, Types.DATE);
			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next())
					return rs.getInt(1);
				return -1;
			}
		}
	}

	public List<HashMap<String, Object>> listComplaintsByUser(int userId) throws SQLException {
		String sql = "SELECT c.id, c.title, c.status, c.resolution_deadline, c.created_at, cat.name as category_name "
				+ "FROM complaints c JOIN categories cat ON c.category_id = cat.id WHERE c.user_id = ? ORDER BY c.created_at DESC";
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				List<HashMap<String, Object>> list = new ArrayList<>();
				while (rs.next()) {
					HashMap<String, Object> m = new HashMap<>();
					m.put("id", rs.getInt("id"));
					m.put("title", rs.getString("title"));
					m.put("status", rs.getString("status"));
					m.put("deadline", rs.getDate("resolution_deadline"));
					m.put("created_at", rs.getTimestamp("created_at"));
					m.put("category", rs.getString("category_name"));
					list.add(m);
				}
				return list;
			}
		}
	}

	public HashMap<String, Object> getComplaint(int id) throws SQLException {
		String sql = "SELECT c.*, cat.name as category_name, u.full_name as user_name FROM complaints c "
				+ "JOIN categories cat ON c.category_id = cat.id JOIN users u ON c.user_id = u.id WHERE c.id = ?";
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return null;
				HashMap<String, Object> m = new HashMap<>();
				m.put("id", rs.getInt("id"));
				m.put("title", rs.getString("title"));
				m.put("description", rs.getString("description"));
				m.put("status", rs.getString("status"));
				m.put("deadline", rs.getDate("resolution_deadline"));
				m.put("created_at", rs.getTimestamp("created_at"));
				m.put("category", rs.getString("category_name"));
				m.put("user_name", rs.getString("user_name"));
				m.put("resolved_at", rs.getTimestamp("resolved_at"));
				return m;
			}
		}
	}

	public boolean markResolved(int id, int resolverId) throws SQLException {
		String sql = "UPDATE complaints SET status = 'RESOLVED', resolved_at = CURRENT_TIMESTAMP, assigned_to = ? WHERE id = ?";
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, resolverId);
			ps.setInt(2, id);
			return ps.executeUpdate() == 1;
		}
	}

	// fetch overdue complaints (for admin)
	public List<HashMap<String, Object>> listOverdue() throws SQLException {
		String sql = "SELECT c.id, c.title, c.status, c.resolution_deadline, u.full_name as owner FROM complaints c JOIN users u ON c.user_id = u.id WHERE c.status != 'RESOLVED' AND c.resolution_deadline IS NOT NULL AND c.resolution_deadline < CURDATE()";
		try (Connection c = DBUtil.getConnection();
				PreparedStatement ps = c.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			List<HashMap<String, Object>> out = new ArrayList<>();
			while (rs.next()) {
				HashMap<String, Object> m = new HashMap<>();
				m.put("id", rs.getInt("id"));
				m.put("title", rs.getString("title"));
				m.put("status", rs.getString("status"));
				m.put("deadline", rs.getDate("resolution_deadline"));
				m.put("owner", rs.getString("owner"));
				out.add(m);
			}
			return out;
		}
	}
	// Add these methods to existing ComplaintDAO class

	// Admin: list all complaints
	public List<HashMap<String, Object>> listAllComplaints() throws SQLException {
		String sql = "SELECT c.id, c.title, c.status, c.resolution_deadline, c.created_at, cat.name as category_name, u.full_name as owner "
				+ "FROM complaints c JOIN categories cat ON c.category_id = cat.id JOIN users u ON c.user_id = u.id ORDER BY c.created_at DESC";
		try (Connection c = DBUtil.getConnection();
				PreparedStatement ps = c.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			List<HashMap<String, Object>> out = new ArrayList<>();
			while (rs.next()) {
				HashMap<String, Object> m = new HashMap<>();
				m.put("id", rs.getInt("id"));
				m.put("title", rs.getString("title"));
				m.put("status", rs.getString("status"));
				m.put("deadline", rs.getDate("resolution_deadline"));
				m.put("created_at", rs.getTimestamp("created_at"));
				m.put("category", rs.getString("category_name"));
				m.put("owner", rs.getString("owner"));
				out.add(m);
			}
			return out;
		}
	}

	// Update status (or set IN_PROGRESS/RESOLVED)
	public boolean updateStatus(int complaintId, String newStatus, int updatedBy, String note) throws SQLException {
		String sql = "UPDATE complaints SET status = ?, assigned_to = ? WHERE id = ?";
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, newStatus);
			ps.setInt(2, updatedBy);
			ps.setInt(3, complaintId);
			int updated = ps.executeUpdate();

			if (updated > 0) {
				// insert audit
				insertAudit(complaintId, updatedBy, "STATUS_UPDATE", note);
				return true;
			}
			return false;
		}
	}

	// Abort a complaint with reason
	public boolean abortComplaint(int complaintId, int abortedBy, String reason) throws SQLException {
		String sql = "UPDATE complaints SET status = 'CLOSED', abort_reason = ?, aborted_by = ? WHERE id = ?";
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, reason);
			ps.setInt(2, abortedBy);
			ps.setInt(3, complaintId);
			int updated = ps.executeUpdate();

			if (updated > 0) {
				insertAudit(complaintId, abortedBy, "ABORT", reason);
				return true;
			}
			return false;
		}
	}

	// Add feedback to a completed complaint (student)
	public boolean addFeedback(int complaintId, String feedbackText, int rating, int userId) throws SQLException {
		String sql = "UPDATE complaints SET feedback_text = ?, feedback_rating = ? WHERE id = ? AND user_id = ?";
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, feedbackText);
			ps.setInt(2, rating);
			ps.setInt(3, complaintId);
			ps.setInt(4, userId);
			int updated = ps.executeUpdate();
			if (updated > 0) {
				insertAudit(complaintId, userId, "FEEDBACK", "Rating: " + rating);
				return true;
			}
			return false;
		}
	}

	// Insert audit helper
	private void insertAudit(int complaintId, Integer userId, String type, String desc) throws SQLException {
		String sql = "INSERT INTO complaint_audit (complaint_id, changed_by, change_type, change_desc) VALUES (?, ?, ?, ?)";
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, complaintId);
			if (userId != null)
				ps.setInt(2, userId);
			else
				ps.setNull(2, java.sql.Types.INTEGER);
			ps.setString(3, type);
			ps.setString(4, desc);
			ps.executeUpdate();
		}
	}

	// Dashboard stats (simple counts)
	public HashMap<String, Integer> getDashboardStats(int userId, String role) throws SQLException {
		HashMap<String, Integer> stats = new HashMap<>();
		String sql;
		if ("admin".equalsIgnoreCase(role) || "faculty".equalsIgnoreCase(role)) {
			sql = "SELECT status, COUNT(*) cnt FROM complaints GROUP BY status";
			try (Connection c = DBUtil.getConnection();
					PreparedStatement ps = c.prepareStatement(sql);
					ResultSet rs = ps.executeQuery()) {
				while (rs.next())
					stats.put(rs.getString("status"), rs.getInt("cnt"));
			}
		} else {
			sql = "SELECT status, COUNT(*) cnt FROM complaints WHERE user_id = ? GROUP BY status";
			try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
				ps.setInt(1, userId);
				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next())
						stats.put(rs.getString("status"), rs.getInt("cnt"));
				}
			}
		}
		// overdue count
		String overdueSql = "SELECT COUNT(*) FROM complaints WHERE status != 'RESOLVED' AND resolution_deadline IS NOT NULL AND resolution_deadline < CURDATE()"
				+ (("admin".equalsIgnoreCase(role) || "faculty".equalsIgnoreCase(role)) ? "" : " AND user_id = ?");
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(overdueSql)) {
			if (!("admin".equalsIgnoreCase(role) || "faculty".equalsIgnoreCase(role)))
				ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					stats.put("OVERDUE", rs.getInt(1));
			}
		}
		return stats;
	}

	public boolean withdrawComplaint(int complaintId, int userId) throws SQLException {
		String sql = "UPDATE complaints SET status = 'WITHDRAW' WHERE id = ? AND user_id = ? AND status IN ('OPEN','IN_PROGRESS')";
		try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, complaintId);
			ps.setInt(2, userId);
			int rows = ps.executeUpdate();
			return rows > 0;
		}
	}

	public List<Complaint> getComplaintsForAudit(String status) throws Exception {
		List<Complaint> list = new ArrayList<>();
		String sql = "SELECT c.id, c.title, c.status, u.full_name, c.created_at "
				+ "FROM complaints c JOIN users u ON c.user_id = u.id";
		if (!"ALL".equalsIgnoreCase(status)) {
			sql += " WHERE c.status = ?";
		}

		try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			if (!"ALL".equalsIgnoreCase(status)) {
				ps.setString(1, status);
			}
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Complaint c = new Complaint();
				c.setId(rs.getInt(1));
				c.setTitle(rs.getString(2));
				c.setStatus(rs.getString(3));
				c.setCreatedByName(rs.getString(4));
				c.setCreatedAt(rs.getTimestamp(5));
				list.add(c);
			}
		}
		return list;
	}
	

}
