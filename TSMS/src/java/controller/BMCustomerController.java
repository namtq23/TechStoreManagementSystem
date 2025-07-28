package controller;

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
import model.CustomerDTO;

@WebServlet(name = "BMCustomerController", urlPatterns = {"/bm-customer"})
public class BMCustomerController extends HttpServlet {

   @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
            resp.sendRedirect(req.getContextPath() + "/subscription");
            return;
        }

        // Lấy thông báo từ session nếu có
        if (session != null) {
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
                req.setAttribute("successMessage", successMsg);
                session.removeAttribute("successMessage");
            }

            String errorMsg = (String) session.getAttribute("errorMessage");
            if (errorMsg != null) {
                req.setAttribute("errorMessage", errorMsg);
                session.removeAttribute("errorMessage");
            }
        }

        if (session == null || session.getAttribute("userId") == null
                || session.getAttribute("roleId") == null || session.getAttribute("dbName") == null) {
            resp.sendRedirect("login");
            return;
        }

        int roleId = Integer.parseInt(session.getAttribute("roleId").toString());
        if (roleId != 1) {
            resp.sendRedirect("login");
            return;
        }

        String dbName = session.getAttribute("dbName").toString();
        String keyword = req.getParameter("keyword");
        String genderFilter = req.getParameter("gender");
        String showTop = req.getParameter("showTop");

        String minStr = req.getParameter("minGrandTotal");
        String maxStr = req.getParameter("maxGrandTotal");
        Double minGrandTotal = parseDoubleOrNull(minStr);
        Double maxGrandTotal = parseDoubleOrNull(maxStr);

        int page = parseIntOrDefault(req.getParameter("page"), 1);
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        // ✅ Parse branchID an toàn
        int branchID = (session.getAttribute("branchID") != null)
    ? Integer.parseInt(session.getAttribute("branchID").toString())
    : 0;


        // Thông báo từ session
        if (session != null) {
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
                req.setAttribute("successMessage", successMsg);
                session.removeAttribute("successMessage");
            }

            String errorMsg = (String) session.getAttribute("errorMessage");
            if (errorMsg != null) {
                req.setAttribute("errorMessage", errorMsg);
                session.removeAttribute("errorMessage");
            }
        }

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            List<CustomerDTO> customers;
            int totalCustomers;
            int totalPages;

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            boolean hasTop = "true".equalsIgnoreCase(showTop);

            if (hasTop) {
                double min = (minGrandTotal != null) ? minGrandTotal : 0.0;
                double max = (maxGrandTotal != null) ? maxGrandTotal : Double.MAX_VALUE;

                customers = customerDAO.getTopCustomersBySpending(min, max, dbName);

                // ✅ Lọc theo branchID
                if (branchID > 0 && customers != null) {
                    customers.removeIf(c -> c.getBranchID() != branchID);
                }

                // ✅ Lọc keyword
                if (hasKeyword) {
                    String lowerKeyword = keyword.toLowerCase();
                    customers.removeIf(c -> !c.getFullName().toLowerCase().contains(lowerKeyword));
                }

                // ✅ Lọc giới tính
                if ("male".equalsIgnoreCase(genderFilter)) {
                    customers.removeIf(c -> c.getGender() == null || !c.getGender());
                } else if ("female".equalsIgnoreCase(genderFilter)) {
                    customers.removeIf(c -> c.getGender() == null || c.getGender());
                }

                totalCustomers = customers.size();
                totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
                page = Math.min(page, totalPages == 0 ? 1 : totalPages);
                offset = (page - 1) * pageSize;

                int toIndex = Math.min(offset + pageSize, totalCustomers);
                if (offset > toIndex) {
                    offset = 0;
                }
                customers = customers.subList(offset, toIndex);

            } else if (hasKeyword) {
                customers = customerDAO.filterCustomers(dbName, keyword, genderFilter, branchID);
                totalCustomers = customers.size();
                totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
                page = Math.min(page, totalPages);
                offset = (page - 1) * pageSize;

                int toIndex = Math.min(offset + pageSize, totalCustomers);
                if (offset > toIndex) {
                    offset = 0;
                }
                customers = customers.subList(offset, toIndex);

            } else {
                totalCustomers = customerDAO.countCustomers(dbName, genderFilter, branchID);
                totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
                page = Math.min(page, totalPages == 0 ? 1 : totalPages);
                offset = (page - 1) * pageSize;
                customers = customerDAO.getCustomerListByPage(dbName, offset, pageSize, genderFilter, branchID);
            }

            // ✅ Truyền thông tin về view
            req.setAttribute("customers", customers);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCustomers", totalCustomers);
            req.setAttribute("startCustomer", offset + 1);
            req.setAttribute("endCustomer", offset + customers.size());
            req.setAttribute("genderFilter", genderFilter);
            req.setAttribute("keyword", keyword);
            req.setAttribute("showTop", showTop);
            req.setAttribute("minGrandTotal", minGrandTotal);
            req.setAttribute("maxGrandTotal", maxGrandTotal);
            req.setAttribute("branchID", branchID);
            req.setAttribute("service", "active");

            req.getRequestDispatcher("/WEB-INF/jsp/manager/customer.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi truy xuất dữ liệu khách hàng.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã khách hàng.");
                return;
            }

            HttpSession session = req.getSession(false);
            int customerId = Integer.parseInt(idStr.trim());
            String fullName = getSafeParam(req, "fullName");
            String email = getSafeParam(req, "email");
            String genderStr = getSafeParam(req, "gender");
            String phone = getSafeParam(req, "phoneNumber");
            String address = getSafeParam(req, "address");

            if (fullName == null || email == null || genderStr == null || phone == null || address == null) {
                session.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
                resp.sendRedirect("bm-customer");
                return;
            }

            boolean gender = Boolean.parseBoolean(genderStr.trim());

            if (session == null || session.getAttribute("dbName") == null) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không xác định được cơ sở dữ liệu.");
                return;
            }

            String dbName = session.getAttribute("dbName").toString();
            CustomerDAO dao = new CustomerDAO();

            boolean success = dao.updateCustomer(customerId, fullName, email, gender, phone, address, dbName);

            if (success) {
                session.setAttribute("successMessage", "Cập nhật thông tin khách hàng thành công!");
            } else {
                session.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
            }
            resp.sendRedirect("bm-customer");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra khi xử lý yêu cầu.");
        }
    }

    private String getSafeParam(HttpServletRequest req, String paramName) {
        String value = req.getParameter(paramName);
        return (value != null && !value.trim().isEmpty()) ? value.trim() : null;
    }

    private int parseIntOrDefault(String str, int defaultVal) {
        try {
            int value = Integer.parseInt(str);
            return (value > 0) ? value : defaultVal;
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private Double parseDoubleOrNull(String str) {
        try {
            return (str != null && !str.trim().isEmpty()) ? Double.parseDouble(str) : null;
        } catch (Exception e) {
            return null;
        }
    }
}
