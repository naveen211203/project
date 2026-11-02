package com.VHealthAssure.Controller;

import java.io.*;
import java.math.BigDecimal;
import java.nio.file.*;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.WebServlet;

import com.VHealthAssure.Dao.ClaimsDao;
import com.VHealthAssure.Entity.ClaimEntity;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 60 * 1024 * 1024
)

@WebServlet(urlPatterns = {"/Claims", "/SubmitClaim"})
public class ClaimsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Set<String> FILE_FIELDS = new HashSet<>(
        Arrays.asList(
            "hospitalFinalBill", "detailedBill", "dischargeSummary",
            "medicalReports", "pharmacyBills", "fIRAccidentReport",
            "iDProof", "insuranceCardTPACard",
            "patientGuardianSignature", "hospitalSealandDoctorSignature"
        )
    );

    private String getUserId(HttpServletRequest request) {
        return (String) request.getSession(false).getAttribute("loginId");
    }

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
            List<ClaimEntity> claims =
                new ClaimsDao().getClaimsByUser(userId);

            request.setAttribute("claims", claims);
            request.getRequestDispatcher("/Claims.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load claims", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String userId = session == null ? null :
                (String) session.getAttribute("loginId");

        if (userId == null) {
            response.sendRedirect("login.html");
            return;
        }

        Path uploadDirectory = null;
        List<Path> savedFiles = new ArrayList<>();

        try {
            String[] required = {
                "patientName", "age", "contactNumber", "emailID",
                "insuranceCompanyName", "policyNumber",
                "policyholderName", "hospitalName", "hospitalAddress",
                "dateandTimeofAdmission", "typeofAdmission",
                "diagnosis", "typeofTreatment",
                "totalHospitalBillAmount", "amountClaimed",
                "accountHolderName", "bankName", "accountNumber",
                "iFSCCode"
            };

            for (String field : required) {
                if (request.getParameter(field) == null ||
                    request.getParameter(field).trim().isEmpty()) {
                    response.sendRedirect("SubmitClaim.jsp?error=1");
                    return;
                }
            }

            if (!"YES".equals(request.getParameter("declarationcheckbox"))) {
                response.sendRedirect("SubmitClaim.jsp?error=1");
                return;
            }
            

            ClaimsDao dao = new ClaimsDao();

            String policyNumber = request.getParameter("policyNumber").trim();

            if (!dao.isActivePolicyOwnedByUser(userId, policyNumber)) {
            	response.sendRedirect("SubmitClaim.jsp?error=1");
            	return;
            }


            int age = Integer.parseInt(request.getParameter("age"));
            BigDecimal bill = new BigDecimal(
                request.getParameter("totalHospitalBillAmount"));
            BigDecimal amount = new BigDecimal(
                request.getParameter("amountClaimed"));

            if (age < 0 || age > 130 ||
                bill.signum() <= 0 ||
                amount.signum() <= 0 ||
                amount.compareTo(bill) > 0) {
                response.sendRedirect("SubmitClaim.jsp?error=1");
                return;
            }

            Map<String, String> data = new HashMap<>();

            String[] columns = {
                "patientName", "age", "dateofBirth", "gender",
                "contactNumber", "emailID", "address",
                "insuranceCompanyName", "policyNumber", "healthCardNumber",
                "policyholderName", "hospitalName", "registrationNumber",
                "hospitalAddress", "hospitalContactNumber", "hospitalEmail",
                "dateandTimeofAdmission", "dateandTimeofDischarge",
                "typeofAdmission", "diagnosis", "typeofTreatment",
                "surgeryName", "surgeryDate", "treatingDoctorName",
                "totalHospitalBillAmount", "amountClaimed",
                "accountHolderName", "bankName", "accountNumber",
                "iFSCCode", "branchName", "declarationcheckbox"
            };

            for (String column : columns) {
                String value = request.getParameter(column);
                if (value != null) {
                    data.put(column, value.trim());
                }
            }

            String realPath = getServletContext().getRealPath("/");
            if (realPath == null) {
                throw new ServletException(
                    "Application deployment path is unavailable");
            }

            uploadDirectory = Paths.get(realPath, "uploads", "claims");
            Files.createDirectories(uploadDirectory);

            for (Part part : request.getParts()) {
                String fieldName = part.getName();

                if (!FILE_FIELDS.contains(fieldName) ||
                    part.getSize() == 0) {
                    continue;
                }

                if (part.getSize() > 5L * 1024 * 1024) {
                    throw new IllegalArgumentException(
                        "Each uploaded file must be 5 MB or smaller");
                }

                String submittedName = Paths.get(
                    part.getSubmittedFileName()).getFileName().toString();

                String extension = "";
                int dot = submittedName.lastIndexOf('.');
                if (dot >= 0) {
                    extension = submittedName.substring(dot).toLowerCase(
                        Locale.ROOT);
                }

                if (!Arrays.asList(".pdf", ".jpg", ".jpeg", ".png")
                        .contains(extension)) {
                    throw new IllegalArgumentException(
                        "Only PDF, JPG, JPEG and PNG files are allowed");
                }

                String storedName = UUID.randomUUID() + extension;
                Path destination = uploadDirectory.resolve(storedName);

                try (InputStream in = part.getInputStream()) {
                    Files.copy(in, destination);
                }

                savedFiles.add(destination);

                // Store relative path, not the original client filename.
                data.put(fieldName,
                    "uploads/claims/" + storedName);
            }

            String claimNumber = dao.submitClaim(userId, data);

            response.sendRedirect(
                "Claims?submitted=" +
                java.net.URLEncoder.encode(claimNumber, "UTF-8"));

        } catch (Exception e) {
            // Remove files if the database submission fails.
            for (Path file : savedFiles) {
                try {
                    Files.deleteIfExists(file);
                } catch (IOException ignored) {
                    // Log cleanup failure in production.
                }
            }

            if (e instanceof IllegalArgumentException) {
                response.sendRedirect("SubmitClaim.jsp?error=1");
            } else {
                getServletContext().log("Claim submission failed", e);
                response.sendRedirect("SubmitClaim.jsp?error=2");
            }
        }
    }
}
