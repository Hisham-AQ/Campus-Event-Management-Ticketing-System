<html>
<head>
  <title>Search Events</title>

  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f4f6f8;
    }

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

    .container {
      padding: 30px;
      display: flex;
      justify-content: center;
    }

    .search-box {
      background: white;
      padding: 25px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      width: 350px;
      text-align: center;
    }

    h2 {
      margin-bottom: 20px;
    }

    input, select {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ddd;
      border-radius: 6px;
    }

    button {
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 6px;
      background-color: #2d89ef;
      color: white;
      font-size: 14px;
      cursor: pointer;
    }

    button:hover {
      background-color: #1b6fdc;
    }

    .checkbox {
      display: flex;
      align-items: center;
      gap: 8px;
      margin: 10px 0;
      font-size: 14px;
      color: #555;
    }

    .checkbox input {
      width: auto;
    }
  </style>
</head>

<body>

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

  <div class="search-box">

    <h2>Search Events</h2>

    <form action="search" method="get">

      <input type="text" name="keyword" placeholder="Enter keyword">

      <select name="type">
        <option value="title">Search by Title</option>
        <option value="location">Search by Location</option>
        <option value="type">Search by Event Type</option>
        <option value="category">Search by Category</option>
      </select>

      <input type="date" name="date">

      <div class="checkbox">
        <input type="checkbox" id="available" name="available">
        <label for="available">Only Available</label>
      </div>

      <button type="submit">Search</button>

    </form>

  </div>

</div>

</body>
</html>