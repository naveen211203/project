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

import com.VHealthAssure.Dao.AdminPoliciesDao;

@WebServlet("/AdminPolicies")
public class AdminPoliciesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminPoliciesDao policiesDao;

    @Override
    public void init() throws ServletException {
        policiesDao = new AdminPoliciesDao();
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

        // Get search and status filter values
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        if (search == null) {
            search = "";
        }

        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        // Get all policies with search and filter
        List<Map<String, Object>> policies =
                policiesDao.getAllPolicies(search, status);

        // Get policy statistics
        Map<String, Integer> statistics =
                policiesDao.getPolicyStatistics();

        // Get admin name from session
        String adminName =
                (String) session.getAttribute("userName");

        if (adminName == null || adminName.trim().isEmpty()) {
            adminName = "Administrator";
        }

        // Send data to JSP
        request.setAttribute("policies", policies);
        request.setAttribute("statistics", statistics);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("adminName", adminName);

        // Forward to Admin Policies page
        request.getRequestDispatcher(
                "/WEB-INF/admin/AdminPolicies.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        doGet(request, response);
    }
}