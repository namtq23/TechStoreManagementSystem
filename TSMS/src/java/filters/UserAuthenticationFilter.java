/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filters;

/**
 *
 * @author Astersa
 */
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.User;

@WebFilter(filterName = "UserAuthenticationFilter", urlPatterns = {"/bm-products", "/bm-overview", "/bm-staff", "/bm-customer"})
public class UserAuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            Cookie[] cookies = httpRequest.getCookies();
            String dbName = null;
            String userIdStr = null;

            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberUser".equals(cookie.getName())) {
                        userIdStr = cookie.getValue();
                    } else if ("rememberDb".equals(cookie.getName())) {
                        dbName = cookie.getValue();
                    }
                }
            }

            if (userIdStr != null && dbName != null) {
                try {
                    int userId = Integer.parseInt(userIdStr);
                    User user = UserDAO.getUserById(userId, dbName);

                    if (user != null) {
                        HttpSession newSession = httpRequest.getSession(true);
                        newSession.setAttribute("userId", user.getUserID());
                        newSession.setAttribute("roleId", user.getRoleId());
                        newSession.setAttribute("dbName", dbName);
                        newSession.setAttribute("branchId", user.getBranchId());
                        newSession.setAttribute("warehouseId", user.getWarehouseId());

                        chain.doFilter(request, response);
                        return;
                    }
                } catch (NumberFormatException | SQLException e) {
                    System.out.println(e);
                }
            }

            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Cleanup logic (if needed)
    }
}
