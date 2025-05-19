<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.users.User" %>
<%@ page import="model.reserve.Reserve" %>
<%@ page import="model.rooms.Room" %>
<%@ page import="model.payment.Payment" %>
<%@ page import="daos.ReserveDao" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.util.Locale" %>
<%
    // Get the current user from session
    User currentUser = (User) session.getAttribute("user");

    // Variables to store data
    String roomType = null;
    Integer roomNumber = null;
    Long nights = null;
    Double totalPrice = null;
    String checkInFormatted = null;
    String checkOutFormatted = null;
    String guestName = null;
    String guestEmail = null;
    Long reservationId = null;

    // Get the Payment object from session
    Payment payment = (Payment) session.getAttribute("payment");
    Reserve reservation = null;

    if (payment != null) {
        // Get the reservation from the payment
        ReserveDao reserveDao = new ReserveDao();
        reservation = reserveDao.getReserveById(payment.getReserve().getId());

        if (reservation != null) {
            // Get reservation ID
            reservationId = reservation.getId();

            // Get room information
            Room room = reservation.getRoom();
            if (room != null) {
                roomType = room.getType();
                roomNumber = room.getRoomNumber();

                // Get check-in and check-out dates
                LocalDate checkIn = reservation.getCheckIn();
                LocalDate checkOut = reservation.getCheckOut();

                if (checkIn != null && checkOut != null) {
                    // Format dates
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
                    checkInFormatted = checkIn.format(formatter);
                    checkOutFormatted = checkOut.format(formatter);

                    // Calculate number of nights
                    nights = ChronoUnit.DAYS.between(checkIn, checkOut);

                    // Get total price from payment
                    totalPrice = payment.getAmount();
                }
            }

            // Get guest information
            User user = reservation.getUser();
            if (user != null) {
                guestName = user.getName() + " " + user.getLastName();
                guestEmail = user.getEmail();
            }
        }
    }

    // If we couldn't get the data from the payment/reservation, fall back to session attributes
    if (roomType == null) {
        roomType = (String) session.getAttribute("roomType");
    }

    if (roomNumber == null) {
        roomNumber = (Integer) session.getAttribute("roomNumber");
    }

    if (nights == null) {
        nights = (Long) session.getAttribute("nights");
    }

    if (totalPrice == null) {
        totalPrice = (Double) session.getAttribute("totalPrice");
    }

    // If we still don't have guest information, use the current user
    if (guestName == null && currentUser != null) {
        guestName = currentUser.getName() + " " + currentUser.getLastName();
        guestEmail = currentUser.getEmail();
    }

    // Ensure we have valid values for calculations
    if (totalPrice == null) totalPrice = 0.0;
    if (nights == null) nights = 1L;

    // Calculate taxes and total
    double taxesAndFees = totalPrice * 0.15;
    double grandTotal = totalPrice + taxesAndFees;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReZZZerv - Reservation Confirmation</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/reserveConfirmation.css">
    <link rel="stylesheet" href="css/dropdown.css">
</head>
<body<% if (session.getAttribute("user") != null) { %> data-user-id="<%= ((User)session.getAttribute("user")).getId() %>"<% } %>>
<header>
    <nav>
        <div class="logo"><a href="index.jsp">ReZZZerv</a></div>
        <ul class="nav-main">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="rooms.jsp">Rooms</a></li>
            <li><a href="booking.jsp">Book Now</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <%@ include file="/WEB-INF/fragments/nav.jspf" %>
        </ul>
        <ul class="nav-auth">
            <%
                if (currentUser == null) {
            %>
            <li><a href="login.jsp" class="login-link">Login</a></li>
            <li><a href="register.jsp" class="register-link">Register</a></li>
            <% } else { %>
            <li class="dropdown">
                <a href="#" class="user-name"><%= currentUser.getName() %></a>
                <div class="dropdown-content">
                    <a href="myaccount.jsp">My Account</a>
                    <a href="logout">Logout</a>
                </div>
            </li>
            <% } %>
        </ul>
    </nav>
</header>

<main>
    <section class="page-banner">
        <h1>Reservation Confirmed</h1>
        <p>Thank you for choosing ReZZZerv</p>
    </section>
    <div class="confirmation-container">
        <div class="confirmation-header">
            <h2>Your Reservation is Confirmed!</h2>
            <p>A confirmation email has been sent to your registered email address.</p>
        </div>
        <div class="confirmation-details">
            <div class="detail-group">
                <h3>Reservation Details</h3>
                <% if (reservationId != null) { %>
                <p><strong>Confirmation Number:</strong> #<%= reservationId %></p>
                <% } else { %>
                <p><strong>Confirmation Number:</strong> Your confirmation number will be sent via email</p>
                <% } %>

                <% if (checkInFormatted != null && checkOutFormatted != null) { %>
                <p><strong>Check-in:</strong> <%= checkInFormatted %></p>
                <p><strong>Check-out:</strong> <%= checkOutFormatted %></p>
                <% } %>
                <p><strong>Stay Duration:</strong> <%= nights %> night<%= nights > 1 ? "s" : "" %></p>
            </div>
            <div class="detail-group">
                <h3>Room Information</h3>
                <p><strong>Room Type:</strong> <%= roomType != null ? roomType : "Standard Room" %></p>
                <p><strong>Room Number:</strong> <%= roomNumber != null ? roomNumber : "To be assigned" %></p>
            </div>
        </div>
        <div class="detail-group">
            <h3>Guest Information</h3>
            <p><strong>Name:</strong> <%= guestName != null ? guestName : "Guest" %></p>
            <p><strong>Email:</strong> <%= guestEmail != null ? guestEmail : "Not provided" %></p>
        </div>
        <div class="confirmation-total">
            <p>Room Charge: $<%= String.format("%.2f", totalPrice) %></p>
            <p>Taxes & Fees: $<%= String.format("%.2f", taxesAndFees) %></p>
            <p class="total-amount">Total Paid: $<%= String.format("%.2f", grandTotal) %></p>
        </div>
        <div class="confirmation-actions">
            <a href="index.jsp" class="btn-primary">Return to Home</a>
            <a href="booking.jsp" class="btn-secondary">Book Another Room</a>
        </div>
    </div>
</main>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script src="js/main.js"></script>
<% if (session.getAttribute("user") != null) { %>
<script src="js/sessionMonitor.js"></script>
<% } %>
</body>
</html>
