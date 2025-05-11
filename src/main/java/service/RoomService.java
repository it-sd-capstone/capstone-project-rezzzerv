package service;

import daos.ReserveDao;
import daos.RoomDao;
import model.reserve.Reserve;
import model.rooms.Room;
import java.sql.SQLException;
import model.rooms.RoomConstruction;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class RoomService {

    private RoomDao roomDao;
    private ReserveDao reserveDao;

    public RoomService() {
        this.roomDao = new RoomDao();
        this.reserveDao = new ReserveDao();
    }

    public Room addRoom(int roomNumber, String type, double price){

        //create the room using the RoomConstruction class
        Room room = RoomConstruction.createRoom(type, null, roomNumber, true, price);
        //add the room to the DB
        roomDao.insertRoom(room);
        return room;
    }

    public List<Room> ListRooms(){
        try {
            return  roomDao.getAll();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


  public List<Room> getAllRooms() throws SQLException {
    return roomDao.getAll();
  }

  public void createRoom(Room room) throws SQLException {
    roomDao.insertRoom(room);
  }

  public void updateRoom(Room room) throws SQLException {
    roomDao.updateRoom(room);
  }

  //original method

//      public void deleteRoom(long id) throws SQLException {
//        roomDao.deleteRoom(id);
//      }


    // new method with condition
    public boolean deleteRoom(Long roomId) throws SQLException {
        // check if there are reserves with hat room
        List<Reserve> reservas = reserveDao.getReservationsByRoomId(roomId);
        if (!reservas.isEmpty()) {
            return false;   // if the room is reserved it wont delete
        }
        // if the room is not used yet then deleteO
        return roomDao.deleteRoom(roomId);
    }

  public Object getTotalRoomCount() {
    return null;
  }

  public Map<String, Long> getAvailableRoomCountByType(LocalDate start, LocalDate end) {
    return null;
  }

  public Object getAvailableRoomCount() {
    return null;
  }
}
