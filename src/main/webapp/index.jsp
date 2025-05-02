<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ReZZZerv - Hotel Booking</title>
  <link rel="stylesheet" href="css/styles.css">
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
      <li><a href="payment.jsp">Payment</a></li>
    </ul>
    <ul class="nav-auth">
      <li><a href="login.jsp" class="login-link">Login</a></li>
      <li><a href="register.jsp" class="register-link">Register</a></li>
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
    <div class="feature">
      <h2>Luxury Rooms</h2>
      <p>Experience comfort like never before</p>
    </div>
    <div class="feature">
      <h2>Prime Location</h2>
      <p>Situated in the heart of the city</p>
    </div>
    <div class="feature">
      <h2>24/7 Service</h2>
      <p>Our staff is always at your service</p>
    </div>
  </section>
</main>

<footer>
  <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
