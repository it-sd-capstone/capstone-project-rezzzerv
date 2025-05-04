package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

import service.RoomService;
import model.rooms.Room;
import model.rooms.RoomConstruction;

@WebServlet("/createRoom")
public class CreateRoomServlet extends HttpServlet {
  private final RoomService roomService = new RoomService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {

    String roomNumberStr = req.getParameter("roomNumber");
    String type          = req.getParameter("roomType");
    String availParam    = req.getParameter("roomAvailable");
    String priceStr      = req.getParameter("roomPrice");
    System.out.println("DEBUG: Add-Room availParam = [" + availParam + "]");

    int roomNumber = Integer.parseInt(roomNumberStr);
    double price   = Double.parseDouble(priceStr);
    boolean available = "1".equals(availParam);

    Room room = RoomConstruction.createRoom(type, null, roomNumber, available, price);

    try {
      roomService.createRoom(room);
      req.getSession().setAttribute("flash", "Room “" + room.getRoomNumber() + "” added successfully.");
    } catch (SQLException e) {
      throw new ServletException("Error creating room", e);
    }

    resp.sendRedirect("admin");
  }
}


