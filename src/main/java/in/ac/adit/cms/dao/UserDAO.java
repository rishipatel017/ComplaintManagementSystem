package in.ac.adit.cms.dao;

import in.ac.adit.cms.model.User;
import in.ac.adit.cms.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // Authenticate user (login)
    public User authenticate(String username, String password) throws SQLException {
        String sql = "SELECT id, username, full_name, role, password_hash FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");

                    // For now, simple match — later we'll use BCrypt
                    if (storedHash.equals(password)) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setFullName(rs.getString("full_name"));
                        user.setRole(rs.getString("role"));
                        return user;
                    }
                }
            }
        }
        return null;
    }

    // Register new user
    public boolean register(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password_hash, full_name, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());   // we'll hash later
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getRole());
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    // Check if username exists
    public boolean userExists(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
