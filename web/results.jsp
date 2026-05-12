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
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
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

    <div class="card">
      <h3><%= e.getTitle() %></h3>

      <% if (e.getImage() != null && !e.getImage().isEmpty()) { %>
      <img src="<%= e.getImage() %>"
           style="width:100%; height:160px; object-fit:cover; border-radius:10px; margin-bottom:10px;">
      <% } %>
      <p class="info"><%= e.getDescription() %></p>
      <p class="info"><strong>Date:</strong> <%= e.getEventDate() %></p>
      <p class="info"><strong>Location:</strong> <%= e.getLocation() %></p>
      <p class="info"><strong>Seats:</strong> <%= e.getSeatsRemaining() %></p>
      <p><strong>Category:</strong> <%= e.getCategory() %></p>
      <p><strong>Date:</strong> <%= e.getEventDate() %></p>

      <% if (e.getSeatsRemaining() > 0) { %>
      <a href="reserve?eventId=<%= e.getId() %>" class="btn btn-reserve">
        Reserve
      </a>
      <% } else { %>
      <p style="color:red; font-weight:bold;">Full</p>
      <% } %>
    </div>

    <% } %>

  </div>

  <% } %>

</div>

</body>
</html>