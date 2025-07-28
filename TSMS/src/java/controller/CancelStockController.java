package controller;

import dao.StockMovementResponseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;

@WebServlet("/cancel-stock")
public class CancelStockController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        System.out.println("=== [DEBUG] Cancel Stock Controller Started ===");
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        Object userIdObj = request.getSession().getAttribute("userId");
        Object roleIdObj = request.getSession().getAttribute("roleId");
        
        System.out.println("[DEBUG] Session - dbName: " + dbName);
        System.out.println("[DEBUG] Session - userIdObj: " + userIdObj);
        System.out.println("[DEBUG] Session - roleIdObj: " + roleIdObj);
        
        // Check permission (Warehouse Manager = 3)
        if (dbName == null || userIdObj == null || roleIdObj == null) {
            System.out.println("[DEBUG] Session validation failed - redirecting to login");
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = null;
        Integer roleId = null;
        try {
            if (userIdObj instanceof String) {
                userId = Integer.parseInt((String) userIdObj);
            } else if (userIdObj instanceof Integer) {
                userId = (Integer) userIdObj;
            }
            
            if (roleIdObj instanceof String) {
                roleId = Integer.parseInt((String) roleIdObj);
            } else if (roleIdObj instanceof Integer) {
                roleId = (Integer) roleIdObj;
            }
            
            System.out.println("[DEBUG] Parsed - userId: " + userId + ", roleId: " + roleId);
            
            if (userId == null || roleId == null || roleId != 0) {
                System.out.println("[DEBUG] Permission denied - userId: " + userId + ", roleId: " + roleId);
                request.getSession().setAttribute("errorMessage", "Bạn không có quyền thực hiện hành động này");
                response.sendRedirect("so-track-movements");
                return;
            }
            
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] Number format error: " + e.getMessage());
            response.sendRedirect("login");
            return;
        }
        
        // Get parameters
        String movementIdParam = request.getParameter("id");
        String movementType = request.getParameter("movementType");
        
        System.out.println("[DEBUG] Movement ID param: " + movementIdParam);
        System.out.println("[DEBUG] Movement Type param: " + movementType);
        
        if (movementIdParam == null || movementIdParam.trim().isEmpty()) {
            System.out.println("[DEBUG] Movement ID is null or empty");
            request.getSession().setAttribute("errorMessage", "Không tìm thấy ID đơn hàng");
            response.sendRedirect("so-track-movements");
            return;
        }
        
        int movementID;
        try {
            movementID = Integer.parseInt(movementIdParam);
            System.out.println("[DEBUG] Parsed movement ID: " + movementID);
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] Invalid movement ID format: " + movementIdParam);
            request.getSession().setAttribute("errorMessage", "ID đơn hàng không hợp lệ");
            response.sendRedirect("so-track-movements");
            return;
        }
        
        // Xác định redirect URL dựa trên movementType
        String redirectUrl = "so-track-movements"; // default
        String successMessage = "Đã hủy đơn nhập hàng thành công";
        
        if (movementType != null) {
            String lowerMovementType = movementType.toLowerCase();
            if ("export".equals(lowerMovementType)) {
                redirectUrl = "so-track-movements";
                successMessage = "Đã hủy đơn xuất hàng thành công";
            }
            System.out.println("[DEBUG] Movement type: " + movementType + " -> Redirect to: " + redirectUrl);
        }
        
        try {
            System.out.println("[DEBUG] Creating StockMovementResponseDAO...");
            StockMovementResponseDAO responseDAO = new StockMovementResponseDAO();
            
            System.out.println("[DEBUG] Calling markAsCancelled with: dbName=" + dbName + ", movementID=" + movementID + ", userId=" + userId);
            
            // Sử dụng method markAsCancelled
            responseDAO.markAsCancelled(dbName, movementID, userId);
            
            System.out.println("[DEBUG] markAsCancelled completed successfully");
            request.getSession().setAttribute("successMessage", successMessage);
            
        } catch (SQLException e) {
            System.err.println("[DEBUG] SQLException occurred:");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi hủy đơn hàng: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("[DEBUG] Unexpected error occurred:");
            System.err.println("Error type: " + e.getClass().getSimpleName());
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi không xác định xảy ra: " + e.getMessage());
        }
        
        System.out.println("[DEBUG] Redirecting to: " + redirectUrl);
        response.sendRedirect(redirectUrl);
        System.out.println("=== [DEBUG] Cancel Stock Controller Ended ===");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[DEBUG] POST request received - delegating to GET");
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Universal Stock Movement Cancel Controller";
    }
}
