package com.VHealthAssure.Controller;

import java.io.IOException;

import com.VHealthAssure.Dao.AdminChangePasswordDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminChangePassword")
public class AdminChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AdminChangePasswordDao passwordDao =
            new AdminChangePasswordDao();

    private boolean isAdminLoggedIn(HttpSession session) {
        return session != null
                && session.getAttribute("loginId") != null
                && "ADMIN".equals(session.getAttribute("role"));
    }

    private void setNoCacheHeaders(HttpServletResponse response) {
        response.setHeader(
                "Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.html");
            return;
        }

        setNoCacheHeaders(response);

        request.setAttribute(
                "adminName", session.getAttribute("userName"));

        request.getRequestDispatcher(
                "/WEB-INF/admin/AdminChangePassword.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.html");
            return;
        }

        setNoCacheHeaders(response);

        String contextPath = request.getContextPath();

        try {

            long adminId = Long.parseLong(
                    session.getAttribute("loginId").toString());

            String currentPassword =
                    request.getParameter("currentPassword");

            String newPassword =
                    request.getParameter("newPassword");

            String confirmPassword =
                    request.getParameter("confirmPassword");

            // Check required fields
            if (currentPassword == null || currentPassword.isEmpty()
                    || newPassword == null || newPassword.isEmpty()
                    || confirmPassword == null
                    || confirmPassword.isEmpty()) {

                response.sendRedirect(
                        contextPath
                        + "/AdminChangePassword?message=required");
                return;
            }

            // Check minimum password length
            if (newPassword.length() < 8) {

                response.sendRedirect(
                        contextPath
                        + "/AdminChangePassword?message=weakPassword");
                return;
            }

            // Check whether new password and confirmation match
            if (!newPassword.equals(confirmPassword)) {

                response.sendRedirect(
                        contextPath
                        + "/AdminChangePassword?message=mismatch");
                return;
            }

            // Do not allow the same password
            if (newPassword.equals(currentPassword)) {

                response.sendRedirect(
                        contextPath
                        + "/AdminChangePassword?message=samePassword");
                return;
            }

            // Verify current password
            boolean currentPasswordValid =
                    passwordDao.verifyCurrentPassword(
                            adminId, currentPassword);

            if (!currentPasswordValid) {

                response.sendRedirect(
                        contextPath
                        + "/AdminChangePassword?message=incorrect");
                return;
            }

            // Update new password
            boolean updated =
                    passwordDao.updatePassword(
                            adminId, newPassword);

            if (updated) {

                response.sendRedirect(
                        contextPath
                        + "/AdminChangePassword?message=success");

            } else {

                response.sendRedirect(
                        contextPath
                        + "/AdminChangePassword?message=failed");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    contextPath + "/login.html");

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to change admin password.", e);
        }
    }
}