package controller;

import dao.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/updateUserRole")
public class UpdateUserRoleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("id"));
        String role = request.getParameter("role");

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE users SET role=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, role);
            ps.setInt(2, userId);

            ps.executeUpdate();

            response.sendRedirect("admin.jsp?updated=1");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}