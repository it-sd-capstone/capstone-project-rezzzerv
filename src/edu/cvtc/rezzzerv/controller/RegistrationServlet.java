package edu.cvtc.rezzzerv.controller;

import edu.cvtc.rezzzerv.model.users.Customer;
import edu.cvtc.rezzzerv.service.UserService;
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


    public void doGet(HttpServletRequest request, HttpServletResponse response){

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        if (!password.equals(confirmPassword)){
            response.sendRedirect("index.html");
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

        // after creating the user redirect to login page
        response.sendRedirect("login.html");

    }
}
