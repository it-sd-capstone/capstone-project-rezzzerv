package model.rooms;

public class BasicRoom extends Room {
    public BasicRoom(Long id, int roomNumber, boolean available, double price) {
        super(id, roomNumber, available, "Basic", price);
    }
}
