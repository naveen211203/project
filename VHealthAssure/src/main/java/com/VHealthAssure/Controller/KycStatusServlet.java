package com.VHealthAssure.Controller;

import java.io.IOException;
import java.sql.ResultSet;

import com.VHealthAssure.Dao.KycDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Kyc")
public class KycStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final KycDao kycDao = new KycDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginId") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String userId = (String) session.getAttribute("loginId");

        try {
            request.setAttribute("kycStatus", kycDao.getUserKycStatus(userId));
            request.setAttribute("attempts", kycDao.getKycAttemptCount(userId));
            request.setAttribute("fullName", kycDao.getUserName(userId));

            ResultSet gov = kycDao.getUserGovIdDetails(userId);
            if (gov.next()) {
                request.setAttribute("govIdType", gov.getString("GovIdType"));
                request.setAttribute("govIdNumber", gov.getString("GovIdNumber"));
            }

            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
