package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.VHealthAssure.Connection.MySqlInstance;

public class AdminChangePasswordDao {

    // Verify current admin password
    public boolean verifyCurrentPassword(
            long adminId, String currentPassword) {

        String sql =
            "SELECT Password FROM admins WHERE AdminId = ?";

        try {

            Connection con =
                MySqlInstance.getinstance().getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setLong(1, adminId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        String storedPassword =
                            rs.getString("Password");

                        return storedPassword != null &&
                               storedPassword.equals(currentPassword);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // Update admin password
    public boolean updatePassword(
            long adminId, String newPassword) {

        String sql =
            "UPDATE admins SET Password = ? WHERE AdminId = ?";

        try {

            Connection con =
                MySqlInstance.getinstance().getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, newPassword);
                ps.setLong(2, adminId);

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}