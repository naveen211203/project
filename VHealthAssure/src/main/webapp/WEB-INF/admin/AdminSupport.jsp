<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="com.VHealthAssure.Entity.SupportEntity" %>

<%!
    private String esc(Object value) {
        if (value == null) return "";

        return value.toString()
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>

<%
    if (session == null ||
        session.getAttribute("loginId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }

    List<SupportEntity> tickets =
        (List<SupportEntity>) request.getAttribute("tickets");

    Map<String, Integer> statistics =
        (Map<String, Integer>) request.getAttribute("statistics");

    String search = (String) request.getAttribute("search");
    String selectedStatus =
        (String) request.getAttribute("selectedStatus");

    String adminName = (String) request.getAttribute("adminName");

    if (search == null) search = "";
    if (selectedStatus == null) selectedStatus = "ALL";

    if (adminName == null || adminName.trim().isEmpty()) {
        adminName = "Administrator";
    }

    String initial = adminName.substring(0, 1).toUpperCase();
    String ctx = request.getContextPath();
    String message = request.getParameter("message");

    int totalTickets = 0;
    int openTickets = 0;
    int inProgressTickets = 0;
    int resolvedTickets = 0;
    int closedTickets = 0;

    if (statistics != null) {
        totalTickets = statistics.getOrDefault("totalTickets", 0);
        openTickets = statistics.getOrDefault("openTickets", 0);
        inProgressTickets = statistics.getOrDefault("inProgressTickets", 0);
        resolvedTickets = statistics.getOrDefault("resolvedTickets", 0);
        closedTickets = statistics.getOrDefault("closedTickets", 0);
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Support Management | VHealthAssure</title>

<style>

:root {
    --primary: #0b2a4a;
    --dark: #071d33;
    --accent: #2563eb;
    --background: #f4f6fa;
    --text: #172033;
    --muted: #64748b;
    --border: #e5eaf1;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Poppins, Arial, sans-serif;
}

body {
    background: var(--background);
    color: var(--text);
    min-height: 100vh;
}

/* ================= HEADER ================= */

header {
    height: 68px;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;

    background: linear-gradient(135deg, var(--dark), var(--primary));
    color: white;

    display: flex;
    align-items: center;
    justify-content: space-between;

    padding: 0 30px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
}

.logo-box {
    width: 42px;
    height: 42px;
    background: white;
    border-radius: 10px;
    overflow: hidden;
}

.logo-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.brand h1 {
    font-size: 20px;
    font-weight: 600;
}

/* ================= ADMIN PROFILE ================= */

.admin-area {
    position: relative;
    display: flex;
    align-items: center;
    gap: 12px;
    cursor: pointer;
}

.avatar {
    width: 38px;
    height: 38px;
    background: var(--accent);
    border-radius: 50%;
    display: grid;
    place-items: center;
    font-weight: 600;
}

.admin-name {
    font-size: 14px;
    color: white;
}

.dropdown {
    display: none;
    position: absolute;
    right: 0;
    top: 48px;
    width: 180px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0,0,0,.15);
    overflow: hidden;
    z-index: 1100;
}

.admin-area.active .dropdown {
    display: block;
}

.dropdown a {
    display: block;
    padding: 13px 16px;
    color: var(--text);
    text-decoration: none;
    font-size: 13px;
}

.dropdown a:hover {
    background: #f1f5f9;
}

.dropdown .logout {
    color: #dc2626;
    border-top: 1px solid var(--border);
}

/* ================= LAYOUT ================= */

.layout {
    display: block;
    padding-top: 68px;
    min-height: 100vh;
}

/* ================= SIDEBAR ================= */

.sidebar {
    position: fixed;
    top: 68px;
    left: 0;
    bottom: 0;

    width: 245px;
    height: calc(100vh - 68px);

    background: #081a30;
    padding: 24px 15px;

    overflow-y: auto;
    z-index: 900;
}

.sidebar-heading {
    color: #94a3b8;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 1.3px;
    padding: 8px 13px 15px;
}

.sidebar a {
    display: block;
    padding: 13px 14px;
    margin-bottom: 6px;

    color: #cbd5e1;
    text-decoration: none;

    border-radius: 8px;
    font-size: 13px;
    transition: .2s;
}

.sidebar a:hover,
.sidebar a.active {
    background: #1e3a5f;
    color: white;
}

.sidebar a.active {
    border-left: 3px solid #60a5fa;
}

/* ================= MAIN CONTENT ================= */

main {
    margin-left: 245px;
    padding: 30px;
    min-height: calc(100vh - 68px);
    min-width: 0;
}

.page-heading {
    margin-bottom: 25px;
}

.page-heading h2 {
    color: var(--primary);
    font-size: 24px;
    margin-bottom: 6px;
}

.page-heading p {
    color: var(--muted);
    font-size: 13px;
}

/* ================= SUMMARY CARDS ================= */

.summary {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 18px;
    margin-bottom: 24px;
}

.summary-card {
    background: white;
    padding: 20px;
    border-radius: 12px;
    border: 1px solid var(--border);
}

.summary-card span {
    color: var(--muted);
    font-size: 13px;
}

.summary-card h3 {
    color: var(--primary);
    font-size: 25px;
    margin-top: 9px;
}

/* ================= PANEL ================= */

.panel {
    background: white;
    padding: 23px;
    border-radius: 13px;
    border: 1px solid var(--border);
    box-shadow: 0 5px 18px rgba(15,23,42,.04);
}

.panel-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
    margin-bottom: 20px;
}

.panel-heading h3 {
    color: var(--primary);
    font-size: 17px;
}

.filters {
    display: flex;
    gap: 9px;
    flex-wrap: wrap;
}

input, select {
    height: 40px;
    border: 1px solid #dbe2ea;
    border-radius: 7px;
    padding: 0 12px;
    font-size: 12px;
    outline: none;
    background: white;
}

input {
    width: 270px;
}

input:focus, select:focus, textarea:focus {
    border-color: var(--accent);
}

button {
    border: none;
    cursor: pointer;
    font-size: 11px;
    font-weight: 600;
    border-radius: 6px;
    transition: .2s;
}

.search-btn {
    height: 40px;
    padding: 0 17px;
    background: var(--accent);
    color: white;
    font-size: 12px;
}

.search-btn:hover {
    background: #1d4ed8;
}

.clear-link {
    display: inline-block;
    padding: 12px 14px;
    height: 40px;
    background: #eaf1ff;
    color: #1d4ed8;
    text-decoration: none;
    border-radius: 7px;
    font-size: 12px;
}

/* ================= TABLE ================= */

.table-wrap {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 1450px;
    border-collapse: collapse;
    font-size: 12px;
}

th {
    text-align: left;
    background: #f8fafc;
    color: #475569;
    padding: 15px 12px;
    font-weight: 600;
    white-space: nowrap;
}

td {
    padding: 14px 12px;
    border-bottom: 1px solid #edf0f4;
    color: #334155;
    vertical-align: top;
}

.ticket-number {
    color: var(--primary);
    font-weight: 600;
    white-space: nowrap;
}

.ticket-id {
    font-size: 10px;
    color: #94a3b8;
    margin-top: 4px;
}

.customer-name {
    color: var(--primary);
    font-weight: 600;
}

.ticket-subject {
    font-weight: 600;
    color: #334155;
    min-width: 150px;
}

.ticket-message {
    color: #64748b;
    line-height: 1.6;
    min-width: 220px;
    max-width: 280px;
    overflow-wrap: anywhere;
    white-space: pre-wrap;
}

.category {
    color: #475569;
    white-space: nowrap;
}

.date {
    white-space: nowrap;
    color: #64748b;
}

/* ================= STATUS ================= */

.status {
    display: inline-block;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 10px;
    font-weight: 600;
    white-space: nowrap;
}

.OPEN {
    background: #dbeafe;
    color: #1e40af;
}

.IN_PROGRESS {
    background: #fef3c7;
    color: #92400e;
}

.RESOLVED {
    background: #dcfce7;
    color: #166534;
}

.CLOSED {
    background: #e2e8f0;
    color: #475569;
}

/* ================= RESPONSE FORM ================= */

.response-form {
    min-width: 240px;
}

.response-form textarea {
    width: 100%;
    min-height: 85px;
    resize: vertical;
    border: 1px solid #dbe2ea;
    border-radius: 7px;
    padding: 10px;
    font-size: 12px;
    line-height: 1.5;
    outline: none;
    color: var(--text);
}

.response-form select {
    width: 100%;
    margin-top: 8px;
}

.update-btn {
    margin-top: 8px;
    padding: 9px 14px;
    background: var(--accent);
    color: white;
}

.update-btn:hover {
    background: #1d4ed8;
}

/* ================= EMPTY STATE ================= */

.empty {
    text-align: center;
    padding: 35px;
    color: var(--muted);
}

/* ================= ALERT MESSAGES ================= */

.alert {
    padding: 13px 16px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 13px;
}

.alert-success {
    background: #dcfce7;
    color: #166534;
    border: 1px solid #bbf7d0;
}

.alert-error {
    background: #fee2e2;
    color: #991b1b;
    border: 1px solid #fecaca;
}

/* ================= RESPONSIVE ================= */

@media(max-width: 1200px) {
    .summary {
        grid-template-columns: repeat(3, 1fr);
    }
}

@media(max-width: 1100px) {
    .summary {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media(max-width: 900px) {

    .sidebar {
        position: fixed;
        top: 68px;
        left: 0;
        right: 0;
        bottom: auto;

        width: 100%;
        height: auto;

        display: flex;
        gap: 5px;
        padding: 10px;
        overflow-x: auto;
    }

    .sidebar-heading {
        display: none;
    }

    .sidebar a {
        white-space: nowrap;
        flex-shrink: 0;
        margin: 0;
    }

    main {
        margin-left: 0;
        padding: 90px 18px 25px;
    }
}

@media(max-width: 650px) {

    .summary {
        grid-template-columns: 1fr;
    }

    .filters {
        width: 100%;
    }

    .filters input {
        width: 100%;
    }

    .admin-name {
        display: none;
    }

    .brand h1 {
        font-size: 17px;
    }
}

</style>

</head>

<body>

<!-- ================= HEADER ================= -->

<header>

    <div class="brand">

        <div class="logo-box">
            <img src="<%= ctx %>/images/logo.jpg"
                 alt="VHealthAssure Logo">
        </div>

        <h1>VHealthAssure</h1>

    </div>

    <div class="admin-area" id="adminArea">

        <div class="avatar">
            <%= esc(initial) %>
        </div>

        <div class="admin-name">
            <%= esc(adminName) %> ▾
        </div>

        <div class="dropdown">

            <a href="<%= ctx %>/AdminProfile">
                Admin Profile
            </a>

            <a href="<%= ctx %>/AdminChangePassword">
                Change Password
            </a>

            <a href="<%= ctx %>/logout" class="logout">
                Logout
            </a>

        </div>

    </div>

</header>

<div class="layout">

    <!-- ================= SIDEBAR ================= -->

    <aside class="sidebar">

        <div class="sidebar-heading">
            ADMIN MENU
        </div>

        <a href="<%= ctx %>/AdminDashboard">
            📊 Dashboard
        </a>

        <a href="<%= ctx %>/AdminUsers">
            👥 User Management
        </a>

        <a href="<%= ctx %>/AdminPolicies">
            📄 Policy Management
        </a>

        <a href="<%= ctx %>/AdminClaims">
            📋 Claims Management
        </a>

        <a href="<%= ctx %>/AdminKyc">
            🛡️ KYC Management
        </a>

        <a href="<%= ctx %>/AdminHospitals">
            🏥 Hospital Management
        </a>

        <a class="active" href="<%= ctx %>/AdminSupport">
            🎧 Support Management
        </a>

    </aside>

    <!-- ================= MAIN CONTENT ================= -->

    <main>

        <div class="page-heading">

            <h2>Support Management</h2>

            <p>
                Review customer support tickets, respond to queries
                and manage ticket status.
            </p>

        </div>

        <!-- SUMMARY CARDS -->

        <div class="summary">

            <div class="summary-card">
                <span>Total Tickets</span>
                <h3><%= totalTickets %></h3>
            </div>

            <div class="summary-card">
                <span>Open Tickets</span>
                <h3><%= openTickets %></h3>
            </div>

            <div class="summary-card">
                <span>In Progress</span>
                <h3><%= inProgressTickets %></h3>
            </div>

            <div class="summary-card">
                <span>Resolved Tickets</span>
                <h3><%= resolvedTickets %></h3>
            </div>

            <div class="summary-card">
                <span>Closed Tickets</span>
                <h3><%= closedTickets %></h3>
            </div>

        </div>

        <!-- STATUS MESSAGES -->

        <%
            if ("updated".equals(message)) {
        %>

            <div class="alert alert-success">
                Support ticket has been updated successfully.
            </div>

        <%
            } else if ("notUpdated".equals(message)) {
        %>

            <div class="alert alert-error">
                Ticket could not be updated. Please try again.
            </div>

        <%
            } else if ("invalidStatus".equals(message) ||
                       "invalidData".equals(message) ||
                       "invalidId".equals(message) ||
                       "ticketNotFound".equals(message)) {
        %>

            <div class="alert alert-error">
                Invalid ticket update request. Please check the details.
            </div>

        <%
            } else if ("responseTooLong".equals(message)) {
        %>

            <div class="alert alert-error">
                Admin response cannot exceed 5000 characters.
            </div>

        <%
            }
        %>

        <!-- SUPPORT TICKETS TABLE -->

        <div class="panel">

            <div class="panel-heading">

                <h3>Registered Support Tickets</h3>

                <form class="filters"
                      method="get"
                      action="<%= ctx %>/AdminSupport">

                    <input type="text"
                           name="search"
                           placeholder="Search ticket, customer, subject..."
                           value="<%= esc(search) %>">

                    <select name="status">

                        <option value="ALL"
                            <%= "ALL".equals(selectedStatus)
                                ? "selected" : "" %>>
                            All Status
                        </option>

                        <option value="OPEN"
                            <%= "OPEN".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Open
                        </option>

                        <option value="IN_PROGRESS"
                            <%= "IN_PROGRESS".equals(selectedStatus)
                                ? "selected" : "" %>>
                            In Progress
                        </option>

                        <option value="RESOLVED"
                            <%= "RESOLVED".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Resolved
                        </option>

                        <option value="CLOSED"
                            <%= "CLOSED".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Closed
                        </option>

                    </select>

                    <button type="submit" class="search-btn">
                        Search / Filter
                    </button>

                    <a class="clear-link"
                       href="<%= ctx %>/AdminSupport">
                        Clear
                    </a>

                </form>

            </div>

            <div class="table-wrap">

                <table>

                    <thead>

                        <tr>
                            <th>TICKET DETAILS</th>
                            <th>CUSTOMER</th>
                            <th>EMAIL</th>
                            <th>MOBILE</th>
                            <th>CATEGORY</th>
                            <th>SUBJECT</th>
                            <th>CUSTOMER MESSAGE</th>
                            <th>CREATED DATE</th>
                            <th>STATUS</th>
                            <th>ADMIN RESPONSE / ACTION</th>
                        </tr>

                    </thead>

                    <tbody>

                    <%
                        if (tickets != null && !tickets.isEmpty()) {

                            for (SupportEntity ticket : tickets) {

                                String statusValue = ticket.getStatus() == null
                                    ? "" : ticket.getStatus();

                                String statusLabel =
                                    statusValue.replace("_", " ");
                    %>

                        <tr>

                            <td>

                                <div class="ticket-number">
                                    <%= esc(ticket.getTicketNumber()) %>
                                </div>

                                <div class="ticket-id">
                                    ID: <%= ticket.getTicketId() %>
                                </div>

                            </td>

                            <td>
                                <div class="customer-name">
                                    <%= esc(ticket.getFullName()) %>
                                </div>
                            </td>

                            <td>
                                <%= esc(ticket.getEmail()) %>
                            </td>

                            <td>
                                <%= esc(ticket.getMobile()) %>
                            </td>

                            <td>
                                <span class="category">
                                    <%= esc(ticket.getCategory()) %>
                                </span>
                            </td>

                            <td>
                                <div class="ticket-subject">
                                    <%= esc(ticket.getSubject()) %>
                                </div>
                            </td>

                            <td>
                                <div class="ticket-message">
                                    <%= esc(ticket.getMessage()) %>
                                </div>
                            </td>

                            <td>
                                <div class="date">
                                    <%= esc(ticket.getCreatedAt()) %>
                                </div>
                            </td>

                            <td>
                                <span class="status <%= esc(statusValue) %>">
                                    <%= esc(statusLabel) %>
                                </span>
                            </td>

                            <td>

                                <form class="response-form"
                                      method="post"
                                      action="<%= ctx %>/AdminSupport"
                                      onsubmit="return confirm('Are you sure you want to update this support ticket?');">

                                    <input type="hidden"
                                           name="ticketId"
                                           value="<%= ticket.getTicketId() %>">

                                    <textarea name="adminResponse"
                                              maxlength="5000"
                                              placeholder="Enter admin response..."><%= esc(ticket.getAdminResponse()) %></textarea>

                                    <select name="status" required>

                                        <option value="OPEN"
                                            <%= "OPEN".equals(statusValue)
                                                ? "selected" : "" %>>
                                            Open
                                        </option>

                                        <option value="IN_PROGRESS"
                                            <%= "IN_PROGRESS".equals(statusValue)
                                                ? "selected" : "" %>>
                                            In Progress
                                        </option>

                                        <option value="RESOLVED"
                                            <%= "RESOLVED".equals(statusValue)
                                                ? "selected" : "" %>>
                                            Resolved
                                        </option>

                                        <option value="CLOSED"
                                            <%= "CLOSED".equals(statusValue)
                                                ? "selected" : "" %>>
                                            Closed
                                        </option>

                                    </select>

                                    <button type="submit" class="update-btn">
                                        Update Ticket
                                    </button>

                                </form>

                            </td>

                        </tr>

                    <%
                            }

                        } else {
                    %>

                        <tr>

                            <td colspan="10" class="empty">
                                No support tickets found.
                            </td>

                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

        </div>

    </main>

</div>

<!-- ================= PROFILE DROPDOWN JAVASCRIPT ================= -->

<script>

const adminArea = document.getElementById("adminArea");

adminArea.addEventListener("click", function(event) {
    event.stopPropagation();
    adminArea.classList.toggle("active");
});

document.addEventListener("click", function() {
    adminArea.classList.remove("active");
});

document.addEventListener("keydown", function(event) {
    if (event.key === "Escape") {
        adminArea.classList.remove("active");
    }
});

</script>

</body>
</html>