
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("loginId") == null) {
        response.sendRedirect("login.html");
        return;
    }

    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Contact Support | VHealthAssure</title>

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

/* SUPPORT CONTENT */

.support-layout {
    display: grid;
    grid-template-columns: minmax(0, 2fr) minmax(240px, 1fr);
    gap: 22px;
    align-items: start;
}

.card {
    background: #fff;
    padding: 25px;
    border-radius: 16px;
    box-shadow: 0 10px 26px rgba(0,0,0,.07);
}

.card h2 {
    color: var(--primary);
    font-size: 18px;
    margin-bottom: 20px;
}

label {
    display: block;
    font-size: 13px;
    font-weight: 500;
    margin: 16px 0 7px;
}

input, select, textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #dbe2ea;
    border-radius: 7px;
    font-family: inherit;
    font-size: 13px;
    outline: none;
}

input:focus, select:focus, textarea:focus {
    border-color: #2563eb;
}

textarea {
    resize: vertical;
    min-height: 140px;
}

.submit-btn {
    margin-top: 20px;
    background: #2563eb;
    color: white;
    border: none;
    padding: 12px 22px;
    border-radius: 7px;
    cursor: pointer;
    font-family: inherit;
    font-weight: 500;
}

.submit-btn:hover {
    background: #1d4ed8;
}

.info-card {
    margin-bottom: 18px;
}

.info-card p {
    color: #64748b;
    font-size: 13px;
    line-height: 1.8;
}

.info-card a {
    display: inline-block;
    margin-top: 14px;
    color: #2563eb;
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
}

.alert {
    padding: 12px 15px;
    border-radius: 7px;
    margin-bottom: 18px;
    font-size: 13px;
}

.error {
    color: #b91c1c;
    background: #fee2e2;
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

    .support-layout {
        grid-template-columns: 1fr;
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
        <a href="Payments.jsp">Payments</a>
        <a href="Kyc">KYC Details</a>
        <a href="Support" class="active">Support</a>

    </aside>

    <!-- MAIN CONTENT -->

    <main>

        <div class="page-heading">
            <h1>Contact Support</h1>

            <p>
                Have a question or facing an issue? Submit a support request
                and our admin team will assist you.
            </p>
        </div>

        <% if ("invalid".equals(error)) { %>

            <div class="alert error">
                Please check your category, subject and message.
            </div>

        <% } else if ("failed".equals(error)) { %>

            <div class="alert error">
                Unable to submit your request. Please try again.
            </div>

        <% } %>

        <div class="support-layout">

            <section class="card">

                <h2>Raise a Support Ticket</h2>

                <form action="Support" method="post">

                    <label>Customer Name</label>

                    <input type="text"
                           value="<%= userName %>"
                           readonly>

                    <label>Category</label>

                    <select name="category" required>

                        <option value="">Select Category</option>
                        <option value="Policy Related">Policy Related</option>
                        <option value="Claim Related">Claim Related</option>
                        <option value="Payment Related">Payment Related</option>
                        <option value="KYC Related">KYC Related</option>
                        <option value="Technical Issue">Technical Issue</option>
                        <option value="Other">Other</option>

                    </select>

                    <label>Subject</label>

                    <input type="text"
                           name="subject"
                           maxlength="200"
                           placeholder="Enter the issue subject"
                           required>

                    <label>Describe Your Issue</label>

                    <textarea name="message"
                              maxlength="5000"
                              placeholder="Explain your issue in detail..."
                              required></textarea>

                    <button type="submit" class="submit-btn">
                        Submit Support Request
                    </button>

                </form>

            </section>

            <div>

                <section class="card info-card">

                    <h2>How It Works</h2>

                    <p>
                        1. Submit your support request.<br>
                        2. Your ticket is sent to the admin team.<br>
                        3. The admin reviews your issue.<br>
                        4. Check your ticket history for updates.
                    </p>

                </section>

                <section class="card info-card">

                    <h2>Track Your Request</h2>

                    <p>
                        View your submitted tickets, check their status
                        and read responses from the admin team.
                    </p>

                    <a href="MySupportTickets">
                        View My Support Tickets →
                    </a>

                </section>

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
