
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
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
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Submit Claim | VHealthAssure</title>

<style>
:root {
    --primary: #0b2a4a;
    --primary-dark: #071d33;
    --accent: #2563eb;
    --success: #2e7d32;
    --warning: #ed6c02;
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
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    display: flex;
    align-items: center;
    justify-content: center;
}

.logo-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.brand h1 {
    font-size: 20px;
    font-weight: 600;
    letter-spacing: 0.3px;
}

/* Profile dropdown */
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
    transition: 0.2s;
}

.profile-area:hover .profile-avatar {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35);
}

.profile-name {
    font-size: 14px;
    opacity: 0.95;
}

.profile-dropdown {
    position: absolute;
    top: 52px;
    right: 0;
    width: 210px;
    background: white;
    color: var(--text);
    border-radius: 14px;
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.18);
    overflow: hidden;
    opacity: 0;
    pointer-events: none;
    transform: translateY(-10px) scale(0.95);
    transition: 0.25s;
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

/* Dashboard layout */
.layout {
    display: grid;
    grid-template-columns: 240px 1fr;
    min-height: calc(100vh - 64px);
}

.sidebar {
    background: #081a30;
    padding: 24px 16px;
}

.sidebar a {
    display: block;
    padding: 12px 14px;
    margin-bottom: 6px;
    color: #cbd5e1;
    text-decoration: none;
    border-radius: 8px;
    font-size: 14px;
    transition: 0.2s;
}

.sidebar a:hover,
.sidebar a.active {
    background: #1e293b;
    color: white;
}

/* Main content */
main {
    padding: 28px;
    min-width: 0;
}

.heading {
    margin-bottom: 24px;
}

.heading h1 {
    font-size: 27px;
    color: var(--primary);
    margin-bottom: 7px;
}

.heading p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.6;
}

/* Form cards */
.card {
    background: white;
    border-radius: 16px;
    padding: 22px;
    margin-bottom: 22px;
    box-shadow: 0 10px 26px rgba(0, 0, 0, 0.07);
}

.card h2 {
    font-size: 19px;
    color: var(--primary);
    margin-bottom: 20px;
}

.fields {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 18px;
}

.field {
    display: flex;
    flex-direction: column;
    gap: 7px;
    min-width: 0;
}

.field.full {
    grid-column: 1 / -1;
}

label {
    font-size: 13px;
    font-weight: 600;
    color: var(--text);
}

input,
select,
textarea {
    width: 100%;
    padding: 11px 12px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-size: 14px;
    color: var(--text);
    background: white;
    transition: border-color 0.2s, box-shadow 0.2s;
}

input:focus,
select:focus,
textarea:focus {
    outline: none;
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

input[type="file"] {
    padding: 9px;
    font-size: 12px;
    background: #f8fafc;
}

input[type="checkbox"] {
    width: 17px;
    height: 17px;
    flex-shrink: 0;
    accent-color: var(--accent);
}

textarea {
    min-height: 90px;
    resize: vertical;
}

.note {
    color: var(--muted);
    font-size: 12px;
    line-height: 1.6;
    margin-bottom: 16px;
}

/* Alerts */
.alert {
    padding: 15px 18px;
    margin-bottom: 20px;
    border-radius: 10px;
    font-size: 14px;
    line-height: 1.6;
}

.alert-error {
    color: #b91c1c;
    background: #fef2f2;
    border: 1px solid #fecaca;
}

/* Declaration */
.declaration {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    font-size: 13px;
    line-height: 1.7;
    font-weight: 400;
}

/* Buttons */
.actions {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    margin-top: 22px;
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
    transition: 0.2s;
}

.btn:hover {
    background: #1d4ed8;
    transform: translateY(-1px);
}

.btn.secondary {
    background: #e2e8f0;
    color: var(--primary);
}

.btn.secondary:hover {
    background: #cbd5e1;
}

footer {
    text-align: center;
    color: var(--muted);
    padding: 16px;
    font-size: 12px;
}

/* Responsive */
@media (max-width: 900px) {
    .layout {
        grid-template-columns: 190px 1fr;
    }

    main {
        padding: 22px;
    }

    header {
        padding: 0 22px;
    }
}

@media (max-width: 600px) {
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
        padding: 12px;
        display: flex;
        gap: 6px;
        overflow-x: auto;
    }

    .sidebar a {
        display: block;
        white-space: nowrap;
        margin-bottom: 0;
        padding: 10px 12px;
    }

    main {
        padding: 18px 14px;
    }

    .heading h1 {
        font-size: 23px;
    }

    .card {
        padding: 18px;
    }

    .fields {
        grid-template-columns: 1fr;
    }

    .field.full {
        grid-column: auto;
    }

    .actions .btn {
        text-align: center;
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
        <a href="Claims" class="active">Claims</a>
        <a href="CashlessHospitals">Cashless Hospitals</a>
        <a href="Payments">Payments</a>
        <a href="Kyc">KYC Details</a>
        <a href="Support">Support</a>
    </aside>

    <main>

        <div class="heading">
            <h1>Submit a Claim</h1>
            <p>Complete the form accurately and provide the supporting documents.</p>
        </div>

        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">
                Please complete all required fields and check the uploaded documents.
            </div>
        <% } else if ("2".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">
                The claim could not be submitted. Please verify your policy details and try again.
            </div>
        <% } %>

        <form action="SubmitClaim" method="post" enctype="multipart/form-data">

            <!-- 1. Patient Details -->
            <div class="card">
                <h2>1. Patient Details</h2>

                <div class="fields">
                    <div class="field">
                        <label for="patientName">Patient Name *</label>
                        <input id="patientName" name="patientName" maxlength="100" required>
                    </div>

                    <div class="field">
                        <label for="age">Age *</label>
                        <input id="age" type="number" name="age" min="0" max="130" required>
                    </div>

                    <div class="field">
                        <label for="dateofBirth">Date of Birth</label>
                        <input id="dateofBirth" type="date" name="dateofBirth">
                    </div>

                    <div class="field">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender">
                            <option value="">Select</option>
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>
                    </div>

                    <div class="field">
                        <label for="contactNumber">Contact Number *</label>
                        <input id="contactNumber" name="contactNumber" maxlength="200" required>
                    </div>

                    <div class="field">
                        <label for="emailID">Email *</label>
                        <input id="emailID" type="email" name="emailID" maxlength="200" required>
                    </div>

                    <div class="field full">
                        <label for="address">Address</label>
                        <textarea id="address" name="address" maxlength="200"></textarea>
                    </div>
                </div>
            </div>

            <!-- 2. Insurance and Policy Details -->
            <div class="card">
                <h2>2. Insurance and Policy Details</h2>

                <div class="fields">
                    <div class="field">
                        <label for="insuranceCompanyName">Insurance Company *</label>
                        <input id="insuranceCompanyName" name="insuranceCompanyName" maxlength="100" required>
                    </div>

                    <div class="field">
                        <label for="policyNumber">Policy Number *</label>
                        <input id="policyNumber" name="policyNumber" maxlength="50" required>
                    </div>

                    <div class="field">
                        <label for="healthCardNumber">Health Card Number</label>
                        <input id="healthCardNumber" name="healthCardNumber" maxlength="50">
                    </div>

                    <div class="field">
                        <label for="policyholderName">Policyholder Name *</label>
                        <input id="policyholderName" name="policyholderName" maxlength="100" required>
                    </div>
                </div>
            </div>

            <!-- 3. Hospital Details -->
            <div class="card">
                <h2>3. Hospital Details</h2>

                <div class="fields">
                    <div class="field">
                        <label for="hospitalName">Hospital Name *</label>
                        <input id="hospitalName" name="hospitalName" maxlength="100" required>
                    </div>

                    <div class="field">
                        <label for="registrationNumber">Hospital Registration Number</label>
                        <input id="registrationNumber" name="registrationNumber" maxlength="50">
                    </div>

                    <div class="field full">
                        <label for="hospitalAddress">Hospital Address *</label>
                        <textarea id="hospitalAddress" name="hospitalAddress" maxlength="250" required></textarea>
                    </div>

                    <div class="field">
                        <label for="hospitalContactNumber">Hospital Contact Number</label>
                        <input id="hospitalContactNumber" name="hospitalContactNumber" maxlength="100">
                    </div>

                    <div class="field">
                        <label for="hospitalEmail">Hospital Email</label>
                        <input id="hospitalEmail" type="email" name="hospitalEmail" maxlength="200">
                    </div>

                    <div class="field">
                        <label for="dateandTimeofAdmission">Admission Date and Time *</label>
                        <input id="dateandTimeofAdmission" type="datetime-local"
                               name="dateandTimeofAdmission" required>
                    </div>

                    <div class="field">
                        <label for="dateandTimeofDischarge">Discharge Date and Time</label>
                        <input id="dateandTimeofDischarge" type="datetime-local"
                               name="dateandTimeofDischarge">
                    </div>

                    <div class="field">
                        <label for="typeofAdmission">Type of Admission *</label>
                        <select id="typeofAdmission" name="typeofAdmission" required>
                            <option value="">Select</option>
                            <option>Emergency</option>
                            <option>Planned</option>
                            <option>Day Care</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- 4. Treatment Details -->
            <div class="card">
                <h2>4. Treatment Details</h2>

                <div class="fields">
                    <div class="field">
                        <label for="diagnosis">Diagnosis *</label>
                        <input id="diagnosis" name="diagnosis" maxlength="200" required>
                    </div>

                    <div class="field">
                        <label for="typeofTreatment">Type of Treatment *</label>
                        <input id="typeofTreatment" name="typeofTreatment" maxlength="200" required>
                    </div>

                    <div class="field">
                        <label for="surgeryName">Surgery Name</label>
                        <input id="surgeryName" name="surgeryName" maxlength="250">
                    </div>

                    <div class="field">
                        <label for="surgeryDate">Surgery Date</label>
                        <input id="surgeryDate" type="date" name="surgeryDate">
                    </div>

                    <div class="field">
                        <label for="treatingDoctorName">Treating Doctor Name</label>
                        <input id="treatingDoctorName" name="treatingDoctorName" maxlength="100">
                    </div>
                </div>
            </div>

            <!-- 5. Claim Amount -->
            <div class="card">
                <h2>5. Claim Amount</h2>

                <div class="fields">
                    <div class="field">
                        <label for="totalHospitalBillAmount">Total Hospital Bill (₹) *</label>
                        <input id="totalHospitalBillAmount" type="number"
                               name="totalHospitalBillAmount" min="0.01" step="0.01" required>
                    </div>

                    <div class="field">
                        <label for="amountClaimed">Amount Claimed (₹) *</label>
                        <input id="amountClaimed" type="number"
                               name="amountClaimed" min="0.01" step="0.01" required>
                    </div>
                </div>
            </div>

            <!-- 6. Bank Details -->
            <div class="card">
                <h2>6. Bank Details</h2>

                <div class="fields">
                    <div class="field">
                        <label for="accountHolderName">Account Holder Name *</label>
                        <input id="accountHolderName" name="accountHolderName" maxlength="100" required>
                    </div>

                    <div class="field">
                        <label for="bankName">Bank Name *</label>
                        <input id="bankName" name="bankName" maxlength="100" required>
                    </div>

                    <div class="field">
                        <label for="accountNumber">Account Number *</label>
                        <input id="accountNumber" name="accountNumber" maxlength="50" required>
                    </div>

                    <div class="field">
                        <label for="iFSCCode">IFSC Code *</label>
                        <input id="iFSCCode" name="iFSCCode" maxlength="30" required>
                    </div>

                    <div class="field">
                        <label for="branchName">Branch Name</label>
                        <input id="branchName" name="branchName" maxlength="100">
                    </div>
                </div>

                <p class="note" style="margin-top:16px;margin-bottom:0;">
                    Bank information is sensitive. Submit only through your authenticated insurance application.
                </p>
            </div>

            <!-- 7. Supporting Documents -->
            <div class="card">
                <h2>7. Supporting Documents</h2>

                <p class="note">
                    Upload PDF, JPG, or PNG files. Maximum 5 MB per file.
                    Required documents depend on the claim type.
                </p>

                <div class="fields">
                    <div class="field">
                        <label for="hospitalFinalBill">Hospital Final Bill</label>
                        <input id="hospitalFinalBill" type="file" name="hospitalFinalBill"
                               accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="detailedBill">Detailed Bill</label>
                        <input id="detailedBill" type="file" name="detailedBill"
                               accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="dischargeSummary">Discharge Summary</label>
                        <input id="dischargeSummary" type="file" name="dischargeSummary"
                               accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="medicalReports">Medical Reports</label>
                        <input id="medicalReports" type="file" name="medicalReports"
                               accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="pharmacyBills">Pharmacy Bills</label>
                        <input id="pharmacyBills" type="file" name="pharmacyBills"
                               accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="fIRAccidentReport">FIR / Accident Report</label>
                        <input id="fIRAccidentReport" type="file" name="fIRAccidentReport"
                               accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="iDProof">ID Proof</label>
                        <input id="iDProof" type="file" name="iDProof"
                               accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="insuranceCardTPACard">Insurance / TPA Card</label>
                        <input id="insuranceCardTPACard" type="file" name="insuranceCardTPACard"
                               accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="patientGuardianSignature">Patient / Guardian Signature</label>
                        <input id="patientGuardianSignature" type="file"
                               name="patientGuardianSignature" accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field">
                        <label for="hospitalSealandDoctorSignature">Hospital Seal / Doctor Signature</label>
                        <input id="hospitalSealandDoctorSignature" type="file"
                               name="hospitalSealandDoctorSignature" accept=".pdf,.jpg,.jpeg,.png">
                    </div>
                </div>
            </div>

            <!-- Declaration and Actions -->
            <div class="card">
                <label class="declaration" for="declarationcheckbox">
                    <input type="checkbox" id="declarationcheckbox"
                           name="declarationcheckbox" value="YES" required>
                    <span>
                        I declare that the information provided is accurate and
                        the supporting documents are genuine. *
                    </span>
                </label>

                <div class="actions">
                    <button class="btn" type="submit">Submit Claim</button>
                    <a class="btn secondary" href="Claims">Cancel</a>
                </div>
            </div>

        </form>

        <footer>
            © <%= java.time.Year.now().getValue() %> VHealthAssure Insurance Services
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
