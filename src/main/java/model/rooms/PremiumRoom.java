package model.rooms;

public class PremiumRoom extends Room{

    public PremiumRoom(Long id, int roomNumber, boolean available, double price) {
        super(id, roomNumber, available, "Premium", price);
    }
}
