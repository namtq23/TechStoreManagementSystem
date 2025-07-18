package controller;

import dao.StockMovementDAO;
import dao.StockMovementDetailDAO;
import dao.StockMovementsRequestDAO;
import model.ProductDetails;
import model.StockMovementDetail;
import model.Warehouse;
import util.Validate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/request-stock")
public class BMStockMovementController extends HttpServlet {

    private final StockMovementDetailDAO StockMovementDetailDAO = new StockMovementDetailDAO();
    private final StockMovementsRequestDAO StockMovementsRequestDAO = new StockMovementsRequestDAO();
    private final StockMovementDAO dao = new StockMovementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null || branchIdObj == null) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());

            String success = (String) session.getAttribute("successMessage");
            String error = (String) session.getAttribute("errorMessage");
            String selectedToWarehouseID = (String) session.getAttribute("selectedToWarehouseID");

            if (success != null) {
                req.setAttribute("successMessage", success);
                session.removeAttribute("successMessage");
            }
            if (error != null) {
                req.setAttribute("errorMessage", error);
                session.removeAttribute("errorMessage");
            }
            if (selectedToWarehouseID != null) {
                req.setAttribute("selectedToWarehouseID", selectedToWarehouseID);
            }

            String keyword = req.getParameter("keyword");
            if (keyword != null && keyword.isBlank()) {
                resp.sendRedirect("request-stock");
                return;
            }

            List<ProductDetails> products;
            List<Warehouse> warehouses = dao.getAllWarehouses(dbName);
            req.setAttribute("warehouses", warehouses);
 

            if (keyword != null && !keyword.isBlank()) {
                keyword = Validate.standardizeName(keyword);
                products = dao.searchProductsByName(branchId, keyword, dbName);
            } else {
                products = dao.getAvailableProductsByBranch(branchId, dbName);
            }

            // Lưu danh sách sản phẩm vào session để sử dụng trong doPost
            session.setAttribute("allProducts", products);

            List<StockMovementDetail> draft = (List<StockMovementDetail>) session.getAttribute("requestDraft");
            List<ProductDetails> draftProductDetails = new ArrayList<>();
            if (draft != null && !draft.isEmpty()) {
                List<ProductDetails> allProducts = dao.getAvailableProductsByBranch(branchId, dbName);
                for (ProductDetails allProduct : allProducts) {
                    System.out.println(allProduct);
                }
                for (StockMovementDetail detail : draft) {
                    for (ProductDetails p : allProducts) {
                        // SỬA: Dùng ProductDetailID để so sánh với ProductDetailID
                        if (p.getProductDetailID() == detail.getProductDetailID()) {
                            draftProductDetails.add(p);
                            break;
                        }
                    }
                }
            }

            int totalQuantity = 0;
            if (draft != null) {
                totalQuantity = draft.stream().mapToInt(StockMovementDetail::getQuantity).sum();
            }

            req.setAttribute("totalQuantity", totalQuantity);
            req.setAttribute("products", products);
            req.setAttribute("draftDetails", draft);
            req.setAttribute("draftProductDetails", draftProductDetails);
            req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-stockmovement-request.jsp").forward(req, resp);

        } catch (SQLException | NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi lấy danh sách sản phẩm.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");
        Object branchIdObj = session.getAttribute("branchId");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || branchIdObj == null) {
            System.out.println("Phiên không hợp lệ, chuyển hướng về login.");
            resp.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        int userId = Integer.parseInt(userIdObj.toString());
        int branchId = Integer.parseInt(branchIdObj.toString());

        String action = req.getParameter("action");
        System.out.println("=== [doPost] Action: " + action);

        // === UPDATE QUANTITY ===
        if ("updateQuantity".equals(action)) {
            String productDetailIDRaw = req.getParameter("productDetailID");
            String quantityRaw = req.getParameter("quantity");

            System.out.println(">> productDetailIDRaw = " + productDetailIDRaw);
            System.out.println(">> quantityRaw = " + quantityRaw);

            if (productDetailIDRaw == null || productDetailIDRaw.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Thiếu mã sản phẩm.");
                resp.sendRedirect("request-stock");
                return;
            }

            int productDetailID = Integer.parseInt(productDetailIDRaw.trim());
            int quantity = 1;
            try {
                quantity = Integer.parseInt(quantityRaw.trim());
                if (quantity < 1) {
                    quantity = 1;
                }
            } catch (Exception e) {
                quantity = 1;
            }

            List<StockMovementDetail> draft = (List<StockMovementDetail>) session.getAttribute("requestDraft");
            if (draft != null) {
                for (StockMovementDetail item : draft) {
                    if (item.getProductDetailID() == productDetailID) { // ✅ So sánh đúng
                        item.setQuantity(quantity);
                        break;
                    }
                }
                session.setAttribute("requestDraft", draft);
            }

            resp.sendRedirect("request-stock");
            return;
        }

        // === REMOVE PRODUCT ===
        if ("remove".equals(action)) {
            String idStr = req.getParameter("productDetailID");
            System.out.println("Xóa sản phẩm: " + idStr);

            if (idStr != null && !idStr.trim().isEmpty()) {
                int productDetailID = Integer.parseInt(idStr.trim());
                List<StockMovementDetail> draft = (List<StockMovementDetail>) session.getAttribute("requestDraft");
                if (draft != null) {
                    // SỬA: Dùng ProductDetailID thay vì ProductID
                    draft.removeIf(d -> d.getProductDetailID() == productDetailID);
                    session.setAttribute("requestDraft", draft);
                }
                session.setAttribute("successMessage", "Đã xoá sản phẩm.");
            } else {
                session.setAttribute("errorMessage", "Thiếu mã sản phẩm.");
            }

            resp.sendRedirect("request-stock");
            return;
        }

        // === ADD PRODUCT ===
        if ("add".equals(action)) {
            String idStr = req.getParameter("productDetailID");
            System.out.println("Thêm sản phẩm: " + idStr);

            if (idStr != null && !idStr.trim().isEmpty()) {
                int productDetailID = Integer.parseInt(idStr.trim());
                List<StockMovementDetail> draft = (List<StockMovementDetail>) session.getAttribute("requestDraft");

                if (draft == null) {
                    draft = new ArrayList<>();
                }

                boolean found = false;
                for (StockMovementDetail detail : draft) {
                    // SỬA: Dùng ProductDetailID thay vì ProductID
                    if (detail.getProductDetailID() == productDetailID) {
                        detail.setQuantity(detail.getQuantity() + 1);
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    // SỬA: Lấy đúng ProductID từ ProductDetails
                    List<ProductDetails> allProducts = (List<ProductDetails>) session.getAttribute("allProducts");
                    if (allProducts == null) {
                        try {
                            allProducts = dao.getAvailableProductsByBranch(branchId, dbName);
                            session.setAttribute("allProducts", allProducts);
                        } catch (SQLException e) {
                            session.setAttribute("errorMessage", "Lỗi khi lấy danh sách sản phẩm.");
                            resp.sendRedirect("request-stock");
                            return;
                        }
                    }

                    ProductDetails pd = null;
                    for (ProductDetails prod : allProducts) {
                        if (prod.getProductDetailID() == productDetailID) {
                            pd = prod;
                            break;
                        }
                    }

                    if (pd == null) {
                        session.setAttribute("errorMessage", "Không tìm thấy sản phẩm chi tiết.");
                        resp.sendRedirect("request-stock");
                        return;
                    }

                    StockMovementDetail newDetail = new StockMovementDetail();
                    // SỬA: Set đúng ProductID và ProductDetailID
                    newDetail.setProductID(pd.getProductID());             // Đúng: ID sản phẩm gốc
                    newDetail.setProductDetailID(pd.getProductDetailID()); // Đúng: ID chi tiết sản phẩm
                    newDetail.setQuantity(1);
                    draft.add(newDetail);
                }

                session.setAttribute("requestDraft", draft);
            }

            resp.sendRedirect("request-stock");
            return;
        }

        // === RESET DRAFT ===
        if ("reset".equals(action)) {
            System.out.println("Reset toàn bộ phiếu yêu cầu");
            session.removeAttribute("requestDraft");
            session.setAttribute("successMessage", "Đã xóa tất cả sản phẩm khỏi phiếu yêu cầu.");
            resp.sendRedirect("request-stock");
            return;
        }

        // === FINAL SUBMIT ===
        System.out.println("Gửi yêu cầu xuất hàng cuối cùng...");
        String toWarehouseStr = req.getParameter("toWarehouseID");
        String overallNote = req.getParameter("overallNote");

        try {
            if (toWarehouseStr == null || toWarehouseStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Chưa chọn kho đích.");
                resp.sendRedirect("request-stock");
                return;
            }

            int toWarehouseID = Integer.parseInt(toWarehouseStr.trim());
            List<StockMovementDetail> draft = (List<StockMovementDetail>) session.getAttribute("requestDraft");

            if (draft == null || draft.isEmpty()) {
                session.setAttribute("errorMessage", "Không có sản phẩm nào trong phiếu yêu cầu.");
                resp.sendRedirect("request-stock");
                return;
            }

            for (StockMovementDetail detail : draft) {
                // SỬA: Dùng ProductDetailID thay vì ProductID
                String paramName = "quantity_" + detail.getProductDetailID();
                String quantityStr = req.getParameter(paramName);
                int quantity = 1;
                try {
                    if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                        quantity = Integer.parseInt(quantityStr.trim());
                        if (quantity < 1) {
                            quantity = 1;
                        }
                    }
                } catch (NumberFormatException ignored) {
                    quantity = 1;
                }
                detail.setQuantity(quantity);
            }

            int movementId = StockMovementsRequestDAO.insertExportMovementRequest(
                    dbName, branchId, toWarehouseID, "export",
                    (overallNote != null ? overallNote : ""), userId
            );
            System.out.println("Đã tạo yêu cầu xuất ID = " + movementId);

            for (StockMovementDetail item : draft) {
                StockMovementDetailDAO.insertMovementDetail(dbName, movementId, item.getProductDetailID(), item.getQuantity());
            }

            StockMovementsRequestDAO.insertMovementResponse(dbName, movementId, userId, "pending", null);
            session.removeAttribute("requestDraft");
            session.setAttribute("successMessage", "Yêu cầu xuất hàng đã được gửi thành công.");
            resp.sendRedirect("request-stock");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi gửi yêu cầu xuất hàng: " + e.getMessage());
            resp.sendRedirect("request-stock");
        }
    }
}
