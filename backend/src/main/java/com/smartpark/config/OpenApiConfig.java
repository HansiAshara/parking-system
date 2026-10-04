package com.smartpark.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "SmartPark REST API",
                version = "1.0.0",
                description = "Modular Enterprise REST API for Smart Parking System (Drivers, Spot Owners, Reservations & Payments)",
                contact = @Contact(name = "SmartPark Team", email = "support@smartpark.com"),
                license = @License(name = "Apache 2.0")
        )
)
@SecurityScheme(
        name = "bearerAuth",
        type = SecuritySchemeType.HTTP,
        bearerFormat = "JWT",
        scheme = "bearer",
        description = "Enter JWT Bearer token obtained from /api/auth/login"
)
public class OpenApiConfig {
}
