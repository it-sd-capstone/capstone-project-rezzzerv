package model.users;

import model.reserve.Reserve;

import java.util.List;

public class Administrator extends User {

    public Administrator() {
    }

    public Administrator(Long id, String name, String lastName, String phone,
                         String email, String password, List<Reserve> reserves) {
        super(id, name, lastName, phone, email, password, reserves);
    }

    @Override
    public boolean maxReservation() {
        return true;
    }

    @Override
    public boolean isAdmin() {
        return true;
    }
}