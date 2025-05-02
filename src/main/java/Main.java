import daos.ReserveDao;
import daos.RoomDao;
import daos.UserDao;
import model.reserve.Reserve;
import model.rooms.Room;
import model.rooms.RoomConstruction;
import model.users.Administrator;
import model.users.Customer;
import model.users.User;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
      //System.out.println("Hello, world! Server would start here.");

       //Testing CRUD for User

        UserDao userDao = new UserDao();
        RoomDao roomDao = new RoomDao();
        ReserveDao reserveDao = new ReserveDao();
        Scanner sc = new Scanner(System.in);
        boolean exit = false;

        while (!exit){
            System.out.println("\n=== Hotel CRUD Test ===");
            System.out.println("1. Register Customer");
            System.out.println("2. List all Users:");
            System.out.println("3. Get user by Id");
            System.out.println("4. update user");
            System.out.println("5. Delete user");
            System.out.println("6. search  user by email");
            // testing crud room
            System.out.println("7. create a Room");
            System.out.println("8. List of Rooms");
            System.out.println("9. Get room by id");
            System.out.println("10. Eliminate room by id");
            System.out.println("11. Update room by id");

            //testing reserveDao

            System.out.println("12. Create new reserve");
            System.out.println("13. List reserves");
            System.out.println("14. Get reserve by id");
            System.out.println("15. Update reserve");
            System.out.println("16. Eliminate reserve");
            System.out.println("17. get reserve by user id");

            System.out.print("Choose an option: ");

            int option = sc.nextInt();
            sc.nextLine();

            switch (option){
                case 1:
                    System.out.print("Name: ");
                    String name = sc.nextLine();
                    System.out.print("Last Name: ");
                    String last = sc.nextLine();
                    System.out.print("Phone: ");
                    String phone = sc.nextLine();
                    System.out.print("Email: ");
                    String email = sc.nextLine();
                    System.out.print("Password: ");
                    String pwd = sc.nextLine();
                    Customer cust = new Customer(null, name, last, phone, email, pwd, null);
                    userDao.insertUser(cust);
                    System.out.println("Customer registered.");
                    break;
                case 2:
                    System.out.println(userDao.getAllUsers());
                    break;
                case 3:
                    System.out.println("insert the user id you looking for");
                    Long Id = sc.nextLong();
                    System.out.println(userDao.getUserById(Id));
                    break;
                case 4:
                    System.out.println("insert the id of user to update");
                    Long id = Long.parseLong(sc.nextLine());
                    System.out.println("insert user new name");
                    String nameUser = sc.nextLine();
                    System.out.println("insert new last name");
                    String lastName = sc.nextLine();
                    System.out.println("insert new Phone");
                    String phoneUser = sc.nextLine();
                    System.out.println("insert new Email");
                    String emailUser = sc.nextLine();
                    System.out.println("insert new password");
                    String psw = sc.nextLine();
                    System.out.println("insert type of User( Customer or Administrator");
                    String userType = sc.nextLine();

                    User userToUpdate = null;

                    if (userType.equalsIgnoreCase("Administrator")) {
                        userToUpdate = new Administrator();
                    } else if (userType.equalsIgnoreCase("Customer")) {
                        userToUpdate = new Customer();
                    }

                    if (userToUpdate != null) {
                        userToUpdate.setId(id);
                        userToUpdate.setName(nameUser);
                        userToUpdate.setLastName(lastName);
                        userToUpdate.setPhone(phoneUser);
                        userToUpdate.setEmail(emailUser);
                        userToUpdate.setPassword(psw);
                        userDao.updateUser(userToUpdate);
                        System.out.println("User updated successfully.");
                    } else {
                        System.out.println("Invalid user type. Please enter 'Customer' or 'Administrator'.");
                    }
                    break;
                case 5:
                    System.out.println("insert Id of user to delete");
                    Long idToDelete = Long.parseLong(sc.nextLine());
                    User userToDelete = userDao.getUserById(idToDelete);
                    if (userToDelete != null) {
                        userDao.deleteUser(idToDelete);
                        System.out.println("User eliminated");
                    } else {
                        System.out.println("User with ID " + idToDelete + " not found.");
                    }
                    break;
                case 6:
                    System.out.println("Insert user email to search:");
                    String emailInput = sc.nextLine();

                    User user3 = userDao.findByEmail(emailInput);
                    if (user3 != null) {
                        System.out.println("User found:");
                        System.out.println("ID: " + user3.getId());
                        System.out.println("Name: " + user3.getName());
                        System.out.println("Email: " + user3.getEmail());
                        System.out.println("User Type: " + (user3 instanceof Administrator ? "Administrator" : "Customer"));
                    } else {
                        System.out.println("No user found with that email.");
                    }
                    break;
                case 7:
                    System.out.println("insert Room Number");
                    int roomNumber = sc.nextInt();
                    sc.nextLine();

                    System.out.println("insert Room type: example Basic, Premium, Presidential");
                    String roomType = sc.nextLine();

                    System.out.println("Room will be available? (true/false)");
                    boolean available = sc.nextBoolean();
                    sc.nextLine();

                    System.out.println("insert Room price (example. 150.00):");
                    double price = sc.nextDouble();
                    sc.nextLine();

                    // pass values to room construction
                    Room room = RoomConstruction.createRoom(roomType, null, roomNumber, available, price);
                    roomDao.insertRoom(room);
                    break;
                case 8:
                    System.out.println("Room List....");
                    System.out.println(roomDao.getAll());
                    break;
                case 9:
                    System.out.println("insert Id of the Room to look For");
                    Long roomid = Long.parseLong(sc.nextLine());
                    System.out.println(roomDao.getRoomById(roomid));
                    break;
                case 10:
                    System.out.println("insert room id to Eliminate");
                    Long roomIdToDelete = Long.parseLong(sc.nextLine());
                    Room roomToDelete = roomDao.getRoomById(roomIdToDelete);

                    if (roomToDelete != null){
                        roomDao.deleteRoom(roomIdToDelete);
                        System.out.println("Room eliminated =" + roomIdToDelete);
                    }else {
                        System.out.println("room with id = " + roomIdToDelete + " was not found");
                    }
                    break;
                case 11:
                    System.out.println("Insert Room ID to Update");
                    Long roomIdUpdate = Long.parseLong(sc.nextLine());
                    Room roomToUpdate = roomDao.getRoomById(roomIdUpdate);

                    if (roomToUpdate == null) {
                        System.out.println("Room not found.");
                        break;
                    }

                    System.out.println("Current room info: " + roomToUpdate);

                    System.out.println("Enter new room number:");
                    int newNumber = sc.nextInt();

                    System.out.println("set Room availability (true/false)");
                    boolean roomAvailable = sc.nextBoolean();
                    sc.nextLine();

                    System.out.println("Enter new type (Basic, Premium, or Presidential)");
                    String newType = sc.nextLine();

                    // new price
                    System.out.println("Enter new price (ej. 220.50):");
                    double newPrice = sc.nextDouble();
                    sc.nextLine();

                    // update room
                    Room updatedRoom = RoomConstruction.createRoom(
                            newType,
                            roomToUpdate.getId(),
                            newNumber,
                            roomAvailable,
                            newPrice
                    );

                    roomDao.updateRoom(updatedRoom);
                    System.out.println("Room updated successfully.");
                    System.out.println("New room info: " + updatedRoom);
                    break;
                case 12:
                    System.out.println("insert reserve status ");
                    String status = sc.nextLine();

                    // prompt for dates
                    System.out.println("insert CheckIn date (yyyy-MM-dd)");
                    String checkInString = sc.nextLine();
                    System.out.println("insert checkOut (yyyy-MM-dd)");
                    String checkOutString = sc.nextLine();

                    // convert dates string into Date format
                    LocalDate checkIn = LocalDate.parse(checkInString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    LocalDate checkOut = LocalDate.parse(checkOutString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

                    // prompt for user id, this user must exist
                    System.out.println("insert user Id to add to the reserve");
                    Long userIdToAdd = Long.parseLong(sc.nextLine());
                    User user = userDao.getUserById(userIdToAdd);

                    // prompt for room id, this room must exist
                    System.out.println("insert room Id to add to the reserve");
                    Long roomIdToAdd = Long.parseLong(sc.nextLine());
                    Room room4 = roomDao.getRoomById(roomIdToAdd);

                    // create and save the reserve
                    if (user != null && room4 != null) {
                        Reserve reserve = new Reserve();
                        reserve.setStatus(status);
                        reserve.setCheckIn(checkIn);
                        reserve.setCheckOut(checkOut);
                        reserve.setUser(user);
                        reserve.setRoom(room4);

                        reserveDao.insertReserve(reserve);
                        System.out.println("Reserve created successfully with ID: " + reserve.getId());
                    } else {
                        System.out.println("Error creating reserve. User or Room not found.");
                    }
                    break;
                case 13:
                    System.out.println("--------Reserve List-------");
                    System.out.println(reserveDao.getAll());
                    break;
                case 14:
                    System.out.println("please insert the reservation Id to check");
                    Long reserveId = Long.parseLong(sc.nextLine());
                    System.out.println(reserveDao.getReserveById(reserveId));
                    break;
                case 15:
                    System.out.println("Please insert the reservation ID to update");
                    Long reserveIdToUpdate = Long.parseLong(sc.nextLine());
                    Reserve reserveUpdate = reserveDao.getReserveById(reserveIdToUpdate);

                    // the reserve exist?
                    if (reserveUpdate == null) {
                        System.out.println("Reserve with ID = " + reserveIdToUpdate + " was not found");
                    } else {
                        // show current reserve info
                        System.out.println("Current reserve info for ID = " + reserveIdToUpdate + " is: " + reserveUpdate);
                        System.out.println("\n");

                        // update status
                        System.out.println("Insert new reserve status (Current = " + reserveUpdate.getStatus() + ")");
                        String newStatus = sc.nextLine();
                        reserveUpdate.setStatus(newStatus);

                        // update check-in
                        System.out.println("Insert new check-in date (Current = " + reserveUpdate.getCheckIn() + ")");
                        String newCheckInString = sc.nextLine();

                        // turn string input to LocalDate
                        LocalDate newCheckIn = null;
                        try {
                            newCheckIn = LocalDate.parse(newCheckInString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                            reserveUpdate.setCheckIn(newCheckIn);
                        } catch (Exception e) {
                            System.out.println("Error parsing CheckIn date. Please enter a valid date in format yyyy-MM-dd");
                            break;
                        }

                        // update check-out
                        System.out.println("Insert new check-out date (Current = " + reserveUpdate.getCheckOut() + ")");
                        String newCheckOutString = sc.nextLine();

                        // turn string input into LocalDate
                        LocalDate newCheckOut = null;
                        try {
                            newCheckOut = LocalDate.parse(newCheckOutString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                            reserveUpdate.setCheckOut(newCheckOut);
                        } catch (Exception e) {
                            System.out.println("Error parsing CheckOut date. Please enter a valid date in format yyyy-MM-dd");
                            break;
                        }

                        // update with the new room
                        System.out.println("Insert new room ID (Current = " + reserveUpdate.getRoom().getId() + ")");
                        Long newRoomID = Long.parseLong(sc.nextLine());
                        Room newRoom = roomDao.getRoomById(newRoomID);
                        if (newRoom != null) {
                            reserveUpdate.setRoom(newRoom);
                        } else {
                            System.out.println("Room with ID = " + newRoomID + " was not found");
                            break;
                        }

                        // update the reserve
                        reserveDao.updateReserve(reserveUpdate);
                        System.out.println("Reserve updated successfully");
                    }
                    break;
                case 16:
                    System.out.println("insert reserve Id to Eliminate");
                    Long reserveToEliminate = Long.parseLong(sc.nextLine());
                    System.out.println("are you sure you want to eliminate reserve id" + reserveToEliminate + "? yes/no");
                    String confirmation = sc.nextLine();
                    if (confirmation.equalsIgnoreCase("yes")){
                        reserveDao.deleteReserve(reserveToEliminate);
                    } else {
                        System.out.println("delete cancelled");
                    }
                    break;
                case 17:
                    System.out.println("insert the user Id to see his reserve");
                    Long userid = Long.parseLong(sc.nextLine());
                    System.out.println(reserveDao.findReserveByUserId(userid));
                break;
                case 0:
                    exit = true;
                    break;
                default:
                    System.out.println("Invalid option.");
            }
        }

    }

}
