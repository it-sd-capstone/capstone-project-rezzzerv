package service;

import daos.RoomDao;
import daos.ReserveDao;
import daos.UserDao;
import model.rooms.Room;
import model.reserve.Reserve;
import model.users.User;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class ReservationService {
    private ReserveDao reserveDao;
    private RoomDao roomDao;
    private UserDao userDao;

    public ReservationService() {
        this.reserveDao = new ReserveDao();
        this.roomDao = new RoomDao();
        this.userDao = new UserDao();
    }

    public Reserve createReservation(Long userId, String roomType, LocalDate checkIn, LocalDate checkOut) throws Exception {
        // Validate dates
        if (checkIn.isAfter(checkOut)) {
            throw new Exception("Check-in date must be before check-out date");
        }

        // Get user
        User user = userDao.getUserById(userId);
        if (user == null) {
            throw new Exception("User not found");
        }

        // Find available room
        Room selectedRoom = findAvailableRoom(roomType);
        if (selectedRoom == null) {
            throw new Exception("No " + roomType + " rooms available for the selected dates");
        }

        // Create reserve object
        Reserve reserve = new Reserve();
        reserve.setStatus("Pending");
        reserve.setCheckIn(checkIn);
        reserve.setCheckOut(checkOut);
        reserve.setUser(user);
        reserve.setRoom(selectedRoom);

        // Save reservation to database
        reserveDao.insertReserve(reserve);

        // Mark room as unavailable
        selectedRoom.setAvailable(false);
        roomDao.updateRoom(selectedRoom);

        return reserve;
    }

    public long calculateNights(LocalDate checkIn, LocalDate checkOut) {
        return ChronoUnit.DAYS.between(checkIn, checkOut);
    }

    public double calculateTotalPrice(Room room, long nights) {
        return room.getPrice() * nights;
    }

    private Room findAvailableRoom(String roomType) {
        List<Room> allRooms = roomDao.getAll();
        for (Room room : allRooms) {
            if (room.getType().equals(roomType) && room.isAvailable()) {
                return room;
            }
        }
        return null;
    }

    public List<Reserve> getUserReservations(Long userId) {
        return reserveDao.findReserveByUserId(userId);
    }

    /**
     * Cancels a reservation without checking user ownership
     * This method is for admin use or when user verification is done elsewhere
     *
     * @param reserveId The ID of the reservation to cancel
     * @throws Exception If the reservation is not found or cannot be cancelled
     */
    public void cancelReservation(Long reserveId) throws Exception {
        Reserve reserve = reserveDao.getReserveById(reserveId);
        if (reserve == null) {
            throw new Exception("Reservation not found");
        }

        // Update status to cancelled
        reserve.setStatus("Cancelled");
        reserveDao.updateReserve(reserve);

        // Make room available again
        Room room = reserve.getRoom();
        room.setAvailable(true);
        roomDao.updateRoom(room);
    }

    public void updateReservationStatus(Long reserveId, String status) throws Exception {
        Reserve reserve = reserveDao.getReserveById(reserveId);
        if (reserve == null) {
            throw new Exception("Reservation not found");
        }
        reserve.setStatus(status);
        reserveDao.updateReserve(reserve);
    }

    /**
     * Cancels a reservation with user verification
     * This method checks if the reservation belongs to the specified user
     *
     * @param reserveId The ID of the reservation to cancel
     * @param userId The ID of the user making the cancellation request
     * @return true if cancellation was successful, false otherwise
     */
    public boolean cancelReservation(Long reserveId, Long userId) {
        try {
            // Get the reservation
            Reserve reserve = reserveDao.getReserveById(reserveId);

            // Check if reservation exists and belongs to the user
            if (reserve == null || !reserve.getUser().getId().equals(userId)) {
                return false;
            }

            // Update status to cancelled
            reserve.setStatus("Cancelled");
            reserveDao.updateReserve(reserve);

            // Make room available again
            Room room = reserve.getRoom();
            room.setAvailable(true);
            roomDao.updateRoom(room);

            return true;
        } catch (Exception e) {
            System.out.println("Error cancelling reservation: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
