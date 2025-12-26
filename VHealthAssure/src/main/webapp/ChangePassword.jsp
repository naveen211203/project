<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>

<%
String userName =
(String) session.getAttribute("userName");

if (userName == null) {
   userName = "User";
}

%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Change Password | VHealthAssure</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
}

*{margin:0;padding:0;box-sizing:border-box;font-family:Poppins,Arial,sans-serif}
body{background:var(--bg);color:var(--text);height:100vh;overflow:hidden}

/* HEADER */
header{
  height:64px;
  background:linear-gradient(135deg,var(--primary-dark),var(--primary));
  color:#fff;
  display:flex;align-items:center;justify-content:space-between;
  padding:0 32px;
}
.brand{display:flex;align-items:center;gap:12px}
.logo-box{width:42px;height:42px;border-radius:12px;background:#e2e8f0;overflow:hidden;}
.logo-box img{
  width:100%;
  height:100%;
  object-fit:cover;  /* 🔥 FILL COMPLETELY */
}
.brand h1{font-size:20px;font-weight:600}

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
  width:38px;height:38px;border-radius:50%;
  background:linear-gradient(135deg,#2563eb,#1e40af);
  display:flex;align-items:center;justify-content:center;
  font-weight:600;font-size:15px;
}
.profile-name{font-size:14px;opacity:.95}

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
.profile-dropdown a:hover{background:#f1f5f9}
.profile-dropdown .logout{
  color:#c62828;
  font-weight:600;
  border-top:1px solid #e5e7eb;
}

/* LAYOUT */
.layout{display:grid;grid-template-columns:240px 1fr;height:calc(100vh - 64px)}
.sidebar{
  background:#081a30;padding:24px 16px;
  position:sticky;top:64px;height:calc(100vh - 64px)
}
.sidebar a{
  display:block;padding:12px 14px;margin-bottom:6px;
  color:#cbd5e1;text-decoration:none;border-radius:8px;font-size:14px
}
.sidebar a:hover,.sidebar a.active{background:#1e293b;color:#fff}

main{padding:28px;overflow-y:auto}
.wrapper{max-width:680px;margin:60px auto}

/* CARD */
.card{
  background:linear-gradient(180deg,#f8fafc 0%,#ffffff 40%);
  border-radius:18px;padding:38px 44px;
  box-shadow:0 10px 26px rgba(0,0,0,.08);
  border-left:4px solid var(--primary)
}

.card h2{font-size:20px;color:var(--primary);margin-bottom:8px}
.card p{font-size:14px;color:var(--muted);margin-bottom:30px}

/* FIELD */
.field{
  display:flex;
  align-items:center;
  gap:16px;
  margin-bottom:22px;
  position:relative
}
.field label{min-width:180px;font-size:14px;font-weight:500}
.field input{
  flex:1;
  padding:12px 70px 12px 14px;
  border-radius:10px;
  border:1px solid #c7d7f3;
  background:#f8fbff;
  font-size:14px
}
.toggle-text{
  position:absolute;
  right:16px;
  font-size:13px;
  color:var(--accent);
  cursor:pointer
}

/* PASSWORD STRENGTH */
.password-strength-container{margin-left:196px;margin-top:16px}
.strength-meter{
  width:100%;height:8px;background:#e0e0e0;
  border-radius:4px;overflow:hidden
}
.strength-meter-fill{height:100%;width:0%;transition:all .4s}
.strength-text{margin-top:8px;font-size:13px;font-weight:500}

.strength-requirements{margin-top:14px}
.requirement{
  display:flex;align-items:center;gap:8px;
  font-size:13px;color:#777;margin-bottom:6px
}
.requirement.valid{color:#4caf50}
.requirement i{width:16px;text-align:center}

/* STRENGTH LEVELS */
.strength-very-weak .strength-meter-fill{width:20%;background:#dc2626}
.strength-weak .strength-meter-fill{width:40%;background:#f97316}
.strength-medium .strength-meter-fill{width:60%;background:#eab308}
.strength-strong .strength-meter-fill{width:80%;background:#22c55e}
.strength-very-strong .strength-meter-fill{width:100%;background:#16a34a}

/* ACTIONS */
.actions{display:flex;justify-content:flex-end;gap:16px}
.btn{padding:11px 26px;border-radius:10px;border:none;font-size:14px;cursor:pointer}
.btn-primary{background:#ffb74d;color:black}
.btn-primary:disabled{background:#94a3b8;cursor:not-allowed}
.btn-secondary{background:#e5e7eb}
/* TOAST */
.toast{
  position:fixed;
  top:80px;
  right:30px;
  min-width:280px;
  padding:14px 18px;
  border-radius:10px;
  color:#fff;
  font-size:14px;
  box-shadow:0 10px 30px rgba(0,0,0,.25);
  opacity:0;
  pointer-events:none;
  transform:translateY(-10px);
  transition:all .4s ease;
  z-index:9999;
}

.toast.show{
  opacity:1;
  transform:translateY(0);
}

.toast.success{ background:#2e7d32; }
.toast.error{ background:#c62828; }

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
    <div class="profile-avatar"><%= userName.charAt(0) %></div>
    <div class="profile-name"><%= userName %></div>

    <div class="profile-dropdown">
      <a href="MyProfile.jsp">My Profile</a>
      <a href="ChangePassword.jsp">Change Password</a>
      <a href="logout" class="logout">Logout</a>
    </div>
  </div>
</header>

<div class="layout">

<aside class="sidebar">
  <a href="UserDashboardServlet">Overview</a>
  <a>My Policies</a>
  <a>Claims</a>
  <a>Cashless Hospitals</a>
  <a>Payments</a>
  <a>Profile & KYC</a>
  <a class="active">Change Password</a>
</aside>

<main>
<div class="wrapper">
<div class="card">

<h2>Change Password</h2>
<p>For security reasons, please update your password regularly.</p>

<form method="post" action="change-password">

<div class="field">
  <label>Current Password</label>
  <input type="password" id="currentPwd" name="currentPassword">
  <span class="toggle-text" onclick="togglePwd('currentPwd',this)">Show</span>
</div>

<div class="field">
  <label>New Password</label>
  <input type="password" id="newPwd" name="newPassword" oninput="checkStrength()">
  <span class="toggle-text" onclick="togglePwd('newPwd',this)">Show</span>
</div>

<div class="password-strength-container" id="strengthBox">
  <div class="strength-meter"><div class="strength-meter-fill"></div></div>
  <div class="strength-text" id="strengthText"></div>

  <div class="strength-requirements">
    <div class="requirement" id="len"><i class="fa fa-times-circle"></i>At least 8 characters</div>
    <div class="requirement" id="up"><i class="fa fa-times-circle"></i>1 uppercase letter</div>
    <div class="requirement" id="low"><i class="fa fa-times-circle"></i>1 lowercase letter</div>
    <div class="requirement" id="num"><i class="fa fa-times-circle"></i>1 number</div>
    <div class="requirement" id="spec"><i class="fa fa-times-circle"></i>1 special character</div>
  </div>
</div>

<div class="field">
  <label>Confirm New Password</label>
  <input type="password" id="confirmPwd" name="confirmPassword" oninput="checkStrength()">
  <span class="toggle-text" onclick="togglePwd('confirmPwd',this)">Show</span>
</div>

<div class="actions">
  <button type="reset" class="btn btn-secondary">Cancel</button>
  <button type="submit" class="btn btn-primary" id="updateBtn" disabled>
    Update Password
  </button>
</div>

</form>

</div>
</div>
</main>
</div>
<% 
String successMsg = (String) request.getAttribute("success");
String errorMsg   = (String) request.getAttribute("error");
%>

<div id="toast" class="toast"></div>


<script>
function togglePwd(id,el){
  const i=document.getElementById(id);
  i.type=i.type==="password"?"text":"password";
  el.textContent=i.type==="password"?"Show":"Hide";
}

function checkStrength(){
  const p=document.getElementById("newPwd").value;
  const c=document.getElementById("confirmPwd").value;
  const container=document.getElementById("strengthBox");
  const text=document.getElementById("strengthText");
  const btn=document.getElementById("updateBtn");

  container.classList.remove(
    "strength-very-weak","strength-weak",
    "strength-medium","strength-strong","strength-very-strong"
  );

  const rules={
    len:p.length>=8,
    up:/[A-Z]/.test(p),
    low:/[a-z]/.test(p),
    num:/[0-9]/.test(p),
    spec:/[^A-Za-z0-9]/.test(p)
  };

  let score=0;
  for(let k in rules){
    document.getElementById(k).classList.toggle("valid",rules[k]);
    document.querySelector(`#${k} i`).className =
      rules[k]?"fa fa-check-circle":"fa fa-times-circle";
    if(rules[k]) score++;
  }

  if(p.length===0){
    text.textContent="";
    btn.disabled=true;
    return;
  }

  if(score<=1){container.classList.add("strength-very-weak");text.textContent="Very Weak";}
  else if(score===2){container.classList.add("strength-weak");text.textContent="Weak";}
  else if(score===3){container.classList.add("strength-medium");text.textContent="Medium";}
  else if(score===4){container.classList.add("strength-strong");text.textContent="Strong";}
  else{container.classList.add("strength-very-strong");text.textContent="Very Strong";}

  btn.disabled=!(score>=4 && p===c);
}

const profile=document.getElementById("profileArea");
profile.addEventListener("click",()=>profile.classList.toggle("active"));
document.addEventListener("click",e=>{
  if(!profile.contains(e.target)) profile.classList.remove("active");
});
<% if (successMsg != null) { %>
showToast("<%= successMsg %>", "success");
<% } %>

<% if (errorMsg != null) { %>
showToast("<%= errorMsg %>", "error");
<% } %>

function showToast(message, type){
  const toast = document.getElementById("toast");
  toast.textContent = message;
  toast.className = "toast " + type + " show";

  setTimeout(() => {
    toast.classList.remove("show");
  }, 3000);
}

</script>

</body>
</html>
