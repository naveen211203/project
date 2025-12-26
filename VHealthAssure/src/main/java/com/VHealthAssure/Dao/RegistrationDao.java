package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import com.VHealthAssure.Connection.MySqlInstance;
import com.VHealthAssure.Entity.RegistrationEntity;

public class RegistrationDao {

    // NOTE: Removed CreatedAt / UpdatedAt from INSERT to avoid datetime format issues.
    private static final String INSERT_SQL =
        "INSERT INTO users ("
        + "UserId, FullName, Email, Mobile, Password, "
        + "GovIdType, GovIdNumber, DateOfBirth, Gender, "
        + "AddressLine1, AddressLine2, City, State, PostalCode, Country, "
        + "NomineeName, NomineeRelation, NomineeDob, NomineeShare, "
        + "EmploymentStatus, AnnualIncome, "
        + "EmailVerified, MobileVerified, KycStatus, Role, Status"
        + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

    public boolean registerUser(RegistrationEntity user) {
        if (user == null || user.getUserId() == null) return false;
        boolean inserted = false;

        // Normalize GovIdType to uppercase and validate simple set (defensive).
        String govType = user.getGovIdType();
        if (govType != null) govType = govType.trim().toUpperCase();
        // If you want to support VOTER, add it to the DB enum OR add it here and update DB
        if (govType != null && !govType.isEmpty()) {
            if (!("AADHAAR".equals(govType) || "PAN".equals(govType) || "DL".equals(govType) || "PASSPORT".equals(govType) || "VOTER".equals(govType))) {
                System.err.println("RegistrationDao: illegal GovIdType -> " + govType);
                return false;
            }
        }

        try (Connection con = MySqlInstance.getinstance().getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_SQL)) {

            int i = 1;
            ps.setString(i++, user.getUserId());
            ps.setString(i++, safe(user.getFullName()));
            ps.setString(i++, safe(user.getEmail()));
            ps.setString(i++, safe(user.getMobile()));
            ps.setString(i++, safe(user.getPassword()));

            ps.setString(i++, govType);
            ps.setString(i++, user.getGovIdNumber() == null ? null : user.getGovIdNumber().trim().toUpperCase());

            // DateOfBirth
            if (user.getDateOfBirth() == null || user.getDateOfBirth().trim().isEmpty()) {
                ps.setNull(i++, Types.DATE);
            } else {
                try {
                    LocalDate ld = LocalDate.parse(user.getDateOfBirth());
                    ps.setDate(i++, Date.valueOf(ld));
                } catch (DateTimeParseException ex) {
                    ps.setNull(i++, Types.DATE);
                }
            }

            ps.setString(i++, safe(user.getGender()));
            ps.setString(i++, safe(user.getAddressLine1()));
            ps.setString(i++, safe(user.getAddressLine2()));
            ps.setString(i++, safe(user.getCity()));
            ps.setString(i++, safe(user.getState()));
            ps.setString(i++, safe(user.getPostalCode()));
            ps.setString(i++, safe(user.getCountry()));

            ps.setString(i++, safe(user.getNomineeName()));
            ps.setString(i++, safe(user.getNomineeRelation()));

            if (user.getNomineeDob() == null || user.getNomineeDob().trim().isEmpty()) {
                ps.setNull(i++, Types.DATE);
            } else {
                try {
                    LocalDate ld2 = LocalDate.parse(user.getNomineeDob());
                    ps.setDate(i++, Date.valueOf(ld2));
                } catch (DateTimeParseException ex) {
                    ps.setNull(i++, Types.DATE);
                }
            }

            ps.setDouble(i++, user.getNomineeShare());
            ps.setString(i++, safe(user.getEmploymentStatus()));
            ps.setDouble(i++, user.getAnnualIncome());

            ps.setBoolean(i++, user.isEmailVerified());
            ps.setBoolean(i++, user.isMobileVerified());

            ps.setString(i++, safe(user.getKycStatus()));
            ps.setString(i++, safe(user.getRole()));
            ps.setString(i++, safe(user.getStatus()));

            int rows = ps.executeUpdate();
            inserted = rows > 0;

        } catch (SQLException e) {
            System.err.println("RegistrationDao - SQLException:");
            System.err.println("Message : " + e.getMessage());
            System.err.println("SQLState : " + e.getSQLState());
            System.err.println("ErrorCode: " + e.getErrorCode());
            e.printStackTrace();
            inserted = false;
        }

        return inserted;
    }

    private String safe(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}