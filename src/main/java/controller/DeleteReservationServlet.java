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

@WebServlet("/deleteReservation")
public class DeleteReservationServlet extends HttpServlet {
  private final ReservationService svc = new ReservationService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {
    Long id = Long.parseLong(req.getParameter("reservationId"));
    svc.deleteReservation(id);
    req.getSession().setAttribute("flash", "Reservation deleted.");
    resp.sendRedirect("admin?section=reservations");
  }
}

