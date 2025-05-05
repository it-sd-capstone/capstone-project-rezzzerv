package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.payment.Payment;
import model.reserve.Reserve;
import service.PaymentService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/processPayment")
public class PaymentServlet extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() {
        paymentService = new PaymentService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reserve") == null) {
            // there is not reserve, go back to booking
            response.sendRedirect("booking.jsp");
            return;
        }

        // Get form parameters
        //String cardName = request.getParameter("cardName");
        String cardNumber = request.getParameter("cardNumber");
        // String expDate = request.getParameter("expDate");
        //String cvv = request.getParameter("cvv");
        //String billingAddress = request.getParameter("billingAddress");
        //String city = request.getParameter("city");
        //String zipCode = request.getParameter("zipCode");
        //String country = request.getParameter("country");
        String amountStr = request.getParameter("amount");
        String dateStr = request.getParameter("paidDate");

        Long reserveId = ((Reserve) session.getAttribute("reserve")).getId();


        Double amount = Double.parseDouble(amountStr);
        LocalDate paidDate = LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));


        // In a real application, you would:
        // 1. Validate the payment information
        // 2. Process the payment through a payment gateway
        // 3. Update the reservation status in the database

        Payment payment;
        try {
            payment = paymentService.payByReserveId(cardNumber, amount, paidDate, reserveId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        session.setAttribute("payment", payment);

        //once the reserve got paid remove it from session
        session.removeAttribute("reserve");

        response.sendRedirect("reservationConfirmation.jsp");

        // For now, we'll just simulate a successful payment
        //HttpSession session = request.getSession();

        // Get test parameter if it exists
//        String testParam = request.getParameter("test");
//
//        // Forward to the confirmation page
//        if (testParam != null && testParam.equals("true")) {
//            response.sendRedirect("reservationConfirmation.jsp?test=true");
//        } else {
//            response.sendRedirect("reservationConfirmation.jsp");
//        }
    }
}
