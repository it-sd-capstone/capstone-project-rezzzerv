<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.users.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ReZZZerv - Hotel Booking</title>
  <link rel="stylesheet" href="css/styles.css">
  <link rel="stylesheet" href="css/dropdown.css">
</head>
<body>
<header>
  <nav>
    <div class="logo"><a href="index.jsp">ReZZZerv</a></div>
    <ul class="nav-main">
      <li><a href="index.jsp" class="active">Home</a></li>
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
  <section class="hero">
    <h1>Welcome to ReZZZerv</h1>
    <p>Your perfect stay is just a few clicks away</p>
    <a href="booking.jsp" class="btn">Book Now</a>
  </section>
  <section class="features">
    <a href="rooms.jsp" class="feature-link">
      <div class="feature">
        <h2>Luxury Rooms</h2>
        <p>Experience comfort like never before</p>
      </div>
    </a>
    <a href="https://www.google.com/maps/place/123+Wisconsin+St,+Eau+Claire,+WI+54703/@44.8151996,-91.5063688,17z/data=!3m1!4b1!4m5!3m4!1s0x87f8bd6cff387963:0xd452c826e38018a6!8m2!3d44.8151996!4d-91.5037992?authuser=0&entry=ttu&g_ep=EgoyMDI1MDUwNy4wIKXMDSoASAFQAw%3D%3D" target="_blank" class="feature-link">
      <div class="feature">
        <h2>Prime Location</h2>
        <p>Situated in the heart of the city</p>
      </div>
    </a>
    <a href="contact.jsp" class="feature-link">
      <div class="feature">
        <h2>24/7 Service</h2>
        <p>Our staff is always at your service</p>
      </div>
    </a>
  </section>
</main>

<footer>
  <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
