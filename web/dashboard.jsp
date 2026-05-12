<%@ page import="model.User" %>

<%
  User user = (User) session.getAttribute("user");

  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>

<html>
<head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <title>Dashboard</title>

  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(to right, #f4f6f8, #e9eef3);
    }

    /* Navbar */
    .navbar {
      background: linear-gradient(90deg, #2d89ef, #1b6fdc);
      padding: 15px 25px;
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .navbar a {
      color: white;
      margin: 0 10px;
      text-decoration: none;
      font-weight: 500;
    }

    .navbar a:hover {
      text-decoration: underline;
    }

    /* Container */
    .container {
      padding: 40px;
      max-width: 1100px;
      margin: auto;
    }

    /* Profile Card */
    .profile-card {
      background: white;
      padding: 25px;
      border-radius: 12px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      margin-bottom: 30px;
    }

    .profile-card h2 {
      margin: 0 0 10px 0;
      color: #2d89ef;
    }

    .profile-info p {
      margin: 6px 0;
      color: #555;
    }

    /* Cards */
    .cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 20px;
    }

    .card {
      background: white;
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      text-align: center;
      transition: 0.3s;
    }

    .card:hover {
      transform: translateY(-6px);
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
    }

    .card h3 {
      margin-bottom: 10px;
    }

    .card p {
      color: #666;
      font-size: 14px;
    }

    /* Button */
    .btn {
      display: inline-block;
      margin-top: 12px;
      padding: 10px 14px;
      background-color: #191a1c;
      color: white;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 500;
    }

    .btn {
      background: linear-gradient(135deg, #2d89ef, #1b6fdc);
      box-shadow: 0 4px 10px rgba(45,137,239,0.3);
    }

    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 15px rgba(45,137,239,0.5);
    }

    .btn:hover {
      background-color: #2d89ef;
    }

    /* Alert */
    .alert {
      padding: 12px;
      margin-bottom: 20px;
      border-radius: 6px;
      font-weight: 500;
      text-align: center;
    }

    .alert.success {
      background-color: #d1e7dd;
      color: #0f5132;
    }
  </style>
</head>

<body>

<!-- Navbar -->
<div class="navbar">
  <strong>Campus Events</strong>

  <div>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="events.jsp">Events</a>
    <% if ("student".equals(user.getRole())) { %>
    <a href="myReservations.jsp">My Reservations</a>
    <% } %>
    <a href="search.jsp">Search</a>
    <a href="logout">Logout</a>
  </div>
</div>


<!-- Content -->
<div class="container">

  <% if (request.getParameter("created") != null) { %>
  <div class="alert success">Event created successfully!</div>
  <% } %>

  <!-- PROFILE CARD -->
  <div class="profile-card">
    <h2>Welcome, <%= user.getName() %></h2>

    <div class="profile-info">
      <p><strong>Role:</strong> <%= user.getRole() %></p>

      <p><strong>Faculty:</strong>
        <%= user.getFaculty() != null ? user.getFaculty() : "Not set" %>
      </p>

      <p><strong>Department:</strong>
        <%= user.getDepartment() != null ? user.getDepartment() : "Not set" %>
      </p>

      <p><strong>Admission Year:</strong>
        <%= user.getAdmissionYear() != 0 ? user.getAdmissionYear() : "Not set" %>
      </p>
    </div>
  </div>

  <!-- ACTION CARDS -->
  <div class="cards">

    <div class="card">
      <h3><i class="fas fa-calendar-alt"></i> Browse Events</h3>
      <p>View all available events</p>
      <a href="events.jsp" class="btn">Go</a>
    </div>

    <% if ("student".equals(user.getRole())) { %>
    <div class="card">
      <h3>My Reservations</h3>
      <p>Check your bookings</p>
      <a href="myReservations.jsp" class="btn">View</a>
    </div>
    <% } %>

    <div class="card">
      <h3>Search Events</h3>
      <p>Find events quickly</p>
      <a href="search.jsp" class="btn">Search</a>
    </div>

    <% if ("organizer".equals(user.getRole())) { %>
    <div class="card">
      <h3>Create Event</h3>
      <p>Add new events</p>
      <a href="createEvent.jsp" class="btn">Create</a>
    </div>
    <% } %>

    <% if ("admin".equals(user.getRole())) { %>
    <div class="card">
      <h3>Admin Panel</h3>
      <p>Manage users</p>
      <a href="admin.jsp" class="btn">Open</a>
    </div>
    <% } %>

    <div class="card">
      <h3>My Profile</h3>
      <p>View & update your details</p>
      <a href="profile.jsp" class="btn">Open</a>
    </div>

  </div>

</div>

<script>
  setTimeout(() => {
    const alert = document.querySelector(".alert");
    if (alert) alert.style.display = "none";
  }, 3000);
</script>

</body>
</html>