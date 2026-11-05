
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List,java.util.Map" %>

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

    List<Map<String, Object>> policies =
        (List<Map<String, Object>>) request.getAttribute("policies");

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

    int totalPolicies = 0;
    int activePolicies = 0;
    int expiredPolicies = 0;
    int cancelledPolicies = 0;

    if (statistics != null) {
        totalPolicies = statistics.getOrDefault("totalPolicies", 0);
        activePolicies = statistics.getOrDefault("activePolicies", 0);
        expiredPolicies = statistics.getOrDefault("expiredPolicies", 0);
        cancelledPolicies = statistics.getOrDefault("cancelledPolicies", 0);
    }

    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Policy Management | VHealthAssure</title>

<style>

/* ================= ROOT ================= */

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
    grid-template-columns: repeat(4, 1fr);
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

.clear-link {
    display: inline-flex;
    align-items: center;
    justify-content: center;

    height: 40px;
    padding: 0 14px;

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

.policy-number {
    color: var(--primary);
    font-weight: 600;
}

.policy-id {
    font-size: 10px;
    color: #94a3b8;
    margin-top: 4px;
    overflow-wrap: anywhere;
}

.customer-name {
    color: var(--primary);
    font-weight: 600;
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

.EXPIRED {
    background: #fef3c7;
    color: #92400e;
}

.CANCELLED {
    background: #fee2e2;
    color: #991b1b;
}

.premium {
    font-weight: 600;
    color: var(--primary);
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
        font-size: 11px;
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

        <div class="logo">
            <img src="<%= ctx %>/images/logo.jpg"
                 alt="VHealthAssure Logo">
        </div>

        <h1>VHealthAssure</h1>

    </div>

    <!-- SAME PROFILE DROPDOWN AS ADMINUSERS.JSP -->

    <div class="admin-area" id="adminArea">

        <div class="avatar">
            <%= initial %>
        </div>

        <div class="admin-name">
            <%= esc(adminName) %> ▾
        </div>

        <div class="dropdown">

            <a href="AdminProfile">
                Admin Profile
            </a>

            <a href="AdminChangePassword">
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

        <a class="active" href="<%= ctx %>/AdminPolicies">
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

    <!-- ================= MAIN CONTENT ================= -->

    <main>

        <div class="page-heading">

            <h2>Policy Management</h2>

            <p>
                View, search and monitor registered VHealthAssure policies.
            </p>

        </div>

        <!-- ================= ALERT MESSAGES ================= -->

        <% if ("updated".equals(message)) { %>

            <div class="alert success">
                Policy information updated successfully.
            </div>

        <% } else if ("failed".equals(message)) { %>

            <div class="alert error">
                Unable to process the requested action.
            </div>

        <% } %>

        <!-- ================= SUMMARY CARDS ================= -->

        <div class="summary">

            <div class="summary-card total">

                <span>Total Policies</span>

                <h3><%= totalPolicies %></h3>

            </div>

            <div class="summary-card active-card">

                <span>Active Policies</span>

                <h3><%= activePolicies %></h3>

            </div>

            <div class="summary-card expired-card">

                <span>Expired Policies</span>

                <h3><%= expiredPolicies %></h3>

            </div>

            <div class="summary-card cancelled-card">

                <span>Cancelled Policies</span>

                <h3><%= cancelledPolicies %></h3>

            </div>

        </div>

        <!-- ================= POLICY TABLE PANEL ================= -->

        <div class="panel">

            <div class="panel-heading">

                <h3>Registered Policies</h3>

                <!-- SEARCH AND FILTER -->

                <form class="filters"
                      method="get"
                      action="<%= ctx %>/AdminPolicies">

                    <input
                        type="text"
                        name="search"
                        placeholder="Search policy, customer, email or mobile"
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

                        <option value="EXPIRED"
                            <%= "EXPIRED".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Expired
                        </option>

                        <option value="CANCELLED"
                            <%= "CANCELLED".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Cancelled
                        </option>

                    </select>

                    <button type="submit">
                        Search / Filter
                    </button>

                    <a class="clear-link"
                       href="<%= ctx %>/AdminPolicies">
                        Clear
                    </a>

                </form>

            </div>

            <!-- ================= TABLE ================= -->

            <div class="table-wrap">

                <table>

                    <thead>

                        <tr>
                            <th>POLICY DETAILS</th>
                            <th>CUSTOMER</th>
                            <th>EMAIL</th>
                            <th>MOBILE</th>
                            <th>POLICY TYPE</th>
                            <th>PREMIUM AMOUNT</th>
                            <th>NEXT PREMIUM DATE</th>
                            <th>STATUS</th>
                            <th>CREATED DATE</th>
                        </tr>

                    </thead>

                    <tbody>

                    <%
                        if (policies != null && !policies.isEmpty()) {

                            for (Map<String, Object> policy : policies) {

                                Object policyId =
                                    policy.get("policyId");

                                Object policyNumber =
                                    policy.get("policyNumber");

                                Object customerName =
                                    policy.get("customerName");

                                Object email =
                                    policy.get("email");

                                Object mobile =
                                    policy.get("mobile");

                                Object policyType =
                                    policy.get("policyType");

                                Object premiumAmount =
                                    policy.get("premiumAmount");

                                Object nextPremiumDate =
                                    policy.get("nextPremiumDate");

                                Object createdAt =
                                    policy.get("createdAt");

                                Object status =
                                    policy.get("status");

                                String statusValue =
                                    status == null
                                    ? ""
                                    : status.toString();
                    %>

                        <tr>

                            <td>

                                <div class="policy-number">
                                    <%= esc(policyNumber) %>
                                </div>

                                <div class="policy-id">
                                    ID: <%= esc(policyId) %>
                                </div>

                            </td>

                            <td>

                                <div class="customer-name">
                                    <%= esc(customerName) %>
                                </div>

                            </td>

                            <td>
                                <%= esc(email) %>
                            </td>

                            <td>
                                <%= esc(mobile) %>
                            </td>

                            <td>
                                <%= esc(policyType) %>
                            </td>

                            <td class="premium">

                                ₹<%= premiumAmount == null
                                    ? "0.00"
                                    : esc(premiumAmount) %>

                            </td>

                            <td>
                                <%= esc(nextPremiumDate) %>
                            </td>

                            <td>

                                <span class="status <%= esc(statusValue) %>">
                                    <%= esc(statusValue) %>
                                </span>

                            </td>

                            <td>

                                <%= createdAt == null
                                    ? "—"
                                    : esc(createdAt.toString()) %>

                            </td>

                        </tr>

                    <%
                            }

                        } else {
                    %>

                        <tr>

                            <td colspan="9" class="empty">
                                No policy records found.
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

<!-- ================= PROFILE DROPDOWN SCRIPT ================= -->

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
