<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.users.User" %>
<%@ page import="model.reserve.Reserve" %>
<%@ page import="model.rooms.Room" %>
<%@ page import="daos.ReserveDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReZZZerv - My Account</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/styles.css">
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

<div class="container mt-5 mb-5">
    <%
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
        if (user == null) {
            // Redirect to login page if not logged in
            response.sendRedirect("login.jsp");
            return;
        }
        // Get user's reservations
        ReserveDao reserveDao = new ReserveDao();
        List<Reserve> reservations = reserveDao.findReserveByUserId(user.getId());
        // Date formatter
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    %>
    <h1 class="mb-4">My Account</h1>
    <!-- Profile Information Section -->
    <div class="profile-section">
        <h2>Profile Information</h2>
        <div class="row">
            <div class="col-md-6">
                <p><strong>Name:</strong> <%= user.getName() %> <%= user.getLastName() %></p>
                <p><strong>Email:</strong> <%= user.getEmail() %></p>
            </div>
            <div class="col-md-6">
                <p><strong>Phone:</strong> <%= user.getPhone() %></p>
                <p><strong>Account Type:</strong> <%= user.getClass().getSimpleName() %></p>
            </div>
        </div>
    </div>
    <!-- Reservations Section -->
    <h2>My Reservations</h2>
    <% if (reservations.isEmpty()) { %>
    <div class="no-reservations">
        <p>You don't have any reservations yet.</p>
        <a href="booking.jsp" class="btn btn-primary mt-3">Make a Reservation</a>
    </div>
    <% } else { %>
    <div class="row">
        <% for (Reserve reservation : reservations) {
            Room room = reservation.getRoom();
            long nights = ChronoUnit.DAYS.between(reservation.getCheckIn(), reservation.getCheckOut());
            double totalPrice = room.getPrice() * nights;
            String statusClass = "";
            if ("confirmed".equalsIgnoreCase(reservation.getStatus())) {
                statusClass = "status-confirmed";
            } else if ("pending".equalsIgnoreCase(reservation.getStatus())) {
                statusClass = "status-pending";
            } else if ("cancelled".equalsIgnoreCase(reservation.getStatus())) {
                statusClass = "status-cancelled";
            }
        %>
        <div class="col-md-6">
            <div class="card reservation-card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span>Reservation #<%= reservation.getId() %></span>
                    <span class="<%= statusClass %>"><%= reservation.getStatus() %></span>
                </div>
                <div class="card-body">
                    <h5 class="card-title"><%= room.getType() %> Room</h5>
                    <p class="card-text">
                        <strong>Room Number:</strong> <%= room.getRoomNumber() %><br>
                        <strong>Check-in:</strong> <%= reservation.getCheckIn().format(dateFormatter) %><br>
                        <strong>Check-out:</strong> <%= reservation.getCheckOut().format(dateFormatter) %><br>
                        <strong>Duration:</strong> <%= nights %> night<%= nights > 1 ? "s" : "" %><br>
                        <strong>Total Price:</strong> $<%= String.format("%.2f", totalPrice) %>
                    </p>
                    <% if ("confirmed".equalsIgnoreCase(reservation.getStatus())) { %>
                    <a href="cancelReservation?id=<%= reservation.getId() %>" class="btn btn-danger"
                       onclick="return confirm('Are you sure you want to cancel this reservation?')">
                        Cancel Reservation
                    </a>
                    <% } else if ("pending".equalsIgnoreCase(reservation.getStatus())) { %>
                    <a href="completePayment?id=<%= reservation.getId() %>" class="btn btn-success">
                        Complete Payment
                    </a>
                    <a href="cancelReservation?id=<%= reservation.getId() %>" class="btn btn-danger ml-2"
                       onclick="return confirm('Are you sure you want to cancel this reservation?')">
                        Cancel Reservation
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <div class="mt-4">
        <a href="booking.jsp" class="btn btn-primary">Make Another Reservation</a>
    </div>
    <% } %>
</div>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="js/main.js"></script>
</body>
</html>
