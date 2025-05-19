package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.users.User;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            // Get the user before invalidating the session
            User user = (User) session.getAttribute("user");

            if (user != null) {
                // Set cookies to track logout
                Cookie logoutCookie = new Cookie("lastLogout", String.valueOf(System.currentTimeMillis()));
                logoutCookie.setPath("/");
                logoutCookie.setMaxAge(3600); // 1 hour
                response.addCookie(logoutCookie);

                Cookie userCookie = new Cookie("logoutUserId", user.getId().toString());
                userCookie.setPath("/");
                userCookie.setMaxAge(3600); // 1 hour
                response.addCookie(userCookie);
            }

            // Invalidate the session
            session.invalidate();
        }

        // Forward to the logout JSP page to show the logout message
        request.getRequestDispatcher("/logout.jsp").forward(request, response);
    }
}
