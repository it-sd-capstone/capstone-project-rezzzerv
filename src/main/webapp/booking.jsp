<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%
    // This would normally come from database
    // For now, we'll use hardcoded values
    Map<String, Integer> roomInventory = new HashMap<>();
    roomInventory.put("Basic", 18);
    roomInventory.put("Premium", 12);
    roomInventory.put("Presidential", 4);

    Map<String, Double> roomPrices = new HashMap<>();
    roomPrices.put("Basic", 139.59);
    roomPrices.put("Premium", 219.59);
    roomPrices.put("Presidential", 499.59);

    // Get today's date and format it for the date picker min attribute
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String today = dateFormat.format(new Date());

    // Calculate date 1 year from now for max date
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.YEAR, 1);
    String maxDate = dateFormat.format(cal.getTime());

    // Default checkout date (tomorrow)
    cal = Calendar.getInstance();
    cal.add(Calendar.DATE, 1);
    String tomorrow = dateFormat.format(cal.getTime());

    // Make room prices available to JavaScript
    request.setAttribute("basicPrice", roomPrices.get("Basic"));
    request.setAttribute("premiumPrice", roomPrices.get("Premium"));
    request.setAttribute("presidentialPrice", roomPrices.get("Presidential"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Your Stay - ReZZZerv</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/booking.css">
</head>
<body>
<header>
    <nav>
        <div class="logo"><a href="index.html">ReZZZerv</a></div>
        <ul class="nav-main">
            <li><a href="index.html">Home</a></li>
            <li><a href="rooms.html">Rooms</a></li>
            <li><a href="booking.jsp" class="active">Book Now</a></li>
            <li><a href="contact.html">Contact</a></li>
        </ul>
        <ul class="nav-auth">
            <li><a href="login.html" class="login-link">Login</a></li>
            <li><a href="register.html" class="register-link">Register</a></li>
        </ul>
    </nav>
</header>

<main>
    <section class="page-banner">
        <h1>Book Your Stay</h1>
        <p>Reserve your perfect room today</p>
    </section>

    <section class="booking-container">
        <div class="booking-form">
            <form action="processBooking" method="post" id="bookingForm">
                <div class="form-group date-inputs">
                    <div>
                        <label for="checkIn">Check-in Date:</label>
                        <input type="date" id="checkIn" name="checkIn" required
                               min="<%= today %>" max="<%= maxDate %>" value="<%= today %>">
                    </div>
                    <div>
                        <label for="checkOut">Check-out Date:</label>
                        <input type="date" id="checkOut" name="checkOut" required
                               min="<%= tomorrow %>" max="<%= maxDate %>" value="<%= tomorrow %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="guests">Number of Guests:</label>
                    <select id="guests" name="guests" required>
                        <option value="1">1 Guest</option>
                        <option value="2" selected>2 Guests</option>
                        <option value="3">3 Guests</option>
                        <option value="4">4 Guests</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Select Room Type:</label>
                    <input type="hidden" id="roomType" name="roomType" value="">
                    <div class="room-options">
                        <div class="room-option" data-room-type="Basic" onclick="selectRoom('Basic')">
                            <h3>Basic Room</h3>
                            <div class="room-price">$<%= roomPrices.get("Basic") %>/night</div>
                            <div class="room-availability"><%= roomInventory.get("Basic") %> rooms available</div>
                            <p>Perfect for solo travelers or couples</p>
                        </div>

                        <div class="room-option" data-room-type="Premium" onclick="selectRoom('Premium')">
                            <h3>Premium Room</h3>
                            <div class="room-price">$<%= roomPrices.get("Premium") %>/night</div>
                            <div class="room-availability"><%= roomInventory.get("Premium") %> rooms available</div>
                            <p>Spacious room with premium amenities</p>
                        </div>

                        <div class="room-option" data-room-type="Presidential" onclick="selectRoom('Presidential')">
                            <h3>Presidential Suite</h3>
                            <div class="room-price">$<%= roomPrices.get("Presidential") %>/night</div>
                            <div class="room-availability"><%= roomInventory.get("Presidential") %> rooms available</div>
                            <p>Luxury suite with exclusive features</p>
                        </div>
                    </div>
                </div>

                <div class="booking-summary" id="bookingSummary">
                    <h3>Booking Summary</h3>
                    <p><strong>Check-in:</strong> <span id="summaryCheckIn"></span></p>
                    <p><strong>Check-out:</strong> <span id="summaryCheckOut"></span></p>
                    <p><strong>Guests:</strong> <span id="summaryGuests"></span></p>
                    <p><strong>Room Type:</strong> <span id="summaryRoomType"></span></p>
                    <p><strong>Nights:</strong> <span id="summaryNights"></span></p>
                    <div class="booking-total">
                        Total: $<span id="summaryTotal"></span>
                    </div>
                </div>

                <button type="submit" class="booking-btn">Complete Booking</button>
            </form>
        </div>
    </section>
</main>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<!-- Add room prices as data attributes for JavaScript -->
<div id="roomPrices"
     data-basic-price="<%= roomPrices.get("Basic") %>"
     data-premium-price="<%= roomPrices.get("Premium") %>"
     data-presidential-price="<%= roomPrices.get("Presidential") %>">
</div>

<script src="js/booking.js"></script>
</body>
</html>
