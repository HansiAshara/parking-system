package com.smartpark.modules.user.dto;

import com.smartpark.modules.user.model.Role;
import com.smartpark.modules.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserProfileDto {
    private Long id;
    private String name;
    private String email;
    private String phone;
    private String avatarUrl;
    private Role role;
    private boolean isVerified;
    private Integer totalBookings;
    private Double totalSpent;
    private Integer totalSpots;
    private Double totalEarnings;
    private Double averageRating;
    private LocalDateTime createdAt;

    public static UserProfileDto fromEntity(User user) {
        return UserProfileDto.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .avatarUrl(user.getAvatarUrl())
                .role(user.getRole())
                .isVerified(user.isVerified())
                .totalBookings(user.getTotalBookings())
                .totalSpent(user.getTotalSpent())
                .totalSpots(user.getTotalSpots())
                .totalEarnings(user.getTotalEarnings())
                .averageRating(user.getAverageRating())
                .createdAt(user.getCreatedAt())
                .build();
    }
}
