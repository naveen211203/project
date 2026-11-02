
package com.VHealthAssure.Dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.VHealthAssure.Connection.MySqlInstance;
import com.VHealthAssure.Entity.SupportEntity;

public class SupportDao {

    // Create a new support ticket
    public boolean createTicket(SupportEntity ticket) {

        String sql = "INSERT INTO support_tickets " +
                "(TicketNumber, UserId, Category, Subject, Message) " +
                "VALUES (?, ?, ?, ?, ?)";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();

            // Generate a ticket number
            String ticketNumber = "VHA-TKT-" +
                    UUID.randomUUID().toString()
                    .substring(0, 8).toUpperCase();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, ticketNumber);
            ps.setString(2, ticket.getUserId());
            ps.setString(3, ticket.getCategory());
            ps.setString(4, ticket.getSubject());
            ps.setString(5, ticket.getMessage());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Get tickets belonging to a particular user
    public List<SupportEntity> getTicketsByUser(String userId) {

        List<SupportEntity> tickets = new ArrayList<>();

        String sql = "SELECT * FROM support_tickets " +
                "WHERE UserId = ? ORDER BY CreatedAt DESC";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                SupportEntity ticket = new SupportEntity();

                ticket.setTicketId(rs.getInt("TicketId"));
                ticket.setTicketNumber(rs.getString("TicketNumber"));
                ticket.setUserId(rs.getString("UserId"));
                ticket.setCategory(rs.getString("Category"));
                ticket.setSubject(rs.getString("Subject"));
                ticket.setMessage(rs.getString("Message"));
                ticket.setAdminResponse(rs.getString("AdminResponse"));
                ticket.setStatus(rs.getString("Status"));
                ticket.setCreatedAt(rs.getTimestamp("CreatedAt"));
                ticket.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                tickets.add(ticket);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return tickets;
    }

    // Get all tickets for admin
    public List<SupportEntity> getAllTickets(String statusFilter) {

        List<SupportEntity> tickets = new ArrayList<>();

        String sql = "SELECT s.*, u.FullName, u.Email, u.Mobile " +
                "FROM support_tickets s " +
                "JOIN users u ON s.UserId = u.UserId ";

        boolean filter = statusFilter != null
                && !statusFilter.equalsIgnoreCase("ALL");

        if (filter) {
            sql += "WHERE s.Status = ? ";
        }

        sql += "ORDER BY s.CreatedAt DESC";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            if (filter) {
                ps.setString(1, statusFilter);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                SupportEntity ticket = new SupportEntity();

                ticket.setTicketId(rs.getInt("TicketId"));
                ticket.setTicketNumber(rs.getString("TicketNumber"));
                ticket.setUserId(rs.getString("UserId"));
                ticket.setFullName(rs.getString("FullName"));
                ticket.setEmail(rs.getString("Email"));
                ticket.setMobile(rs.getString("Mobile"));
                ticket.setCategory(rs.getString("Category"));
                ticket.setSubject(rs.getString("Subject"));
                ticket.setMessage(rs.getString("Message"));
                ticket.setAdminResponse(rs.getString("AdminResponse"));
                ticket.setStatus(rs.getString("Status"));
                ticket.setCreatedAt(rs.getTimestamp("CreatedAt"));
                ticket.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                tickets.add(ticket);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return tickets;
    }

    // Update admin response and ticket status
    public boolean updateTicket(int ticketId,
                                String adminResponse,
                                String status) {

        String sql = "UPDATE support_tickets " +
                "SET AdminResponse = ?, Status = ? " +
                "WHERE TicketId = ?";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, adminResponse);
            ps.setString(2, status);
            ps.setInt(3, ticketId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
