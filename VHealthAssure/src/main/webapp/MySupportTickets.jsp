
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.VHealthAssure.Entity.SupportEntity" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("loginId") == null) {
        response.sendRedirect("login.html");
        return;
    }

    List<SupportEntity> tickets =
        (List<SupportEntity>) request.getAttribute("tickets");

    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }

    String submitted = request.getParameter("submitted");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Support Tickets | VHealthAssure</title>

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

/* HEADER - SAME AS MY POLICIES */

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

.top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 25px;
}

.top h1 {
    color: var(--primary);
    font-size: 27px;
}

.subtitle {
    color: var(--muted);
    font-size: 14px;
    margin-top: 7px;
}

/* NEW TICKET BUTTON */

.new-btn {
    display: inline-block;
    text-decoration: none;
    background: #2563eb;
    color: white;
    padding: 11px 17px;
    border-radius: 7px;
    font-size: 13px;
    font-weight: 500;
}

.new-btn:hover {
    background: #1d4ed8;
}

/* TICKET CARD */

.ticket {
    background: white;
    border-radius: 16px;
    padding: 22px;
    margin-bottom: 18px;
    box-shadow: 0 10px 26px rgba(0,0,0,.07);
}

.ticket-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

.ticket-number {
    font-weight: 600;
    color: #0b2a4a;
}

.status {
    font-size: 11px;
    font-weight: 600;
    padding: 6px 11px;
    border-radius: 20px;
    background: #dbeafe;
    color: #1d4ed8;
}

.status.OPEN {
    background: #dbeafe;
    color: #1d4ed8;
}

.status.IN_PROGRESS {
    background: #ffedd5;
    color: #c2410c;
}

.status.RESOLVED {
    background: #dcfce7;
    color: #15803d;
}

.status.CLOSED {
    background: #e2e8f0;
    color: #475569;
}

/* TICKET DETAILS */

.details {
    margin-top: 15px;
    color: #64748b;
    font-size: 13px;
    line-height: 1.9;
}

.details strong {
    color: #0f172a;
}

/* ADMIN RESPONSE */

.response {
    margin-top: 18px;
    padding: 15px;
    border-left: 4px solid #2563eb;
    background: #eff6ff;
    border-radius: 5px;
}

.response h3 {
    font-size: 13px;
    margin-bottom: 7px;
}

.response p {
    color: #334155;
    font-size: 13px;
    white-space: pre-wrap;
    overflow-wrap: anywhere;
}

/* EMPTY STATE */

.empty {
    background: white;
    padding: 40px;
    border-radius: 16px;
    text-align: center;
    color: #64748b;
    box-shadow: 0 10px 26px rgba(0,0,0,.07);
}

.empty h3 {
    color: var(--primary);
    margin-bottom: 8px;
}

/* SUCCESS MESSAGE */

.success {
    background: #dcfce7;
    color: #166534;
    padding: 12px 15px;
    border-radius: 7px;
    margin-bottom: 20px;
    font-size: 13px;
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

    .top {
        align-items: flex-start;
        flex-direction: column;
    }
}

/* PROFILE BACKGROUND FIXES */

header .profile-area,
header .profile-area:hover,
header .profile-area:focus,
header .profile-area:active,
header .profile-area.active {
    background: transparent !important;
}

header .profile-avatar {
    background: linear-gradient(135deg, #2563eb, #1e40af) !important;
}

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

        <div class="profile-avatar">
            <%= userName.substring(0, 1).toUpperCase() %>
        </div>

        <div class="profile-name">
            <%= userName %>
        </div>

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
        <a href="MyPolicies">My Policies</a>
        <a href="Claims">Claims</a>
        <a href="CashlessHospitals">Cashless Hospitals</a>
        <a href="Payments">Payments</a>
        <a href="Kyc">KYC Details</a>
        <a href="Support" class="active">Support</a>

    </aside>

    <!-- MAIN CONTENT -->

    <main>

        <div class="top">

            <div>

                <h1>My Support Tickets</h1>

                <p class="subtitle">
                    Track your requests and view responses from our admin team.
                </p>

            </div>

            <a href="Support" class="new-btn">+ New Ticket</a>

        </div>

        <% if ("1".equals(submitted)) { %>

            <div class="success">
                Your support ticket has been submitted successfully.
            </div>

        <% } %>

        <% if (tickets == null || tickets.isEmpty()) { %>

            <div class="empty">

                <h3>No Support Tickets Found</h3>

                <p>You haven't submitted any support requests yet.</p>

            </div>

        <% } else { %>

            <% for (SupportEntity ticket : tickets) { %>

                <section class="ticket">

                    <div class="ticket-top">

                        <div class="ticket-number">
                            <%= ticket.getTicketNumber() %>
                        </div>

                        <span class="status <%= ticket.getStatus() %>">
                            <%= ticket.getStatus().replace("_", " ") %>
                        </span>

                    </div>

                    <div class="details">

                        <strong>Category:</strong>
                        <%= ticket.getCategory() %><br>

                        <strong>Subject:</strong>
                        <%= ticket.getSubject() %><br>

                        <strong>Submitted:</strong>
                        <%= ticket.getCreatedAt() %><br>

                        <strong>Your Message:</strong><br>
                        <%= ticket.getMessage() %>

                    </div>

                    <% if (ticket.getAdminResponse() != null &&
                           !ticket.getAdminResponse().trim().isEmpty()) { %>

                        <div class="response">

                            <h3>Admin Response</h3>

                            <p><%= ticket.getAdminResponse() %></p>

                        </div>

                    <% } else { %>

                        <div class="response">

                            <h3>Waiting for Admin Response</h3>

                            <p>Your request is being reviewed by our team.</p>

                        </div>

                    <% } %>

                </section>

            <% } %>

        <% } %>

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
