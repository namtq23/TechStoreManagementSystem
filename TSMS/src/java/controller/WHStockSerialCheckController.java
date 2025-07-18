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

@WebServlet(name = "WHStockSerialCheckController", urlPatterns = {"/serial-check", "/serial-check-export"})
public class WHStockSerialCheckController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String dbName = (String) request.getSession().getAttribute("dbName");

        if (dbName == null || dbName.isEmpty()) {
            response.sendRedirect("login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null && request.getAttribute("id") != null) {
            idParam = request.getAttribute("id").toString();
        }

        String movementType = request.getParameter("movementType");
        if (movementType == null && request.getAttribute("movementType") != null) {
            movementType = request.getAttribute("movementType").toString();
        }

        if (idParam == null) {
            request.setAttribute("error", "Không tìm thấy mã đơn kiểm kho.");
            request.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/stock-check.jsp").forward(request, response);
            return;
        }

        int movementID = Integer.parseInt(idParam);

        StockMovementDetailDAO dao = new StockMovementDetailDAO();
        List<StockMovementDetail> details = dao.getDetailsByMovementID(dbName, movementID);
        for (StockMovementDetail detail : details) {
            System.out.println("✔️ DetailID: " + detail.getDetailID() + ", ProductDetailID: " + detail.getProductDetailID());

        }

        request.setAttribute("movementID", movementID);
        request.setAttribute("movementDetails", details);
        request.setAttribute("movementType", movementType);

        System.out.println("📦 Đơn " + (movementType != null ? movementType : "") + " #" + movementID + " có " + details.size() + " dòng sản phẩm.");

        //Kiểm tra tất cả các sản phẩm trong đã hoàn thành chưa. 10 sản phẩm 2/2 => đã hoàn thành
        boolean allCompleted = true;
        for (StockMovementDetail item : details) {
            if (item.getScanned() < item.getQuantity()) {
                allCompleted = false;
                break;
            }
        }
        request.setAttribute("allCompleted", allCompleted);
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
        String movementType = request.getParameter("movementType");
      
      
      
        String productDetailIDStr = request.getParameter("productDetailID"); // dùng cho export
          System.out.println("movement type nhận đc " + movementType);
  System.out.println("detail ID nhận đc " + productDetailIDStr );
        System.out.println("🔍 Serial nhận được: [" + serial + "]");

        // Kiểm tra dữ liệu đầu vào
        if (serial == null || serial.trim().isEmpty() || detailIDStr == null || movementIDStr == null
                || !Validate.validateSerialFormat(serial)) {
            request.setAttribute("error", "Vui lòng nhập Serial hợp lệ.");
            request.setAttribute("movementType", movementType);
            processRequest(request, response);
            return;
        }

        int detailID = Integer.parseInt(detailIDStr);
        int movementID = Integer.parseInt(movementIDStr);
        SerialNumberDAO serialDAO = new SerialNumberDAO();

        if ("import".equalsIgnoreCase(movementType)) {
            // ✅ Xử lý nhập kho (Import): chỉ kiểm tra serial chưa tồn tại
            if (serialDAO.checkIfSerialExists(dbName, serial)) {
                request.setAttribute("error", "❌ Serial đã tồn tại trong hệ thống.");
            } else if (serialDAO.addScannedSerial(dbName, detailID, serial)) {
                request.setAttribute("success", "✅ Đã thêm Serial thành công.");
            } else {
                request.setAttribute("error", "❌ Có lỗi xảy ra khi thêm Serial.");
            }

        } else if ("export".equalsIgnoreCase(movementType)) {
            // ✅ Xử lý xuất kho (Export): kiểm tra serial trong kho & không bị xuất trước đó
            if (productDetailIDStr == null) {
                request.setAttribute("error", "Thiếu thông tin mã sản phẩm.");
                processRequest(request, response);
                return;
            }

            int productDetailID = Integer.parseInt(productDetailIDStr);
System.out.println("🧪 Gửi vào DAO: ProductDetailID = " + productDetailID + ", Serial = " + serial + ", DetailID = " + detailID);


            boolean valid = serialDAO.checkIfSerialAvailableForExport(dbName, productDetailID, serial, detailID);
            if (!valid) {
                
                request.setAttribute("error", "❌ Serial không hợp lệ: không nằm trong kho hoặc đã được xuất.");
            } else if (serialDAO.markSerialAsExported(dbName, detailID, serial)) {
                System.out.println("➡️ Đang xuất serial: " + serial);
                System.out.println("➡️ MovementDetailID = " + movementID);
                System.out.println("➡️ ProductDetailID = " + productDetailID);
                request.setAttribute("success", "✅ Serial đã được xác nhận xuất kho.");
            } else {
                request.setAttribute("error", "❌ Có lỗi khi xử lý serial xuất kho.");
            }

        } else {
            // ❌ Trường hợp không rõ loại đơn
            request.setAttribute("error", "Loại yêu cầu không hợp lệ.");
        }

        request.setAttribute("movementID", movementID);
        request.setAttribute("movementType", movementType);
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Quản lý kiểm tra serial sản phẩm khi nhập hoặc xuất kho";
    }
}
