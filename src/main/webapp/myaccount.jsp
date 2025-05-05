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
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/myaccount.css">
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
        // Display success or error messages
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");

        if (successMessage != null) {
    %>
    <div class="alert alert-success alert-dismissible">
        <%= successMessage %>
        <button type="button" class="close" onclick="this.parentElement.style.display='none';">&times;</button>
    </div>
    <%
            session.removeAttribute("successMessage");
        }

        if (errorMessage != null) {
    %>
    <div class="alert alert-danger alert-dismissible">
        <%= errorMessage %>
        <button type="button" class="close" onclick="this.parentElement.style.display='none';">&times;</button>
    </div>
    <%
            session.removeAttribute("errorMessage");
        }
    %>

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
    <div class="reservations-container">
        <h2>My Reservations</h2>

        <% if (reservations.isEmpty()) { %>
        <div class="no-reservations">
            <p>You don't have any reservations yet.</p>
            <a href="booking.jsp" class="btn btn-primary mt-3">Make a Reservation</a>
        </div>
        <% } else { %>
        <div class="reservations-scroll">
            <table class="reservations-table">
                <thead>
                <tr>
                    <th>Reservation #</th>
                    <th>Room</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th>Nights</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Reserve reservation : reservations) {
                    Room room = reservation.getRoom();
                    long nights = ChronoUnit.DAYS.between(reservation.getCheckIn(), reservation.getCheckOut());
                    double totalPrice = room.getPrice() * nights;
                    String statusClass = "";

                    // Debug the status
                    System.out.println("Reservation #" + reservation.getId() + " status: '" + reservation.getStatus() + "'");

                    if (reservation.getStatus().contains("Confirmed") || reservation.getStatus().contains("confirmed")) {
                        statusClass = "status-confirmed";
                    } else if (reservation.getStatus().contains("Pending") || reservation.getStatus().contains("pending")) {
                        statusClass = "status-pending";
                    } else if (reservation.getStatus().contains("Cancelled") || reservation.getStatus().contains("cancelled")) {
                        statusClass = "status-cancelled";
                    }
                %>
                <tr>
                    <td><%= reservation.getId() %></td>
                    <td><%= room.getType() %> (Room <%= room.getRoomNumber() %>)</td>
                    <td><%= reservation.getCheckIn().format(dateFormatter) %></td>
                    <td><%= reservation.getCheckOut().format(dateFormatter) %></td>
                    <td><%= nights %> night<%= nights > 1 ? "s" : "" %></td>
                    <td>$<%= String.format("%.2f", totalPrice) %></td>
                    <td class="<%= statusClass %>"><%= reservation.getStatus() %></td>
                    <td>
                        <%
                            // Always show cancel button regardless of status
                            // This addresses the issue where buttons weren't showing up
                        %>
                        <a href="cancelReservation?id=<%= reservation.getId() %>" class="btn-cancel"
                           onclick="return confirm('Are you sure you want to cancel this reservation?')">
                            Cancel
                        </a>

                        <%
                            // If status contains "Pending", also show the payment button
                            if (reservation.getStatus().contains("Pending") || reservation.getStatus().contains("pending")) {
                        %>
                        <a href="completePayment?id=<%= reservation.getId() %>" class="btn-payment">
                            Pay
                        </a>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <div class="mt-4">
            <a href="booking.jsp" class="btn btn-primary">Make Another Reservation</a>
        </div>
        <% } %>
    </div>
</div>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script>
    // Simple JavaScript to handle alert dismissal
    document.addEventListener('DOMContentLoaded', function() {
        var closeButtons = document.querySelectorAll('.close');
        closeButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                this.parentElement.style.display = 'none';
            });
        });
    });
</script>
<script src="js/main.js"></script>
</body>
</html>
