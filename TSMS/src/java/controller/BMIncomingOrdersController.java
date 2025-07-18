package controller;

import dao.StockMovementsRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.StockMovementsRequest;

/**
 * Controller để hiển thị danh sách đơn hàng đang vận chuyển đến chi nhánh
 * @author TRIEU NAM
 */
@WebServlet("/bm-incoming-orders")
public class BMIncomingOrdersController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        Object branchIdObj = request.getSession().getAttribute("branchId");
        
        // Kiểm tra null trước khi xử lý
        if (dbName == null || branchIdObj == null) {
            System.err.println("Session không hợp lệ - dbName: " + dbName + ", branchId: " + branchIdObj);
            response.sendRedirect("login");
            return;
        }
        
        // Xử lý chuyển đổi branchId an toàn
        Integer branchId = null;
        try {
            if (branchIdObj instanceof String) {
                String branchIdStr = (String) branchIdObj;
                if (branchIdStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("branchId không được rỗng");
                }
                branchId = Integer.parseInt(branchIdStr.trim());
            } else if (branchIdObj instanceof Integer) {
                branchId = (Integer) branchIdObj;
            } else {
                throw new IllegalArgumentException("branchId phải là String hoặc Integer, nhận được: " + branchIdObj.getClass().getName());
            }
            
            // Kiểm tra giá trị hợp lệ
            if (branchId <= 0) {
                throw new IllegalArgumentException("branchId phải là số dương");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Lỗi format branchId: " + branchIdObj + " - " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "ID chi nhánh không đúng định dạng số");
            response.sendRedirect("login");
            return;
        } catch (IllegalArgumentException e) {
            System.err.println("Lỗi branchId: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "ID chi nhánh không hợp lệ");
            response.sendRedirect("login");
            return;
        }
        
        // Lấy danh sách đơn hàng
        try {
            StockMovementsRequestDAO dao = new StockMovementsRequestDAO();
            List<StockMovementsRequest> exportRequests = dao.getExportRequestsByToBranch(dbName, branchId.toString());
            
            // Debug log
            System.out.println("Tìm thấy " + exportRequests.size() + " đơn hàng cho chi nhánh " + branchId);
            
            request.setAttribute("exportRequests", exportRequests);
            request.getRequestDispatcher("/WEB-INF/jsp/manager/bm-track-orders.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách đơn hàng cho chi nhánh " + branchId + ": " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách đơn hàng");
            response.sendRedirect("bm-overview");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Controller hiển thị danh sách đơn hàng đang vận chuyển đến chi nhánh";
    }
}
