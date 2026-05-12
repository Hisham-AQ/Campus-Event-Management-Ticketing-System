package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = String.valueOf(request.getParameter("password"));
        String role = request.getParameter("role");
        String faculty = request.getParameter("faculty");
        String department = request.getParameter("department");
        int admissionYear = Integer.parseInt(request.getParameter("admissionYear"));

        if (name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            response.getWriter().println("All fields required!");
            return;
        }

        User user = new User(name, email, password, role);

        user.setFaculty(faculty);
        user.setDepartment(department);
        user.setAdmissionYear(admissionYear);

        boolean success = UserDAO.register(user);

        if (success) {
            response.sendRedirect("login.jsp?registered=1");
        } else {
            response.getWriter().println("Error occurred.");
        }
    }
}