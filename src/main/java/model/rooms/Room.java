package model.rooms;

public abstract class Room {

    private Long id;
    private int roomNumber;
    private boolean available = true;
    private String type;
    private double price;

    public Room() {
    }

    public Room(Long id, int roomNumber, boolean available, String type, double price) {
        this.id = id;
        this.roomNumber = roomNumber;
        this.available = available;
        this.type = type;
        this.price = price;
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

    //new getter and setters
    public String getType() {
        return type;
    }

    protected void setType(String type) {
        this.type = type;
    }

    public double getPrice() {
        return price;
    }

    protected void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "Room Id: " + id + " room number= " + roomNumber + " available= "
                + available + " type= " + type + ", Price = " + price + "\n";
    }
}

