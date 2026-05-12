package controller;

import dao.DBConnection;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/cancelReservation")

public class CancelReservationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getId();
        int eventId = Integer.parseInt(request.getParameter("eventId"));

        try {
            Connection conn = DBConnection.getConnection();

            String deleteSql = "DELETE FROM reservations WHERE user_id=? AND event_id=?";
            PreparedStatement ps = conn.prepareStatement(deleteSql);
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            ps.executeUpdate();

            String updateSql = "UPDATE events SET seats_remaining = seats_remaining + 1 WHERE id=?";
            PreparedStatement updatePs = conn.prepareStatement(updateSql);
            updatePs.setInt(1, eventId);
            updatePs.executeUpdate();

            response.sendRedirect("myReservations.jsp?cancel=1");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}