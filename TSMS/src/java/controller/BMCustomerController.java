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
        // Lấy session hiện tại, không tạo mới nếu không tồn tại
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login");
            return;
        }

        // Lấy các tham số session cần thiết
        Object staffIdObj = session.getAttribute("staffId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        // Kiểm tra các tham số bắt buộc
        if (staffIdObj == null || roleIdObj == null || dbNameObj == null) {
            resp.sendRedirect("login");
            return;
        }

        try {
            int staffId = Integer.parseInt(staffIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();

            CustomerDAO customerDAO = new CustomerDAO();
            List<Customer> customers = customerDAO.getAllCustomers(dbName);

            req.setAttribute("customers", customers);
            req.setAttribute("service", "active"); // nếu cần highlight menu hay tương tự

            req.getRequestDispatcher("/WEB-INF/jsp/manager/customer.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid session attributes.");
        } catch (SQLException e) {
            throw new ServletException("Database error when loading customers", e);
        }
    }
}
