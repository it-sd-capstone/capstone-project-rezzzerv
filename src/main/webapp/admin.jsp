<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.rooms.Room" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>ReZZZerv - Admin</title>
        <link rel="stylesheet" href="css/styles.css" />
        <link rel="stylesheet" href="css/admin.css" />
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
                    <li><a href="logout.html" class="login-link">Logout</a></li>
                </ul>
            </nav>
        </header>
        <h1>Admin Dashboard - Manage Rooms</h1>
        <button id="addRoomBtn" class="btnPrimaryAdmin">Add New Room</button>
        <div id="roomFormContainer" class="adminContainer">
            <section id="roomFormSection">
                <h2 id="formTitle">Add Room</h2>
                <form id="roomForm" class="adminForm" action="createRoom" method="post">
                    <div class="formGroup">
                        <input type="hidden" id="roomId" name="roomId">
                        <label for="roomNumber">Room Number:</label>
                        <input type="text" id="roomNumber" name="roomNumber" required>
                    </div>
                    <div class="formGroup">
                        <label for="roomType">Room Type:</label>
                        <select id="roomType" name="roomType" required>
                            <option value="" disabled selected>Choose a type…</option>
<<<<<<< Updated upstream
                            <option value="Type placeholder">Presidential</option>
                            <option value="Type placeholder">Basic</option>
                            <option value="Type placeholder">Premium</option>
=======
                            <option value="Basic">Basic</option>
                            <option value="Premium">Premium</option>
                            <option value="Presidential">Presidential</option>
                        </select>
                    </div>
                    <div class="formGroup">
                        <label for="roomAvailable">Available:</label>
                        <select id="roomAvailable" name="roomAvailable" required>
                            <option value="" disabled selected>Choose…</option>
                            <option value="1">Yes</option>
                            <option value="0">No</option>
>>>>>>> Stashed changes
                        </select>
                    </div>
                    <div class="formGroup">
                        <label for="roomPrice">Price Per Night:</label>
                        <input type="number" id="roomPrice" name="roomPrice" step="0.01" required>
                    </div>
                    <div class="formGroup">
                        <button type="submit" class="btnPrimaryAdmin" id="submitRoom">Save Room</button>
                        <button type="button" class="btnSecondaryAdmin" id="cancelBtn">Cancel</button>
                    </div>
                </form>
            </section>
        </div>
        <div id="editOverlay" class="modalOverlay" style="display:none;">
            <div id="editModal" class="modal">
                <section>
                    <h2>Edit Room</h2>
                    <form id="editForm" action="updateRoom" method="post">
                        <input type="hidden" id="editRoomId" name="roomId"/>
                        <div class="formGroup">
                            <label for="editRoomNumber">Room Number:</label>
                            <input type="text" id="editRoomNumber" name="roomNumber" required/>
                        </div>
                        <div class="formGroup">
                            <label for="editRoomType">Room Type:</label>
                            <select id="editRoomType" name="roomType" required>
                                <option value="Basic">Basic</option>
                                <option value="Premium">Premium</option>
                                <option value="Presidential">Presidential</option>
                            </select>
                        </div>
                        <div class="formGroup">
                            <label for="editRoomPrice">Price Per Night:</label>
                            <input type="number" id="editRoomPrice" name="roomPrice" step="0.01" required/>
                        </div>
                        <div class="formGroup">
                            <label for="editRoomAvailable">Available:</label>
                            <select id="editRoomAvailable" name="roomAvailable" required>
                                <option value="" disabled>Choose…</option>
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                        <div class="formGroup">
                            <button type="submit" class="btnPrimaryAdmin">Save</button>
                            <button type="button" class="btnSecondaryAdmin" id="editCancelBtn">Cancel</button>
                        </div>
                    </form>
                </section>
            </div>
        </div>
        <div id="deleteOverlay" class="modalOverlay" style="display:none;">
            <div id="deleteModal" class="modal">
                <section>
                    <h2>Confirm Delete</h2>
                    <p>Are you sure you want to delete room "<strong id="deleteRoomNumber"></strong>"?</p>
                    <div class="formGroup">
                        <button type="button" id="confirmDeleteBtn" class="btnPrimaryAdmin">Yes, Delete</button>
                        <button type="button" id="cancelDeleteBtn"  class="btnSecondaryAdmin">Cancel</button>
                    </div>
                </section>
            </div>
        </div>
        <div class="adminContainer">
            <section id="roomsListSection">
                <div id="flashContainer">
                    <%
                        String flash = (String) request.getAttribute("flash");
                        if (flash != null) {
                    %>
                    <div class="flash-message success">
                        <span class="flash-text"><%= flash %></span>
                        <button type="button" class="flash-close" aria-label="Dismiss">&times;</button>
                    </div>
                    <%
                        }
                    %>
                </div>
                <h2>All Rooms</h2>
                <table class="tableAdmin" id="roomsTable">
                    <thead>
                    <tr>
                        <th>Room Number</th>
                        <th>Type</th>
                        <th>Available</th>
                        <th>Price</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                        for (Room room : rooms) {
                    %>
                    <tr>
                        <td class="roomNumberCell"><%= room.getRoomNumber() %></td>
                        <td class="roomTypeCell"><%= room.getType() %></td>
                        <td class="roomAvailableCell"><%= room.isAvailable() ? "Yes" : "No" %></td>
                        <td class="roomPriceCell">$<%= room.getPrice() %></td>
                        <td class="actionCell">
                            <button
                                class="btnPrimaryAdmin editBtn"
                                data-id="<%= room.getId() %>"
                                data-number="<%= room.getRoomNumber() %>"
                                data-type="<%= room.getType() %>"
                                data-price="<%= room.getPrice() %>"
                                data-available="<%= room.isAvailable() ? "1" : "0" %>">
                                Edit
                            </button>
                            <form action="deleteRoom" method="post" style="display:inline;">
                                <input type="hidden" name="roomId"     value="<%= room.getId() %>"/>
                                <input type="hidden" name="roomNumber" value="<%= room.getRoomNumber() %>"/>
                                <button type="button" class="btnSecondaryAdmin deleteBtn" data-number="<%= room.getRoomNumber() %>">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </section>
        </div>
        <footer>
            <p>&copy; 2025 ReZZZerv - All rights reserved</p>
        </footer>
        <script src="js/admin.js"></script>
        <script src="js/validation.js"></script>
    </body>
</html>
