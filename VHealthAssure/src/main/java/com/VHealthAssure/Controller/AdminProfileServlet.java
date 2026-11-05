package com.VHealthAssure.Controller;

import java.io.IOException;
import java.util.Map;

import com.VHealthAssure.Dao.AdminProfileDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminProfile")
public class AdminProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AdminProfileDao adminProfileDao = new AdminProfileDao();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Verify admin login
        if (session == null ||
            session.getAttribute("loginId") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                request.getContextPath() + "/login.html"
            );
            return;
        }

        // Prevent cached admin profile after logout
        response.setHeader(
            "Cache-Control",
            "no-cache, no-store, must-revalidate"
        );
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {

            // Retrieve AdminId from session
            String adminIdValue =
                session.getAttribute("loginId").toString();

            long adminId = Long.parseLong(adminIdValue);

            // Fetch admin profile
            Map<String, Object> admin =
                adminProfileDao.getAdminProfile(adminId);

            if (admin == null) {
                request.setAttribute(
                    "errorMessage",
                    "Unable to retrieve your admin profile."
                );
            }

            request.setAttribute("admin", admin);

            request.setAttribute(
                "adminName",
                session.getAttribute("userName")
            );

            // Forward to Admin Profile JSP
            request.getRequestDispatcher(
                "/WEB-INF/admin/AdminProfile.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath() + "/login.html"
            );

        } catch (Exception e) {

            throw new ServletException(
                "Error loading admin profile.", e
            );
        }
    }
}