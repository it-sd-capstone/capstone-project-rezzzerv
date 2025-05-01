package model.rooms;

public class RoomConstruction {
    public static Room createRoom(String type, Long id, int roomNumber, boolean available, double price) {
        switch (type) {
            case "Basic":
                return new BasicRoom(id, roomNumber, available, price);
            case "Premium":
                return new PremiumRoom(id, roomNumber, available, price);
            case "Presidential":
                return new PresidentialRoom(id, roomNumber, available, price);
            default:
                throw new IllegalArgumentException("Incorrect room type: " + type);
        }
    }
}
