package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.VHealthAssure.Connection.MySqlInstance;

public class AdminHospitalsDao {

    private Connection getConnection() throws SQLException {
        return MySqlInstance.getinstance().getConnection();
    }

    // Get all hospitals with search and status filters
    public List<Map<String, Object>> getAllHospitals(
            String search, String status) {

        List<Map<String, Object>> hospitals = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT HospitalId, HospitalName, Address, City, State, " +
            "ContactNumber, Email, NetworkStatus, CreatedAt " +
            "FROM hospitals WHERE 1=1 "
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append(
                "AND (HospitalName LIKE ? OR City LIKE ? OR State LIKE ? " +
                "OR Email LIKE ? OR ContactNumber LIKE ?) "
            );
        }

        if (status != null &&
            (status.equals("ACTIVE") || status.equals("INACTIVE"))) {
            sql.append("AND NetworkStatus = ? ");
        }

        sql.append("ORDER BY HospitalId DESC");

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;

            if (search != null && !search.trim().isEmpty()) {
                String keyword = "%" + search.trim() + "%";

                for (int i = 0; i < 5; i++) {
                    ps.setString(index++, keyword);
                }
            }

            if (status != null &&
                (status.equals("ACTIVE") || status.equals("INACTIVE"))) {
                ps.setString(index++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> hospital = new HashMap<>();

                    hospital.put("hospitalId", rs.getInt("HospitalId"));
                    hospital.put("hospitalName", rs.getString("HospitalName"));
                    hospital.put("address", rs.getString("Address"));
                    hospital.put("city", rs.getString("City"));
                    hospital.put("state", rs.getString("State"));
                    hospital.put("contactNumber", rs.getString("ContactNumber"));
                    hospital.put("email", rs.getString("Email"));
                    hospital.put("networkStatus", rs.getString("NetworkStatus"));
                    hospital.put("createdAt", rs.getTimestamp("CreatedAt"));

                    hospitals.add(hospital);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hospitals;
    }

    // Get hospital statistics
    public Map<String, Integer> getHospitalStatistics() {

        Map<String, Integer> statistics = new HashMap<>();

        String sql =
            "SELECT COUNT(*) AS totalHospitals, " +
            "SUM(CASE WHEN NetworkStatus = 'ACTIVE' THEN 1 ELSE 0 END) AS activeHospitals, " +
            "SUM(CASE WHEN NetworkStatus = 'INACTIVE' THEN 1 ELSE 0 END) AS inactiveHospitals " +
            "FROM hospitals";

        try (Connection con = getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                statistics.put("totalHospitals", rs.getInt("totalHospitals"));
                statistics.put("activeHospitals", rs.getInt("activeHospitals"));
                statistics.put("inactiveHospitals", rs.getInt("inactiveHospitals"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statistics;
    }

    // Get one hospital by ID
    public Map<String, Object> getHospitalById(int hospitalId) {

        Map<String, Object> hospital = null;

        String sql =
            "SELECT HospitalId, HospitalName, Address, City, State, " +
            "ContactNumber, Email, NetworkStatus, CreatedAt " +
            "FROM hospitals WHERE HospitalId = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, hospitalId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    hospital = new HashMap<>();

                    hospital.put("hospitalId", rs.getInt("HospitalId"));
                    hospital.put("hospitalName", rs.getString("HospitalName"));
                    hospital.put("address", rs.getString("Address"));
                    hospital.put("city", rs.getString("City"));
                    hospital.put("state", rs.getString("State"));
                    hospital.put("contactNumber", rs.getString("ContactNumber"));
                    hospital.put("email", rs.getString("Email"));
                    hospital.put("networkStatus", rs.getString("NetworkStatus"));
                    hospital.put("createdAt", rs.getTimestamp("CreatedAt"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hospital;
    }

    // Add a new hospital
    public boolean addHospital(Map<String, String> hospital) {

        String sql =
            "INSERT INTO hospitals " +
            "(HospitalName, Address, City, State, ContactNumber, Email, NetworkStatus) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hospital.get("hospitalName"));
            ps.setString(2, hospital.get("address"));
            ps.setString(3, hospital.get("city"));
            ps.setString(4, hospital.get("state"));
            ps.setString(5, hospital.get("contactNumber"));
            ps.setString(6, hospital.get("email"));
            ps.setString(7, hospital.get("networkStatus"));

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update hospital details
    public boolean updateHospital(int hospitalId, Map<String, String> hospital) {

        String sql =
            "UPDATE hospitals SET HospitalName = ?, Address = ?, City = ?, " +
            "State = ?, ContactNumber = ?, Email = ?, NetworkStatus = ? " +
            "WHERE HospitalId = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hospital.get("hospitalName"));
            ps.setString(2, hospital.get("address"));
            ps.setString(3, hospital.get("city"));
            ps.setString(4, hospital.get("state"));
            ps.setString(5, hospital.get("contactNumber"));
            ps.setString(6, hospital.get("email"));
            ps.setString(7, hospital.get("networkStatus"));
            ps.setInt(8, hospitalId);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Activate or deactivate a hospital
    public boolean updateHospitalStatus(int hospitalId, String status) {

        if (!"ACTIVE".equals(status) && !"INACTIVE".equals(status)) {
            return false;
        }

        String sql =
            "UPDATE hospitals SET NetworkStatus = ? WHERE HospitalId = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, hospitalId);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    // Delete a hospital
    public boolean deleteHospital(int hospitalId) {

        String sql = "DELETE FROM hospitals WHERE HospitalId = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, hospitalId);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}