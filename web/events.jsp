<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

    List<Event> events = EventDAO.getAllEvents();
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Events</title>

    <style>
        body {
            margin:0;
            font-family:'Segoe UI';
            background:#f4f6f8;
        }

        /* Navbar */
        .navbar {
            background: linear-gradient(90deg,#2d89ef,#1b6fdc);
            padding:15px 25px;
            color:white;
            display:flex;
            justify-content:space-between;
        }

        .navbar a {
            color:white;
            margin:0 10px;
            text-decoration:none;
            font-weight:500;
        }

        /* Container */
        .container {
            padding:30px;
        }

        /* Alerts */
        .alert {
            padding:12px;
            margin-bottom:15px;
            border-radius:8px;
            text-align:center;
        }
        .alert.error { background:#f8d7da; color:#842029; }
        .alert.success { background:#d1e7dd; color:#0f5132; }

        /* Grid */
        .grid {
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
            gap:25px;
        }

        /* Card */
        .card {
            background:white;
            border-radius:16px;
            padding:20px;
            box-shadow:0 8px 20px rgba(0,0,0,0.08);
            transition:0.3s;
        }
        .card img {
            width:100%;
            height:180px;
            object-fit:cover;
            border-radius:12px;
            margin-bottom:10px;
        }

        .card:hover {
            transform:translateY(-6px);
            box-shadow:0 12px 25px rgba(0,0,0,0.15);
        }

        /* Text */
        .card h3 { margin-bottom:8px; }
        .card p { margin:6px 0; font-size:14px; color:#555; }

        .meta { color:#666; font-size:13px; }

        /* Buttons */
        .btn {
            display:inline-block;
            margin-top:10px;
            padding:10px 14px;
            border-radius:8px;
            color:white;
            text-decoration:none;
            font-size:14px;
            transition:0.2s;
        }
        .btn:hover { opacity:0.9; }

        .btn-reserve { background:#28a745; }
        .btn-edit { background:#ffc107; color:black; }
        .btn-delete { background:#dc3545; }
        .btn-disabled { background:#6c757d; cursor:not-allowed; }

        /* Status */
        .status {
            padding:4px 10px;
            border-radius:20px;
            font-size:12px;
            font-weight:bold;
        }
        .status.open { background:#d4edda; color:#155724; }
        .status.closed { background:#fff3cd; color:#856404; }
        .status.completed { background:#cce5ff; color:#004085; }
        .status.expired { background:#e2e3e5; color:#383d41; }

        .star {
            font-size:18px;
            color:#ccc;
            text-decoration:none;
            cursor: pointer;
        }
        .star:hover { color:gold; }

        .full { color:red; font-weight:bold; }

    </style>
</head>

<body>

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

<div class="container">

    <%
        String error = request.getParameter("error");
        if ("already".equals(error)) {
    %>
    <div class="alert error">You already reserved this event!</div>
    <% } else if ("full".equals(error)) { %>
    <div class="alert error">This event is full!</div>
    <% } else if ("expired".equals(error)) { %>
    <div class="alert error">This event has expired!</div>
    <% } %>
    <% if ("1".equals(request.getParameter("deleted"))) { %>
    <div class="alert success">Event deleted successfully!</div>
    <% } %>

    <% if (request.getParameter("success") != null) { %>
    <div class="alert success">Reservation successful!</div>
    <% } %>

    <h2>All Events</h2>

    <% if (events == null || events.isEmpty()) { %>
    <p>No events available</p>
    <% } else { %>

    <div class="grid">

        <% for (Event e : events) {
            double avg = EventDAO.getAverageRating(e.getId());
            boolean alreadyReserved = EventDAO.hasUserReserved(user.getId(), e.getId());
        %>

        <div class="card">
            <% if (e.getImage() != null && !e.getImage().isEmpty()) { %>
            <img src="<%= e.getImage() %>"
                 style="width:100%; height:180px; object-fit:cover; border-radius:12px; margin-bottom:10px;">
            <% } %>
            <h3><%= e.getTitle() %></h3>


            <p><%= e.getDescription() %></p>

            <p class="meta">📅 <%= e.getEventDate() %></p>
            <p class="meta">📍 <%= e.getLocation() %></p>

            <p class="meta">👤 <%= e.getOrganizerName()!=null?e.getOrganizerName():"N/A" %></p>
            <p class="meta">🏫 <%= e.getDepartment()!=null?e.getDepartment():"N/A" %></p>

            <p class="meta">📂 <%= e.getCategory() %></p>

            <p>
                Rating:
                <% for(int i=1;i<=5;i++){ %>
                <span style="color:<%= (avg >= i) ? "gold" : "#ccc" %>;">★</span>
                <% } %>
                (<%= String.format("%.1f", avg) %>)
            </p>

            <%
                boolean rated = EventDAO.hasUserRated(user.getId(), e.getId());
            %>

            <p>👥 <%= EventDAO.getAttendeeCount(e.getId()) %> / <%= e.getCapacity() %></p>

            <p>Seats left: <%= e.getSeatsRemaining() %></p>

            <p>
                Status:
                <span class="status <%= e.getStatus() %>">
                <%= e.getStatus() %>
                </span>
            </p>

            <!-- Rating -->
            <% if ("student".equals(user.getRole()) && "completed".equals(e.getStatus())) { %>

            <% if (!rated) { %>
            <div>
                <% for(int i=1;i<=5;i++){ %>
                <a href="rateEvent?eventId=<%= e.getId() %>&rating=<%= i %>" class="star">★</a>
                <% } %>
            </div>
            <% } else { %>
            <p style="color:green;">✔ You already rated</p>
            <% } %>

            <% } %>

            <%
                int myRating = EventDAO.getUserRating(user.getId(), e.getId());
            %>

            <% if ("student".equals(user.getRole()) && myRating > 0) { %>
            <p>Your rating:
                <% for(int i=1;i<=5;i++){ %>
                <span style="color:<%= (myRating >= i) ? "gold" : "#ccc" %>;">★</span>
                <% } %>
            </p>
            <% } %>

            <!-- ADMIN / ORGANIZER CONTROLS -->
            <% if ("admin".equals(user.getRole()) ||
                    ("organizer".equals(user.getRole()) && e.getOrganizerId()==user.getId())) { %>

            <a href="editEvent?eventId=<%= e.getId() %>" class="btn btn-edit">Edit</a>

            <a href="deleteEvent?eventId=<%= e.getId() %>" class="btn btn-delete"
               onclick="return confirm('Delete this event?');">
                Delete
            </a>

            <% if ("open".equals(e.getStatus())) { %>
            <a href="updateEventStatus?id=<%= e.getId() %>&status=closed"
               class="btn" style="background:#fd7e14;">Close</a>
            <% } else if ("closed".equals(e.getStatus())) { %>
            <a href="updateEventStatus?id=<%= e.getId() %>&status=open"
               class="btn" style="background:#20c997;">Open</a>
            <% } %>

            <% if (!"completed".equals(e.getStatus())) { %>
            <a href="updateEventStatus?id=<%= e.getId() %>&status=completed"
               class="btn" style="background:#0d6efd;">Complete</a>
            <% } %>

            <a href="viewAttendance.jsp?eventId=<%= e.getId() %>"
               class="btn" style="background:#6f42c1;">Attendance</a>

            <% } %>

            <!-- RESERVATION -->
            <% if ("student".equals(user.getRole())) { %>

            <% if (alreadyReserved) { %>
            <button class="btn btn-disabled" disabled>Reserved</button>

            <% } else if (e.getSeatsRemaining() > 0 && "open".equals(e.getStatus())) { %>
            <a href="reserve?eventId=<%= e.getId() %>" class="btn btn-reserve">Reserve</a>

            <% } else { %>
            <p class="full">
                <%= "closed".equals(e.getStatus()) ? "Closed" :
                        e.getSeatsRemaining() == 0 ? "Full" :
                        "Expired" %>
            </p>
            <% } %>

            <% } %>

        </div>

        <% } %>

    </div>
    <% } %>
</div>

</body>
</html>