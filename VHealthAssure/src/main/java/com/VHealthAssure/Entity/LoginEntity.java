package com.VHealthAssure.Entity;

public class LoginEntity {

    private String Identifier;   // email or mobile
    private String Role;         // USER or ADMIN
    private String Password;
	public String getIdentifier() {
		return Identifier;
	}
	public void setIdentifier(String identifier) {
		Identifier = identifier;
	}
	public String getRole() {
		return Role;
	}
	public void setRole(String role) {
		Role = role;
	}
	public String getPassword() {
		return Password;
	}
	public void setPassword(String password) {
		Password = password;
	}
}
