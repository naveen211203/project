package com.VHealthAssure.Controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

import com.VHealthAssure.Dao.KycDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/UploadKyc")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 6 * 1024 * 1024
)
public class KycServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final KycDao kycDao = new KycDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginId") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String userId = (String) session.getAttribute("loginId");

        try {
            if ("VERIFIED".equalsIgnoreCase(kycDao.getUserKycStatus(userId))) {
                response.sendRedirect("Kyc");
                return;
            }

            int attempts = kycDao.getKycAttemptCount(userId);
            if (attempts >= 3) {
                response.sendRedirect("Kyc");
                return;
            }

            String govIdType = request.getParameter("GovIdType");
            String govIdNumber = request.getParameter("GovIdNumber");
            Part filePart = request.getPart("kycFile");

            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("Kyc");
                return;
            }

            String uploadDir = getServletContext()
                    .getRealPath("/uploads/kyc/" + userId);
            Files.createDirectories(Paths.get(uploadDir));

            String fileName = "kyc_attempt_" + (attempts + 1) + "_" +
                              filePart.getSubmittedFileName();
            String filePath = uploadDir + File.separator + fileName;

            filePart.write(filePath);

            kycDao.insertKycDocument(
                UUID.randomUUID().toString(),
                userId,
                govIdType,
                govIdNumber,
                filePath,
                filePart.getContentType(),
                attempts + 1
            );

            kycDao.updateUserKycStatus(userId, "PENDING");

            response.sendRedirect("Kyc"); // ✅ CRITICAL
            System.out.println("✅File Uploaded Successfully to DB");
            System.out.println("FILE SIZE = " + filePart.getSize());

        } catch (Exception e) {
            e.printStackTrace();  // KEEP THIS
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "KYC upload failed: " + e.getMessage());
        }

    }
}
