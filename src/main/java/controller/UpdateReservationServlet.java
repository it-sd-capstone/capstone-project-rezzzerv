package controller;

import daos.RoomDao;
import daos.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.reserve.Reserve;
import service.ReservationService;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/updateReservation")
public class UpdateReservationServlet extends HttpServlet {
  private final ReservationService svc = new ReservationService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {
    Long id = Long.parseLong(req.getParameter("reservationId"));
    try {
      // 1) Load existing reservation (with its User and Room)
      Reserve r = svc.getReservationById(id);

      // 2) Overwrite editable fields
      r.setStatus(req.getParameter("status"));
      r.setCheckIn(LocalDate.parse(req.getParameter("checkin")));
      r.setCheckOut(LocalDate.parse(req.getParameter("checkout")));

      // 3) Reload User and Room so they're never null
      Long userId = Long.parseLong(req.getParameter("userId"));
      Long roomId = Long.parseLong(req.getParameter("roomId"));
      r.setUser(new UserDao().getUserById(userId));
      r.setRoom(new RoomDao().getRoomById(roomId));

      // 4) Persist update
      svc.updateReservation(r);
      req.getSession().setAttribute("flash", "Reservation updated.");
    } catch (Exception e) {
      req.getSession().setAttribute("flash_error", "Error updating reservation.");
    }

    // 5) Redirect back to the Reservations tab
    resp.sendRedirect("admin?section=reservations");
  }
}