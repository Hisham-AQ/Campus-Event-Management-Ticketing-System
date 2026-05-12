package controller;

import dao.DBConnection;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/reserve")
public class ReservationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check login
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Only students allowed
        if (!"student".equals(user.getRole())) {
            response.getWriter().println("Only students can reserve!");
            return;
        }

        int userId = user.getId();
        int eventId;

        // Validate eventId
        try {
            eventId = Integer.parseInt(request.getParameter("eventId"));
        } catch (Exception e) {
            response.getWriter().println("Invalid event!");
            return;
        }

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Lock event row + get seats & status
            String seatSql = "SELECT seats_remaining, status FROM events WHERE id=? FOR UPDATE";
            PreparedStatement seatPs = conn.prepareStatement(seatSql);
            seatPs.setInt(1, eventId);
            ResultSet seatRs = seatPs.executeQuery();

            if (!seatRs.next()) {
                conn.rollback();
                response.getWriter().println("Event not found!");
                return;
            }

            int seats = seatRs.getInt("seats_remaining");
            String status = seatRs.getString("status");

            // Check event status FIRST
            if (!"open".equals(status)) {
                conn.rollback();

                if ("expired".equals(status)) {
                    response.sendRedirect("events.jsp?error=expired");
                } else {
                    response.sendRedirect("events.jsp?error=closed");
                }
                return;
            }

            // Check seats
            if (seats <= 0) {
                conn.rollback();
                response.sendRedirect("events.jsp?error=full");
                return;
            }

            // Check duplicate reservation
            String checkSql = "SELECT id FROM reservations WHERE user_id=? AND event_id=?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, userId);
            checkPs.setInt(2, eventId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                conn.rollback();
                response.sendRedirect("events.jsp?error=already");
                return;
            }

            // Decrease seats FIRST
            String updateSql = "UPDATE events SET seats_remaining = seats_remaining - 1 WHERE id=?";
            PreparedStatement updatePs = conn.prepareStatement(updateSql);
            updatePs.setInt(1, eventId);
            updatePs.executeUpdate();

            // Insert reservation
            String insertSql = "INSERT INTO reservations (user_id, event_id) VALUES (?, ?)";
            PreparedStatement insertPs = conn.prepareStatement(insertSql);
            insertPs.setInt(1, userId);
            insertPs.setInt(2, eventId);
            insertPs.executeUpdate();

            conn.commit();

            response.sendRedirect("events.jsp?success=1");

        } catch (Exception e) {

            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            response.sendRedirect("events.jsp?error=1");

        } finally {

            try {
                if (conn != null) conn.close();
            } catch (SQLException ignored) {
            }
        }
    }
}