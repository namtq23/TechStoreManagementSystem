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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Branch;
import model.CashFlowReportDTO;
import model.User;

@WebServlet(name = "SOInvoicesController", urlPatterns = {"/so-invoices"})
public class SOInvoicesController extends HttpServlet {

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

            // Load danh sách chi nhánh
            List<Branch> branchList = branchDAO.getAllBranches(dbName);
            List<User> employeeList = new ArrayList<>();
            
            // Sửa lại: Sử dụng hàm có sẵn trong UserDAO
            if (branchId != null && !branchId.isEmpty() && !branchId.equals("")) {
                employeeList = userDAO.getStaffsByBranchID(Integer.parseInt(branchId), dbName);
            }
            request.setAttribute("branchList", branchList);
            
            
            //Debug
            for (User user : employeeList) {
                System.out.println(user.toString());
            }

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

            // Lấy dữ liệu với filter
            List<CashFlowReportDTO> incomeList = dao.getIncomeCashFlowReports(dbName, offset, recordsPerPage,
                    dateFrom, dateTo, branchId, employeeId);

            // Lấy tổng số bản ghi
            int totalRecords = dao.getTotalIncomeCashFlowCount(dbName, dateFrom, dateTo, branchId, employeeId);

            // Tính toán phân trang
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            int startRecord = offset + 1;
            int endRecord = Math.min(offset + recordsPerPage, totalRecords);

            // Set attributes
            request.setAttribute("incomeList", incomeList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);

            // Set filter parameters
            request.setAttribute("employeeList", employeeList);
            request.setAttribute("branchId", branchId);
            request.setAttribute("employeeId", employeeId);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi truy vấn dữ liệu: " + e.getMessage());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Tham số không hợp lệ: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/invoices.jsp").forward(request, response);
    }

    // THÊM CÁC PHƯƠNG THỨC NÀY ĐỂ SỬA LỖI
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
        return "SO Invoices Controller";
    }
}
