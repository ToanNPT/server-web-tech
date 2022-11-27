package com.hcmute.backendtechnologicalapplianceswebsite.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RegisterForm {
    private String username;
    private String password;
    private String name;
    private String email;
    private String phoneNumber;
    private LocalDate dateOfBirth;
    private String address;
    private Boolean gender;
}
