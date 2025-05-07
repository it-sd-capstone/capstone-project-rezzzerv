package controller;

import jakarta.servlet.ServletException;
import model.rooms.Room;
import service.RoomService;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.users.User;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
  private final RoomService roomService = new RoomService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    User user = (User) req.getSession(false).getAttribute("user");
    if (user == null || !user.isAdmin()) {
      resp.sendError(HttpServletResponse.SC_FORBIDDEN);
      return;
    }

    String flash = (String) req.getSession().getAttribute("flash");
    if (flash != null) {
      req.setAttribute("flash", flash);
      req.getSession().removeAttribute("flash");
    }

    try {

      List<Room> rooms = roomService.getAllRooms();

      req.setAttribute("rooms", rooms);

      req.getRequestDispatcher("admin.jsp")
              .forward(req, resp);

    } catch (SQLException e) {
      throw new ServletException("Unable to load rooms", e);
    }
  }
}

