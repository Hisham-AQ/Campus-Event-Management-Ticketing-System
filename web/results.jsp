<%@ page import="java.util.List" %>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>

<%
  User user = (User) session.getAttribute("user");

  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  List<Event> events = (List<Event>) request.getAttribute("events");
%>

<html>
<head>
  <title>Search Results</title>

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
      padding: 30px;
    }

    h2 {
      margin-bottom: 20px;
    }

    /* Cards */
    .grid {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
    }

    .event-card {
      width: 350px;
      background: white;
      border-radius: 14px;
      overflow: hidden;
      box-shadow: 0 5px 15px rgba(0,0,0,0.08);
      transition: 0.3s;
    }

    .event-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }

    .event-image {
      width: 100%;
      height: 160px;
      object-fit: cover;
    }

    .event-content {
      padding: 18px;
    }

    .event-content h3 {
      margin: 0 0 10px;
      color: #2d89ef;
      font-size: 22px;
    }

    .desc {
      color: #666;
      font-size: 14px;
      line-height: 1.5;
      height: 40px;
      overflow: hidden;
    }

    .info-row {
      margin-top: 10px;
      color: #444;
      font-size: 14px;
    }

    .category {
      background: #eef4ff;
      color: #2d89ef;
      padding: 5px 10px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: bold;
    }

    .btn-reserve {
      display: inline-block;
      margin-top: 15px;
      background: #28a745;
      color: white;
      padding: 10px 18px;
      border-radius: 8px;
      text-decoration: none;
      transition: 0.3s;
    }

    .btn-reserve:hover {
      background: #218838;
    }

    .full {
      margin-top: 15px;
      color: red;
      font-weight: bold;
    }


    .card {
      background: white;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      transition: 0.2s;
    }

    .card:hover {
      transform: translateY(-5px);
    }

    .card h3 {
      margin-top: 0;
      color: #2d89ef;
    }

    .info {
      font-size: 14px;
      color: #555;
      margin: 5px 0;
    }

    .btn {
      display: inline-block;
      margin-top: 10px;
      padding: 8px 12px;
      border-radius: 6px;
      text-decoration: none;
      color: white;
      font-size: 14px;
    }

    .btn-reserve {
      background-color: #28a745;
    }

    .btn-reserve:hover {
      background-color: #218838;
    }

    .empty {
      text-align: center;
      color: #666;
      margin-top: 30px;
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

  <h2>Search Results</h2>

  <% if (events == null || events.isEmpty()) { %>
  <p class="empty">No events found.</p>
  <% } else { %>

  <div class="grid">

    <% for (Event e : events) { %>

    <div class="event-card">

      <% if (e.getImage() != null && !e.getImage().isEmpty()) { %>
      <img src="<%= e.getImage() %>" class="event-image">
      <% } %>

      <div class="event-content">

        <h3><%= e.getTitle() %></h3>

        <p class="desc">
          <%= e.getDescription() %>
        </p>

        <div class="info-row">
          <span><%= e.getEventDate() %></span>
        </div>

        <div class="info-row">
          <span> <%= e.getLocation() %></span>
        </div>

        <div class="info-row">
          <span>Seats: <%= e.getSeatsRemaining() %></span>
        </div>

        <div class="info-row">
            <span class="category">
                <%= e.getCategory() %>
            </span>
        </div>

        <% if (e.getSeatsRemaining() > 0) { %>

        <a href="reserve?eventId=<%= e.getId() %>"
           class="btn-reserve">
          Reserve
        </a>

        <% } else { %>

        <div class="full">Full</div>

        <% } %>

      </div>

    </div>

    <% } %>

  </div>

  <% } %>

</div>

</body>
</html>