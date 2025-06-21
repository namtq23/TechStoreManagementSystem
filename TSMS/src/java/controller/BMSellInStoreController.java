/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dao.CashFlowDAO;
import dao.CustomerDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.lang.reflect.Type;
import java.util.List;
import java.sql.Date;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.Order;
import model.ProductDTO;
import model.User;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "BMSellInStoreController", urlPatterns = {"/bm-cart"})
public class BMSellInStoreController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());
            int page = 1;
            int pageSize = 100;

            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
            int offset = (page - 1) * pageSize;

            ProductDAO p = new ProductDAO();
            List<ProductDTO> products = p.getInventoryProductListByPageByBranchId(dbName, branchId, offset, pageSize);
            int totalProducts = p.countProductsByBranchId(dbName, branchId);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("startProduct", offset + 1);
            req.setAttribute("endProduct", Math.min(offset + pageSize, totalProducts));
            req.setAttribute("products", products);

            req.getRequestDispatcher("/WEB-INF/jsp/manager/sell-in-store.jsp").forward(req, resp);
        } catch (ServletException | IOException | NumberFormatException e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());

            String customerName = req.getParameter("fullName");
            String customerPhone = req.getParameter("phone");
            String customerGender = req.getParameter("gender");
            String customerAddress = req.getParameter("address");
            String customerMail = req.getParameter("email");
            String dobStr = req.getParameter("dob");
            boolean gender = true;
            switch (customerGender) {
                case "1":
                    gender = true;
                    break;
                case "0":
                    gender = false;
                    break;
            }
            Date customerDob;
            if (dobStr == null || dobStr.isEmpty()) {
                customerDob = null;
            } else {
                customerDob = Date.valueOf(dobStr);
            }

            String paymentMethod = req.getParameter("paymentMethod");
            Double amountDue = Validate.safeParseDouble(req.getParameter("amountDue"));
            Double cashGiven = Validate.safeParseDouble(req.getParameter("cashGiven"));
            Double changeDue = Validate.safeParseDouble(req.getParameter("changeDue"));

            String cartJson = req.getParameter("cartData");

            Gson gson = new Gson();
            Type productListType = new TypeToken<List<ProductDTO>>() {
            }.getType();
            List<ProductDTO> cartItems = gson.fromJson(cartJson, productListType);

            Order order;
            Customer customer = new Customer();

            if (CustomerDAO.checkCustomerExist(dbName, customerPhone)) {
                System.out.println("Khách hàng cũ");
                int customerId = CustomerDAO.getCustomerId(dbName, customerPhone);
                order = new Order(0, branchId, userId, "Hoàn thành", customerId, paymentMethod, null, amountDue, cashGiven,
                        changeDue);
                ProductDAO.updateProductQuantityOfInventory(dbName, cartItems, branchId);
            } else {
                System.out.println("Khách hàng mới");
                customer = new Customer(0, customerName, customerPhone, customerMail, customerAddress, gender, customerDob,
                        null, null);
                CustomerDAO.insertCustomer(dbName, customer);
                int customerId = CustomerDAO.getCustomerId(dbName, customerPhone);
                order = new Order(0, branchId, userId, "Hoàn thành", customerId, paymentMethod, null, amountDue, cashGiven,
                        changeDue);
                ProductDAO.updateProductQuantityOfInventory(dbName, cartItems, branchId);
            }

            OrderDAO.insertOrderWithDetails(dbName, order, cartItems);

            int latestOrderId = OrderDAO.getLatestOrderId(dbName, branchId);
            for (ProductDTO product : cartItems) {
                for (int i = 0; i < product.getQuantity(); i++) {
                    boolean rs = ProductDAO.markSerialAsSold(dbName, product.getProductDetailId(), latestOrderId, branchId);
                }
            }

            User user = UserDAO.getUserById(userId, dbName);

            CashFlowDAO.insertCashFlow(dbName, "income", amountDue, "Tiền hoá đơn", "Tiền hoá đơn của chi nhánh" + branchId, paymentMethod, latestOrderId, branchId, user.getFullName());

            resp.sendRedirect(req.getContextPath() + "/bm-cart");
        } catch (SQLException ex) {
            Logger.getLogger(BMSellInStoreController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
