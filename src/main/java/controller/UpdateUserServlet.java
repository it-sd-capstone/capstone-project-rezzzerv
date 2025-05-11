package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.users.Administrator;
import model.users.Customer;
import model.users.User;
import service.UserService;

import java.io.IOException;

@WebServlet("/updateUser")
public class UpdateUserServlet extends HttpServlet {
  private final UserService userService = new UserService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {

    Long   id            = Long.parseLong(req.getParameter("userId"));
    String firstName     = req.getParameter("firstName");
    String lastName      = req.getParameter("lastName");
    String phone         = req.getParameter("userPhone");
    String email         = req.getParameter("userEmail");
    String password      = req.getParameter("userPassword");
    String userTypeParam = req.getParameter("userType");

    User user = "Administrator".equalsIgnoreCase(userTypeParam) ? new Administrator() : new Customer();

    user.setId(id);
    user.setName(firstName);
    user.setLastName(lastName);
    user.setPhone(phone);
    user.setEmail(email);
    user.setPassword(password);

    try {
      userService.updateUser(user);
      req.getSession().setAttribute("flash", "User updated successfully.");
    } catch (Exception e) {
      req.getSession().setAttribute("flash_error", "Error updating user.");
    }

    resp.sendRedirect(req.getContextPath() + "/admin?section=users");
  }
}
