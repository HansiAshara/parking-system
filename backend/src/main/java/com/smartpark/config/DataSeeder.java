package com.smartpark.config;

import com.smartpark.modules.booking.model.Booking;
import com.smartpark.modules.booking.model.BookingStatus;
import com.smartpark.modules.booking.repository.BookingRepository;
import com.smartpark.modules.spot.model.ParkingSpot;
import com.smartpark.modules.spot.model.SpotStatus;
import com.smartpark.modules.spot.model.SpotType;
import com.smartpark.modules.spot.repository.ParkingSpotRepository;
import com.smartpark.modules.user.model.Role;
import com.smartpark.modules.user.model.User;
import com.smartpark.modules.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final ParkingSpotRepository spotRepository;
    private final BookingRepository bookingRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (userRepository.count() == 0) {
            seedData();
        }
    }

    private void seedData() {
        // 1. Seed Demo Driver
        User driver = User.builder()
                .name("Alex Johnson")
                .email("driver@smartpark.com")
                .password(passwordEncoder.encode("password"))
                .phone("+1 555-0101")
                .role(Role.ROLE_DRIVER)
                .avatarUrl("https://i.pravatar.cc/150?img=11")
                .totalBookings(24)
                .totalSpent(890.50)
                .isVerified(true)
                .build();
        driver = userRepository.save(driver);

        // 2. Seed Demo Owner
        User owner = User.builder()
                .name("Sarah Mitchell")
                .email("owner@smartpark.com")
                .password(passwordEncoder.encode("password"))
                .phone("+1 555-0102")
                .role(Role.ROLE_OWNER)
                .avatarUrl("https://i.pravatar.cc/150?img=5")
                .totalSpots(2)
                .totalEarnings(12450.00)
                .averageRating(4.8)
                .isVerified(true)
                .build();
        owner = userRepository.save(owner);

        // 3. Seed Demo Spots
        ParkingSpot spot1 = ParkingSpot.builder()
                .owner(owner)
                .title("Downtown Premium Covered Spot")
                .description("Secure covered parking in downtown financial center. 24/7 CCTV surveillance.")
                .address("123 Market Street, Downtown")
                .latitude(37.7749)
                .longitude(-122.4194)
                .pricePerHour(8.00)
                .pricePerDay(45.00)
                .type(SpotType.COVERED)
                .status(SpotStatus.AVAILABLE)
                .images(List.of(
                        "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=800",
                        "https://images.unsplash.com/photo-1621929747188-6b4dc5244330?w=800"
                ))
                .amenities(List.of("CCTV Security", "24/7 Access", "EV Charging", "Covered"))
                .rating(4.9)
                .reviewCount(127)
                .isApproved(true)
                .build();

        ParkingSpot spot2 = ParkingSpot.builder()
                .owner(owner)
                .title("Shopping District Open Lot")
                .description("Convenient open lot space directly opposite the city shopping mall.")
                .address("456 Mall Avenue, Shopping District")
                .latitude(37.7849)
                .longitude(-122.4094)
                .pricePerHour(4.50)
                .pricePerDay(25.00)
                .type(SpotType.OPEN)
                .status(SpotStatus.AVAILABLE)
                .images(List.of("https://images.unsplash.com/photo-1590674899505-1c5c41967caa?w=800"))
                .amenities(List.of("Near Mall", "Easy In/Out", "Well Lit"))
                .rating(4.5)
                .reviewCount(89)
                .isApproved(true)
                .build();

        spotRepository.saveAll(List.of(spot1, spot2));

        // 4. Seed Demo Booking
        Booking booking = Booking.builder()
                .driver(driver)
                .spot(spot1)
                .startTime(LocalDateTime.now().plusHours(2))
                .endTime(LocalDateTime.now().plusHours(5))
                .totalPrice(24.00)
                .status(BookingStatus.CONFIRMED)
                .vehicleNumber("CA-789-XY")
                .vehicleModel("Tesla Model 3")
                .paymentMethod("Visa **** 4242")
                .notes("Charging required if available")
                .qrCodeData("SMARTPARK-DEMO-QR-001")
                .build();

        bookingRepository.save(booking);
    }
}
