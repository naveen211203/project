
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.VHealthAssure.Entity.HospitalEntity" %>

<%
    if (session == null || session.getAttribute("loginId") == null) {
        response.sendRedirect("login.html");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }

    List<HospitalEntity> hospitals =
        (List<HospitalEntity>) request.getAttribute("hospitals");

    String searchCity = request.getParameter("city");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Cashless Hospitals | VHealthAssure</title>

<style>
:root {
    --primary: #0b2a4a;
    --primary-dark: #071d33;
    --accent: #2563eb;
    --success: #2e7d32;
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

    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
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
    box-shadow: 0 4px 12px rgba(0,0,0,.15);
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
    transition: .2s;
}

.profile-area:hover .profile-avatar {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(37,99,235,.35);
}

.profile-name {
    font-size: 14px;
    opacity: .95;
}

.profile-dropdown {
    position: absolute;
    top: 52px;
    right: 0;
    width: 210px;
    background: white;
    color: var(--text);
    border-radius: 14px;
    box-shadow: 0 12px 30px rgba(0,0,0,.18);
    overflow: hidden;
    opacity: 0;
    pointer-events: none;
    transform: translateY(-10px) scale(.95);
    transition: .25s;
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
}

.profile-dropdown a:hover {
    background: #f1f5f9;
}

.profile-dropdown .logout {
    color: var(--danger);
    border-top: 1px solid #e5e7eb;
}

/* Layout */
.layout {
    display: grid;
    grid-template-columns: 240px 1fr;

    position: fixed;
    top: 64px;
    left: 0;
    right: 0;
    bottom: 0;

    overflow: hidden;
}

.sidebar {
    background: #081a30;
    padding: 24px 16px;

    height: 100%;
    overflow-y: auto;
    position: sticky;
    top: 0;
}

.sidebar a {
    display: block;
    padding: 12px 14px;
    margin-bottom: 6px;
    color: #cbd5e1;
    text-decoration: none;
    border-radius: 8px;
    font-size: 14px;
    transition: .2s;
}

.sidebar a:hover,
.sidebar a.active {
    background: #1e293b;
    color: white;
}

/* Main */
main {
    padding: 28px;
    min-width: 0;

    height: 100%;
    overflow-y: auto;
    scroll-behavior: smooth;
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

/* Summary */
.summary-card {
    background: white;
    padding: 20px 22px;
    border-radius: 14px;
    box-shadow: 0 10px 26px rgba(0,0,0,.06);
    margin-bottom: 22px;
}

.summary-card h3 {
    font-size: 15px;
    color: var(--muted);
    font-weight: 500;
    margin-bottom: 8px;
}

.summary-card h2 {
    font-size: 28px;
    color: var(--primary);
}

/* Search */
.search-card {
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 10px 26px rgba(0,0,0,.07);
    margin-bottom: 24px;
}

.search-card h2 {
    color: var(--primary);
    font-size: 19px;
    margin-bottom: 16px;
}

.search-fields {
    display: grid;
    grid-template-columns: 2fr 1fr auto;
    gap: 12px;
    align-items: end;
}

.search-field {
    display: flex;
    flex-direction: column;
    gap: 7px;
}

.search-field label {
    font-size: 13px;
    font-weight: 600;
}

.search-field input {
    width: 100%;
    padding: 12px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-size: 14px;
}

.search-field input:focus {
    outline: none;
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(37,99,235,.12);
}

.btn {
    display: inline-block;
    border: none;
    border-radius: 8px;
    background: var(--accent);
    color: white;
    padding: 12px 20px;
    font-size: 14px;
    font-weight: 500;
    text-decoration: none;
    cursor: pointer;
    transition: .2s;
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

/* Hospital section */
.section-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 18px;
    gap: 12px;
}

.section-heading h2 {
    font-size: 20px;
    color: var(--primary);
}

.section-heading span {
    font-size: 13px;
    color: var(--muted);
}

/* Hospital cards */
.hospital-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px;
}

.hospital-card {
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 10px 26px rgba(0,0,0,.06);
    transition: .2s;
    min-width: 0;
}

.hospital-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 14px 30px rgba(0,0,0,.09);
}

.hospital-top {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    margin-bottom: 16px;
}

.hospital-icon {
    width: 48px;
    height: 48px;
    flex-shrink: 0;
    border-radius: 12px;
    background: #eff6ff;
    color: var(--accent);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 23px;
}

.hospital-info {
    min-width: 0;
}

.hospital-info h3 {
    font-size: 16px;
    color: var(--primary);
    margin-bottom: 7px;
    overflow-wrap: anywhere;
}

.network-badge {
    display: inline-block;
    background: #e8f5e9;
    color: var(--success);
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

.hospital-details {
    border-top: 1px solid #e5e7eb;
    padding-top: 14px;
}

.detail {
    display: flex;
    gap: 9px;
    margin-bottom: 11px;
    font-size: 13px;
    line-height: 1.6;
}

.detail-icon {
    color: var(--accent);
    flex-shrink: 0;
}

.detail-text {
    color: var(--muted);
    overflow-wrap: anywhere;
}

.hospital-actions {
    margin-top: 16px;
}

.hospital-actions a {
    font-size: 13px;
    padding: 9px 14px;
}

/* Empty state */
.empty-state {
    background: white;
    border-radius: 16px;
    padding: 45px 20px;
    text-align: center;
    box-shadow: 0 10px 26px rgba(0,0,0,.06);
}

.empty-state h3 {
    color: var(--primary);
    font-size: 18px;
    margin-bottom: 8px;
}

.empty-state p {
    color: var(--muted);
    font-size: 14px;
}

footer {
    text-align: center;
    color: var(--muted);
    padding: 16px;
    font-size: 12px;
}

/* Responsive */
@media(max-width: 900px) {
    .layout {
        grid-template-columns: 190px 1fr;
    }

    main {
        padding: 22px;
    }

    .hospital-grid {
        grid-template-columns: 1fr;
    }
}

@media(max-width: 600px) {
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
    display: flex;
    gap: 6px;
    padding: 10px;
    overflow-x: auto;
    overflow-y: hidden;
    height: auto;
}

.sidebar a {
    white-space: nowrap;
    margin-bottom: 0;
    padding: 10px 12px;
}

main {
    padding: 18px 14px;
    overflow-y: auto;
}
.layout {
    top: 64px;
}

    .page-heading h1 {
        font-size: 23px;
    }

    .search-fields {
        grid-template-columns: 1fr;
    }

    .search-fields .btn {
        width: 100%;
    }

    .hospital-grid {
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
        <a href="Claims">Claims</a>
        <a href="CashlessHospitals" class="active">Cashless Hospitals</a>
        <a href="Payments.jsp">Payments</a>
        <a href="Kyc">KYC Details</a>
        <a href="Support">Support</a>
    </aside>

    <main>

        <div class="page-heading">
            <h1>Cashless Hospitals</h1>
            <p>Find network hospitals where you can access cashless healthcare services.</p>
        </div>

        <div class="summary-card">
            <h3>Network Hospitals Available</h3>
            <h2><%= hospitals == null ? 0 : hospitals.size() %></h2>
        </div>

        <!-- Search -->
        <div class="search-card">
            <h2>Find a Hospital</h2>

            <div class="search-fields">
                <div class="search-field">
                    <label for="hospitalSearch">Hospital Name or Address</label>
                    <input type="text" id="hospitalSearch"
                           placeholder="Search hospital name or address...">
                </div>

                <div class="search-field">
                    <label for="citySearch">City</label>
                    <input type="text" id="citySearch"
                           placeholder="Enter city...">
                </div>

                <button type="button" class="btn" onclick="filterHospitals()">
                    Search
                </button>
            </div>
        </div>

        <!-- Hospital list -->
        <div class="section-heading">
            <h2>Hospital Directory</h2>
            <span id="resultCount">
                <%= hospitals == null ? 0 : hospitals.size() %> hospitals found
            </span>
        </div>

        <div class="hospital-grid" id="hospitalGrid">

            <% if (hospitals != null && !hospitals.isEmpty()) { %>

                <% for (HospitalEntity hospital : hospitals) { %>

                    <%
                        String hospitalName = hospital.getHospitalName() == null
                                ? "" : hospital.getHospitalName();

                        String address = hospital.getAddress() == null
                                ? "" : hospital.getAddress();

                        String city = hospital.getCity() == null
                                ? "" : hospital.getCity();

                        String state = hospital.getState() == null
                                ? "" : hospital.getState();

                        String phone = hospital.getContactNumber() == null
                                ? "Not available" : hospital.getContactNumber();

                        String location = address + ", " + city + ", " + state;
                    %>

                    <div class="hospital-card"
                         data-name="<%= hospitalName.toLowerCase() %>"
                         data-address="<%= location.toLowerCase() %>"
                         data-city="<%= city.toLowerCase() %>">

                        <div class="hospital-top">
                            <div class="hospital-icon">✚</div>

                            <div class="hospital-info">
                                <h3><%= hospitalName %></h3>
                                <span class="network-badge">Network Hospital</span>
                            </div>
                        </div>

                        <div class="hospital-details">

                            <div class="detail">
                                <span class="detail-icon">📍</span>
                                <span class="detail-text"><%= location %></span>
                            </div>

                            <div class="detail">
                                <span class="detail-icon">☎</span>
                                <span class="detail-text"><%= phone %></span>
                            </div>

                        </div>

                        <div class="hospital-actions">
                            <% if (hospital.getContactNumber() != null &&
                                   !hospital.getContactNumber().trim().isEmpty()) { %>
                                <a class="btn"
                                   href="tel:<%= hospital.getContactNumber() %>">
                                    Contact Hospital
                                </a>
                            <% } %>
                        </div>

                    </div>

                <% } %>

            <% } else { %>

                <div class="empty-state" style="grid-column:1/-1;">
                    <h3>No Hospitals Available</h3>
                    <p>Hospital information will appear here once network hospital records are added.</p>
                </div>

            <% } %>

        </div>

        <div class="empty-state" id="noResults" style="display:none;margin-top:20px;">
            <h3>No Matching Hospitals Found</h3>
            <p>Try searching with another hospital name or city.</p>
        </div>
    </main>
</div>

<script>
/* Profile dropdown */
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

/* Hospital search */
function filterHospitals() {
    const searchValue = document.getElementById("hospitalSearch")
        .value.trim().toLowerCase();

    const cityValue = document.getElementById("citySearch")
        .value.trim().toLowerCase();

    const cards = document.querySelectorAll(".hospital-card");
    const noResults = document.getElementById("noResults");

    let count = 0;

    cards.forEach(function(card) {
        const name = card.dataset.name || "";
        const address = card.dataset.address || "";
        const city = card.dataset.city || "";

        const matchesSearch =
            name.includes(searchValue) || address.includes(searchValue);

        const matchesCity = city.includes(cityValue);

        if (matchesSearch && matchesCity) {
            card.style.display = "";
            count++;
        } else {
            card.style.display = "none";
        }
    });

    document.getElementById("resultCount").textContent =
        count + (count === 1 ? " hospital found" : " hospitals found");

    noResults.style.display = count === 0 ? "block" : "none";
}

document.getElementById("hospitalSearch")
    .addEventListener("input", filterHospitals);

document.getElementById("citySearch")
    .addEventListener("input", filterHospitals);
</script>

</body>
</html>
