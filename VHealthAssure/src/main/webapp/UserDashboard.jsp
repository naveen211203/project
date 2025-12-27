<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if (session == null || session.getAttribute("loginId") == null) {
    	response.sendRedirect("login.html");
    	return;
	}
    com.VHealthAssure.Entity.RegistrationEntity user =
        (com.VHealthAssure.Entity.RegistrationEntity) request.getAttribute("user");

    String userName = user != null ? user.getFullName() : "John Doe";
    String city = user != null ? user.getCity() : "Hyderabad";

    int activePolicies = (int) request.getAttribute("activePolicies");
    int claimsFiled    = (int) request.getAttribute("claimsFiled");
    int approvedClaims = (int) request.getAttribute("approvedClaims");

    String nextPremium = (String) request.getAttribute("nextPremiumAmount");

    	java.sql.Date nextPremiumDate =
    	    (java.sql.Date) request.getAttribute("nextPremiumDate");


    ResultSet activePolicyRS =
        (ResultSet) request.getAttribute("activePolicyRS");

    ResultSet recentClaimsRS =
        (ResultSet) request.getAttribute("recentClaimsRS");
    String kycStatus = (String) request.getAttribute("kycStatus");
    if (kycStatus == null) kycStatus = "NOT VERIFIED";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Dashboard | VHealthAssure</title>

<!-- ❌ CSS NOT TOUCHED -->

<style>
:root{
  --primary:#0b2a4a;
  --primary-dark:#071d33;
  --accent:#2563eb;
  --success:#2e7d32;
  --warning:#ed6c02;
  --bg:#f4f6f9;
  --card:#ffffff;
  --text:#0f172a;
  --muted:#64748b;
}

/* RESET */
*{margin:0;padding:0;box-sizing:border-box;font-family:Poppins,Arial,sans-serif}
body{
  background:var(--bg);
  color:var(--text);
  height:100vh;
  overflow:hidden;   /* 🔥 prevents page scrollbar */
}


/* HEADER */
header{
  height:64px;
  background:linear-gradient(135deg,var(--primary-dark),var(--primary));
  color:#fff;
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding:0 32px;
}

/* BRAND WITH LOGO */
.brand{
  display:flex;
  align-items:center;
  gap:12px;
}

.logo-box{
  width:42px;
  height:42px;
  border-radius:12px;              /* rounded-square */
  background:linear-gradient(145deg,#f8fafc,#e2e8f0);
  display:flex;
  align-items:center;
  justify-content:center;
  overflow:hidden; 
  box-shadow:
    0 6px 14px rgba(0,0,0,0.25),
    inset 0 2px z rgba(255,255,255,0.6);
}

.logo-box img{
  width:100%;
  height:100%;
  object-fit:cover;  /* 🔥 FILL COMPLETELY */
}


.brand h1{
  font-size:20px;
  font-weight:600;
  letter-spacing:.3px;
}

/* PROFILE */
.profile-area{
  position:relative;
  display:flex;
  align-items:center;
  gap:10px;
  cursor:pointer;
  user-select:none;
}

.profile-avatar{
  width:38px;
  height:38px;
  border-radius:50%;
  background:linear-gradient(135deg,#2563eb,#1e40af);
  display:flex;
  align-items:center;
  justify-content:center;
  font-weight:600;
  font-size:15px;
  transition:transform .25s ease, box-shadow .25s ease;
}

.profile-area:hover .profile-avatar{
  transform:scale(1.05);
  box-shadow:0 8px 20px rgba(0,0,0,.35);
}

.profile-name{
  font-size:14px;
  opacity:.95;
}

/* DROPDOWN */
.profile-dropdown{
  position:absolute;
  top:52px;
  right:0;
  background:#fff;
  color:#0f172a;
  width:210px;
  border-radius:14px;
  box-shadow:0 20px 40px rgba(0,0,0,.2);
  overflow:hidden;
  transform:translateY(-10px) scale(.95);
  opacity:0;
  pointer-events:none;
  transition:all .25s ease;
  z-index:100;
}

.profile-area.active .profile-dropdown{
  transform:translateY(0) scale(1);
  opacity:1;
  pointer-events:auto;
}

.profile-dropdown a{
  display:block;
  padding:14px 18px;
  text-decoration:none;
  color:#0f172a;
  font-size:14px;
}

.profile-dropdown a:hover{
  background:#f1f5f9;
}

.profile-dropdown .logout{
  color:#c62828;
  font-weight:600;
  border-top:1px solid #e5e7eb;
}
.profile-area,
.profile-area:focus,
.profile-area:active,
.profile-area:focus-visible {
  background: transparent !important;
  outline: none !important;
}


/* LAYOUT */
.layout{
  display:grid;
  grid-template-columns:240px 1fr;
  height:calc(100vh - 64px); /* 🔥 exact height */
}


/* SIDEBAR */
.sidebar{
  background:#081a30;
  padding:24px 16px;
  height:100%;
  position:sticky;
  top:0;
  overflow:hidden;   /* 🔥 sidebar never scrolls */
}

.sidebar a{
  display:block;
  padding:12px 14px;
  margin-bottom:6px;
  color:#cbd5e1;
  text-decoration:none;
  border-radius:8px;
  font-size:14px;
}
.sidebar a:hover,.sidebar a.active{
  background:#1e293b;
  color:#fff;
}

/* MAIN */
main{
  padding:28px;
  height:100%;
  overflow-y:auto;   /* 🔥 only content scrolls */
}


/* KPI */
.kpi-row{
  display:grid;
  grid-template-columns:repeat(4,1fr);
  gap:20px;
  margin-bottom:28px;
}
.kpi{
  background:var(--card);
  padding:18px 20px;
  border-radius:14px;
  box-shadow:0 8px 20px rgba(0,0,0,.08);
}
.kpi span{font-size:13px;color:var(--muted)}
.kpi h2{margin-top:6px;font-size:26px}

/* GRID */
.dashboard-grid{
  display:grid;
  grid-template-columns:2.2fr 1fr;
  gap:24px;
}

/* CARD */
.card{
  background:var(--card);
  border-radius:16px;
  padding:22px;
  box-shadow:0 10px 26px rgba(0,0,0,.08);
}
.card h3{margin-bottom:16px;color:var(--primary)}

/* TABLE */
table{width:100%;border-collapse:collapse;font-size:14px}
th,td{padding:12px;border-bottom:1px solid #e5e7eb;text-align:left}

/* BADGE */
.badge{
  padding:4px 10px;
  border-radius:999px;
  font-size:12px;
  color:#fff;
}
.active{background:var(--success)}
.approved{background:var(--success)}
.review{background:var(--warning)}

/* KYC Health Status */
.kyc-status{
  display:flex;
  justify-content:space-between;
  align-items:center;
  padding:14px 18px;
  border-radius:12px;
  font-weight:600;
  margin-top:12px;
}

.kyc-status .label{
  font-size:14px;
  opacity:.9;
}

.kyc-status .value{
  font-size:14px;
}


.not-verified{
  background:#e0f2fe;
  color:#075985;
  border-left:5px solid #0284c7;
  
}

.pending{
  background:#fef3c7;
  color:#92400e;
  border-left:5px solid #f59e0b;
}

.verified{
  background:#ecfdf5;
  color:#065f46;
  border-left:5px solid #16a34a;
}

.rejected{
  background:#fef2f2;
  color:#991b1b;
  border-left:5px solid #dc2626;
}


/* BUTTON */
.btn{
  display:inline-block;
  margin-top:14px;
  padding:9px 16px;
  background:var(--accent);
  color:#fff;
  border-radius:999px;
  text-decoration:none;
  font-size:13px;
}

.right-col{display:flex;flex-direction:column;gap:24px}
.alert{background:#fff7ed;border-left:6px solid var(--warning)}

footer{
  text-align:center;
  font-size:12px;
  color:#94a3b8;
  padding:16px;
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
    <div class="profile-avatar"><%= userName.charAt(0) %></div>
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
  <a class="active" href="User-Dashboard">Dashboard</a>
  <a>My Policies</a>
  <a>Claims</a>
  <a>Cashless Hospitals</a>
  <a>Payments</a>
  <a href="Kyc">KYC Details</a>
  <a>Support</a>
</aside>

<main>

<!-- KPI -->
<div class="kpi-row">
  <div class="kpi"><span>Active Policies</span><h2><%= activePolicies %></h2></div>
  <div class="kpi"><span>Claims Filed</span><h2><%= claimsFiled %></h2></div>
  <div class="kpi"><span>Approved Claims</span><h2><%= approvedClaims %></h2></div>
  <div class="kpi"><span>Next Premium Due</span><h2><%= nextPremium %></h2></div>
</div>

<div class="dashboard-grid">

<!-- LEFT -->
<div>

<!-- ACTIVE POLICY -->
<div class="card">
<h3>Active Policy Snapshot</h3>
<table>
<tr><th>Policy No</th><th>Type</th><th>Status</th></tr>

<%
boolean hasActivePolicy = false;
int policyCount = 0;

if (activePolicyRS != null) {
    while (activePolicyRS.next() && policyCount < 2) {
        hasActivePolicy = true;
        policyCount++;
%>
<tr>
  <td><%= activePolicyRS.getString("PolicyNumber") %></td>
  <td><%= activePolicyRS.getString("PolicyType") %></td>
  <td>
    <span class="badge active">
      <%= activePolicyRS.getString("Status") %>
    </span>
  </td>
</tr>
<%
    }
}

if (!hasActivePolicy) {
%>
<tr>
  <td colspan="3" style="text-align:center; color:#64748b; padding:20px;">
    No Active Policies
  </td>
</tr>
<%
}
%>

</table>


<a class="btn">View Policy Details</a>
</div>

<br>

<!-- RECENT CLAIMS -->
<div class="card">
<h3>Recent Claims</h3>
<table>
<tr><th>Claim ID</th><th>Date</th><th>Status</th></tr>

<%
boolean hasClaims = false;
if (recentClaimsRS != null) {
    while (recentClaimsRS.next()) {
        hasClaims = true;
        String status = recentClaimsRS.getString("Status");
        String badge  = "APPROVED".equals(status) ? "approved" : "review";
%>
<tr>
  <td><%= recentClaimsRS.getString("ClaimNumber") %></td>
  <td><%= recentClaimsRS.getDate("ClaimDate") %></td>
  <td><span class="badge <%= badge %>"><%= status %></span></td>
</tr>
<%
    }
}

if (!hasClaims) {
%>
<tr>
  <td colspan="3" style="text-align:center; color:#64748b; padding:20px;">
    Not Claimed Yet
  </td>
</tr>
<%
}
%>

</table>

<a class="btn">Track All Claims</a>
</div>

</div>

<!-- RIGHT -->
<div class="right-col">

<div class="card alert">
<h3>Premium Reminder</h3>
<p>
Your next premium is due on
<b>
<%= nextPremiumDate != null ? nextPremiumDate : "—" %>
</b>
</p>

</div>

<div class="card">
<h3>Cashless Hospitals in <%= city %></h3>
<ul>
<li>Care Multispeciality Hospital</li>
<li>CityLife Medical Center</li>
<li>MedPlus Network Hospital</li>
</ul>
<a class="btn">View Full Network</a>
</div>

<div class="card">
<h3>KYC Details</h3>
<div class="kyc-status <%= kycStatus.replace(" ", "-").toLowerCase() %>">
  <span class="label">Status</span>
  <span class="value">
    <% if ("NOT VERIFIED".equals(kycStatus)) { %>
      Not Verified
    <% } else if ("PENDING".equals(kycStatus)) { %>
      Pending Verification
    <% } else if ("VERIFIED".equals(kycStatus)) { %>
      Verified
    <% } else if ("REJECTED".equals(kycStatus)) { %>
      Rejected
    <% } %>
  </span>
</div>

</div>


</div>

</div>
</main>
</div>

<footer>
© 2025 VHealthAssure Insurance Services | IRDAI Registered
</footer>

<script>
const profile = document.getElementById("profileArea");
profile.addEventListener("click", () => profile.classList.toggle("active"));
document.addEventListener("click", e => {
  if(!profile.contains(e.target)) profile.classList.remove("active");
});


(function () {
	  // If page is loaded from browser cache (Back button)
	  window.addEventListener("pageshow", function (event) {
	    if (event.persisted || performance.getEntriesByType("navigation")[0].type === "back_forward") {
	      // Force reload from server
	      window.location.reload();
	    }
	  });
	})();
</script>

</body>
</html>
