/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Shift;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class ShiftDAO {

    // Lấy tất cả ca làm việc với phân trang
    public static List<Shift> getAllShifts(int page, int pageSize, String dbName) {
        List<Shift> shifts = new ArrayList<>();
        String sql = "SELECT * FROM Shift ORDER BY shiftID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            int offset = (page - 1) * pageSize;
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Shift shift = new Shift();
                    shift.setShiftID(rs.getInt("shiftID"));
                    shift.setShiftName(rs.getString("shiftName"));
                    shift.setStartTime(rs.getTime("startTime").toLocalTime());
                    shift.setEndTime(rs.getTime("endTime").toLocalTime());
                    shifts.add(shift);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return shifts;
    }

    // Tìm kiếm ca làm việc theo tên
    public List<Shift> searchShiftsByName(String searchName, int page, int pageSize, String dbName) {
        List<Shift> shifts = new ArrayList<>();
        String sql = "SELECT * FROM Shift WHERE shiftName LIKE ? ORDER BY shiftID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchName + "%");
            int offset = (page - 1) * pageSize;
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Shift shift = new Shift();
                    shift.setShiftID(rs.getInt("shiftID"));
                    shift.setShiftName(rs.getString("shiftName"));
                    shift.setStartTime(rs.getTime("startTime").toLocalTime());
                    shift.setEndTime(rs.getTime("endTime").toLocalTime());
                    shifts.add(shift);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return shifts;
    }

    // Đếm tổng số ca làm việc
    public int getTotalShifts(String dbName) {
        String sql = "SELECT COUNT(*) FROM Shift";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return 0;
    }

    // Đếm tổng số ca làm việc theo tên tìm kiếm
    public int getTotalShiftsBySearch(String searchName, String dbName) {
        String sql = "SELECT COUNT(*) FROM Shift WHERE shiftName LIKE ?";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchName + "%");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return 0;
    }

    // Lấy ca làm việc theo ID
    public Shift getShiftById(int shiftId, String dbName) {
        String sql = "SELECT * FROM Shift WHERE shiftID = ?";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, shiftId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Shift shift = new Shift();
                    shift.setShiftID(rs.getInt("shiftID"));
                    shift.setShiftName(rs.getString("shiftName"));
                    shift.setStartTime(rs.getTime("startTime").toLocalTime());
                    shift.setEndTime(rs.getTime("endTime").toLocalTime());
                    return shift;
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return null;
    }

    // Tạo ca làm việc mới
    public boolean createShift(Shift shift, String dbName) {
        String sql = "INSERT INTO Shift (shiftName, startTime, endTime) VALUES (?, ?, ?)";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, shift.getShiftName());
            ps.setTime(2, Time.valueOf(shift.getStartTime()));
            ps.setTime(3, Time.valueOf(shift.getEndTime()));

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }

    // Cập nhật ca làm việc
    public boolean updateShift(Shift shift, String dbName) {
        String sql = "UPDATE Shift SET shiftName = ?, startTime = ?, endTime = ? WHERE shiftID = ?";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, shift.getShiftName());
            ps.setTime(2, Time.valueOf(shift.getStartTime()));
            ps.setTime(3, Time.valueOf(shift.getEndTime()));
            ps.setInt(4, shift.getShiftID());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }

    // Xóa ca làm việc
    public boolean deleteShift(int shiftId, String dbName) {
        String sql = "DELETE FROM Shift WHERE shiftID = ?";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, shiftId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }

    // Kiểm tra ca làm việc có đang được sử dụng hay không (để tránh xóa nhầm)
    public boolean isShiftInUse(int shiftId, String dbName) {
        String sql = "SELECT COUNT(*) FROM Staff WHERE shiftID = ?";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, shiftId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return false;
    }

    // Kiểm tra tên ca làm việc đã tồn tại hay chưa
    public boolean isShiftNameExists(String shiftName, int excludeShiftId, String dbName) {
        String sql = "SELECT COUNT(*) FROM Shift WHERE shiftName = ? AND shiftID != ?";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, shiftName);
            ps.setInt(2, excludeShiftId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return false;
    }

    // Kiểm tra thời gian ca làm việc có bị trùng lặp hay không
    public static boolean isTimeConflict(String startTimeStr, String endTimeStr, int excludeShiftId, String dbName) {
        String sql = "SELECT COUNT(*) FROM Shift WHERE ShiftID != ? AND "
                + "((CAST(StartTime AS TIME) <= CAST(? AS TIME) AND CAST(EndTime AS TIME) > CAST(? AS TIME)) OR "
                + "(CAST(StartTime AS TIME) < CAST(? AS TIME) AND CAST(EndTime AS TIME) >= CAST(? AS TIME)) OR "
                + "(CAST(StartTime AS TIME) >= CAST(? AS TIME) AND CAST(EndTime AS TIME) <= CAST(? AS TIME)))";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, excludeShiftId);
            ps.setString(2, startTimeStr);
            ps.setString(3, startTimeStr);
            ps.setString(4, endTimeStr);
            ps.setString(5, endTimeStr);
            ps.setString(6, startTimeStr);
            ps.setString(7, endTimeStr);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static Shift getShiftOfUserId(int userId, String dbName) {
        String sql = "SELECT * FROM UserShift\n"
                + "JOIN Shift ON Shift.ShiftID = UserShift.ShiftID\n"
                + "WHERE UserID = ?";

        try (Connection connection = DBUtil.getConnectionTo(dbName); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Shift shift = new Shift();
                    shift.setShiftID(rs.getInt("shiftID"));
                    shift.setShiftName(rs.getString("shiftName"));
                    shift.setStartTime(rs.getTime("startTime").toLocalTime());
                    shift.setEndTime(rs.getTime("endTime").toLocalTime());
                    return shift;
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return null;
    }

    public static boolean updateUserShift(int userId, int shiftId, String dbName) throws SQLException {
        String deleteSql = "DELETE FROM UserShift WHERE UserID = ?";
        String insertSql = "INSERT INTO UserShift (UserID, ShiftID) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnectionTo(dbName)) {
            conn.setAutoCommit(false);

            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, userId);
                deleteStmt.executeUpdate();
            }

            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setInt(1, userId);
                insertStmt.setInt(2, shiftId);
                insertStmt.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }

    public static void main(String[] args) throws SQLException {
        String startTime = "09:00:00";
        String endTime = "11:00:00";
        System.out.println(ShiftDAO.isTimeConflict(startTime, endTime, 3, "DTB_TechStore"));
    }
}
