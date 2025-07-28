/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShiftDAO;
import model.Shift;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOShiftController", urlPatterns = {"/so-shift"})
public class SOShiftController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
            response.sendRedirect("login");
            return;
        }

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            response.sendRedirect(request.getContextPath() + "/subscription");
            return;
        }

        String dbName = dbNameObj.toString();
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            handleEditAction(request, response);
        } else {
            handleListAction(request, response);
        }
    }

    private void handleEditAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
            response.sendRedirect("login");
            return;
        }

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            response.sendRedirect(request.getContextPath() + "/subscription");
            return;
        }

        String dbName = dbNameObj.toString();
        String shiftIdStr = request.getParameter("shiftId");

        if (shiftIdStr != null && !shiftIdStr.isEmpty()) {
            try {
                int shiftId = Integer.parseInt(shiftIdStr);
                ShiftDAO shiftDAO = new ShiftDAO();
                Shift shift = shiftDAO.getShiftById(shiftId, dbName);
                if (shift != null) {
                    request.setAttribute("editShift", shift);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        handleListAction(request, response);
    }

    private void handleListAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
            response.sendRedirect("login");
            return;
        }

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            response.sendRedirect(request.getContextPath() + "/subscription");
            return;
        }

        String dbName = dbNameObj.toString();
        // Lấy thông tin phân trang
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        // Lấy từ khóa tìm kiếm
        String search = request.getParameter("search");
        if (search != null) {
            search = search.trim();
        }

        ShiftDAO shiftDAO = new ShiftDAO();
        List<Shift> shiftList;
        int totalShifts;
        // Tìm kiếm hoặc lấy tất cả
        if (search != null && !search.isEmpty()) {
            shiftList = shiftDAO.searchShiftsByName(search, currentPage, PAGE_SIZE, dbName);
            totalShifts = shiftDAO.getTotalShiftsBySearch(search, dbName);
        } else {
            shiftList = shiftDAO.getAllShifts(currentPage, PAGE_SIZE, dbName);
            totalShifts = shiftDAO.getTotalShifts(dbName);
        }
        // Tính toán thông tin phân trang
        int totalPages = (int) Math.ceil((double) totalShifts / PAGE_SIZE);
        int startShift = (currentPage - 1) * PAGE_SIZE + 1;
        int endShift = Math.min(startShift + PAGE_SIZE - 1, totalShifts);
        // Đảm bảo currentPage không vượt quá totalPages
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        // Set attributes cho JSP
        request.setAttribute("shiftList", shiftList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalShift", totalShifts);
        request.setAttribute("startShift", startShift);
        request.setAttribute("endShift", endShift);
        request.setAttribute("search", search);
        request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-shift.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("create".equals(action)) {
            handleCreateShift(request, response, session);
        } else if ("update".equals(action)) {
            handleUpdateShift(request, response, session);
        } else if ("delete".equals(action)) {
            handleDeleteShift(request, response, session);
        }

        response.sendRedirect("so-shift");
    }

    private void handleCreateShift(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
            response.sendRedirect("login");
            return;
        }

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            response.sendRedirect(request.getContextPath() + "/subscription");
            return;
        }

        String dbName = dbNameObj.toString();

        String shiftName = request.getParameter("shiftName");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");

        // Validation
        if (shiftName == null || shiftName.trim().isEmpty()) {
            session.setAttribute("error", "Tên ca làm việc không được để trống!");
            return;
        }

        if (startTimeStr == null || startTimeStr.trim().isEmpty()) {
            session.setAttribute("error", "Giờ bắt đầu không được để trống!");
            return;
        }

        if (endTimeStr == null || endTimeStr.trim().isEmpty()) {
            session.setAttribute("error", "Giờ kết thúc không được để trống!");
            return;
        }

        try {
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);

            // Kiểm tra logic thời gian
            if (!startTime.isBefore(endTime)) {
                session.setAttribute("error", "Giờ kết thúc phải sau giờ bắt đầu!");
                return;
            }

            ShiftDAO shiftDAO = new ShiftDAO();
            // Kiểm tra tên ca đã tồn tại
            if (shiftDAO.isShiftNameExists(shiftName.trim(), 0, dbName)) {
                session.setAttribute("error", "Tên ca làm việc đã tồn tại!");
                return;
            }
            // Kiểm tra trùng lặp thời gian
            if (ShiftDAO.isTimeConflict(startTimeStr, endTimeStr, 0, dbName)) {
                session.setAttribute("error", "Thời gian ca làm việc bị trùng lặp với ca khác!");
                return;
            }
            // Tạo ca làm việc mới
            Shift newShift = new Shift(shiftName.trim(), startTime, endTime);
            boolean success = shiftDAO.createShift(newShift, dbName);
            if (success) {
                session.setAttribute("success", "Tạo ca làm việc thành công!");
            } else {
                session.setAttribute("error", "Tạo ca làm việc thất bại!");
            }
        } catch (DateTimeParseException e) {
            session.setAttribute("error", "Định dạng thời gian không hợp lệ!");
        }
    }

    private void handleUpdateShift(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {

        String shiftIdStr = request.getParameter("shiftId");
        String shiftName = request.getParameter("shiftName");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");

        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
            response.sendRedirect("login");
            return;
        }

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            response.sendRedirect(request.getContextPath() + "/subscription");
            return;
        }

        String dbName = dbNameObj.toString();

        // Validation
        if (shiftIdStr == null || shiftIdStr.trim().isEmpty()) {
            session.setAttribute("error", "ID ca làm việc không hợp lệ!");
            return;
        }

        if (shiftName == null || shiftName.trim().isEmpty()) {
            session.setAttribute("error", "Tên ca làm việc không được để trống!");
            return;
        }

        if (startTimeStr == null || startTimeStr.trim().isEmpty()) {
            session.setAttribute("error", "Giờ bắt đầu không được để trống!");
            return;
        }

        if (endTimeStr == null || endTimeStr.trim().isEmpty()) {
            session.setAttribute("error", "Giờ kết thúc không được để trống!");
            return;
        }

        try {
            int shiftId = Integer.parseInt(shiftIdStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);

            // Kiểm tra logic thời gian
            if (!startTime.isBefore(endTime)) {
                session.setAttribute("error", "Giờ kết thúc phải sau giờ bắt đầu!");
                return;
            }

            ShiftDAO shiftDAO = new ShiftDAO();
            // Kiểm tra tên ca đã tồn tại (trừ ca hiện tại)
            if (shiftDAO.isShiftNameExists(shiftName.trim(), shiftId, dbName)) {
                session.setAttribute("error", "Tên ca làm việc đã tồn tại!");
                return;
            }
            // Kiểm tra trùng lặp thời gian (trừ ca hiện tại)
            if (ShiftDAO.isTimeConflict(startTimeStr, endTimeStr, shiftId, dbName)) {
                session.setAttribute("error", "Thời gian ca làm việc bị trùng lặp với ca khác!");
                return;
            }
            // Cập nhật ca làm việc
            Shift updatedShift = new Shift(shiftId, shiftName.trim(), startTime, endTime);
            boolean success = shiftDAO.updateShift(updatedShift, dbName);
            if (success) {
                session.setAttribute("success", "Cập nhật ca làm việc thành công!");
            } else {
                session.setAttribute("error", "Cập nhật ca làm việc thất bại!");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID ca làm việc không hợp lệ!");
        } catch (DateTimeParseException e) {
            session.setAttribute("error", "Định dạng thời gian không hợp lệ!");
        }
    }

    private void handleDeleteShift(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {

        String shiftIdStr = request.getParameter("shiftId");

        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
            response.sendRedirect("login");
            return;
        }

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            response.sendRedirect(request.getContextPath() + "/subscription");
            return;
        }

        String dbName = dbNameObj.toString();

        if (shiftIdStr == null || shiftIdStr.trim().isEmpty()) {
            session.setAttribute("error", "ID ca làm việc không hợp lệ!");
            return;
        }

        try {
            int shiftId = Integer.parseInt(shiftIdStr);

            ShiftDAO shiftDAO = new ShiftDAO();
            // Kiểm tra ca có đang được sử dụng không
            if (shiftDAO.isShiftInUse(shiftId, dbName)) {
                session.setAttribute("error", "Không thể xóa ca làm việc đang được sử dụng!");
                return;
            }
            // Xóa ca làm việc
            boolean success = shiftDAO.deleteShift(shiftId, dbName);
            if (success) {
                session.setAttribute("success", "Xóa ca làm việc thành công!");
            } else {
                session.setAttribute("error", "Xóa ca làm việc thất bại!");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID ca làm việc không hợp lệ!");
        }
    }

}
