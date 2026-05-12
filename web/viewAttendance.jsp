<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="dao.EventDAO" %>

<%
  int eventId = Integer.parseInt(request.getParameter("eventId"));
  List<User> users = EventDAO.getEventAttendees(eventId);
%>

<html>
<head>
  <title>Attendance</title>

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

    /* Card */
    .card {
      background: white;
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    /* Table */
    table {
      width: 100%;
      border-collapse: collapse;
    }

    th {
      background-color: #2d89ef;
      color: white;
      padding: 12px;
      text-align: left;
    }

    td {
      padding: 12px;
      border-bottom: 1px solid #eee;
    }

    tr:hover {
      background-color: #f9f9f9;
    }

    /* Status badge */
    .status {
      padding: 4px 8px;
      border-radius: 5px;
      font-size: 12px;
      font-weight: bold;
    }

    .present { background-color: #28a745; color: white; }
    .absent { background-color: #dc3545; color: white; }
    .pending { background-color: #ffc107; color: black; }

    /* Buttons */
    .btn {
      padding: 6px 10px;
      border-radius: 5px;
      text-decoration: none;
      color: white;
      font-size: 13px;
      margin-right: 5px;
    }

    .btn-present {
      background-color: #28a745;
    }

    .btn-present:hover {
      background-color: #218838;
    }

    .btn-absent {
      background-color: #dc3545;
    }

    .btn-absent:hover {
      background-color: #bb2d3b;
    }

    /* Alert */
    .alert {
      padding: 12px;
      margin-bottom: 15px;
      border-radius: 6px;
      text-align: center;
      font-weight: 500;
    }

    .alert.success {
      background-color: #d1e7dd;
      color: #0f5132;
    }

    /* Empty */
    .empty {
      text-align: center;
      padding: 20px;
      color: #666;
    }

  </style>
</head>

<body>

<!-- Navbar -->
<div class="navbar">
  <div><strong>Attendance</strong></div>

  <div>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="events.jsp">Events</a>
    <a href="logout">Logout</a>
  </div>
</div>

<div class="container">

  <% if ("1".equals(request.getParameter("updated"))) { %>
  <div class="alert success">Attendance updated successfully!</div>
  <% } %>

  <h2>Event Attendance</h2>

  <div class="card">

    <% if (users.isEmpty()) { %>
    <div class="empty">No attendees yet.</div>
    <% } else { %>

    <table>
      <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Status</th>
        <th>Action</th>
      </tr>

      <% for (User u : users) { %>
      <tr>
        <td><%= u.getName() %></td>
        <td><%= u.getEmail() %></td>

        <td>
          <span class="status <%= u.getStatus() %>">
            <%= u.getStatus() %>
          </span>
        </td>

        <td>
          <a href="updateAttendance?userId=<%= u.getId() %>&eventId=<%= eventId %>&status=present"
             class="btn btn-present">
            Present
          </a>

          <a href="updateAttendance?userId=<%= u.getId() %>&eventId=<%= eventId %>&status=absent"
             class="btn btn-absent">
            Absent
          </a>
        </td>
      </tr>
      <% } %>

    </table>

    <% } %>

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