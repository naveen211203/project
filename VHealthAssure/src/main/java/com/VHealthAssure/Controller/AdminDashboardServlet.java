package com.VHealthAssure.Controller;

import java.io.IOException;
import java.util.Map;

import com.VHealthAssure.Dao.AdminDashboardDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loginId") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                request.getContextPath() + "/login.html"
            );
            return;
        }

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        AdminDashboardDao dao = new AdminDashboardDao();

        Map<String, Long> stats = dao.getDashboardStats();

        request.setAttribute("stats", stats);
        request.setAttribute("adminName", session.getAttribute("userName"));

        request.getRequestDispatcher(
            "/WEB-INF/admin/AdminDashboard.jsp"
        ).forward(request, response);
    }
}