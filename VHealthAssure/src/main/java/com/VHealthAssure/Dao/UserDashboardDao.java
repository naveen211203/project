package com.VHealthAssure.Dao;

import java.sql.*;

import com.VHealthAssure.Connection.MySqlInstance;
import com.VHealthAssure.Entity.RegistrationEntity;

public class UserDashboardDao {
	
	public ResultSet getActivePolicy(String userId) throws Exception {
	    String sql = "SELECT PolicyNumber, PolicyType, Status " +
	                 "FROM policies WHERE UserId=? AND Status='ACTIVE' LIMIT 2";
	    Connection con = MySqlInstance.getinstance().getConnection();
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, userId);
	    return ps.executeQuery();
	}

	public ResultSet getRecentClaims(String userId) throws Exception {
	    String sql = "SELECT ClaimNumber, ClaimDate, Status " +
	                 "FROM claims WHERE UserId=? ORDER BY ClaimDate DESC LIMIT 2";
	    Connection con = MySqlInstance.getinstance().getConnection();
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, userId);
	    return ps.executeQuery();
	}

    public int getActivePolicies(String userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM policies WHERE UserId=? AND Status='ACTIVE'";
        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    public int getClaimsFiled(String userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM claims WHERE UserId=?";
        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    public int getApprovedClaims(String userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM claims WHERE UserId=? AND Status='APPROVED'";
        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }
    public ResultSet getNextPremium(String userId) throws Exception {

        String sql = "SELECT PremiumAmount, NextPremiumDate FROM policies WHERE UserId = ? AND Status = 'ACTIVE' AND NextPremiumDate >= CURDATE() ORDER BY NextPremiumDate ASC LIMIT 1";

        Connection con = MySqlInstance.getinstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userId);

        return ps.executeQuery();
    }


    public RegistrationEntity getUserById(String userId) throws Exception {

        String sql = "SELECT * FROM users WHERE UserId=?";
        RegistrationEntity user = null;

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new RegistrationEntity();
                user.setUserId(rs.getString("UserId"));
                user.setFullName(rs.getString("FullName"));
                user.setCity(rs.getString("City"));
                user.setKycStatus(rs.getString("KycStatus"));
            }
        }
        return user;
    }

    // ✅ Verify current password
    public boolean verifyCurrentPassword(String userId, String currentPassword) {

        String sql = "SELECT Password FROM users WHERE UserId = ?";

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("Password");
                boolean match = currentPassword.equals(dbPassword);
                System.out.println("Password match result: " + match);
                return match;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Update password (hashed)
    public boolean updatePassword(String userId, String newPassword) {

        String sql = "UPDATE users SET Password = ? WHERE UserId = ?";

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newPassword); 
            ps.setString(2, userId);
            
            int rows = ps.executeUpdate();
            System.out.println("Password update rows affected: " + rows);
            return rows == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
