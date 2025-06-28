package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import model.StockMovement;
import model.StockMovement.StockMovementDetail;
import dao.StockMovementDAO;

@WebServlet("/bm-stockmovement")
public class BMStockMovementController extends HttpServlet {

    private final StockMovementDAO dao = new StockMovementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        HttpSession session = req.getSession();

        // Kiểm tra session đăng nhập dựa trên userId và roleId
        if (session.getAttribute("userId") == null || session.getAttribute("roleId") == null) {
            resp.sendRedirect("common/homeLogin.jsp");
            return;
        }

        try {
            if ("import".equals(type)) {
                req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-stockmovement.jsp").forward(req, resp);

            } else if ("request".equals(type)) {
                req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-stockmovement-request.jsp").forward(req, resp);

            } else {
                resp.sendRedirect("/WEB-INF/jsp/manager/bm-.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if (session.getAttribute("userId") == null || session.getAttribute("branchId") == null) {
            resp.sendRedirect("common/homeLogin.jsp");
            return;
        }

        if ("submitRequest".equals(action)) {
            String jsonData = req.getParameter("productData");
            String note = req.getParameter("note");

            try {
                Gson gson = new Gson();
                StockMovementDetail[] parsed = gson.fromJson(jsonData, StockMovementDetail[].class);
                List<StockMovementDetail> details = new ArrayList<>(Arrays.asList(parsed));

                StockMovement movement = new StockMovement();
                movement.setFromWarehouseID(null);

                int branchID = Integer.parseInt(session.getAttribute("branchId").toString());
                int userID = Integer.parseInt(session.getAttribute("userId").toString());

                movement.setToBranchID(branchID);
                movement.setCreatedBy(userID);
                movement.setMovementType("ImportRequest");
                movement.setNote(note);
                movement.setDetails(details);

                dao.createFullStockMovement(movement);

                resp.sendRedirect("bm-stockmovement?type=import&success=true");

            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                resp.sendRedirect("bm-stockmovement?type=request&error=true");
            }
        }
    }
}
