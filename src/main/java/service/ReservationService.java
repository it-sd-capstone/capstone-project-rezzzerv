package service;

import daos.PaymentDao;
import daos.RoomDao;
import daos.ReserveDao;
import daos.UserDao;
import model.payment.Payment;
import model.rooms.Room;
import model.reserve.Reserve;
import model.users.User;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

public class ReservationService {
    private ReserveDao reserveDao;
    private RoomDao roomDao;
    private UserDao userDao;
    private PaymentDao paymentDao;

    public ReservationService() {
        this.reserveDao = new ReserveDao();
        this.roomDao = new RoomDao();
        this.userDao = new UserDao();
        this.paymentDao = new PaymentDao();
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


        // find available room within the selected dates.
        Room selectedRoom = findAvailableRoom(roomType, checkIn, checkOut);
        if (selectedRoom == null) {
            throw new Exception("No " + roomType +
                    " rooms available from " + checkIn + " to " + checkOut);
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

        // Mark room as unavailable no needed any more for reservations
        // since it will be available depending on the dates

        // selectedRoom.setAvailable(false);
        //roomDao.updateRoom(selectedRoom);

        return reserve;
    }

    public long calculateNights(LocalDate checkIn, LocalDate checkOut) {
        return ChronoUnit.DAYS.between(checkIn, checkOut);
    }

    public double calculateTotalPrice(Room room, long nights) {
        return room.getPrice() * nights;
    }

    public List<Reserve> getUserReservations(Long userId) {
        return reserveDao.findReserveByUserId(userId);
    }


    public void updateReservationStatus(Long reserveId, String status) throws Exception {
        Reserve reserve = reserveDao.getReserveById(reserveId);
        if (reserve == null) {
            throw new Exception("Reservation not found");
        }
        reserve.setStatus(status);
        reserveDao.updateReserve(reserve);
    }



    private Room findAvailableRoom(String roomType, LocalDate checkIn, LocalDate checkOut) {
        List<Room> candidates = roomDao.getAll().stream()
                .filter(r -> r.getType().equals(roomType))
                .collect(Collectors.toList());

        System.out.printf("Searching availability for %s from %s to %s%n", roomType, checkIn, checkOut);

        for (Room room : candidates) {
            List<Reserve> reservations = reserveDao.getReservationsByRoomId(room.getId());


            // check if not overlapping dates exist
            boolean overlaps = reservations.stream().anyMatch(res ->
                    checkIn.isBefore(res.getCheckOut()) &&
                            checkOut.isAfter(res.getCheckIn())
            );


            if (!overlaps) {
                return room;
            }
        }
        return null;
    }



    public boolean cancelReservation(Long reserveId, Long userId) {
        try {
            // Get the reservation
            Reserve reserve = reserveDao.getReserveById(reserveId);

            // Check if reservation exists and belongs to the user
            if (reserve == null || !reserve.getUser().getId().equals(userId)) {
                return false;
            }

            LocalDate currentDate = LocalDate.now();
            if (reserve.getCheckIn().isBefore(currentDate)){
                // it won't cancel the reserve if the checkin is in the past
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

    public List<Reserve> findReserveByRoomId(Long id){
        return reserveDao.getReservationsByRoomId(id);
    }

    public Reserve findReserveById(Long id){
        return reserveDao.getReserveById(id);
    }

    public List<Reserve> getAllReservations() {
        return reserveDao.findAllWithFk();

    }

    public void updateReservation(Reserve reserve) {
        reserveDao.updateReserve(reserve);
    }
    public void deleteReservation(Long id) {
        reserveDao.deleteReserve(id);
    }

    public void deleteReservationByAdmin(Long id){

        //find  reserve by id
        Reserve reserve = reserveDao.getReserveById(id);

        if (reserve == null) {
            System.out.println("reservation not found.");
            return;
        }

        // find payment associated to the reserve id
        Payment payment = paymentDao.findPaymentByReserveId(id);

        // if payment exist eliminate payment first
        if (payment != null) {
            paymentDao.deletePayment(payment.getId()); // use the payment id
            System.out.println("payment eliminated successfully.");
        }

        // delete reserve
        reserveDao.deleteReserve(id);
        System.out.println("reservation eliminated successfully.");
    }

    public Reserve getReservationById(Long id) {
        return reserveDao.getReserveById(id);
    }
}

