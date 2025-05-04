<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReZZZerv - Our Rooms</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<header>
    <nav>
        <div class="logo"><a href="index.jsp">ReZZZerv</a></div>
        <ul class="nav-main">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="rooms.jsp" class="active">Rooms</a></li>
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
        <h1>Our Luxury Accommodations</h1>
        <p>Experience comfort and elegance in every room</p>
    </section>

    <section class="rooms-container">
        <!-- Basic Room -->
        <div class="room-card" id="basic-room">
            <div class="room-images">
                <img src="images/basic-room1.jpg" alt="Basic Room" class="main-image">
                <div class="thumbnail-images">
                    <img src="images/basic-room1.jpg" alt="Basic Room View 1" onclick="changeImage(this, 'basic-room')">
                    <img src="images/basic-room2.jpg" alt="Basic Room View 2" onclick="changeImage(this, 'basic-room')">
                    <img src="images/basic-room3.jpg" alt="Basic Room View 3" onclick="changeImage(this, 'basic-room')">
                </div>
            </div>
            <div class="room-details">
                <h2>Basic Room</h2>
                <p class="room-price">$139 <span>per night</span></p>
                <p class="room-description">Our comfortable Basic Room offers everything you need for a pleasant stay. Perfect for solo travelers or couples looking for quality accommodations at an affordable price.</p>

                <h3>Room Amenities</h3>
                <ul class="amenities-list">
                    <li>Queen-sized bed</li>
                    <li>32" Flat-screen TV</li>
                    <li>Free Wi-Fi</li>
                    <li>Air conditioning</li>
                    <li>Private bathroom with shower</li>
                    <li>Coffee maker</li>
                    <li>Work desk</li>
                </ul>

                <div class="room-specs">
                    <div class="spec">
                        <span class="spec-icon">👤</span>
                        <span class="spec-text">2 Guests</span>
                    </div>
                    <div class="spec">
                        <span class="spec-icon">🛏️</span>
                        <span class="spec-text">1 Queen Bed</span>
                    </div>
                    <div class="spec">
                        <span class="spec-icon">📏</span>
                        <span class="spec-text">300 sq ft</span>
                    </div>
                </div>

                <a href="booking.jsp?room=basic" class="btn book-btn">Book Now</a>
            </div>
        </div>

        <!-- Premium Room -->
        <div class="room-card" id="premium-room">
            <div class="room-images">
                <img src="images/premium-room1.jpg" alt="Premium Room" class="main-image">
                <div class="thumbnail-images">
                    <img src="images/premium-room1.jpg" alt="Premium Room View 1" onclick="changeImage(this, 'premium-room')">
                    <img src="images/premium-room2.jpg" alt="Premium Room View 2" onclick="changeImage(this, 'premium-room')">
                    <img src="images/premium-room3.jpg" alt="Premium Room View 3" onclick="changeImage(this, 'premium-room')">
                </div>
            </div>
            <div class="room-details">
                <h2>Premium Room</h2>
                <p class="room-price">$219 <span>per night</span></p>
                <p class="room-description">Our Premium Room offers additional space and upgraded amenities for a truly comfortable stay. Ideal for those seeking extra comfort and convenience during their visit.</p>

                <h3>Room Amenities</h3>
                <ul class="amenities-list">
                    <li>King-sized bed</li>
                    <li>50" Smart TV</li>
                    <li>High-speed Wi-Fi</li>
                    <li>Climate control</li>
                    <li>Luxury bathroom</li>
                    <li>Premium coffee machine</li>
                    <li>Minibar</li>
                    <li>Sitting area with sofa</li>
                    <li>Workspace</li>
                    <li>Bathrobes and slippers</li>
                </ul>

                <div class="room-specs">
                    <div class="spec">
                        <span class="spec-icon">👤</span>
                        <span class="spec-text">2-3 Guests</span>
                    </div>
                    <div class="spec">
                        <span class="spec-icon">🛏️</span>
                        <span class="spec-text">1 King Bed</span>
                    </div>
                    <div class="spec">
                        <span class="spec-icon">📏</span>
                        <span class="spec-text">450 sq ft</span>
                    </div>
                </div>

                <a href="booking.jsp?room=premium" class="btn book-btn">Book Now</a>
            </div>
        </div>

        <!-- Presidential Suite -->
        <div class="room-card" id="presidential-suite">
            <div class="room-images">
                <img src="images/presidential-suite1.jpg" alt="Presidential Suite" class="main-image">
                <div class="thumbnail-images">
                    <img src="images/presidential-suite1.jpg" alt="Presidential Suite View 1" onclick="changeImage(this, 'presidential-suite')">
                    <img src="images/presidential-suite2.jpg" alt="Presidential Suite View 2" onclick="changeImage(this, 'presidential-suite')">
                    <img src="images/presidential-suite3.jpg" alt="Presidential Suite View 3" onclick="changeImage(this, 'presidential-suite')">
                </div>
            </div>
            <div class="room-details">
                <h2>Presidential Suite</h2>
                <p class="room-price">$499 <span>per night</span></p>
                <p class="room-description">Our most luxurious accommodation, the Presidential Suite offers unparalleled comfort and elegance. Experience the ultimate in luxury with panoramic views, exclusive amenities, and personalized service.</p>

                <h3>Suite Amenities</h3>
                <ul class="amenities-list">
                    <li>King-sized bed with premium linens</li>
                    <li>Separate living room with entertainment system</li>
                    <li>Premium sound system</li>
                    <li>Ultra-fast Wi-Fi</li>
                    <li>Smart climate control</li>
                    <li>Luxury bathroom with jacuzzi</li>
                    <li>Full-sized kitchen with premium appliances</li>
                    <li>Dining area for guests</li>
                    <li>Private balcony with panoramic views</li>
                    <li>Complimentary champagne upon arrival</li>
                    <li>Access to executive lounge</li>
                    <li>Luxury toiletries and bath products</li>
                </ul>

                <div class="room-specs">
                    <div class="spec">
                        <span class="spec-icon">👤</span>
                        <span class="spec-text">2-4 Guests</span>
                    </div>
                    <div class="spec">
                        <span class="spec-icon">🛏️</span>
                        <span class="spec-text">1 King Bed + Sofa Bed</span>
                    </div>
                    <div class="spec">
                        <span class="spec-icon">📏</span>
                        <span class="spec-text">1050 sq ft</span>
                    </div>
                </div>

                <a href="booking.jsp?room=presidential" class="btn book-btn">Book Now</a>
            </div>
        </div>
    </section>
</main>

<footer>
    <p>&copy; 2025 Rezzzerv - All rights reserved</p>
</footer>

<script>
    // Function to change the main image when clicking on thumbnails
    function changeImage(thumbnail, roomId) {
        const mainImage = document.querySelector(`#${roomId} .main-image`);
        mainImage.src = thumbnail.src;
    }
</script>
<script src="js/main.js"></script>
</body>
</html>
