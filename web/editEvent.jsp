<%@ page import="model.Event" %>

<%
  Event e = (Event) request.getAttribute("event");

  if (e == null) {
    response.sendRedirect("events.jsp");
    return;
  }
%>

<html>
<head>
  <title>Edit Event</title>

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

    /* Form box */
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

    input {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ddd;
      border-radius: 6px;
    }

    input:focus {
      border-color: #2d89ef;
      outline: none;
      box-shadow: 0 0 5px rgba(45,137,239,0.3);
    }

    button {
      width: 100%;
      padding: 12px;
      margin-top: 10px;
      border: none;
      border-radius: 6px;
      background-color: #ffc107;
      color: black;
      font-size: 15px;
      cursor: pointer;
    }

    button:hover {
      background-color: #e0a800;
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

    <h2>Edit Event</h2>

    <form action="updateEvent" method="post">

      <input type="hidden" name="id" value="<%= e.getId() %>">

      <input type="text" name="title" value="<%= e.getTitle() %>" required>

      <input type="text" name="description" value="<%= e.getDescription() %>" required>

      <input
              type="datetime-local"
              name="eventDate"
              value="<%= e.getEventDate().replace(" ", "T").substring(0,16) %>"
              required
      >

      <input type="text" name="location" value="<%= e.getLocation() %>" required>

      <input type="number" name="capacity" value="<%= e.getCapacity() %>" min="1" required>

      <button type="submit">Update Event</button>

    </form>

  </div>

</div>

</body>
</html>