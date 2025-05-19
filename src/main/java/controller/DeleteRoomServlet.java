package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

import service.RoomService;

@WebServlet("/deleteRoom")
public class DeleteRoomServlet extends HttpServlet {
  private final RoomService roomService = new RoomService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {

    // read parameters
    String roomNumber = req.getParameter("roomNumber");
    long id = Long.parseLong(req.getParameter("roomId"));

  // new try
    try {
      // call the methods and set it as a boolean
      boolean deleted = roomService.deleteRoom(id);

      // set the right message in session
      if (deleted) {
        req.getSession().setAttribute("flash",
                "Room " + roomNumber + " deleted successfully.");
      } else {
        req.getSession().setAttribute("flash_error",
                "Cannot delete room " + roomNumber
                        + ", because it has active reservations.");
      }

      resp.sendRedirect("admin");
    } catch (SQLException e) {
      throw new ServletException("Error deleting room", e);
    }
  }
}
