package controller;

// Servlet imports
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Java core imports
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

// DAO và Model imports
import dao.CashFlowDAO;
import dao.BranchDAO;
import dao.UserDAO;
import model.CashFlowReportDTO;
import model.Branch;
import model.User;

// Apache POI imports cho Excel
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "ExportExcelController", urlPatterns = {"/export-excel"})
public class SOExportExcelController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dbName = (String) request.getSession().getAttribute("dbName");
        String exportType = request.getParameter("type");

        // Lấy các filter parameters từ request
        String branchId = request.getParameter("branchId");
        String employeeId = request.getParameter("employeeId");
        String dateFrom = request.getParameter("fromDate");
        String dateTo = request.getParameter("toDate");
        String paymentMethodInpara = request.getParameter("paymentMethod");


        try {
            CashFlowDAO dao = new CashFlowDAO();

            // Lấy dữ liệu từ database với filter
            List<CashFlowReportDTO> dataList;
            if ("income".equals(exportType)) {
                dataList = dao.getIncomeCashFlowReports(dbName, 0, Integer.MAX_VALUE,
                        dateFrom, dateTo, branchId, employeeId, paymentMethodInpara);
            } else {
                dataList = dao.getOutcomeCashFlowReports(dbName, 0, Integer.MAX_VALUE,
                        dateFrom, dateTo, branchId, employeeId, paymentMethodInpara);
            }

            // Tạo file Excel
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet;
            String filename;

            // Tạo sheet và filename dựa trên type
            if ("income".equals(exportType)) {
                sheet = workbook.createSheet("Income Report");
                filename = "income-report.xlsx";
            } else {
                sheet = workbook.createSheet("Outcome Report");
                filename = "outcome-report.xlsx";
            }

            // Tạo header row dựa trên type
            Row headerRow = sheet.createRow(0);
            if ("income".equals(exportType)) {
                // Header cho Income
                headerRow.createCell(0).setCellValue("STT");
                headerRow.createCell(1).setCellValue("Mã đơn hàng");
                headerRow.createCell(2).setCellValue("Tên khách hàng");
                headerRow.createCell(3).setCellValue("Phương thức TT");
                headerRow.createCell(4).setCellValue("Ngày tạo");
                headerRow.createCell(5).setCellValue("Người tạo");
                headerRow.createCell(6).setCellValue("Số tiền");
            } else {
                // Header cho Outcome
                headerRow.createCell(0).setCellValue("STT");
                headerRow.createCell(1).setCellValue("Mã giao dịch");
                headerRow.createCell(2).setCellValue("Danh mục");
                headerRow.createCell(3).setCellValue("Phương thức TT");
                headerRow.createCell(4).setCellValue("Ngày tạo");
                headerRow.createCell(5).setCellValue("Chi nhánh");
                headerRow.createCell(6).setCellValue("Người tạo");
                headerRow.createCell(7).setCellValue("Số tiền");
            }

            // Thêm dữ liệu vào Excel
            int rowNum = 1;
            for (CashFlowReportDTO item : dataList) {
                Row row = sheet.createRow(rowNum++);

                if ("income".equals(exportType)) {
                    // Dữ liệu cho Income
                    row.createCell(0).setCellValue(rowNum - 1);

                    String orderID = String.valueOf(item.getRelatedOrderID());

                    row.createCell(1).setCellValue(orderID);

                    String customerName = item.getCustomerName();
                    if (customerName == null) {
                        customerName = "";
                    }
                    row.createCell(2).setCellValue(customerName);

                    String paymentMethod = item.getPaymentMethod();
                    if (paymentMethod == null) {
                        paymentMethod = "";
                    }
                    row.createCell(3).setCellValue(paymentMethod);

                    String date = item.getFormattedDate();
                    if (date == null) {
                        date = "";
                    }
                    row.createCell(4).setCellValue(date);

                    String createdBy = item.getCreatedByName();
                    if (createdBy == null) {
                        createdBy = "";
                    }
                    row.createCell(5).setCellValue(createdBy);

                    String amount = item.getFormattedAmountVND();
                    if (amount == null) {
                        amount = "0";
                    }
                    row.createCell(6).setCellValue(amount);

                } else {
                    // Dữ liệu cho Outcome
                    row.createCell(0).setCellValue(rowNum - 1);

                    String cashFlowID = "";
                    if (item.getCashFlowID() > 0) {
                        cashFlowID = String.valueOf(item.getCashFlowID());
                    }
                    row.createCell(1).setCellValue(cashFlowID);

                    String category = item.getCategory();
                    if (category == null) {
                        category = "";
                    }
                    row.createCell(2).setCellValue(category);

                    String paymentMethod = item.getPaymentMethod();
                    if (paymentMethod == null) {
                        paymentMethod = "";
                    }
                    row.createCell(3).setCellValue(paymentMethod);

                    String createdAt = item.getFormattedCreatedAt();
                    if (createdAt == null) {
                        createdAt = "";
                    }
                    row.createCell(4).setCellValue(createdAt);

                    String branchName = item.getBranchName();
                    if (branchName == null) {
                        branchName = "";
                    }
                    row.createCell(5).setCellValue(branchName);

                    String createdBy = item.getCreatedByName();
                    if (createdBy == null) {
                        createdBy = "";
                    }
                    row.createCell(6).setCellValue(createdBy);

                    String amount = item.getFormattedAmount();
                    if (amount == null) {
                        amount = "0";
                    }
                    row.createCell(7).setCellValue(amount);
                }
            }

            // Auto-size columns
            int columnCount = "income".equals(exportType) ? 7 : 8;
            for (int i = 0; i < columnCount; i++) {
                sheet.autoSizeColumn(i);
            }

            // Chuẩn bị response để download
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            // Ghi file Excel vào response
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            workbook.close();

            response.getOutputStream().write(outputStream.toByteArray());
            response.getOutputStream().flush();

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xuất Excel");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Export Excel Controller";
    }
}
