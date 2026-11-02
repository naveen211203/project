
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.VHealthAssure.Entity.ClaimEntity" %>

<%
    if (session == null || session.getAttribute("loginId") == null) {
        response.sendRedirect("login.html");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }

    ClaimEntity claim = (ClaimEntity) request.getAttribute("claim");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Claim Details | VHealthAssure</title>

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

/* Header */
header {
    height: 64px;
    background: linear-gradient(135deg, var(--primary-dark), var(--primary));
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 32px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
}

.logo-box {
    width: 42px;
    height: 42px;
    border-radius: 12px;
    overflow: hidden;
    background: linear-gradient(135deg, #e0f2fe, #ffffff);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    display: flex;
    align-items: center;
    justify-content: center;
}

.logo-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.brand h1 {
    font-size: 20px;
    font-weight: 600;
    letter-spacing: 0.3px;
}

/* Profile */
.profile-area {
    position: relative;
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    user-select: none;
}

.profile-avatar {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: linear-gradient(135deg, #2563eb, #1e40af);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 15px;
    font-weight: 600;
    transition: 0.2s;
}

.profile-area:hover .profile-avatar {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35);
}

.profile-name {
    font-size: 14px;
    opacity: 0.95;
}

.profile-dropdown {
    position: absolute;
    top: 52px;
    right: 0;
    width: 210px;
    background: white;
    color: var(--text);
    border-radius: 14px;
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.18);
    overflow: hidden;
    opacity: 0;
    pointer-events: none;
    transform: translateY(-10px) scale(0.95);
    transition: 0.25s;
    z-index: 100;
}

.profile-area.active .profile-dropdown {
    opacity: 1;
    pointer-events: auto;
    transform: translateY(0) scale(1);
}

.profile-dropdown a {
    display: block;
    padding: 14px 18px;
    color: var(--text);
    text-decoration: none;
    font-size: 14px;
    transition: background 0.2s;
}

.profile-dropdown a:hover {
    background: #f1f5f9;
}

.profile-dropdown .logout {
    color: var(--danger);
    border-top: 1px solid #e5e7eb;
}

/* Main layout */
.layout {
    display: grid;
    grid-template-columns: 240px 1fr;
    min-height: calc(100vh - 64px);
}

/* Sidebar */
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
    transition: 0.2s;
}

.sidebar a:hover,
.sidebar a.active {
    background: #1e293b;
    color: white;
}

/* Page content */
main {
    padding: 28px;
    min-width: 0;
}

.page-heading {
    margin-bottom: 24px;
}

.page-heading h1 {
    font-size: 27px;
    color: var(--primary);
    margin-bottom: 7px;
}

.page-heading p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.6;
}

/* Card */
.card {
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 10px 26px rgba(0, 0, 0, 0.07);
}

.card h2 {
    color: var(--primary);
    font-size: 19px;
    margin-bottom: 6px;
}

.card-description {
    color: var(--muted);
    font-size: 14px;
    margin-bottom: 16px;
    line-height: 1.6;
}

/* Claim details */
.details-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 24px;
}

.detail-item {
    padding: 17px 0;
    border-bottom: 1px solid #e5e7eb;
    min-width: 0;
}

.detail-label {
    display: block;
    color: var(--muted);
    font-size: 12px;
    margin-bottom: 7px;
}

.detail-value {
    display: block;
    color: var(--text);
    font-size: 14px;
    font-weight: 600;
    overflow-wrap: anywhere;
    line-height: 1.6;
}

.status {
    display: inline-block;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.status-approved {
    background: #e8f5e9;
    color: var(--success);
}

.status-rejected {
    background: #ffebee;
    color: var(--danger);
}

.status-review {
    background: #fff3e0;
    color: var(--warning);
}

/* Buttons */
.actions {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    margin-top: 24px;
}

.btn {
    display: inline-block;
    background: var(--accent);
    color: white;
    text-decoration: none;
    padding: 11px 18px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    transition: 0.2s;
}

.btn:hover {
    background: #1d4ed8;
    transform: translateY(-1px);
}

.btn-secondary {
    background: #e2e8f0;
    color: var(--primary);
}

.btn-secondary:hover {
    background: #cbd5e1;
}

/* Empty state */
.empty-state {
    text-align: center;
    padding: 30px 10px;
}

.empty-state p {
    color: var(--muted);
    font-size: 14px;
    margin-top: 8px;
}

/* Footer */
footer {
    color: var(--muted);
    text-align: center;
    padding: 16px;
    font-size: 12px;
}

/* Responsive */
@media (max-width: 900px) {
    .layout {
        grid-template-columns: 190px 1fr;
    }

    main {
        padding: 22px;
    }

    header {
        padding: 0 22px;
    }
}

@media (max-width: 600px) {
    header {
        padding: 0 14px;
    }

    .brand h1 {
        font-size: 17px;
    }

    .logo-box {
        width: 36px;
        height: 36px;
    }

    .profile-name {
        font-size: 13px;
        max-width: 100px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .layout {
        grid-template-columns: 1fr;
    }

    .sidebar {
        padding: 12px;
        display: flex;
        gap: 6px;
        overflow-x: auto;
    }

    .sidebar a {
        white-space: nowrap;
        margin-bottom: 0;
        padding: 10px 12px;
    }

    main {
        padding: 18px 14px;
    }

    .page-heading h1 {
        font-size: 23px;
    }

    .card {
        padding: 18px;
    }

    .details-grid {
        grid-template-columns: 1fr;
    }
}
</style>
</head>

<body>

<header>
    <div class="brand">
        <div class="logo-box">
            <img src="images/logo.jpg" alt="VHealthAssure Logo">
        </div>
        <h1>VHealthAssure</h1>
    </div>

    <div class="profile-area" id="profileArea">
        <div class="profile-avatar">
            <%= userName.substring(0, 1).toUpperCase() %>
        </div>

        <div class="profile-name"><%= userName %></div>

        <div class="profile-dropdown">
            <a href="MyProfile">My Profile</a>
            <a href="ChangePassword.jsp">Change Password</a>
            <a href="logout" class="logout">Logout</a>
        </div>
    </div>
</header>

<div class="layout">

    <aside class="sidebar">
        <a href="User-Dashboard">Dashboard</a>
        <a href="MyPolicies">My Policies</a>
        <a href="Claims" class="active">Claims</a>
        <a href="CashlessHospitals">Cashless Hospitals</a>
        <a href="Payments">Payments</a>
        <a href="Kyc">KYC Details</a>
        <a href="Support">Support</a>
    </aside>

    <main>

        <div class="page-heading">
            <h1>Claim Details</h1>
            <p>View your claim information and track its current status.</p>
        </div>

        <div class="card">

            <% if (claim != null) { %>

                <h2>Claim Information</h2>
                <p class="card-description">
                    Review the details associated with your submitted insurance claim.
                </p>

                <div class="details-grid">

                    <div class="detail-item">
                        <span class="detail-label">Claim Number</span>
                        <span class="detail-value"><%= claim.getClaimNumber() == null ? "—" : claim.getClaimNumber() %></span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Claim Date</span>
                        <span class="detail-value"><%= claim.getClaimDate() == null ? "—" : claim.getClaimDate() %></span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Policy Number</span>
                        <span class="detail-value"><%= claim.getPolicyNumber() == null ? "—" : claim.getPolicyNumber() %></span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Claim Amount</span>
                        <span class="detail-value">
                            ₹<%= claim.getAmountClaimed() == null ? "—" : claim.getAmountClaimed().toPlainString() %>
                        </span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Current Status</span>
                        <span class="detail-value">
                            <%
                                String status = claim.getStatus() == null
                                        ? "UNDER REVIEW"
                                        : claim.getStatus().replace('_', ' ');

                                String statusClass = "status-review";

                                if ("APPROVED".equalsIgnoreCase(status)) {
                                    statusClass = "status-approved";
                                } else if ("REJECTED".equalsIgnoreCase(status)) {
                                    statusClass = "status-rejected";
                                }
                            %>
                            <span class="status <%= statusClass %>"><%= status %></span>
                        </span>
                    </div>

                </div>

                <div class="actions">
                    <a href="Claims" class="btn">Back to My Claims</a>
                    <a href="SubmitClaim.jsp" class="btn btn-secondary">Submit New Claim</a>
                </div>

            <% } else { %>

                <div class="empty-state">
                    <h2>Claim Details Unavailable</h2>
                    <p>We could not find the claim information you requested.</p>
                    <div class="actions" style="justify-content:center;">
                        <a href="Claims" class="btn">Back to My Claims</a>
                    </div>
                </div>

            <% } %>

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
