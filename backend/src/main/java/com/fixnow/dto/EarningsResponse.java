package com.fixnow.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
public class EarningsResponse {
    private double totalEarnings;
    private double weeklyEarnings;
    private double monthlyEarnings;
    private List<DailyEarning> dailyBreakdown;

    @Data
    @Builder
    @AllArgsConstructor
    public static class DailyEarning {
        private String date; // ISO date string
        private double amount;
        private int jobCount;
    }
}
