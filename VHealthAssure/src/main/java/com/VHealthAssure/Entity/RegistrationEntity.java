package com.VHealthAssure.Entity;

public class RegistrationEntity {

    private String UserId;
    private String FullName;
    private String Email;
    private String Mobile;
    private String Password;

    // KYC / Identity
    private String GovIdType;
    private String GovIdNumber;
    private String DateOfBirth;
    private String Gender;

    // Address
    private String AddressLine1;
    private String AddressLine2;
    private String City;
    private String State;
    private String PostalCode;
    private String Country;

    // Nominee
    private String NomineeName;
    private String NomineeRelation;
    private String NomineeDob;
    private double NomineeShare;

    // Employment / Financial
    private String EmploymentStatus;
    private double AnnualIncome;

    // Security & System
    private boolean EmailVerified;
    private boolean MobileVerified;
    private String KycStatus;
    private String Role;
    private String Status;

    private String CreatedAt;
    private String UpdatedAt;
	public String getUserId() {
		return UserId;
	}
	public void setUserId(String userId) {
		UserId = userId;
	}
	public String getFullName() {
		return FullName;
	}
	public void setFullName(String fullName) {
		FullName = fullName;
	}
	public String getEmail() {
		return Email;
	}
	public void setEmail(String email) {
		Email = email;
	}
	public String getMobile() {
		return Mobile;
	}
	public void setMobile(String mobile) {
		Mobile = mobile;
	}
	public String getPassword() {
		return Password;
	}
	public void setPassword(String pwd) {
		Password = pwd;
	}
	public String getGovIdType() {
		return GovIdType;
	}
	public void setGovIdType(String govIdType) {
		GovIdType = govIdType;
	}
	public String getGovIdNumber() {
		return GovIdNumber;
	}
	public void setGovIdNumber(String govIdNumber) {
		GovIdNumber = govIdNumber;
	}
	public String getDateOfBirth() {
		return DateOfBirth;
	}
	public void setDateOfBirth(String dateOfBirth) {
		DateOfBirth = dateOfBirth;
	}
	public String getGender() {
		return Gender;
	}
	public void setGender(String gender) {
		Gender = gender;
	}
	public String getAddressLine1() {
		return AddressLine1;
	}
	public void setAddressLine1(String addressLine1) {
		AddressLine1 = addressLine1;
	}
	public String getAddressLine2() {
		return AddressLine2;
	}
	public void setAddressLine2(String addressLine2) {
		AddressLine2 = addressLine2;
	}
	public String getCity() {
		return City;
	}
	public void setCity(String city) {
		City = city;
	}
	public String getState() {
		return State;
	}
	public void setState(String state) {
		State = state;
	}
	public String getPostalCode() {
		return PostalCode;
	}
	public void setPostalCode(String postalCode) {
		PostalCode = postalCode;
	}
	public String getCountry() {
		return Country;
	}
	public void setCountry(String country) {
		Country = country;
	}
	public String getNomineeName() {
		return NomineeName;
	}
	public void setNomineeName(String nomineeName) {
		NomineeName = nomineeName;
	}
	public String getNomineeRelation() {
		return NomineeRelation;
	}
	public void setNomineeRelation(String nomineeRelation) {
		NomineeRelation = nomineeRelation;
	}
	public String getNomineeDob() {
		return NomineeDob;
	}
	public void setNomineeDob(String nomineeDob) {
		NomineeDob = nomineeDob;
	}
	public double getNomineeShare() {
		return NomineeShare;
	}
	public void setNomineeShare(double d) {
		NomineeShare = d;
	}
	public String getEmploymentStatus() {
		return EmploymentStatus;
	}
	public void setEmploymentStatus(String employmentStatus) {
		EmploymentStatus = employmentStatus;
	}
	public double getAnnualIncome() {
		return AnnualIncome;
	}
	public void setAnnualIncome(double annualIncome) {
		AnnualIncome = annualIncome;
	}
	public boolean isEmailVerified() {
		return EmailVerified;
	}
	public void setEmailVerified(boolean emailVerified) {
		EmailVerified = emailVerified;
	}
	public boolean isMobileVerified() {
		return MobileVerified;
	}
	public void setMobileVerified(boolean mobileVerified) {
		MobileVerified = mobileVerified;
	}
	public String getKycStatus() {
		return KycStatus;
	}
	public void setKycStatus(String kycStatus) {
		KycStatus = kycStatus;
	}
	public String getRole() {
		return Role;
	}
	public void setRole(String role) {
		Role = role;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}
	public String getCreatedAt() {
		return CreatedAt;
	}
	public void setCreatedAt(String createdAt) {
		CreatedAt = createdAt;
	}
	public String getUpdatedAt() {
		return UpdatedAt;
	}
	public void setUpdatedAt(String updatedAt) {
		UpdatedAt = updatedAt;
	}
}

