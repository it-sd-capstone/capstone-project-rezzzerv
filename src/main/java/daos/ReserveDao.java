package daos;

import db.DbConnection;
import model.reserve.Reserve;
import model.rooms.Room;
import model.users.User;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReserveDao {

    private final UserDao userDao = new UserDao();
    private final RoomDao roomDao = new RoomDao();

    // create a reserve
    public void insertReserve(Reserve reserve) {
        String sql = "INSERT INTO reserves (status, checkIn, checkOut, userId, roomId) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, reserve.getStatus());
            pstmt.setObject(2, reserve.getCheckIn());
            pstmt.setObject(3, reserve.getCheckOut());
            pstmt.setLong(4, reserve.getUser().getId());
            pstmt.setLong(5, reserve.getRoom().getId());
            pstmt.executeUpdate();

            // recover the id generated to assign it
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    reserve.setId(rs.getLong(1)); // assign the new id Created to the reserve
                }
            }

            System.out.println("Reserve created with ID: " + reserve.getId());
        } catch (SQLException e) {
            System.out.println("Error trying to create the reserve");
            e.printStackTrace();
        }
    }

    // list all reserves
    public List<Reserve> getAll() {
        List<Reserve> list = new ArrayList<>();
        String sql = "SELECT * FROM reserves";
        try (Connection conn = DbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapRowToReserve(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error trying to get the reserve list");
            e.printStackTrace();
        }
        return list;
    }

    // get reserve by id
    public Reserve getReserveById(Long id) {
        String sql = "SELECT * FROM reserves WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToReserve(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting reserve id");
            e.printStackTrace();
        }
        return null;
    }

    // get reserves from a specific user.
    public List<Reserve> findReserveByUserId(Long userId) {
        List<Reserve> list = new ArrayList<>();
        String sql = "SELECT * FROM reserves WHERE userId = ?";

        Connection conn = DbConnection.getConnection();
        try ( PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToReserve(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving reserves for user Id = " + userId);
            e.printStackTrace();
        }
        return list;
    }

    // update
    public void updateReserve(Reserve reserve) {
        String sql = "UPDATE reserves SET status = ?, checkIn = ?, checkOut = ?, userId = ?, roomId = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reserve.getStatus());
            pstmt.setObject(2, reserve.getCheckIn());
            pstmt.setObject(3, reserve.getCheckOut());
            pstmt.setLong(4, reserve.getUser().getId());
            pstmt.setLong(5, reserve.getRoom().getId());
            pstmt.setLong(6, reserve.getId());
            int rows = pstmt.executeUpdate();
            System.out.println(rows > 0
                    ? "Reserve updated"
                    : "unable to find reserve with ID: " + reserve.getId());
        } catch (SQLException e) {
            System.out.println("Error updating reserve");
            e.printStackTrace();
        }
    }


    // DELETE
    public void deleteReserve(Long id) {
        String sql = "DELETE FROM reserves WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, id);
            int rows = pstmt.executeUpdate();
            System.out.println(rows > 0
                    ? "Reserve eliminated with ID: " + id
                    : "No reserve found with ID: " + id);
        } catch (SQLException e) {
            System.out.println("Error eliminating reserve");
            e.printStackTrace();
        }
    }

    private Reserve mapRowToReserve(ResultSet rs) throws SQLException {
        Reserve r = new Reserve();
        r.setId(rs.getLong("id"));
        r.setStatus(rs.getString("status"));
        r.setCheckIn(rs.getObject("checkIn", LocalDate.class));
        r.setCheckOut(rs.getObject("checkOut", LocalDate.class));

        // load the entities relational
        User user = userDao.getUserById(rs.getLong("userId"));
        Room room = roomDao.getRoomById(rs.getLong("roomId"));
        r.setUser(user);
        r.setRoom(room);

        return r;
    }
}
