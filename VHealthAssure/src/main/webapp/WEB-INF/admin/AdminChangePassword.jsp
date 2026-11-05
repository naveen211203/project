<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null ||
        session.getAttribute("loginId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }

    String ctx = request.getContextPath();

    String adminName = (String) session.getAttribute("userName");

    if (adminName == null || adminName.trim().isEmpty()) {
        adminName = "Admin";
    }

    String initial = adminName.substring(0, 1).toUpperCase();

    String message = request.getParameter("message");
    String toastMessage = null;
    String toastType = null;

    if ("success".equals(message)) {
        toastMessage = "Password changed successfully!";
        toastType = "success";
    } else if ("incorrect".equals(message)) {
        toastMessage = "Current password is incorrect.";
        toastType = "error";
    } else if ("mismatch".equals(message)) {
        toastMessage = "New password and confirm password do not match.";
        toastType = "error";
    } else if ("weakPassword".equals(message)) {
        toastMessage = "Please choose a stronger password.";
        toastType = "error";
    } else if ("samePassword".equals(message)) {
        toastMessage = "New password must be different from current password.";
        toastType = "error";
    } else if ("required".equals(message)) {
        toastMessage = "Please fill in all password fields.";
        toastType = "error";
    } else if ("failed".equals(message)) {
        toastMessage = "Unable to update password. Please try again.";
        toastType = "error";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Change Password | VHealthAssure</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>

:root {
    --primary: #0b2a4a;
    --primary-dark: #071d33;
    --accent: #2563eb;
    --bg: #f4f6fa;
    --card: #ffffff;
    --text: #0f172a;
    --muted: #64748b;
    --border: #e5e7eb;
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
        var(--primary-dark),
        var(--primary)
    );

    color: #fff;

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
    border-radius: 10px;
    background: #fff;
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
    user-select: none;
}

.avatar {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: var(--accent);

    display: flex;
    align-items: center;
    justify-content: center;

    font-weight: 600;
    font-size: 15px;
}

.admin-name {
    font-size: 14px;
    opacity: .95;
}

/* ================= DROPDOWN ================= */

.dropdown {
    position: absolute;
    top: 48px;
    right: 0;

    background: #fff;
    color: #0f172a;

    width: 180px;
    border-radius: 10px;

    box-shadow: 0 10px 30px rgba(0,0,0,.15);
    overflow: hidden;

    opacity: 0;
    pointer-events: none;
    transform: translateY(-10px);

    transition: all .25s ease;
    z-index: 1100;
}

.admin-area.active .dropdown {
    opacity: 1;
    pointer-events: auto;
    transform: translateY(0);
}

.dropdown a {
    display: block;
    padding: 13px 16px;

    text-decoration: none;
    color: #0f172a;
    font-size: 13px;
}

.dropdown a:hover {
    background: #f1f5f9;
}

.dropdown .logout {
    color: #dc2626;
    border-top: 1px solid #e5e7eb;
}

/* ================= ADMIN LAYOUT ================= */

.layout {
    padding-top: 68px;
    min-height: 100vh;
}

/* ================= ADMIN SIDEBAR ================= */

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
    color: #fff;
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

/* ================= ORIGINAL PASSWORD CARD ================= */

.wrapper {
    max-width: 680px;
    margin: 60px auto;
}

.card {
    background: linear-gradient(
        180deg,
        #f8fafc 0%,
        #ffffff 40%
    );

    border-radius: 18px;
    padding: 38px 44px;

    box-shadow: 0 10px 26px rgba(0,0,0,.08);

    border-left: 4px solid var(--primary);
}

.card h2 {
    font-size: 20px;
    color: var(--primary);
    margin-bottom: 8px;
}

.card p {
    font-size: 14px;
    color: var(--muted);
    margin-bottom: 30px;
}

/* ================= PASSWORD FIELDS ================= */

.field {
    display: flex;
    align-items: center;
    gap: 16px;

    margin-bottom: 22px;
    position: relative;
}

.field label {
    min-width: 180px;
    font-size: 14px;
    font-weight: 500;
}

.field input {
    flex: 1;
    min-width: 0;

    padding: 12px 70px 12px 14px;

    border-radius: 10px;
    border: 1px solid #c7d7f3;

    background: #f8fbff;
    font-size: 14px;
    outline: none;
}

.field input:focus {
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(37,99,235,.08);
}

.toggle-text {
    position: absolute;
    right: 16px;

    font-size: 13px;
    color: var(--accent);
    cursor: pointer;
}

/* ================= PASSWORD STRENGTH ================= */

.password-strength-container {
    margin-left: 196px;
    margin-top: 16px;
    margin-bottom: 22px;
}

.strength-meter {
    width: 100%;
    height: 8px;

    background: #e0e0e0;
    border-radius: 4px;
    overflow: hidden;
}

.strength-meter-fill {
    height: 100%;
    width: 0%;
    transition: all .4s;
}

.strength-text {
    margin-top: 8px;
    font-size: 13px;
    font-weight: 500;
}

.strength-requirements {
    margin-top: 14px;
}

.requirement {
    display: flex;
    align-items: center;
    gap: 8px;

    font-size: 13px;
    color: #777;
    margin-bottom: 6px;
}

.requirement.valid {
    color: #4caf50;
}

.requirement i {
    width: 16px;
    text-align: center;
}

/* ================= STRENGTH LEVELS ================= */

.strength-very-weak .strength-meter-fill {
    width: 20%;
    background: #dc2626;
}

.strength-weak .strength-meter-fill {
    width: 40%;
    background: #f97316;
}

.strength-medium .strength-meter-fill {
    width: 60%;
    background: #eab308;
}

.strength-strong .strength-meter-fill {
    width: 80%;
    background: #22c55e;
}

.strength-very-strong .strength-meter-fill {
    width: 100%;
    background: #16a34a;
}

/* ================= ACTION BUTTONS ================= */

.actions {
    display: flex;
    justify-content: flex-end;
    gap: 16px;
}

.btn {
    padding: 11px 26px;
    border-radius: 10px;
    border: none;
    font-size: 14px;
    cursor: pointer;
}

.btn-primary {
    background: #ffb74d;
    color: black;
}

.btn-primary:disabled {
    background: #94a3b8;
    cursor: not-allowed;
}

.btn-secondary {
    background: #e5e7eb;
}

/* ================= TOAST ================= */

.toast {
    position: fixed;
    top: 80px;
    right: 30px;

    min-width: 280px;
    padding: 14px 18px;

    border-radius: 10px;
    color: #fff;
    font-size: 14px;

    box-shadow: 0 10px 30px rgba(0,0,0,.25);

    opacity: 0;
    pointer-events: none;
    transform: translateY(-10px);

    transition: all .4s ease;
    z-index: 9999;
}

.toast.show {
    opacity: 1;
    transform: translateY(0);
}

.toast.success {
    background: #2e7d32;
}

.toast.error {
    background: #c62828;
}

/* ================= RESPONSIVE ================= */

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

    .wrapper {
        margin: 35px auto;
    }
}

@media(max-width: 650px) {

    header {
        padding: 0 15px;
    }

    .admin-name {
        display: none;
    }

    .brand h1 {
        font-size: 17px;
    }

    .card {
        padding: 25px 20px;
    }

    .field {
        display: block;
    }

    .field label {
        display: block;
        margin-bottom: 9px;
    }

    .field input {
        width: 100%;
    }

    .toggle-text {
        top: 38px;
    }

    .password-strength-container {
        margin-left: 0;
        margin-top: 0;
    }

    .actions {
        flex-wrap: wrap;
    }

    .toast {
        right: 15px;
        left: 15px;
        min-width: 0;
    }
}

</style>

</head>

<body>

<!-- ================= ADMIN HEADER ================= -->

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
            <%= initial %>
        </div>

        <div class="admin-name">
            <%= adminName %> ▾
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

    <!-- ================= ADMIN SIDEBAR ================= -->

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

    <!-- ================= MAIN CONTENT ================= -->

    <main>

        <div class="page-heading">

            <h2>Change Password</h2>

            <p>
                Manage your administrator account security.
            </p>

        </div>

        <div class="wrapper">

            <div class="card">

                <h2>Change Password</h2>

                <p>
                    For security reasons, please update your password regularly.
                </p>

                <form method="post"
                      action="<%= ctx %>/AdminChangePassword"
                      id="changePasswordForm">

                    <!-- CURRENT PASSWORD -->

                    <div class="field">

                        <label for="currentPwd">
                            Current Password
                        </label>

                        <input type="password"
                               id="currentPwd"
                               name="currentPassword"
                               autocomplete="current-password"
                               required>

                        <span class="toggle-text"
                              onclick="togglePwd('currentPwd',this)">
                            Show
                        </span>

                    </div>

                    <!-- NEW PASSWORD -->

                    <div class="field">

                        <label for="newPwd">
                            New Password
                        </label>

                        <input type="password"
                               id="newPwd"
                               name="newPassword"
                               autocomplete="new-password"
                               oninput="checkStrength()"
                               required>

                        <span class="toggle-text"
                              onclick="togglePwd('newPwd',this)">
                            Show
                        </span>

                    </div>

                    <!-- PASSWORD STRENGTH -->

                    <div class="password-strength-container"
                         id="strengthBox">

                        <div class="strength-meter">

                            <div class="strength-meter-fill"></div>

                        </div>

                        <div class="strength-text"
                             id="strengthText"></div>

                        <div class="strength-requirements">

                            <div class="requirement" id="len">
                                <i class="fa fa-times-circle"></i>
                                At least 8 characters
                            </div>

                            <div class="requirement" id="up">
                                <i class="fa fa-times-circle"></i>
                                1 uppercase letter
                            </div>

                            <div class="requirement" id="low">
                                <i class="fa fa-times-circle"></i>
                                1 lowercase letter
                            </div>

                            <div class="requirement" id="num">
                                <i class="fa fa-times-circle"></i>
                                1 number
                            </div>

                            <div class="requirement" id="spec">
                                <i class="fa fa-times-circle"></i>
                                1 special character
                            </div>

                        </div>

                    </div>

                    <!-- CONFIRM PASSWORD -->

                    <div class="field">

                        <label for="confirmPwd">
                            Confirm New Password
                        </label>

                        <input type="password"
                               id="confirmPwd"
                               name="confirmPassword"
                               autocomplete="new-password"
                               oninput="checkStrength()"
                               required>

                        <span class="toggle-text"
                              onclick="togglePwd('confirmPwd',this)">
                            Show
                        </span>

                    </div>

                    <!-- ACTIONS -->

                    <div class="actions">

                        <button type="reset"
                                class="btn btn-secondary">
                            Cancel
                        </button>

                        <button type="submit"
                                class="btn btn-primary"
                                id="updateBtn"
                                disabled>
                            Update Password
                        </button>

                    </div>

                </form>

            </div>

        </div>

    </main>

</div>

<!-- TOAST -->

<div id="toast" class="toast"></div>

<script>

/* ================= SHOW / HIDE PASSWORD ================= */

function togglePwd(id, el) {

    const input = document.getElementById(id);

    input.type = input.type === "password"
        ? "text"
        : "password";

    el.textContent = input.type === "password"
        ? "Show"
        : "Hide";
}


/* ================= PASSWORD STRENGTH ================= */

function checkStrength() {

    const p = document.getElementById("newPwd").value;

    const c = document.getElementById("confirmPwd").value;

    const container = document.getElementById("strengthBox");

    const text = document.getElementById("strengthText");

    const btn = document.getElementById("updateBtn");

    container.classList.remove(
        "strength-very-weak",
        "strength-weak",
        "strength-medium",
        "strength-strong",
        "strength-very-strong"
    );

    const rules = {

        len: p.length >= 8,

        up: /[A-Z]/.test(p),

        low: /[a-z]/.test(p),

        num: /[0-9]/.test(p),

        spec: /[^A-Za-z0-9]/.test(p)

    };

    let score = 0;

    for (let k in rules) {

        document.getElementById(k).classList.toggle(
            "valid",
            rules[k]
        );

        document.querySelector("#" + k + " i").className =
            rules[k]
                ? "fa fa-check-circle"
                : "fa fa-times-circle";

        if (rules[k]) {
            score++;
        }

    }

    if (p.length === 0) {

        text.textContent = "";

        btn.disabled = true;

        return;
    }

    if (score <= 1) {

        container.classList.add("strength-very-weak");
        text.textContent = "Very Weak";

    } else if (score === 2) {

        container.classList.add("strength-weak");
        text.textContent = "Weak";

    } else if (score === 3) {

        container.classList.add("strength-medium");
        text.textContent = "Medium";

    } else if (score === 4) {

        container.classList.add("strength-strong");
        text.textContent = "Strong";

    } else {

        container.classList.add("strength-very-strong");
        text.textContent = "Very Strong";

    }

    btn.disabled = !(score >= 4 && p === c);

}


/* ================= CANCEL / RESET ================= */

document.getElementById("changePasswordForm")
    .addEventListener("reset", function() {

        setTimeout(function() {

            checkStrength();

            document.querySelectorAll(".toggle-text")
                .forEach(function(element) {
                    element.textContent = "Show";
                });

            document.querySelectorAll("input[type='password'], input[type='text']")
                .forEach(function(input) {
                    if (input.id === "currentPwd" ||
                        input.id === "newPwd" ||
                        input.id === "confirmPwd") {
                        input.type = "password";
                    }
                });

        }, 0);

    });


/* ================= ADMIN PROFILE DROPDOWN ================= */

const adminArea = document.getElementById("adminArea");

adminArea.addEventListener("click", function(event) {

    event.stopPropagation();

    adminArea.classList.toggle("active");

});

document.addEventListener("click", function(event) {

    if (!adminArea.contains(event.target)) {
        adminArea.classList.remove("active");
    }

});

document.addEventListener("keydown", function(event) {

    if (event.key === "Escape") {
        adminArea.classList.remove("active");
    }

});


/* ================= TOAST MESSAGE ================= */

function showToast(message, type) {

    const toast = document.getElementById("toast");

    toast.textContent = message;

    toast.className = "toast " + type + " show";

    setTimeout(function() {

        toast.classList.remove("show");

    }, 3000);

}

<% if (toastMessage != null) { %>

showToast(
    "<%= toastMessage %>",
    "<%= toastType %>"
);

<% } %>


/* ================= BROWSER BACK CACHE ================= */

window.addEventListener("pageshow", function(event) {

    const navigation =
        performance.getEntriesByType("navigation")[0];

    if (event.persisted ||
        (navigation && navigation.type === "back_forward")) {

        window.location.reload();

    }

});

</script>

</body>
</html>