/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShopOwnerDAO;
import dao.UserDAO;
import jakarta.mail.MessagingException;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ShopOwner;
import util.EmailUtil;

/**
 *
 * @author admin
 */
@WebServlet(name = "SAApproveSubs", urlPatterns = {"/sa-approved-subs"})
public class SAApproveSubs extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ownerIdStr = request.getParameter("id");
        String action = request.getParameter("action");

        if (ownerIdStr != null) {
            switch (action) {
                case "accept":
                try {
                    int ownerId = Integer.parseInt(ownerIdStr);
                    int methodId = Integer.parseInt(request.getParameter("methodId"));
                    int subsMonth = Integer.parseInt(request.getParameter("subsMonth"));

                    ShopOwner so = UserDAO.getShopOwnerById(ownerId);
                    ShopOwnerDAO dao = new ShopOwnerDAO();
                    dao.activateShopOwnerIfInactive(ownerId);
                    UserDAO.activateUsersIfInactive(so.getDatabaseName());
                    dao.markSubscriptionLogAsDone(ownerId, methodId);
                    dao.updateUserServiceMethod(ownerId, methodId, subsMonth);

                    // Gửi mail thông báo thành công
                    String to = so.getEmail();
                    String subject = "Xác nhận đăng ký gói dịch vụ TSMS";
                    String message = "<h3>Chúc mừng bạn đã đăng ký thành công!</h3>"
                            + "<p>Gói dịch vụ của bạn đã được phê duyệt và sẽ có hiệu lực trong <strong>" + subsMonth + "</strong> tháng.</p>"
                            + "<p>Trân trọng,<br>TSMS Support</p>";

                    EmailUtil.sendEmail(to, subject, message);

                    response.sendRedirect("sa-subscriptions?&update=success");
                } catch (NumberFormatException | SQLException | MessagingException e) {
                    e.printStackTrace();
                    response.sendRedirect("sa-subscriptions?update=error");
                }
                break;

                case "refuse":
                try {
                    int ownerId = Integer.parseInt(ownerIdStr);
                    int methodId = Integer.parseInt(request.getParameter("methodId"));

                    ShopOwnerDAO dao = new ShopOwnerDAO();
                    dao.markSubscriptionLogAsRefuse(ownerId, methodId);

                    // Gửi mail thông báo từ chối
                    ShopOwner so = UserDAO.getShopOwnerById(ownerId);
                    String to = so.getEmail();
                    String subject = "Đăng ký gói dịch vụ TSMS bị từ chối";
                    String message = "<h3>Rất tiếc!</h3>"
                            + "<p>Yêu cầu đăng ký gói dịch vụ của bạn đã bị từ chối. Vui lòng liên hệ bộ phận hỗ trợ để biết thêm chi tiết.</p>"
                            + "<p>Trân trọng,<br>TSMS Support</p>";

                    EmailUtil.sendEmail(to, subject, message);

                    response.sendRedirect("sa-subscriptions?&update=success-refuse");
                } catch (NumberFormatException | SQLException | MessagingException e) {
                    response.sendRedirect("sa-subscriptions?update=error");
                }
                break;
            }
        } else {
            response.sendRedirect("sa-subscriptions?update=error");
        }
    }

}
