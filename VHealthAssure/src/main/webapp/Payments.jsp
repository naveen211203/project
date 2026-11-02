
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payments | VHealthAssure</title>

<style>
:root {
    --primary: #0b2a4a;
    --primary-dark: #071d33;
    --accent: #2563eb;
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
    height: 100vh;
    overflow: hidden;
}

/* HEADER */
header {
    height: 64px;
    background: linear-gradient(135deg, #071d33, #0b2a4a);
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 32px;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
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
    background: white;
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

/* PROFILE */
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
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
}

.profile-name {
    font-size: 14px;
}

.profile-dropdown {
    position: absolute;
    top: 52px;
    right: 0;
    background: white;
    color: #0f172a;
    width: 210px;
    border-radius: 12px;
    box-shadow: 0 20px 40px rgba(0,0,0,.2);
    overflow: hidden;
    opacity: 0;
    pointer-events: none;
    transform: translateY(-10px);
    transition: .25s;
    z-index: 100;
}

.profile-area.active .profile-dropdown {
    opacity: 1;
    pointer-events: auto;
    transform: translateY(0);
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
    border-top: 1px solid #e5e7eb;
    font-weight: 600;
}

/* LAYOUT */
.layout {
    position: fixed;
    top: 64px;
    left: 0;
    right: 0;
    bottom: 0;
    display: grid;
    grid-template-columns: 240px minmax(0, 1fr);
    overflow: hidden;
}

/* SIDEBAR */
.sidebar {
    background: #081a30;
    padding: 24px 16px;
    height: 100%;
    overflow-y: auto;
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
    color: white;
}

/* MAIN */
main {
    padding: 28px;
    height: 100%;
    overflow-y: auto;
    min-width: 0;
}

.page-heading {
    margin-bottom: 24px;
}

.page-heading h2 {
    color: var(--primary);
    font-size: 25px;
    margin-bottom: 7px;
}

.page-heading p {
    color: var(--muted);
    font-size: 14px;
}

/* SUMMARY CARDS */
.summary-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 26px;
}

.summary-card {
    background: white;
    padding: 20px;
    border-radius: 14px;
    box-shadow: 0 8px 20px rgba(0,0,0,.06);
}

.summary-card span {
    color: var(--muted);
    font-size: 13px;
}

.summary-card h2 {
    margin-top: 10px;
    font-size: 25px;
    color: var(--primary);
}

.summary-card .icon {
    font-size: 20px;
    margin-bottom: 10px;
}

/* PAYMENT TABLE */
.card {
    background: white;
    border-radius: 16px;
    padding: 22px;
    box-shadow: 0 10px 26px rgba(0,0,0,.07);
}

.card-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
}

.card-heading h3 {
    color: var(--primary);
    font-size: 18px;
}

.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 750px;
    border-collapse: collapse;
    font-size: 13px;
}

th {
    background: #f1f5f9;
    color: #475569;
    font-weight: 600;
}

th, td {
    padding: 15px 12px;
    text-align: left;
    border-bottom: 1px solid #e5e7eb;
}

td {
    color: #334155;
}

.status {
    padding: 5px 11px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

.success {
    color: #166534;
    background: #dcfce7;
}

.pending {
    color: #92400e;
    background: #fef3c7;
}

.failed {
    color: #991b1b;
    background: #fee2e2;
}

.receipt {
    color: #2563eb;
    text-decoration: none;
    font-weight: 600;
    font-size: 12px;
}

.receipt:hover {
    text-decoration: underline;
}

.info-note {
    margin-top: 20px;
    padding: 14px;
    background: #eff6ff;
    border-left: 4px solid #2563eb;
    border-radius: 8px;
    color: #1e40af;
    font-size: 12px;
}

footer {
    text-align: center;
    font-size: 12px;
    color: #94a3b8;
    padding: 20px;
}

/* RESPONSIVE */
@media(max-width: 900px) {
    .layout {
        grid-template-columns: 190px minmax(0, 1fr);
    }

    .summary-grid {
        grid-template-columns: 1fr;
    }
}

@media(max-width: 600px) {
    header {
        padding: 0 14px;
    }

    .brand h1 {
        font-size: 16px;
    }

    .profile-name {
        display: none;
    }

    .layout {
        grid-template-columns: minmax(0, 1fr);
        grid-template-rows: auto minmax(0, 1fr);
    }

    .sidebar {
        display: flex;
        gap: 5px;
        padding: 10px;
        overflow-x: auto;
        overflow-y: hidden;
        white-space: nowrap;
    }

    .sidebar a {
        flex: 0 0 auto;
        margin-bottom: 0;
        font-size: 12px;
    }

    main {
        padding: 18px;
    }

    .page-heading h2 {
        font-size: 21px;
    }

    .card {
        padding: 15px;
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
            <%= userName.charAt(0) %>
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
        <a href="CashlessHospitals">Cashless Hospitals</a>
        <a href="Payments.jsp" class="active">Payments</a>
        <a href="Kyc">KYC Details</a>
        <a href="Support">Support</a>
    </aside>

    <main>

        <div class="page-heading">
            <h2>Payments</h2>
            <p>View your insurance premium payment history and payment details.</p>
        </div>

        <!-- SUMMARY -->
        <div class="summary-grid">

            <div class="summary-card">
                <div class="icon">💳</div>
                <span>Total Payments</span>
                <h2>₹25,000</h2>
            </div>

            <div class="summary-card">
                <div class="icon">✓</div>
                <span>Successful Payments</span>
                <h2>4</h2>
            </div>

            <div class="summary-card">
                <div class="icon">⌛</div>
                <span>Pending Payments</span>
                <h2>1</h2>
            </div>

        </div>

        <!-- PAYMENT HISTORY -->
        <div class="card">

            <div class="card-heading">
                <h3>Payment History</h3>
            </div>

            <div class="table-wrapper">

                <table>
                    <thead>
                        <tr>
                            <th>Payment ID</th>
                            <th>Policy Number</th>
                            <th>Payment Date</th>
                            <th>Payment Method</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Receipt</th>
                        </tr>
                    </thead>

                    <tbody>

                        <tr>
                            <td>PAY1001</td>
                            <td>VHA2025001</td>
                            <td>10-01-2026</td>
                            <td>UPI</td>
                            <td>₹5,000</td>
                            <td><span class="status success">Success</span></td>
                            <td><span class="receipt">Sample</span></td>
                        </tr>

                        <tr>
                            <td>PAY1002</td>
                            <td>VHA2025002</td>
                            <td>15-02-2026</td>
                            <td>Debit Card</td>
                            <td>₹7,500</td>
                            <td><span class="status success">Success</span></td>
                            <td><span class="receipt">Sample</span></td>
                        </tr>

                        <tr>
                            <td>PAY1003</td>
                            <td>VHA2025001</td>
                            <td>10-04-2026</td>
                            <td>Net Banking</td>
                            <td>₹5,000</td>
                            <td><span class="status pending">Pending</span></td>
                            <td>—</td>
                        </tr>

                        <tr>
                            <td>PAY1004</td>
                            <td>VHA2025003</td>
                            <td>05-06-2026</td>
                            <td>UPI</td>
                            <td>₹4,000</td>
                            <td><span class="status success">Success</span></td>
                            <td><span class="receipt">Sample</span></td>
                        </tr>

                        <tr>
                            <td>PAY1005</td>
                            <td>VHA2025002</td>
                            <td>12-08-2026</td>
                            <td>Credit Card</td>
                            <td>₹3,500</td>
                            <td><span class="status failed">Failed</span></td>
                            <td>—</td>
                        </tr>

                    </tbody>
                </table>

            </div>

            <div class="info-note">
                These are sample payment records for demonstration purposes.
                No actual payment has been processed.
            </div>

        </div>

        <footer>
            © 2026 VHealthAssure Insurance Services | IRDAI Registered
        </footer>

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
