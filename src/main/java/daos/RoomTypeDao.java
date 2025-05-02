package daos;

import db.DbConnection;
import model.rooms.RoomType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDao {

    public List<RoomType> getAllRoomTypes() {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT type, price FROM rooms ORDER BY " +
                "CASE type " +
                "WHEN 'Basic' THEN 1 " +
                "WHEN 'Premium' THEN 2 " +
                "WHEN 'Presidential' THEN 3 " +
                "ELSE 4 END";

        Connection conn = DbConnection.getConnection();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            long id = 1; // Since we don't have a separate room_types table
            while (rs.next()) {
                RoomType roomType = new RoomType();
                roomType.setId(id++);
                roomType.setName(rs.getString("type"));
                roomType.setPrice(rs.getDouble("price"));

                // Set default values for description and capacity
                switch (roomType.getName()) {
                    case "Basic":
                        roomType.setDescription("Standard room with basic amenities");
                        roomType.setCapacity(2);
                        break;
                    case "Premium":
                        roomType.setDescription("Spacious room with premium amenities");
                        roomType.setCapacity(3);
                        break;
                    case "Presidential":
                        roomType.setDescription("Luxurious suite with all amenities");
                        roomType.setCapacity(4);
                        break;
                    default:
                        roomType.setDescription("Room with standard amenities");
                        roomType.setCapacity(2);
                }

                roomTypes.add(roomType);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving room types");
            e.printStackTrace();
        }

        return roomTypes;
    }

    // Method to count available rooms by type
    public int countAvailableRoomsByType(String typeName) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE type = ? AND available = true";
        int count = 0;

        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, typeName);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error counting available rooms by type");
            e.printStackTrace();
        }

        return count;
    }

    // Method to get price by room type
    public double getPriceByRoomType(String typeName) {
        String sql = "SELECT price FROM rooms WHERE type = ? LIMIT 1";
        double price = 0.0;

        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, typeName);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    price = rs.getDouble("price");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting price by room type");
            e.printStackTrace();
        }

        return price;
    }
}
