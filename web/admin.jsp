<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>

<%
  User user = (User) session.getAttribute("user");

  if (user == null || !"admin".equals(user.getRole())) {
    response.sendRedirect("login.jsp");
    return;
  }

  List<User> users = UserDAO.getAllUsers();
%>

<html>
<head>
  <title>Admin Panel</title>

  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f4f6f8;
    }

    /* Navbar */
    .navbar {
      background: linear-gradient(90deg, #2d89ef, #1b6fdc);
      padding: 15px 25px;
      color: white;
      display: flex;
      justify-content: space-between;
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
      padding: 30px;
      max-width: 1100px;
      margin: auto;
    }

    h2 {
      margin-bottom: 20px;
    }

    /* Top card */
    .top-card {
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      margin-bottom: 20px;
      text-align: center;
    }

    /* Table */
    .table-box {
      background: white;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      overflow: hidden;
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    th {
      background-color: #2d89ef;
      color: white;
      padding: 12px;
    }

    td {
      padding: 12px;
      border-bottom: 1px solid #eee;
    }

    tr:hover {
      background-color: #f9f9f9;
    }

    /* Role badge */
    .role-badge {
      padding: 4px 8px;
      border-radius: 5px;
      font-size: 12px;
      font-weight: bold;
    }

    .admin { background: #ffc107; color: black; }
    .student { background: #28a745; color: white; }
    .organizer { background: #17a2b8; color: white; }

    /* Status */
    .status-active { color: green; font-weight: bold; }
    .status-blocked { color: red; font-weight: bold; }

    /* Buttons */
    .btn {
      padding: 6px 10px;
      border-radius: 5px;
      color: white;
      text-decoration: none;
      font-size: 13px;
      margin-right: 5px;
    }

    .btn-delete { background: #dc3545; }
    .btn-block { background: #dc3545; }
    .btn-unblock { background: #28a745; }
    .btn-save { background: #2d89ef; }

    select {
      padding: 4px;
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
  <div><strong>Admin Panel</strong></div>
  <div>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="events.jsp">Events</a>
    <a href="logout">Logout</a>
  </div>
</div>

<!-- Content -->
<div class="container">

  <!-- Success Message -->
  <% if ("1".equals(request.getParameter("updated"))) { %>
  <div class="alert success">User updated successfully</div>
  <% } %>



  <h2>Manage Users</h2>

  <div class="table-box">
    <table>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Role</th>
        <th>Status</th>
        <th>Actions</th>
      </tr>

      <% for (User u : users) { %>
      <tr>
        <td><%= u.getId() %></td>
        <td><%= u.getName() %></td>
        <td><%= u.getEmail() %></td>

        <!-- ROLE -->
        <td>
          <% if (u.getId() != user.getId()) { %>
          <form action="updateUserRole" method="post" style="display:flex; gap:5px; align-items:center;">
            <input type="hidden" name="id" value="<%= u.getId() %>">

            <select name="role">
              <option value="student" <%= "student".equals(u.getRole()) ? "selected" : "" %>>Student</option>
              <option value="organizer" <%= "organizer".equals(u.getRole()) ? "selected" : "" %>>Organizer</option>
              <option value="admin" <%= "admin".equals(u.getRole()) ? "selected" : "" %>>Admin</option>
            </select>

            <button type="submit" class="btn btn-save"
                    onclick="return confirm('Change user role?');">
              Save
            </button>
          </form>
          <% } else { %>
          <span class="role-badge admin">admin</span>
          <% } %>
        </td>

        <!-- STATUS -->
        <td>
          <span class="<%= "active".equals(u.getStatus()) ? "status-active" : "status-blocked" %>">
            <%= u.getStatus() %>
          </span>
        </td>

        <!-- ACTIONS -->
        <td>
          <% if (u.getId() != user.getId()) { %>

          <a href="toggleUserStatus?id=<%= u.getId() %>"
             class="btn <%= "active".equals(u.getStatus()) ? "btn-block" : "btn-unblock" %>"
             onclick="return confirm('Are you sure?');">
            <%= "active".equals(u.getStatus()) ? "Block" : "Unblock" %>
          </a>

          <a href="deleteUser?id=<%= u.getId() %>"
             class="btn btn-delete"
             onclick="return confirm('Delete this user?');">
            Delete
          </a>

          <% } else { %>
          -
          <% } %>
        </td>
      </tr>
      <% } %>

    </table>
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