package controller;

import dao.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("id"));

        try {
            Connection conn = DBConnection.getConnection();

            // delete reservations first
            String sql1 = "DELETE FROM reservations WHERE user_id=?";
            PreparedStatement ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, userId);
            ps1.executeUpdate();

            // delete user
            String sql2 = "DELETE FROM users WHERE id=?";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, userId);
            ps2.executeUpdate();

            response.sendRedirect("admin.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}