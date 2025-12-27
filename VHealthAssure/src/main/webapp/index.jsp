<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session == null || session.getAttribute("loginId") == null) {
    response.sendRedirect("login.html");
    return;
}

String kycStatus = (String) request.getAttribute("kycStatus");
Integer attempts = (Integer) request.getAttribute("attempts");
String govIdType = (String) request.getAttribute("govIdType");
String govIdNumber = (String) request.getAttribute("govIdNumber");
String fullName = (String) request.getAttribute("fullName");
char initial = Character.toUpperCase(fullName.trim().charAt(0));

if (kycStatus == null) kycStatus = "NOT VERIFIED";
if (attempts == null) attempts = 0;
if (govIdType == null) govIdType = "";
if (govIdNumber == null) govIdNumber = "";
%>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>KYC Status | VHealthAssure</title>

<style>
:root{
  --primary:#0b2a4a;
  --primary-dark:#071d33;
  --accent:#2563eb;
  --bg:#f4f6f9;
  --card:#ffffff;
  --text:#0f172a;
  --muted:#64748b;
  --border:#e5e7eb;
  --warn:#dc2626;
}

/* RESET */
*{margin:0;padding:0;box-sizing:border-box;font-family:Poppins,Arial,sans-serif}
body{
  background:var(--bg);
  height:100vh;
  overflow:hidden;
  color:var(--text);
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
  height:calc(100vh - 64px);
}

/* SIDEBAR */
.sidebar{
  background:#081a30;
  padding:24px 16px;
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
  padding:40px;
  overflow-y:auto;
}

/* KYC CONTAINER */
.kyc-container{
  max-width:780px;
  margin:auto;
  background:#fff;
  border-radius:20px;
  box-shadow:0 18px 40px rgba(0,0,0,.12);
  padding:40px;
}

/* TITLES */
.kyc-title{
  font-size:22px;
  color:var(--primary);
  margin-bottom:6px;
}
.kyc-sub{
  color:var(--muted);
  font-size:14px;
  margin-bottom:28px;
}

/* STATUS */
.status-strip{
  display:flex;
  justify-content:space-between;
  align-items:center;
  padding:16px 20px;
  background:#fef2f2;
  border-radius:14px;
  border-left:5px solid var(--warn);
  margin-bottom:32px;
}
.status-strip strong{
  color:var(--warn);
  font-size:14px;
}
/* STATUS STRIP VARIANTS */
.status-not-verified{
  background:#eff6ff;
  border-left-color:#2563eb;
}
.status-not-verified strong{
  color:#2563eb;
}

.status-pending{
  background:#fff7ed;
  border-left-color:#f59e0b;
}
.status-pending strong{
  color:#f59e0b;
}

.status-rejected{
  background:#fef2f2;
  border-left-color:#dc2626;
}
.status-rejected strong{
  color:#dc2626;
}

/* INFO */
.info{
  display:flex;
  flex-direction:column;
  gap:16px;
  margin-bottom:30px;
}
.info-row{
  display:flex;
  justify-content:space-between;
  font-size:14px;
}
.label{color:var(--muted)}
.value{font-weight:600}

/* INSTRUCTIONS */
.instructions{
  background:#f8fafc;
  border:1px solid var(--border);
  padding:18px;
  border-radius:14px;
  font-size:14px;
  color:#334155;
  line-height:1.7;
  margin-bottom:26px;
}

/* UPLOAD */
.upload-box{
  border:2px dashed #c7d7f3;
  border-radius:16px;
  min-height:200px;

  display:flex;
  flex-direction:column;
  align-items:center;
  justify-content:center;

  gap:12px;
  padding:28px;
  text-align:center;
  margin-bottom:24px;

  transition:all .3s ease;
  animation:pulseBorder 2.5s infinite;
}

.upload-box:hover{
  background:#f8fbff;
  border-color:#2563eb;
}

/* ICON */
.upload-icon{
  font-size:40px;
  opacity:.9;
  animation:floatIcon 3s ease-in-out infinite;
}

/* TITLE */
.upload-title{
  font-size:16px;
  font-weight:600;
  color:#0f172a;
}

/* DESCRIPTION */
.upload-desc{
  font-size:14px;
  color:#64748b;
}

/* BUTTON */
.upload-btn{
  margin-top:6px;
  background:#2563eb;
  color:#fff;
  padding:10px 24px;
  border-radius:10px;
  font-size:14px;
  font-weight:600;
  cursor:pointer;
  transition:transform .2s ease, box-shadow .2s ease;
}

.upload-btn:hover{
  transform:translateY(-2px);
  box-shadow:0 8px 20px rgba(37,99,235,.25);
}

.upload-btn input{
  display:none;
}

/* NOTE */
.upload-note{
  font-size:12px;
  color:#64748b;
}

/* ANIMATIONS */
@keyframes floatIcon{
  0%,100%{transform:translateY(0)}
  50%{transform:translateY(-6px)}
}

@keyframes pulseBorder{
  0%{box-shadow:0 0 0 0 rgba(37,99,235,.15)}
  70%{box-shadow:0 0 0 10px rgba(37,99,235,0)}
  100%{box-shadow:0 0 0 0 rgba(37,99,235,0)}
}


/* AFTER UPLOAD STATE */
.upload-box.uploaded{
  animation:none;
  border-style:solid;
  border-color:#22c55e;
  background:#f0fdf4;
}

.upload-success{
  display:flex;
  align-items:center;
  gap:10px;
  font-size:15px;
  font-weight:600;
  color:#166534;
  animation:fadeIn .4s ease;
}

.upload-file{
  font-size:13px;
  color:#334155;
  margin-top:6px;
}

@keyframes fadeIn{
  from{opacity:0; transform:translateY(6px)}
  to{opacity:1; transform:translateY(0)}
}

/* REMOVE FILE BUTTON */
.remove-file{
  margin-top:8px;
  background:none;
  border:none;
  color:#dc2626;
  font-size:13px;
  font-weight:600;
  cursor:pointer;
}

.remove-file:hover{
  text-decoration:underline;
}


/* DECLARATION */
.declaration{
  display:flex;
  gap:10px;
  font-size:13px;
  color:#334155;
  margin-bottom:30px;
}
.declaration input{
  width:20px;
  height:20px;
  cursor:pointer;
}

/* ACTION */
.action{
  display:flex;
  justify-content:flex-end;
}
.btn{
  padding:12px 36px;
  border-radius:12px;
  border:none;
  background:var(--accent);
  color:#fff;
  font-size:14px;
  font-weight:600;
  cursor:pointer;
}
.btn:hover{background:#1e4fd8}
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
    <div class="profile-avatar"><%= initial %></div>
    <div class="profile-name"><%= fullName %></div>

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
  <a>My Policies</a>
  <a>Claims</a>
  <a>Cashless Hospitals</a>
  <a>Payments</a>
  <a class="active" href="Kyc">KYC Details</a>
  <a>Support</a>
</aside>

<main>

<div class="kyc-container">

  <div class="kyc-title">Identity Verification</div>
  <%-- KYC SUB TITLE --%>
<div class="kyc-sub">
  <% if ("NOT VERIFIED".equals(kycStatus)) { %>
    Verification required to activate full services
  <% } else if ("PENDING".equals(kycStatus)) { %>
    Your documents are being reviewed
  <% } else if ("REJECTED".equals(kycStatus) && attempts < 3) { %>
    Verification failed – please reupload valid documents
  <% } else if ("REJECTED".equals(kycStatus) && attempts >= 3) { %>
    Verification locked due to multiple failed attempts
  <% } else if ("VERIFIED".equals(kycStatus)) { %>
    Your identity has been successfully verified
  <% } %>
</div>

<%
boolean showStrip =
    "NOT VERIFIED".equals(kycStatus) ||
    "PENDING".equals(kycStatus) ||
    ("REJECTED".equals(kycStatus) && attempts <= 3);
%>

<%-- STATUS STRIP --%>
<%
String stripClass = "";

if ("NOT VERIFIED".equals(kycStatus)) {
  stripClass = "status-not-verified";
} else if ("PENDING".equals(kycStatus)) {
  stripClass = "status-pending";
} else if ("REJECTED".equals(kycStatus)) {
  stripClass = "status-rejected";
}
%>

<% if (showStrip) { %>
<div class="status-strip <%= stripClass %>">
  <span>
    <% if ("NOT VERIFIED".equals(kycStatus)) { %>
      KYC not submitted
    <% } else if ("PENDING".equals(kycStatus)) { %>
      Verification in progress
    <% } else if ("REJECTED".equals(kycStatus) && attempts<3) { %>
      KYC rejected – you may reapply
    <% } else if ("REJECTED".equals(kycStatus) && attempts>=3) { %>
      KYC rejected multiple times
    <% } %>
  </span>
  <strong><%= kycStatus %></strong>
</div>
<% } %>


<%-- INSTRUCTIONS (ALWAYS SHOWN) --%>
<div class="instructions">
  <% if ("NOT VERIFIED".equals(kycStatus)) { %>
    Please upload a clear copy of your government-issued ID to start verification.
  <% } else if ("PENDING".equals(kycStatus)) { %>
    Your document has already been uploaded and is currently under verification.
  <% } else if ("REJECTED".equals(kycStatus) && attempts < 3) { %>
    Your previous submission was rejected. Please upload a valid document again.
  <% } else if ("REJECTED".equals(kycStatus) && attempts >= 3) { %>
    ❌ Maximum KYC attempts exceeded. Please contact support for assistance.
  <% } else if ("VERIFIED".equals(kycStatus)) { %>
    ✅ Your KYC has been verified successfully. You now have full access.
  <% } %>
</div>
  
  
<% if ("NOT VERIFIED".equals(kycStatus) ||
       ("REJECTED".equals(kycStatus) && attempts < 3)) { %>
  <div class="info">
    <div class="info-row">
      <span class="label">Government ID</span>
      <span class="value"><%= govIdType %></span>
    </div>
    <div class="info-row">
      <span class="label">ID Number</span>
      <span class="value"><%= govIdNumber %></span>
    </div>
  </div>

  <div class="instructions">
    <strong>Please upload a clear copy of your government-issued ID.</strong><br>
    • Accepted formats: PDF, JPG, PNG<br>
    • File size should not exceed 5 MB<br>
    • Ensure name and ID number are clearly visible<br>
    • Do not upload expired or masked documents<br>
    • Uploaded document must match the Government ID type and ID number.
  </div>
  
<form action="UploadKyc" method="post" enctype="multipart/form-data">
<input type="hidden" name="GovIdType" value="<%= govIdType %>">
<input type="hidden" name="GovIdNumber" value="<%= govIdNumber %>">


  <div class="upload-box">
    <div class="upload-icon">📄</div>
    <div class="upload-title">Upload your Government ID</div>
    <div class="upload-desc">Drag & drop your document here or click to browse</div>

    <label class="upload-btn">
      Choose File
      <input type="file"
             name="kycFile"
             accept=".pdf,.jpg,.jpeg,.png"
             id="kycFile"
             required>
    </label>

    <div class="upload-note">PDF, JPG or PNG • Max size 5 MB</div>
    
    
  </div>

  <div class="declaration">
    <input type="checkbox" id="declare" required>
    <label for="declare">
      I hereby declare that the document uploaded is genuine and belongs to me.
      I understand that providing false information may result in rejection of my account.
    </label>
  </div>

  <div class="action">
    <button class="btn" type="submit">Submit for Verification</button>
  </div>

</form>

<% } %>

</div>

</main>
</div>

<script>
/* ===============================
   PROFILE DROPDOWN
================================ */
document.addEventListener("DOMContentLoaded", () => {
  const profileArea = document.getElementById("profileArea");

  if (profileArea) {
    profileArea.addEventListener("click", function () {
      this.classList.toggle("active");
    });

    document.addEventListener("click", function (e) {
      if (!profileArea.contains(e.target)) {
        profileArea.classList.remove("active");
      }
    });
  }
});


/* ===============================
   KYC FILE UPLOAD HANDLER
   (SAFE – DOES NOT BREAK INPUT)
================================ */
document.addEventListener("DOMContentLoaded", () => {

  const fileInput = document.getElementById("kycFile");
  const uploadBox = document.querySelector(".upload-box");

  if (!fileInput || !uploadBox) return;

  // Grab existing elements (DO NOT REMOVE THEM)
  const icon = uploadBox.querySelector(".upload-icon");
  const title = uploadBox.querySelector(".upload-title");
  const desc  = uploadBox.querySelector(".upload-desc");
  const btn   = uploadBox.querySelector(".upload-btn");
  const note  = uploadBox.querySelector(".upload-note");

  // Create uploaded state elements (once)
  const successText = document.createElement("div");
  successText.className = "upload-success";
  successText.textContent = "✅ Document uploaded";

  const fileNameDiv = document.createElement("div");
  fileNameDiv.className = "upload-file";

  const removeBtn = document.createElement("button");
  removeBtn.type = "button";
  removeBtn.className = "remove-file";
  removeBtn.textContent = "✖";

  const fileRow = document.createElement("div");
  fileRow.style.display = "flex";
  fileRow.style.alignItems = "center";
  fileRow.style.gap = "8px";

  fileRow.appendChild(fileNameDiv);
  fileRow.appendChild(removeBtn);

  successText.style.display = "none";
  fileRow.style.display = "none";

  uploadBox.appendChild(successText);
  uploadBox.appendChild(fileRow);

  /* =========================
     FILE SELECT
  ========================== */
  fileInput.addEventListener("change", function () {
    if (!this.files || !this.files[0]) return;

    const file = this.files[0];

    // Hide original UI
    icon.style.display = "none";
    title.style.display = "none";
    desc.style.display  = "none";
    btn.style.display   = "none";
    note.style.display  = "none";

    // Show uploaded UI
    successText.style.display = "block";
    fileRow.style.display = "flex";
    fileNameDiv.textContent = file.name;

    uploadBox.classList.add("uploaded");
  });

  /* =========================
     REMOVE FILE
  ========================== */
  removeBtn.addEventListener("click", () => {
    fileInput.value = "";

    // Restore original UI
    icon.style.display = "";
    title.style.display = "";
    desc.style.display  = "";
    btn.style.display   = "";
    note.style.display  = "";

    // Hide uploaded UI
    successText.style.display = "none";
    fileRow.style.display = "none";
    fileNameDiv.textContent = "";

    uploadBox.classList.remove("uploaded");
  });

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
