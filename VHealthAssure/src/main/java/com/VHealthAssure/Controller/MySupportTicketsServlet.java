
package com.VHealthAssure.Controller;

import java.io.IOException;
import java.util.List;

import com.VHealthAssure.Dao.SupportDao;
import com.VHealthAssure.Entity.SupportEntity;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MySupportTickets")
public class MySupportTicketsServlet extends HttpServlet {

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

        String userId = String.valueOf(session.getAttribute("loginId"));

        List<SupportEntity> tickets =
                supportDao.getTicketsByUser(userId);

        request.setAttribute("tickets", tickets);

        request.getRequestDispatcher("/MySupportTickets.jsp")
               .forward(request, response);
    }
}
