package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import model.reserve.Reserve;
import service.ReservationService;
import service.RoomService;
import model.rooms.Room;
import model.rooms.RoomConstruction;

  @WebServlet("/updateRoom")
  public class UpdateRoomServlet extends HttpServlet {
    private final RoomService roomService = new RoomService();
    private final ReservationService reservationService = new ReservationService();

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

      List<Reserve> reserve = reservationService.findReserveByRoomId(id);

      if (reserve == null || reserve.isEmpty()){
        roomService.updateRoom(room);
        req.getSession().setAttribute("flash", "Room “" + roomNumber + "” updated successfully.");
        resp.sendRedirect("admin");
      }else {
        req.getSession().setAttribute("flash_error", "Room can't be updated while it's reserved.");
        resp.sendRedirect("admin");
      }
    } catch (SQLException e) {
      throw new ServletException("Error updating room", e);
    }
  }
}


