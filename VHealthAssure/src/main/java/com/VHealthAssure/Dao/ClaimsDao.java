package com.VHealthAssure.Dao;

import java.sql.*;
import java.sql.Date;
import java.util.*;
import java.math.BigDecimal;

import com.VHealthAssure.Connection.MySqlInstance;
import com.VHealthAssure.Entity.ClaimEntity;

public class ClaimsDao {

    private static final String[] DETAIL_COLUMNS = {
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
        "iFSCCode", "branchName",
        "hospitalFinalBill", "detailedBill", "dischargeSummary",
        "medicalReports", "pharmacyBills", "fIRAccidentReport",
        "iDProof", "insuranceCardTPACard", "declarationcheckbox",
        "patientGuardianSignature", "hospitalSealandDoctorSignature"
    };

    public String submitClaim(String userId, Map<String, String> data)
            throws Exception {

        String claimNumber = "CLM-" +
                UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        String insertClaim =
            "INSERT INTO claims (ClaimNumber, UserId, ClaimDate, Status) " +
            "VALUES (?, ?, CURRENT_DATE, 'UNDER_REVIEW')";

        StringBuilder sql = new StringBuilder(
            "INSERT INTO claimdata (ClaimId");

        for (String column : DETAIL_COLUMNS) {
            sql.append(", `").append(column).append("`");
        }
        sql.append(") VALUES (?");

        for (int i = 0; i < DETAIL_COLUMNS.length; i++) {
            sql.append(", ?");
        }
        sql.append(")");

        try (Connection con =
                 MySqlInstance.getinstance().getConnection()) {

            con.setAutoCommit(false);

            try {
                long claimId;

                try (PreparedStatement ps = con.prepareStatement(
                        insertClaim, Statement.RETURN_GENERATED_KEYS)) {

                    ps.setString(1, claimNumber);
                    ps.setString(2, userId);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException(
                                "Could not generate ClaimId");
                        }
                        claimId = keys.getLong(1);
                    }
                }

                try (PreparedStatement ps =
                         con.prepareStatement(sql.toString())) {

                    ps.setLong(1, claimId);

                    for (int i = 0; i < DETAIL_COLUMNS.length; i++) {
                        String column = DETAIL_COLUMNS[i];
                        String value = data.get(column);

                        if (value == null || value.trim().isEmpty()) {
                            ps.setNull(i + 2, Types.NULL);
                        } else if ("age".equals(column)) {
                            ps.setInt(i + 2, Integer.parseInt(value));
                        } else if ("dateofBirth".equals(column)
                                || "surgeryDate".equals(column)) {
                            ps.setDate(i + 2, Date.valueOf(value));
                        } else if ("dateandTimeofAdmission".equals(column)
                                || "dateandTimeofDischarge".equals(column)) {
                            ps.setTimestamp(i + 2,
                                Timestamp.valueOf(value.replace("T", " ") +
                                    (value.length() == 16 ? ":00" : "")));
                        } else if ("totalHospitalBillAmount".equals(column)
                                || "amountClaimed".equals(column)) {
                            ps.setBigDecimal(i + 2,
                                new BigDecimal(value));
                        } else {
                            ps.setString(i + 2, value);
                        }
                    }

                    ps.executeUpdate();
                }

                con.commit();
                return claimNumber;

            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public List<ClaimEntity> getClaimsByUser(String userId)
            throws Exception {

        List<ClaimEntity> claims = new ArrayList<>();

        String sql =
            "SELECT c.ClaimId, c.ClaimNumber, c.UserId, c.ClaimDate, " +
            "c.Status, d.amountClaimed, d.policyNumber " +
            "FROM claims c " +
            "LEFT JOIN claimdata d ON d.ClaimId = c.ClaimId " +
            "WHERE c.UserId = ? " +
            "ORDER BY c.ClaimDate DESC, c.ClaimId DESC";

        try (Connection con =
                 MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ClaimEntity claim = new ClaimEntity();
                    claim.setClaimId(rs.getLong("ClaimId"));
                    claim.setClaimNumber(rs.getString("ClaimNumber"));
                    claim.setUserId(rs.getString("UserId"));
                    claim.setClaimDate(rs.getDate("ClaimDate"));
                    claim.setStatus(rs.getString("Status"));
                    claim.setAmountClaimed(
                        rs.getBigDecimal("amountClaimed"));
                    claim.setPolicyNumber(rs.getString("policyNumber"));
                    claims.add(claim);
                }
            }
        }

        return claims;
    }
    
    public boolean isActivePolicyOwnedByUser(
            String userId, String policyNumber) throws Exception {

        String sql =
            "SELECT 1 FROM policies " +
            "WHERE UserId=? AND PolicyNumber=? AND Status='ACTIVE' LIMIT 1";

        try (Connection con =
                 MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userId);
            ps.setString(2, policyNumber);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public ClaimEntity getClaimById(long claimId, String userId)
            throws Exception {

        String sql =
            "SELECT c.ClaimId, c.ClaimNumber, c.UserId, c.ClaimDate, " +
            "c.Status, d.amountClaimed, d.policyNumber " +
            "FROM claims c LEFT JOIN claimdata d ON d.ClaimId=c.ClaimId " +
            "WHERE c.ClaimId=? AND c.UserId=?";

        try (Connection con =
                 MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, claimId);
            ps.setString(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ClaimEntity claim = new ClaimEntity();
                    claim.setClaimId(rs.getLong("ClaimId"));
                    claim.setClaimNumber(rs.getString("ClaimNumber"));
                    claim.setUserId(rs.getString("UserId"));
                    claim.setClaimDate(rs.getDate("ClaimDate"));
                    claim.setStatus(rs.getString("Status"));
                    claim.setAmountClaimed(
                        rs.getBigDecimal("amountClaimed"));
                    claim.setPolicyNumber(rs.getString("policyNumber"));
                    return claim;
                }
            }
        }

        return null;
    }
}
