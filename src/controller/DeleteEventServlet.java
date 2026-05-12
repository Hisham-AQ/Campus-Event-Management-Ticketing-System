package controller;

import dao.DBConnection;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/deleteEvent")
public class DeleteEventServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null ||
                (!"admin".equals(user.getRole()) && !"organizer".equals(user.getRole()))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));

        try {
            Connection conn = DBConnection.getConnection();

            // ownership check
            String checkSql = "SELECT organizer_id FROM events WHERE id=?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, eventId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                int ownerId = rs.getInt("organizer_id");

                if ("organizer".equals(user.getRole()) && ownerId != user.getId()) {
                    response.getWriter().println("Not allowed!");
                    return;
                }
            }

            // delete reservations
            PreparedStatement ps1 = conn.prepareStatement(
                    "DELETE FROM reservations WHERE event_id=?"
            );
            ps1.setInt(1, eventId);
            ps1.executeUpdate();

            // delete event
            PreparedStatement ps2 = conn.prepareStatement(
                    "DELETE FROM events WHERE id=?"
            );
            ps2.setInt(1, eventId);
            ps2.executeUpdate();

            response.sendRedirect("events.jsp?deleted=1");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}