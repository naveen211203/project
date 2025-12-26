package com.VHealthAssure.Controller;

import java.io.IOException;

import com.VHealthAssure.Dao.LoginDao;
import com.VHealthAssure.Entity.LoginEntity;
import com.VHealthAssure.Entity.LoginResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String identifier = req.getParameter("Identifier");
        String password = req.getParameter("Password");
        String role = req.getParameter("Role");

        LoginEntity entity = new LoginEntity();
        entity.setIdentifier(identifier);
        entity.setPassword(password);
        entity.setRole(role);

        try {
            LoginDao dao = new LoginDao();
            LoginResult result = dao.login(entity);

            if (result != null) {
                HttpSession session = req.getSession();
                session.setAttribute("loginId", result.getId());
                session.setAttribute("userName", result.getName());
                session.setAttribute("role", result.getRole());

                if ("ADMIN".equals(result.getRole())) {
                    resp.sendRedirect("AdminDashboard.html");
                } else {
                    resp.sendRedirect("UserDashboardServlet");
                }

            } else {
                resp.sendRedirect("login.html?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("login.html?error=server");
        }
    }
}
