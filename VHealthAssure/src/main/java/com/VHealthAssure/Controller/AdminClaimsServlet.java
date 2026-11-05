
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

import com.VHealthAssure.Dao.AdminClaimsDao;

@WebServlet("/AdminClaims")
public class AdminClaimsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminClaimsDao claimsDao;

    @Override
    public void init() throws ServletException {
        claimsDao = new AdminClaimsDao();
    }

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

        // Retrieve claims
        List<Map<String, Object>> claims =
                claimsDao.getAllClaims(search, status);

        // Retrieve claim statistics
        Map<String, Integer> statistics =
                claimsDao.getClaimStatistics();

        // Get admin name
        String adminName =
                (String) session.getAttribute("userName");

        if (adminName == null || adminName.trim().isEmpty()) {
            adminName = "Administrator";
        }

        // Pass data to JSP
        request.setAttribute("claims", claims);
        request.setAttribute("statistics", statistics);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("adminName", adminName);

        // Forward to Admin Claims page
        request.getRequestDispatcher(
                "/WEB-INF/admin/AdminClaims.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        response.setHeader("Cache-Control",
                "no-cache, no-store, must-revalidate");

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loginId") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.html");
            return;
        }

        // Read claim ID and requested status
        String claimIdValue = request.getParameter("claimId");
        String status = request.getParameter("status");

        String message;

        try {
            long claimId = Long.parseLong(claimIdValue);

            if (!"APPROVED".equals(status) &&
                !"REJECTED".equals(status)) {

                message = "invalidStatus";

            } else {
                boolean updated =
                        claimsDao.updateClaimStatus(claimId, status);

                message = updated ? "updated" : "notUpdated";
            }

        } catch (NumberFormatException e) {
            message = "invalidClaim";

        }

        response.sendRedirect(
                request.getContextPath()
                + "/AdminClaims?message=" + message);
    }
}
