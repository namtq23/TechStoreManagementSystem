package controller;


import dao.BrandDAO;
import dao.CashFlowDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CashFlowReportDTO;
import model.User;
import util.Validate;

@WebServlet(name = "BMOutcomeController", urlPatterns = {"/bm-outcome"})
public class BMOutcomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        String dbName = (String) session.getAttribute("dbName");
        
        // ===== DEBUG SESSION INFO =====
        System.out.println("=== BM OUTCOME SESSION DEBUG ===");
        System.out.println("userId: " + session.getAttribute("userId"));
        System.out.println("roleId: " + session.getAttribute("roleId"));
        System.out.println("branchId: " + session.getAttribute("branchId"));
        System.out.println("dbName: " + dbName);
        
        // Lấy branchId từ session
        Object branchIdObj = session.getAttribute("branchId");
        Integer branchId = null;
        
        if (branchIdObj != null) {
            try {
                branchId = (branchIdObj instanceof Integer) ? (Integer) branchIdObj : Integer.parseInt(branchIdObj.toString());
                System.out.println("✅ BranchID successfully retrieved: " + branchId);
            } catch (NumberFormatException e) {
                System.out.println("❌ Error parsing branchId: " + e.getMessage());
                request.setAttribute("error", "Không thể xác định chi nhánh: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/jsp/manager/outcome-report.jsp").forward(request, response);
                return;
            }
        }

        // ===== XỬ LÝ TRƯỜNG HỢP BRANCHID NULL =====
        if (branchId == null) {
            System.out.println("⚠️ BranchID is null, trying to get from roleId or set default");
            Object roleIdObj = session.getAttribute("roleId");
            if (roleIdObj != null) {
                Integer roleId = (Integer) roleIdObj;
                if (roleId == 1) {
                    branchId = 1;
                    System.out.println("⚠️ Using default branchID for roleId 1: " + branchId);
                }
            }
        }

        if (branchId == null) {
            System.out.println("❌ Cannot determine branchID - redirecting");
            request.setAttribute("error", "Không thể xác định chi nhánh của bạn. Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("/WEB-INF/jsp/manager/outcome-report.jsp").forward(request, response);
            return;
        }

        System.out.println("✅ Proceeding with BranchID: " + branchId + ", dbName: " + dbName);

        CashFlowDAO dao = new CashFlowDAO();
        UserDAO userDAO = new UserDAO();
        BrandDAO brandDAO = new BrandDAO();  // ✅ Thêm BranchDAO

        try {
            // ===== THÊM PHẦN LẤY TÊN CHI NHÁNH =====
            String branchName = null;
            try {
                branchName = brandDAO.getBranchNameById(dbName, (int)branchId);
                if (branchName != null) {
                    request.setAttribute("currentBranchName", branchName);
                    System.out.println("✅ Branch name retrieved: " + branchName);
                } else {
                    request.setAttribute("currentBranchName", "Chi nhánh ID: " + branchId);
                    System.out.println("⚠️ Branch name not found for ID: " + branchId);
                }
            } catch (SQLException e) {
                System.err.println("❌ Error getting branch name: " + e.getMessage());
                request.setAttribute("currentBranchName", "Chi nhánh ID: " + branchId);
            }
            request.setAttribute("currentBranchId", branchId);
            // ===== KẾT THÚC PHẦN LẤY TÊN CHI NHÁNH =====

            // Lấy tham số
            String employeeId = request.getParameter("employeeId");
            String paymentMethod = request.getParameter("paymentMethod");

            // Load danh sách nhân viên của chi nhánh hiện tại
            List<User> employeeList = userDAO.getStaffsByBranchIDForOutcome(branchId, dbName);
            List<String> paymentMethodList = dao.getAllPaymentMethods(dbName);

            // Phân trang
            int currentPage = 1;
            int recordsPerPage = 10;

            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
            }

            String recordsParam = request.getParameter("recordsPerPage");
            if (recordsParam != null && !recordsParam.isEmpty()) {
                recordsPerPage = Integer.parseInt(recordsParam);
            }

            // Lấy các filter parameters
            String dateFrom = request.getParameter("fromDate");
            String dateTo = request.getParameter("toDate");

            // Tính offset
            int offset = (currentPage - 1) * recordsPerPage;

            // Lấy dữ liệu outcome với branchId cố định từ session
            List<CashFlowReportDTO> outcomeList = dao.getOutcomeCashFlowReports(dbName, offset, recordsPerPage,
                    dateFrom, dateTo, String.valueOf(branchId), employeeId, paymentMethod);

            // Lấy tổng số bản ghi
            int totalRecords = dao.getTotalOutcomeCashFlowCount(dbName, dateFrom, dateTo, String.valueOf(branchId), employeeId, paymentMethod);

            // Tạo danh sách recordsPerPage theo phần trăm
            List<Integer> recordsPerPageOptions = new ArrayList<>();
            if (totalRecords > 0) {
                recordsPerPageOptions.add(Math.max(1, totalRecords * 10 / 100));
                recordsPerPageOptions.add(Math.max(1, totalRecords * 25 / 100));
                recordsPerPageOptions.add(Math.max(1, totalRecords * 50 / 100));
                recordsPerPageOptions.add(Math.max(1, totalRecords * 75 / 100));
            } else {
                recordsPerPageOptions.add(10);
            }

            // Lấy tổng amount của tất cả các trang    
            String totalOutcomeAmount = String.valueOf(dao.getTotalOutcomeAmount(dbName, dateFrom, dateTo, String.valueOf(branchId), employeeId, paymentMethod));

            // Tính toán phân trang
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            int startRecord = offset + 1;
            int endRecord = Math.min(offset + recordsPerPage, totalRecords);

            System.out.println("BM Outcome Controller - Chi nhanh: " + branchName + " (ID: " + branchId + ")");
            System.out.println("Nhan vien theo chi nhanh:");
            for (User user : employeeList) {
                System.out.println("- " + user.getFullName() + " (ID: " + user.getUserID() + ")");
            }
            System.out.println("Total outcome records: " + totalRecords);
            System.out.println("Total outcome amount: " + totalOutcomeAmount);

            // Set attributes
            request.setAttribute("outcomeList", outcomeList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);
            request.setAttribute("totalOutcomeAmount", Validate.formatCostPriceToVND(totalOutcomeAmount));
            request.setAttribute("recordsPerPageOptions", recordsPerPageOptions);

            // Set filter parameters
            request.setAttribute("employeeList", employeeList);
            request.setAttribute("employeeId", employeeId);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);
            request.setAttribute("paymentMethodList", paymentMethodList);
            request.setAttribute("paymentMethod", paymentMethod);
            
            System.out.println("✅ All BM outcome data set successfully");

        } catch (SQLException e) {
            System.err.println("❌ SQL Error in BMOutcomeController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi truy vấn dữ liệu: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.err.println("❌ Number Format Error in BMOutcomeController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Tham số không hợp lệ: " + e.getMessage());
        }


        request.getRequestDispatcher("/WEB-INF/jsp/manager/outcome-report.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || (Integer) session.getAttribute("isActive") == 0) {
            response.sendRedirect(request.getContextPath() + "/subscription");
            return;
        }

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Branch Manager Outcome Controller";
    }
}
