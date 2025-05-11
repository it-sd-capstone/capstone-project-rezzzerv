package model.users;

import model.reserve.Reserve;

import java.util.ArrayList;
import java.util.List;

public abstract class User {

    private Long id;
    private String name;
    private String lastName;
    private String phone;
    private String email;
    private String password;
    private List<Reserve> reserves = new ArrayList<>();

    public User() {
    }

    public User(Long id, String name, String lastName,
                String phone, String email, String password,
                List<Reserve> reserves) {
        this.id = id;
        this.name = name;
        this.lastName = lastName;
        this.phone = phone;
        this.email = email;
        this.password = password;
        this.reserves = reserves;
    }

    public boolean isAdmin() {
        return false;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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

    public List<Reserve> getReserves() {
        return reserves;
    }

    public void setReserves(List<Reserve> reserves) {
        this.reserves = reserves;
    }

    public abstract boolean maxReservation();

    public abstract String getUserType();

    @Override
    public String toString() {
        return "User Id: "+ id + " name is " + name + " " +
                lastName + ", his information is phone = " +
                phone + ", email='" +
                email + ", reserves=" + reserves + "\n";
    }
}
