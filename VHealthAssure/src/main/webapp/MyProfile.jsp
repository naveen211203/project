<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Profile | VHealthAssure</title>

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

/* RESET */
*{margin:0;padding:0;box-sizing:border-box;font-family:Poppins,Arial,sans-serif}
body{
  background:var(--bg);
  color:var(--text);
  height:100vh;
  overflow:hidden;
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
.brand{display:flex;align-items:center;gap:12px}
.logo-box{width:42px;height:42px;border-radius:12px;background:#e2e8f0}
.brand h1{font-size:20px;font-weight:600}
.profile-area{display:flex;align-items:center;gap:10px}
.profile-avatar{
  width:38px;height:38px;border-radius:50%;
  background:linear-gradient(135deg,#2563eb,#1e40af);
  display:flex;align-items:center;justify-content:center;font-weight:600
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
  position:sticky;
  top:64px;
  height:calc(100vh - 64px);
}
.sidebar a{
  display:block;
  padding:12px 14px;
  margin-bottom:6px;
  color:#cbd5e1;
  text-decoration:none;
  border-radius:8px;
  font-size:14px;
  cursor:pointer;
}
.sidebar a:hover,.sidebar a.active{
  background:#1e293b;
  color:#fff;
}

/* MAIN */
main{
  padding:28px;
  overflow-y:auto;
}

/* PROFILE WRAPPER */
.profile-wrapper{
  max-width:1200px;
  margin:auto;
  display:flex;
  flex-direction:column;
  gap:28px;
}

/* CARD */
.card{
  background:linear-gradient(180deg,#f8fafc 0%,#ffffff 40%);
  border-radius:18px;
  padding:26px 30px;
  box-shadow:0 10px 26px rgba(0,0,0,.08);
  position:relative;
  border-left:4px solid var(--primary);
}
.card h3{
  font-size:16px;
  color:var(--primary);
  margin-bottom:18px;
  position:relative;
  padding-bottom:6px;
}
.card h3::after{
  content:"";
  position:absolute;
  left:0;
  bottom:0;
  width:38px;
  height:3px;
  background:var(--primary);
  border-radius:6px;
}

/* EDIT BUTTON */
.edit-btn{
  position:absolute;
  top:22px;
  right:26px;
  font-size:13px;
  color:var(--accent);
  font-weight:500;
  cursor:pointer;
  z-index:10;
  pointer-events:auto;
}

/* USER OVERVIEW */
.user-overview{
  display:grid;
  grid-template-columns:120px 1fr 1fr;
  align-items:center;
  gap:28px;
  border-left:none;
  background:linear-gradient(135deg,#e8f0ff 0%,#ffffff 60%);
  box-shadow:0 14px 32px rgba(11,42,74,.18);
}

.big-avatar{
  width:96px;height:96px;border-radius:50%;
  background:linear-gradient(135deg,#2563eb,#1e40af);
  display:flex;align-items:center;justify-content:center;
  font-size:34px;font-weight:600;color:#fff;
  box-shadow:0 8px 22px rgba(11,42,74,.35);
}

.user-meta p{font-size:13px;color:var(--muted)}
.user-stats{
  display:grid;
  grid-template-columns:repeat(2,1fr);
  gap:14px;
  font-size:13px;
}
.stat{
  display:flex;
  justify-content:space-between;
  border-bottom:1px solid var(--border);
  padding-bottom:6px;
}

/* GRID */
.grid{
  display:grid;
  grid-template-columns:repeat(2,1fr);
  gap:20px;
}

/* VIEW MODE */
.value{
  padding:10px 12px;
  background:#f8fafc;
  border-radius:8px;
  border:1px solid var(--border);
  font-size:14px;
}

/* INPUT */
.field input{
  width:100%;
  padding:10px 12px;
  border-radius:8px;
  border:1px solid #c7d7f3;
  background:#f8fbff;
  font-size:14px;
  display:none;
}
/* FIELD SPACING IMPROVEMENT */
.field label{
  display:block;
  margin-bottom:8px;   /* space between label & input/value */
  font-weight:500;
}

.field .value,
.field input{
  margin-bottom:6px;   /* space below each field */
}


/* ACTIONS */
.actions{
  display:none;
  justify-content:flex-end;
  gap:12px;
  margin-top:18px;
}
.btn{
  padding:9px 18px;
  border-radius:8px;
  border:none;
  font-size:13px;
  cursor:pointer;
}
.btn-secondary{background:#e5e7eb}
.btn-primary{background:var(--accent);color:#fff}
.btn-primary:hover{background:#1e4fd8}
.btn-secondary:hover{background:#d1d5db}

/* EDIT MODE */
.card.editing .value{display:none}
.card.editing input{display:block}
.card.editing .actions{display:flex}

@media(max-width:900px){
  .user-overview{grid-template-columns:1fr;text-align:center}
  .grid{grid-template-columns:1fr}
}
</style>
</head>

<body>

<header>
  <div class="brand"><div class="logo-box"></div><h1>VHealthAssure</h1></div>
  <div class="profile-area"><div class="profile-avatar">U</div><span>User</span></div>
</header>

<div class="layout">

<aside class="sidebar">
  <a href="UserDashboardServlet">Overview</a>
  <a>My Policies</a>
  <a>Claims</a>
  <a>Cashless Hospitals</a>
  <a>Payments</a>
  <a class="active">Profile & KYC</a>
  <a>Support</a>
</aside>

<main>
<div class="profile-wrapper">

  <!-- USER OVERVIEW -->
  <div class="card user-overview">
    <div class="big-avatar">U</div>
    <div class="user-meta"><h2>User Name</h2><p>Policy Holder</p></div>
    <div class="user-stats">
      <div class="stat"><span>Account</span><strong>Active</strong></div>
      <div class="stat"><span>KYC</span><strong>Verified</strong></div>
      <div class="stat"><span>Role</span><strong>USER</strong></div>
      <div class="stat"><span>Member Since</span><strong>2024</strong></div>
    </div>
  </div>

  <!-- PERSONAL -->
  <div class="card">
    <span class="edit-btn" onclick="startEdit(this)">Edit</span>
    <h3>Personal Information</h3>
    <div class="grid">
      <div class="field"><label>Full Name</label><div class="value">John Doe</div><input></div>
      <div class="field"><label>Date of Birth</label><div class="value">1999-04-12</div><input type="date"></div>
      <div class="field"><label>Gender</label><div class="value">Male</div><input></div>
      <div class="field"><label>City</label><div class="value">Hyderabad</div><input></div>
    </div>
    <div class="actions">
      <button class="btn btn-secondary" onclick="cancelEdit(this)">Cancel</button>
      <button class="btn btn-primary">Save</button>
    </div>
  </div>

  <!-- CONTACT -->
  <div class="card">
    <span class="edit-btn" onclick="startEdit(this)">Edit</span>
    <h3>Contact Details</h3>
    <div class="grid">
      <div class="field"><label>Email</label><div class="value">user@mail.com</div><input></div>
      <div class="field"><label>Mobile</label><div class="value">9876543210</div><input></div>
      <div class="field"><label>Address</label><div class="value">Hyderabad</div><input></div>
      <div class="field"><label>Postal Code</label><div class="value">500001</div><input></div>
    </div>
    <div class="actions">
      <button class="btn btn-secondary" onclick="cancelEdit(this)">Cancel</button>
      <button class="btn btn-primary">Save</button>
    </div>
  </div>

  <!-- NOMINEE -->
  <div class="card">
    <span class="edit-btn" onclick="startEdit(this)">Edit</span>
    <h3>Nominee Details</h3>
    <div class="grid">
      <div class="field"><label>Nominee Name</label><div class="value">Father</div><input></div>
      <div class="field"><label>Relationship</label><div class="value">Parent</div><input></div>
      <div class="field"><label>Nominee DOB</label><div class="value">1970-01-01</div><input type="date"></div>
      <div class="field"><label>Share (%)</label><div class="value">100</div><input></div>
    </div>
    <div class="actions">
      <button class="btn btn-secondary" onclick="cancelEdit(this)">Cancel</button>
      <button class="btn btn-primary">Save</button>
    </div>
  </div>

  <!-- EMPLOYMENT -->
  <div class="card">
    <span class="edit-btn" onclick="startEdit(this)">Edit</span>
    <h3>Employment & Income</h3>
    <div class="grid">
      <div class="field"><label>Status</label><div class="value">Salaried</div><input></div>
      <div class="field"><label>Occupation</label><div class="value">Engineer</div><input></div>
      <div class="field"><label>Annual Income</label><div class="value">600000</div><input></div>
      <div class="field"><label>Company</label><div class="value">ABC Pvt Ltd</div><input></div>
    </div>
    <div class="actions">
      <button class="btn btn-secondary" onclick="cancelEdit(this)">Cancel</button>
      <button class="btn btn-primary">Save</button>
    </div>
  </div>

</div>
</main>
</div>

<script>
function startEdit(el){
  const card = el.closest('.card');
  if(card.classList.contains('editing')) return;

  card.classList.add('editing');

  card.querySelectorAll('.field').forEach(f=>{
    const val = f.querySelector('.value').innerText.trim();
    f.querySelector('input').value = val;
  });
}

function cancelEdit(el){
  const card = el.closest('.card');
  card.classList.remove('editing');
}
</script>

</body>
</html>
