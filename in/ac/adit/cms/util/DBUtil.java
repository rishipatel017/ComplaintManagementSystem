package in.ac.adit.cms.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBUtil {
    private static HikariDataSource ds;

    static {
        HikariConfig config = new HikariConfig();
        // Update these values to match your DB
        config.setJdbcUrl("jdbc:mysql://localhost:3306/cmsdb");
        config.setUsername("root");
        config.setPassword("admin@2905");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setPoolName("CMSHikariPool");
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        ds = new HikariDataSource(config);
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

    public static DataSource getDataSource() {
        return ds;
    }

    public static void close() {
        if (ds != null && !ds.isClosed()) ds.close();
    }
}
