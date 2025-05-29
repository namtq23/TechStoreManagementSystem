package util;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseUtils {
    private static final String SCHEMA_PATH = "D:/FPT/2025.SU5/SWP391/template.sql";

    public static void createDatabaseWithSchema(String newDbName) throws SQLException {
        try (Connection conn = DBUtil.getServerConnection();
             Statement stmt = conn.createStatement()) {

            stmt.executeUpdate("CREATE DATABASE " + newDbName);
            System.out.println("Database created: " + newDbName);
        }

        loadSchemaIntoDatabase(newDbName);
    }

    private static void loadSchemaIntoDatabase(String dbName) throws SQLException {
        try (Connection conn = DBUtil.getConnectionTo(dbName);
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

