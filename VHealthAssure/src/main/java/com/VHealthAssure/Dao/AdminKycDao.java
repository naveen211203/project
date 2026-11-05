
package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.VHealthAssure.Connection.MySqlInstance;

public class AdminKycDao {

    /*
     * Fetch all KYC submissions.
     * Supports search and status filtering.
     */
    public List<Map<String, Object>> getAllKyc(
            String search, String status) {

        List<Map<String, Object>> kycList =
                new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT k.KycId, k.UserId, k.GovIdType, " +
            "k.GovIdNumber, k.DocumentPath, k.DocumentType, " +
            "k.AttemptNumber, k.Status, k.RejectionReason, " +
            "k.UploadedAt, k.ReviewedAt, " +
            "u.FullName, u.Email, u.Mobile " +
            "FROM kyc_documents k " +
            "INNER JOIN users u ON k.UserId = u.UserId " +
            "WHERE 1=1 "
        );

        boolean hasSearch =
                search != null && !search.trim().isEmpty();

        boolean validStatus =
                status != null &&
                ("PENDING".equals(status) ||
                 "VERIFIED".equals(status) ||
                 "REJECTED".equals(status));

        if (hasSearch) {
            sql.append(
                "AND (k.KycId LIKE ? " +
                "OR k.GovIdNumber LIKE ? " +
                "OR u.FullName LIKE ? " +
                "OR u.Email LIKE ? " +
                "OR u.Mobile LIKE ?) "
            );
        }

        if (validStatus) {
            sql.append("AND k.Status = ? ");
        }

        sql.append("ORDER BY k.UploadedAt DESC");

        try (Connection con =
                    MySqlInstance.getinstance().getConnection();

             PreparedStatement ps =
                    con.prepareStatement(sql.toString())) {

            int index = 1;

            if (hasSearch) {

                String keyword =
                        "%" + search.trim() + "%";

                ps.setString(index++, keyword);
                ps.setString(index++, keyword);
                ps.setString(index++, keyword);
                ps.setString(index++, keyword);
                ps.setString(index++, keyword);
            }

            if (validStatus) {
                ps.setString(index++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> kyc =
                            new HashMap<>();

                    kyc.put("kycId",
                            rs.getString("KycId"));

                    kyc.put("userId",
                            rs.getString("UserId"));

                    kyc.put("customerName",
                            rs.getString("FullName"));

                    kyc.put("email",
                            rs.getString("Email"));

                    kyc.put("mobile",
                            rs.getString("Mobile"));

                    kyc.put("govIdType",
                            rs.getString("GovIdType"));

                    kyc.put("govIdNumber",
                            rs.getString("GovIdNumber"));

                    kyc.put("documentPath",
                            rs.getString("DocumentPath"));

                    kyc.put("documentType",
                            rs.getString("DocumentType"));

                    kyc.put("attemptNumber",
                            rs.getInt("AttemptNumber"));

                    kyc.put("status",
                            rs.getString("Status"));

                    kyc.put("rejectionReason",
                            rs.getString("RejectionReason"));

                    kyc.put("uploadedAt",
                            rs.getTimestamp("UploadedAt"));

                    kyc.put("reviewedAt",
                            rs.getTimestamp("ReviewedAt"));

                    kycList.add(kyc);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return kycList;
    }


    /*
     * Fetch KYC dashboard statistics.
     */
    public Map<String, Integer> getKycStatistics() {

        Map<String, Integer> statistics =
                new HashMap<>();

        String sql =
            "SELECT COUNT(*) AS totalKyc, " +
            "SUM(CASE WHEN Status = 'PENDING' " +
            "THEN 1 ELSE 0 END) AS pendingKyc, " +
            "SUM(CASE WHEN Status = 'VERIFIED' " +
            "THEN 1 ELSE 0 END) AS verifiedKyc, " +
            "SUM(CASE WHEN Status = 'REJECTED' " +
            "THEN 1 ELSE 0 END) AS rejectedKyc " +
            "FROM kyc_documents";

        try (Connection con =
                    MySqlInstance.getinstance().getConnection();

             PreparedStatement ps =
                    con.prepareStatement(sql);

             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                statistics.put("totalKyc",
                        rs.getInt("totalKyc"));

                statistics.put("pendingKyc",
                        rs.getInt("pendingKyc"));

                statistics.put("verifiedKyc",
                        rs.getInt("verifiedKyc"));

                statistics.put("rejectedKyc",
                        rs.getInt("rejectedKyc"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statistics;
    }


    /*
     * Fetch individual KYC submission details.
     */
    public Map<String, Object> getKycById(String kycId) {

        Map<String, Object> kyc = null;

        String sql =
            "SELECT k.KycId, k.UserId, k.GovIdType, " +
            "k.GovIdNumber, k.DocumentPath, k.DocumentType, " +
            "k.AttemptNumber, k.Status, k.RejectionReason, " +
            "k.UploadedAt, k.ReviewedAt, k.ReviewedBy, " +
            "u.FullName, u.Email, u.Mobile, " +
            "u.DateOfBirth, u.Gender, u.AddressLine1, " +
            "u.AddressLine2, u.City, u.State, " +
            "u.PostalCode, u.Country, u.KycStatus " +
            "FROM kyc_documents k " +
            "INNER JOIN users u ON k.UserId = u.UserId " +
            "WHERE k.KycId = ?";

        try (Connection con =
                    MySqlInstance.getinstance().getConnection();

             PreparedStatement ps =
                    con.prepareStatement(sql)) {

            ps.setString(1, kycId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    kyc = new HashMap<>();

                    kyc.put("kycId",
                            rs.getString("KycId"));

                    kyc.put("userId",
                            rs.getString("UserId"));

                    kyc.put("customerName",
                            rs.getString("FullName"));

                    kyc.put("email",
                            rs.getString("Email"));

                    kyc.put("mobile",
                            rs.getString("Mobile"));

                    kyc.put("govIdType",
                            rs.getString("GovIdType"));

                    kyc.put("govIdNumber",
                            rs.getString("GovIdNumber"));

                    kyc.put("documentPath",
                            rs.getString("DocumentPath"));

                    kyc.put("documentType",
                            rs.getString("DocumentType"));

                    kyc.put("attemptNumber",
                            rs.getInt("AttemptNumber"));

                    kyc.put("status",
                            rs.getString("Status"));

                    kyc.put("rejectionReason",
                            rs.getString("RejectionReason"));

                    kyc.put("uploadedAt",
                            rs.getTimestamp("UploadedAt"));

                    kyc.put("reviewedAt",
                            rs.getTimestamp("ReviewedAt"));

                    kyc.put("reviewedBy",
                            rs.getString("ReviewedBy"));

                    kyc.put("dateOfBirth",
                            rs.getDate("DateOfBirth"));

                    kyc.put("gender",
                            rs.getString("Gender"));

                    kyc.put("addressLine1",
                            rs.getString("AddressLine1"));

                    kyc.put("addressLine2",
                            rs.getString("AddressLine2"));

                    kyc.put("city",
                            rs.getString("City"));

                    kyc.put("state",
                            rs.getString("State"));

                    kyc.put("postalCode",
                            rs.getString("PostalCode"));

                    kyc.put("country",
                            rs.getString("Country"));

                    kyc.put("userKycStatus",
                            rs.getString("KycStatus"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return kyc;
    }


    /*
     * Approve or reject a pending KYC submission.
     *
     * Updates:
     * 1. kyc_documents.Status
     * 2. kyc_documents.RejectionReason
     * 3. kyc_documents.ReviewedAt
     * 4. kyc_documents.ReviewedBy
     * 5. users.KycStatus
     */
    public boolean reviewKyc(
            String kycId,
            String status,
            String rejectionReason,
            String adminId) {

        if (kycId == null || kycId.trim().isEmpty() ||
            adminId == null || adminId.trim().isEmpty()) {

            return false;
        }

        if (!"VERIFIED".equals(status) &&
            !"REJECTED".equals(status)) {

            return false;
        }

        if ("REJECTED".equals(status) &&
            (rejectionReason == null ||
             rejectionReason.trim().isEmpty())) {

            return false;
        }

        Connection con = null;

        try {

            con = MySqlInstance.getinstance().getConnection();

            boolean originalAutoCommit = con.getAutoCommit();

            try {

                con.setAutoCommit(false);

                String userId;

                // Lock the pending document during review
                String checkSql =
                    "SELECT UserId FROM kyc_documents " +
                    "WHERE KycId = ? AND Status = 'PENDING' " +
                    "FOR UPDATE";

                try (PreparedStatement checkPs =
                        con.prepareStatement(checkSql)) {

                    checkPs.setString(1, kycId);

                    try (ResultSet rs = checkPs.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();
                            return false;
                        }

                        userId = rs.getString("UserId");
                    }
                }

                // Update document review information
                String documentSql =
                    "UPDATE kyc_documents SET " +
                    "Status = ?, " +
                    "RejectionReason = ?, " +
                    "ReviewedAt = CURRENT_TIMESTAMP, " +
                    "ReviewedBy = ? " +
                    "WHERE KycId = ? AND Status = 'PENDING'";

                try (PreparedStatement documentPs =
                        con.prepareStatement(documentSql)) {

                    documentPs.setString(1, status);

                    if ("REJECTED".equals(status)) {
                        documentPs.setString(
                                2, rejectionReason.trim());
                    } else {
                        documentPs.setNull(
                                2, java.sql.Types.VARCHAR);
                    }

                    documentPs.setString(3, adminId);
                    documentPs.setString(4, kycId);

                    int updated =
                            documentPs.executeUpdate();

                    if (updated != 1) {
                        con.rollback();
                        return false;
                    }
                }

                // Update customer's KYC status
                String userSql =
                    "UPDATE users SET KycStatus = ? " +
                    "WHERE UserId = ?";

                try (PreparedStatement userPs =
                        con.prepareStatement(userSql)) {

                    userPs.setString(1, status);
                    userPs.setString(2, userId);

                    int updated =
                            userPs.executeUpdate();

                    if (updated != 1) {
                        con.rollback();
                        return false;
                    }
                }

                con.commit();

                return true;

            } catch (SQLException e) {

                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }

                throw e;

            } finally {

                try {
                    con.setAutoCommit(originalAutoCommit);
                } catch (SQLException resetError) {
                    resetError.printStackTrace();
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

}
