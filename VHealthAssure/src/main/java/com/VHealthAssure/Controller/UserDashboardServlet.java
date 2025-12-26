package com.VHealthAssure.Controller;

import java.io.IOException;
import java.sql.ResultSet;

import com.VHealthAssure.Dao.UserDashboardDao;
import com.VHealthAssure.Entity.RegistrationEntity;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class UserDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String userId = (String) request.getSession().getAttribute("loginId");

	    if (userId == null) {
	        response.sendRedirect("login.html");
	        return;
	    }

	    try {
	        UserDashboardDao dao = new UserDashboardDao();

	        // KPIs
	        request.setAttribute("activePolicies", dao.getActivePolicies(userId));
	        request.setAttribute("claimsFiled", dao.getClaimsFiled(userId));
	        request.setAttribute("approvedClaims", dao.getApprovedClaims(userId));

	        // user
	        RegistrationEntity user = dao.getUserById(userId);
	        request.setAttribute("user", user);

	        // policy + claims
	        request.setAttribute("activePolicyRS", dao.getActivePolicy(userId));
	        request.setAttribute("recentClaimsRS", dao.getRecentClaims(userId));

	        // 🔥 NEXT PREMIUM
	        ResultSet premiumRS = dao.getNextPremium(userId);

	        if (premiumRS != null && premiumRS.next()) {
	            request.setAttribute("nextPremiumAmount",
	                    "₹" + premiumRS.getBigDecimal("PremiumAmount"));
	            request.setAttribute("nextPremiumDate",
	                    premiumRS.getDate("NextPremiumDate"));
	        } else {
	            request.setAttribute("nextPremiumAmount", "—");
	            request.setAttribute("nextPremiumDate", null);
	        }


	        request.getRequestDispatcher("UserDashboard.jsp")
	               .forward(request, response);

	    } catch (Exception e) {
	        throw new ServletException(e);
	    }
	}

}
