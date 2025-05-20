<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.users.User" %>
<%@ page import="model.reserve.Reserve" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Locale" %>
<%
    User user1 = (User) session.getAttribute("user");
    if (user1 == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get data from session
    String roomType = (String) session.getAttribute("roomType");
    Integer roomNumber = (Integer) session.getAttribute("roomNumber");
    Long nights = (Long) session.getAttribute("nights");
    Double totalPrice = (Double) session.getAttribute("totalPrice");

    // Get reserve object from session
    Reserve reserveObj = (Reserve) session.getAttribute("reserve");

    // Initialize formatted date strings
    String checkInFormatted = null;
    String checkOutFormatted = null;
    Long reservationId = null;

    // Extract dates from reserve object if available
    if (reserveObj != null) {
        reservationId = reserveObj.getId();

        // Get check-in and check-out dates
        LocalDate checkIn = reserveObj.getCheckIn();
        LocalDate checkOut = reserveObj.getCheckOut();

        if (checkIn != null && checkOut != null) {
            // Format dates
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
            checkInFormatted = checkIn.format(formatter);
            checkOutFormatted = checkOut.format(formatter);
        }
    }

    // Calculate taxes and total
    double taxesAndFees = totalPrice != null ? totalPrice * 0.15 : 0.0;
    double grandTotal = totalPrice != null ? totalPrice + taxesAndFees : 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReZZZerv - Payment</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/payment.css">
    <link rel="stylesheet" href="css/dropdown.css">
</head>
<body>
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
                // Check if user is logged in
                User currentUser = (User) session.getAttribute("user");
                if (currentUser == null) {
            %>
            <li><a href="login.jsp" class="login-link">Login</a></li>
            <li><a href="register.jsp" class="register-link">Register</a></li>
            <% } else { %>
            <li class="dropdown">
                <a href="#" class="user-name"><%= currentUser.getName() %></a>
                <div class="dropdown-content">
                    <a href="myaccount.jsp">My Account</a>
                    <a href="logout.jsp">Logout</a>
                </div>
            </li>
            <% } %>
        </ul>
    </nav>
</header>

<main>
    <section class="page-banner">
        <h1>Payment</h1>
        <p>Complete your reservation</p>
    </section>
    <div class="payment-container">
        <div class="payment-summary">
            <h2>Reservation Summary</h2>
            <div class="reservation-details">
                <p><strong>Check-in:</strong> <%= checkInFormatted != null ? checkInFormatted : "Not specified" %></p>
                <p><strong>Check-out:</strong> <%= checkOutFormatted != null ? checkOutFormatted : "Not specified" %></p>
                <p><strong>Room Type:</strong> <%= roomType != null ? roomType : "Not specified" %></p>
                <p><strong>Room Number:</strong> <%= roomNumber != null ? roomNumber : "Not assigned" %></p>
                <p><strong>Nights:</strong> <%= nights != null ? nights : "1" %></p>
            </div>
            <div class="price-summary">
                <p><span>Room Rate:</span> $<%= String.format("%.2f", totalPrice) %></p>
                <p><span>Taxes & Fees:</span> $<%= String.format("%.2f", taxesAndFees) %></p>
                <p class="total"><span>Total:</span> $<%= String.format("%.2f", grandTotal) %></p>
            </div>
        </div>
        <div class="payment-form">
            <h2>Payment Information</h2>
            <form id="paymentForm" action="processPayment" method="post">
                <!-- hidden fields -->
                <input type="hidden" name="reserveId" value="<%= reservationId %>" />
                <input type="hidden" name="amount" value="<%= totalPrice %>" />
                <input type="hidden" name="paidDate" value="<%= LocalDate.now().toString() %>" />

                <!-- card number it has to persist in db -->
                <div class="form-group">
                    <label for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber"
                           placeholder="XXXX XXXX XXXX XXXX" required>
                </div>

                <!-- billing info is optional by now -->
                <div class="form-group">
                    <label for="billingAddress">Billing Address</label>
                    <input type="text" id="billingAddress" name="billingAddress" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="city">City</label>
                        <input type="text" id="city" name="city" required>
                    </div>
                    <div class="form-group">
                        <label for="zipCode">Zip Code</label>
                        <input type="text" id="zipCode" name="zipCode" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="country">Country</label>
                    <select id="country" name="country" required>
                        <option value="">Select Country</option>
                        <option value="US">United States</option>
                    </select>
                </div>
                <div class="form-actions">
                    <a href="myaccount.jsp" class="btn-secondary">My Reservations</a>
                    <button type="submit" class="btn-primary">Complete Payment</button>
                </div>
            </form>
        </div>
    </div>
</main>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script src="js/main.js"></script>
<script src="js/validation.js"></script>
</body>
</html>
