<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
com.VHealthAssure.Entity.RegistrationEntity user =
    (com.VHealthAssure.Entity.RegistrationEntity) request.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.html");
    return;
}
%>

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

.field select{
  width:100%;
  padding:10px 12px;
  border-radius:8px;
  border:1px solid #c7d7f3;
  background:#f8fbff;
  font-size:14px;
  appearance:none;          /* removes native style */
  -webkit-appearance:none;
  -moz-appearance:none;
}


.field select{
  display:none;
}
.card.editing select{
  display:block;
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
  <div class="brand">
    <div class="logo-box">
      <img src="images/logo.jpg" alt="VHealthAssure Logo">
    </div>
    <h1>VHealthAssure</h1>
  </div>

  <div class="profile-area" id="profileArea">
    <div class="profile-avatar"><%= user.getFullName().charAt(0) %></div>
    <div class="profile-name"><%= user.getFullName() %></div>

    <div class="profile-dropdown">
      <a href="MyProfile">My Profile</a>
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
  <a class="active">Profile & KYC</a>
  <a>Support</a>
</aside>

<main>
<div class="profile-wrapper">

  <!-- USER OVERVIEW -->
  <div class="card user-overview">
    <div class="big-avatar"><%= user.getFullName().charAt(0) %></div>
    <div class="user-meta"><h2><%= user.getFullName() %></h2><p>Policy Holder</p></div>
    <div class="user-stats">
      <div class="stat"><span>Account</span><strong><%= user.getStatus() %></strong></div>
      <div class="stat"><span>KYC</span><strong><%= user.getKycStatus() %></strong></div>
      <div class="stat"><span>Role</span><strong>USER</strong></div>
      <div class="stat"><span>Member Since</span>
      <strong>
		<%= user.getCreatedAt() != null 
      		? user.getCreatedAt().substring(0, 4) 
      		: "-" %>
	  </strong>
	</div>
    </div>
  </div>

  <!-- PERSONAL -->
  <form action="MyProfileServlet" method="post" onsubmit="return validateProfileForm(this)">
  <input type="hidden" name="section" value="PERSONAL">
  <div class="card">
    <span class="edit-btn" onclick="startEdit(this)">Edit</span>
    <h3>Personal Information</h3>
    <div class="grid">
      <div class="field"><label>Full Name</label><div class="value"><%= user.getFullName() %></div><input name="FullName"></div>
      <div class="field"><label>Date of Birth</label><div class="value"><%= user.getDateOfBirth() %></div><input type="date" name="DateOfBirth" id="DateOfBirth"></div>
      <div class="field">
  		<label>Gender</label>
  		<div class="value"><%= user.getGender() %></div>
  		<select name="Gender">
    		<option value="">Select</option>
    		<option value="MALE">Male</option>
   		    <option value="FEMALE">Female</option>
   		    <option value="OTHER">Other</option>
  		</select>
	  </div>
      <div class="field"><label>City</label><div class="value"><%= user.getCity() %></div><input name="City"></div>
    </div>
    <div class="actions">
      <button type="button" class="btn btn-secondary" onclick="cancelEdit(this)">Cancel</button>
      <button class="btn btn-primary" onclick="return validateProfileForm(this.form, this)">Save</button>
    </div>
  </div>
  </form>

  <!-- CONTACT -->
  <form action="MyProfileServlet" method="post" onsubmit="return validateProfileForm(this)">
  <input type="hidden" name="section" value="CONTACT">
  <div class="card">
    <span class="edit-btn" onclick="startEdit(this)">Edit</span>
    <h3>Contact Details</h3>
    <div class="grid">
      <div class="field"><label>Email</label><div class="value"><%= user.getEmail() %></div><input name="Email"></div>
      <div class="field"><label>Mobile</label><div class="value"><%= user.getMobile() %></div><input name="Mobile"></div>
      <div class="field"><label>Address</label><div class="value">Hyderabad</div><input></div>
      <div class="field"><label>Postal Code</label><div class="value"><%= user.getPostalCode() %></div><input name="PostalCode"></div>
    </div>
    <div class="actions">
      <button type="button" class="btn btn-secondary" onclick="cancelEdit(this)">Cancel</button>
      <button class="btn btn-primary" onclick="return validateProfileForm(this.form, this)">Save</button>
    </div>
  </div>
  </form>

  <!-- NOMINEE -->
  <form action="MyProfileServlet" method="post" onsubmit="return validateProfileForm(this)">
  <input type="hidden" name="section" value="NOMINEE">
  <div class="card">
    <span class="edit-btn" onclick="startEdit(this)">Edit</span>
    <h3>Nominee Details</h3>
    <div class="grid">
      <div class="field"><label>Nominee Name</label><div class="value"><%= user.getNomineeName() %></div><input name="NomineeName" id="NomineeName"></div>
      <div class="field"><label>Relationship</label><div class="value"><%= user.getNomineeRelation() %></div><input name="NomineeRelation" id="NomineeRelation"></div>
      <div class="field"><label>Nominee DOB</label><div class="value"><%= user.getNomineeDob() %></div><input type="date" name="NomineeDob" id="NomineeDob"></div>
      <div class="field"><label>Share (%)</label><div class="value"><%= user.getNomineeShare() %></div><input name="NomineeShare" id="NomineeShare"></div>
    </div>
    <div class="actions">
      <button type="button" class="btn btn-secondary" onclick="cancelEdit(this)">Cancel</button>
      <button class="btn btn-primary" onclick="return validateProfileForm(this.form, this)">Save</button>
    </div>
  </div>
  </form>

  <!-- EMPLOYMENT -->
  <form action="MyProfileServlet" method="post" onsubmit="return validateProfileForm(this)">
  <input type="hidden" name="section" value="EMPLOYMENT">
  <div class="card">
    <span class="edit-btn" onclick="startEdit(this)">Edit</span>
    <h3>Employment & Income</h3>
    <div class="grid">
      <div class="field"><label>Status</label><div class="value"><%= user.getEmploymentStatus() %></div>
      <select name="EmploymentStatus">
  		<option value="">Select</option>
  		<option value="SALARIED">Salaried</option>
  		<option value="SELF EMPLOYED">Self Employed</option>
  		<option value="UNEMPLOYED">Unemployed</option>
  		<option value="RETIRED">Retired</option>
	  </select>
      </div>
      <div class="field"><label>Occupation</label><div class="value"><%= user.getOccupation() %></div><input type="text" name="Occupation"></div>
      <div class="field"><label>Annual Income</label><div class="value"><%= user.getAnnualIncome() %></div><input name="AnnualIncome"></div>
      <div class="field"><label>Company</label><div class="value"><%= user.getCompany() %></div><input type="text" name="Company"></div>
    </div>
    <div class="actions">
      <button type="button" class="btn btn-secondary" onclick="cancelEdit(this)">Cancel</button>
      <button class="btn btn-primary" onclick="return validateProfileForm(this.form, this)">Save</button>
    </div>
  </div>
  </form>

</div>
</main>
</div>
<div id="toastWrap" style="position:fixed;top:20px;right:20px;z-index:9999"></div>

<script>
const profile = document.getElementById("profileArea");
profile.addEventListener("click", () => profile.classList.toggle("active"));
document.addEventListener("click", e => {
  if(!profile.contains(e.target)) profile.classList.remove("active");
});

function startEdit(el){
  const card = el.closest('.card');
  if(card.classList.contains('editing')) return;

  card.classList.add('editing');

  card.querySelectorAll('.field').forEach(f=>{
    const valueDiv = f.querySelector('.value');
    const valueText = valueDiv ? valueDiv.innerText.trim() : "";

    const input = f.querySelector('input');
    if (input) {
      input.value = valueText;
      input.dataset.original = valueText;
    }

    const select = f.querySelector('select');
    if (select) {
      select.dataset.original = valueText;
      const normalized = valueText.toLowerCase();
      Array.from(select.options).forEach(opt => {
        opt.selected = opt.value.toLowerCase() === normalized;
      });
    }
  });
}

function cancelEdit(el){
  const card = el.closest('.card');

  card.querySelectorAll('.field input').forEach(input=>{
    input.value = input.dataset.original || "";
  });

  card.querySelectorAll('.field select').forEach(select=>{
    const original = select.dataset.original || "";
    Array.from(select.options).forEach(opt => {
      opt.selected = opt.value === original;
    });
  });

  card.classList.remove('editing');
}

/* ---------- Toast ---------- */
function showToast(message, type="error") {
  const wrap = document.getElementById("toastWrap");
  if(!wrap) return;

  const toast = document.createElement("div");
  toast.style.cssText = `
    min-width:260px;
    padding:12px 14px;
    margin-bottom:10px;
    border-radius:10px;
    color:#fff;
    font-weight:600;
    background:${type==="success"
      ? "linear-gradient(90deg,#28c76f,#12b886)"
      : "linear-gradient(90deg,#ff4d4f,#ff6b6b)"};
    box-shadow:0 8px 30px rgba(0,0,0,.15);
  `;
  toast.textContent = message;
  wrap.appendChild(toast);
  setTimeout(()=>toast.remove(), 4000);
}

/* ---------- Name validation ---------- */
document.querySelectorAll('input[name="FullName"]').forEach(el => {
  el.addEventListener("input", function () {
    this.value = this.value.replace(/[^A-Za-z ]/g, "");
  });
});

/* ---------- Date length fix ---------- */
document.querySelectorAll('input[type="date"]').forEach(el=>{
  el.addEventListener("input",()=>{
    if(el.value.length > 10){
      el.value = el.value.substring(0,10);
    }
  });
});

/* ---------- Age helper ---------- */
function isValidAge(dob) {
  const birth = new Date(dob);
  if (isNaN(birth)) return false;

  const today = new Date();
  let age = today.getFullYear() - birth.getFullYear();
  const m = today.getMonth() - birth.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) age--;

  return age >= 18 && age <= 100;
}

/* ---------- Main form validation ---------- */
function validateProfileForm(form, btn) {

  const card = btn.closest('.card');

  // PERSONAL SECTION → validate user DOB
  const userDob = card.querySelector('input[name="DateOfBirth"]');
  if (userDob) {
    if (!validateUserDob(userDob)) return false;
  }

  // NOMINEE SECTION → validate nominee DOB ONLY
  const nomineeDob = card.querySelector('input[name="NomineeDob"]');
  if (nomineeDob) {
    if (!validateNomineeSection(card)) return false;
  }

  // CONTACT validations
  const mobile = card.querySelector('input[name="Mobile"]');
  if (mobile) {
    const digits = mobile.value.replace(/\D/g, '');
    if (digits.length !== 10) {
      showToast("Mobile number must be exactly 10 digits", "error");
      mobile.focus();
      return false;
    }
  }

  const postal = card.querySelector('input[name="PostalCode"]');
  if (postal) {
    const digits = postal.value.replace(/\D/g, '');
    if (digits.length !== 6) {
      showToast("Postal code must be exactly 6 digits", "error");
      postal.focus();
      return false;
    }
  }

  return true;
}



/* ---------- City / State / Country ---------- */
["City","State","Country"].forEach(name => {
  document.querySelectorAll(`input[name="${name}"]`).forEach(el => {
    el.addEventListener("input", function () {
      this.value = this.value.replace(/[^A-Za-z ]/g, "");
    });
  });
});

/* ---------- Nominee text ---------- */
["NomineeName","NomineeRelation"].forEach(name => {
  document.querySelectorAll(`input[name="${name}"]`).forEach(el => {
    el.addEventListener("input", function () {
      this.value = this.value.replace(/[^A-Za-z ]/g, "");
    });
  });
});

/* ---------- DOB year trim ---------- */
(function () {
  const dateFields = document.querySelectorAll('input[type="date"]');
  dateFields.forEach(field => {
    field.addEventListener("input", function () {
      let v = this.value;
      if (/^\d{5,}-\d{2}-\d{2}$/.test(v)) {
        let parts = v.split("-");
        parts[0] = parts[0].slice(0, 4);
        this.value = parts.join("-");
      }
    });
  });
})();

/* ---------- Age calculation ---------- */
function calculateAgeYears(birthDate, referenceDate) {
  if (!(birthDate instanceof Date) || isNaN(birthDate)) return NaN;
  const ref = referenceDate || new Date();
  let age = ref.getFullYear() - birthDate.getFullYear();
  const m = ref.getMonth() - birthDate.getMonth();
  if (m < 0 || (m === 0 && ref.getDate() < birthDate.getDate())) age--;
  return age;
}

/* ---------- DOB + Nominee DOB validation ---------- */
function validateAgesOnSubmit() {

  const dobEl = document.getElementById('DateOfBirth');
  const nomEl = document.getElementById('NomineeDob');
  const nameEl = document.getElementById('NomineeName');
  const relEl = document.getElementById('NomineeRelation');
  const shareEl = document.getElementById('NomineeShare');

  const now = new Date();
  const MIN_AGE = 18;
  const MAX_AGE = 100;

  function parseISODate(val) {
    if (!val) return null;
    const d = new Date(val);
    return isNaN(d) ? null : d;
  }

  if (!dobEl || !dobEl.value) {
    showToast('Please enter Date of Birth.', 'error');
    dobEl?.focus();
    return false;
  }

  const dobDate = parseISODate(dobEl.value);
  const age = calculateAgeYears(dobDate, now);
  if (!dobDate || age < MIN_AGE || age > MAX_AGE) {
    showToast('User must be between 18 and 100 years old.', 'error');
    dobEl.focus();
    return false;
  }

  const nameVal = (nameEl?.value || '').trim();
  const relVal  = (relEl?.value || '').trim();
  const dobVal  = (nomEl?.value || '').trim();

  if ((nameVal || relVal) && !dobVal) {
    showToast('Please enter Nominee DOB.', 'error');
    nomEl?.focus();
    return false;
  }

  if (dobVal) {
    const nomDate = parseISODate(dobVal);
    const nomAge = calculateAgeYears(nomDate, now);
    if (!nomDate || nomAge < MIN_AGE || nomAge > MAX_AGE) {
      showToast('Nominee must be between 18 and 100 years old.', 'error');
      nomEl.focus();
      return false;
    }
  }

  if (shareEl) {
    const val = parseFloat(shareEl.value || '0');
    if (val < 0 || val > 100) {
      showToast('Nominee share must be between 0 and 100.', 'error');
      shareEl.focus();
      return false;
    }
  }

  return true;
}

function validateUserDob(dobEl) {
	  const dob = new Date(dobEl.value);
	  if (!dobEl.value || isNaN(dob)) {
	    showToast("Please enter Date of Birth.", "error");
	    dobEl.focus();
	    return false;
	  }

	  const age = calculateAgeYears(dob);
	  if (age < 18 || age > 100) {
	    showToast("User must be between 18 and 100 years old.", "error");
	    dobEl.focus();
	    return false;
	  }
	  return true;
	}

	function validateNomineeSection(card) {
	  const nameEl = card.querySelector('#NomineeName');
	  const relEl  = card.querySelector('#NomineeRelation');
	  const dobEl  = card.querySelector('#NomineeDob');
	  const shareEl = card.querySelector('#NomineeShare');

	  const name = (nameEl?.value || '').trim();
	  const rel  = (relEl?.value || '').trim();
	  const dobV = (dobEl?.value || '').trim();

	  // Nominee partially filled
	  if ((name || rel) && !dobV) {
	    showToast("Please enter Nominee DOB.", "error");
	    dobEl.focus();
	    return false;
	  }

	  if (dobV) {
	    const dob = new Date(dobV);
	    if (isNaN(dob)) {
	      showToast("Invalid Nominee Date of Birth.", "error");
	      dobEl.focus();
	      return false;
	    }
	    const age = calculateAgeYears(dob);
	    if (age < 18 || age > 100) {
	      showToast("Nominee must be between 18 and 100 years old.", "error");
	      dobEl.focus();
	      return false;
	    }
	  }

	  if (shareEl) {
	    const val = parseFloat(shareEl.value || '0');
	    if (val < 0 || val > 100) {
	      showToast("Nominee share must be between 0 and 100.", "error");
	      shareEl.focus();
	      return false;
	    }
	  }

	  return true;
	}
</script>
</body>
</html>
