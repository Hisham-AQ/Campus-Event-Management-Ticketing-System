package controller;

import dao.DBConnection;
import model.Event;
import model.EventFactory;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/editEvent")
public class EditEventServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(request.getParameter("eventId"));

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM events WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, eventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Event e = EventFactory.createEvent(
                        rs.getString("type"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("event_date"),
                        rs.getString("location"),
                        rs.getInt("capacity"),
                        rs.getString("category"),
                        rs.getString("organizer_name"),
                        rs.getString("department")
                );


                e.setId(rs.getInt("id"));
                e.setSeatsRemaining(rs.getInt("seats_remaining"));

                request.setAttribute("event", e);
                RequestDispatcher rd = request.getRequestDispatcher("editEvent.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}