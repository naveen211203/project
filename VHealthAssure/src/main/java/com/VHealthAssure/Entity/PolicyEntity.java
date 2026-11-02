package com.VHealthAssure.Entity;

import java.math.BigDecimal;
import java.sql.Date;

public class PolicyEntity {

    private String policyNumber;
    private String policyType;
    private String status;
    private BigDecimal premiumAmount;
    private Date nextPremiumDate;
    private Date createdAt;

    public String getPolicyNumber() {
        return policyNumber;
    }

    public void setPolicyNumber(String policyNumber) {
        this.policyNumber = policyNumber;
    }

    public String getPolicyType() {
        return policyType;
    }

    public void setPolicyType(String policyType) {
        this.policyType = policyType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getPremiumAmount() {
        return premiumAmount;
    }

    public void setPremiumAmount(BigDecimal premiumAmount) {
        this.premiumAmount = premiumAmount;
    }

    public Date getNextPremiumDate() {
        return nextPremiumDate;
    }

    public void setNextPremiumDate(Date nextPremiumDate) {
        this.nextPremiumDate = nextPremiumDate;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}