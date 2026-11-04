
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List,java.util.Map,java.sql.Timestamp" %>
<%@ page import="java.net.URLEncoder" %>

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

    List<Map<String, Object>> users =
        (List<Map<String, Object>>) request.getAttribute("users");

    String search = (String) request.getAttribute("search");

    String selectedStatus =
        (String) request.getAttribute("selectedStatus");

    String adminName =
        (String) request.getAttribute("adminName");

    if (adminName == null) adminName = "Administrator";
    if (search == null) search = "";
    if (selectedStatus == null) selectedStatus = "ALL";

    String initial = adminName.isEmpty()
        ? "A" : adminName.substring(0, 1).toUpperCase();

    String ctx = request.getContextPath();
    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>User Management | VHealthAssure</title>

<style>

:root {
    --primary: #0b2a4a;
    --dark: #071d33;
    --accent: #2563eb;
    --background: #f4f6fa;
    --text: #172033;
    --muted: #64748b;
    --border: #e5eaf1;
    --white: #ffffff;
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

    background: linear-gradient(
        135deg,
        var(--dark),
        var(--primary)
    );

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

.logo {
    width: 42px;
    height: 42px;
    background: white;
    border-radius: 10px;
    overflow: hidden;
}

.logo img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.brand h1 {
    font-size: 20px;
    font-weight: 600;
}

/* ================= ADMIN PROFILE DROPDOWN ================= */

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

/* ================= SUMMARY ================= */

.summary {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
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

/* ================= TABLE PANEL ================= */

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

input,
select {
    height: 40px;

    border: 1px solid #dbe2ea;
    border-radius: 7px;

    padding: 0 12px;
    font-size: 12px;

    outline: none;
    background: white;
}

input {
    width: 250px;
}

input:focus,
select:focus {
    border-color: var(--accent);
}

button {
    height: 40px;
    padding: 0 17px;

    background: var(--accent);
    color: white;

    border: none;
    border-radius: 7px;

    cursor: pointer;
    font-size: 12px;
    font-weight: 600;
}

button:hover {
    background: #1d4ed8;
}

/* ================= TABLE ================= */

.table-wrap {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 1100px;
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
    vertical-align: middle;
}

.user-name {
    color: var(--primary);
    font-weight: 600;
}

.user-id {
    font-size: 10px;
    color: #94a3b8;
    margin-top: 4px;
    overflow-wrap: anywhere;
}

.status {
    display: inline-block;
    padding: 5px 10px;

    border-radius: 20px;
    font-size: 10px;
    font-weight: 600;
}

.ACTIVE {
    background: #dcfce7;
    color: #166534;
}

.INACTIVE {
    background: #e2e8f0;
    color: #475569;
}

.SUSPENDED {
    background: #fee2e2;
    color: #991b1b;
}

.kyc {
    display: inline-block;
    padding: 5px 9px;

    background: #eaf1ff;
    color: #1d4ed8;

    border-radius: 20px;
    font-size: 10px;
    font-weight: 600;
}

.view-link {
    display: inline-block;
    padding: 7px 11px;

    background: #eaf1ff;
    color: #1d4ed8;

    border-radius: 6px;
    text-decoration: none;

    font-size: 11px;
    font-weight: 600;
    margin-bottom: 8px;
}

.view-link:hover {
    background: #dbeafe;
}

.action-form {
    display: flex;
    align-items: center;
    gap: 6px;
}

.action-form select {
    width: 112px;
    height: 34px;
    font-size: 11px;
}

.action-form button {
    height: 34px;
    padding: 0 10px;
    font-size: 11px;
}

.empty {
    text-align: center;
    padding: 35px;
    color: var(--muted);
}

/* ================= ALERTS ================= */

.alert {
    padding: 13px 16px;
    border-radius: 8px;

    margin-bottom: 18px;
    font-size: 13px;
}

.success {
    background: #dcfce7;
    color: #166534;
}

.error {
    background: #fee2e2;
    color: #991b1b;
}

/* ================= RESPONSIVE ================= */

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

    .brand h1 {
        font-size: 17px;
    }

    .admin-name {
        font-size: 12px;
    }
}

</style>
</head>

<body>

<!-- ================= HEADER ================= -->

<header>

    <div class="brand">

        <div class="logo">
            <img src="<%= ctx %>/images/logo.jpg"
                 alt="VHealthAssure Logo">
        </div>

        <h1>VHealthAssure</h1>

    </div>

    <div class="admin-area" id="adminArea">

        <div class="avatar">
            <%= initial %>
        </div>

        <div class="admin-name">
            <%= esc(adminName) %> ▾
        </div>

        <div class="dropdown">

            <a href="#">Admin Profile</a>

            <a href="#">Change Password</a>

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

        <a class="active" href="<%= ctx %>/AdminUsers">
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

        <a href="<%= ctx %>/AdminSupport">
            🎧 Support Management
        </a>

    </aside>


    <!-- ================= MAIN ================= -->

    <main>

        <div class="page-heading">

            <h2>User Management</h2>

            <p>
                View, search and manage registered VHealthAssure customers.
            </p>

        </div>


        <!-- ================= ALERT MESSAGES ================= -->

        <% if ("updated".equals(message)) { %>

            <div class="alert success">
                Customer account status updated successfully.
            </div>

        <% } else if ("failed".equals(message)) { %>

            <div class="alert error">
                Unable to update customer status.
            </div>

        <% } else if ("notfound".equals(message)) { %>

            <div class="alert error">
                Customer record was not found.
            </div>

        <% } %>


        <!-- ================= SUMMARY ================= -->

        <div class="summary">

            <div class="summary-card">

                <span>Customers Displayed</span>

                <h3>
                    <%= users == null ? 0 : users.size() %>
                </h3>

            </div>


            <div class="summary-card">

                <span>Current Status Filter</span>

                <h3 style="font-size:19px;">
                    <%= esc(selectedStatus) %>
                </h3>

            </div>


            <div class="summary-card">

                <span>Account Category</span>

                <h3 style="font-size:19px;">
                    Registered Users
                </h3>

            </div>

        </div>


        <!-- ================= CUSTOMER TABLE ================= -->

        <div class="panel">

            <div class="panel-heading">

                <h3>Registered Customers</h3>


                <!-- SEARCH AND FILTER -->

                <form class="filters"
                      method="get"
                      action="<%= ctx %>/AdminUsers">

                    <input
                        type="text"
                        name="search"
                        placeholder="Search name, email, mobile or ID"
                        value="<%= esc(search) %>"
                    >


                    <select name="status">

                        <option value="ALL"
                            <%= "ALL".equals(selectedStatus)
                                ? "selected" : "" %>>
                            All Status
                        </option>

                        <option value="ACTIVE"
                            <%= "ACTIVE".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Active
                        </option>

                        <option value="INACTIVE"
                            <%= "INACTIVE".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Inactive
                        </option>

                        <option value="SUSPENDED"
                            <%= "SUSPENDED".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Suspended
                        </option>

                    </select>


                    <button type="submit">
                        Search / Filter
                    </button>

                </form>

            </div>


            <div class="table-wrap">

                <table>

                    <thead>

                        <tr>
                            <th>CUSTOMER</th>
                            <th>EMAIL</th>
                            <th>MOBILE</th>
                            <th>LOCATION</th>
                            <th>KYC STATUS</th>
                            <th>REGISTERED DATE</th>
                            <th>ACCOUNT STATUS</th>
                            <th>ACTIONS</th>
                        </tr>

                    </thead>


                    <tbody>

                    <% if (users != null && !users.isEmpty()) {

                        for (Map<String, Object> user : users) {

                            String userId =
                                (String) user.get("userId");

                            String fullName =
                                (String) user.get("fullName");

                            String email =
                                (String) user.get("email");

                            String mobile =
                                (String) user.get("mobile");

                            String city =
                                (String) user.get("city");

                            String state =
                                (String) user.get("state");

                            String status =
                                (String) user.get("status");

                            String kycStatus =
                                (String) user.get("kycStatus");

                            Timestamp createdAt =
                                (Timestamp) user.get("createdAt");

                            String location =
                                (city == null ? "" : city) +
                                (state == null || state.isEmpty()
                                    ? "" : ", " + state);

                            String detailsUrl =
                                ctx + "/AdminUsers?action=details&userId=" +
                                URLEncoder.encode(userId, "UTF-8");
                    %>


                        <tr>

                            <td>

                                <div class="user-name">
                                    <%= esc(fullName) %>
                                </div>

                                <div class="user-id">
                                    <%= esc(userId) %>
                                </div>

                            </td>


                            <td>
                                <%= esc(email) %>
                            </td>


                            <td>
                                <%= esc(mobile) %>
                            </td>


                            <td>
                                <%= location.isEmpty()
                                    ? "—" : esc(location) %>
                            </td>


                            <td>

                                <span class="kyc">
                                    <%= esc(kycStatus == null
                                        ? "NOT VERIFIED" : kycStatus) %>
                                </span>

                            </td>


                            <td>

                                <%= createdAt == null
                                    ? "—"
                                    : createdAt.toLocalDateTime()
                                               .toLocalDate() %>

                            </td>


                            <td>

                                <span class="status <%= esc(status) %>">
                                    <%= esc(status) %>
                                </span>

                            </td>


                            <td>

                                <a class="view-link"
                                   href="<%= detailsUrl %>">

                                    View Details

                                </a>


                                <form
                                    class="action-form"
                                    method="post"
                                    action="<%= ctx %>/AdminUsers"
                                    onsubmit="return confirm('Update this customer account status?');">

                                    <input
                                        type="hidden"
                                        name="userId"
                                        value="<%= esc(userId) %>"
                                    >


                                    <select name="newStatus" required>

                                        <option value="ACTIVE"
                                            <%= "ACTIVE".equals(status)
                                                ? "selected" : "" %>>
                                            Active
                                        </option>

                                        <option value="INACTIVE"
                                            <%= "INACTIVE".equals(status)
                                                ? "selected" : "" %>>
                                            Inactive
                                        </option>

                                        <option value="SUSPENDED"
                                            <%= "SUSPENDED".equals(status)
                                                ? "selected" : "" %>>
                                            Suspended
                                        </option>

                                    </select>


                                    <button type="submit">
                                        Update
                                    </button>

                                </form>

                            </td>

                        </tr>


                    <%  }

                       } else { %>


                        <tr>

                            <td colspan="8" class="empty">

                                No customer records found.

                            </td>

                        </tr>


                    <% } %>

                    </tbody>

                </table>

            </div>

        </div>

    </main>

</div>


<!-- ================= ADMIN PROFILE DROPDOWN SCRIPT ================= -->

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
