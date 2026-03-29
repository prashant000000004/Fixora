package com.fixnow.dto;

import lombok.Data;
import java.util.List;

@Data
public class ScheduleUpdateRequest {
    private List<String> availableDays; // e.g., ["MONDAY", "TUESDAY", ...]
    private String startTime; // e.g., "09:00"
    private String endTime; // e.g., "18:00"
    private List<String> blockedDates; // ISO date strings
}
