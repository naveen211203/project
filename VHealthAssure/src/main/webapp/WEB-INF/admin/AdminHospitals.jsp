<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List,java.util.Map,java.text.SimpleDateFormat" %>

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

    private String js(Object value) {
        if (value == null) return "";

        return value.toString()
            .replace("\\", "\\\\")
            .replace("'", "\\'")
            .replace("\"", "\\\"")
            .replace("\r", "\\r")
            .replace("\n", "\\n")
            .replace("<", "\\x3C")
            .replace(">", "\\x3E");
    }
%>

<%
    if (session == null ||
        session.getAttribute("loginId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }

    List<Map<String, Object>> hospitals =
        (List<Map<String, Object>>) request.getAttribute("hospitals");

    Map<String, Integer> statistics =
        (Map<String, Integer>) request.getAttribute("statistics");

    String search = (String) request.getAttribute("search");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String adminName = (String) request.getAttribute("adminName");

    if (search == null) search = "";
    if (selectedStatus == null) selectedStatus = "ALL";

    if (adminName == null || adminName.trim().isEmpty()) {
        adminName = "Administrator";
    }

    String initial = adminName.substring(0, 1).toUpperCase();
    String ctx = request.getContextPath();
    String message = request.getParameter("message");

    int totalHospitals = 0;
    int activeHospitals = 0;
    int inactiveHospitals = 0;

    if (statistics != null) {
        totalHospitals = statistics.getOrDefault("totalHospitals", 0);
        activeHospitals = statistics.getOrDefault("activeHospitals", 0);
        inactiveHospitals = statistics.getOrDefault("inactiveHospitals", 0);
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Hospital Management | VHealthAssure</title>

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

/* ADMIN PROFILE */

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

/* LAYOUT */

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

/* MAIN */

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

/* SUMMARY */

.summary {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
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

/* PANEL */

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

/* FILTERS */

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

.filters input {
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

/* TABLE */

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

.hospital-name {
    color: var(--primary);
    font-weight: 600;
}

.hospital-id {
    font-size: 10px;
    color: #94a3b8;
    margin-top: 4px;
}

.location {
    min-width: 160px;
}

.contact {
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

.ACTIVE {
    background: #dcfce7;
    color: #166534;
}

.INACTIVE {
    background: #fee2e2;
    color: #991b1b;
}

/* ACTIONS */

.action-buttons {
    display: flex;
    align-items: center;
    gap: 7px;
}

.action-form {
    display: inline;
}

.edit-btn {
    padding: 8px 11px;
    background: #eaf1ff;
    color: #1d4ed8;
}

.edit-btn:hover {
    background: #dbeafe;
}

.activate-btn {
    padding: 8px 11px;
    background: #16a34a;
    color: white;
}

.activate-btn:hover {
    background: #15803d;
}

.deactivate-btn,
.delete-btn {
    padding: 8px 11px;
    background: #dc2626;
    color: white;
}

.deactivate-btn:hover,
.delete-btn:hover {
    background: #b91c1c;
}

.empty {
    text-align: center;
    padding: 35px;
    color: var(--muted);
}

/* ALERTS */

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

/* MODAL */

.modal {
    display: none;
    position: fixed;
    inset: 0;
    z-index: 2000;
    background: rgba(7,29,51,.55);
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.modal.active {
    display: flex;
}

.modal-content {
    background: white;
    width: 100%;
    max-width: 650px;
    max-height: 90vh;
    overflow-y: auto;
    border-radius: 13px;
    padding: 25px;
}

.modal-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 22px;
}

.modal-heading h3 {
    color: var(--primary);
    font-size: 18px;
}

.close-btn {
    background: transparent;
    color: #64748b;
    font-size: 25px;
}

.hospital-form {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 7px;
}

.form-group.full {
    grid-column: 1 / -1;
}

.form-group label {
    font-size: 12px;
    font-weight: 600;
    color: #475569;
}

.form-group input,
.form-group select {
    width: 100%;
}

.form-actions {
    grid-column: 1 / -1;
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 8px;
}

.cancel-btn {
    padding: 11px 18px;
    background: #e2e8f0;
    color: #334155;
}

.save-btn {
    padding: 11px 20px;
    background: var(--accent);
    color: white;
}

.save-btn:hover {
    background: #1d4ed8;
}

/* RESPONSIVE */

@media(max-width:1100px) {
    .summary {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media(max-width:900px) {
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

@media(max-width:650px) {
    .summary {
        grid-template-columns: 1fr;
    }

    .filters {
        width: 100%;
    }

    .filters input,
    .filters select {
        width: 100%;
    }

    .admin-name {
        display: none;
    }

    .brand h1 {
        font-size: 17px;
    }

    .hospital-form {
        grid-template-columns: 1fr;
    }

    .form-group.full,
    .form-actions {
        grid-column: 1;
    }
}

</style>
</head>

<body>

<header>

    <div class="brand">
        <div class="logo-box">
            <img src="<%= ctx %>/images/logo.jpg" alt="VHealthAssure Logo">
        </div>
        <h1>VHealthAssure</h1>
    </div>

    <div class="admin-area" id="adminArea">

        <div class="avatar"><%= esc(initial) %></div>

        <div class="admin-name">
            <%= esc(adminName) %> ▾
        </div>

        <div class="dropdown">
            <a href="<%= ctx %>/AdminProfile">Admin Profile</a>
            <a href="<%= ctx %>/AdminChangePassword">Change Password</a>
            <a href="<%= ctx %>/logout" class="logout">Logout</a>
        </div>

    </div>

</header>

<div class="layout">

    <aside class="sidebar">

        <div class="sidebar-heading">ADMIN MENU</div>

        <a href="<%= ctx %>/AdminDashboard">📊 Dashboard</a>
        <a href="<%= ctx %>/AdminUsers">👥 User Management</a>
        <a href="<%= ctx %>/AdminPolicies">📄 Policy Management</a>
        <a href="<%= ctx %>/AdminClaims">📋 Claims Management</a>
        <a href="<%= ctx %>/AdminKyc">🛡️ KYC Management</a>
        <a class="active" href="<%= ctx %>/AdminHospitals">🏥 Hospital Management</a>
        <a href="<%= ctx %>/AdminSupport">🎧 Support Management</a>

    </aside>

    <main>

        <div class="page-heading">
            <h2>Hospital Management</h2>
            <p>Manage network hospitals and their registration details.</p>
        </div>

        <% if ("added".equals(message) ||
               "updated".equals(message) ||
               "statusUpdated".equals(message) ||
               "deleted".equals(message)) { %>

            <div class="alert alert-success">
                <% if ("added".equals(message)) { %>
                    Hospital added successfully.
                <% } else if ("updated".equals(message)) { %>
                    Hospital details updated successfully.
                <% } else if ("deleted".equals(message)) { %>
                    Hospital deleted successfully.
                <% } else { %>
                    Hospital network status updated successfully.
                <% } %>
            </div>

        <% } else if (message != null) { %>

            <div class="alert alert-error">
                <% if ("invalidData".equals(message)) { %>
                    Please provide valid hospital information.
                <% } else if ("invalidId".equals(message)) { %>
                    Invalid hospital ID.
                <% } else if ("invalidAction".equals(message)) { %>
                    Invalid operation.
                <% } else if ("notAdded".equals(message)) { %>
                    Unable to add hospital.
                <% } else if ("notUpdated".equals(message)) { %>
                    Unable to update hospital.
                <% } else if ("notDeleted".equals(message)) { %>
                    Unable to delete hospital. It may be referenced by another record.
                <% } else { %>
                    Something went wrong. Please try again.
                <% } %>
            </div>

        <% } %>

        <!-- SUMMARY -->

        <section class="summary">

            <div class="summary-card">
                <span>Total Hospitals</span>
                <h3><%= totalHospitals %></h3>
            </div>

            <div class="summary-card">
                <span>Active Hospitals</span>
                <h3><%= activeHospitals %></h3>
            </div>

            <div class="summary-card">
                <span>Inactive Hospitals</span>
                <h3><%= inactiveHospitals %></h3>
            </div>

        </section>

        <!-- HOSPITAL TABLE -->

        <section class="panel">

            <div class="panel-heading">

                <h3>Registered Hospitals</h3>

                <div class="filters">

                    <form action="<%= ctx %>/AdminHospitals"
                          method="get"
                          class="filters">

                        <input type="text"
                               name="search"
                               placeholder="Search hospital, city, email..."
                               value="<%= esc(search) %>">

                        <select name="status">

                            <option value="ALL"
                                <%= "ALL".equals(selectedStatus) ? "selected" : "" %>>
                                All Status
                            </option>

                            <option value="ACTIVE"
                                <%= "ACTIVE".equals(selectedStatus) ? "selected" : "" %>>
                                Active
                            </option>

                            <option value="INACTIVE"
                                <%= "INACTIVE".equals(selectedStatus) ? "selected" : "" %>>
                                Inactive
                            </option>

                        </select>

                        <button type="submit" class="search-btn">
                            Search
                        </button>

                        <a href="<%= ctx %>/AdminHospitals" class="clear-link">
                            Clear
                        </a>

                    </form>

                    <button type="button"
                            class="search-btn"
                            onclick="openAddModal()">
                        + Add Hospital
                    </button>

                </div>

            </div>

            <div class="table-wrap">

                <table>

                    <thead>
                        <tr>
                            <th>HOSPITAL DETAILS</th>
                            <th>LOCATION</th>
                            <th>CONTACT NUMBER</th>
                            <th>EMAIL</th>
                            <th>NETWORK STATUS</th>
                            <th>REGISTERED DATE</th>
                            <th>ACTIONS</th>
                        </tr>
                    </thead>

                    <tbody>

                    <% if (hospitals != null && !hospitals.isEmpty()) { %>

                        <% for (Map<String, Object> hospital : hospitals) {

                            int hospitalId = ((Number) hospital.get("hospitalId")).intValue();

                            String hospitalName = esc(hospital.get("hospitalName"));
                            String address = esc(hospital.get("address"));
                            String city = esc(hospital.get("city"));
                            String state = esc(hospital.get("state"));
                            String contact = esc(hospital.get("contactNumber"));
                            String email = esc(hospital.get("email"));

                            String networkStatus =
                                hospital.get("networkStatus") == null
                                    ? "INACTIVE"
                                    : hospital.get("networkStatus").toString();

                            Object createdAt = hospital.get("createdAt");

                            String registeredDate =
                                createdAt == null
                                    ? "-"
                                    : dateFormat.format(createdAt);

                        %>

                        <tr>

                            <td>
                                <div class="hospital-name">
                                    <%= hospitalName %>
                                </div>

                                <div class="hospital-id">
                                    Hospital ID: <%= hospitalId %>
                                </div>
                            </td>

                            <td class="location">
                                <%= address %><br>
                                <%= city %>, <%= state %>
                            </td>

                            <td class="contact">
                                <%= contact.isEmpty() ? "-" : contact %>
                            </td>

                            <td>
                                <%= email.isEmpty() ? "-" : email %>
                            </td>

                            <td>
                                <span class="status <%= esc(networkStatus) %>">
                                    <%= esc(networkStatus) %>
                                </span>
                            </td>

                            <td><%= registeredDate %></td>

                            <td>

                                <div class="action-buttons">

                                    <button type="button"
                                            class="edit-btn"
                                            onclick="openEditModal(
                                                '<%= hospitalId %>',
                                                '<%= js(hospital.get("hospitalName")) %>',
                                                '<%= js(hospital.get("address")) %>',
                                                '<%= js(hospital.get("city")) %>',
                                                '<%= js(hospital.get("state")) %>',
                                                '<%= js(hospital.get("contactNumber")) %>',
                                                '<%= js(hospital.get("email")) %>',
                                                '<%= js(networkStatus) %>'
                                            )">
                                        Edit
                                    </button>

                                    <form action="<%= ctx %>/AdminHospitals"
                                          method="post"
                                          class="action-form"
                                          onsubmit="return confirm('Are you sure you want to change this hospital status?');">

                                        <input type="hidden" name="action" value="status">
                                        <input type="hidden" name="hospitalId" value="<%= hospitalId %>">

                                        <% if ("ACTIVE".equals(networkStatus)) { %>

                                            <input type="hidden" name="status" value="INACTIVE">

                                            <button type="submit" class="deactivate-btn">
                                                Deactivate
                                            </button>

                                        <% } else { %>

                                            <input type="hidden" name="status" value="ACTIVE">

                                            <button type="submit" class="activate-btn">
                                                Activate
                                            </button>

                                        <% } %>

                                    </form>

                                    <form action="<%= ctx %>/AdminHospitals"
                                          method="post"
                                          class="action-form"
                                          onsubmit="return confirm('Are you sure you want to permanently delete this hospital? This action cannot be undone.');">

                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="hospitalId" value="<%= hospitalId %>">

                                        <button type="submit" class="delete-btn">
                                            Delete
                                        </button>

                                    </form>

                                </div>

                            </td>

                        </tr>

                        <% } %>

                    <% } else { %>

                        <tr>
                            <td colspan="7" class="empty">
                                No hospitals found.
                            </td>
                        </tr>

                    <% } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

<!-- ADD / EDIT HOSPITAL MODAL -->

<div class="modal" id="hospitalModal">

    <div class="modal-content">

        <div class="modal-heading">

            <h3 id="modalTitle">Add Hospital</h3>

            <button type="button"
                    class="close-btn"
                    onclick="closeModal()">
                &times;
            </button>

        </div>

        <form action="<%= ctx %>/AdminHospitals"
              method="post"
              class="hospital-form"
              onsubmit="return validateHospitalForm();">

            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="hospitalId" id="hospitalId">

            <div class="form-group full">
                <label>Hospital Name *</label>
                <input type="text"
                       name="hospitalName"
                       id="hospitalName"
                       maxlength="150"
                       required>
            </div>

            <div class="form-group full">
                <label>Address *</label>
                <input type="text"
                       name="address"
                       id="address"
                       maxlength="255"
                       required>
            </div>

            <div class="form-group">
                <label>City *</label>
                <input type="text"
                       name="city"
                       id="city"
                       maxlength="100"
                       required>
            </div>

            <div class="form-group">
                <label>State *</label>
                <input type="text"
                       name="state"
                       id="state"
                       maxlength="100"
                       required>
            </div>

            <div class="form-group">
                <label>Contact Number</label>
                <input type="tel"
                       name="contactNumber"
                       id="contactNumber"
                       maxlength="20">
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email"
                       name="email"
                       id="email"
                       maxlength="150">
            </div>

            <div class="form-group full">
                <label>Network Status</label>
                <select name="networkStatus" id="networkStatus">
                    <option value="ACTIVE">Active</option>
                    <option value="INACTIVE">Inactive</option>
                </select>
            </div>

            <div class="form-actions">

                <button type="button"
                        class="cancel-btn"
                        onclick="closeModal()">
                    Cancel
                </button>

                <button type="submit" class="save-btn">
                    Save Hospital
                </button>

            </div>

        </form>

    </div>

</div>

<script>

/* PROFILE DROPDOWN */

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
        closeModal();
    }
});

/* HOSPITAL MODAL */

const hospitalModal = document.getElementById("hospitalModal");

function openAddModal() {

    document.getElementById("modalTitle").textContent = "Add Hospital";
    document.getElementById("formAction").value = "add";

    document.getElementById("hospitalId").value = "";
    document.getElementById("hospitalName").value = "";
    document.getElementById("address").value = "";
    document.getElementById("city").value = "";
    document.getElementById("state").value = "";
    document.getElementById("contactNumber").value = "";
    document.getElementById("email").value = "";
    document.getElementById("networkStatus").value = "ACTIVE";

    hospitalModal.classList.add("active");
}

function openEditModal(id, name, address, city, state, contact, email, status) {

    document.getElementById("modalTitle").textContent = "Edit Hospital";
    document.getElementById("formAction").value = "update";

    document.getElementById("hospitalId").value = id;
    document.getElementById("hospitalName").value = name;
    document.getElementById("address").value = address;
    document.getElementById("city").value = city;
    document.getElementById("state").value = state;
    document.getElementById("contactNumber").value = contact;
    document.getElementById("email").value = email;
    document.getElementById("networkStatus").value = status;

    hospitalModal.classList.add("active");
}

function closeModal() {
    hospitalModal.classList.remove("active");
}

hospitalModal.addEventListener("click", function(event) {
    if (event.target === hospitalModal) {
        closeModal();
    }
});

function validateHospitalForm() {

    const name = document.getElementById("hospitalName").value.trim();
    const address = document.getElementById("address").value.trim();
    const city = document.getElementById("city").value.trim();
    const state = document.getElementById("state").value.trim();

    if (!name || !address || !city || !state) {
        alert("Please fill in all required hospital details.");
        return false;
    }

    return true;
}

</script>

</body>
</html>