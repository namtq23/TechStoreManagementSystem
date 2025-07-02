package controller;

import dao.SuppliersDAO;
import model.Supplier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SOSupplierController", urlPatterns = {"/so-supplier"})
public class SOSupplierController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Kiểm tra đăng nhập
        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("roleId") == null
                || session.getAttribute("dbName") == null) {
            resp.sendRedirect("login");
            return;
        }

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            resp.sendRedirect(req.getContextPath() + "/subscription?status=expired");
            return;
        }

        int roleId = Integer.parseInt(session.getAttribute("roleId").toString());
        if (roleId != 0) {
            resp.sendRedirect("login");
            return;
        }

        String dbName = session.getAttribute("dbName").toString();
        String keyword = req.getParameter("keyword");
        String showTop = req.getParameter("top");
        String pageParam = req.getParameter("page");

        int page = 1;
        int pageSize = 10;

        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * pageSize;

        SuppliersDAO suppliersDAO = new SuppliersDAO();
        List<Supplier> suppliers;
        int totalSuppliers;
        int totalPages;
        if ("true".equalsIgnoreCase(showTop)) {
            // Top 10 nhà cung cấp theo tổng đơn hàng
            suppliers = suppliersDAO.getAllSuppliers(dbName);
            totalSuppliers = suppliers.size();
            totalPages = 1;
            page = 1;
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            // Tìm kiếm theo tên
            suppliers = suppliersDAO.searchSuppliersByName(dbName, keyword.trim());
            totalSuppliers = suppliers.size();
            totalPages = 1;
            page = 1;
        } else {
            // Hiển thị tất cả với phân trang
            totalSuppliers = suppliersDAO.countSuppliers(dbName);
            totalPages = (int) Math.ceil((double) totalSuppliers / pageSize);

            if (page > totalPages && totalPages > 0) {
                page = totalPages;
                offset = (page - 1) * pageSize;
            }

            suppliers = suppliersDAO.getSuppliersByPage(dbName, offset, pageSize);
        }
        req.setAttribute("suppliers", suppliers);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalSuppliers", totalSuppliers);
        int startSupplier = (keyword != null && !keyword.trim().isEmpty()) ? 1 : offset + 1;
        int endSupplier = (keyword != null && !keyword.trim().isEmpty()) ? totalSuppliers : Math.min(offset + pageSize, totalSuppliers);
        req.setAttribute("startSupplier", startSupplier);
        req.setAttribute("endSupplier", endSupplier);
        req.setAttribute("keyword", keyword);
        req.setAttribute("showTop", showTop);
        req.setAttribute("service", "active");
        req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-supplier.jsp").forward(req, resp);
    }
    
    
    @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    try {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID nhà cung cấp.");
            return;
        }

        int supplierId = Integer.parseInt(idStr.trim());
        String supplierName = req.getParameter("supplierName");
        String contactName = req.getParameter("contactName");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        HttpSession session = req.getSession(false);
        String dbName = (session != null) ? (String) session.getAttribute("dbName") : null;

        if (dbName == null || supplierName == null || supplierName.trim().isEmpty()) {
            resp.sendRedirect("so-supplier.jsp");
            return;
        }

        SuppliersDAO dao = new SuppliersDAO();
        boolean success = dao.updateSupplier(dbName, supplierId, supplierName, contactName, phone, email);

        if (success) {
            session.setAttribute("successMessage", "Cập nhật nhà cung cấp thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật thất bại.");
        }

        resp.sendRedirect("so-supplier");

    } catch (Exception e) {
        e.printStackTrace();
        resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
}

private String getSafeParam(HttpServletRequest req, String paramName) {
    String value = req.getParameter(paramName);
    return (value != null && !value.trim().isEmpty()) ? value.trim() : null;
}

    
    
}
