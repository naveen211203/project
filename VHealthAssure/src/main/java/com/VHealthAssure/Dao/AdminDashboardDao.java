package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

import com.VHealthAssure.Connection.MySqlInstance;

public class AdminDashboardDao {

    public Map<String, Long> getDashboardStats() {

        Map<String, Long> stats = new LinkedHashMap<>();

        String sql =
            "SELECT " +
            "(SELECT COUNT(*) FROM users) AS totalUsers, " +
            "(SELECT COUNT(*) FROM users WHERE Status = 'ACTIVE') AS activeUsers, " +
            "(SELECT COUNT(*) FROM policies) AS totalPolicies, " +
            "(SELECT COUNT(*) FROM policies WHERE Status = 'ACTIVE') AS activePolicies, " +
            "(SELECT COUNT(*) FROM claims) AS totalClaims, " +
            "(SELECT COUNT(*) FROM claims WHERE Status = 'UNDER_REVIEW') AS pendingClaims, " +
            "(SELECT COUNT(*) FROM kyc_documents WHERE Status = 'PENDING') AS pendingKyc, " +
            "(SELECT COUNT(*) FROM hospitals WHERE NetworkStatus = 'ACTIVE') AS activeHospitals, " +
            "(SELECT COUNT(*) FROM support_tickets WHERE Status = 'OPEN') AS openTickets";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    stats.put("totalUsers", rs.getLong("totalUsers"));
                    stats.put("activeUsers", rs.getLong("activeUsers"));
                    stats.put("totalPolicies", rs.getLong("totalPolicies"));
                    stats.put("activePolicies", rs.getLong("activePolicies"));
                    stats.put("totalClaims", rs.getLong("totalClaims"));
                    stats.put("pendingClaims", rs.getLong("pendingClaims"));
                    stats.put("pendingKyc", rs.getLong("pendingKyc"));
                    stats.put("activeHospitals", rs.getLong("activeHospitals"));
                    stats.put("openTickets", rs.getLong("openTickets"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return stats;
    }
}