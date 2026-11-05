
package com.VHealthAssure.Controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.VHealthAssure.Dao.AdminKycDao;

@WebServlet("/AdminKyc")
public class AdminKycServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminKycDao kycDao;

    @Override
    public void init() throws ServletException {
        kycDao = new AdminKycDao();
    }

    /*
     * Display KYC management page.
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        // Prevent browser caching
        response.setHeader("Cache-Control",
                "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Check admin session
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loginId") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.html");
            return;
        }

        // Read search and status filter
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        if (search == null) {
            search = "";
        }

        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        // Retrieve KYC submissions
        List<Map<String, Object>> kycList =
                kycDao.getAllKyc(search, status);

        // Retrieve KYC statistics
        Map<String, Integer> statistics =
                kycDao.getKycStatistics();

        // Get admin name
        String adminName =
                (String) session.getAttribute("userName");

        if (adminName == null || adminName.trim().isEmpty()) {
            adminName = "Administrator";
        }

        // Pass data to JSP
        request.setAttribute("kycList", kycList);
        request.setAttribute("statistics", statistics);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("adminName", adminName);

        // Forward to Admin KYC page
        request.getRequestDispatcher(
                "/WEB-INF/admin/AdminKyc.jsp")
                .forward(request, response);
    }


    /*
     * Approve or reject a KYC submission.
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loginId") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.html");
            return;
        }

        // Get admin ID from session
        String adminId =
                (String) session.getAttribute("loginId");

        // Read submitted parameters
        String kycId = request.getParameter("kycId");
        String status = request.getParameter("status");
        String rejectionReason =
                request.getParameter("rejectionReason");

        String message;

        // Validate request
        if (kycId == null || kycId.trim().isEmpty()) {

            message = "invalidKyc";

        } else if (!"VERIFIED".equals(status) &&
                   !"REJECTED".equals(status)) {

            message = "invalidStatus";

        } else if ("REJECTED".equals(status) &&
                   (rejectionReason == null ||
                    rejectionReason.trim().isEmpty())) {

            message = "reasonRequired";

        } else {

            // Update KYC document and customer status
            boolean updated = kycDao.reviewKyc(
                    kycId,
                    status,
                    rejectionReason,
                    adminId
            );

            message = updated ? "updated" : "notUpdated";
        }

        // Redirect after processing
        response.sendRedirect(
                request.getContextPath()
                + "/AdminKyc?message=" + message);
    }

}
