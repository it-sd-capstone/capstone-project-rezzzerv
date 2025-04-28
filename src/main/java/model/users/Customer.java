package model.users;

import model.reserve.Reserve;

import java.util.List;

public class Customer extends User {

    public Customer() {
    }

    public Customer(Long id, String name, String lastName,
                    String phone, String email, String password,
                    List<Reserve> reserves) {
        super(id, name, lastName, phone, email, password, reserves);
    }

    @Override
    public boolean maxReservation() {
        int capacity = 3;
        return getReserves().size() < capacity;
    }
}