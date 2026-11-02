
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.VHealthAssure.Entity.PolicyEntity" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("loginId") == null) {
        response.sendRedirect("login.html");
        return;
    }

    List<PolicyEntity> policies =
        (List<PolicyEntity>) request.getAttribute("policies");

    if (policies == null) {
        policies = new ArrayList<>();
    }

    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Policies | VHealthAssure</title>

<style>
:root {
    --primary: #0b2a4a;
    --primary-dark: #071d33;
    --accent: #2563eb;
    --success: #2e7d32;
    --warning: #ed6c02;
    --danger: #c62828;
    --bg: #f4f6f9;
    --text: #0f172a;
    --muted: #64748b;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Poppins, Arial, sans-serif;
}

body {
    background: var(--bg);
    color: var(--text);
}

/* HEADER - MATCHED WITH USER DASHBOARD */
header {
    height: 64px;
    background: linear-gradient(135deg, var(--primary-dark), var(--primary));
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 32px;
}

/* BRAND AND LOGO */
.brand {
    display: flex;
    align-items: center;
    gap: 12px;
}

.logo-box {
    width: 42px;
    height: 42px;
    border-radius: 12px;
    background: linear-gradient(145deg, #f8fafc, #e2e8f0);
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    box-shadow: 0 6px 14px rgba(0,0,0,0.25),
                inset 0 2px 4px rgba(255,255,255,0.6);
}

.logo-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.brand h1 {
    font-size: 20px;
    font-weight: 600;
    letter-spacing: .3px;
}

/* PROFILE AREA */
.profile-area {
    position: relative;
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    user-select: none;
    background: transparent;
}

.profile-area:hover,
.profile-area:focus,
.profile-area:active {
    background: transparent;
}

.profile-avatar {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: linear-gradient(135deg, #2563eb, #1e40af);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 15px;
    color: #fff;
    transition: transform .25s ease, box-shadow .25s ease;
}

.profile-area:hover .profile-avatar {
    transform: scale(1.05);
    box-shadow: 0 8px 20px rgba(0,0,0,.35);
}

.profile-name {
    font-size: 14px;
    opacity: .95;
}

/* PROFILE DROPDOWN */
.profile-dropdown {
    position: absolute;
    top: 52px;
    right: 0;
    background: #fff;
    color: #0f172a;
    width: 210px;
    border-radius: 14px;
    box-shadow: 0 20px 40px rgba(0,0,0,.2);
    overflow: hidden;
    transform: translateY(-10px) scale(.95);
    opacity: 0;
    pointer-events: none;
    transition: all .25s ease;
    z-index: 100;
}

.profile-area.active .profile-dropdown {
    transform: translateY(0) scale(1);
    opacity: 1;
    pointer-events: auto;
}

.profile-dropdown a {
    display: block;
    padding: 14px 18px;
    text-decoration: none;
    color: #0f172a;
    font-size: 14px;
}

.profile-dropdown a:hover {
    background: #f1f5f9;
}

.profile-dropdown .logout {
    color: #c62828;
    font-weight: 600;
    border-top: 1px solid #e5e7eb;
}

/* LAYOUT */
.layout {
    display: grid;
    grid-template-columns: 240px 1fr;
    min-height: calc(100vh - 64px);
}

/* SIDEBAR */
.sidebar {
    background: #081a30;
    padding: 24px 16px;
}

.sidebar a {
    display: block;
    padding: 12px 14px;
    margin-bottom: 6px;
    color: #cbd5e1;
    text-decoration: none;
    border-radius: 8px;
    font-size: 14px;
}

.sidebar a:hover,
.sidebar a.active {
    background: #1e293b;
    color: #fff;
}

/* MAIN CONTENT */
main {
    padding: 28px;
    min-width: 0;
}

.page-heading {
    margin-bottom: 22px;
}

.page-heading h1 {
    color: var(--primary);
    font-size: 27px;
    margin-bottom: 7px;
}

.page-heading p {
    color: var(--muted);
    font-size: 14px;
}

/* CARD */
.card {
    background: #fff;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 10px 26px rgba(0,0,0,.07);
}

.card h3 {
    color: var(--primary);
    margin-bottom: 18px;
}

/* TABLE */
.table-wrap {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
    min-width: 680px;
}

th, td {
    padding: 15px 12px;
    border-bottom: 1px solid #e5e7eb;
    text-align: left;
}

th {
    color: var(--primary);
    background: #f8fafc;
    font-weight: 600;
}

/* STATUS BADGES */
.badge {
    display: inline-block;
    padding: 5px 11px;
    border-radius: 999px;
    color: #fff;
    font-size: 11px;
    font-weight: 600;
    white-space: nowrap;
}

.active {
    background: var(--success);
}

.expired {
    background: var(--warning);
}

.cancelled {
    background: var(--danger);
}

.empty {
    text-align: center;
    color: var(--muted);
    padding: 35px 12px;
}

.policy-number {
    color: var(--accent);
    font-weight: 600;
}

/* FOOTER */
footer {
    text-align: center;
    font-size: 12px;
    color: #94a3b8;
    padding: 16px;
}

/* RESPONSIVE */
@media (max-width: 900px) {
    .layout {
        grid-template-columns: 190px 1fr;
    }

    main {
        padding: 18px;
    }

    header {
        padding: 0 18px;
    }
}

@media (max-width: 600px) {
    .layout {
        grid-template-columns: 1fr;
    }

    .sidebar {
        padding: 10px;
    }

    .sidebar a {
        display: inline-block;
        margin-bottom: 0;
    }

    .brand h1 {
        font-size: 17px;
    }

    .profile-name {
        font-size: 13px;
    }
}
/* Remove unwanted green background from profile area */
header .profile-area,
header .profile-area:hover,
header .profile-area:focus,
header .profile-area:active,
header .profile-area.active {
    background: transparent !important;
}

/* Keep avatar blue */
header .profile-avatar {
    background: linear-gradient(135deg, #2563eb, #1e40af) !important;
}

/* Keep dropdown white */
header .profile-dropdown {
    background: #ffffff !important;
}
</style>
</head>

<body>

<!-- HEADER -->
<header>
    <div class="brand">
        <div class="logo-box">
            <img src="images/logo.jpg" alt="VHealthAssure Logo">
        </div>
        <h1>VHealthAssure</h1>
    </div>

    <div class="profile-area" id="profileArea">
        <div class="profile-avatar"><%= userName.substring(0, 1).toUpperCase() %></div>
        <div class="profile-name"><%= userName %></div>

        <div class="profile-dropdown">
            <a href="MyProfile">My Profile</a>
            <a href="ChangePassword.jsp">Change Password</a>
            <a href="logout" class="logout">Logout</a>
        </div>
    </div>
</header>

<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <a href="User-Dashboard">Dashboard</a>
        <a href="MyPolicies" class="active">My Policies</a>
        <a href="Claims">Claims</a>
        <a href="CashlessHospitals">Cashless Hospitals</a>
        <a href="Payments.jsp">Payments</a>
        <a href="Kyc">KYC Details</a>
        <a href="Support">Support</a>
    </aside>

    <!-- MAIN -->
    <main>

        <div class="page-heading">
            <h1>My Policies</h1>
            <p>View your insurance policies, premium amounts and upcoming due dates.</p>
        </div>

        <div class="card">
            <h3>Policy Details</h3>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Policy Number</th>
                            <th>Policy Type</th>
                            <th>Status</th>
                            <th>Premium Amount</th>
                            <th>Next Premium Due</th>
                            <th>Created Date</th>
                        </tr>
                    </thead>

                    <tbody>
                    <% if (policies.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="empty">
                                You don't have any policies yet.
                            </td>
                        </tr>
                    <% } else {
                        for (PolicyEntity policy : policies) {
                            String status = policy.getStatus() == null
                                ? ""
                                : policy.getStatus();

                            String badgeClass = "ACTIVE".equalsIgnoreCase(status)
                                ? "active"
                                : "EXPIRED".equalsIgnoreCase(status)
                                    ? "expired"
                                    : "cancelled";
                    %>
                        <tr>
                            <td class="policy-number">
                                <%= policy.getPolicyNumber() %>
                            </td>
                            <td><%= policy.getPolicyType() %></td>
                            <td>
                                <span class="badge <%= badgeClass %>">
                                    <%= status %>
                                </span>
                            </td>
                            <td>₹<%= policy.getPremiumAmount() %></td>
                            <td><%= policy.getNextPremiumDate() %></td>
                            <td><%= policy.getCreatedAt() %></td>
                        </tr>
                    <%  }
                       } %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<script>
const profile = document.getElementById("profileArea");

profile.addEventListener("click", function(event) {
    event.stopPropagation();
    profile.classList.toggle("active");
});

document.addEventListener("click", function(event) {
    if (!profile.contains(event.target)) {
        profile.classList.remove("active");
    }
});
</script>

</body>
</html>
