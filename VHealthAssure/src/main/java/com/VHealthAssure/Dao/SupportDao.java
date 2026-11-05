package com.VHealthAssure.Dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    // Get all tickets with search and status filter
    public List<SupportEntity> getAllTickets(String search, String statusFilter) {

        List<SupportEntity> tickets = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT s.*, u.FullName, u.Email, u.Mobile " +
            "FROM support_tickets s " +
            "JOIN users u ON s.UserId = u.UserId WHERE 1=1 "
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append(
                "AND (s.TicketNumber LIKE ? OR u.FullName LIKE ? " +
                "OR u.Email LIKE ? OR u.Mobile LIKE ? OR s.Subject LIKE ?) "
            );
        }

        if (statusFilter != null &&
            ("OPEN".equals(statusFilter) ||
             "IN_PROGRESS".equals(statusFilter) ||
             "RESOLVED".equals(statusFilter) ||
             "CLOSED".equals(statusFilter))) {

            sql.append("AND s.Status = ? ");
        }

        sql.append("ORDER BY s.TicketId DESC");

        try {
            Connection con = MySqlInstance.getinstance().getConnection();
            PreparedStatement ps = con.prepareStatement(sql.toString());

            int index = 1;

            if (search != null && !search.trim().isEmpty()) {

                String keyword = "%" + search.trim() + "%";

                for (int i = 0; i < 5; i++) {
                    ps.setString(index++, keyword);
                }
            }

            if (statusFilter != null &&
                ("OPEN".equals(statusFilter) ||
                 "IN_PROGRESS".equals(statusFilter) ||
                 "RESOLVED".equals(statusFilter) ||
                 "CLOSED".equals(statusFilter))) {

                ps.setString(index++, statusFilter);
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

    // Get support ticket statistics
    public Map<String, Integer> getTicketStatistics() {

        Map<String, Integer> statistics = new HashMap<>();

        String sql =
            "SELECT COUNT(*) AS totalTickets, " +
            "SUM(CASE WHEN Status='OPEN' THEN 1 ELSE 0 END) AS openTickets, " +
            "SUM(CASE WHEN Status='IN_PROGRESS' THEN 1 ELSE 0 END) AS inProgressTickets, " +
            "SUM(CASE WHEN Status='RESOLVED' THEN 1 ELSE 0 END) AS resolvedTickets, " +
            "SUM(CASE WHEN Status='CLOSED' THEN 1 ELSE 0 END) AS closedTickets " +
            "FROM support_tickets";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                statistics.put("totalTickets", rs.getInt("totalTickets"));
                statistics.put("openTickets", rs.getInt("openTickets"));
                statistics.put("inProgressTickets", rs.getInt("inProgressTickets"));
                statistics.put("resolvedTickets", rs.getInt("resolvedTickets"));
                statistics.put("closedTickets", rs.getInt("closedTickets"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return statistics;
    }

    // Get one ticket by ID
    public SupportEntity getTicketById(int ticketId) {

        SupportEntity ticket = null;

        String sql =
            "SELECT s.*, u.FullName, u.Email, u.Mobile " +
            "FROM support_tickets s " +
            "JOIN users u ON s.UserId = u.UserId " +
            "WHERE s.TicketId = ?";

        try {
            Connection con = MySqlInstance.getinstance().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, ticketId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                ticket = new SupportEntity();

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
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ticket;
    }

    // Update admin response and ticket status
    public boolean updateTicket(int ticketId,
                                String adminResponse,
                                String status) {

        if (!"OPEN".equals(status) &&
            !"IN_PROGRESS".equals(status) &&
            !"RESOLVED".equals(status) &&
            !"CLOSED".equals(status)) {

            return false;
        }

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