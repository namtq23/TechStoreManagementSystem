/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dao.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.lang.reflect.Type;
import java.util.List;
import model.ProductDTO;

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
            int pageSize = 10;

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
        String customerName = req.getParameter("fullName");
        String customerPhone = req.getParameter("phone");
        String customerGender = req.getParameter("gender");
        String customerAddress = req.getParameter("address");
        String customerMail = req.getParameter("email");
        String customerDob = req.getParameter("dob");

        String amountDue = req.getParameter("amountDue");
        String totalAmount = req.getParameter("totalAmount");

        String cartJson = req.getParameter("cartData");

        Gson gson = new Gson();
        Type productListType = new TypeToken<List<ProductDTO>>() {}.getType();
        List<ProductDTO> cartItems = gson.fromJson(cartJson, productListType);
        System.out.println(cartItems);
    }

}
