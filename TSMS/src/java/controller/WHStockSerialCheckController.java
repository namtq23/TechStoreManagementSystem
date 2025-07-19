package controller;

import dao.SerialNumberDAO;
import dao.StockMovementDetailDAO;
import dao.StockMovementsRequestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ProductDetailSerialNumber;
import model.StockMovementDetail;
import model.StockMovementsRequest;
import util.Validate;

@WebServlet(name = "WHStockSerialCheckController", urlPatterns = {"/serial-check", "/serial-check-export"})
public class WHStockSerialCheckController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

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

        // Get filter parameters
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String productFilter = request.getParameter("productFilter");
        String status = request.getParameter("status");

        // Get pagination parameters
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        try {
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        // Get items per page parameter
        String itemsPerPageParam = request.getParameter("itemsPerPage");
        int itemsPerPage = PAGE_SIZE;
        try {
            if (itemsPerPageParam != null && !itemsPerPageParam.trim().isEmpty()) {
                itemsPerPage = Integer.parseInt(itemsPerPageParam);
                if (itemsPerPage < 1) {
                    itemsPerPage = PAGE_SIZE;
                }
            }
        } catch (NumberFormatException e) {
            itemsPerPage = PAGE_SIZE;
        }

        try {
            StockMovementDetailDAO dao = new StockMovementDetailDAO();
            // **THÊM ĐOẠN CODE MỚI ĐỂ LẤY MOVEMENT TYPE TỪ DATABASE**
            StockMovementsRequestDAO movementDAO = new StockMovementsRequestDAO();
            StockMovementsRequest movement = movementDAO.getMovementById(dbName, movementID);

            if (movement != null) {
                String movementTypeFromDB = movement.getMovementType();
                if (movementType == null || movementType.isEmpty()) {
                    movementType = movementTypeFromDB.toLowerCase(); // Thêm .toLowerCase()
                    System.out.println("[DEBUG] Movement type set from DB: " + movementType + " for MovementID: " + movementID);
                }
            } else {
                System.out.println("[DEBUG] Movement not found for ID: " + movementID);
            }
            // Sử dụng method có filter và pagination
            List<StockMovementDetail> details = dao.getMovementDetailsWithFilters(
                    dbName, movementID, productFilter, status, currentPage, itemsPerPage
            );

            // Update scanned count based on actual serial numbers
            for (StockMovementDetail detail : details) {
                List<ProductDetailSerialNumber> serials = dao.getSerialsByDetail(dbName, detail.getDetailID());
                detail.setSerials(serials);
                detail.setScanned(serials != null ? serials.size() : 0);

                System.out.println("✔️ DetailID: " + detail.getDetailID()
                        + ", ProductDetailID: " + detail.getProductDetailID()
                        + ", Scanned: " + detail.getScanned() + "/" + detail.getQuantity());
            }

            // Get total count for pagination
            int totalItems = dao.getMovementDetailsCount(dbName, movementID, productFilter, status);

            // Calculate pagination info
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / itemsPerPage) : 1;

            // Validate current page
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                StringBuilder redirectUrl = new StringBuilder("serial-check?id=" + movementID + "&page=" + currentPage);
                if (movementType != null) {
                    redirectUrl.append("&movementType=").append(movementType);
                }
                if (productFilter != null && !productFilter.isEmpty()) {
                    redirectUrl.append("&productFilter=").append(productFilter);
                }
                if (status != null && !status.isEmpty()) {
                    redirectUrl.append("&status=").append(status);
                }
                redirectUrl.append("&itemsPerPage=").append(itemsPerPage);
                response.sendRedirect(redirectUrl.toString());
                return;
            }

            // Calculate display info
            int startItem = totalItems > 0 ? ((currentPage - 1) * itemsPerPage) + 1 : 0;
            int endItem = Math.min(currentPage * itemsPerPage, totalItems);

            // Get product list for filter
            List<String> productList = dao.getProductListByMovement(dbName, movementID);

            // Check if all completed
            boolean allCompleted = true;
            for (StockMovementDetail item : details) {
                if (item.getScanned() < item.getQuantity()) {
                    allCompleted = false;
                    break;
                }
            }

            // Set attributes for JSP
            request.setAttribute("movementID", movementID);
            request.setAttribute("movementDetails", details);
            request.setAttribute("movementType", movementType);
            request.setAttribute("allCompleted", allCompleted);
            request.setAttribute("productList", productList);

            // Filter parameters
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("productFilter", productFilter);
            request.setAttribute("status", status);

            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);

            System.out.println("📦 Đơn " + (movementType != null ? movementType : "") + " #" + movementID
                    + " - Page: " + currentPage + "/" + totalPages
                    + ", Items: " + details.size() + "/" + totalItems);

            request.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/stock-check.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in processRequest: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/stock-check.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST processing cho scan serial giữ nguyên như cũ
        response.setContentType("text/html;charset=UTF-8");

        String dbName = (String) request.getSession().getAttribute("dbName");
        String serial = request.getParameter("scannedSerial");
        String detailIDStr = request.getParameter("detailID");
        String movementIDStr = request.getParameter("movementID");
        String movementType = request.getParameter("movementType");
        String productDetailIDStr = request.getParameter("productDetailID");

        System.out.println("🔍 Serial nhận được: [" + serial + "]");
        System.out.println("movement type nhận đc " + movementType);
        System.out.println("detail ID nhận đc " + productDetailIDStr);

        // Existing POST processing logic...
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
            if (serialDAO.checkIfSerialExists(dbName, serial)) {
                request.setAttribute("error", "❌ Serial đã tồn tại trong hệ thống.");
            } else if (serialDAO.addScannedSerial(dbName, detailID, serial)) {
                request.setAttribute("success", "✅ Đã thêm Serial thành công.");
            } else {
                request.setAttribute("error", "❌ Có lỗi xảy ra khi thêm Serial.");
            }

        } else if ("export".equalsIgnoreCase(movementType)) {
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
                request.setAttribute("success", "✅ Serial đã được xác nhận xuất kho.");
            } else {
                request.setAttribute("error", "❌ Có lỗi khi xử lý serial xuất kho.");
            }

        } else {
            request.setAttribute("error", "Loại yêu cầu không hợp lệ.");
        }

        request.setAttribute("movementID", movementID);
        request.setAttribute("movementType", movementType);
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Quản lý kiểm tra serial sản phẩm với filter và pagination";
    }
}
