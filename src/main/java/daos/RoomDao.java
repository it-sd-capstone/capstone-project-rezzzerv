package daos;

import db.DbConnection;
import model.rooms.Room;
import model.rooms.RoomConstruction;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;
import java.sql.Date;

public class RoomDao {


    public boolean insertRoom(Room room) {
        String query = "INSERT INTO rooms (roomNumber, available, type, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

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


    public List<Room> getAll() {
        List<Room> rooms = new ArrayList<>();
        String query = "SELECT * FROM rooms";

        try (Connection conn = DbConnection.getConnection();
             Statement stmt = conn.createStatement();
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


    public Room getRoomById(Long id) {
        String query = "SELECT * FROM rooms WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query)) {

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


    public boolean updateRoom(Room room) {
        String query = "UPDATE rooms SET roomNumber = ?, available = ?, type = ?, price = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query)) {

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

    public boolean deleteRoom(Long id) {
        String query = "DELETE FROM rooms WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setLong(1, id);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting room: " + e.getMessage());
            return false;
        }
    }


    public List<Room> getAllRoomTypes() {
        List<Room> roomTypes = new ArrayList<>();
        String query = "SELECT DISTINCT type, price FROM rooms GROUP BY type, price";

        try (Connection conn = DbConnection.getConnection();
            Statement stmt = conn.createStatement();
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
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
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


    // Method to get all room descriptions
    public Map<String, String> getAllRoomDescriptions() {
        Map<String, String> descriptions = new HashMap<>();
        descriptions.put("Basic", getRoomDescription("Basic"));
        descriptions.put("Premium", getRoomDescription("Premium"));
        descriptions.put("Presidential", getRoomDescription("Presidential"));
        return descriptions;
    }


    public int countReservedRooms(String type, LocalDate in, LocalDate out) {
        String sql =
                "SELECT COUNT(*) "
                        + "  FROM reserves r "
                        + "  JOIN rooms m ON r.roomId = m.id "
                        + " WHERE m.type = ? "
                        + "   AND NOT (r.checkOut <= ? OR r.checkIn >= ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            // java.sql.Date wraps LocalDate
            ps.setDate(2, Date.valueOf(in));
            ps.setDate(3, Date.valueOf(out));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting reserved rooms: " + e.getMessage());
        }
        return 0;
    }


}
