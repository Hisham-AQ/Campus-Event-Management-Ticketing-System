package dao;

import model.Event;
import model.EventFactory;
import model.User;

import java.sql.*;
import java.util.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class EventDAO {

    // CREATE EVENT
    public static boolean createEvent(Event event, int organizerId) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO events (title, description, event_date, location, capacity, seats_remaining," +
                    " type, category, organizer_id, organizer_name, department, status, image)" +
                    " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, event.getTitle());
            ps.setString(2, event.getDescription());
            ps.setString(3, event.getEventDate());
            ps.setString(4, event.getLocation());
            ps.setInt(5, event.getCapacity());
            ps.setInt(6, event.getSeatsRemaining());
            ps.setString(7, event.getEventType());
            ps.setString(8, event.getCategory());
            ps.setInt(9, organizerId);
            ps.setString(10, event.getOrganizerName());
            ps.setString(11, event.getDepartment());
            ps.setString(12, "open");
            ps.setString(13, event.getImage());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    //  GET ALL EVENTS
    public static List<Event> getAllEvents() {
        List<Event> list = new ArrayList<>();

        try {
            updateExpiredEvents();
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM events";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                String type = rs.getString("type");
                if (type == null || type.isEmpty()) type = "workshop";

                Event e = EventFactory.createEvent(
                        type,
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
                e.setCategory(rs.getString("category"));
                e.setOrganizerId(rs.getInt("organizer_id"));
                e.setOrganizerName(rs.getString("organizer_name"));
                e.setDepartment(rs.getString("department"));

                // Status logic
                String dbStatus = rs.getString("status");
                String dateStr = rs.getString("event_date");
                e.setImage(rs.getString("image"));

                LocalDateTime eventDate;

                try {
                    if (dateStr.contains("T")) {
                        eventDate = LocalDateTime.parse(dateStr);
                    } else if (dateStr.length() == 16) {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                        eventDate = LocalDateTime.parse(dateStr, formatter);
                    } else {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                        eventDate = LocalDateTime.parse(dateStr, formatter);
                    }
                } catch (Exception ex) {
                    eventDate = LocalDateTime.now();
                }

                if (eventDate.isBefore(LocalDateTime.now()) && !"completed".equals(dbStatus)) {
                    e.setStatus("expired");
                } else {
                    e.setStatus(dbStatus != null ? dbStatus : "open");
                }

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // GET USER RESERVATIONS
    public static List<Event> getUserReservations(int userId) {
        List<Event> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT e.* FROM events e JOIN reservations r ON e.id = r.event_id WHERE r.user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

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
                e.setStatus(rs.getString("status"));
                e.setOrganizerId(rs.getInt("organizer_id"));
                e.setImage(rs.getString("image"));

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // GET EVENT BY ID
    public static Event getEventById(int id) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM events WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

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
                e.setStatus(rs.getString("status"));
                e.setOrganizerId(rs.getInt("organizer_id"));
                e.setImage(rs.getString("image"));

                return e;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // UPDATE EVENT
    public static boolean updateEvent(Event event) {
        try {
            Connection conn = DBConnection.getConnection();

            // 1️⃣ Get old capacity
            String selectSql = "SELECT capacity, seats_remaining FROM events WHERE id=?";
            PreparedStatement selectPs = conn.prepareStatement(selectSql);
            selectPs.setInt(1, event.getId());
            ResultSet rs = selectPs.executeQuery();

            if (!rs.next()) return false;

            int oldCapacity = rs.getInt("capacity");
            int oldSeats = rs.getInt("seats_remaining");

            // 2️⃣ Calculate new seats safely
            int newSeats = oldSeats + (event.getCapacity() - oldCapacity);

            if (newSeats < 0) newSeats = 0;

            // 3️⃣ Update
            String sql = "UPDATE events SET title=?, description=?, event_date=?, location=?, capacity=?, seats_remaining=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, event.getTitle());
            ps.setString(2, event.getDescription());
            ps.setString(3, event.getEventDate());
            ps.setString(4, event.getLocation());
            ps.setInt(5, event.getCapacity());
            ps.setInt(6, newSeats);
            ps.setInt(7, event.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE EVENT
    public static boolean deleteEvent(int id) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "DELETE FROM events WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE EVENT STATUS
    public static void updateEventStatus(int id, String status) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE events SET status=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // GET ATTENDEES
    public static List<User> getEventAttendees(int eventId) {
        List<User> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT u.id, u.name, u.email, r.attendance " +
                    "FROM users u JOIN reservations r ON u.id = r.user_id WHERE r.event_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, eventId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        "",
                        "",
                        "pending",
                        "",
                        "",
                        0
                );

                u.setStatus(rs.getString("attendance"));
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // RATE EVENT
    public static void rateEvent(int userId, int eventId, int rating) {

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "INSERT INTO ratings (user_id, event_id, rating) VALUES (?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE rating=?";

            ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            ps.setInt(3, rating);
            ps.setInt(4, rating);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    // 🔹 GET AVERAGE RATING
    public static double getAverageRating(int eventId) {
        double avg = 0;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT AVG(rating) as avg_rating FROM ratings WHERE event_id=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, eventId);

            rs = ps.executeQuery();

            if (rs.next()) {
                avg = rs.getDouble("avg_rating");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (Exception ignored) {
            }
            try {
                if (ps != null) ps.close();
            } catch (Exception ignored) {
            }
            try {
                if (conn != null) conn.close();
            } catch (Exception ignored) {
            }
        }

        return avg;
    }

    public static void updateExpiredEvents() {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE events SET status='expired' " +
                    "WHERE event_date < NOW() AND status != 'completed'";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static int getAttendeeCount(int eventId) {
        int count = 0;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) FROM reservations WHERE event_id=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, eventId);

            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (Exception ignored) {
            }
            try {
                if (ps != null) ps.close();
            } catch (Exception ignored) {
            }
            try {
                if (conn != null) conn.close();
            } catch (Exception ignored) {
            }
        }

        return count;
    }

    public static boolean hasUserReserved(int userId, int eventId) {
        boolean exists = false;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT id FROM reservations WHERE user_id=? AND event_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, eventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    public static boolean hasUserRated(int userId, int eventId) {
        boolean exists = false;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT id FROM ratings WHERE user_id=? AND event_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, eventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    public static int getUserRating(int userId, int eventId) {
        int rating = 0;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT rating FROM ratings WHERE user_id=? AND event_id=?";
            ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, eventId);

            rs = ps.executeQuery();

            if (rs.next()) {
                rating = rs.getInt("rating");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (Exception ignored) {
            }
            try {
                if (ps != null) ps.close();
            } catch (Exception ignored) {
            }
            try {
                if (conn != null) conn.close();
            } catch (Exception ignored) {
            }
        }

        return rating;
    }
}