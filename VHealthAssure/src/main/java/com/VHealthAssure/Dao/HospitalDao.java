package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.VHealthAssure.Connection.MySqlInstance;
import com.VHealthAssure.Entity.HospitalEntity;

public class HospitalDao {

    public List<HospitalEntity> getActiveHospitals() {

        List<HospitalEntity> hospitals = new ArrayList<>();

        String sql = "SELECT HospitalId, HospitalName, Address, City, State, "
                   + "ContactNumber, Email, NetworkStatus "
                   + "FROM hospitals "
                   + "WHERE NetworkStatus = 'ACTIVE' "
                   + "ORDER BY HospitalName ASC";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    HospitalEntity hospital = new HospitalEntity();

                    hospital.setHospitalId(rs.getInt("HospitalId"));
                    hospital.setHospitalName(rs.getString("HospitalName"));
                    hospital.setAddress(rs.getString("Address"));
                    hospital.setCity(rs.getString("City"));
                    hospital.setState(rs.getString("State"));
                    hospital.setContactNumber(rs.getString("ContactNumber"));
                    hospital.setEmail(rs.getString("Email"));
                    hospital.setNetworkStatus(rs.getString("NetworkStatus"));

                    hospitals.add(hospital);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hospitals;
    }
    
    public List<HospitalEntity> getActiveHospitalsByCity(String city) {

        List<HospitalEntity> hospitals = new ArrayList<>();

        if (city == null || city.trim().isEmpty()) {
            return hospitals;
        }

        String sql = "SELECT HospitalId, HospitalName, Address, City, State, " +
                     "ContactNumber, Email, NetworkStatus " +
                     "FROM hospitals " +
                     "WHERE NetworkStatus = 'ACTIVE' " +
                     "AND LOWER(TRIM(City)) = LOWER(TRIM(?)) " +
                     "ORDER BY HospitalName ASC";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, city.trim());

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                HospitalEntity hospital = new HospitalEntity();

                hospital.setHospitalId(rs.getInt("HospitalId"));
                hospital.setHospitalName(rs.getString("HospitalName"));
                hospital.setAddress(rs.getString("Address"));
                hospital.setCity(rs.getString("City"));
                hospital.setState(rs.getString("State"));
                hospital.setContactNumber(rs.getString("ContactNumber"));
                hospital.setEmail(rs.getString("Email"));
                hospital.setNetworkStatus(rs.getString("NetworkStatus"));

                hospitals.add(hospital);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return hospitals;
    }
}
