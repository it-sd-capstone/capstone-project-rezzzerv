<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="daos.RoomDao" %>
<%@ page import="model.rooms.Room" %>
<%@ page import="model.users.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!-- show user session -->
<p>show: User object = <%= user %></p>

<!-- show user data -->
<p>show: User email  = <%= user.getEmail() %></p>
<p>show: User name   = <%= user.getName() %> <%= user.getLastName() %></p>

<%
    // Maps to store room data
    Map<String, Integer> roomInventory = new HashMap<>();
    Map<String, Double> roomPrices = new HashMap<>();
    Map<String, String> roomDescriptions = new HashMap<>();

    try {
        // Get room data from database
        RoomDao roomDao = new RoomDao();

        // Get room types and their prices
        List<Room> roomTypes = roomDao.getAllRoomTypes();

        // Get room descriptions
        roomDescriptions = roomDao.getAllRoomDescriptions();

        for (Room room : roomTypes) {
            String typeName = room.getType();
            double price = room.getPrice();

            // Store price in the map
            roomPrices.put(typeName, price);

            // Count available rooms of this type
            int availableCount = roomDao.countAvailableRoomsByType(typeName);
            roomInventory.put(typeName, availableCount);
        }
    } catch (Exception e) {
        // If database access fails, use fallback values
        System.err.println("Error accessing database: " + e.getMessage());
        e.printStackTrace();

        // Fallback values
        roomInventory.put("Basic", 18);
        roomInventory.put("Premium", 12);
        roomInventory.put("Presidential", 4);

        roomPrices.put("Basic", 139.59);
        roomPrices.put("Premium", 219.59);
        roomPrices.put("Presidential", 499.59);

        roomDescriptions.put("Basic", "Perfect for solo travelers or couples");
        roomDescriptions.put("Premium", "Spacious room with premium amenities");
        roomDescriptions.put("Presidential", "Luxury suite with exclusive features");
    }

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

    // Check for error message
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReZZZerv - Book Your Stay</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/booking.css">
    <link rel="stylesheet" href="css/dropdown.css">
</head>
<body<% if (session.getAttribute("user") != null) { %> data-user-id="<%= ((User)session.getAttribute("user")).getId() %>"<% } %>>
<header>
    <nav>
        <div class="logo"><a href="index.jsp">ReZZZerv</a></div>
        <ul class="nav-main">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="rooms.jsp">Rooms</a></li>
            <li><a href="booking.jsp" class="active">Book Now</a></li>
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
                    <a href="logout">Logout</a>
                </div>
            </li>
            <% } %>
        </ul>
    </nav>
</header>

<main>
    <section class="page-banner">
        <h1>Book Your Stay</h1>
        <p>Reserve your perfect room today</p>
    </section>

    <section class="booking-container">
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="error-message">
            <%= errorMessage %>
        </div>
        <% } %>

        <div class="booking-form">
            <form action="processReservation" method="post" id="bookingForm">
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
                    <label>Select Room Type:</label>
                    <input type="hidden" id="roomType" name="roomType" value="">
                    <div class="room-options">
                        <div class="room-option" data-room-type="Basic" onclick="selectRoom('Basic')">
                            <h3>Basic Room</h3>
                            <div class="room-price">$<%= String.format("%.2f", roomPrices.get("Basic")) %>/night</div>
                            <div class="room-availability">
                                rooms available: <span id="countBasic"><%= roomInventory.get("Basic") %></span>
                            </div>
                            <p><%= roomDescriptions.get("Basic") %></p>
                        </div>

                        <div class="room-option" data-room-type="Premium" onclick="selectRoom('Premium')">
                            <h3>Premium Room</h3>
                            <div class="room-price">$<%= String.format("%.2f", roomPrices.get("Premium")) %>/night</div>
                            <div class="room-availability">
                                rooms available: <span id="countPremium"><%= roomInventory.get("Premium") %></span>
                            </div>
                            <p><%= roomDescriptions.get("Premium") %></p>
                        </div>

                        <div class="room-option" data-room-type="Presidential" onclick="selectRoom('Presidential')">
                            <h3>Presidential Suite</h3>
                            <div class="room-price">$<%= String.format("%.2f", roomPrices.get("Presidential")) %>/night</div>
                            <div class="room-availability">
                                rooms available: <span id="countPresidential"><%= roomInventory.get("Presidential") %></span>
                            </div>
                            <p><%= roomDescriptions.get("Presidential") %></p>
                        </div>
                    </div>
                </div>

                <div class="booking-summary" id="bookingSummary">
                    <h3>Booking Summary</h3>
                    <p><strong>Check-in:</strong> <span id="summaryCheckIn"></span></p>
                    <p><strong>Check-out:</strong> <span id="summaryCheckOut"></span></p>
                    <p><strong>Room Type:</strong> <span id="summaryRoomType"></span></p>
                    <p><strong>Nights:</strong> <span id="summaryNights"></span></p>
                    <div class="booking-total">
                        Total: $<span id="summaryTotal"></span>
                    </div>
                </div>

                <button type="submit" class="btn book-btn">Save and Proceed to Payment</button>
            </form>
        </div>
    </section>
</main>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<!-- Add room prices as data attributes for JavaScript -->
<div id="roomPrices"
     data-basic-price="<%= String.format("%.2f", roomPrices.get("Basic")) %>"
     data-premium-price="<%= String.format("%.2f", roomPrices.get("Premium")) %>"
     data-presidential-price="<%= String.format("%.2f", roomPrices.get("Presidential")) %>"></div>


<script src="js/booking.js"></script>
<script src="js/RoomCount.js"></script>
<script src="js/main.js"></script>
<% if (session.getAttribute("user") != null) { %>
<script src="js/sessionMonitor.js"></script>
<% } %>
</body>
</html>