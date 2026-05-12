package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User current = (User) request.getSession().getAttribute("user");

        current.setName(name);
        current.setEmail(email);

        if (password != null && !password.isEmpty()) {
            current.setPassword(password);
        }

        boolean success = UserDAO.updateUser(current);

        if (success) {
            // update session too
            HttpSession session = request.getSession();
            current.setName(name);
            current.setEmail(email);

            response.sendRedirect("profile.jsp?success=1");
        } else {
            response.sendRedirect("profile.jsp?error=1");
        }
    }
}