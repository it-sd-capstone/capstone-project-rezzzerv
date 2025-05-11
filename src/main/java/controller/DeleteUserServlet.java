package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.UserService;

import java.io.IOException;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
  private final UserService userService = new UserService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {
    Long id = Long.parseLong(req.getParameter("userId"));

    try {
      userService.deleteUser(id);
      req.getSession().setAttribute("flash", "User deleted.");
    } catch (Exception e) {
      req.getSession().setAttribute("flash_error", "Error deleting user.");
    }

    resp.sendRedirect("admin?section=users");
  }
}