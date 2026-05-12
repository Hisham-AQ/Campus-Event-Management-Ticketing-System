<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: url("images/uni.jpg") no-repeat center center/cover;
        }

        /* Dark overlay */
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

        .register-container {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(8px);
            padding: 30px;
            border-radius: 12px;
            width: 320px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

        label {
            text-align: left;
            display: block;
            font-size: 13px;
            color: #555;
            margin-top: 8px;
        }

        input, select {
            width: 100%;
            padding: 12px;
            margin: 6px 0;
            border: 1px solid #ddd;
            border-radius: 6px;
            transition: 0.2s;
        }

        input:focus, select:focus {
            border-color: #2d89ef;
            box-shadow: 0 0 5px rgba(45,137,239,0.3);
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            margin-top: 12px;
        }

        .register-btn {
            background-color: #2d89ef;
            color: white;
        }

        .register-btn:hover {
            background-color: #1b6fdc;
        }

        .error {
            color: red;
            margin-top: 10px;
            font-size: 13px;
        }

        .login-link {
            margin-top: 15px;
            color: #555;
        }

        .login-link a {
            color: #2d89ef;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="register-container">

    <h2>Create Account</h2>

    <!-- Error message -->
    <% if ("1".equals(request.getParameter("error"))) { %>
    <div class="error">Registration failed. Try again.</div>
    <% } %>

    <form action="register" method="post">

        <label>Full Name</label>
        <input type="text" name="name" placeholder="Full Name" required>

        <label>Email</label>
        <input type="email" name="email" placeholder="Email" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="Password" required>

        <label>Role</label>
        <select name="role" required>
            <option value="">Select Role</option>
            <option value="student">Student</option>
            <option value="organizer">Organizer</option>
        </select>

        <label>Faculty</label>
        <select name="faculty" required>
            <option value="">Select Faculty</option>
            <option value="Engineering">Engineering</option>
            <option value="IT">IT</option>
            <option value="Business">Business</option>
        </select>

        <label>Department</label>
        <input type="text" name="department" placeholder="Department" required>

        <label>Admission Year</label>
        <input type="number" name="admissionYear" min="2000" max="2100" required>

        <button type="submit" class="register-btn">Register</button>

    </form>

    <p class="login-link">
        Already have an account?
        <a href="login.jsp">Login</a>
    </p>

</div>

</body>
</html>