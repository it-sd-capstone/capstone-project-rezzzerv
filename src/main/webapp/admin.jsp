<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.rooms.Room" %>
<%@ page import="model.users.User" %>
<%@ page import="model.reserve.Reserve" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>ReZZZerv - Admin</title>
        <link rel="stylesheet" href="css/styles.css" />
        <link rel="stylesheet" href="css/admin.css" />
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
                    <%@ include file="/WEB-INF/fragments/nav.jspf" %>
                </ul>
                <ul class="nav-auth">
                    <%
                        // Check if user is logged in
                        User currentUser = (User) session.getAttribute("user");
                        if (currentUser == null) {
                    %>
                    <li><a href="logout.jsp" class="login-link">Logout</a></li>
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
        <h1>Admin Dashboard</h1>
        <div class="manageContainer">
            <div class="adminContainer">
                <label for="sectionSelect"><strong>Manage:</strong></label>
                <%
                    String current = request.getParameter("section");
                    if (current == null) current = "rooms";
                %>
                <select id="sectionSelect" name="section">
                    onchange="window.location.href='${pageContext.request.contextPath}/admin?section='+this.value">
                    <option value="rooms" <%= "rooms".equals(current) ? "selected" : "" %>>Rooms</option>
                    <option value="users" <%= "users".equals(current) ? "selected" : "" %>>Users</option>
                    <option value="reservations" <%= "reservations".equals(current) ? "selected" : "" %>>Reservations</option>
                </select>
            </div>
        </div>
        <div id="roomsSection" class="selectionSection">
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
                            </select>
                        </div>
                        <div class="formGroup">
                            <label for="price">Price Per Night:</label>
                            <input type="text" id="price" name="roomPrice" readonly />
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
                                <input type="text" id="editRoomPrice" name="price" readonly />
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
    <%--                <div id="flashContainer">--%>
    <%--                    <%--%>
    <%--                        String flash = (String) request.getAttribute("flash");--%>
    <%--                        if (flash != null) {--%>
    <%--                    %>--%>
    <%--                    <div class="flash-message success">--%>
    <%--                        <span class="flash-text"><%= flash %></span>--%>
    <%--                        <button type="button" class="flash-close" aria-label="Dismiss">&times;</button>--%>
    <%--                    </div>--%>
    <%--                    <%--%>
    <%--                        }--%>
    <%--                    %>--%>
    <%--                </div>--%>

                        <div id="flashContainer">
                            <%
                                String flash = (String) request.getAttribute("flash");
                                String flashError   = (String) request.getAttribute("flash_error");
                                if (flash != null) {
                            %>
                            <div class="flash-message success"><%= flash %></div>
                            <%
                                }
                                if (flashError != null) {
                            %>
                            <div class="flash-message error"><%= flashError %></div>
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
                            <td class="roomPriceCell">$<%= String.format("%.2f", room.getPrice()) %></td>
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
                                <form action="deleteRoom" method="post" style="display:inline;  display:inline;">
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
        </div>
        <div id="usersSection" class="selectionSection">
            <button id="addUserBtn" class="btnPrimaryAdmin">Add New User</button>
            <div id="userFormContainer" class="adminContainer">
                <section id="userFormSection">
                    <h2 id="formTitle">Add User</h2>
                    <form id="userForm" class="adminForm" action="createUser" method="post">
                        <input type="hidden" id="userId" name="userId">

                        <div class="formGroup">
                            <label for="firstName">First Name:</label>
                            <input type="text" id="firstName" name="firstName" required>
                        </div>
                        <div class="formGroup">
                            <label for="lastName">Last Name:</label>
                            <input type="text" id="lastName" name="lastName" required>
                        </div>
                        <div class="formGroup">
                            <label for="userPhone">Phone:</label>
                            <input type="tel" id="userPhone" name="userPhone" required>
                        </div>
                        <div class="formGroup">
                            <label for="userEmail">Email:</label>
                            <input type="email" id="userEmail" name="userEmail" required>
                        </div>
                        <div class="formGroup">
                            <label for="userPassword">Password:</label>
                            <input type="password" id="userPassword" name="userPassword" required>
                        </div>
                        <div class="formGroup">
                            <label for="userType">User Type:</label>
                            <select id="userType" name="userType" required>
                                <option value="" disabled selected>Select a type…</option>
                                <option value="Administrator">Administrator</option>
                                <option value="Customer">Customer</option>
                            </select>
                        </div>
                        <div class="formGroup">
                            <button type="submit" class="btnPrimaryAdmin" id="submitUser">Save User</button>
                            <button type="button" class="btnSecondaryAdmin" id="cancelUserBtn">Cancel</button>
                        </div>
                    </form>
                </section>
            </div>
            <div id="editUserOverlay" class="modalOverlay" style="display:none;">
                <div id="editUserModal" class="modal">
                    <section>
                        <h2>Edit User</h2>
                        <form id="editUserForm" action="updateUser" method="post">
                            <input type="hidden" id="editUserId" name="userId">

                            <div class="formGroup">
                                <label for="editFirstName">First Name:</label>
                                <input type="text" id="editFirstName" name="firstName" required>
                            </div>
                            <div class="formGroup">
                                <label for="editLastName">Last Name:</label>
                                <input type="text" id="editLastName" name="lastName" required>
                            </div>
                            <div class="formGroup">
                                <label for="editUserPhone">Phone:</label>
                                <input type="tel" id="editUserPhone" name="userPhone" required>
                            </div>
                            <div class="formGroup">
                                <label for="editUserEmail">Email:</label>
                                <input type="email" id="editUserEmail" name="userEmail" required>
                            </div>
                            <div class="formGroup">
                                <label for="editUserPassword">Password:</label>
                                <input type="password" id="editUserPassword" name="userPassword" required>
                            </div>
                            <div class="formGroup">
                                <label for="editUserType">User Type:</label>
                                <select id="editUserType" name="userType" required>
                                    <option value="Administrator">Administrator</option>
                                    <option value="Customer">Customer</option>
                                </select>
                            </div>
                            <div class="formGroup">
                                <button type="submit" class="btnPrimaryAdmin">Save</button>
                                <button type="button" class="btnSecondaryAdmin" id="editUserCancelBtn">Cancel</button>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
            <div id="deleteUserOverlay" class="modalOverlay" style="display:none;">
                <div id="deleteUserModal" class="modal">
                    <section>
                        <h2>Confirm Delete</h2>
                        <p>Are you sure you want to delete user
                            "<strong id="deleteUserName"></strong>"?</p>
                        <div class="formGroup">
                            <button type="button" id="confirmDeleteUserBtn" class="btnPrimaryAdmin">
                                Yes, Delete
                            </button>
                            <button type="button" id="cancelDeleteUserBtn" class="btnSecondaryAdmin">
                                Cancel
                            </button>
                        </div>
                    </section>
                </div>
            </div>
            <div class="adminContainer">
                <section id="usersListSection">
                    <h2>All Users</h2>
                    <table class="tableAdmin" id="usersTable">
                        <thead>
                        <tr>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Phone</th>
                            <th>Email</th>
<%--                            <th>Password</th>--%>
                            <th>User Type</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<User> users = (List<User>) request.getAttribute("users");
                            for (User user : users) {
                        %>
                        <tr>
                            <td class="firstNameCell"><%= user.getName() %></td>
                            <td class="lastNameCell"><%= user.getLastName() %></td>
                            <td class="phoneCell"><%= user.getPhone() %></td>
                            <td class="emailCell"><%= user.getEmail() %></td>
<%--                            <td class="passwordCell"><%= user.getPassword() %></td>--%>
                            <td class="userTypeCell"><%= user.getUserType() %></td>
                            <td class="actionCell">
                                <button
                                        class="btnPrimaryAdmin editUserBtn"
                                        data-id="<%= user.getId() %>"
                                        data-first-name="<%= user.getName() %>"
                                        data-last-name="<%= user.getLastName() %>"
                                        data-phone="<%= user.getPhone() %>"
                                        data-email="<%= user.getEmail() %>"
                                        data-password="<%= user.getPassword() %>"
                                        data-user-type="<%= user.getUserType() %>">
                                    Edit
                                </button>
                                <form action="deleteUser" method="post" style="display:inline;">
                                    <input type="hidden" name="userId" value="<%= user.getId() %>">
                                    <button type="button" class="btnSecondaryAdmin deleteUserBtn" data-first-name="<%= user.getName() %>" data-last-name="<%= user.getLastName() %>">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </section>
            </div>
        </div>
        <div id="reservationsSection" class="selectionSection" style="display:none;">
            <div id="editReservationOverlay" class="modalOverlay" style="display:none;">
                <div id="editReservationModal" class="modal">
                    <section>
                        <h2>Edit Reservation</h2>
                        <form id="editReservationForm" action="updateReservation" method="post">
                            <input type="hidden" id="editReservationId" name="reservationId">

                            <div class="formGroup">
                                <label for="editReservationStatus">Status:</label>
                                <select id="editReservationStatus" name="status" required>
                                    <option value="Confirmed and Paid">Confirmed and Paid</option>
                                    <option value="Pending">Pending</option>
                                </select>
                            </div>
                            <div class="formGroup">
                                <label for="editReservationCheckin">Check-In:</label>
                                <input type="date" id="editReservationCheckin" name="checkin" required>
                            </div>
                            <div class="formGroup">
                                <label for="editReservationCheckout">Check-Out:</label>
                                <input type="date" id="editReservationCheckout" name="checkout" required>
                            </div>
                            <div class="formGroup">
                                <label for="editReservationUserId">User ID:</label>
                                <input type="number" id="editReservationUserId" name="userId" required>
                            </div>
                            <div class="formGroup">
                                <label for="editReservationRoomId">Room ID:</label>
                                <input type="number" id="editReservationRoomId" name="roomId" required>
                            </div>
                            <div class="formGroup">
                                <button type="submit" class="btnPrimaryAdmin">Save</button>
                                <button type="button" class="btnSecondaryAdmin" id="cancelEditReservationBtn">Cancel</button>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
            <div id="deleteReservationOverlay" class="modalOverlay" style="display:none;">
                <div id="deleteReservationModal" class="modal">
                    <section>
                        <h2>Confirm Delete</h2>
                        <p>Are you sure you want to delete reservation <strong id="deleteReservationId"></strong>?</p>
                        <div class="formGroup">
                            <button type="button" id="confirmDeleteReservationBtn" class="btnPrimaryAdmin">Yes, Delete</button>
                            <button type="button" id="cancelDeleteReservationBtn" class="btnSecondaryAdmin">Cancel</button>
                        </div>
                    </section>
                </div>
            </div>
            <div class="adminContainer">
                <section id="reservationsListSection">
                    <h2>All Reservations</h2>
                    <table class="tableAdmin" id="reservationsTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Status</th>
                            <th>Check-In</th>
                            <th>Check-Out</th>
                            <th>User ID</th>
                            <th>Room ID</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                            <tbody>
                            <%
                                List<Reserve> reservations = (List<Reserve>) request.getAttribute("reservations");
                                for (Reserve r : reservations) {
                            %>
                            <tr>
                                <td class="reservationIdCell"><%= r.getId() %></td>
                                <td class="reservationStatusCell"><%= r.getStatus() %></td>
                                <td class="reservationCheckinCell"><%= r.getCheckIn() %></td>
                                <td class="reservationCheckoutCell"><%= r.getCheckOut() %></td>
                                <td class="reservationUserCell"><%= (r.getUser()   != null ? r.getUser().getId()   : "") %></td>
                                <td class="reservationRoomCell"><%= (r.getRoom()   != null ? r.getRoom().getId()   : "") %></td>
                                <td class="actionCell">
                                    <button class="btnPrimaryAdmin editReservationBtn"
                                            data-id="<%= r.getId() %>"
                                            data-status="<%= r.getStatus() %>"
                                            data-checkin="<%= r.getCheckIn() %>"
                                            data-checkout="<%= r.getCheckOut() %>"
                                            data-user-id="<%= (r.getUser() != null ? r.getUser().getId() : "") %>"
                                            data-room-id="<%= (r.getRoom() != null ? r.getRoom().getId() : "") %>">Edit</button>
                                    <form action="deleteReservation" method="post" style="display:inline;">
                                        <input type="hidden" name="reservationId" value="<%= r.getId() %>">
                                        <button type="button" class="btnSecondaryAdmin deleteReservationBtn" data-id="<%= r.getId() %>">Delete</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                    </table>
                </section>
            </div>
        </div>
        <footer>
            <p>&copy; 2025 ReZZZerv - All rights reserved</p>
        </footer>
        <script src="js/admin.js"></script>
        <script src="js/validation.js"></script>
        <script src="js/main.js"></script>
    </body>
</html>
