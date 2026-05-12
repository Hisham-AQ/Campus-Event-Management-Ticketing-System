package controller;

import dao.DBConnection;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/updateAttendance")
public class UpdateAttendanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check login
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String status = request.getParameter("status");

        // 2. Validate status
        if (!"present".equals(status) && !"absent".equals(status)) {
            response.sendRedirect("viewAttendance.jsp?eventId=" + eventId + "&error=1");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE reservations SET attendance=? WHERE user_id=? AND event_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, userId);
            ps.setInt(3, eventId);

            ps.executeUpdate();

            response.sendRedirect("viewAttendance.jsp?eventId=" + eventId + "&updated=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewAttendance.jsp?eventId=" + eventId + "&error=1");
        }
    }
}