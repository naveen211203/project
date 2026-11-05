
package com.VHealthAssure.Controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.VHealthAssure.Dao.AdminKycDao;

@WebServlet("/AdminKycDocument")
public class AdminKycDocumentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Allow only logged-in administrators
        if (session == null
                || session.getAttribute("loginId") == null
                || !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String kycId = request.getParameter("kycId");

        if (kycId == null || kycId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            AdminKycDao dao = new AdminKycDao();
            Map<String, Object> kyc = dao.getKycById(kycId);

            if (kyc == null || kyc.get("documentPath") == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String storedPath = kyc.get("documentPath").toString();

            File uploadRoot = new File(
                getServletContext().getRealPath("/uploads/kyc")
            ).getCanonicalFile();

            File document = new File(storedPath).getCanonicalFile();

            // Prevent access to files outside the KYC upload directory
            String rootPath = uploadRoot.getPath() + File.separator;

            if (!document.getPath().startsWith(rootPath)
                    || !document.isFile()
                    || !document.exists()) {

                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Identify the actual file type using its contents
            String contentType = detectContentType(document);

            if (contentType == null) {
                response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
                return;
            }

            response.setContentType(contentType);
            response.setHeader("Content-Disposition", "inline");
            response.setHeader("X-Content-Type-Options", "nosniff");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setContentLengthLong(document.length());

            try (FileInputStream input = new FileInputStream(document);
                 OutputStream output = response.getOutputStream()) {

                byte[] buffer = new byte[8192];
                int bytesRead;

                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to open KYC document.", e);
        }
    }

    private String detectContentType(File file) throws IOException {

        byte[] header = new byte[8];

        try (FileInputStream input = new FileInputStream(file)) {
            if (input.read(header) < 4) {
                return null;
            }
        }

        // PDF
        if (header[0] == '%'
                && header[1] == 'P'
                && header[2] == 'D'
                && header[3] == 'F') {
            return "application/pdf";
        }

        // JPEG
        if ((header[0] & 0xFF) == 0xFF
                && (header[1] & 0xFF) == 0xD8
                && (header[2] & 0xFF) == 0xFF) {
            return "image/jpeg";
        }

        // PNG
        if ((header[0] & 0xFF) == 0x89
                && header[1] == 'P'
                && header[2] == 'N'
                && header[3] == 'G') {
            return "image/png";
        }

        return null;
    }
}
