package util;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseUtils {
    private static final String SERVER = "ND2P"; // tên máy
    private static final String INSTANCE = "PHUONG"; // tên instance
    private static final String PORT = "1433";
    private static final String USER = "sa"; 
    private static final String PASSWORD = "123"; // đổi mật khẩu
    private static final String SCHEMA_PATH = "D:/FPT/2025.SU5/SWP391/template.sql"; // Đường dẫn đến file schema

    public static void createDatabaseWithSchema(String newDbName) throws SQLException {
        try {
            // Load driver nếu cần
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        }

        // Kết nối tới SQL Server (không chọn database cụ thể)
        String url = "jdbc:sqlserver://" + SERVER + ":" + PORT +
                     ";instanceName=" + INSTANCE + ";encrypt=false";

        try (Connection conn = DriverManager.getConnection(url, USER, PASSWORD);
             Statement stmt = conn.createStatement()) {

            // 1. Tạo database mới rỗng
            stmt.executeUpdate("CREATE DATABASE " + newDbName);
            System.out.println("Database created: " + newDbName);
        }

        // 2. Nạp schema vào database vừa tạo
        loadSchemaIntoDatabase(newDbName);
    }

    private static void loadSchemaIntoDatabase(String dbName) throws SQLException {
        String dbUrl = "jdbc:sqlserver://" + SERVER + ":" + PORT +
                       ";instanceName=" + INSTANCE + ";databaseName=" + dbName + ";encrypt=false";

        try (Connection conn = DriverManager.getConnection(dbUrl, USER, PASSWORD);
             Statement stmt = conn.createStatement()) {

            String sql = Files.readString(Paths.get(SCHEMA_PATH));
            for (String statement : sql.split(";")) {
                String trimmed = statement.trim();
                if (!trimmed.isEmpty()) {
                    stmt.execute(trimmed);
                }
            }
            System.out.println("Schema loaded successfully into " + dbName);
        } catch (Exception e) {
            throw new SQLException("Error loading schema into " + dbName, e);
        }
    }
}
