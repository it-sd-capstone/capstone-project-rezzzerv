<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Pages - ReZZZerv</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        .test-container {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(136, 96, 208, 0.15);
        }

        .test-links {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-top: 2rem;
        }

        .test-link {
            display: block;
            padding: 1rem;
            background-color: #8860d0;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
            transition: all 0.3s;
        }

        .test-link:hover {
            background-color: #7a51c0;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
        }
    </style>
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
        <h1>Test Pages</h1>
        <p>View payment and confirmation pages without logging in</p>
    </section>

    <div class="test-container">
        <h2>Test Links</h2>
        <p>These links will let you view the payment and confirmation pages with test data.</p>

        <div class="test-links">
            <a href="payment.jsp?test=true" class="test-link">View Payment Page</a>
            <a href="reservationConfirmation.jsp?test=true" class="test-link">View Confirmation Page</a>
        </div>
    </div>
</main>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>
</body>
</html>
