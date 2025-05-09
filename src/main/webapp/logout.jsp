<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session to log the user out
    session.invalidate();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Logged Out</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="css/logout.css">
</head>
<body>
<main class="adminContainer">
    <section id="logoutSection" class="formGroup">
        <h2>You have been logged out</h2>
        <div class="formGroup" style="margin-top: 2rem;">
            <a href="login.jsp" class="btnPrimaryAdmin">Login</a>
            <a href="index.jsp" class="btnSecondaryAdmin">Return Home</a>
        </div>
    </section>
</main>
</body>
</html>