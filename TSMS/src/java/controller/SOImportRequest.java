package controller;

import dao.AnnouncementDAO;
import dao.ProductDAO;
import dao.StockMovementDetailDAO;
import dao.StockMovementsRequestDAO;
import dao.SuppliersDAO;
import dao.WareHouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ProductDetailDTO;
import model.Supplier;
import model.Warehouse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.Validate;

@WebServlet(name = "SOImportRequest", urlPatterns = {"/import-request"})
public class SOImportRequest extends HttpServlet {
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();
    private final StockMovementsRequestDAO StockMovementsRequestDAO = new StockMovementsRequestDAO();
    private final StockMovementDetailDAO StockMovementDetailDAO = new StockMovementDetailDAO();
    private final SuppliersDAO suppliersDAO = new SuppliersDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final WareHouseDAO warehouseDAO = new WareHouseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processDisplay(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dbName = (String) request.getSession().getAttribute("dbName");
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                int incomingSupplierId = Integer.parseInt(request.getParameter("supplierId"));
                Integer sessionSupplierId = (Integer) session.getAttribute("cartSupplierId");

                if (sessionSupplierId == null) {
                    session.setAttribute("cartSupplierId", incomingSupplierId);
                } else if (sessionSupplierId != incomingSupplierId) {
                    session.setAttribute("errorMessage", "Phiếu nhập hàng chỉ được nhập từ một nhà cung cấp. Vui lòng xóa giỏ hàng trước khi chọn nhà cung cấp khác.");
                    response.sendRedirect(request.getContextPath() + "/import-request?supplierId=" + sessionSupplierId);
                    return;
                }

                int productDetailID = Integer.parseInt(request.getParameter("productDetailID"));
                List<ProductDetailDTO> cartItems = (List<ProductDetailDTO>) session.getAttribute("cartItems");
                if (cartItems == null) {
                    cartItems = new ArrayList<>();
                }

                ProductDetailDTO product = ProductDAO.getProductDetailById(dbName, productDetailID);
                if (product != null) {
                    boolean alreadyAdded = cartItems.stream()
                            .anyMatch(p -> p.getProductDetailID() == productDetailID);

                    if (!alreadyAdded) {
                        product.setQuantity(1); // default số lượng
                        cartItems.add(product);
                        session.setAttribute("successMessage", "Đã thêm sản phẩm: " + product.getProductName());
                    } else {
                        session.setAttribute("errorMessage", "Sản phẩm đã có trong phiếu yêu cầu.");
                    }
                } else {
                    session.setAttribute("errorMessage", "Không tìm thấy sản phẩm.");
                }

                session.setAttribute("cartItems", cartItems);

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi khi thêm sản phẩm: " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/import-request?supplierId=" + request.getParameter("supplierId"));
            return;
        }

        if ("updateQuantity".equals(action)) {
            try {
                int productDetailID = Integer.parseInt(request.getParameter("productDetailID"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String supplierIdRaw = request.getParameter("supplierId");

                List<ProductDetailDTO> cartItems = (List<ProductDetailDTO>) session.getAttribute("cartItems");
                if (cartItems != null) {
                    for (ProductDetailDTO item : cartItems) {
                        if (item.getProductDetailID() == productDetailID) {
                            item.setQuantity(quantity);
                            break;
                        }
                    }
                }

                response.sendRedirect("import-request?supplierId=" + supplierIdRaw);
                return;

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi khi cập nhật số lượng: " + e.getMessage());
                response.sendRedirect("import-request");
            }
        }

        if ("remove".equals(action)) {
            try {
                int productDetailID = Integer.parseInt(request.getParameter("productDetailID"));

                List<ProductDetailDTO> cartItems = (List<ProductDetailDTO>) session.getAttribute("cartItems");
                if (cartItems != null) {
                    cartItems.removeIf(item -> item.getProductDetailID() == productDetailID);
                }

                session.setAttribute("cartItems", cartItems);
                session.setAttribute("successMessage", "Đã xóa sản phẩm khỏi phiếu yêu cầu.");

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi khi xóa sản phẩm: " + e.getMessage());
            }

            String redirectURL = request.getContextPath() + "/import-request?supplierId=" + request.getParameter("supplierId");
            String toWarehouseID = request.getParameter("toWarehouseID");
            if (toWarehouseID != null && !toWarehouseID.isEmpty()) {
                redirectURL += "&toWarehouseID=" + toWarehouseID;
            }

            response.sendRedirect(redirectURL);
            return;
        }

        if ("reset".equals(action)) {
            try {
                session.removeAttribute("cartItems");
                session.removeAttribute("cartSupplierId");
                session.setAttribute("successMessage", "Đã xóa tất cả sản phẩm khỏi phiếu yêu cầu.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi khi xóa tất cả sản phẩm: " + e.getMessage());
            }

            String redirectURL = request.getContextPath() + "/import-request";
            String supplierId = request.getParameter("supplierId");
            String toWarehouseID = request.getParameter("toWarehouseID");

            if (supplierId != null && !supplierId.isEmpty()) {
                redirectURL += "?supplierId=" + supplierId;
                if (toWarehouseID != null && !toWarehouseID.isEmpty()) {
                    redirectURL += "&toWarehouseID=" + toWarehouseID;
                }
            }

            response.sendRedirect(redirectURL);
            return;
        }
        
if ("submitRequest".equals(action)) {
    try {
        // 0. Lấy thông tin từ session & request
        Integer userId = (Integer) session.getAttribute("userId");
        Integer supplierId = (Integer) session.getAttribute("cartSupplierId");
        String toWarehouseIdRaw = request.getParameter("toWarehouseID");
        String note = request.getParameter("overallNote");

        if (userId == null || dbName == null || supplierId == null) {
            session.setAttribute("errorMessage", "Thiếu thông tin người dùng hoặc nhà cung cấp.");
            response.sendRedirect("import-request");
            return;
        }

        if (toWarehouseIdRaw == null || toWarehouseIdRaw.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng chọn kho đích trước khi gửi yêu cầu.");
            response.sendRedirect("import-request");
            return;
        }

        int toWarehouseId = Integer.parseInt(toWarehouseIdRaw);
        List<ProductDetailDTO> cartItems = (List<ProductDetailDTO>) session.getAttribute("cartItems");
        if (cartItems == null || cartItems.isEmpty()) {
            session.setAttribute("errorMessage", "Không có sản phẩm nào trong phiếu yêu cầu.");
            response.sendRedirect("import-request?supplierId=" + supplierId + "&toWarehouseID=" + toWarehouseId);
            return;
        }

        // 1. Insert phiếu nhập
        int movementId = StockMovementsRequestDAO.insertMovementRequest(
            dbName, supplierId, toWarehouseId, "import", (note != null ? note : ""), userId
        );

        // 2. Insert từng dòng chi tiết
        for (ProductDetailDTO item : cartItems) {
            StockMovementDetailDAO.insertMovementDetail(dbName, movementId, item.getProductDetailID(), item.getQuantity());
        }

        // 3. Ghi trạng thái pending
        StockMovementsRequestDAO.insertMovementResponse(dbName, movementId, userId, "pending", null);

        // 4. Ghi thông báo vào bảng Announcements (NEW)
        announcementDAO.insertImportRequestAnnouncement(dbName, userId, toWarehouseId, note);

        // 5. Dọn giỏ
        session.removeAttribute("cartItems");
        session.removeAttribute("cartSupplierId");

        session.setAttribute("successMessage", "Đã gửi yêu cầu nhập hàng thành công.");
        response.sendRedirect("import-request");
        return;

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("errorMessage", "Lỗi khi gửi yêu cầu nhập hàng: " + e.getMessage());
        response.sendRedirect("import-request");
    }
}



    }

    private void processDisplay(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dbName = (String) request.getSession().getAttribute("dbName");

        try {
            loadCommonData(request, dbName);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/import-request.jsp").forward(request, response);
    }

    private void loadCommonData(HttpServletRequest request, String dbName) throws SQLException {
        String keywordRaw = request.getParameter("keyword");
        String keyword = null;
        if (keywordRaw != null && !keywordRaw.trim().isEmpty()) {
            keyword = Validate.normalizeSearch(keywordRaw);
            request.setAttribute("keyword", keywordRaw);
        }

        List<Supplier> listSuppliers = suppliersDAO.getAllSupplier(dbName);
        request.setAttribute("listSuppliers", listSuppliers);

        List<Warehouse> listWarehouse = warehouseDAO.getAllWarehouses(dbName);
        request.setAttribute("listWarehouse", listWarehouse);

        String supplierIdRaw = request.getParameter("supplierId");
        String pageRaw = request.getParameter("page");
        int page = 1;
        int limit = 5;

        if (pageRaw != null) {
            try {
                page = Integer.parseInt(pageRaw);
                if (page <= 0) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * limit;

        if (supplierIdRaw != null && !supplierIdRaw.isEmpty()) {
            int selectedSupplierID = Integer.parseInt(supplierIdRaw);
            request.setAttribute("selectedSupplierID", selectedSupplierID);

            List<ProductDetailDTO> listProductDetails;
            int totalItems;
            int totalPages;

            if (keyword != null && !keyword.isEmpty()) {
                listProductDetails = productDAO.searchProductDetailDTOsBySupplier(
                        dbName, selectedSupplierID, keyword, offset, limit);
                totalItems = productDAO.countSearchProductDetailBySupplier(
                        dbName, selectedSupplierID, keyword);
            } else {
                listProductDetails = productDAO.getProductDetailDTOsBySupplierPaged(
                        dbName, selectedSupplierID, offset, limit);
                totalItems = productDAO.countProductDetailBySupplier(
                        dbName, selectedSupplierID);
            }

            totalPages = (int) Math.ceil((double) totalItems / limit);

            request.setAttribute("listProductDetails", listProductDetails);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        }
    }

    @Override
    public String getServletInfo() {
        return "Xử lý tạo phiếu yêu cầu nhập hàng (Shop Owner)";
    }
}