package controller;

import dao.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/updateEvent")
public class UpdateEventServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String date = request.getParameter("eventDate");
        String location = request.getParameter("location");
        int capacity = Integer.parseInt(request.getParameter("capacity"));

        try {
            Connection conn = DBConnection.getConnection();

            String getSql = "SELECT capacity, seats_remaining FROM events WHERE id=?";
            PreparedStatement getPs = conn.prepareStatement(getSql);
            getPs.setInt(1, id);
            ResultSet rs = getPs.executeQuery();

            if (rs.next()) {
                int oldCapacity = rs.getInt("capacity");
                int seatsRemaining = rs.getInt("seats_remaining");

                int diff = capacity - oldCapacity;
                int newSeats = seatsRemaining + diff;

                if (newSeats < 0) newSeats = 0; // safety

                String updateSql = "UPDATE events SET title=?, description=?, event_date=?, location=?, capacity=?, seats_remaining=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(updateSql);

                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, date);
                ps.setString(4, location);
                ps.setInt(5, capacity);
                ps.setInt(6, newSeats);
                ps.setInt(7, id);

                ps.executeUpdate();
            }

            response.sendRedirect("events.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}