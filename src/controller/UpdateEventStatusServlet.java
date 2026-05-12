package controller;

import dao.DBConnection;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/updateEventStatus")
public class UpdateEventStatusServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check login
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Check role
        if (!"organizer".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            response.getWriter().println("Access denied!");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        // 3. Validate status
        if (!status.equals("open") &&
                !status.equals("closed") &&
                !status.equals("completed")) {

            response.sendRedirect("events.jsp?error=invalidStatus");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE events SET status=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, id);

            ps.executeUpdate();

            // 4. Send success feedback
            response.sendRedirect("events.jsp?statusUpdated=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("events.jsp?error=1");
        }
    }
}