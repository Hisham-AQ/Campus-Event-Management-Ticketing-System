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
    <title>Profile</title>

    <style>
        body {
            font-family: Arial;
            background: #f4f6f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            width: 350px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
        }

        button {
            width: 100%;
            padding: 10px;
            background: #2d89ef;
            color: white;
            border: none;
            border-radius: 5px;
        }

        .msg {
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>

<body>

<div class="box">

    <h2>My Profile</h2>

    <% if (request.getParameter("success") != null) { %>
    <p class="msg" style="color:green;">Profile updated!</p>
    <% } %>

    <form action="updateProfile" method="post">

        <input type="hidden" name="id" value="<%= user.getId() %>">

        <input type="text" name="name" value="<%= user.getName() %>" required>

        <input type="email" name="email" value="<%= user.getEmail() %>" required>

        <input type="password" name="password" placeholder="New password (optional)">

        <button type="submit">Update</button>

    </form>

</div>

</body>
</html>