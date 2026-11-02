
package com.VHealthAssure.Controller;

import java.io.IOException;

import com.VHealthAssure.Dao.SupportDao;
import com.VHealthAssure.Entity.SupportEntity;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Support")
public class SupportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private SupportDao supportDao = new SupportDao();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loginId") == null) {
            response.sendRedirect("login.html");
            return;
        }

        request.getRequestDispatcher("/Support.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loginId") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String userId = String.valueOf(session.getAttribute("loginId"));

        String category = request.getParameter("category");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (category == null || subject == null || message == null) {
            response.sendRedirect("Support?error=invalid");
            return;
        }

        category = category.trim();
        subject = subject.trim();
        message = message.trim();

        boolean validCategory =
                category.equals("Policy Related") ||
                category.equals("Claim Related") ||
                category.equals("Payment Related") ||
                category.equals("KYC Related") ||
                category.equals("Technical Issue") ||
                category.equals("Other");

        if (!validCategory ||
            subject.isEmpty() || subject.length() > 200 ||
            message.isEmpty() || message.length() > 5000) {

            response.sendRedirect("Support?error=invalid");
            return;
        }

        SupportEntity ticket = new SupportEntity();

        ticket.setUserId(userId);
        ticket.setCategory(category);
        ticket.setSubject(subject);
        ticket.setMessage(message);

        boolean created = supportDao.createTicket(ticket);

        if (created) {
            response.sendRedirect("MySupportTickets?submitted=1");
        } else {
            response.sendRedirect("Support?error=failed");
        }
    }
}
