package com.fixnow.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class DashboardResponse {
    private double todayEarnings;
    private double weeklyEarnings;
    private double monthlyEarnings;
    private int pendingRequests;
    private int completedToday;
    private int activeJobs;
    private Double rating;
    private int totalJobs;
    private boolean isOnline;
}
