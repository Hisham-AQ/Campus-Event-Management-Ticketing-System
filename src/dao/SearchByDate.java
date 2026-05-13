package dao;

import model.Event;
import model.EventFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SearchByDate implements SearchStrategy {

    @Override
    public List<Event> search(String keyword) {

        List<Event> list = new ArrayList<>();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            conn = DBConnection.getConnection();

            String sql = "SELECT * FROM events WHERE event_date LIKE ?";

            ps = conn.prepareStatement(sql);

            ps.setString(1, "%" + keyword + "%");

            rs = ps.executeQuery();

            while (rs.next()) {

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
                e.setImage(rs.getString("image"));

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {

            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        return list;
    }
}