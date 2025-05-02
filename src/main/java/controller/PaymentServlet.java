package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/processPayment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String cardName = request.getParameter("cardName");
        String cardNumber = request.getParameter("cardNumber");
        String expDate = request.getParameter("expDate");
        String cvv = request.getParameter("cvv");
        String billingAddress = request.getParameter("billingAddress");
        String city = request.getParameter("city");
        String zipCode = request.getParameter("zipCode");
        String country = request.getParameter("country");

        // In a real application, you would:
        // 1. Validate the payment information
        // 2. Process the payment through a payment gateway
        // 3. Update the reservation status in the database

        // For now, we'll just simulate a successful payment
        HttpSession session = request.getSession();

        // Get test parameter if it exists
        String testParam = request.getParameter("test");

        // Forward to the confirmation page
        if (testParam != null && testParam.equals("true")) {
            response.sendRedirect("reservationConfirmation.jsp?test=true");
        } else {
            response.sendRedirect("reservationConfirmation.jsp");
        }
    }
}
