/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.ProductDTO;

/**
 *
 * @author admin
 */
@WebServlet(name = "BMCartJson", urlPatterns = {"/products-json"})
public class BMCartJson extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (branchIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());

            ProductDAO p = new ProductDAO();
            
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            List<ProductDTO> products = p.getInventoryProductListByPageByBranchId(dbName, branchId, 0, p.countProductsByBranchId(dbName, branchId));

            Gson gson = new Gson();
            String json = gson.toJson(products);
            resp.getWriter().write(json);
            
        } catch (IOException | NumberFormatException e) {
            System.out.println(e.getMessage());
        }
    }

}
