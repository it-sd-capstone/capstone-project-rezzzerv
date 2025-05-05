package controller;

import service.ReservationService;
import model.rooms.Room;
import model.reserve.Reserve;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet(urlPatterns = {"/processReservation", "/cancelReservation"})
public class ReserveServlet extends HttpServlet {

    private ReservationService reservationService;

    @Override
    public void init() {
        reservationService = new ReservationService();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/cancelReservation".equals(path)) {
            handleCancellation(request, response);
        } else {
            // Default GET behavior or show form
            response.sendRedirect("booking.jsp");
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        // checking to see if session in working with the user id
        System.out.println("debug: incoming session userId = " + session.getAttribute("userId"));

        // Check if user is logged in
        if (userId == null) {
            // Redirect to login page if not logged in
            session.setAttribute("redirectAfterLogin", "booking.jsp");
            request.setAttribute("errorMessage", "Please log in to complete your reservation");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Get form parameters
            String checkInStr = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");
            //int guests = Integer.parseInt(request.getParameter("guests"));
            String roomType = request.getParameter("roomType");

            // Parse dates
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate checkInDate = LocalDate.parse(checkInStr, formatter);
            LocalDate checkOutDate = LocalDate.parse(checkOutStr, formatter);

            // Create reservation
            Reserve reserve = reservationService.createReservation(userId, roomType, checkInDate, checkOutDate);

            // Calculate nights and total price
            long nights = reservationService.calculateNights(checkInDate, checkOutDate);
            double totalPrice = reservationService.calculateTotalPrice(reserve.getRoom(), nights);

            // Store reservation info in session for payment page
            session.setAttribute("reserve", reserve);
            session.setAttribute("roomNumber", reserve.getRoom().getRoomNumber());
            session.setAttribute("roomType", roomType);
            session.setAttribute("nights", nights);
            session.setAttribute("totalPrice", totalPrice);

            // Redirect to payment page
            response.sendRedirect("payment.jsp");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format");
            request.getRequestDispatcher("booking.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("booking.jsp").forward(request, response);
        }
    }

    private void handleCancellation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        // Check if user is logged in
        if (userId == null) {
            session.setAttribute("errorMessage", "Please log in to cancel your reservation");
            response.sendRedirect("login.jsp");
            return;
        }

        // Get reservation ID from request
        String reserveIdStr = request.getParameter("id");
        if (reserveIdStr == null || reserveIdStr.isEmpty()) {
            session.setAttribute("errorMessage", "Invalid reservation ID");
            response.sendRedirect("myaccount.jsp");
            return;
        }

        try {
            Long reserveId = Long.parseLong(reserveIdStr);

            // Cancel the reservation
            boolean success = reservationService.cancelReservation(reserveId, userId);

            if (success) {
                session.setAttribute("successMessage", "Reservation #" + reserveId + " has been successfully cancelled");
            } else {
                session.setAttribute("errorMessage", "Failed to cancel reservation. You may not have permission or the reservation doesn't exist.");
            }

            response.sendRedirect("myaccount.jsp");
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid reservation ID format");
            response.sendRedirect("myaccount.jsp");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect("myaccount.jsp");
        }
    }
}
