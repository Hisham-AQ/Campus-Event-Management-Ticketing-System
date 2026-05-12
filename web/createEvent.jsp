<%@ page import="model.User" %>

<%
  User user = (User) session.getAttribute("user");

  if (user == null || !"organizer".equals(user.getRole())) {
    response.sendRedirect("login.jsp");
    return;
  }
%>

<html>
<head>
  <title>Create Event</title>

  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f4f6f8;
    }

    /* Navbar */
    .navbar {
      background-color: #2d89ef;
      padding: 15px;
      color: white;
      display: flex;
      justify-content: space-between;
    }

    .navbar a {
      color: white;
      margin: 0 10px;
      text-decoration: none;
    }

    /* Container */
    .container {
      display: flex;
      justify-content: center;
      padding: 40px;
    }

    /* Form card */
    .form-box {
      background: white;
      padding: 30px;
      border-radius: 12px;
      width: 400px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    h2 {
      text-align: center;
      margin-bottom: 20px;
      color: #333;
    }

    label {
      font-size: 13px;
      color: #555;
      display: block;
      margin-top: 10px;
    }

    input, select {
      width: 100%;
      padding: 10px;
      margin: 5px 0 10px 0;
      border: 1px solid #ddd;
      border-radius: 6px;
    }

    input:focus, select:focus {
      border-color: #2d89ef;
      outline: none;
      box-shadow: 0 0 5px rgba(45,137,239,0.3);
    }

    button {
      width: 100%;
      padding: 12px;
      margin-top: 15px;
      border: none;
      border-radius: 6px;
      background-color: #2d89ef;
      color: white;
      font-size: 15px;
      cursor: pointer;
    }

    button:hover {
      background-color: #1b6fdc;
    }

    .error {
      color: red;
      text-align: center;
      margin-bottom: 10px;
    }
  </style>
</head>

<body>

<!-- Navbar -->
<div class="navbar">
  <div><strong>Campus Events</strong></div>

  <div>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="events.jsp">Events</a>
    <a href="myReservations.jsp">My Reservations</a>
    <a href="search.jsp">Search</a>
    <a href="logout">Logout</a>
  </div>
</div>

<div class="container">

  <div class="form-box">

    <h2>Create Event</h2>

    <% if ("1".equals(request.getParameter("error"))) { %>
    <div class="error">Failed to create event. Please try again.</div>
    <% } %>

      <form action="createEvent" method="post" enctype="multipart/form-data">

      <label>Event Title</label>
      <input type="text" name="title" required>

      <label>Description</label>
      <input type="text" name="description" required>

      <label>Date & Time</label>
      <input type="datetime-local" name="eventDate" required>

      <label>Location</label>
      <input type="text" name="location" required>

      <label>Capacity</label>
      <input type="number" name="capacity" min="1" required>

      <label>Organizer Name</label>
      <input type="text" name="organizerName" required>

      <label>Department / Club</label>
      <input type="text" name="department" required>

      <label>Event Type</label>
      <select name="type" required>
        <option value="">-- Select Event Type --</option>
        <option value="workshop">Workshop</option>
        <option value="seminar">Seminar</option>
        <option value="sports">Sports</option>
        <option value="social">Social</option>
      </select>

      <label>Category</label>
      <select name="category" required>
        <option value="">-- Select Category --</option>
        <option value="Educational">Educational</option>
        <option value="Social">Social</option>
        <option value="Sports">Sports</option>
        <option value="Cultural">Cultural</option>
        <option value="Technical">Technical</option>
      </select>

        <label>Event Image</label>
        <input type="file" name="image" accept="image/*" required>

      <button type="submit">Create Event</button>

    </form>

  </div>

</div>

</body>
</html>