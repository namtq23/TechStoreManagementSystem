package controller;

import dao.StockMovementDAO;
import model.ProductDetails;
import model.StockMovement;
import util.Validate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.Warehouse;

@WebServlet("/import-request")
public class ImportRequestController extends HttpServlet {

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
            String supplierIdStr = req.getParameter("supplierId");
            
            if (keyword != null && keyword.isBlank()) {
                String redirectUrl = "import-request";
                if (supplierIdStr != null && !supplierIdStr.isBlank()) {
                    redirectUrl += "?supplierId=" + supplierIdStr;
                }
                resp.sendRedirect(redirectUrl);
                return;
            }

            List<ProductDetails> products;

            //Lấy danh sách kho 
            List<Warehouse> warehouses = dao.getAllWarehouses(dbName);
            req.setAttribute("warehouses", warehouses);

            // Lấy tất cả sản phẩm trước
            if (keyword != null && !keyword.isBlank()) {
                keyword = Validate.standardizeName(keyword);
                products = dao.searchProductsByName(branchId, keyword, dbName);
            } else {
                products = dao.getAvailableProductsByBranch(branchId, dbName);
            }

            // Filter theo supplierId nếu có
            if (supplierIdStr != null && !supplierIdStr.isBlank()) {
                try {
                    int supplierId = Integer.parseInt(supplierIdStr);
                    products = products.stream()
                        .filter(p -> p.getSupplierID() == supplierId)
                        .collect(Collectors.toList());
                    req.setAttribute("selectedSupplierId", supplierId);
                } catch (NumberFormatException e) {
                    // Nếu supplierId không hợp lệ, không filter
                }
            }

            List<StockMovement.StockMovementDetail> draft
                      = (List<StockMovement.StockMovementDetail>) session.getAttribute("requestDraft");

            List<ProductDetails> draftProductDetails = new ArrayList<>();
            if (draft != null && !draft.isEmpty()) {
                for (StockMovement.StockMovementDetail detail : draft) {
                    try {
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
        // Redirect POST requests to request-stock controller để xử lý logic add/remove/submit
        String supplierIdStr = req.getParameter("supplierId");
        String keyword = req.getParameter("keyword");
        
        StringBuilder redirectUrl = new StringBuilder("request-stock");
        boolean hasParams = false;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            redirectUrl.append("?keyword=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
            hasParams = true;
        }
        
        if (supplierIdStr != null && !supplierIdStr.trim().isEmpty()) {
            redirectUrl.append(hasParams ? "&" : "?").append("supplierId=").append(supplierIdStr);
        }
        
        resp.sendRedirect(redirectUrl.toString());
    }
}