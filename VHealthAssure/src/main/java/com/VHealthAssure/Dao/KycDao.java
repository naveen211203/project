package com.VHealthAssure.Dao;

import java.sql.*;
import com.VHealthAssure.Connection.MySqlInstance;

public class KycDao {

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

    public int getKycAttemptCount(String userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM kyc_documents WHERE UserId=?";
        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    public void insertKycDocument(
            String kycId,
            String userId,
            String govIdType,
            String govIdNumber,
            String documentPath,
            String documentType,
            int attemptNumber
    ) throws Exception {

        String sql = "INSERT INTO kyc_documents (KycId, UserId, GovIdType, GovIdNumber, DocumentPath, DocumentType, AttemptNumber, Status) VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, kycId);
            ps.setString(2, userId);
            ps.setString(3, govIdType);
            ps.setString(4, govIdNumber);
            ps.setString(5, documentPath);
            ps.setString(6, documentType);
            ps.setInt(7, attemptNumber);

            ps.executeUpdate(); // ✅ THIS WAS FAILING EARLIER
        }
    }

    public void updateUserKycStatus(String userId, String status) throws Exception {
        String sql = "UPDATE users SET KycStatus=? WHERE UserId=?";
        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, userId);
            ps.executeUpdate();
        }
    }

    public ResultSet getLatestKycDocument(String userId) throws Exception {
        String sql = "SELECT * FROM kyc_documents WHERE UserId=? ORDER BY UploadedAt DESC LIMIT 1";
        Connection con = MySqlInstance.getinstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userId);
        return ps.executeQuery();
    }

    public ResultSet getUserGovIdDetails(String userId) throws Exception {
        String sql = "SELECT GovIdType, GovIdNumber FROM users WHERE UserId=?";
        Connection con = MySqlInstance.getinstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userId);
        return ps.executeQuery();
    }

    public String getUserName(String userId) throws Exception {
        String sql = "SELECT FullName FROM users WHERE UserId=?";
        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("FullName");
        }
        return "User";
    }
}
