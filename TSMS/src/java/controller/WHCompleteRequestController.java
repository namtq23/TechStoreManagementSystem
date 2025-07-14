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
        int movementID = Integer.parseInt(request.getParameter("movementID"));
        int warehouseID = Integer.parseInt(request.getParameter("warehouseID"));
        String redirectURL = request.getParameter("backURL");

        try {
            // Khởi tạo DAO
            StockMovementDetailDAO detailDAO = new StockMovementDetailDAO();
            WareHouseDAO warehouseDAO = new WareHouseDAO();
            SerialNumberDAO serialDAO = new SerialNumberDAO();
            StockMovementResponseDAO responseDAO = new StockMovementResponseDAO();

            // Lấy danh sách chi tiết phiếu nhập
            List<StockMovementDetail> details = detailDAO.getRawDetailsByMovementID(dbName, movementID);

            // Cập nhật tồn kho & serial
            for (StockMovementDetail detail : details) {
                warehouseDAO.insertWarehouseProduct(dbName, warehouseID, detail.getProductID(), detail.getQuantity());
                serialDAO.updateWarehouseForSerials(dbName, detail.getDetailID(), warehouseID);
            }

            // Đánh dấu phản hồi là hoàn tất
            responseDAO.markAsCompleted(dbName, movementID);

            request.getSession().setAttribute("success", "Hoàn thành đơn nhập thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi khi hoàn tất đơn nhập.");
        }

        // Chuyển hướng về trang ban đầu
        response.sendRedirect(redirectURL != null ? redirectURL : "serial-check?id=" + movementID);
    }

    @Override
    public String getServletInfo() {
        return "Xử lý hoàn tất đơn nhập kho";
    }
}
