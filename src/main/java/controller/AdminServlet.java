package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpSession;
import model.reserve.Reserve;
import model.rooms.Room;
import service.ReservationService;
import service.RoomService;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.users.User;
import service.UserService;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
  private final RoomService roomService = new RoomService();
  private final UserService userService = new UserService();
  private final ReservationService reservationService = new ReservationService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

      HttpSession session = req.getSession();


    User user = (User) req.getSession(false).getAttribute("user");
    if (user == null || !user.isAdmin()) {
      resp.sendError(HttpServletResponse.SC_FORBIDDEN);
      return;
    }

    // flash of success
    String flash = (String) req.getSession().getAttribute("flash");
    if (flash != null) {
      req.setAttribute("flash", flash);
      req.getSession().removeAttribute("flash");
    }

    // flash of error
    String flashError = (String) session.getAttribute("flash_error");
    if (flashError != null) {
      req.setAttribute("flash_error", flashError);
      session.removeAttribute("flash_error");
    }

    try {

      List<Room> rooms = roomService.getAllRooms();
      req.setAttribute("rooms", rooms);

      List<User> users = userService.getAllUsers();
      req.setAttribute("users", users);

      List<Reserve> reservations = reservationService.getAllReservations();
      req.setAttribute("reservations", reservations);

      req.getRequestDispatcher("admin.jsp")
              .forward(req, resp);
    } catch (SQLException e) {
      throw new ServletException("Unable to load tables", e);
    }
  }
}

