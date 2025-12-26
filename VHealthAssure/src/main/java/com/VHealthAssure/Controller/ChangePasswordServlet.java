package com.VHealthAssure.Controller;

import com.VHealthAssure.Dao.UserDashboardDao;
import com.VHealthAssure.Entity.RegistrationEntity;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDashboardDao userDao = new UserDashboardDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loginId") == null) {
            resp.sendRedirect("login.html");
            return;
        }

        String userId = (String) session.getAttribute("loginId");

        RegistrationEntity user =
            (RegistrationEntity) session.getAttribute("user");

        req.setAttribute("user", user);

        String currentPwd = req.getParameter("currentPassword");
        String newPwd     = req.getParameter("newPassword");
        String confirmPwd = req.getParameter("confirmPassword");

        if (currentPwd == null || newPwd == null || confirmPwd == null ||
            currentPwd.isEmpty() || newPwd.isEmpty() || confirmPwd.isEmpty()) {

            req.setAttribute("error", "All fields are required");
            req.getRequestDispatcher("ChangePassword.jsp").forward(req, resp);
            return;
        }

        if (!newPwd.equals(confirmPwd)) {
            req.setAttribute("error", "New passwords do not match");
            req.getRequestDispatcher("ChangePassword.jsp").forward(req, resp);
            return;
        }

        if (!userDao.verifyCurrentPassword(userId, currentPwd)) {
            req.setAttribute("error", "Current password is incorrect");
            req.getRequestDispatcher("ChangePassword.jsp").forward(req, resp);
            return;
        }


        boolean updated = userDao.updatePassword(userId, newPwd);

        if (updated) {
            req.setAttribute("success", "Password updated successfully");
        } else {
            req.setAttribute("error", "Failed to update password");
        }

        req.getRequestDispatcher("ChangePassword.jsp").forward(req, resp);
    }
}
