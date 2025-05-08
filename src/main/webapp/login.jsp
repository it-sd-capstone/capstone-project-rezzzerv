<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>ReZZZerv - Login</title>
    <link rel="stylesheet" href="css/styles.css" />
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
            <li><a href="login.jsp" class="login-link active">Login</a></li>
            <li><a href="register.jsp" class="register-link">Register</a></li>
        </ul>
    </nav>
</header>

<main>
    <section class="auth-container">
        <h1 class="auth-title">Log In</h1>
        <form action="login" method="POST" class="auth-form" id="login-form">
            <div class="input-wrapper">
                <input type="email" id="login-email" name="email" placeholder="Email" required>
            </div>
            <div class="input-wrapper">
                <input type="password" id="login-password" name="password" placeholder="Password" required>
            </div>

            <div id="login-error" class="error-banner" style="<%= (request.getAttribute("error") != null) ? "" : "display: none;" %>">
                <%= (request.getAttribute("error") != null) ? request.getAttribute("error") : "" %>
            </div>

            <button type="submit" class="btn auth-btn" id="login-btn" disabled>Log in</button>
        </form>
        <p class="auth-link">
            Don't have an account? <a href="register.jsp">Register</a>
        </p>
    </section>
</main>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script src="js/main.js"></script>
<script src="js/validation.js"></script>
</body>
</html>