
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

public class AdminPoliciesDao {

    /*
     * Fetch policies with their customer details.
     * Supports search and status filtering.
     */
    public List<Map<String, Object>> getAllPolicies(
            String search, String status) {

        List<Map<String, Object>> policies = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT p.PolicyId, p.PolicyNumber, p.UserId, " +
            "p.PolicyType, p.Status, p.PremiumAmount, " +
            "p.NextPremiumDate, p.CreatedAt, " +
            "u.FullName, u.Email, u.Mobile " +
            "FROM policies p " +
            "INNER JOIN users u ON p.UserId = u.UserId " +
            "WHERE 1=1 "
        );

        boolean hasSearch =
            search != null && !search.trim().isEmpty();

        boolean validStatus =
            status != null &&
            ("ACTIVE".equals(status) ||
             "EXPIRED".equals(status) ||
             "CANCELLED".equals(status));

        if (hasSearch) {
            sql.append(
                "AND (p.PolicyNumber LIKE ? " +
                "OR u.FullName LIKE ? " +
                "OR u.Email LIKE ? " +
                "OR u.Mobile LIKE ?) "
            );
        }

        if (validStatus) {
            sql.append("AND p.Status = ? ");
        }

        sql.append("ORDER BY p.CreatedAt DESC");

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps =
                 con.prepareStatement(sql.toString())) {

            int index = 1;

            if (hasSearch) {
                String keyword = "%" + search.trim() + "%";

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

                    Map<String, Object> policy =
                        new HashMap<>();

                    policy.put("policyId",
                        rs.getLong("PolicyId"));

                    policy.put("policyNumber",
                        rs.getString("PolicyNumber"));

                    policy.put("userId",
                        rs.getString("UserId"));

                    policy.put("policyType",
                        rs.getString("PolicyType"));

                    policy.put("status",
                        rs.getString("Status"));

                    policy.put("premiumAmount",
                        rs.getBigDecimal("PremiumAmount"));

                    policy.put("nextPremiumDate",
                        rs.getDate("NextPremiumDate"));

                    policy.put("createdAt",
                        rs.getTimestamp("CreatedAt"));

                    policy.put("customerName",
                        rs.getString("FullName"));

                    policy.put("email",
                        rs.getString("Email"));

                    policy.put("mobile",
                        rs.getString("Mobile"));

                    policies.add(policy);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return policies;
    }


    /*
     * Fetch policy statistics for dashboard cards.
     */
    public Map<String, Integer> getPolicyStatistics() {

        Map<String, Integer> statistics = new HashMap<>();

        String sql =
            "SELECT COUNT(*) AS totalPolicies, " +
            "SUM(CASE WHEN Status = 'ACTIVE' " +
            "THEN 1 ELSE 0 END) AS activePolicies, " +
            "SUM(CASE WHEN Status = 'EXPIRED' " +
            "THEN 1 ELSE 0 END) AS expiredPolicies, " +
            "SUM(CASE WHEN Status = 'CANCELLED' " +
            "THEN 1 ELSE 0 END) AS cancelledPolicies " +
            "FROM policies";

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                statistics.put("totalPolicies",
                    rs.getInt("totalPolicies"));

                statistics.put("activePolicies",
                    rs.getInt("activePolicies"));

                statistics.put("expiredPolicies",
                    rs.getInt("expiredPolicies"));

                statistics.put("cancelledPolicies",
                    rs.getInt("cancelledPolicies"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statistics;
    }


    /*
     * Fetch one policy using its PolicyId.
     */
    public Map<String, Object> getPolicyById(long policyId) {

        Map<String, Object> policy = null;

        String sql =
            "SELECT p.PolicyId, p.PolicyNumber, p.UserId, " +
            "p.PolicyType, p.Status, p.PremiumAmount, " +
            "p.NextPremiumDate, p.CreatedAt, " +
            "u.FullName, u.Email, u.Mobile " +
            "FROM policies p " +
            "INNER JOIN users u ON p.UserId = u.UserId " +
            "WHERE p.PolicyId = ?";

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, policyId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    policy = new HashMap<>();

                    policy.put("policyId",
                        rs.getLong("PolicyId"));

                    policy.put("policyNumber",
                        rs.getString("PolicyNumber"));

                    policy.put("userId",
                        rs.getString("UserId"));

                    policy.put("policyType",
                        rs.getString("PolicyType"));

                    policy.put("status",
                        rs.getString("Status"));

                    policy.put("premiumAmount",
                        rs.getBigDecimal("PremiumAmount"));

                    policy.put("nextPremiumDate",
                        rs.getDate("NextPremiumDate"));

                    policy.put("createdAt",
                        rs.getTimestamp("CreatedAt"));

                    policy.put("customerName",
                        rs.getString("FullName"));

                    policy.put("email",
                        rs.getString("Email"));

                    policy.put("mobile",
                        rs.getString("Mobile"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return policy;
    }

}
