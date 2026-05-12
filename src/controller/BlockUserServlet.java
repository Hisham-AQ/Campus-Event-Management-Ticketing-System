package controller;

import dao.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/toggleUserStatus")
public class BlockUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection conn = DBConnection.getConnection();

            // get current status
            String check = "SELECT status FROM users WHERE id=?";
            PreparedStatement ps1 = conn.prepareStatement(check);
            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");

                String newStatus = status.equals("active") ? "blocked" : "active";

                String update = "UPDATE users SET status=? WHERE id=?";
                PreparedStatement ps2 = conn.prepareStatement(update);
                ps2.setString(1, newStatus);
                ps2.setInt(2, id);
                ps2.executeUpdate();
            }

            response.sendRedirect("admin.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}