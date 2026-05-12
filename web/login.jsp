<%
  String error = request.getParameter("error");
%>
<html>
<head>
  <title>Login</title>

  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      /*background-color: #f4f6f8; */ /* soft light gray */
      background: url("images/Uni.jpg") no-repeat center center/cover;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    body::before {
      content: "";
      position: fixed;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.3);
      top: 0;
      left: 0;
      z-index: -1;
    }

    .login-container {
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(8px);
      padding: 30px;
      border-radius: 12px;
      width: 320px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    }

    h2 {
      margin-bottom: 20px;
      font-weight: 600;
      color: #333;
    }

    input {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border: 1px solid #ddd;
      border-radius: 6px;
      transition: 0.2s;
    }

    input:focus {
      border-color: #2d89ef;
      box-shadow: 0 0 5px rgba(45,137,239,0.3);
    }

    button {
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 14px;
    }

    .login-btn {
      background-color: #2d89ef;
      color: white;
    }

    .login-btn:hover {
      background-color: #1b6fdc;
    }

    .register-btn {
      background-color: #28a745;
    }

    .register-btn:hover {
      background-color: #218838;
    }

    .error {
      color: red;
      margin-bottom: 10px;
    }

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

  </style>
</head>

<body>

<div class="login-container">

  <h2>Login</h2>

  <%
    if ("1".equals(request.getParameter("registered"))) {
  %>
  <div class="alert success">Account created successfully! Please login.</div>
  <%
    }
  %>

  <% if ("1".equals(error)) { %>
  <p class="error">Invalid email or password</p>
  <% } %>

  <form action="login" method="post">
    <input type="text" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password" required>

    <button type="submit" class="login-btn">Login</button>
  </form>

  <p style="margin-top:15px; color:#555;">
    Don't have an account?
  </p>

  <a href="register.jsp">
    <button class="register-btn">Create Account</button>
  </a>

</div>

<script>
  setTimeout(() => {
    const alert = document.querySelector(".alert");
    if (alert) {
      alert.style.transition = "opacity 0.5s";
      alert.style.opacity = "0";
      setTimeout(() => alert.remove(), 500);
    }
  }, 3000);
</script>

</body>
</html>