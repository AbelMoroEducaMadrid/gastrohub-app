package com.abel.gastrohub.restaurant.dto;

public class RestaurantUpdateDTO {
    private String name;
    private Integer ownerId;
    private String address;
    private String cuisineType;

    // Getters y setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getOwnerId() { return ownerId; }
    public void setOwnerId(Integer ownerId) { this.ownerId = ownerId; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getCuisineType() { return cuisineType; }
    public void setCuisineType(String cuisineType) { this.cuisineType = cuisineType; }
}