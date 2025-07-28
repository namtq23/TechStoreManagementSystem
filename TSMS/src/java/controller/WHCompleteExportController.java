package controller;

import dao.SerialNumberDAO;
import dao.StockMovementDetailDAO;
import dao.StockMovementResponseDAO;
import dao.StockMovementsRequestDAO;
import dao.WareHouseDAO;
import model.StockMovementDetail;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "WHCompleteExportController", urlPatterns = {"/complete-stock-export"})
public class WHCompleteExportController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dbName = (String) request.getSession().getAttribute("dbName");
        String movementIDStr = request.getParameter("movementID");
        String warehouseIDStr = request.getParameter("warehouseID");

        System.out.println("=== DEBUG: Đầu vào ===");
        System.out.println("MovementID: " + movementIDStr);
        System.out.println("WarehouseID: " + warehouseIDStr);
        System.out.println("DBName: " + dbName);

        if (movementIDStr == null || warehouseIDStr == null ||
                movementIDStr.isBlank() || warehouseIDStr.isBlank()) {
            System.out.println("❌ Thiếu thông tin đầu vào");
            request.getSession().setAttribute("error", "Thiếu thông tin đơn xuất hoặc kho xuất.");
            response.sendRedirect("wh-export");
            return;
        }

        try {
            int movementID = Integer.parseInt(movementIDStr);
            int warehouseID = Integer.parseInt(warehouseIDStr);

            StockMovementDetailDAO detailDAO = new StockMovementDetailDAO();
            WareHouseDAO warehouseDAO = new WareHouseDAO();
            SerialNumberDAO serialDAO = new SerialNumberDAO();
            StockMovementResponseDAO responseDAO = new StockMovementResponseDAO();
            StockMovementsRequestDAO requestDAO = new StockMovementsRequestDAO();

            // Lấy danh sách dòng chi tiết
            List<StockMovementDetail> details = detailDAO.getRawDetailsByMovementID(dbName, movementID);
            System.out.println("=== DEBUG: Danh sách chi tiết ===");
            System.out.println("Số lượng dòng: " + details.size());
            
            for (StockMovementDetail detail : details) {
                System.out.println("DetailID: " + detail.getDetailID() + 
                                  ", ProductID: " + detail.getProductID() + 
                                  ", ProductDetailID: " + detail.getProductDetailID() + 
                                  ", Quantity: " + detail.getQuantity());
            }

            // Xử lý từng dòng chi tiết
            for (StockMovementDetail detail : details) {
                System.out.println("=== DEBUG: Xử lý detail " + detail.getDetailID() + " ===");
                
                // Trước khi trừ kho
                System.out.println("Trừ kho: WarehouseID=" + warehouseID + 
                                  ", ProductID=" + detail.getProductID() + 
                                  ", Quantity=" + detail.getQuantity());
                
                // Trừ kho
                warehouseDAO.subtractWarehouseProduct(dbName, warehouseID, detail.getProductDetailID(), detail.getQuantity());
                System.out.println("✅ Đã trừ kho thành công");

                // Cập nhật serial
                System.out.println("Cập nhật serial: DetailID=" + detail.getDetailID() + 
                                  ", WarehouseID=" + warehouseID);
                serialDAO.markSerialsAsTransferring(dbName, detail.getDetailID(), warehouseID);
                System.out.println("✅ Đã cập nhật serial thành công");
            }

            // Cập nhật request
            System.out.println("=== DEBUG: Cập nhật request ===");
            System.out.println("MovementID: " + movementID + ", FromWarehouseID: " + warehouseID);
            requestDAO.updateExportRequestTransferInfo(dbName, movementID, warehouseID);
            System.out.println("✅ Đã cập nhật request thành công");

            // Cập nhật phản hồi
            System.out.println("=== DEBUG: Cập nhật response ===");
            responseDAO.markAsTransferring(dbName, movementID);
            System.out.println("✅ Đã cập nhật response thành công");

            System.out.println("🎉 Hoàn tất đơn xuất thành công!");
            request.getSession().setAttribute("success", "Đơn xuất đã được chuyển đi thành công!");

        } catch (Exception e) {
            System.out.println("❌ Lỗi khi hoàn tất đơn xuất:");
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi khi hoàn tất đơn xuất: " + e.getMessage());
        }

        response.sendRedirect("wh-export");
    }

    @Override
    public String getServletInfo() {
        return "Xử lý hoàn tất đơn xuất kho";
    }
}
