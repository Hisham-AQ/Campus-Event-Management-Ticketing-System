package dao;

import model.Event;
import java.sql.*;
import java.util.*;
import model.EventFactory;

public class SearchByLocation implements SearchStrategy {

    public List<Event> search(String keyword) {
        List<Event> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM events WHERE location LIKE ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

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

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}