package model.reserve;

import model.rooms.Room;
import model.users.User;

import java.time.LocalDate;

public class Reserve {
    private Long id;
    private String status;
    private LocalDate checkIn;
    private LocalDate checkOut;
    private User user;
    private Room room;

    public Reserve() {
    }

    public Reserve(Long id, String status, LocalDate checkIn, LocalDate checkOut, User user, Room room) {
        this.id = id;
        this.status = status;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.user = user;
        this.room = room;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(LocalDate checkIn) {
        this.checkIn = checkIn;
    }

    public LocalDate getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(LocalDate checkOut) {
        this.checkOut = checkOut;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    @Override
    public String toString() {
        return "Reservation id = " + id + "\n"+
                " [Status: " + status + "\n"+
                ", Check-in: " + checkIn + "\n"+
                ", Check-out: " + checkOut + "\n"+
                ", User: " + user + "\n"+
                ", Room: " + room + "]";
    }
}
