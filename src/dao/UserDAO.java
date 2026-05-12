package dao;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

public class UserDAO {

    public static boolean register(User user) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO users (name, email, password, role, faculty, department, admission_year)" +
                    " VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getFaculty());
            ps.setString(6, user.getDepartment());
            ps.setInt(7, user.getAdmissionYear());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }
    public static User login(String email, String password) {

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE email=? AND password=? AND status='active'";
            ps = conn.prepareStatement(sql);

            ps.setString(1, email.trim());
            ps.setString(2, password.trim());

            rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("status"),
                        rs.getString("faculty"),
                        rs.getString("department"),
                        rs.getInt("admission_year")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        return null;
    }

    public static List<User> getAllUsers() {
        List<User> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM users";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("status"),
                        rs.getString("faculty"),
                        rs.getString("department"),
                        rs.getInt("admission_year")
                );
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static boolean updateUser(User user) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql;

            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                sql = "UPDATE users SET name=?, email=?, password=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, user.getName());
                ps.setString(2, user.getEmail());
                ps.setString(3, user.getPassword().trim());
                ps.setInt(4, user.getId());
                return ps.executeUpdate() > 0;
            } else {
                sql = "UPDATE users SET name=?, email=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, user.getName());
                ps.setString(2, user.getEmail());
                ps.setInt(3, user.getId());
                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
