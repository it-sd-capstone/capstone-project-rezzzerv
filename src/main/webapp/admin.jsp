<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>ReZZZerv - Admin</title>
        <link rel="stylesheet" href="css/styles.css" />
        <link rel="stylesheet" href="css/admin.css" />
        <link rel="stylesheet" href="validation.css" />
    </head>
    <body>
        <header>
            <nav>
                <div class="logo"><a href="index.jsp">ReZZZerv</a></div>
                <ul class="nav-main">
                    <li><a href="index.jsp">Home</a></li>
                </ul>
                <ul class="nav-auth">
                    <li><a href="logout.html" class="login-link">Logout</a></li>
                </ul>
            </nav>
        </header>
        <h1>Admin Dashboard - Manage Rooms</h1>
        <button id="addRoomBtn">Add New Room</button>
        <div id="roomFormContainer" class="adminContainer" style="display: none;">
            <section id="roomFormSection">
                <h2 id="formTitle">Add/Edit Room</h2>
                <form id="roomForm" class="adminForm">
                    <div class="formGroup">
                        <input type="hidden" id="roomId" name="roomId">
                        <label for="roomNumber">Room Number:</label>
                        <input type="text" id="roomNumber" name="roomNumber" required>
                    </div>
                    <div class="formGroup">
                        <label for="roomType">Room Type:</label>
                        <select id="roomType" name="roomType" required>
                            <option value="" disabled selected>Choose a type…</option>
                            <option value="Type placeholder">Type placeholder</option>
                            <option value="Type placeholder">Type placeholder</option>
                            <option value="Type placeholder">Type placeholder</option>
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
        <div class="adminContainer">
            <section id="roomsListSection">
                <h2>All Rooms</h2>
                <table class="tableAdmin" id="roomsTable">
                    <thead>
                    <tr>
                        <th>Room Number</th>
                        <th>Type</th>
                        <th>Price</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- Rooms will be dynamically populated here, the following is test data -->
                    <tr>
                        <td>101</td>
                        <td>Single</td>
                        <td>$99.99</td>
                        <td>
                            <button class="btnPrimaryAdmin editBtn">Edit</button>
                            <button class="btnSecondaryAdmin deleteBtn">Delete</button>
                        </td>
                    </tr>
                    <tr>
                        <td>202</td>
                        <td>Double</td>
                        <td>$129.99</td>
                        <td>
                            <button class="btnPrimaryAdmin editBtn">Edit</button>
                            <button class="btnSecondaryAdmin deleteBtn">Delete</button>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </section>
        </div>
        <footer>
            <p>&copy; 2025 ReZZZerv - All rights reserved</p>
        </footer>
        <script src="js/admin.js"></script>
        <script src="validation.js"></script>
    </body>
</html>
