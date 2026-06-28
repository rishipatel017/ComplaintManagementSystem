package in.ac.adit.cms.dao;

import java.sql.*;
import java.util.*;

public class ComplaintDAO {
	public int createComplaint(int userId, int categoryId, String title, String desc, Date deadline)
			throws SQLException {
		String sql = "INSERT INTO complaints (user_id, category_id, title, description, resolution_deadline) VALUES (?, ?, ?, ?, ?)";
		try (Connection c = DBUtil.getConnection();
				PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, userId);
			ps.setInt(2, categoryId);
			ps.setString(3, title);
			ps.setString(4, desc);
			if (deadline != null)
				ps.setDate(5, new java.sql.Date(deadline.getTime()));
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

	public List<Map<String, Object>> listComplaintsByUser(int userId) throws SQLException {
		String sql = "SELECT c.*, cat.name as category_name FROM complaints c JOIN categories cat ON c.category_id = cat.id WHERE c.user_id = ? ORDER BY c.created_at DESC";
		try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				List<Map<String, Object>> list = new ArrayList<>();
				while (rs.next()) {
					Map<String, Object> row = new HashMap<>();
					row.put("id", rs.getInt("id"));
					row.put("title", rs.getString("title"));
					row.put("status", rs.getString("status"));
					row.put("category", rs.getString("category_name"));
					row.put("deadline", rs.getDate("resolution_deadline"));
					row.put("created_at", rs.getTimestamp("created_at"));
					list.add(row);
				}
				return list;
			}
		}
	}

	public Map<String, Object> getComplaint(int id) throws SQLException {
		String sql = "SELECT c.*, cat.name as category_name, u.full_name as user_name FROM complaints c JOIN categories cat ON c.category_id = cat.id JOIN users u ON c.user_id = u.id WHERE c.id = ?";
		try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return null;
				Map<String, Object> m = new HashMap<>();
				m.put("id", rs.getInt("id"));
				m.put("title", rs.getString("title"));
				m.put("description", rs.getString("description"));
				m.put("status", rs.getString("status"));
				m.put("category", rs.getString("category_name"));
				m.put("deadline", rs.getDate("resolution_deadline"));
				m.put("created_at", rs.getTimestamp("created_at"));
				m.put("user_name", rs.getString("user_name"));
				m.put("resolved_at", rs.getTimestamp("resolved_at"));
				return m;
			}
		}
	}

	public boolean markResolved(int id, int resolverId) throws SQLException {
		String sql = "UPDATE complaints SET status='RESOLVED', resolved_at = CURRENT_TIMESTAMP, assigned_to = ? WHERE id = ?";
		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, resolverId);
			ps.setInt(2, id);
			return ps.executeUpdate() == 1;
		}
	}

	// add more functions: assign, change status, search overdue, etc.
}
