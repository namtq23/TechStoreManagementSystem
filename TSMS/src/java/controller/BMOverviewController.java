/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import model.AnnouncementDTO;
import dao.AnnouncementDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.UserDTO;

/**
 *
 * @author admin
 */
@WebServlet(name="BMOverviewController", urlPatterns={"/bm-overview"})
public class BMOverviewController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // Lấy thông tin user từ session
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");
        String dbName = (String) session.getAttribute("dbName");
        
        // Kiểm tra user và branchID
        if (currentUser == null || currentUser.getBranchID() == null) {
            request.setAttribute("error", "Không thể xác định chi nhánh của bạn. Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("/WEB-INF/jsp/manager/overview.jsp").forward(request, response);
            return;
        }
        
        int branchID = currentUser.getBranchID();
        System.out.println(">>> DEBUG BMOverviewController - BranchID = " + branchID);
        System.out.println(">>> DEBUG BMOverviewController - dbName = " + dbName);

        // Lấy thông báo và hoạt động gần đây cho Branch Manager
        AnnouncementDAO announcementDAO = new AnnouncementDAO();
        try {
            List<AnnouncementDTO> recentAnnouncements = announcementDAO.getRecentAnnouncementsForBranchManager(dbName, branchID);
            request.setAttribute("recentAnnouncements", recentAnnouncements);

            List<AnnouncementDTO> activityLogs = announcementDAO.getRecentActivitiesForBranchManager(dbName, branchID);
            request.setAttribute("activityLogs", activityLogs);
            
            System.out.println("🟢 Branch Manager - Loaded " + recentAnnouncements.size() + " announcements and " + activityLogs.size() + " activities for BranchID: " + branchID);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi lấy thông báo: " + e.getMessage());
        }

        // Set thông tin chi nhánh
        request.setAttribute("currentBranchID", branchID);

        // Forward tới JSP
        request.getRequestDispatcher("/WEB-INF/jsp/manager/overview.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Branch Manager Overview Controller";
    }
}