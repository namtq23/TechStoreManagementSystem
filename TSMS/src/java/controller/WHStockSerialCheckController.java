package controller;

import dao.SerialNumberDAO;
import dao.StockMovementDetailDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.StockMovementDetail;
import util.Validate;

@WebServlet(name="WHStockSerialCheckController", urlPatterns={"/serial-check"})
public class WHStockSerialCheckController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String dbName = (String) request.getSession().getAttribute("dbName");

        String idParam = request.getParameter("id");
        if (idParam == null && request.getAttribute("id") != null) {
            idParam = request.getAttribute("id").toString();
        }

        if (idParam == null) {
            request.setAttribute("error", "Không tìm thấy mã đơn kiểm kho.");
            request.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/stock-check.jsp").forward(request, response);
            return;
        }

        int movementID = Integer.parseInt(idParam);

        StockMovementDetailDAO dao = new StockMovementDetailDAO();
        List<StockMovementDetail> details = dao.getDetailsByMovementID(dbName, movementID);

        request.setAttribute("movementID", movementID);
        request.setAttribute("movementDetails", details);
        System.out.println("📦 Đơn nhập #" + movementID+ " có " + details.size() + " dòng sản phẩm.");

        request.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/stock-check.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         response.setContentType("text/html;charset=UTF-8");
        String dbName = (String) request.getSession().getAttribute("dbName");
        String serial = request.getParameter("scannedSerial");
        String detailIDStr = request.getParameter("detailID");
       
        String movementIDStr = request.getParameter("movementID");
System.out.println("Serial nhận được: [" + serial + "]");

        if (serial == null || detailIDStr == null || serial.trim().isEmpty() || !Validate.validateSerialFormat(serial)) {
            request.setAttribute("error", "Vui lòng nhập Serial hợp lệ.");
            processRequest(request, response);
            return;
        }

         int detailID = Integer.parseInt(detailIDStr);
         System.out.println(detailID);
        int movementID = Integer.parseInt(movementIDStr);

   
        SerialNumberDAO serialDAO = new SerialNumberDAO();

        // Kiểm tra trùng serial
        if (serialDAO.checkIfSerialExists(dbName, serial)) {
            System.err.println("❌ Serial đã tồn tại trong hệ thống: " + serial);
            request.setAttribute("error", "Serial đã tồn tại trong hệ thống.");
            request.setAttribute("movementID", movementID);
            processRequest(request, response);
            return;
        }

        // Thêm serial vào chi tiết
        boolean inserted = serialDAO.addScannedSerial(dbName, detailID, serial);

        if (inserted) {
            System.out.println("✅ Serial được thêm thành công: " + serial);
            request.setAttribute("success", "Đã thêm Serial thành công.");
        } else {
            System.err.println("❌ Lỗi khi thêm serial: " + serial);
            request.setAttribute("error", "Có lỗi xảy ra khi thêm Serial.");
        }

        request.setAttribute("movementID", movementID);
       processRequest(request, response);

    }

    @Override
    public String getServletInfo() {
        return "Quản lý kiểm tra serial sản phẩm khi nhập kho";
    }
}
