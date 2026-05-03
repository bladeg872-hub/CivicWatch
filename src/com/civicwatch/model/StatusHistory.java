package com.civicwatch.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class StatusHistory implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int reportId;
    private String oldStatus;
    private String newStatus;
    private int changedBy;
    private String comment;
    private Timestamp createdAt;

    private String changedByName;

    public StatusHistory() {
    }

    public StatusHistory(int reportId, String oldStatus, String newStatus, int changedBy) {
        this.reportId = reportId;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.changedBy = changedBy;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getChangedByName() {
        return changedByName;
    }

    public void setChangedByName(String changedByName) {
        this.changedByName = changedByName;
    }

    @Override
    public String toString() {
        return "StatusHistory{" +
                "id=" + id +
                ", reportId=" + reportId +
                ", oldStatus='" + oldStatus + '\'' +
                ", newStatus='" + newStatus + '\'' +
                '}';
    }
}
