package com.example.GwDanganApp.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class JwtConfig {
    @Value("${app.jwtSecret:mysecretkey}")
    private String jwtSecret;

    @Value("${app.jwtExpirationMs:86400000}")
    private int jwtExpirationMs;

    public String getJwtSecret() {
        return jwtSecret;
    }

    public int getJwtExpirationMs() {
        return jwtExpirationMs;
    }
}
