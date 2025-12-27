<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <div class="logo-box"></div>
    <h1>VHealthAssure</h1>
  </div>
  <div class="profile-area">
    <div class="profile-avatar">U</div>
    <span>User</span>
  </div>
</header>

<div class="layout">

<aside class="sidebar">
  <a href="UserDashboardServlet">Overview</a>
  <a>My Policies</a>
  <a>Claims</a>
  <a>Payments</a>
  <a class="active">KYC</a>
  <a>Profile</a>
  <a>Support</a>
</aside>

<main>

<div class="kyc-container">

  <div class="kyc-title">Identity Verification</div>
  <div class="kyc-sub">Verification required to activate full services</div>

  <div class="status-strip">
    <span>Your account is not verified</span>
    <strong>NOT VERIFIED</strong>
  </div>

  <div class="info">
    <div class="info-row">
      <span class="label">Government ID</span>
      <span class="value">Aadhaar</span>
    </div>
    <div class="info-row">
      <span class="label">ID Number</span>
      <span class="value">XXXX-XXXX-1234</span>
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

  <div class="upload-box">
  	<div class="upload-icon">📄</div>
  	<div class="upload-title">Upload your Government ID</div>
  	<div class="upload-desc">Drag & drop your document here or click to browse</div>
  	<label class="upload-btn">
  	Choose File
    	<input type="file" accept=".pdf,.jpg,.jpeg,.png" id="kycFile">
 	 </label>
 	<div class="upload-note">PDF, JPG or PNG • Max size 5 MB</div>
  </div>


  <div class="declaration">
    <input type="checkbox" id="declare">
    <label for="declare">
      I hereby declare that the document uploaded is genuine and belongs to me.
      I understand that providing false information may result in rejection of my account.
    </label>
  </div>

  <div class="action">
    <button class="btn">Submit for Verification</button>
  </div>

</div>

</main>
</div>

<script>
const fileInput = document.getElementById("kycFile");
const uploadBox = document.querySelector(".upload-box");

fileInput.addEventListener("change", function () {
  if (!this.files || !this.files[0]) return;

  const file = this.files[0];
  const fileName = file.name;

  // Show uploaded state with remove option
  uploadBox.innerHTML = `
    <div class="upload-success">
      ✅ Document uploaded successfully
    </div>
    <div class="upload-file">
      ${fileName}
    </div>
    <button class="remove-file" id="removeFile">Remove file</button>
  `;

  uploadBox.classList.add("uploaded");

  // Remove file logic
  document.getElementById("removeFile").addEventListener("click", () => {
    fileInput.value = "";
    uploadBox.classList.remove("uploaded");

    // Restore original upload UI
    uploadBox.innerHTML = `
      <div class="upload-icon">📄</div>
      <div class="upload-title">Upload your Government ID</div>
      <div class="upload-desc">Drag & drop your document here or click to browse</div>
      <label class="upload-btn">
        Choose File
        <input type="file" accept=".pdf,.jpg,.jpeg,.png" id="kycFile">
      </label>
      <div class="upload-note">PDF, JPG or PNG • Max size 5 MB</div>
    `;

    // Re-bind input after DOM reset
    document.getElementById("kycFile").addEventListener("change", arguments.callee);
  });
});
</script>



</body>
</html>
