package com.VHealthAssure.Controller;

import java.io.IOException;

import com.VHealthAssure.Dao.UserDashboardDao;
import com.VHealthAssure.Entity.RegistrationEntity;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MyProfile")
public class MyProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDashboardDao dao = new UserDashboardDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loginId") == null) {
            resp.sendRedirect("login.html");
            return;
        }

        String userId = (String) session.getAttribute("loginId");

        try {
            RegistrationEntity user = dao.getUserById(userId);
            req.setAttribute("user", user);
            req.getRequestDispatcher("MyProfile.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loginId") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String userId = (String) session.getAttribute("loginId");

        String section = request.getParameter("section"); // PERSONAL / CONTACT / NOMINEE / EMPLOYMENT

        try {
            RegistrationEntity user = new RegistrationEntity();
            user.setUserId(userId);

            if ("PERSONAL".equals(section)) {
                user.setFullName(request.getParameter("FullName"));
                user.setDateOfBirth(request.getParameter("DateOfBirth"));
                user.setGender(request.getParameter("Gender"));
                user.setCity(request.getParameter("City"));
            }

            else if ("CONTACT".equals(section)) {
                user.setEmail(request.getParameter("Email"));
                user.setMobile(request.getParameter("Mobile"));
                user.setPostalCode(request.getParameter("PostalCode"));
            }

            else if ("NOMINEE".equals(section)) {
                user.setNomineeName(request.getParameter("NomineeName"));
                user.setNomineeRelation(request.getParameter("NomineeRelation"));
                user.setNomineeDob(request.getParameter("NomineeDob"));
                user.setNomineeShare(
                    Double.parseDouble(request.getParameter("NomineeShare"))
                );
            }

            else if ("EMPLOYMENT".equals(section)) {
                user.setEmploymentStatus(request.getParameter("EmploymentStatus"));
                user.setAnnualIncome(
                    Double.parseDouble(request.getParameter("AnnualIncome"))
                );
                user.setOccupation(request.getParameter("Occupation"));
                user.setCompany(request.getParameter("Company"));
            }

            // 🔥 SINGLE DAO METHOD
            dao.updateUserDetails(user, section);

            // Reload fresh data
            RegistrationEntity updatedUser = dao.getUserById(userId);
            request.setAttribute("user", updatedUser);

            request.setAttribute("success", "Profile updated successfully");
            request.getRequestDispatcher("MyProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update profile");
            request.getRequestDispatcher("MyProfile.jsp").forward(request, response);
        }
    }


}
