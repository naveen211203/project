package com.VHealthAssure.Controller;

import java.io.IOException;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.VHealthAssure.Dao.RegistrationDao;
import com.VHealthAssure.Entity.RegistrationEntity;

@WebServlet(name = "RegistrationServlet", urlPatterns = {"/RegistrationServlet"})
public class RegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String nowIso() {
        return DateTimeFormatter.ISO_INSTANT.withZone(ZoneOffset.UTC).format(Instant.now());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "register";

        if ("register".equalsIgnoreCase(action) || "insert".equalsIgnoreCase(action)) {
            RegistrationEntity user = new RegistrationEntity();

            String userId = request.getParameter("UserId");
            if (userId == null || userId.trim().isEmpty()) userId = UUID.randomUUID().toString();
            user.setUserId(userId);

            user.setFullName(request.getParameter("FullName"));
            user.setEmail(request.getParameter("Email"));
            user.setMobile(request.getParameter("Mobile"));

            // NOTE: Hashing password is recommended. For simplicity storing raw (don't do this in production)
            user.setPassword(request.getParameter("Password"));

            user.setDateOfBirth(request.getParameter("DateOfBirth"));
            user.setGender(request.getParameter("Gender"));

            user.setGovIdType(request.getParameter("GovIdType"));
            user.setGovIdNumber(request.getParameter("GovIdNumber"));

            user.setAddressLine1(request.getParameter("AddressLine1"));
            user.setAddressLine2(request.getParameter("AddressLine2"));
            user.setCity(request.getParameter("City"));
            user.setState(request.getParameter("State"));
            user.setPostalCode(request.getParameter("PostalCode"));
            user.setCountry(request.getParameter("Country"));

            user.setNomineeName(request.getParameter("NomineeName"));
            user.setNomineeRelation(request.getParameter("NomineeRelation"));
            user.setNomineeDob(request.getParameter("NomineeDob"));
            String nomineeShareStr = request.getParameter("NomineeShare");
            try {
                user.setNomineeShare(nomineeShareStr != null && !nomineeShareStr.isEmpty() ? Double.parseDouble(nomineeShareStr) : 100.0);
            } catch (NumberFormatException e) {
                user.setNomineeShare(100.0);
            }

            user.setEmploymentStatus(request.getParameter("EmploymentStatus"));
            String incomeStr = request.getParameter("AnnualIncome");
            try {
                user.setAnnualIncome(incomeStr != null && !incomeStr.isEmpty() ? Double.parseDouble(incomeStr) : 0.0);
            } catch (NumberFormatException e) {
                user.setAnnualIncome(0.0);
            }

            user.setEmailVerified("true".equalsIgnoreCase(request.getParameter("EmailVerified")));
            user.setMobileVerified("true".equalsIgnoreCase(request.getParameter("MobileVerified")));

            user.setKycStatus(request.getParameter("KycStatus"));
            user.setRole(request.getParameter("Role"));
            user.setStatus(request.getParameter("Status"));

            String now = nowIso();
            user.setCreatedAt(now);
            user.setUpdatedAt(now);

            RegistrationDao dao = new RegistrationDao();
            boolean inserted = dao.registerUser(user);

            if (inserted) {
                response.sendRedirect(request.getContextPath() + "/RegistrationSuccess.html");
            } else {
                response.setContentType("text/plain");
                response.getWriter().println("Registration failed. Check server logs / DB.");
            }
        } else {
            response.setContentType("text/plain");
            response.getWriter().println("Unsupported action: " + action);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.getWriter().println("Use POST to submit the registration form.");
    }
}