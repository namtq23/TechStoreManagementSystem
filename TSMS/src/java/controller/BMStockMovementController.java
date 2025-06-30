package controller;

import dao.StockMovementDAO;
import model.ProductDetails;
import model.StockMovement;
import util.Validate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Warehouse;

@WebServlet("/request-stock")
public class BMStockMovementController extends HttpServlet {

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

            //Lấy danh sách kho 
            List<Warehouse> warehouses = dao.getAllWarehouses(dbName);
            req.setAttribute("warehouses", warehouses);

            if (keyword != null && !keyword.isBlank()) {
                keyword = Validate.standardizeName(keyword);
                products = dao.searchProductsByName(branchId, keyword, dbName);
            } else {
                products = dao.getAvailableProductsByBranch(branchId, dbName);
            }

            List<StockMovement.StockMovementDetail> draft
                      = (List<StockMovement.StockMovementDetail>) session.getAttribute("requestDraft");

            List<ProductDetails> draftProductDetails = new ArrayList<>();
            if (draft != null && !draft.isEmpty()) {
                for (StockMovement.StockMovementDetail detail : draft) {
                    try {
                        // Tìm sản phẩm trong danh sách tất cả sản phẩm (không bị filter)
                        List<ProductDetails> allProducts = dao.getAvailableProductsByBranch(branchId, dbName);
                        for (ProductDetails p : allProducts) {
                            if (p.getProductDetailID() == detail.getProductDetailID()) {
                                draftProductDetails.add(p);
                                break;
                            }
                        }
                    } catch (SQLException e) {
                    }
                }
            }
            int totalQuantity = 0;
            if (draft != null) {
                totalQuantity = draft.stream().mapToInt(StockMovement.StockMovementDetail::getQuantity).sum();
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
            resp.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        int userId = Integer.parseInt(userIdObj.toString());
        int branchId = Integer.parseInt(branchIdObj.toString());

        String action = req.getParameter("action");

        // === REMOVE PRODUCT ===
        if ("remove".equals(action)) {
            String idStr = req.getParameter("productDetailID");
            String toWarehouseID = req.getParameter("toWarehouseID");

            if (idStr != null) {
                int productDetailID = Integer.parseInt(idStr);
                List<StockMovement.StockMovementDetail> draft
                          = (List<StockMovement.StockMovementDetail>) session.getAttribute("requestDraft");

                if (draft != null) {
                    draft.removeIf(d -> d.getProductDetailID() == productDetailID);
                    session.setAttribute("requestDraft", draft);
                }
                session.setAttribute("successMessage", "Đã xoá sản phẩm.");
            } else {
                session.setAttribute("errorMessage", "Thiếu mã sản phẩm.");
            }

            if (toWarehouseID != null && !toWarehouseID.isBlank()) {
                session.setAttribute("selectedToWarehouseID", toWarehouseID);
            }

            // 🔁 Chuyển hướng về GET
            resp.sendRedirect("request-stock");
            return;
        }

// === ADD PRODUCT ===
        if ("add".equals(action)) {
            String idStr = req.getParameter("productDetailID");
            if (idStr != null) {
                int productDetailID = Integer.parseInt(idStr);
                List<StockMovement.StockMovementDetail> draft
                          = (List<StockMovement.StockMovementDetail>) session.getAttribute("requestDraft");

                if (draft == null) {
                    draft = new ArrayList<>();
                }

                // Tìm sản phẩm đã có
                boolean found = false;
                for (StockMovement.StockMovementDetail detail : draft) {
                    if (detail.getProductDetailID() == productDetailID) {
                        detail.setQuantity(detail.getQuantity() + 1);
                        found = true;
                        break;
                    }
                }

                // Nếu chưa có, thêm mới
                if (!found) {
                    draft.add(new StockMovement.StockMovementDetail(productDetailID, 1));
                }

                session.setAttribute("requestDraft", draft);
            }

            String selectedWarehouse = req.getParameter("toWarehouseID");
            if (selectedWarehouse != null && !selectedWarehouse.isBlank()) {
                session.setAttribute("selectedToWarehouseID", selectedWarehouse);
            }

            // Giữ keyword
            String keyword = req.getParameter("keyword");
            String redirectURL = "request-stock";
            if (keyword != null && !keyword.trim().isEmpty()) {
                redirectURL += "?keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
            }
            resp.sendRedirect(redirectURL);
            return;
        }

        // === RESET ALL PRODUCTS ===
        if ("reset".equals(action)) {
            session.removeAttribute("requestDraft");
            session.setAttribute("successMessage", "Đã xóa tất cả sản phẩm khỏi phiếu yêu cầu.");

            // Giữ lại keyword nếu có
            String keyword = req.getParameter("keyword");
            String redirectURL = "request-stock";
            if (keyword != null && !keyword.trim().isEmpty()) {
                redirectURL += "?keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
            }
            resp.sendRedirect(redirectURL);
            return;
        }

        // === SUBMIT REQUEST ===
        String toWarehouseStr = req.getParameter("toWarehouseID");
        String overallNote = req.getParameter("overallNote");

        try {
            int toWarehouseID = Integer.parseInt(toWarehouseStr);
            List<StockMovement.StockMovementDetail> draft
                      = (List<StockMovement.StockMovementDetail>) session.getAttribute("requestDraft");

            if (draft == null || draft.isEmpty()) {
                session.setAttribute("errorMessage", "Không có sản phẩm nào trong phiếu yêu cầu.");
                resp.sendRedirect("request-stock");
                return;
            }

            StockMovement movement = new StockMovement();
            movement.setCreatedBy(userId);
            movement.setFromBranchID(branchId);
            movement.setToWarehouseID(toWarehouseID);
            movement.setMovementType("Import");
            movement.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            movement.setNote(overallNote);
            movement.setDetails(draft);

            dao.createStockRequest(movement, dbName);
            session.removeAttribute("requestDraft");

            session.setAttribute("successMessage", "Yêu cầu nhập hàng đã được gửi thành công.");
            resp.sendRedirect("request-stock");

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi khi gửi yêu cầu nhập hàng.");
            resp.sendRedirect("request-stock");
        }
    }
}
