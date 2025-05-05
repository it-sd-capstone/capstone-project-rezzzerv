<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.TemporalAccessor" %>
<%@ page import="model.users.User" %>
<%@ page import="model.reserve.Reserve" %>
<%@ page import="java.time.LocalDate" %>
<%
    User user1 = (User) session.getAttribute("user");
    if (user1 == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // get data from session
    String roomType          = (String) session.getAttribute("roomType");
    Integer roomNumber       = (Integer) session.getAttribute("roomNumber");
    Long nights              = (Long)    session.getAttribute("nights");
    Double totalPrice        = (Double)  session.getAttribute("totalPrice");
    String checkInFormatted  = (String)  session.getAttribute("checkInFormatted");
    String checkOutFormatted = (String)  session.getAttribute("checkOutFormatted");

    // get reserve id
    Long reservationId = null;
    Reserve reserveObj = (Reserve) session.getAttribute("reserve");
    if (reserveObj != null) {
        reservationId = reserveObj.getId();
    }

    //  Calculate taxes and total
    double taxesAndFees = totalPrice != null ? totalPrice * 0.15 : 0.0;
    double grandTotal   = totalPrice != null ? totalPrice + taxesAndFees : 0.0;
%>

<!-- show user session -->
<p>show: User object = <%= user1 %></p>

<!-- show user data -->
<p>show: User email  = <%= user1.getEmail() %></p>
<p>show: User name   = <%= user1.getName() %> <%= user1.getLastName() %></p>

<%--<%--%>
<%--    // Check if this is a test view--%>
<%--    boolean isTest = "true".equals(request.getParameter("test"));--%>

<%--    // Variables to store data--%>
<%--    String roomType = null;--%>
<%--    Integer roomNumber = null;--%>
<%--    Long nights = null;--%>
<%--    Double totalPrice = null;--%>
<%--    String checkInFormatted = null;--%>
<%--    String checkOutFormatted = null;--%>
<%--    String guestName = null;--%>
<%--    String guestEmail = null;--%>
<%--    Long reservationId = null;--%>



<%--    // If test mode, create dummy data--%>
<%--    if (isTest) {--%>
<%--        // Create simple test data without using model classes--%>
<%--        roomType = "Premium Suite";--%>
<%--        roomNumber = 205;--%>
<%--        nights = 3L;--%>
<%--        totalPrice = 658.77;--%>
<%--        checkInFormatted = "June 15, 2025";--%>
<%--        checkOutFormatted = "June 18, 2025";--%>
<%--        guestName = "John Doe";--%>
<%--        guestEmail = "john.doe@example.com";--%>
<%--        reservationId = 12345L;--%>
<%--    } else {--%>
<%--        // Get data from session--%>
<%--        roomType = (String) session.getAttribute("roomType");--%>
<%--        roomNumber = (Integer) session.getAttribute("roomNumber");--%>
<%--        nights = (Long) session.getAttribute("nights");--%>
<%--        totalPrice = (Double) session.getAttribute("totalPrice");--%>

<%--        // Get other data from reserve object if available--%>
<%--        Object reserveObj = session.getAttribute("reserve");--%>
<%--        if (reserveObj != null) {--%>
<%--            // Use reflection to safely get values without direct class references--%>
<%--            try {--%>
<%--                // Get check-in and check-out dates--%>
<%--                Object checkIn = reserveObj.getClass().getMethod("getCheckIn").invoke(reserveObj);--%>
<%--                Object checkOut = reserveObj.getClass().getMethod("getCheckOut").invoke(reserveObj);--%>

<%--                // Format dates--%>
<%--                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy");--%>
<%--                checkInFormatted = formatter.format((TemporalAccessor) checkIn);--%>
<%--                checkOutFormatted = formatter.format((TemporalAccessor) checkOut);--%>

<%--                // Get reservation ID--%>
<%--                reservationId = (Long) reserveObj.getClass().getMethod("getId").invoke(reserveObj);--%>

<%--                // Get user info--%>
<%--                Object user = reserveObj.getClass().getMethod("getUser").invoke(reserveObj);--%>
<%--                if (user != null) {--%>
<%--                    String firstName = (String) user.getClass().getMethod("getName").invoke(user);--%>
<%--                    String lastName = (String) user.getClass().getMethod("getLastName").invoke(user);--%>
<%--                    guestName = firstName + " " + lastName;--%>
<%--                    guestEmail = (String) user.getClass().getMethod("getEmail").invoke(user);--%>
<%--                }--%>
<%--            } catch (Exception e) {--%>
<%--                // Handle any errors--%>
<%--                System.out.println("<!-- Error getting reservation details: " + e.getMessage() + " -->");--%>
<%--            }--%>
<%--        }--%>
<%--    }--%>

<%--    // Calculate taxes and total--%>
<%--    double taxesAndFees = totalPrice != null ? totalPrice * 0.15 : 0.0;--%>
<%--    double grandTotal = totalPrice != null ? totalPrice + taxesAndFees : 0.0;--%>
<%--%>--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReZZZerv - Payment</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/payment.css">
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

<%--<main>--%>
<%--    <section class="page-banner">--%>
<%--        <h1>Payment</h1>--%>
<%--        <p>Complete your reservation</p>--%>
<%--    </section>--%>

<%--    <div class="payment-container">--%>
<%--        <div class="payment-summary">--%>
<%--            <h2>Reservation Summary</h2>--%>
<%--            <div class="reservation-details">--%>
<%--                <h3>Reservation Details</h3>--%>
<%--                <p><strong>Check-in:</strong> <%= checkInFormatted %></p>--%>
<%--                <p><strong>Check-out:</strong> <%= checkOutFormatted %></p>--%>
<%--                <p><strong>Room Type:</strong> <%= roomType %></p>--%>
<%--                <p><strong>Room Number:</strong> <%= roomNumber %></p>--%>
<%--                <p><strong>Nights:</strong> <%= nights %></p>--%>
<%--                <p><strong>Guest:</strong> <%= guestName %></p>--%>
<%--            </div>--%>
<%--            <div class="price-summary">--%>
<%--                <h3>Price Summary</h3>--%>
<%--                <p><span>Room Rate:</span> <span>$<%= String.format("%.2f", totalPrice) %></span></p>--%>
<%--                <p><span>Taxes & Fees:</span> <span>$<%= String.format("%.2f", taxesAndFees) %></span></p>--%>
<%--                <p class="total"><span>Total:</span> <span>$<%= String.format("%.2f", grandTotal) %></span></p>--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <div class="payment-form">--%>
<%--            <h2>Payment Information</h2>--%>
<%--            <form action="processPayment<%= isTest ? "?test=true" : "" %>" method="post">--%>
<%--            <div class="form-group">--%>
<%--                    <label for="cardName">Name on Card</label>--%>
<%--                    <input type="text" id="cardName" name="cardName" required>--%>
<%--                </div>--%>
<%--                <div class="form-group">--%>
<%--                    <label for="cardNumber">Card Number</label>--%>
<%--                    <input type="text" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" required>--%>
<%--                </div>--%>
<%--                <div class="form-row">--%>
<%--                    <div class="form-group">--%>
<%--                        <label for="expDate">Expiration Date</label>--%>
<%--                        <input type="text" id="expDate" name="expDate" placeholder="MM/YY" required>--%>
<%--                    </div>--%>
<%--                    <div class="form-group">--%>
<%--                        <label for="cvv">CVV</label>--%>
<%--                        <input type="text" id="cvv" name="cvv" placeholder="XXX" required>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="form-group">--%>
<%--                    <label for="billingAddress">Billing Address</label>--%>
<%--                    <input type="text" id="billingAddress" name="billingAddress" required>--%>
<%--                </div>--%>
<%--                <div class="form-row">--%>
<%--                    <div class="form-group">--%>
<%--                        <label for="city">City</label>--%>
<%--                        <input type="text" id="city" name="city" required>--%>
<%--                    </div>--%>
<%--                    <div class="form-group">--%>
<%--                        <label for="zipCode">Zip Code</label>--%>
<%--                        <input type="text" id="zipCode" name="zipCode" required>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="form-group">--%>
<%--                    <label for="country">Country</label>--%>
<%--                    <select id="country" name="country" required>--%>
<%--                        <option value="">Select Country</option>--%>
<%--                        <option value="US">United States</option>--%>
<%--                        <option value="CA">Canada</option>--%>
<%--                        <option value="MX">Mexico</option>--%>
<%--                        <option value="UK">United Kingdom</option>--%>
<%--                        <!-- Add more countries as needed -->--%>
<%--                    </select>--%>
<%--                </div>--%>
<%--                <div class="form-actions">--%>
<%--                    <a href="booking.jsp" class="btn-secondary">Back</a>--%>
<%--                    <button type="submit" class="btn-primary">Complete Payment</button>--%>
<%--                </div>--%>
<%--            </form>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</main>--%>

<main>
    <section class="page-banner">
        <h1>Payment</h1>
        <p>Complete your reservation</p>
    </section>

    <div class="payment-container">
        <div class="payment-summary">
            <h2>Reservation Summary</h2>
            <div class="reservation-details">
                <p><strong>Check-in:</strong>  <%= checkInFormatted %></p>
                <p><strong>Check-out:</strong> <%= checkOutFormatted %></p>
                <p><strong>Room Type:</strong> <%= roomType %></p>
                <p><strong>Room Number:</strong> <%= roomNumber %></p>
                <p><strong>Nights:</strong>      <%= nights %></p>
            </div>
            <div class="price-summary">
                <p><span>Room Rate:</span>    $<%= String.format("%.2f", totalPrice) %></p>
                <p><span>Taxes & Fees:</span> $<%= String.format("%.2f", taxesAndFees) %></p>
                <p class="total"><span>Total:</span> $<%= String.format("%.2f", grandTotal) %></p>
            </div>
        </div>

        <div class="payment-form">
            <h2>Payment Information</h2>

            <form action="processPayment" method="post">

                <!-- hidden fields -->
                <input type="hidden" name="reserveId" value="<%= reservationId %>" />
                <input type="hidden" name="amount"    value="<%= totalPrice %>" />
                <input type="hidden" name="paidDate"  value="<%= LocalDate.now().toString() %>" />

                <!-- card number it has to persist in db -->
                <div class="form-group">
                    <label for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber"
                           placeholder="XXXX XXXX XXXX XXXX" required>
                </div>

                <!-- billing info is optional by now -->
                <div class="form-group">
                    <label for="billingAddress">Billing Address</label>
                    <input type="text" id="billingAddress" name="billingAddress" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="city">City</label>
                        <input type="text" id="city" name="city" required>
                    </div>
                    <div class="form-group">
                        <label for="zipCode">Zip Code</label>
                        <input type="text" id="zipCode" name="zipCode" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="country">Country</label>
                    <select id="country" name="country" required>
                        <option value="">Select Country</option>
                        <option value="US">United States</option>
                        <option value="CA">Canada</option>
                        <option value="MX">Mexico</option>
                        <option value="UK">United Kingdom</option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="booking.jsp" class="btn-secondary">Back</a>
                    <button type="submit" class="btn-primary">Complete Payment</button>
                </div>
            </form>
        </div>
    </div>
</main>


<footer>
    <p>&copy; 2025 ReZZZerv - All rights reserved</p>
</footer>
<script src="js/main.js"></script>
</body>
</html>
