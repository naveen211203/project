
package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.VHealthAssure.Connection.MySqlInstance;

public class AdminUsersDao {

    // =====================================================
    // GET ALL CUSTOMERS WITH SEARCH AND STATUS FILTER
    // =====================================================

    public List<Map<String, Object>> getUsers(
            String search, String status) {

        List<Map<String, Object>> users = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT UserId, FullName, Email, Mobile, City, State, " +
            "Status, KycStatus, CreatedAt " +
            "FROM users WHERE Role = 'USER' "
        );

        boolean hasSearch =
            search != null && !search.trim().isEmpty();

        boolean hasStatus =
            status != null && !status.equalsIgnoreCase("ALL");

        if (hasSearch) {
            sql.append(
                "AND (FullName LIKE ? OR Email LIKE ? " +
                "OR Mobile LIKE ? OR UserId LIKE ?) "
            );
        }

        if (hasStatus) {
            sql.append("AND Status = ? ");
        }

        sql.append("ORDER BY CreatedAt DESC");

        try {
            Connection con =
                MySqlInstance.getinstance().getConnection();

            try (PreparedStatement ps =
                    con.prepareStatement(sql.toString())) {

                int index = 1;

                if (hasSearch) {
                    String keyword = "%" + search.trim() + "%";

                    ps.setString(index++, keyword);
                    ps.setString(index++, keyword);
                    ps.setString(index++, keyword);
                    ps.setString(index++, keyword);
                }

                if (hasStatus) {
                    ps.setString(index++, status);
                }

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        Map<String, Object> user =
                            new HashMap<>();

                        user.put("userId",
                            rs.getString("UserId"));

                        user.put("fullName",
                            rs.getString("FullName"));

                        user.put("email",
                            rs.getString("Email"));

                        user.put("mobile",
                            rs.getString("Mobile"));

                        user.put("city",
                            rs.getString("City"));

                        user.put("state",
                            rs.getString("State"));

                        user.put("status",
                            rs.getString("Status"));

                        user.put("kycStatus",
                            rs.getString("KycStatus"));

                        user.put("createdAt",
                            rs.getTimestamp("CreatedAt"));

                        users.add(user);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }


    // =====================================================
    // GET COMPLETE CUSTOMER DETAILS
    // Password is intentionally excluded.
    // =====================================================

    public Map<String, Object> getUserDetails(String userId) {

        Map<String, Object> user = null;

        String sql =
            "SELECT UserId, FullName, Email, Mobile, " +
            "GovIdType, GovIdNumber, DateOfBirth, Gender, " +
            "AddressLine1, AddressLine2, City, State, PostalCode, Country, " +
            "NomineeName, NomineeRelation, NomineeDob, NomineeShare, " +
            "EmploymentStatus, AnnualIncome, Occupation, Company, " +
            "EmailVerified, MobileVerified, KycStatus, Role, Status, " +
            "CreatedAt, UpdatedAt " +
            "FROM users WHERE UserId = ? AND Role = 'USER'";

        try {
            Connection con =
                MySqlInstance.getinstance().getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        user = new HashMap<>();

                        user.put("userId",
                            rs.getString("UserId"));

                        user.put("fullName",
                            rs.getString("FullName"));

                        user.put("email",
                            rs.getString("Email"));

                        user.put("mobile",
                            rs.getString("Mobile"));

                        user.put("govIdType",
                            rs.getString("GovIdType"));

                        user.put("govIdNumber",
                            rs.getString("GovIdNumber"));

                        user.put("dateOfBirth",
                            rs.getDate("DateOfBirth"));

                        user.put("gender",
                            rs.getString("Gender"));

                        user.put("addressLine1",
                            rs.getString("AddressLine1"));

                        user.put("addressLine2",
                            rs.getString("AddressLine2"));

                        user.put("city",
                            rs.getString("City"));

                        user.put("state",
                            rs.getString("State"));

                        user.put("postalCode",
                            rs.getString("PostalCode"));

                        user.put("country",
                            rs.getString("Country"));

                        user.put("nomineeName",
                            rs.getString("NomineeName"));

                        user.put("nomineeRelation",
                            rs.getString("NomineeRelation"));

                        user.put("nomineeDob",
                            rs.getDate("NomineeDob"));

                        user.put("nomineeShare",
                            rs.getBigDecimal("NomineeShare"));

                        user.put("employmentStatus",
                            rs.getString("EmploymentStatus"));

                        user.put("annualIncome",
                            rs.getBigDecimal("AnnualIncome"));

                        user.put("occupation",
                            rs.getString("Occupation"));

                        user.put("company",
                            rs.getString("Company"));

                        user.put("emailVerified",
                            rs.getBoolean("EmailVerified"));

                        user.put("mobileVerified",
                            rs.getBoolean("MobileVerified"));

                        user.put("kycStatus",
                            rs.getString("KycStatus"));

                        user.put("role",
                            rs.getString("Role"));

                        user.put("status",
                            rs.getString("Status"));

                        user.put("createdAt",
                            rs.getTimestamp("CreatedAt"));

                        user.put("updatedAt",
                            rs.getTimestamp("UpdatedAt"));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }


    // =====================================================
    // UPDATE CUSTOMER ACCOUNT STATUS
    // =====================================================

    public boolean updateUserStatus(
            String userId, String status) {

        if (userId == null || userId.trim().isEmpty()) {
            return false;
        }

        if (!"ACTIVE".equals(status) &&
            !"INACTIVE".equals(status) &&
            !"SUSPENDED".equals(status)) {

            return false;
        }

        String sql =
            "UPDATE users SET Status = ? " +
            "WHERE UserId = ? AND Role = 'USER'";

        try {
            Connection con =
                MySqlInstance.getinstance().getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, status);
                ps.setString(2, userId);

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
