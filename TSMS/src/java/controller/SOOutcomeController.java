package controller;

import dao.BranchDAO;
import dao.CashFlowDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Branch;
import model.CashFlowReportDTO;
import model.User;
import util.Validate;

@WebServlet(name = "SOOutcomeController", urlPatterns = {"/so-outcome"})
public class SOOutcomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String dbName = (String) request.getSession().getAttribute("dbName");

        CashFlowDAO dao = new CashFlowDAO();
        BranchDAO branchDAO = new BranchDAO();
        UserDAO userDAO = new UserDAO();

        try {
            // Lấy tham số
            String branchId = request.getParameter("branchId");
            String employeeId = request.getParameter("employeeId");
            String paymentMethod = request.getParameter("paymentMethod");

            // Load danh sách chi nhánh
            List<Branch> branchList = branchDAO.getAllBranches(dbName);
            List<User> employeeList = new ArrayList<>();
            List<String> paymentMethodList = dao.getAllPaymentMethods(dbName);

            if (branchId != null && !branchId.isEmpty() && !branchId.equals("")) {
                employeeList = userDAO.getStaffsByBranchIDForOutcome(Integer.parseInt(branchId), dbName);
            }
            request.setAttribute("branchList", branchList);

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

            // Lấy dữ liệu outcome
            List<CashFlowReportDTO> outcomeList = dao.getOutcomeCashFlowReports(dbName, offset, recordsPerPage,
                    dateFrom, dateTo, branchId, employeeId, paymentMethod);

            // Lấy tổng số bản ghi
            int totalRecords = dao.getTotalOutcomeCashFlowCount(dbName, dateFrom, dateTo, branchId, employeeId, paymentMethod);

            // Tạo danh sách recordsPerPage theo phần trăm
            List<Integer> recordsPerPageOptions = new ArrayList<>();
            if (totalRecords > 0) {
                recordsPerPageOptions.add(Math.max(1, totalRecords * 10 / 100));
                recordsPerPageOptions.add(Math.max(1, totalRecords * 25 / 100));
                recordsPerPageOptions.add(Math.max(1, totalRecords * 50 / 100));
                recordsPerPageOptions.add(Math.max(1, totalRecords * 75 / 100));
            } else {
                recordsPerPageOptions.add(10); // fallback khi chưa có bản ghi
            }

            // Lấy tổng amount của tất cả các trang    
            String totalOutcomeAmount = String.valueOf(dao.getTotalOutcomeAmount(dbName, dateFrom, dateTo, branchId, employeeId, paymentMethod));

            // Tính toán phân trang
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            int startRecord = offset + 1;
            int endRecord = Math.min(offset + recordsPerPage, totalRecords);

            System.out.println("Outcome Controller - Nhan vien theo chi nhanh");
            for (User user : employeeList) {
                System.out.println(user.toString());
            }

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
            request.setAttribute("branchId", branchId);
            request.setAttribute("employeeId", employeeId);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);
            request.setAttribute("paymentMethodList", paymentMethodList);
            request.setAttribute("paymentMethod", paymentMethod);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi truy vấn dữ liệu: " + e.getMessage());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Tham số không hợp lệ: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/outcome-report.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            response.sendRedirect(request.getContextPath() + "/subscription?status=expired");
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
        return "SO Outcome Controller";
    }
}
