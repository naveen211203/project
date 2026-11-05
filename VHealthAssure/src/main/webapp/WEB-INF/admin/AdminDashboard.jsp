
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>

<%
    if (session == null ||
        session.getAttribute("loginId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }

    Map<String, Long> stats =
        (Map<String, Long>) request.getAttribute("stats");

    if (stats == null) {
        stats = new java.util.HashMap<>();
    }

    String adminName = (String) request.getAttribute("adminName");
    if (adminName == null) adminName = "Administrator";

    String initial = adminName.isEmpty()
        ? "A" : adminName.substring(0, 1).toUpperCase();

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard | VHealthAssure</title>

<style>
:root {
    --primary: #0b2a4a;
    --dark: #071d33;
    --accent: #2563eb;
    --background: #f4f6fa;
    --text: #172033;
    --muted: #64748b;
    --white: #ffffff;
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

/* HEADER */
header {
    height: 68px;
    background: linear-gradient(135deg, var(--dark), var(--primary));
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 30px;
    position: sticky;
    top: 0;
    z-index: 10;
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

/* LAYOUT */
.layout {
    display: block;
    min-height: calc(100vh - 68px);
    padding-top: 0;
}

/* SIDEBAR */
.sidebar {
    position: fixed;
    top: 68px;
    left: 0;
    bottom: 0;

    width: 245px;
    height: calc(100vh - 68px);

    background: #081a30;
    padding: 25px 15px;

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
    display: flex;
    align-items: center;
    gap: 12px;
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

/* MAIN */
main {
    margin-left: 245px;
    padding: 30px;
    min-width: 0;
    min-height: calc(100vh - 68px);
}

.welcome {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 28px;
    flex-wrap: wrap;
    gap: 12px;
}

.welcome h2 {
    color: var(--primary);
    font-size: 24px;
    margin-bottom: 5px;
}

.welcome p {
    color: var(--muted);
    font-size: 13px;
}

.dashboard-label {
    background: #eaf1ff;
    color: #1d4ed8;
    padding: 9px 15px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 600;
}

/* KPI CARDS */
.kpi-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 28px;
}

.kpi {
    background: white;
    padding: 22px;
    border-radius: 13px;
    box-shadow: 0 5px 18px rgba(15, 23, 42, .05);
    border: 1px solid var(--border);
    transition: .2s;
}

.kpi:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 25px rgba(15, 23, 42, .09);
}

.kpi-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.kpi-label {
    color: var(--muted);
    font-size: 13px;
}

.kpi-icon {
    width: 38px;
    height: 38px;
    border-radius: 10px;
    display: grid;
    place-items: center;
    font-size: 18px;
}

.blue { background: #eaf1ff; }
.green { background: #dcfce7; }
.orange { background: #ffedd5; }
.purple { background: #f3e8ff; }
.red { background: #fee2e2; }
.cyan { background: #cffafe; }

.kpi h2 {
    font-size: 29px;
    margin-top: 15px;
    color: var(--primary);
}

.kpi small {
    display: block;
    color: var(--muted);
    font-size: 11px;
    margin-top: 5px;
}

/* CONTENT */
.section-title {
    color: var(--primary);
    font-size: 17px;
    margin-bottom: 17px;
}

.module-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 18px;
}

.module {
    background: white;
    padding: 21px;
    border-radius: 13px;
    border: 1px solid var(--border);
    box-shadow: 0 5px 18px rgba(15, 23, 42, .04);
    transition: .2s;
}

.module:hover {
    transform: translateY(-3px);
    border-color: #bfdbfe;
}

.module-icon {
    width: 43px;
    height: 43px;
    display: grid;
    place-items: center;
    border-radius: 11px;
    background: #eaf1ff;
    font-size: 20px;
    margin-bottom: 14px;
}

.module h3 {
    color: var(--primary);
    font-size: 14px;
    margin-bottom: 7px;
}

.module p {
    color: var(--muted);
    font-size: 12px;
    line-height: 1.6;
    min-height: 38px;
}

.module a {
    display: inline-block;
    margin-top: 15px;
    color: var(--accent);
    text-decoration: none;
    font-size: 12px;
    font-weight: 600;
}

footer {
    text-align: center;
    color: #94a3b8;
    font-size: 11px;
    padding: 22px;
}

/* RESPONSIVE */
@media(max-width: 1100px) {
    .kpi-grid,
    .module-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media(max-width: 750px) {

    .layout {
        display: block;
    }

    .sidebar {
        position: relative;
        top: auto;
        left: auto;
        bottom: auto;

        width: 100%;
        height: auto;

        display: flex;
        overflow-x: auto;
        overflow-y: hidden;

        padding: 10px;
        gap: 5px;
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
        padding: 18px;
    }

    .kpi-grid,
    .module-grid {
        grid-template-columns: 1fr;
    }

    .admin-name {
        display: none;
    }
}
</style>
</head>

<body>

<header>
    <div class="brand">
        <div class="logo-box">
            <img src="<%= ctx %>/images/logo.jpg"
                 alt="VHealthAssure Logo">
        </div>
        <h1>VHealthAssure</h1>
    </div>

    <div class="admin-area" id="adminArea">
        <div class="avatar"><%= initial %></div>
        <div class="admin-name"><%= adminName %> ▾</div>

        <div class="dropdown">
            <a href="AdminProfile">Admin Profile</a>
            <a href="AdminChangePassword">Change Password</a>
            <a href="<%= ctx %>/logout" class="logout">Logout</a>
        </div>
    </div>
</header>

<div class="layout">

    <aside class="sidebar">
        <div class="sidebar-heading">ADMIN MENU</div>

        <a class="active" href="<%= ctx %>/AdminDashboard">
            📊 Dashboard
        </a>

        <a href="<%= ctx %>/AdminUsers">👥 User Management</a>
        <a href="<%= ctx %>/AdminPolicies">📄 Policy Management</a>
        <a href="<%= ctx %>/AdminClaims">📋 Claims Management</a>
        <a href="<%= ctx %>/AdminKyc">🛡️ KYC Management</a>
        <a href="<%= ctx %>/AdminHospitals">🏥 Hospital Management</a>
        <a href="<%= ctx %>/AdminSupport">🎧 Support Management</a>
    </aside>

    <main>

        <div class="welcome">
            <div>
                <h2>Welcome, <%= adminName %>!</h2>
                <p>Here's what's happening with VHealthAssure today.</p>
            </div>

            <div class="dashboard-label">
                ADMIN CONTROL PANEL
            </div>
        </div>

        <h3 class="section-title">Platform Overview</h3>

        <div class="kpi-grid">

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Total Users</span>
                    <span class="kpi-icon blue">👥</span>
                </div>
                <h2><%= stats.getOrDefault("totalUsers", 0L) %></h2>
                <small>Registered customers</small>
            </div>

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Active Users</span>
                    <span class="kpi-icon green">✓</span>
                </div>
                <h2><%= stats.getOrDefault("activeUsers", 0L) %></h2>
                <small>Currently active accounts</small>
            </div>

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Total Policies</span>
                    <span class="kpi-icon purple">📄</span>
                </div>
                <h2><%= stats.getOrDefault("totalPolicies", 0L) %></h2>
                <small>Registered insurance policies</small>
            </div>

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Active Policies</span>
                    <span class="kpi-icon green">✓</span>
                </div>
                <h2><%= stats.getOrDefault("activePolicies", 0L) %></h2>
                <small>Currently active policies</small>
            </div>

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Total Claims</span>
                    <span class="kpi-icon orange">📋</span>
                </div>
                <h2><%= stats.getOrDefault("totalClaims", 0L) %></h2>
                <small>Claims submitted by customers</small>
            </div>

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Claims Under Review</span>
                    <span class="kpi-icon orange">⏳</span>
                </div>
                <h2><%= stats.getOrDefault("pendingClaims", 0L) %></h2>
                <small>Awaiting claims review</small>
            </div>

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Pending KYC</span>
                    <span class="kpi-icon cyan">🛡️</span>
                </div>
                <h2><%= stats.getOrDefault("pendingKyc", 0L) %></h2>
                <small>Documents awaiting verification</small>
            </div>

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Active Hospitals</span>
                    <span class="kpi-icon green">🏥</span>
                </div>
                <h2><%= stats.getOrDefault("activeHospitals", 0L) %></h2>
                <small>Hospitals in the active network</small>
            </div>

            <div class="kpi">
                <div class="kpi-top">
                    <span class="kpi-label">Open Support Tickets</span>
                    <span class="kpi-icon red">🎧</span>
                </div>
                <h2><%= stats.getOrDefault("openTickets", 0L) %></h2>
                <small>Tickets requiring attention</small>
            </div>

        </div>

        <h3 class="section-title">Administration Modules</h3>

        <div class="module-grid">

            <div class="module">
                <div class="module-icon">👥</div>
                <h3>User Management</h3>
                <p>View customer accounts and manage their account status.</p>
                <a href="<%= ctx %>/AdminUsers">Manage Users →</a>
            </div>

            <div class="module">
                <div class="module-icon">📄</div>
                <h3>Policy Management</h3>
                <p>Review registered policies and manage policy records.</p>
                <a href="<%= ctx %>/AdminPolicies">Manage Policies →</a>
            </div>

            <div class="module">
                <div class="module-icon">📋</div>
                <h3>Claims Management</h3>
                <p>Review customer claims and process claim decisions.</p>
                <a href="<%= ctx %>/AdminClaims">Manage Claims →</a>
            </div>

            <div class="module">
                <div class="module-icon">🛡️</div>
                <h3>KYC Management</h3>
                <p>Review uploaded identity documents and verification status.</p>
                <a href="<%= ctx %>/AdminKyc">Manage KYC →</a>
            </div>

            <div class="module">
                <div class="module-icon">🏥</div>
                <h3>Hospital Management</h3>
                <p>Manage hospitals and their network participation status.</p>
                <a href="<%= ctx %>/AdminHospitals">Manage Hospitals →</a>
            </div>

            <div class="module">
                <div class="module-icon">🎧</div>
                <h3>Support Management</h3>
                <p>Respond to customer tickets and update their status.</p>
                <a href="<%= ctx %>/AdminSupport">Manage Support →</a>
            </div>

        </div>

        <footer>
            © 2026 VHealthAssure Insurance Services | Admin Portal
        </footer>

    </main>
</div>

<script>
const adminArea = document.getElementById("adminArea");

adminArea.addEventListener("click", function(event) {
    event.stopPropagation();
    adminArea.classList.toggle("active");
});

document.addEventListener("click", function() {
    adminArea.classList.remove("active");
});
</script>

</body>
</html>
