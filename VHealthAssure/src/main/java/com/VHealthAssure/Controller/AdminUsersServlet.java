
package com.VHealthAssure.Controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.VHealthAssure.Dao.AdminUsersDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminUsers")
public class AdminUsersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =====================================================
    // ADMIN AUTHENTICATION CHECK
    // =====================================================

    private boolean isAdmin(
            HttpServletRequest request,
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


    // =====================================================
    // GET REQUEST
    // CUSTOMER LIST / CUSTOMER DETAILS
    // =====================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        response.setHeader(
            "Cache-Control",
            "no-cache, no-store, must-revalidate"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        AdminUsersDao dao = new AdminUsersDao();

        String action = request.getParameter("action");


        // ---------------------------------------------
        // VIEW COMPLETE CUSTOMER DETAILS
        // ---------------------------------------------

        if ("details".equalsIgnoreCase(action)) {

            String userId = request.getParameter("userId");

            if (userId == null || userId.trim().isEmpty()) {

                response.sendRedirect(
                    request.getContextPath() + "/AdminUsers"
                );

                return;
            }

            Map<String, Object> user =
                dao.getUserDetails(userId);

            if (user == null) {

                response.sendRedirect(
                    request.getContextPath() +
                    "/AdminUsers?message=notfound"
                );

                return;
            }

            HttpSession session = request.getSession(false);

            request.setAttribute("customer", user);

            request.setAttribute(
                "adminName",
                session.getAttribute("userName")
            );

            request.getRequestDispatcher(
                "/WEB-INF/admin/AdminUserDetails.jsp"
            ).forward(request, response);

            return;
        }


        // ---------------------------------------------
        // CUSTOMER LIST / SEARCH / FILTER
        // ---------------------------------------------

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        if (!"ALL".equals(status) &&
            !"ACTIVE".equals(status) &&
            !"INACTIVE".equals(status) &&
            !"SUSPENDED".equals(status)) {

            status = "ALL";
        }

        List<Map<String, Object>> users =
            dao.getUsers(search, status);

        HttpSession session = request.getSession(false);

        request.setAttribute("users", users);
        request.setAttribute(
            "search",
            search == null ? "" : search
        );

        request.setAttribute("selectedStatus", status);

        request.setAttribute(
            "adminName",
            session.getAttribute("userName")
        );

        request.getRequestDispatcher(
            "/WEB-INF/admin/AdminUsers.jsp"
        ).forward(request, response);
    }


    // =====================================================
    // POST REQUEST
    // UPDATE CUSTOMER STATUS
    // =====================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String userId = request.getParameter("userId");
        String newStatus = request.getParameter("newStatus");

        AdminUsersDao dao = new AdminUsersDao();

        boolean updated =
            dao.updateUserStatus(userId, newStatus);

        String message = updated ? "updated" : "failed";

        response.sendRedirect(
            request.getContextPath() +
            "/AdminUsers?message=" + message
        );
    }
}
