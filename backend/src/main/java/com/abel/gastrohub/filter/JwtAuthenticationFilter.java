package com.abel.gastrohub.filter;

import com.abel.gastrohub.exception.ErrorResponse;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.oauth2.jwt.JwtException;
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
    protected void doFilterInternal(
            @org.springframework.lang.NonNull HttpServletRequest request,
            @org.springframework.lang.NonNull HttpServletResponse response,
            @org.springframework.lang.NonNull FilterChain chain)
            throws ServletException, IOException {
        String authorizationHeader = request.getHeader("Authorization");

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            String token = authorizationHeader.substring(7);
            try {
                Claims claims = Jwts.parser()
                        .verifyWith(secretKey)
                        .build()
                        .parseSignedClaims(token)
                        .getPayload();
                String username = claims.getSubject();

                if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    try {
                        UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                                userDetails, null, userDetails.getAuthorities());
                        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                    } catch (UsernameNotFoundException e) {
                        ErrorResponse errorResponse = new ErrorResponse(
                                HttpServletResponse.SC_UNAUTHORIZED,
                                "Usuario no encontrado",
                                e.getMessage(),
                                request.getRequestURI()
                        );
                        sendErrorResponse(response, errorResponse);
                        return;
                    }
                }
            } catch (ExpiredJwtException e) {
                ErrorResponse errorResponse = new ErrorResponse(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Token expirado",
                        e.getMessage(),
                        request.getRequestURI()
                );
                sendErrorResponse(response, errorResponse);
                return;
            } catch (JwtException e) {
                ErrorResponse errorResponse = new ErrorResponse(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Token inválido",
                        e.getMessage(),
                        request.getRequestURI()
                );
                sendErrorResponse(response, errorResponse);
                return;
            }
        }
        chain.doFilter(request, response);
    }

    private void sendErrorResponse(HttpServletResponse response, ErrorResponse errorResponse) throws IOException {
        response.setStatus(errorResponse.getStatus());
        response.setContentType("application/json");
        String jsonResponse = String.format(
                "{\"status\": %d, \"error\": \"%s\", \"message\": \"%s\", \"path\": \"%s\"}",
                errorResponse.getStatus(),
                errorResponse.getError(),
                errorResponse.getMessage(),
                errorResponse.getPath()
        );
        response.getWriter().write(jsonResponse);
    }
}