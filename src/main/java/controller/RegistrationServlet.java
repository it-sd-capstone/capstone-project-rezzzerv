package controller;

import model.users.Customer;
import service.UserService;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init(){
        userService = new UserService();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response){

    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        if (!password.equals(confirmPassword)){
            response.sendRedirect("index.jsp");
            return;
        }

        Customer customer = new Customer();
        customer.setName(name);
        customer.setLastName(lastName);
        customer.setEmail(email);
        customer.setPhone(phone);
        customer.setPassword(password);

        //save user created
        userService.registerUser(customer);

        // After successful registration, forward to success page
        try {
            request.getRequestDispatcher("success.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp");
        }

    }
}
