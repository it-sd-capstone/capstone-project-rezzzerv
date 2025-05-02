<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if this is a test view
    boolean isTest = "true".equals(request.getParameter("test"));

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

    // If test mode, create dummy data
    if (isTest) {
        // Create simple test data without using model classes
        roomType = "Premium Suite";
        roomNumber = 205;
        nights = 3L;
        totalPrice = 658.77;
        checkInFormatted = "June 15, 2025";
        checkOutFormatted = "June 18, 2025";
        guestName = "John Doe";
        guestEmail = "john.doe@example.com";
        reservationId = 12345L;
    } else {
        // Get data from session
        roomType = (String) session.getAttribute("roomType");
        roomNumber = (Integer) session.getAttribute("roomNumber");
        nights = (Long) session.getAttribute("nights");
        totalPrice = (Double) session.getAttribute("totalPrice");
        checkInFormatted = (String) session.getAttribute("checkInFormatted");
        checkOutFormatted = (String) session.getAttribute("checkOutFormatted");
        guestName = (String) session.getAttribute("guestName");
        guestEmail = (String) session.getAttribute("guestEmail");

        // Try to get reservation ID from reserve object
        Object reserveObj = session.getAttribute("reserve");
        if (reserveObj != null) {
            try {
                reservationId = (Long) reserveObj.getClass().getMethod("getId").invoke(reserveObj);
            } catch (Exception e) {
                // Handle any errors
                System.out.println("<!-- Error getting reservation ID: " + e.getMessage() + " -->");
            }
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
    <title>ReZZZerv - Reservation Confirmation</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/reserveConfirmation.css">
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
        </ul>
        <ul class="nav-auth">
            <li><a href="login.jsp" class="login-link">Login</a></li>
            <li><a href="register.jsp" class="register-link">Register</a></li>
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
                <p><strong>Confirmation Number:</strong> #<%= reservationId %></p>
                <p><strong>Check-in:</strong> <%= checkInFormatted %></p>
                <p><strong>Check-out:</strong> <%= checkOutFormatted %></p>
                <p><strong>Nights:</strong> <%= nights %></p>
            </div>

            <div class="detail-group">
                <h3>Room Information</h3>
                <p><strong>Room Type:</strong> <%= roomType %></p>
                <p><strong>Room Number:</strong> <%= roomNumber %></p>
            </div>
        </div>

        <div class="detail-group">
            <h3>Guest Information</h3>
            <p><strong>Name:</strong> <%= guestName %></p>
            <p><strong>Email:</strong> <%= guestEmail %></p>
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
</body>
</html>
