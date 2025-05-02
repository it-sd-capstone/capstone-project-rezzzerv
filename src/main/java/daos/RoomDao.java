package daos;

import db.DbConnection;
import model.rooms.Room;
import model.rooms.RoomConstruction;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RoomDao {
    private Connection connection;

    public RoomDao() {
        try {
            connection = DbConnection.getConnection();
        } catch (Exception e) {
            System.err.println("Error connecting to database: " + e.getMessage());
        }
    }

    // Method used in Main.java - renamed from createRoom to insertRoom
    public boolean insertRoom(Room room) {
        String query = "INSERT INTO rooms (roomNumber, available, type, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, room.getRoomNumber());
            pstmt.setBoolean(2, room.isAvailable());
            pstmt.setString(3, room.getType());
            pstmt.setDouble(4, room.getPrice());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        room.setId(generatedKeys.getLong(1));
                        return true;
                    }
                }
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error creating room: " + e.getMessage());
            return false;
        }
    }

    // Method used in Main.java - renamed from getAllRooms to getAll
    public List<Room> getAll() {
        List<Room> rooms = new ArrayList<>();
        String query = "SELECT * FROM rooms";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Long id = rs.getLong("id");
                String type = rs.getString("type");
                int roomNumber = rs.getInt("roomNumber");
                boolean available = rs.getBoolean("available");
                double price = rs.getDouble("price");

                Room room = RoomConstruction.createRoom(type, id, roomNumber, available, price);
                rooms.add(room);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all rooms: " + e.getMessage());
        }

        return rooms;
    }

    // Get a room by ID - already exists but keeping for clarity
    public Room getRoomById(Long id) {
        String query = "SELECT * FROM rooms WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setLong(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String type = rs.getString("type");
                    int roomNumber = rs.getInt("roomNumber");
                    boolean available = rs.getBoolean("available");
                    double price = rs.getDouble("price");

                    return RoomConstruction.createRoom(type, id, roomNumber, available, price);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting room by ID: " + e.getMessage());
        }
        return null;
    }

    // Method used in Main.java - renamed from updateRoom to match
    public boolean updateRoom(Room room) {
        String query = "UPDATE rooms SET roomNumber = ?, available = ?, type = ?, price = ? WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, room.getRoomNumber());
            pstmt.setBoolean(2, room.isAvailable());
            pstmt.setString(3, room.getType());
            pstmt.setDouble(4, room.getPrice());
            pstmt.setLong(5, room.getId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating room: " + e.getMessage());
            return false;
        }
    }

    // Method used in Main.java - already exists but keeping for clarity
    public boolean deleteRoom(Long id) {
        String query = "DELETE FROM rooms WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setLong(1, id);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting room: " + e.getMessage());
            return false;
        }
    }

    // Get all room types (distinct)
    public List<Room> getAllRoomTypes() {
        List<Room> roomTypes = new ArrayList<>();
        String query = "SELECT DISTINCT type, price FROM rooms GROUP BY type, price";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                String type = rs.getString("type");
                double price = rs.getDouble("price");

                // Create a room with default values for id, roomNumber, and available
                Room room = RoomConstruction.createRoom(type, 0L, 0, true, price);
                roomTypes.add(room);
            }
        } catch (SQLException e) {
            System.err.println("Error getting room types: " + e.getMessage());
        }

        return roomTypes;
    }

    // Count available rooms by type
    public int countAvailableRoomsByType(String type) {
        String query = "SELECT COUNT(*) FROM rooms WHERE type = ? AND available = true";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, type);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error counting available rooms by type: " + e.getMessage());
        }
        return 0;
    }

    // Method to get room description by type
    public String getRoomDescription(String roomType) {
        switch (roomType) {
            case "Basic":
                return "Standard room with basic amenities, perfect for solo travelers or couples";
            case "Premium":
                return "Spacious room with premium amenities, ideal for extended stays";
            case "Presidential":
                return "Luxurious suite with all amenities, offering the ultimate comfort and elegance";
            default:
                return "Room with standard amenities";
        }
    }

    // Method to get room capacity by type
    public int getRoomCapacity(String roomType) {
        switch (roomType) {
            case "Basic":
                return 2;
            case "Premium":
                return 3;
            case "Presidential":
                return 4;
            default:
                return 2;
        }
    }

    // Method to get all room descriptions
    public Map<String, String> getAllRoomDescriptions() {
        Map<String, String> descriptions = new HashMap<>();
        descriptions.put("Basic", getRoomDescription("Basic"));
        descriptions.put("Premium", getRoomDescription("Premium"));
        descriptions.put("Presidential", getRoomDescription("Presidential"));
        return descriptions;
    }

    // Method to get all room capacities
    public Map<String, Integer> getAllRoomCapacities() {
        Map<String, Integer> capacities = new HashMap<>();
        capacities.put("Basic", getRoomCapacity("Basic"));
        capacities.put("Premium", getRoomCapacity("Premium"));
        capacities.put("Presidential", getRoomCapacity("Presidential"));
        return capacities;
    }

    // Close the database connection
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing database connection: " + e.getMessage());
        }
    }
}
