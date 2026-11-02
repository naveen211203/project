package com.VHealthAssure.Controller;

import java.io.IOException;
import java.util.List;

import com.VHealthAssure.Dao.HospitalDao;
import com.VHealthAssure.Entity.HospitalEntity;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CashlessHospitals")
public class CashlessHospitalsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private HospitalDao hospitalDao;

    @Override
    public void init() throws ServletException {
        hospitalDao = new HospitalDao();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loginId") == null) {
            response.sendRedirect("login.html");
            return;
        }

        List<HospitalEntity> hospitals =
                hospitalDao.getActiveHospitals();

        request.setAttribute("hospitals", hospitals);

        request.getRequestDispatcher("/CashlessHospitals.jsp")
               .forward(request, response);
    }
}
