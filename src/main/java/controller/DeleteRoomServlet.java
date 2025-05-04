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
    String roomNumber = req.getParameter("roomNumber");
    long id = Long.parseLong(req.getParameter("roomId"));
    try {
      roomService.deleteRoom(id);
      req.getSession().setAttribute("flash", "Room ”"   + roomNumber + "”  deleted successfully.");
      resp.sendRedirect("admin");
    } catch (SQLException e) {
      throw new ServletException("Error deleting room", e);
    }
  }
}
