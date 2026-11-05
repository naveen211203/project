<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>

<%!
    private String value(Map<String, Object> data, String key) {
        Object v = data.get(key);

        if (v == null || v.toString().trim().isEmpty()) {
            return "Not provided";
        }

        return v.toString();
    }

    private String esc(String value) {
        if (value == null) return "";

        return value
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

    Map<String, Object> u =
        (Map<String, Object>) request.getAttribute("customer");

    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/AdminUsers");
        return;
    }

    String ctx = request.getContextPath();

    String adminName =
        (String) request.getAttribute("adminName");

    if (adminName == null) {
        adminName = "Administrator";
    }

    String fullName = value(u, "fullName");
    String initial = fullName.substring(0, 1).toUpperCase();

    String status = value(u, "status");
    String kycStatus = value(u, "kycStatus");

    boolean emailVerified =
        Boolean.TRUE.equals(u.get("emailVerified"));

    boolean mobileVerified =
        Boolean.TRUE.equals(u.get("mobileVerified"));
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Customer Profile | VHealthAssure</title>

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

.brand h2 {
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
    font-size: 13px;
}

.avatar-small {
    width: 38px;
    height: 38px;
    background: var(--accent);
    border-radius: 50%;

    display: grid;
    place-items: center;

    font-weight: 600;
    color: #fff;
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
    min-height: 100vh;
    padding-top: 68px;
}

/* ================= SIDEBAR ================= */

.sidebar {
    position: fixed;

    top: 68px;
    bottom: 0;
    left: 0;

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

/* ================= MAIN ================= */

main {
    margin-left: 245px;
    padding: 30px;

    min-height: calc(100vh - 68px);
    min-width: 0;
}

/* ================= PAGE HEADING ================= */

.heading {
    display: flex;
    justify-content: space-between;
    align-items: center;

    flex-wrap: wrap;
    gap: 12px;

    margin-bottom: 24px;
}

.heading h1 {
    color: var(--primary);
    font-size: 24px;
}

.heading p {
    color: var(--muted);
    font-size: 13px;
    margin-top: 5px;
}

.back {
    text-decoration: none;
    color: var(--accent);
    font-size: 13px;
    font-weight: 600;
}

/* ================= PROFILE CARD ================= */

.profile-card {
    background: white;

    border: 1px solid var(--border);
    border-radius: 14px;

    padding: 25px;
    margin-bottom: 20px;

    box-shadow: 0 5px 18px rgba(15,23,42,.04);
}

.profile-top {
    display: flex;
    align-items: center;

    gap: 17px;
    flex-wrap: wrap;
}

.avatar {
    width: 65px;
    height: 65px;

    border-radius: 50%;

    background: #eaf1ff;
    color: #1d4ed8;

    display: grid;
    place-items: center;

    font-size: 25px;
    font-weight: 700;
}

.profile-info h2 {
    color: var(--primary);
    font-size: 20px;
}

.profile-info p {
    color: var(--muted);
    font-size: 12px;
    margin-top: 6px;
    overflow-wrap: anywhere;
}

.pills {
    margin-left: auto;

    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
}

.pill {
    display: inline-block;

    padding: 7px 12px;

    border-radius: 20px;

    background: #eaf1ff;
    color: #1d4ed8;

    font-size: 11px;
    font-weight: 600;
}

.status-active {
    background: #dcfce7;
    color: #166534;
}

.status-inactive {
    background: #e2e8f0;
    color: #475569;
}

.status-suspended {
    background: #fee2e2;
    color: #991b1b;
}

/* ================= SECTION CARDS ================= */

.section-title {
    color: var(--primary);
    font-size: 16px;

    padding-bottom: 14px;
    margin-bottom: 20px;

    border-bottom: 1px solid #edf0f4;
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 24px 25px;
}

.field label {
    display: block;

    font-size: 11px;
    color: var(--muted);

    margin-bottom: 7px;
}

.field p {
    color: #1e293b;

    font-size: 13px;
    font-weight: 500;

    overflow-wrap: anywhere;
    line-height: 1.6;
}

.verified {
    color: #15803d !important;
    font-weight: 600 !important;
}

.not-verified {
    color: #dc2626 !important;
    font-weight: 600 !important;
}

.security-note {
    background: #eff6ff;
    color: #1e40af;

    border-left: 4px solid #2563eb;

    padding: 13px 16px;
    border-radius: 7px;

    font-size: 12px;
    line-height: 1.6;

    margin-bottom: 20px;
}

/* ================= RESPONSIVE ================= */

@media(max-width: 1050px) {

    .details-grid {
        grid-template-columns: repeat(2, 1fr);
    }

}

@media(max-width: 750px) {

    .sidebar {
        position: fixed;

        top: 68px;
        left: 0;
        right: 0;
        bottom: auto;

        width: 100%;
        height: auto;

        display: flex;
        overflow-x: auto;

        padding: 10px;
    }

    .sidebar-heading {
        display: none;
    }

    .sidebar a {
        white-space: nowrap;
        flex-shrink: 0;
        margin: 0 4px;
    }

    main {
        margin-left: 0;
        padding: 90px 18px 25px;
    }

    .details-grid {
        grid-template-columns: 1fr;
    }

    .pills {
        margin-left: 0;
        width: 100%;
    }

}

@media(max-width: 500px) {

    .brand h2 {
        font-size: 16px;
    }

    .admin-area {
        font-size: 11px;
    }

    .admin-name {
        display: none;
    }

    .profile-card {
        padding: 18px;
    }

}

</style>

</head>

<body>

<!-- ================= HEADER ================= -->

<header>

    <div class="brand">

        <div class="logo">
            <img
                src="<%= ctx %>/images/logo.jpg"
                alt="VHealthAssure Logo"
            >
        </div>

        <h2>VHealthAssure</h2>

    </div>

    <!-- ADMIN PROFILE DROPDOWN -->

    <div class="admin-area" id="adminArea">

        <div class="avatar-small">
            <%= esc(adminName.substring(0, 1).toUpperCase()) %>
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


    <!-- ================= MAIN CONTENT ================= -->

    <main>

        <!-- PAGE HEADING -->

        <div class="heading">

            <div>

                <h1>Customer Profile</h1>

                <p>
                    Complete registered customer information
                </p>

            </div>

            <a
                class="back"
                href="<%= ctx %>/AdminUsers"
            >
                ← Back to Customers
            </a>

        </div>


        <div class="security-note">

            This is confidential customer information.
            Access should be limited to authorized administrators.
            Passwords are never displayed in this profile.

        </div>


        <!-- ================= PROFILE OVERVIEW ================= -->

        <div class="profile-card">

            <div class="profile-top">

                <div class="avatar">
                    <%= esc(initial) %>
                </div>

                <div class="profile-info">

                    <h2>
                        <%= esc(fullName) %>
                    </h2>

                    <p>
                        Customer ID:
                        <%= esc(value(u, "userId")) %>
                    </p>

                </div>

                <div class="pills">

                    <span class="pill
                        <%= "ACTIVE".equals(status)
                            ? "status-active"
                            : ("SUSPENDED".equals(status)
                                ? "status-suspended"
                                : "status-inactive") %>">

                        <%= esc(status) %>

                    </span>

                    <span class="pill">
                        KYC: <%= esc(kycStatus) %>
                    </span>

                </div>

            </div>

        </div>


        <!-- ================= PERSONAL INFORMATION ================= -->

        <div class="profile-card">

            <h3 class="section-title">
                Personal Information
            </h3>

            <div class="details-grid">

                <div class="field">
                    <label>Full Name</label>
                    <p><%= esc(fullName) %></p>
                </div>

                <div class="field">
                    <label>Date of Birth</label>
                    <p><%= esc(value(u, "dateOfBirth")) %></p>
                </div>

                <div class="field">
                    <label>Gender</label>
                    <p><%= esc(value(u, "gender")) %></p>
                </div>

                <div class="field">
                    <label>Customer ID</label>
                    <p><%= esc(value(u, "userId")) %></p>
                </div>

                <div class="field">
                    <label>Customer Role</label>
                    <p><%= esc(value(u, "role")) %></p>
                </div>

            </div>

        </div>


        <!-- ================= CONTACT DETAILS ================= -->

        <div class="profile-card">

            <h3 class="section-title">
                Contact & Verification Details
            </h3>

            <div class="details-grid">

                <div class="field">
                    <label>Email Address</label>
                    <p><%= esc(value(u, "email")) %></p>
                </div>

                <div class="field">
                    <label>Mobile Number</label>
                    <p><%= esc(value(u, "mobile")) %></p>
                </div>

                <div class="field">

                    <label>Email Verification</label>

                    <p class="<%= emailVerified
                        ? "verified" : "not-verified" %>">

                        <%= emailVerified
                            ? "Verified" : "Not Verified" %>

                    </p>

                </div>

                <div class="field">

                    <label>Mobile Verification</label>

                    <p class="<%= mobileVerified
                        ? "verified" : "not-verified" %>">

                        <%= mobileVerified
                            ? "Verified" : "Not Verified" %>

                    </p>

                </div>

                <div class="field">
                    <label>KYC Status</label>
                    <p><%= esc(kycStatus) %></p>
                </div>

            </div>

        </div>


        <!-- ================= GOVERNMENT ID ================= -->

        <div class="profile-card">

            <h3 class="section-title">
                Government Identity Details
            </h3>

            <div class="details-grid">

                <div class="field">
                    <label>Government ID Type</label>
                    <p><%= esc(value(u, "govIdType")) %></p>
                </div>

                <div class="field">
                    <label>Government ID Number</label>
                    <p><%= esc(value(u, "govIdNumber")) %></p>
                </div>

            </div>

        </div>


        <!-- ================= ADDRESS ================= -->

        <div class="profile-card">

            <h3 class="section-title">
                Residential Address
            </h3>

            <div class="details-grid">

                <div class="field">
                    <label>Address Line 1</label>
                    <p><%= esc(value(u, "addressLine1")) %></p>
                </div>

                <div class="field">
                    <label>Address Line 2</label>
                    <p><%= esc(value(u, "addressLine2")) %></p>
                </div>

                <div class="field">
                    <label>City</label>
                    <p><%= esc(value(u, "city")) %></p>
                </div>

                <div class="field">
                    <label>State</label>
                    <p><%= esc(value(u, "state")) %></p>
                </div>

                <div class="field">
                    <label>Postal Code</label>
                    <p><%= esc(value(u, "postalCode")) %></p>
                </div>

                <div class="field">
                    <label>Country</label>
                    <p><%= esc(value(u, "country")) %></p>
                </div>

            </div>

        </div>


        <!-- ================= NOMINEE ================= -->

        <div class="profile-card">

            <h3 class="section-title">
                Nominee Information
            </h3>

            <div class="details-grid">

                <div class="field">
                    <label>Nominee Name</label>
                    <p><%= esc(value(u, "nomineeName")) %></p>
                </div>

                <div class="field">
                    <label>Nominee Relationship</label>
                    <p><%= esc(value(u, "nomineeRelation")) %></p>
                </div>

                <div class="field">
                    <label>Nominee Date of Birth</label>
                    <p><%= esc(value(u, "nomineeDob")) %></p>
                </div>

                <div class="field">
                    <label>Nominee Share</label>
                    <p><%= esc(value(u, "nomineeShare")) %>%</p>
                </div>

            </div>

        </div>


        <!-- ================= EMPLOYMENT ================= -->

        <div class="profile-card">

            <h3 class="section-title">
                Employment & Financial Information
            </h3>

            <div class="details-grid">

                <div class="field">
                    <label>Employment Status</label>
                    <p><%= esc(value(u, "employmentStatus")) %></p>
                </div>

                <div class="field">
                    <label>Occupation</label>
                    <p><%= esc(value(u, "occupation")) %></p>
                </div>

                <div class="field">
                    <label>Company</label>
                    <p><%= esc(value(u, "company")) %></p>
                </div>

                <div class="field">
                    <label>Annual Income</label>
                    <p><%= esc(value(u, "annualIncome")) %></p>
                </div>

            </div>

        </div>


        <!-- ================= ACCOUNT INFORMATION ================= -->

        <div class="profile-card">

            <h3 class="section-title">
                Account Information
            </h3>

            <div class="details-grid">

                <div class="field">
                    <label>Account Status</label>
                    <p><%= esc(status) %></p>
                </div>

                <div class="field">
                    <label>Created At</label>
                    <p><%= esc(value(u, "createdAt")) %></p>
                </div>

                <div class="field">
                    <label>Last Updated</label>
                    <p><%= esc(value(u, "updatedAt")) %></p>
                </div>

            </div>

        </div>

    </main>

</div>


<!-- ================= ADMIN DROPDOWN SCRIPT ================= -->

<script>

document.addEventListener("DOMContentLoaded", function () {

    const adminArea = document.getElementById("adminArea");

    adminArea.addEventListener("click", function (event) {

        event.stopPropagation();

        adminArea.classList.toggle("active");

    });

    document.addEventListener("click", function () {

        adminArea.classList.remove("active");

    });

});

</script>

</body>
</html>