/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.StockMovementsRequestDAO;
import dao.SupplierDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Supplier;
import model.Warehouse;
import model.StockMovementsRequest;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.Map;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author TSMS Team
 */
@WebServlet(name="SOImportController", urlPatterns={"/nhap-hang"})
public class SOImportController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        String userID = (String) request.getSession().getAttribute("userID");
        
        if (dbName == null || userID == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Load suppliers for dropdown
            SupplierDAO supplierDAO = new SupplierDAO();
            List<Supplier> suppliers = supplierDAO.getAllSuppliers(dbName);
            request.setAttribute("suppliers", suppliers);
            
            // Load warehouses for dropdown
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<Warehouse> warehouses = warehouseDAO.getAllWarehouses(dbName);
            request.setAttribute("warehouses", warehouses);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/nhap-hang.jsp").forward(request, response);
    }
    
    /**
     * Handles creating import request from Shop Owner
     */
    private void handleCreateImportRequest(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        String userID = (String) request.getSession().getAttribute("userID");
        
        try {
            // Get form parameters
            String action = request.getParameter("action");
            String warehouseId = request.getParameter("warehouseId");
            String supplierId = request.getParameter("supplierId");
            String orderCode = request.getParameter("orderCode");
            String notes = request.getParameter("notes");
            String priority = request.getParameter("priority");
            String discountAmountStr = request.getParameter("discountAmount");
            String productsJson = request.getParameter("products");
            
            // Validation
            if (warehouseId == null || warehouseId.trim().isEmpty()) {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Vui lòng chọn kho nhận hàng"
                );
                out.print(gson.toJson(errorResponse));
                return;
            }
            
            if (supplierId == null || supplierId.trim().isEmpty()) {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Vui lòng chọn nhà cung cấp"
                );
                out.print(gson.toJson(errorResponse));
                return;
            }
            
            if (productsJson == null || productsJson.trim().isEmpty()) {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Vui lòng thêm ít nhất một sản phẩm vào yêu cầu"
                );
                out.print(gson.toJson(errorResponse));
                return;
            }
            
            // Parse products JSON
            Type productListType = new TypeToken<List<Map<String, Object>>>(){}.getType();
            List<Map<String, Object>> products = gson.fromJson(productsJson, productListType);
            
            if (products == null || products.isEmpty()) {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Danh sách sản phẩm không hợp lệ"
                );
                out.print(gson.toJson(errorResponse));
                return;
            }
            
            // Parse discount amount
            double discountAmount = 0;
            try {
                if (discountAmountStr != null && !discountAmountStr.trim().isEmpty()) {
                    discountAmount = Double.parseDouble(discountAmountStr);
                }
            } catch (NumberFormatException e) {
                discountAmount = 0;
            }
            
            // Set default priority if not provided
            if (priority == null || priority.trim().isEmpty()) {
                priority = "normal";
            }
            
            // Calculate total amount (estimated)
            double totalAmount = 0;
            for (Map<String, Object> product : products) {
                try {
                    double quantity = ((Number) product.get("quantity")).doubleValue();
                    double price = 0;
                    if (product.get("price") != null) {
                        price = ((Number) product.get("price")).doubleValue();
                    }
                    double productDiscount = 0;
                    if (product.get("discount") != null) {
                        productDiscount = ((Number) product.get("discount")).doubleValue();
                    }
                    
                    totalAmount += (quantity * price) - productDiscount;
                } catch (Exception e) {
                    System.err.println("Error calculating product total: " + e.getMessage());
                }
            }
            
            // Apply overall discount
            totalAmount -= discountAmount;
            
            // Create import request
            StockMovementsRequestDAO requestDAO = new StockMovementsRequestDAO();
            
            // Determine status based on action
            String status = "draft"; // Default to draft for Shop Owner
            String requestMessage = "Đã lưu nháp yêu cầu nhập hàng thành công";
            
            if ("submit".equals(action)) {
                status = "pending"; // Set to pending for Warehouse Manager to process
                requestMessage = "Đã gửi yêu cầu nhập hàng đến kho thành công";
            } else if ("autosave".equals(action)) {
                // Silent auto-save, no message needed
                requestMessage = "";
            }
            
            // Generate request ID
            String requestId = generateRequestId();
            
            // Prepare additional data for the request
            String requestData = gson.toJson(Map.of(
                "orderCode", orderCode != null ? orderCode : "",
                "priority", priority,
                "estimatedTotal", totalAmount,
                "requestedBy", userID,
                "requestedAt", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)
            ));
            
            // Create the import request for Shop Owner
            boolean success = requestDAO.createShopOwnerImportRequest(
                dbName,
                requestId,
                warehouseId,
                supplierId,
                userID,
                notes,
                totalAmount,
                discountAmount,
                status,
                priority,
                products,
                requestData
            );
            
            if (success) {
                Map<String, Object> successResponse;
                if ("autosave".equals(action)) {
                    successResponse = Map.of("success", true);
                } else {
                    successResponse = Map.of(
                        "success", true,
                        "message", requestMessage,
                        "requestId", requestId
                    );
                }
                out.print(gson.toJson(successResponse));
            } else {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Có lỗi xảy ra khi tạo yêu cầu nhập hàng"
                );
                out.print(gson.toJson(errorResponse));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = Map.of(
                "success", false,
                "message", "Lỗi hệ thống: " + e.getMessage()
            );
            out.print(gson.toJson(errorResponse));
        }
    }
    
    /**
     * Generate unique request ID
     */
    private String generateRequestId() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        return "REQ" + timestamp + String.format("%03d", (int)(Math.random() * 1000));
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        handleCreateImportRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for Shop Owner to create import requests to Warehouse";
    }// </editor-fold>

}