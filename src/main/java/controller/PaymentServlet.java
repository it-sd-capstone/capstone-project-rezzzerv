package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.payment.Payment;
import model.reserve.Reserve;
import model.rooms.Room;
import service.PaymentService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

@WebServlet(urlPatterns = {"/processPayment", "/completePayment"})
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

        if (!luhnCheck(cardNumber)) {
            request.setAttribute("cardError", "Invalid card number");
            request.getRequestDispatcher("payment.jsp").forward(request, response);
            return;
        }

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


    //new doget for pay reservation from Pay bottom in myaccount.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();


        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("myaccount.jsp"); // or an error page
            return;
        }

        Long reserveId;
        try {
            reserveId = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("myaccount.jsp");
            return;
        }

        // search reserve by id
        Reserve reserve = paymentService.getReserveById(reserveId);
        if (reserve == null) {
            response.sendRedirect("myaccount.jsp");
            return;
        }

        Room room = reserve.getRoom();

        // do the math here for now.
        Double roomRate = room.getPrice();
        long nights = ChronoUnit.DAYS.between(reserve.getCheckIn(), reserve.getCheckOut());
        if (nights <= 0) nights = 1;

        Double totalPrice = roomRate * nights;


        // save the reserve and get the attributes
        session.setAttribute("reserve", reserve);
        session.setAttribute("roomType", room.getType());
        session.setAttribute("roomNumber", room.getRoomNumber());
        session.setAttribute("roomPrice", room.getPrice());
        session.setAttribute("nights", nights);
        session.setAttribute("totalPrice", totalPrice);

        //System.out.println(reserve);

        // redirect to payment form
        response.sendRedirect("payment.jsp");
    }

    private static boolean luhnCheck(String ccNum) {
        String digits = ccNum.replaceAll("\\D", "");
        int sum = 0;
        boolean alternate = false;
        for (int i = digits.length() - 1; i >= 0; i--) {
            int d = Character.getNumericValue(digits.charAt(i));
            if (alternate) {
                d *= 2;
                if (d > 9) d -= 9;
            }
            sum += d;
            alternate = !alternate;
        }
        return sum % 10 == 0;
    }

}
