package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.RoomService;

@WebServlet("/roomCounts")
public class RoomCountServlet extends HttpServlet {

  private RoomService roomService;

  @Override
  public void init() {
    roomService = new RoomService();
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
          throws IOException
  {

    LocalDate in  = LocalDate.parse(req.getParameter("checkIn"));
    LocalDate out = LocalDate.parse(req.getParameter("checkOut"));

    Map<String,Integer> counts = roomService.getAvailableRoomCounts(in, out);

    resp.setContentType("application/json");
    String json = String.format(
            "{\"basic\":%d,\"premium\":%d,\"presidential\":%d}",
            counts.getOrDefault("Basic", 0),
            counts.getOrDefault("Premium", 0),
            counts.getOrDefault("Presidential", 0)
    );
    resp.getWriter().write(json);
  }
}
