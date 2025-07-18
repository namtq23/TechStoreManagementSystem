package controller;

import dao.InventoryDAO;
import dao.SerialNumberDAO;
import dao.StockMovementDetailDAO;
import dao.StockMovementResponseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.StockMovementDetail;

/**
 * Controller xử lý nhận hàng cho chi nhánh
 * @author TRIEU NAM
 */
@WebServlet("/bm-receive-order")
public class BMReceiveOrderController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        Object branchIdObj = request.getSession().getAttribute("branchId");
        Object userIdObj = request.getSession().getAttribute("userId");
        String movementIDStr = request.getParameter("movementID");
        
        // Kiểm tra null trước khi xử lý
        if (dbName == null || branchIdObj == null || userIdObj == null || movementIDStr == null) {
            System.err.println("Session không hợp lệ - dbName: " + dbName + ", branchId: " + branchIdObj + 
                             ", userId: " + userIdObj + ", movementID: " + movementIDStr);
            request.getSession().setAttribute("errorMessage", "Phiên làm việc không hợp lệ.");
            response.sendRedirect("bm-incoming-orders");
            return;
        }
        
        // Xử lý chuyển đổi ID an toàn
        Integer branchId = null;
        Integer userId = null;
        
        try {
            // Chuyển đổi branchId
            if (branchIdObj instanceof String) {
                String branchIdStr = (String) branchIdObj;
                if (branchIdStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("branchId không được rỗng");
                }
                branchId = Integer.parseInt(branchIdStr.trim());
            } else if (branchIdObj instanceof Integer) {
                branchId = (Integer) branchIdObj;
            } else {
                throw new IllegalArgumentException("branchId phải là String hoặc Integer");
            }
            
            // Chuyển đổi userId
            if (userIdObj instanceof String) {
                String userIdStr = (String) userIdObj;
                if (userIdStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("userId không được rỗng");
                }
                userId = Integer.parseInt(userIdStr.trim());
            } else if (userIdObj instanceof Integer) {
                userId = (Integer) userIdObj;
            } else {
                throw new IllegalArgumentException("userId phải là String hoặc Integer");
            }
            
            // Kiểm tra giá trị hợp lệ
            if (branchId <= 0) {
                throw new IllegalArgumentException("branchId phải là số dương");
            }
            if (userId <= 0) {
                throw new IllegalArgumentException("userId phải là số dương");
            }
            
            int movementID = Integer.parseInt(movementIDStr.trim());
            if (movementID <= 0) {
                throw new IllegalArgumentException("movementID phải là số dương");
            }
            
            System.out.println("🔄 Bắt đầu xử lý nhận hàng - MovementID: " + movementID + 
                             ", BranchID: " + branchId + ", UserID: " + userId);
            
            // Xử lý nhận hàng
            boolean success = processReceiveOrder(dbName, movementID, branchId, userId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Đã xác nhận nhận hàng thành công!");
                System.out.println("✅ Nhận hàng thành công cho đơn #" + movementID);
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xác nhận nhận hàng.");
                System.err.println("❌ Nhận hàng thất bại cho đơn #" + movementID);
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Lỗi format ID: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "ID không đúng định dạng số");
        } catch (IllegalArgumentException e) {
            System.err.println("Lỗi ID: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "ID không hợp lệ");
        } catch (Exception e) {
            System.err.println("Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect("bm-incoming-orders");
    }
    
    private boolean processReceiveOrder(String dbName, int movementID, int branchId, int userId) {
        try {
            StockMovementDetailDAO detailDAO = new StockMovementDetailDAO();
            InventoryDAO inventoryDAO = new InventoryDAO();
            SerialNumberDAO serialDAO = new SerialNumberDAO();
            StockMovementResponseDAO responseDAO = new StockMovementResponseDAO();
            
            System.out.println("🔍 Lấy chi tiết đơn hàng #" + movementID);
            
            // 1. Lấy chi tiết đơn hàng
            List<StockMovementDetail> details = detailDAO.getRawDetailsByMovementID(dbName, movementID);
            
            if (details == null || details.isEmpty()) {
                System.err.println("❌ Không tìm thấy chi tiết đơn hàng #" + movementID);
                return false;
            }
            
            System.out.println("📦 Tìm thấy " + details.size() + " sản phẩm trong đơn #" + movementID);
            
            // 2. Lấy InventoryID từ BranchID
            int inventoryId = inventoryDAO.getInventoryIdByBranchId(dbName, branchId);
            if (inventoryId == 0) {
                System.err.println("❌ Không tìm thấy inventory cho chi nhánh #" + branchId);
                return false;
            }
            
            System.out.println("🏪 InventoryID của chi nhánh " + branchId + " là: " + inventoryId);
            
            // 3. Xử lý từng sản phẩm
            for (StockMovementDetail detail : details) {
                System.out.println("🔄 Xử lý sản phẩm: DetailID=" + detail.getDetailID() + 
                                 ", ProductDetailID=" + detail.getProductDetailID() + 
                                 ", Quantity=" + detail.getQuantity());
                
                // Thêm/cập nhật số lượng trong InventoryProducts
                boolean inventoryUpdated = inventoryDAO.addOrUpdateInventoryProduct(
                    dbName, inventoryId, detail.getProductDetailID(), detail.getQuantity());
                
                if (!inventoryUpdated) {
                    System.err.println("❌ Lỗi cập nhật inventory cho sản phẩm " + detail.getProductDetailID());
                    return false;
                }
                
                System.out.println("✅ Đã cập nhật inventory: +" + detail.getQuantity() + " sản phẩm " + detail.getProductDetailID());
                
                // Cập nhật serial: gán về chi nhánh, xóa MovementDetailID
                boolean serialUpdated = serialDAO.markSerialsAsReceivedByBranch(
                    dbName, detail.getDetailID(), branchId);
                
                if (!serialUpdated) {
                    System.err.println("❌ Lỗi cập nhật serial cho DetailID " + detail.getDetailID());
                    return false;
                }
                
                System.out.println("✅ Đã cập nhật serial cho DetailID=" + detail.getDetailID());
            }
            
            // 4. Cập nhật trạng thái response thành "completed"
            boolean responseUpdated = responseDAO.insertCompletedResponse(dbName, movementID, userId);
            
            if (!responseUpdated) {
                System.err.println("❌ Lỗi cập nhật response status");
                return false;
            }
            
            System.out.println("✅ Đã cập nhật trạng thái đơn #" + movementID + " thành completed");
            System.out.println("🎉 Hoàn tất nhận hàng cho đơn #" + movementID);
            return true;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi trong processReceiveOrder: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the orders page
        response.sendRedirect("bm-incoming-orders");
    }
    
    @Override
    public String getServletInfo() {
        return "Controller xử lý nhận hàng cho chi nhánh";
    }
}
