package com.epsi.batmapp.model;

import com.google.android.gms.maps.model.LatLng;

/**
 * Created by arnaud on 20/01/16.
 */
public class User {

    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private LatLng lastCoordKnown;

    public User() {
    }

    public User(String firstName, String lastName, String email) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public LatLng getLastCoordKnown() {
        return lastCoordKnown;
    }

    public void setLastCoordKnown(LatLng lastCoordKnown) {
        this.lastCoordKnown = lastCoordKnown;
    }
}
