package controller;

import dao.SubscriptionsDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import model.ShopOwnerDTO;
import model.SubscriptionLogDTO;

/**
 *
 * @author admin
 */
@WebServlet(name = "SAShopOwnerDetailController", urlPatterns = {"/sa-sodetails"})
public class SAShopOwnerDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        System.out.println(idParam);

        if (idParam == null) {
            response.sendRedirect("sa-home");
            return;
        }

        try {
            int ownerId = Integer.parseInt(idParam);
            ShopOwnerDTO shopOwner = UserDAO.getShopOwnerById(ownerId);

            int page = 1;
            int pageSize = 10;

            String pageStr = request.getParameter("page");
            if (pageStr != null) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");

            LocalDate fromDate = fromDateStr != null && !fromDateStr.isEmpty() ? LocalDate.parse(fromDateStr) : LocalDate.now().minusMonths(1);
            LocalDate toDate = toDateStr != null && !toDateStr.isEmpty() ? LocalDate.parse(toDateStr) : LocalDate.now();
            int offset = (page - 1) * pageSize;

            SubscriptionsDAO dao = new SubscriptionsDAO();
            List<SubscriptionLogDTO> logs = dao.getSubscriptionLogsByOwnerId(ownerId, offset, pageSize, fromDate, toDate);
            int totalLogs = dao.countSubscriptionLogsByOwnerId(ownerId, fromDate, toDate);
            int totalPages = (int) Math.ceil((double) totalLogs / pageSize);
            
            Double totalSpent = SubscriptionsDAO.getTotalSpentByOwner(ownerId);

            request.setAttribute("logs", logs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("fromDate", fromDateStr);
            request.setAttribute("toDate", toDateStr);
            request.setAttribute("shopOwner", shopOwner);
            request.setAttribute("totalSpent", totalSpent);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/sa-sodetails.jsp").forward(request, response);
        } catch (NumberFormatException | ServletException | IOException | SQLException e) {
            System.out.println("error");
        }
    }

}
