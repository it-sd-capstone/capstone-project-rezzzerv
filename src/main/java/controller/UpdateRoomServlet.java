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

  @WebServlet("/updateRoom")
  public class UpdateRoomServlet extends HttpServlet {
    private final RoomService roomService = new RoomService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {

    Long id         = Long.parseLong(req.getParameter("roomId"));
    int roomNumber  = Integer.parseInt(req.getParameter("roomNumber"));
    String type     = req.getParameter("roomType");
    double price    = Double.parseDouble(req.getParameter("roomPrice"));
    String availParam = req.getParameter("roomAvailable");
    boolean available = "1".equals(availParam);
    Room room = RoomConstruction.createRoom(type, id, roomNumber, available, price);

    try {
      roomService.updateRoom(room);
      req.getSession().setAttribute("flash", "Room “" + roomNumber + "” updated successfully.");
      resp.sendRedirect("admin");
    } catch (SQLException e) {
      throw new ServletException("Error updating room", e);
    }
  }
}


