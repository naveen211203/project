package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.VHealthAssure.Connection.MySqlInstance;
import com.VHealthAssure.Entity.PolicyEntity;

public class MyPoliciesDao {

    public List<PolicyEntity> getPoliciesByUserId(String userId)
            throws Exception {

        List<PolicyEntity> policies = new ArrayList<>();

        String sql =
            "SELECT PolicyNumber, PolicyType, Status, PremiumAmount, " +
            "NextPremiumDate, CreatedAt " +
            "FROM policies WHERE UserId=? " +
            "ORDER BY CreatedAt DESC";

        try (Connection con =
                 MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    PolicyEntity policy = new PolicyEntity();

                    policy.setPolicyNumber(
                        rs.getString("PolicyNumber"));

                    policy.setPolicyType(
                        rs.getString("PolicyType"));

                    policy.setStatus(
                        rs.getString("Status"));

                    policy.setPremiumAmount(
                        rs.getBigDecimal("PremiumAmount"));

                    policy.setNextPremiumDate(
                        rs.getDate("NextPremiumDate"));

                    policy.setCreatedAt(
                        rs.getDate("CreatedAt"));

                    policies.add(policy);
                }
            }
        }

        return policies;
    }
}