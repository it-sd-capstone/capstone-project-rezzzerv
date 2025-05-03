package service;

import daos.RoomDao;
import model.rooms.Room;
import model.rooms.RoomConstruction;
import java.util.List;

public class RoomService {

    private RoomDao roomDao;

    public RoomService() {
        this.roomDao = new RoomDao();
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
}
