/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;

/**
 *
 * @author admin
 */
@WebServlet(name="BMCustomerJson", urlPatterns={"/customers-json"})
public class BMCustomerJson extends HttpServlet {
   
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

            CustomerDAO c = new CustomerDAO();

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            List<Customer> customers = c.getCustomers(dbName);

            Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
            
            String json = gson.toJson(customers);
            resp.getWriter().write(json);

        } catch (IOException | NumberFormatException e) {
            System.out.println(e.getMessage());
        } catch (SQLException ex) {
             Logger.getLogger(BMCustomerJson.class.getName()).log(Level.SEVERE, null, ex);
         }
    }
}
