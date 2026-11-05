<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Timestamp" %>

<%!
    public String esc(Object value) {
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
    Map<String, Object> admin =
        (Map<String, Object>) request.getAttribute("admin");

    String ctx = request.getContextPath();

    String adminName = (String) request.getAttribute("adminName");
    if (adminName == null || adminName.trim().isEmpty()) {
        adminName = "Admin";
    }

    String initial = adminName.substring(0, 1).toUpperCase();

    String errorMessage =
        (String) request.getAttribute("errorMessage");

    Timestamp createdAt = null;
    Timestamp lastLogin = null;

    if (admin != null) {
        createdAt = (Timestamp) admin.get("createdAt");
        lastLogin = (Timestamp) admin.get("lastLogin");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Profile | VHealthAssure</title>

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

/* HEADER */

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

/* ADMIN PROFILE DROPDOWN */

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

/* PAGE LAYOUT */

.layout {
    display: block;
    padding-top: 68px;
    min-height: 100vh;
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

/* MAIN CONTENT */

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

/* PROFILE PANEL */

.panel {
    background: white;
    padding: 23px;
    border-radius: 13px;
    border: 1px solid var(--border);
    box-shadow: 0 5px 18px rgba(15,23,42,.04);
}

.profile-header {
    display: flex;
    align-items: center;
    gap: 17px;
    padding-bottom: 22px;
    border-bottom: 1px solid var(--border);
    margin-bottom: 22px;
}

.profile-avatar {
    width: 65px;
    height: 65px;
    border-radius: 50%;
    background: var(--accent);
    color: white;
    display: grid;
    place-items: center;
    font-size: 25px;
    font-weight: 600;
}

.profile-header h3 {
    color: var(--primary);
    font-size: 19px;
    margin-bottom: 5px;
}

.profile-header p {
    color: var(--muted);
    font-size: 13px;
}

.status-badge {
    display: inline-block;
    padding: 6px 13px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    background: #dcfce7;
    color: #15803d;
}

.status-inactive {
    background: #fee2e2;
    color: #b91c1c;
}

.profile-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px;
}

.detail-item {
    padding: 16px;
    background: #f8fafc;
    border: 1px solid var(--border);
    border-radius: 9px;
    min-width: 0;
}

.detail-item label {
    display: block;
    color: var(--muted);
    font-size: 12px;
    margin-bottom: 8px;
}

.detail-item p {
    color: var(--text);
    font-size: 14px;
    font-weight: 600;
    overflow-wrap: anywhere;
}

.error-message {
    padding: 15px;
    background: #fee2e2;
    color: #b91c1c;
    border-radius: 8px;
    font-size: 13px;
}

/* RESPONSIVE */

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

    .admin-name {
        display: none;
    }

    .brand h1 {
        font-size: 17px;
    }

    .profile-grid {
        grid-template-columns: 1fr;
    }

    header {
        padding: 0 15px;
    }
}

</style>
</head>

<body>

<!-- HEADER -->

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

    <!-- SIDEBAR -->

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

        <a href="<%= ctx %>/AdminSupport">
            🎧 Support Management
        </a>

    </aside>

    <!-- MAIN CONTENT -->

    <main>

        <div class="page-heading">

            <h2>Admin Profile</h2>

            <p>
                View your administrator account information.
            </p>

        </div>

        <% if (errorMessage != null) { %>

            <div class="error-message">
                <%= esc(errorMessage) %>
            </div>

        <% } else if (admin != null) { %>

            <section class="panel">

                <div class="profile-header">

                    <div class="profile-avatar">
                        <%= esc(initial) %>
                    </div>

                    <div>

                        <h3>
                            <%= esc(admin.get("fullName")) %>
                        </h3>

                        <p>
                            Administrator Account
                        </p>

                        <br>

                        <% if ("ACTIVE".equalsIgnoreCase(
                                String.valueOf(admin.get("status")))) { %>

                            <span class="status-badge">
                                ACTIVE
                            </span>

                        <% } else { %>

                            <span class="status-badge status-inactive">
                                <%= esc(admin.get("status")) %>
                            </span>

                        <% } %>

                    </div>

                </div>

                <div class="profile-grid">

                    <div class="detail-item">
                        <label>Admin ID</label>
                        <p><%= esc(admin.get("adminId")) %></p>
                    </div>

                    <div class="detail-item">
                        <label>Full Name</label>
                        <p><%= esc(admin.get("fullName")) %></p>
                    </div>

                    <div class="detail-item">
                        <label>Email Address</label>
                        <p><%= esc(admin.get("email")) %></p>
                    </div>

                    <div class="detail-item">
                        <label>Mobile Number</label>
                        <p><%= esc(admin.get("mobile")) %></p>
                    </div>

                    <div class="detail-item">
                        <label>Role</label>
                        <p><%= esc(admin.get("role")) %></p>
                    </div>

                    <div class="detail-item">
                        <label>Account Status</label>
                        <p><%= esc(admin.get("status")) %></p>
                    </div>

                    <div class="detail-item">
                        <label>Account Created</label>
                        <p>
                            <%= createdAt != null
                                ? esc(createdAt)
                                : "Not available" %>
                        </p>
                    </div>

                    <div class="detail-item">
                        <label>Last Login</label>
                        <p>
                            <%= lastLogin != null
                                ? esc(lastLogin)
                                : "No previous login recorded" %>
                        </p>
                    </div>

                </div>

            </section>

        <% } else { %>

            <div class="error-message">
                Admin profile information is not available.
            </div>

        <% } %>

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

document.addEventListener("keydown", function(event) {

    if (event.key === "Escape") {
        adminArea.classList.remove("active");
    }

});

</script>

</body>
</html>