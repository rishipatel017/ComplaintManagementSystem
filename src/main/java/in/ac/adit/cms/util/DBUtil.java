package in.ac.adit.cms.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DBUtil {

	private static HikariDataSource dataSource;

	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			HikariConfig config = new HikariConfig();
			config.setJdbcUrl("jdbc:mysql://localhost:3306/cmsdb?serverTimezone=UTC");
			config.setUsername("root");
			config.setPassword("");
			config.setMaximumPoolSize(10);

			dataSource = new HikariDataSource(config);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Error initializing DB connection", e);
		}
	}

	public static Connection getConnection() throws SQLException {
		return dataSource.getConnection();
	}

	public static DataSource getDataSource() {
		return dataSource;
	}
}
