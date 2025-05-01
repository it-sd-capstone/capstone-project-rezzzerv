package daos;

import db.DbConnection;
import model.rooms.Room;
import model.rooms.RoomConstruction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDao {

    public void insertRoom(Room room) {
        String sql = "INSERT INTO rooms (roomNumber, available, type, price) VALUES (?, ?, ?, ?)";

        // get connection and keep it open
        Connection conn = DbConnection.getConnection();

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, room.getRoomNumber());
            pstmt.setBoolean(2, room.isAvailable());
            pstmt.setString(3, room.getType());
            // added price parameter
            pstmt.setDouble(4, room.getPrice());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    room.setId(rs.getLong(1));
                }
            }
            System.out.println("Room inserted: " + room.getRoomNumber() + " (ID= " + room.getId() + ")");

        } catch (SQLException e) {
            System.out.println("Error inserting room");
            e.printStackTrace();
        }
    }

    // List of rooms
    public List<Room> getAll() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms";
        Connection conn = DbConnection.getConnection();

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                //Calling the method to check room type
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving rooms");
            e.printStackTrace();
        }

        return rooms;
    }

    // get room by id
    public Room getRoomById(Long id) {
        String sql = "SELECT * FROM rooms WHERE id = ?";
        Connection conn = DbConnection.getConnection();

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    // the resultset now handles the price too
                    return mapResultSetToRoom(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving room by ID");
            e.printStackTrace();
        }

        return null;
    }

    // update room data
    public void updateRoom(Room room) {
        String sql = "UPDATE rooms SET roomNumber = ?, available = ?, type = ?, price = ? WHERE id = ?";
        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, room.getRoomNumber());
            pstmt.setBoolean(2, room.isAvailable());
            pstmt.setString(3, room.getType());
            // added price parameter
            pstmt.setDouble(4, room.getPrice());
            pstmt.setLong(5, room.getId());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Room updated: " + room.getRoomNumber());
            } else {
                System.out.println("No room found with ID " + room.getId());
            }
        } catch (SQLException e) {
            System.out.println("Error updating room");
            e.printStackTrace();
        }
    }


    // delete room by id
    public void deleteRoom(Long id) {
        String sql = "DELETE FROM rooms WHERE id = ?";
        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, id);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Room deleted with ID: " + id);
            } else {
                System.out.println("No room found with ID: " + id);
            }
        } catch (SQLException e) {
            System.out.println("Error deleting room");
            e.printStackTrace();
        }
    }

    //method to reuse the logic for room type lookup
    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {

        Long id = rs.getLong("id");
        int roomNumber = rs.getInt("roomNumber");
        boolean available = rs.getBoolean("available");
        String type = rs.getString("type");
        // added retrieving price from result set
        double price = rs.getDouble("price");

        // rebuild the room base in the type
        return RoomConstruction.createRoom(type, id, roomNumber, available, price);
    }
}
