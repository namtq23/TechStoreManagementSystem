/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author Astersa
 */
package util;

import java.sql.Connection;
import java.sql.SQLException;
import org.apache.tomcat.dbcp.dbcp2.BasicDataSource;
import java.sql.DriverManager;

public class DBUtil {

    private static BasicDataSource dataSource;

    static {
        try {
            dataSource = new BasicDataSource();
            dataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            //Phuong
//            dataSource.setUrl("jdbc:sqlserver://DESKTOP-LJ3A22Q:1433;databaseName=SuperAdminDB;encrypt=true;trustServerCertificate=true");
//            dataSource.setUsername("sa");
//            dataSource.setPassword("123");
            
            //Nam
//            dataSource.setUrl("jdbc:sqlserver://MAYTINHCUANAM\\TRNAM:1433;databaseName=SuperAdminDB;encrypt=true;trustServerCertificate=true");
//            dataSource.setUsername("sa");
//            dataSource.setPassword("123456");

            //Kien
//            dataSource.setUrl("jdbc:sqlserver://DESKTOP-LJ3A22Q:1433;databaseName=SuperAdminDB;encrypt=true;trustServerCertificate=true");
//            dataSource.setUsername("sa");
//            dataSource.setPassword("123");
            
            //Phung
//            dataSource.setUrl("jdbc:sqlserver://DESKTOP-C3OA5SJ:1433;databaseName=SuperAdminDB;encrypt=true;trustServerCertificate=true");
//            dataSource.setUsername("sa");
//            dataSource.setPassword("1");
            
            //Dat
            dataSource.setUrl("jdbc:sqlserver://ND2P\\PHUONG:1433;databaseName=SuperAdminDB;encrypt=true;trustServerCertificate=true");
            dataSource.setUsername("sa");
            dataSource.setPassword("123");

            dataSource.setInitialSize(5);
            dataSource.setMaxTotal(10);
            dataSource.setMaxIdle(5);
            dataSource.setMinIdle(2);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // Mặc định: kết nối tới SuperAdminDB
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // Kết nối tới server (chưa chọn DB)
    public static Connection getServerConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        }

        
        //Phuong
//        String url = "jdbc:sqlserver://DESKTOP-LJ3A22Q:1433;encrypt=false";
//        return DriverManager.getConnection(url, "sa", "123");

        //Nam
//        String url = "jdbc:sqlserver://MAYTINHCUANAM:1433;instanceName=TRNAM;encrypt=false";
//        return DriverManager.getConnection(url, "sa", "123456");


        //Kien
//        String url = "jdbc:sqlserver://DESKTOP-LJ3A22Q:1433;encrypt=false";
//        return DriverManager.getConnection(url, "sa", "123");
        //Phung
//        String url = "jdbc:sqlserver://DESKTOP-C3OA5SJ:1433;encrypt=false";
//        return DriverManager.getConnection(url, "sa", "1");
        //Dat
        String url = "jdbc:sqlserver://ND2P:1433;instanceName=PHUONG;encrypt=false";
        return DriverManager.getConnection(url, "sa", "123");
    }

    // Kết nối tới một database cụ thể (dùng để nạp schema vào DB mới tạo)
    public static Connection getConnectionTo(String dbName) throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        }

        //Phuong
//        String url = "jdbc:sqlserver://DESKTOP-LJ3A22Q:1433;databaseName=" + dbName + ";encrypt=false";
//        return DriverManager.getConnection(url, "sa", "123");
        //Nam
//        String url = "jdbc:sqlserver://MAYTINHCUANAM:1433;instanceName=TRNAM;databaseName=" + dbName + ";encrypt=false";
//         return DriverManager.getConnection(url, "sa", "123456");
        //Kien
//        String url = "jdbc:sqlserver://DESKTOP-LJ3A22Q:1433;databaseName=" + dbName + ";encrypt=false";
//        return DriverManager.getConnection(url, "sa", "123");
        //Phung
//        String url = "jdbc:sqlserver://DESKTOP-C3OA5SJ:1433;databaseName=" + dbName + ";encrypt=false";
//        return DriverManager.getConnection(url, "sa", "1");
        //Dat
        String url = "jdbc:sqlserver://ND2P:1433;instanceName=PHUONG;databaseName=" + dbName + ";encrypt=false";
        return DriverManager.getConnection(url, "sa", "123");

    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
