package controller;

import dao.SerialNumberDAO;
import dao.StockMovementDetailDAO;
import dao.StockMovementResponseDAO;
import dao.WareHouseDAO;
import model.StockMovementDetail;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Hoàn tất đơn nhập kho: 
 * - Cập nhật tồn kho
 * - Gán serial về kho
 * - Đánh dấu phản hồi là completed
 */
@WebServlet(name = "WHCompleteRequestController", urlPatterns = {"/complete-stock"})
public class WHCompleteRequestController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String dbName = (String) request.getSession().getAttribute("dbName");
        String movementIDStr = request.getParameter("movementID");
        String warehouseIDStr = request.getParameter("warehouseID");
        System.out.println("MovementID"+movementIDStr);
        System.out.println("WarehouseID"+warehouseIDStr);
         

        if (movementIDStr == null || warehouseIDStr == null ||
            movementIDStr.isBlank() || warehouseIDStr.isBlank()) {
            request.getSession().setAttribute("error", "Thiếu thông tin đơn hàng hoặc kho.");
            response.sendRedirect("serial-check?id="+movementIDStr); // ➤ Chuyển về trang wh-import
            return;
        }

        try {
            int movementID = Integer.parseInt(movementIDStr);
            int warehouseID = Integer.parseInt(warehouseIDStr);

            // DAO xử lý
            StockMovementDetailDAO detailDAO = new StockMovementDetailDAO();
            WareHouseDAO warehouseDAO = new WareHouseDAO();
            SerialNumberDAO serialDAO = new SerialNumberDAO();
            StockMovementResponseDAO responseDAO = new StockMovementResponseDAO();

            List<StockMovementDetail> details = detailDAO.getRawDetailsByMovementID(dbName, movementID);

            for (StockMovementDetail detail : details) {
                warehouseDAO.insertWarehouseProduct(dbName, warehouseID, detail.getProductID(), detail.getQuantity());
                serialDAO.updateWarehouseForSerials(dbName, detail.getDetailID(), warehouseID);
            }

            responseDAO.markAsCompleted(dbName, movementID);
            request.getSession().setAttribute("success", "Hoàn thành đơn nhập thành công!");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Mã đơn hàng hoặc mã kho không hợp lệ.");
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi khi hoàn tất đơn nhập.");
        }

        response.sendRedirect("wh-import"); // ➤ Luôn quay về wh-import
    }

    @Override
    public String getServletInfo() {
        return "Xử lý hoàn tất đơn nhập kho";
    }
}
