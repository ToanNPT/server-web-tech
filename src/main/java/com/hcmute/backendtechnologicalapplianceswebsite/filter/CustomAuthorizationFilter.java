package com.hcmute.backendtechnologicalapplianceswebsite.filter;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import static com.hcmute.backendtechnologicalapplianceswebsite.filter.CustomAuthenticationFilter.JWT_SECRET;
import static java.util.Arrays.stream;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;

@Slf4j
public class CustomAuthorizationFilter extends OncePerRequestFilter {
    final String apiPath = "/api/technological_appliances";

    // For anonimous user
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String servletPath = request.getServletPath();
        String method = request.getMethod();

        if (method.equals("GET")) {
            List<String> publicPaths = new ArrayList<>();
            publicPaths.add(apiPath + "/products/**");
            publicPaths.add(apiPath + "/brands/**");
            publicPaths.add(apiPath + "/reviews/**");
            publicPaths.add(apiPath + "/categories/**");
            publicPaths.add("/getImage/**");
            publicPaths.add("/downloadFile/**");

            for (String path : publicPaths) {
                if (path.contains("/**") && servletPath.startsWith(path.replace("/**", ""))) {
                    return true;
                } else if (servletPath.equals(path)) {
                    return true;
                }
            }
        } else if (method.equals("POST")) {
            List<String> publicPaths = new ArrayList<>();
            publicPaths.add(apiPath + "/login");
            publicPaths.add(apiPath + "/register");
            publicPaths.add(apiPath + "/forgot-password/**");
            publicPaths.add(apiPath + "/reset-password/**");

            for (String path : publicPaths) {
                if (path.contains("/**") && servletPath.startsWith(path.replace("/**", ""))) {
                    return true;
                } else if (servletPath.equals(path)) {
                    return true;
                }
            }
        }

        return false;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        if (isLoginRequest(request)) {
            filterChain.doFilter(request, response);
        } else {
            String token = request.getHeader(AUTHORIZATION);
            if (token != null && token.startsWith("Bearer ")) {
                try {
                    token = token.substring("Bearer ".length());
                    Algorithm algorithm = Algorithm.HMAC256(JWT_SECRET.getBytes());
                    JWTVerifier verifier = JWT.require(algorithm).build();
                    DecodedJWT jwt = verifier.verify(token);
                    String username = jwt.getSubject();
                    String[] roles = jwt.getClaim("roles").asArray(String.class);
                    Collection<SimpleGrantedAuthority> authorities = new ArrayList<>();
                    stream(roles).forEach(role -> authorities.add(new SimpleGrantedAuthority(role)));
                    UsernamePasswordAuthenticationToken authToken =
                            new UsernamePasswordAuthenticationToken(username, null, authorities);
                    SecurityContextHolder.getContext().setAuthentication(authToken);

                    log.info("Current user: {}, roles: {}", username, roles);
                    if (Arrays.asList(roles).contains("ROLE_ADMIN")) { // Check if user is admin
                        filterChain.doFilter(request, response);
                    } else { // For user
                        if (isValidUserRequest(request, username)) {
                            try {
                                filterChain.doFilter(request, response);
                            } catch (Exception e) {
                                log.error("Error: {}", e.getMessage());
                                response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
                            }
                        } else {
                            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to access this resource");
                        }
                    }
                } catch (Exception e) {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authentication failed, error: " + e.getMessage());
                }
            } else {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token must be provided as 'Authorization: Bearer <token>'");
            }
        }
    }

    private boolean isValidUserRequest(HttpServletRequest request, String username) {
        return switch (request.getMethod()) {
            case "GET" -> isGETRequestValid(request.getServletPath(), username);
            case "POST" -> isPOSTRequestValid(request.getServletPath(), username);
            case "PUT" -> isPUTRequestValid(request.getServletPath(), username);
            case "DELETE" -> isDELETERequestValid(request.getServletPath(), username);
            default -> false;
        };
    }

    private boolean isDELETERequestValid(String servletPath, String username) {
        List<String> userPaths = new ArrayList<>();
        // CartDetail
        userPaths.add(apiPath + "/cart-details/" + username + "/**");
        // Order
        userPaths.add(apiPath + "/orders/" + username);
        // OrderDetail
        userPaths.add(apiPath + "/order-details/" + username + "/**");
        // Review
        userPaths.add(apiPath + "/reviews/" + username + "/**");

        for (String path : userPaths) {
            if (path.contains("/**") && servletPath.startsWith(path.replace("/**", ""))) {
                return true;
            } else if (servletPath.equals(path)) {
                return true;
            }
        }

        return false;
    }

    private boolean isPUTRequestValid(String servletPath, String username) {
        List<String> userPaths = new ArrayList<>();
        // CartDetail
        userPaths.add(apiPath + "/cart-details/" + username + "/**");
        // Review
        userPaths.add(apiPath + "/reviews/" + username + "/**");
        // User
        userPaths.add(apiPath + "/users/" + username);

        for (String path : userPaths) {
            if (path.contains("/**") && servletPath.startsWith(path.replace("/**", ""))) {
                return true;
            } else if (servletPath.equals(path)) {
                return true;
            }
        }
        return false;
    }

    private boolean isPOSTRequestValid(String servletPath, String username) {
        List<String> userPaths = new ArrayList<>();
        // CartDetail
        userPaths.add(apiPath + "/cart-details/" + username + "/**");
        // Order
        userPaths.add(apiPath + "/orders/" + username);
        // OrderDetail
        userPaths.add(apiPath + "/order-details/" + username);
        // Review
        userPaths.add(apiPath + "/reviews/" + username + "/**");
        // User
        userPaths.add(apiPath + "/change-password/" + username);

        for (String path : userPaths) {
            if (path.contains("/**") && servletPath.startsWith(path.replace("/**", ""))) {
                return true;
            } else if (servletPath.equals(path)) {
                return true;
            }
        }
        return false;
    }

    private boolean isGETRequestValid(String servletPath, String username) {
        List<String> userPaths = new ArrayList<>();
        // CartDetail
        userPaths.add(apiPath + "/cart-details/" + username + "/**");
        // Order
        userPaths.add(apiPath + "/orders/username/" + username);
        // OrderDetail
        userPaths.add(apiPath + "/order-details/username/" + username);
        // User
        userPaths.add(apiPath + "/users/" + username);
        // Coupon
        userPaths.add(apiPath + "/coupons/**");
        // Delivery
        userPaths.add(apiPath + "/deliveries/**");


        for (String path : userPaths) {
            if (path.contains("/**") && servletPath.startsWith(path.replace("/**", ""))) {
                return true;
            } else if (servletPath.equals(path)) {
                return true;
            }
        }
        return false;
    }

    private boolean isLoginRequest(HttpServletRequest request) {
        return request.getRequestURI().equals("/login") && request.getMethod().equals("POST");
    }
}
