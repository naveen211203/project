package com.VHealthAssure.Controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.VHealthAssure.Dao.SupportDao;
import com.VHealthAssure.Entity.SupportEntity;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminSupport")
public class AdminSupportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private SupportDao supportDao;

    @Override
    public void init() {
        supportDao = new SupportDao();
    }

    // Check administrator authentication
    private boolean isAdmin(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loginId") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                request.getContextPath() + "/login.html"
            );

            return false;
        }

        return true;
    }

    // Display support tickets
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        response.setHeader(
            "Cache-Control",
            "no-cache, no-store, must-revalidate"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        if (search == null) {
            search = "";
        }

        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        // Validate ticket status filter
        if (!"ALL".equals(status) &&
            !"OPEN".equals(status) &&
            !"IN_PROGRESS".equals(status) &&
            !"RESOLVED".equals(status) &&
            !"CLOSED".equals(status)) {

            status = "ALL";
        }

        List<SupportEntity> tickets =
            supportDao.getAllTickets(search, status);

        Map<String, Integer> statistics =
            supportDao.getTicketStatistics();

        HttpSession session = request.getSession(false);

        String adminName =
            (String) session.getAttribute("userName");

        if (adminName == null || adminName.trim().isEmpty()) {
            adminName = "Administrator";
        }

        request.setAttribute("tickets", tickets);
        request.setAttribute("statistics", statistics);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("adminName", adminName);

        request.getRequestDispatcher(
            "/WEB-INF/admin/AdminSupport.jsp"
        ).forward(request, response);
    }

    // Save admin response and update ticket status
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String contextPath = request.getContextPath();

        String ticketIdValue =
            request.getParameter("ticketId");

        String adminResponse =
            request.getParameter("adminResponse");

        String status =
            request.getParameter("status");

        int ticketId;

        try {
            ticketId = Integer.parseInt(ticketIdValue);
        } catch (NumberFormatException e) {

            response.sendRedirect(
                contextPath + "/AdminSupport?message=invalidId"
            );

            return;
        }

        if (ticketId <= 0 ||
            adminResponse == null ||
            status == null) {

            response.sendRedirect(
                contextPath + "/AdminSupport?message=invalidData"
            );

            return;
        }

        adminResponse = adminResponse.trim();
        status = status.trim();

        // Validate allowed statuses
        boolean validStatus =
            "OPEN".equals(status) ||
            "IN_PROGRESS".equals(status) ||
            "RESOLVED".equals(status) ||
            "CLOSED".equals(status);

        if (!validStatus) {

            response.sendRedirect(
                contextPath + "/AdminSupport?message=invalidStatus"
            );

            return;
        }

        // Validate response length
        if (adminResponse.length() > 5000) {

            response.sendRedirect(
                contextPath + "/AdminSupport?message=responseTooLong"
            );

            return;
        }

        // Verify that the ticket exists
        SupportEntity existingTicket =
            supportDao.getTicketById(ticketId);

        if (existingTicket == null) {

            response.sendRedirect(
                contextPath + "/AdminSupport?message=ticketNotFound"
            );

            return;
        }

        boolean updated =
            supportDao.updateTicket(
                ticketId,
                adminResponse,
                status
            );

        response.sendRedirect(
            contextPath + "/AdminSupport?message=" +
            (updated ? "updated" : "notUpdated")
        );
    }
}