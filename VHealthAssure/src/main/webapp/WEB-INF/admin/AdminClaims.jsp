
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

    List<Map<String, Object>> claims =
        (List<Map<String, Object>>) request.getAttribute("claims");

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

    int totalClaims = 0;
    int underReview = 0;
    int approved = 0;
    int rejected = 0;

    if (statistics != null) {
        totalClaims = statistics.getOrDefault("totalClaims", 0);
        underReview = statistics.getOrDefault("underReview", 0);
        approved = statistics.getOrDefault("approved", 0);
        rejected = statistics.getOrDefault("rejected", 0);
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Claims Management | VHealthAssure</title>

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

input:focus, select:focus {
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
    min-width: 1250px;
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

.claim-number {
    color: var(--primary);
    font-weight: 600;
}

.claim-id {
    font-size: 10px;
    color: #94a3b8;
    margin-top: 4px;
}

.customer-name {
    color: var(--primary);
    font-weight: 600;
}

.patient-name {
    font-weight: 500;
    color: #334155;
}

.amount {
    color: var(--primary);
    font-weight: 600;
    white-space: nowrap;
}

/* STATUS */

.status {
    display: inline-block;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 10px;
    font-weight: 600;
    white-space: nowrap;
}

.UNDER_REVIEW {
    background: #fef3c7;
    color: #92400e;
}

.APPROVED {
    background: #dcfce7;
    color: #166534;
}

.REJECTED {
    background: #fee2e2;
    color: #991b1b;
}

/* ACTION BUTTONS */

.action-buttons {
    display: flex;
    align-items: center;
    gap: 7px;
}

.action-form {
    display: inline;
}

.approve-btn {
    padding: 8px 11px;
    background: #16a34a;
    color: white;
}

.approve-btn:hover {
    background: #15803d;
}

.reject-btn {
    padding: 8px 11px;
    background: #dc2626;
    color: white;
}

.reject-btn:hover {
    background: #b91c1c;
}

.completed-action {
    color: #94a3b8;
    font-size: 11px;
}

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

    <!-- SAME ADMIN PROFILE AS ADMINUSERS / ADMINPOLICIES -->

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

        <a class="active" href="<%= ctx %>/AdminClaims">
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

            <h2>Claims Management</h2>

            <p>
                Review, monitor and manage customer insurance claims.
            </p>

        </div>


        <!-- SUMMARY CARDS -->

        <div class="summary">

            <div class="summary-card">
                <span>Total Claims</span>
                <h3><%= totalClaims %></h3>
            </div>

            <div class="summary-card">
                <span>Under Review</span>
                <h3><%= underReview %></h3>
            </div>

            <div class="summary-card">
                <span>Approved Claims</span>
                <h3><%= approved %></h3>
            </div>

            <div class="summary-card">
                <span>Rejected Claims</span>
                <h3><%= rejected %></h3>
            </div>

        </div>


        <!-- STATUS MESSAGES -->

        <%
            if ("updated".equals(message)) {
        %>

            <div class="alert alert-success">
                Claim status has been updated successfully.
            </div>

        <%
            } else if ("notUpdated".equals(message)) {
        %>

            <div class="alert alert-error">
                Claim could not be updated. It may already have been processed.
            </div>

        <%
            } else if ("invalidStatus".equals(message) ||
                      "invalidClaim".equals(message)) {
        %>

            <div class="alert alert-error">
                Invalid claim update request.
            </div>

        <%
            }
        %>


        <!-- CLAIMS TABLE -->

        <div class="panel">

            <div class="panel-heading">

                <h3>Registered Claims</h3>

                <form class="filters"
                      method="get"
                      action="<%= ctx %>/AdminClaims">

                    <input type="text"
                           name="search"
                           placeholder="Search claim, customer, patient..."
                           value="<%= esc(search) %>">

                    <select name="status">

                        <option value="ALL"
                            <%= "ALL".equals(selectedStatus)
                                ? "selected" : "" %>>
                            All Status
                        </option>

                        <option value="UNDER_REVIEW"
                            <%= "UNDER_REVIEW".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Under Review
                        </option>

                        <option value="APPROVED"
                            <%= "APPROVED".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Approved
                        </option>

                        <option value="REJECTED"
                            <%= "REJECTED".equals(selectedStatus)
                                ? "selected" : "" %>>
                            Rejected
                        </option>

                    </select>

                    <button type="submit" class="search-btn">
                        Search / Filter
                    </button>

                    <a class="clear-link"
                       href="<%= ctx %>/AdminClaims">
                        Clear
                    </a>

                </form>

            </div>


            <div class="table-wrap">

                <table>

                    <thead>

                        <tr>
                            <th>CLAIM DETAILS</th>
                            <th>CUSTOMER</th>
                            <th>PATIENT</th>
                            <th>EMAIL</th>
                            <th>POLICY NUMBER</th>
                            <th>HOSPITAL</th>
                            <th>DIAGNOSIS</th>
                            <th>CLAIM AMOUNT</th>
                            <th>CLAIM DATE</th>
                            <th>STATUS</th>
                            <th>ACTION</th>
                        </tr>

                    </thead>

                    <tbody>

                    <%
                        if (claims != null && !claims.isEmpty()) {

                            for (Map<String, Object> claim : claims) {

                                Object claimId = claim.get("claimId");
                                Object claimNumber = claim.get("claimNumber");
                                Object customerName = claim.get("customerName");
                                Object patientName = claim.get("patientName");
                                Object email = claim.get("email");
                                Object policyNumber = claim.get("policyNumber");
                                Object hospitalName = claim.get("hospitalName");
                                Object diagnosis = claim.get("diagnosis");
                                Object amountClaimed = claim.get("amountClaimed");
                                Object claimDate = claim.get("claimDate");
                                Object status = claim.get("status");

                                String statusValue =
                                    status == null ? "" : status.toString();
                    %>

                        <tr>

                            <td>
                                <div class="claim-number">
                                    <%= esc(claimNumber) %>
                                </div>

                                <div class="claim-id">
                                    ID: <%= esc(claimId) %>
                                </div>
                            </td>

                            <td>
                                <div class="customer-name">
                                    <%= esc(customerName) %>
                                </div>
                            </td>

                            <td>
                                <div class="patient-name">
                                    <%= esc(patientName) %>
                                </div>
                            </td>

                            <td><%= esc(email) %></td>

                            <td><%= esc(policyNumber) %></td>

                            <td><%= esc(hospitalName) %></td>

                            <td><%= esc(diagnosis) %></td>

                            <td class="amount">
                                ₹<%= amountClaimed == null
                                    ? "0.00" : esc(amountClaimed) %>
                            </td>

                            <td><%= esc(claimDate) %></td>

                            <td>
                                <span class="status <%= esc(statusValue) %>">
                                    <%= esc(statusValue.replace("_", " ")) %>
                                </span>
                            </td>

                            <td>

                                <%
                                    if ("UNDER_REVIEW".equals(statusValue)) {
                                %>

                                    <div class="action-buttons">

                                        <form class="action-form"
                                              method="post"
                                              action="<%= ctx %>/AdminClaims"
                                              onsubmit="return confirm('Are you sure you want to approve this claim?');">

                                            <input type="hidden"
                                                   name="claimId"
                                                   value="<%= esc(claimId) %>">

                                            <input type="hidden"
                                                   name="status"
                                                   value="APPROVED">

                                            <button type="submit"
                                                    class="approve-btn">
                                                Approve
                                            </button>

                                        </form>

                                        <form class="action-form"
                                              method="post"
                                              action="<%= ctx %>/AdminClaims"
                                              onsubmit="return confirm('Are you sure you want to reject this claim?');">

                                            <input type="hidden"
                                                   name="claimId"
                                                   value="<%= esc(claimId) %>">

                                            <input type="hidden"
                                                   name="status"
                                                   value="REJECTED">

                                            <button type="submit"
                                                    class="reject-btn">
                                                Reject
                                            </button>

                                        </form>

                                    </div>

                                <%
                                    } else {
                                %>

                                    <span class="completed-action">
                                        Processed
                                    </span>

                                <%
                                    }
                                %>

                            </td>

                        </tr>

                    <%
                            }

                        } else {
                    %>

                        <tr>
                            <td colspan="11" class="empty">
                                No claim records found.
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


<!-- ================= SAME PROFILE DROPDOWN JAVASCRIPT ================= -->

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
