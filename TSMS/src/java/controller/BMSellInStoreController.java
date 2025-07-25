/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dao.BranchDAO;
import dao.CashFlowDAO;
import dao.CustomerDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.SalesDAO;
import dao.UserDAO;
import jakarta.mail.MessagingException;
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
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Branch;
import model.Customer;
import model.Order;
import model.ProductDTO;
import model.User;
import model.UserDTO;
import util.EmailUtil;
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
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                req.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }

            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());

            if (roleId != 1) {
                resp.sendRedirect("login");
                return;
            }

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

            List<UserDTO> sale = SalesDAO.getAllSalesStaff(dbName);

            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("startProduct", offset + 1);
            req.setAttribute("endProduct", Math.min(offset + pageSize, totalProducts));
            req.setAttribute("products", products);
            req.setAttribute("sale", sale);

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
            int createdBy = Integer.parseInt(req.getParameter("sale"));
            String billDiscountStr = req.getParameter("billDiscount");
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
            Customer customer;

            if (CustomerDAO.checkCustomerExist(dbName, customerPhone)) {
                System.out.println("Khách hàng cũ");
                int customerId = CustomerDAO.getCustomerId(dbName, customerPhone);
                order = new Order(0, branchId, createdBy, "Hoàn thành", customerId, paymentMethod, null, amountDue, cashGiven,
                        changeDue);
                System.out.println("Khach hang cu: " + order);
                ProductDAO.updateProductQuantityOfInventory(dbName, cartItems, branchId);
            } else {
                System.out.println("Khách hàng mới");
                customer = new Customer(0, customerName, customerPhone, customerMail, customerAddress, gender, customerDob,
                        null, null);
                CustomerDAO.insertCustomer(dbName, customer);
                int customerId = CustomerDAO.getCustomerId(dbName, customerPhone);
                order = new Order(0, branchId, createdBy, "Hoàn thành", customerId, paymentMethod, null, amountDue, cashGiven,
                        changeDue);
                System.out.println("Khach hang moi: " + order);
                ProductDAO.updateProductQuantityOfInventory(dbName, cartItems, branchId);
            }

            OrderDAO.insertOrderWithDetails(dbName, order, cartItems);

            int latestOrderId = OrderDAO.getLatestOrderId(dbName, branchId);
            for (ProductDTO product : cartItems) {
                for (int i = 0; i < product.getQuantity(); i++) {
                    boolean rs = ProductDAO.markSerialAsSold(dbName, product.getProductDetailId(), latestOrderId, branchId);
                }
            }

            User user = UserDAO.getUserById(createdBy, dbName);

            CashFlowDAO.insertCashFlow(dbName, "income", amountDue, "Tiền hoá đơn", "Tiền hoá đơn của chi nhánh" + branchId, paymentMethod, latestOrderId, branchId, user.getFullName());

            Branch branch = BranchDAO.getBranchById(branchIdObj.toString(), dbName);
            String creatorName = user.getFullName();
            String branchName = branch.getBranchName();
            double billDiscount;
            if (billDiscountStr == null || billDiscountStr.trim().isEmpty()) {
                billDiscount = 0.0;
            } else {
                billDiscount = Double.parseDouble(billDiscountStr);
            }

            if (customerMail != null && !customerMail.trim().isEmpty()) {
                try {
                    StringBuilder emailContent = new StringBuilder();

                    emailContent.append("<h2 style='color: #1976d2;'>Thông tin đơn hàng #" + latestOrderId + "</h2>");
                    emailContent.append("<p><strong>Người tạo:</strong> ").append(creatorName).append("</p>");
                    emailContent.append("<p><strong>Chi nhánh:</strong> ").append(branchName).append("</p>");
                    emailContent.append("<p><strong>Phương thức thanh toán:</strong> ").append(order.getPaymentMethod()).append("</p>");
                    emailContent.append("<br>");

                    emailContent.append("<table border='1' cellpadding='10' cellspacing='0' style='border-collapse:collapse; width:100%; font-family:Arial, sans-serif;'>");
                    emailContent.append("<thead><tr style='background-color:#f0f0f0;'>");
                    emailContent.append("<th>Tên sản phẩm</th><th>Số lượng</th><th>Giá sau giảm</th><th>Giảm giá (%)</th><th>Thành tiền</th>");
                    emailContent.append("</tr></thead>");
                    emailContent.append("<tbody>");

                    for (ProductDTO product : cartItems) {
                        try {
                            double retailPrice = Double.parseDouble(product.getRetailPrice());
                            double discount = product.getDiscountPercent();
                            double discountedPrice = retailPrice * (1 - discount);
                            double lineTotal = discountedPrice * product.getQuantity();

                            emailContent.append("<tr>");
                            emailContent.append("<td>").append(product.getProductName()).append("</td>");
                            emailContent.append("<td align='center'>").append(product.getQuantity()).append("</td>");
                            emailContent.append("<td align='right'>").append(String.format("%,.0f", discountedPrice)).append("đ</td>");
                            emailContent.append("<td align='right'>").append((int) (discount)).append("%</td>");
                            emailContent.append("<td align='right'>").append(String.format("%,.0f", lineTotal)).append("đ</td>");
                            emailContent.append("</tr>");
                        } catch (NumberFormatException e) {
                            emailContent.append("<tr><td colspan='5' style='color:red;'>Lỗi giá sản phẩm: ").append(product.getProductName()).append("</td></tr>");
                        }
                    }
                    emailContent.append("</tbody></table><br>");

                    emailContent.append("<table style='margin-top: 20px; font-size: 16px;'>");
                    if (billDiscount > 0) {
                        emailContent.append("<tr><td><strong>Giảm giá hoá đơn:</strong></td><td align='right'>").append(String.format("%,.0f", billDiscount)).append("%</td></tr>");
                    }
                    emailContent.append("<tr><td><strong>Tổng cộng:</strong></td><td align='right'>").append(String.format("%,.0f", order.getGrandTotal())).append("đ</td></tr>");
                    emailContent.append("<tr><td><strong>Khách thanh toán:</strong></td><td align='right'>").append(String.format("%,.0f", order.getCustomerPay())).append("đ</td></tr>");
                    emailContent.append("<tr><td><strong>Tiền thừa trả lại:</strong></td><td align='right'>").append(String.format("%,.0f", order.getChange())).append("đ</td></tr>");
                    emailContent.append("</table>");

                    emailContent.append("<p>Chúc bạn một ngày tốt lành! Nếu có thắc mắc vui lòng liên hệ lại với chúng tôi.</p>");
                    emailContent.append("</body></html>");

                    // Gửi mail
                    EmailUtil.sendEmail(customerMail, "Thông tin hóa đơn #" + latestOrderId, emailContent.toString());

                } catch (MessagingException e) {
                    System.out.println(e);
                }
            }

            session.setAttribute("successMessage", "Tạo đơn hàng thành công!");
            resp.sendRedirect(req.getContextPath() + "/bm-cart");
        } catch (SQLException ex) {
            Logger.getLogger(BMSellInStoreController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
