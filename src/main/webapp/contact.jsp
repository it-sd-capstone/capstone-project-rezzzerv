<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.users.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReZZZerv - Contact Us</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/dropdown.css">
</head>
<body<% if (session.getAttribute("user") != null) { %> data-user-id="<%= ((User)session.getAttribute("user")).getId() %>"<% } %>>
<header>
    <nav>
        <div class="logo"><a href="index.jsp">ReZZZerv</a></div>
        <ul class="nav-main">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="rooms.jsp">Rooms</a></li>
            <li><a href="booking.jsp">Book Now</a></li>
            <li><a href="contact.jsp" class="active">Contact</a></li>
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
    <section class="page-header">
        <h1>Contact Us</h1>
        <p>We're here to help with any questions you might have</p>
    </section>

    <section class="contact-container">
        <div class="contact-info">
            <h2>Get in Touch</h2>
            <div class="info-item">
                <h3>Address</h3>
                <p>123 Wisconsin Street, Eau Claire, Wisconsin 54703</p>
            </div>
            <div class="info-item">
                <h3>Phone</h3>
                <p>+1 (555) 123-4567</p>
            </div>
            <div class="info-item">
                <h3>Email</h3>
                <p>info@rezzzerv.com</p>
            </div>
            <div class="info-item">
                <h3>Hours</h3>
                <p>24/7 - Our front desk is always open</p>
            </div>
        </div>
    </section>

    <section class="map-section">
        <h2>Find Us</h2>
        <div class="map-container">
            <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1415.1558722686243!2d-91.50384647323934!3d44.81521331642119!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x87f8bd6cff387963%3A0xd452c826e38018a6!2s123%20Wisconsin%20St%2C%20Eau%20Claire%2C%20WI%2054703!5e0!3m2!1sen!2sus!4v1745636803690!5m2!1sen!2sus"
                    width="100%"
                    height="450"
                    style="border:0;"
                    allowfullscreen=""
                    loading="lazy"
                    referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>
    </section>

    <section class="faq-section">
        <h2>Frequently Asked Questions</h2>
        <div class="faq-container">
            <div class="faq-item">
                <h3>What are your check-in and check-out times?</h3>
                <p>Check-in is at 3:00 PM and check-out is at 11:00 AM. Early check-in and late check-out may be available upon request, subject to availability.</p>
            </div>
            <div class="faq-item">
                <h3>Do you offer airport transportation?</h3>
                <p>Yes, we offer airport shuttle service for an additional fee. Please contact our front desk at least 24 hours in advance to arrange transportation.</p>
            </div>
            <div class="faq-item">
                <h3>Is breakfast included with the stay?</h3>
                <p>Yes, a complimentary breakfast is included with every stay.</p>
            </div>
            <div class="faq-item">
                <h3>Do you have parking available?</h3>
                <p>Yes, we offer both self-parking and valet parking options. Self-parking is $25 per night, and valet parking is $35 per night.</p>
            </div>
            <div class="faq-item">
                <h3>Do you allow pets?</h3>
                <p>Yes, we are a pet-friendly hotel. Please contact us for details about our pet policy.</p>
            </div>
        </div>
    </section>
</main>

<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>

<script src="js/main.js"></script>
<% if (session.getAttribute("user") != null) { %>
<script src="js/sessionMonitor.js"></script>
<% } %>
</body>
</html>
