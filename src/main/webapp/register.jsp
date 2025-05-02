<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ReZZZerv - Register</title>
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
      <li><a href="login.jsp" class="login-link">Login</a></li>
      <li><a href="register.jsp" class="register-link active">Register</a></li>
    </ul>
  </nav>
</header>

<main>
  <section class="auth-container">
    <h1 class="auth-title">Create an Account</h1>
    <form action="register" method="POST" class="auth-form" id="register-form">
      <div class="input-wrapper">
        <input type="text" id="name" name="name" placeholder="Name" required>
      </div>
      <div class="input-wrapper">
        <input type="text" id="lastName" name="lastName" placeholder="Last name" required>
      </div>
      <div class="input-wrapper">
        <input type="email" id="email" name="email" placeholder="Email" required>
      </div>
      <div class="input-wrapper">
        <input type="text" id="phone" name="phone" placeholder="Phone" required>
      </div>
      <div class="input-wrapper">
        <input type="password" id="password" name="password" placeholder="Password" required>
      </div>
      <div class="input-wrapper">
        <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm Password" required>
      </div>
      <button type="submit" class="btn auth-btn" id="register-btn">Register</button>
    </form>

    <p class="auth-link">
      Already have an account? <a href="login.jsp">Log in</a>
    </p>
  </section>
</main>

<footer>
  <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
