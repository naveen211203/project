package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

import com.VHealthAssure.Connection.MySqlInstance;

public class AdminProfileDao {

    // Retrieve admin profile using AdminId
    public Map<String, Object> getAdminProfile(long adminId) {

        Map<String, Object> admin = null;

        String sql =
            "SELECT AdminId, FullName, Email, Mobile, Role, Status, " +
            "CreatedAt, LastLogin " +
            "FROM admins WHERE AdminId = ?";

        try {

            Connection con =
                MySqlInstance.getinstance().getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setLong(1, adminId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        admin = new LinkedHashMap<>();

                        admin.put("adminId",
                            rs.getLong("AdminId"));

                        admin.put("fullName",
                            rs.getString("FullName"));

                        admin.put("email",
                            rs.getString("Email"));

                        admin.put("mobile",
                            rs.getString("Mobile"));

                        admin.put("role",
                            rs.getString("Role"));

                        admin.put("status",
                            rs.getString("Status"));

                        admin.put("createdAt",
                            rs.getTimestamp("CreatedAt"));

                        admin.put("lastLogin",
                            rs.getTimestamp("LastLogin"));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return admin;
    }
}