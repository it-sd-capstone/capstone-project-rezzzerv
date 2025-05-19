package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.users.User;
import java.io.IOException;

@WebServlet("/checkSession")
public class SessionCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        HttpSession session = request.getSession(false);

        boolean isValid = (session != null);
        boolean isAdmin = false;

        if (isValid) {
            User user = (User) session.getAttribute("user");
            isValid = (user != null);
            isAdmin = (user != null && user.getClass().getSimpleName().equals("Admin"));

            // Check if session has been marked for invalidation
            Boolean sessionInvalidated = (Boolean) session.getAttribute("sessionInvalidated");
            if (sessionInvalidated != null && sessionInvalidated) {
                isValid = false;
            }
        }

        String jsonResponse = "{\"valid\":" + isValid + ",\"isAdmin\":" + isAdmin + "}";
        response.getWriter().write(jsonResponse);
    }
}
