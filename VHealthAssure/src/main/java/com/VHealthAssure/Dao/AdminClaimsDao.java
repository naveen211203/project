
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

public class AdminClaimsDao {

    private static final String[] VALID_STATUSES = {
        "UNDER_REVIEW", "APPROVED", "REJECTED"
    };

    /*
     * Check whether the requested status is valid.
     */
    private boolean isValidStatus(String status) {

        if (status == null) {
            return false;
        }

        for (String valid : VALID_STATUSES) {
            if (valid.equals(status)) {
                return true;
            }
        }

        return false;
    }


    /*
     * Fetch all claims with customer and claim details.
     * Supports searching and status filtering.
     */
    public List<Map<String, Object>> getAllClaims(
            String search, String status) {

        List<Map<String, Object>> claims = new ArrayList<>();

        StringBuilder sql = new StringBuilder(

            "SELECT c.ClaimId, c.ClaimNumber, c.UserId, " +
            "c.ClaimDate, c.Status, c.CreatedAt, " +

            "u.FullName, u.Email, u.Mobile, " +

            "d.patientName, d.policyNumber, " +
            "d.hospitalName, d.diagnosis, " +
            "d.typeofTreatment, d.amountClaimed, " +
            "d.totalHospitalBillAmount " +

            "FROM claims c " +

            "INNER JOIN users u ON c.UserId = u.UserId " +

            "LEFT JOIN claimdata d ON c.ClaimId = d.ClaimId " +

            "WHERE 1=1 "
        );

        boolean hasSearch =
            search != null && !search.trim().isEmpty();

        boolean validStatus = isValidStatus(status);

        if (hasSearch) {

            sql.append(
                "AND (c.ClaimNumber LIKE ? " +
                "OR u.FullName LIKE ? " +
                "OR u.Email LIKE ? " +
                "OR u.Mobile LIKE ? " +
                "OR d.patientName LIKE ? " +
                "OR d.policyNumber LIKE ?) "
            );
        }

        if (validStatus) {
            sql.append("AND c.Status = ? ");
        }

        sql.append(
            "ORDER BY c.CreatedAt DESC, c.ClaimId DESC"
        );

        try (
            Connection con = MySqlInstance.getinstance().getConnection();

            PreparedStatement ps =
                con.prepareStatement(sql.toString())
        ) {

            int index = 1;

            if (hasSearch) {

                String keyword = "%" + search.trim() + "%";

                for (int i = 0; i < 6; i++) {
                    ps.setString(index++, keyword);
                }
            }

            if (validStatus) {
                ps.setString(index++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> claim = new HashMap<>();

                    claim.put("claimId",
                        rs.getLong("ClaimId"));

                    claim.put("claimNumber",
                        rs.getString("ClaimNumber"));

                    claim.put("userId",
                        rs.getString("UserId"));

                    claim.put("claimDate",
                        rs.getDate("ClaimDate"));

                    claim.put("status",
                        rs.getString("Status"));

                    claim.put("createdAt",
                        rs.getTimestamp("CreatedAt"));

                    claim.put("customerName",
                        rs.getString("FullName"));

                    claim.put("email",
                        rs.getString("Email"));

                    claim.put("mobile",
                        rs.getString("Mobile"));

                    claim.put("patientName",
                        rs.getString("patientName"));

                    claim.put("policyNumber",
                        rs.getString("policyNumber"));

                    claim.put("hospitalName",
                        rs.getString("hospitalName"));

                    claim.put("diagnosis",
                        rs.getString("diagnosis"));

                    claim.put("treatmentType",
                        rs.getString("typeofTreatment"));

                    claim.put("amountClaimed",
                        rs.getBigDecimal("amountClaimed"));

                    claim.put("totalHospitalBillAmount",
                        rs.getBigDecimal("totalHospitalBillAmount"));

                    claims.add(claim);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return claims;
    }


    /*
     * Fetch claim statistics for dashboard cards.
     */
    public Map<String, Integer> getClaimStatistics() {

        Map<String, Integer> statistics = new HashMap<>();

        String sql =
            "SELECT COUNT(*) AS totalClaims, " +

            "SUM(CASE WHEN Status = 'UNDER_REVIEW' " +
            "THEN 1 ELSE 0 END) AS underReviewClaims, " +

            "SUM(CASE WHEN Status = 'APPROVED' " +
            "THEN 1 ELSE 0 END) AS approvedClaims, " +

            "SUM(CASE WHEN Status = 'REJECTED' " +
            "THEN 1 ELSE 0 END) AS rejectedClaims " +

            "FROM claims";

        try (
            Connection con = MySqlInstance.getinstance().getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {

                statistics.put("totalClaims",
                    rs.getInt("totalClaims"));

                statistics.put("underReviewClaims",
                    rs.getInt("underReviewClaims"));

                statistics.put("approvedClaims",
                    rs.getInt("approvedClaims"));

                statistics.put("rejectedClaims",
                    rs.getInt("rejectedClaims"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statistics;
    }


    /*
     * Fetch complete claim details using ClaimId.
     */
    public Map<String, Object> getClaimById(long claimId) {

        Map<String, Object> claim = null;

        String sql =
            "SELECT c.ClaimId, c.ClaimNumber, c.UserId, " +
            "c.ClaimDate, c.Status, c.CreatedAt, " +

            "u.FullName, u.Email, u.Mobile, " +

            "d.* " +

            "FROM claims c " +

            "INNER JOIN users u ON c.UserId = u.UserId " +

            "LEFT JOIN claimdata d ON c.ClaimId = d.ClaimId " +

            "WHERE c.ClaimId = ?";

        try (
            Connection con = MySqlInstance.getinstance().getConnection();

            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setLong(1, claimId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    claim = new HashMap<>();

                    claim.put("claimId",
                        rs.getLong("ClaimId"));

                    claim.put("claimNumber",
                        rs.getString("ClaimNumber"));

                    claim.put("userId",
                        rs.getString("UserId"));

                    claim.put("claimDate",
                        rs.getDate("ClaimDate"));

                    claim.put("status",
                        rs.getString("Status"));

                    claim.put("createdAt",
                        rs.getTimestamp("CreatedAt"));

                    claim.put("customerName",
                        rs.getString("FullName"));

                    claim.put("email",
                        rs.getString("Email"));

                    claim.put("mobile",
                        rs.getString("Mobile"));

                    claim.put("patientName",
                        rs.getString("patientName"));

                    claim.put("age",
                        rs.getObject("age"));

                    claim.put("dateofBirth",
                        rs.getDate("dateofBirth"));

                    claim.put("gender",
                        rs.getString("gender"));

                    claim.put("contactNumber",
                        rs.getString("contactNumber"));

                    claim.put("emailID",
                        rs.getString("emailID"));

                    claim.put("address",
                        rs.getString("address"));

                    claim.put("insuranceCompanyName",
                        rs.getString("insuranceCompanyName"));

                    claim.put("policyNumber",
                        rs.getString("policyNumber"));

                    claim.put("healthCardNumber",
                        rs.getString("healthCardNumber"));

                    claim.put("policyholderName",
                        rs.getString("policyholderName"));

                    claim.put("hospitalName",
                        rs.getString("hospitalName"));

                    claim.put("registrationNumber",
                        rs.getString("registrationNumber"));

                    claim.put("hospitalAddress",
                        rs.getString("hospitalAddress"));

                    claim.put("hospitalContactNumber",
                        rs.getString("hospitalContactNumber"));

                    claim.put("hospitalEmail",
                        rs.getString("hospitalEmail"));

                    claim.put("admissionDate",
                        rs.getTimestamp("dateandTimeofAdmission"));

                    claim.put("dischargeDate",
                        rs.getTimestamp("dateandTimeofDischarge"));

                    claim.put("typeofAdmission",
                        rs.getString("typeofAdmission"));

                    claim.put("diagnosis",
                        rs.getString("diagnosis"));

                    claim.put("treatmentType",
                        rs.getString("typeofTreatment"));

                    claim.put("surgeryName",
                        rs.getString("surgeryName"));

                    claim.put("surgeryDate",
                        rs.getDate("surgeryDate"));

                    claim.put("treatingDoctorName",
                        rs.getString("treatingDoctorName"));

                    claim.put("totalHospitalBillAmount",
                        rs.getBigDecimal("totalHospitalBillAmount"));

                    claim.put("amountClaimed",
                        rs.getBigDecimal("amountClaimed"));

                    claim.put("accountHolderName",
                        rs.getString("accountHolderName"));

                    claim.put("bankName",
                        rs.getString("bankName"));

                    claim.put("accountNumber",
                        rs.getString("accountNumber"));

                    claim.put("iFSCCode",
                        rs.getString("iFSCCode"));

                    claim.put("branchName",
                        rs.getString("branchName"));

                    claim.put("hospitalFinalBill",
                        rs.getString("hospitalFinalBill"));

                    claim.put("detailedBill",
                        rs.getString("detailedBill"));

                    claim.put("dischargeSummary",
                        rs.getString("dischargeSummary"));

                    claim.put("medicalReports",
                        rs.getString("medicalReports"));

                    claim.put("pharmacyBills",
                        rs.getString("pharmacyBills"));

                    claim.put("fIRAccidentReport",
                        rs.getString("fIRAccidentReport"));

                    claim.put("iDProof",
                        rs.getString("iDProof"));

                    claim.put("insuranceCardTPACard",
                        rs.getString("insuranceCardTPACard"));

                    claim.put("patientGuardianSignature",
                        rs.getString("patientGuardianSignature"));

                    claim.put("hospitalSealandDoctorSignature",
                        rs.getString("hospitalSealandDoctorSignature"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return claim;
    }


    /*
     * Update claim status.
     * Only APPROVED and REJECTED can be selected by admin.
     */
    public boolean updateClaimStatus(long claimId, String status) {

        if (!"APPROVED".equals(status) &&
            !"REJECTED".equals(status)) {
            return false;
        }

        String sql =
            "UPDATE claims SET Status = ? " +
            "WHERE ClaimId = ? AND Status = 'UNDER_REVIEW'";

        try (
            Connection con = MySqlInstance.getinstance().getConnection();

            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, status);
            ps.setLong(2, claimId);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
