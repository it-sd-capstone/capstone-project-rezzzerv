package controller;

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.ServletException;
import model.users.User;
import service.UserService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet{

    private UserService userService;

    public void init(){
        userService = new UserService();
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) {


    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userService.userLogin(email, password);

            //save user in session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            response.sendRedirect("index.jsp");
        } catch (RuntimeException e) {
            request.setAttribute("error", "Email or Password Invalid");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

    }
}
