package com.fixnow.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.List;

@Data
public class SubmitReviewRequest {
    @NotNull
    @Min(1)
    @Max(5)
    private Double rating;

    private String comment;
    private List<String> tags;
}
