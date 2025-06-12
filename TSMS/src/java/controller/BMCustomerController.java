package controller;

import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import model.Customer;

@WebServlet(name = "BMCustomerController", urlPatterns = {"/bm-customer"})
public class BMCustomerController extends HttpServlet {

   @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    HttpSession session = req.getSession(false);
    Object userIdObj = session.getAttribute("userId");
    Object roleIdObj = session.getAttribute("roleId");
    Object dbNameObj = session.getAttribute("dbName");
    if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
        resp.sendRedirect("login");
        return;
    }

    try {
        String dbName = dbNameObj.toString();
        String keyword = req.getParameter("keyword");
         String genderFilter = req.getParameter("gender"); // "male", "female", "all", hoặc null
         String showTop = req.getParameter("top"); // nếu bằng "true" thì hiển thị top 10
        int page = 1;
        int pageSize = 10;

        // Đảm bảo page >= 1
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * pageSize;

        CustomerDAO customerDAO = new CustomerDAO();
        List<Customer> customers;
        int totalCustomers;
        int totalPages;
        
        if ("true".equalsIgnoreCase(showTop)) {
         // Trường hợp lọc top 10 khách hàng chi tiêu nhiều nhất
        customers = customerDAO.getTop10CustomersBySpending(dbName);
        totalCustomers = customers.size();
        totalPages = 1;
        page = 1;
            }else if (keyword != null && !keyword.trim().isEmpty()) {
            // Trường hợp tìm kiếm: không phân trang
            customers = customerDAO.searchCustomersByName(dbName, keyword.trim() ,genderFilter );
            
            totalCustomers = customers.size();
            totalPages = 1; // Vì hiển thị tất cả
            page = 1; // reset về trang đầu
        } else {
            // Trường hợp hiển thị tất cả: có phân trang
            totalCustomers = customerDAO.countCustomers(dbName, genderFilter);
            totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
            
            // Nếu page > totalPages thì set về cuối cùng
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
                offset = (page - 1) * pageSize;
            }

            customers = customerDAO.getCustomerListByPage(dbName, offset, pageSize, genderFilter);
        }

        req.setAttribute("customers", customers);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCustomers", totalCustomers);
        req.setAttribute("startCustomer", keyword != null && !keyword.trim().isEmpty() ? 1 : offset + 1);
        req.setAttribute("endCustomer", keyword != null && !keyword.trim().isEmpty()
                ? totalCustomers : Math.min(offset + pageSize, totalCustomers));
        req.setAttribute("genderFilter", genderFilter);
        req.setAttribute("keyword", keyword);
        req.setAttribute("showTop", showTop);
        req.setAttribute("service", "active");

        req.getRequestDispatcher("/WEB-INF/jsp/manager/customer.jsp").forward(req, resp);

    } catch (SQLException e) {
        throw new ServletException("Database error when loading customers", e);
    }
    
}
}
