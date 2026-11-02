package com.VHealthAssure.Entity;

import java.math.BigDecimal;
import java.sql.Date;

public class ClaimEntity {
    private long claimId;
    private String claimNumber;
    private String userId;
    private Date claimDate;
    private String status;
    private BigDecimal amountClaimed;
    private String policyNumber;

    public long getClaimId() { return claimId; }
    public void setClaimId(long claimId) { this.claimId = claimId; }

    public String getClaimNumber() { return claimNumber; }
    public void setClaimNumber(String claimNumber) { this.claimNumber = claimNumber; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public Date getClaimDate() { return claimDate; }
    public void setClaimDate(Date claimDate) { this.claimDate = claimDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getAmountClaimed() { return amountClaimed; }
    public void setAmountClaimed(BigDecimal amountClaimed) {
        this.amountClaimed = amountClaimed;
    }

    public String getPolicyNumber() { return policyNumber; }
    public void setPolicyNumber(String policyNumber) {
        this.policyNumber = policyNumber;
    }
}
