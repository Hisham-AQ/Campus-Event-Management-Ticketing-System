<%@ page import="java.util.List" %>
<%@ page import="model.Event" %>
<%@ page import="dao.EventDAO" %>
<%@ page import="model.User" %>

<%
  User user = (User) session.getAttribute("user");

  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  List<Event> events = EventDAO.getUserReservations(user.getId());
%>

<%
   user = (User) session.getAttribute("user");

  if (user == null || !"student".equals(user.getRole())) {
    response.sendRedirect("login.jsp");
    return;
  }
%>

<html>
<head>
  <title>My Reservations</title>

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

    /* Alert */
    .alert {
      padding: 12px;
      margin-bottom: 15px;
      border-radius: 6px;
      font-weight: 500;
      text-align: center;
    }

    .alert.success {
      background-color: #d1e7dd;
      color: #0f5132;
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

    .btn-cancel {
      display: inline-block;
      margin-top: 12px;
      padding: 8px 12px;
      border-radius: 6px;
      text-decoration: none;
      color: white;
      background-color: #dc3545;
      font-size: 14px;
    }

    .btn-cancel:hover {
      background-color: #bb2d3b;
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

  <% if (request.getParameter("cancel") != null) { %>
  <div class="alert success">Reservation cancelled successfully!</div>
  <% } %>

  <h2>My Reservations</h2>

  <% if (events.isEmpty()) { %>
  <p class="empty">You have no reservations yet.</p>
  <% } else { %>

  <div class="grid">

    <% for (Event e : events) { %>

    <div class="card">
      <h3><%= e.getTitle() %></h3>

      <p class="info"><%= e.getDescription() %></p>
      <p class="info"><strong>Date:</strong> <%= e.getEventDate() %></p>
      <p class="info"><strong>Location:</strong> <%= e.getLocation() %></p>

      <a href="cancelReservation?eventId=<%= e.getId() %>" class="btn-cancel">
        Cancel Reservation
      </a>
    </div>

    <% } %>

  </div>

  <% } %>

</div>

<!-- Auto-hide alert -->
<script>
  setTimeout(() => {
    const alert = document.querySelector(".alert");
    if (alert) alert.style.display = "none";
  }, 3000);
</script>

</body>
</html>