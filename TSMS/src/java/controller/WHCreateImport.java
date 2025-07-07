/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.StockMovementsRequestDAO;
import dao.SupplierDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Supplier;
import model.Product;
import model.StockMovementsRequest;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.Map;

/**
 *
 * @author admin
 */
@WebServlet(name="WHCreateImport", urlPatterns={"/wh-create-import"})
public class WHCreateImport extends HttpServlet {
   
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
        String warehouseId = (String) request.getSession().getAttribute("warehouseId");
        
        if (dbName == null || warehouseId == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Load suppliers for dropdown
            SupplierDAO supplierDAO = new SupplierDAO();
            List<Supplier> suppliers = supplierDAO.getAllSuppliers(dbName);
            request.setAttribute("suppliers", suppliers);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách nhà cung cấp.");
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/create-import.jsp").forward(request, response);
    }
    
    /**
     * Handles creating import request
     */
    private void handleCreateImport(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        String warehouseId = (String) request.getSession().getAttribute("warehouseId");
        String userId = (String) request.getSession().getAttribute("userID");
        
        try {
            // Get form parameters
            String action = request.getParameter("action");
            String supplierId = request.getParameter("supplierId");
            String orderCode = request.getParameter("orderCode");
            String notes = request.getParameter("notes");
            String discountAmountStr = request.getParameter("discountAmount");
            String productsJson = request.getParameter("products");
            
            // Validation
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
                    "message", "Vui lòng thêm ít nhất một sản phẩm"
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
            
            // Calculate total amount
            double totalAmount = 0;
            for (Map<String, Object> product : products) {
                try {
                    double quantity = ((Number) product.get("quantity")).doubleValue();
                    double price = ((Number) product.get("price")).doubleValue();
                    double productDiscount = ((Number) product.get("discount")).doubleValue();
                    
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
            String status = "draft"; // Default to draft
            if ("complete".equals(action)) {
                // Validate that all products have prices
                boolean allHavePrices = products.stream().allMatch(product -> {
                    try {
                        double price = ((Number) product.get("price")).doubleValue();
                        return price > 0;
                    } catch (Exception e) {
                        return false;
                    }
                });
                
                if (!allHavePrices) {
                    Map<String, Object> errorResponse = Map.of(
                        "success", false,
                        "message", "Vui lòng nhập đơn giá cho tất cả sản phẩm"
                    );
                    out.print(gson.toJson(errorResponse));
                    return;
                }
                
                status = "pending"; // Set to pending for approval
            }
            
            // Create the import request
            boolean success = requestDAO.createImportRequest(
                dbName,
                warehouseId,
                supplierId,
                userId,
                orderCode,
                notes,
                totalAmount,
                discountAmount,
                status,
                products
            );
            
            if (success) {
                Map<String, Object> successResponse = Map.of(
                    "success", true,
                    "message", "complete".equals(action) ? 
                        "Đã tạo phiếu nhập hàng thành công" : 
                        "Đã lưu nháp phiếu nhập hàng thành công"
                );
                out.print(gson.toJson(successResponse));
            } else {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Có lỗi xảy ra khi tạo phiếu nhập hàng"
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
        handleCreateImport(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for creating warehouse import requests";
    }// </editor-fold>

}