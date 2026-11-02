package com.VHealthAssure.Controller;


import java.io.IOException;
import java.util.List;

import com.VHealthAssure.Dao.MyPoliciesDao;
import com.VHealthAssure.Entity.PolicyEntity;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MyPolicies")
public class MyPoliciesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        String userId = session == null
                ? null
                : (String) session.getAttribute("loginId");

        if (userId == null) {
            response.sendRedirect("login.html");
            return;
        }

        try {
            MyPoliciesDao dao = new MyPoliciesDao();

            List<PolicyEntity> policies =
                    dao.getPoliciesByUserId(userId);

            request.setAttribute("policies", policies);

            request.getRequestDispatcher("/MyPolicies.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load user policies.", e);
        }
    }
}