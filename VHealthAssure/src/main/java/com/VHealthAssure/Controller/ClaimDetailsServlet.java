package com.VHealthAssure.Controller;


import java.io.IOException;
import com.VHealthAssure.Dao.ClaimsDao;
import com.VHealthAssure.Entity.ClaimEntity;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/ClaimDetails")
public class ClaimDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userId = session == null ? null :
                (String) session.getAttribute("loginId");

        if (userId == null) {
            response.sendRedirect("login.html");
            return;
        }

        try {
            long id = Long.parseLong(request.getParameter("id"));
            ClaimEntity claim = new ClaimsDao().getClaimById(id, userId);

            if (claim == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                                   "Claim not found");
                return;
            }

            request.setAttribute("claim", claim);
            request.getRequestDispatcher("/ClaimDetails.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                               "Invalid claim ID");
        } catch (Exception e) {
            throw new ServletException("Unable to retrieve claim", e);
        }
    }
}
