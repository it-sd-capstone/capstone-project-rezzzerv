package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.users.Administrator;
import model.users.Customer;
import model.users.User;
import service.UserService;

import java.io.IOException;

@WebServlet("/createUser")
public class CreateUserServlet extends HttpServlet {
  private final UserService userService = new UserService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {

    String firstName    = req.getParameter("firstName");
    String lastName     = req.getParameter("lastName");
    String phone        = req.getParameter("userPhone");
    String email        = req.getParameter("userEmail");
    String password     = req.getParameter("userPassword");
    String userTypeParam= req.getParameter("userType");

    User user;
    if ("Administrator".equalsIgnoreCase(userTypeParam)) {
      user = new Administrator();
    } else {
      user = new Customer();
    }

    user.setName(firstName);
    user.setLastName(lastName);
    user.setPhone(phone);
    user.setEmail(email);
    user.setPassword(password);

    try {
      userService.registerUser(user);
      req.getSession().setAttribute("flash", "User created successfully.");
    } catch (Exception e) {
      req.getSession().setAttribute("flash_error", "Error creating user.");
    }

    resp.sendRedirect("admin?section=users");
  }
}
