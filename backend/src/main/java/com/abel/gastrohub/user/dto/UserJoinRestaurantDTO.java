package com.abel.gastrohub.user.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserJoinRestaurantDTO {
    @NotNull(message = "El código de invitación no puede ser nulo")
    @JsonProperty("invitation_code")
    private String invitationCode;
}