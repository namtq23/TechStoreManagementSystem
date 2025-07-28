/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOSubscribePaymentController", urlPatterns = {"/subscription-payment"})
public class SOSubscribePaymentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
            resp.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        String fullName = req.getParameter("fullname");
        String gender = req.getParameter("gender");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String cccd = req.getParameter("cccd");
        String address = req.getParameter("address");
        String planId = req.getParameter("plan");

        String duration = "";
        int price = 0;
        switch (planId) {
            case "1":
                duration = "3 tháng";
                price = 700000;
                break;
            case "2":
                duration = "6 tháng";
                price = 1200000;
                break;
            case "3":
                duration = "1 năm";
                price = 2000000;
                break;
            case "4":
                duration = "2 năm";
                price = 4200000;
                break;
        }

        // Tạo nội dung chuyển khoản
        String transferNote = "Dang ky goi" + duration + " " + fullName + " " + dbName;

        //Call VietQR API
        // Thông tin cần thiết
        String accountNo = "9529012005";
        String bankId = "970422"; // MB
        String accountName = "NGUYEN DOAN PHUNG PHUONG";
        String template = "print";

        // Gửi POST request đến VietQR API
        URL url = new URL("https://api.vietqr.io/v2/generate");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // Payload JSON
        String jsonInput = String.format(
                "{\"accountNo\":\"%s\",\"accountName\":\"%s\",\"acqId\":\"%s\",\"amount\":%s,\"addInfo\":\"%s\",\"template\":\"%s\"}",
                accountNo, accountName, bankId, price, transferNote, template);

        // Gửi dữ liệu
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInput.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // Đọc phản hồi JSON
        StringBuilder responseStr = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            String line;
            while ((line = br.readLine()) != null) {
                responseStr.append(line.trim());
            }
        }

        // Parse JSON để lấy link ảnh QR
        JSONObject json = new JSONObject(responseStr.toString());
        String qrUrl = json.getJSONObject("data").getString("qrDataURL");

        // Chuyển đến trang thanh toán
        req.setAttribute("qrUrl", qrUrl);
        req.setAttribute("fullName", fullName);
        req.setAttribute("phone", phone);
        req.setAttribute("email", email);
        req.setAttribute("address", address);
        req.setAttribute("plan", duration);
        req.setAttribute("planId", planId);
        req.setAttribute("amount", price);
        req.setAttribute("transferNote", transferNote);

        req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/payment-subs.jsp").forward(req, resp);
    }

}
