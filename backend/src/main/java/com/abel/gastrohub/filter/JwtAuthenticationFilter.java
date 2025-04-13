package com.abel.gastrohub.filter;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.crypto.SecretKey;
import java.io.IOException;
import java.util.Base64;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final UserDetailsService userDetailsService;
    private SecretKey secretKey;

    @Value("${jwt.key}")
    private String key;

    public JwtAuthenticationFilter(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    @PostConstruct
    public void init() {
        if (key == null) {
            throw new IllegalStateException("La propiedad 'jwt.key' no está definida");
        }
        System.out.println("Inicializando secretKey con la clave proporcionada");
        this.secretKey = Keys.hmacShaKeyFor(Base64.getDecoder().decode(key));
    }

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull FilterChain chain)
            throws ServletException, IOException {
        String authorizationHeader = request.getHeader("Authorization");

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            System.out.println("Token encontrado en el header: " + authorizationHeader);
            String token = authorizationHeader.substring(7);
            try {
                System.out.println("Intentando parsear el token");
                Claims claims = Jwts.parser()
                        .verifyWith(secretKey)
                        .build()
                        .parseSignedClaims(token)
                        .getPayload();
                String username = claims.getSubject();
                System.out.println("Usuario extraído del token: " + username);
                if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    System.out.println("Cargando detalles del usuario");
                    UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                    System.out.println("Detalles del usuario cargados: " + userDetails.getUsername() + ", Roles: " + userDetails.getAuthorities());
                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());
                    authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    System.out.println("Autenticación establecida para el usuario: " + username);
                }
            } catch (Exception e) {
                System.out.println("Error al procesar el token: " + e.getMessage());
            }
        } else {
            System.out.println("No se encontró token en la solicitud");
        }
        chain.doFilter(request, response);
    }
}