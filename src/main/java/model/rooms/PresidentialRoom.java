package model.rooms;

public class PresidentialRoom extends Room{

    public PresidentialRoom(Long id, int roomNumber, boolean available, double price) {
        super(id, roomNumber, available, "Presidential", price);
    }
}
