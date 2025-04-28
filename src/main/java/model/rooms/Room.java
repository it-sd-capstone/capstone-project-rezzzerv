package model.rooms;

public abstract class Room {

    private Long id;
    private int roomNumber;
    private boolean available = true;

    public Room() {
    }

    public Room(Long id, int roomNumber, boolean available) {
        this.id = id;
        this.roomNumber = roomNumber;
        this.available = available;
    }

    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }

    public int getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(int roomNumber) {
        this.roomNumber = roomNumber;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public abstract double getPrice();

    public abstract String getType();

    @Override
    public String toString() {
        return "Room Id: " + id + " room number= " + roomNumber + " available= "
                + available + " type= " + getType() + ", Price = " + getPrice() + "\n";
    }
}

