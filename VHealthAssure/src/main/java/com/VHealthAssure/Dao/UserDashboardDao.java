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
    public String getUserKycStatus(String userId) throws Exception {
        String sql = "SELECT KycStatus FROM users WHERE UserId=?";
        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("KycStatus");
        }
        return "NOT VERIFIED";
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

                // BASIC
                user.setUserId(rs.getString("UserId"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setMobile(rs.getString("Mobile"));
                user.setPassword(rs.getString("Password"));

                // KYC / IDENTITY
                user.setGovIdType(rs.getString("GovIdType"));
                user.setGovIdNumber(rs.getString("GovIdNumber"));
                user.setDateOfBirth(
                    rs.getDate("DateOfBirth") != null
                        ? rs.getDate("DateOfBirth").toString()
                        : null
                );
                user.setGender(rs.getString("Gender"));

                // ADDRESS
                user.setAddressLine1(rs.getString("AddressLine1"));
                user.setAddressLine2(rs.getString("AddressLine2"));
                user.setCity(rs.getString("City"));
                user.setState(rs.getString("State"));
                user.setPostalCode(rs.getString("PostalCode"));
                user.setCountry(rs.getString("Country"));

                // NOMINEE
                user.setNomineeName(rs.getString("NomineeName"));
                user.setNomineeRelation(rs.getString("NomineeRelation"));
                user.setNomineeDob(
                    rs.getDate("NomineeDob") != null
                        ? rs.getDate("NomineeDob").toString()
                        : null
                );
                user.setNomineeShare(rs.getDouble("NomineeShare"));

                // EMPLOYMENT / FINANCIAL
                user.setEmploymentStatus(rs.getString("EmploymentStatus"));
                user.setAnnualIncome(rs.getDouble("AnnualIncome"));
                user.setOccupation(rs.getString("Occupation"));
                user.setCompany(rs.getString("Company"));

                // SYSTEM / SECURITY
                user.setEmailVerified(rs.getBoolean("EmailVerified"));
                user.setMobileVerified(rs.getBoolean("MobileVerified"));
                user.setKycStatus(rs.getString("KycStatus"));
                user.setRole(rs.getString("Role"));
                user.setStatus(rs.getString("Status"));

                user.setCreatedAt(
                    rs.getTimestamp("CreatedAt") != null
                        ? rs.getTimestamp("CreatedAt").toString()
                        : null
                );
                user.setUpdatedAt(
                    rs.getTimestamp("UpdatedAt") != null
                        ? rs.getTimestamp("UpdatedAt").toString()
                        : null
                );
            }
        }
        return user;
    }
    
    
    public void updateUserDetails(RegistrationEntity u, String section) throws Exception {

        String sql = null;

        if ("PERSONAL".equals(section)) {
            sql = "UPDATE users SET FullName=?, DateOfBirth=?, Gender=?, City=? WHERE UserId=?";
        } 
        else if ("CONTACT".equals(section)) {
            sql = "UPDATE users SET Email=?, Mobile=?, PostalCode=? WHERE UserId=?";
        } 
        else if ("NOMINEE".equals(section)) {
            sql = "UPDATE users SET NomineeName=?, NomineeRelation=?, NomineeDob=?, NomineeShare=? WHERE UserId=?";
        } 
        else if ("EMPLOYMENT".equals(section)) {
            sql = "UPDATE users SET EmploymentStatus=?, AnnualIncome=?, Occupation=?, Company=? WHERE UserId=?";
        }

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;

            if ("PERSONAL".equals(section)) {
                ps.setString(i++, u.getFullName());
                ps.setString(i++, u.getDateOfBirth());
                ps.setString(i++, u.getGender());
                ps.setString(i++, u.getCity());
            }
            else if ("CONTACT".equals(section)) {
                ps.setString(i++, u.getEmail());
                ps.setString(i++, u.getMobile());
                ps.setString(i++, u.getPostalCode());
            }
            else if ("NOMINEE".equals(section)) {
                ps.setString(i++, u.getNomineeName());
                ps.setString(i++, u.getNomineeRelation());
                ps.setString(i++, u.getNomineeDob());
                ps.setDouble(i++, u.getNomineeShare());
            }
            else if ("EMPLOYMENT".equals(section)) {
                ps.setString(i++, u.getEmploymentStatus());
                ps.setDouble(i++, u.getAnnualIncome());
                ps.setString(i++, u.getOccupation());
                ps.setString(i++, u.getCompany());
            }

            ps.setString(i, u.getUserId());
            ps.executeUpdate();
        }
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
