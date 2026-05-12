package controller;

import dao.EventDAO;
import model.Event;
import model.EventFactory;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 5 * 1024 * 1024
)

@WebServlet("/createEvent")

public class CreateEventServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (!"organizer".equals(user.getRole())) {
            response.getWriter().println("Access denied!");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String date = request.getParameter("eventDate");
        String location = request.getParameter("location");
        String type = request.getParameter("type");
        String category = request.getParameter("category");
        String organizerName = request.getParameter("organizerName");
        String department = request.getParameter("department");



        Part filePart = request.getPart("image");
        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

        String uploadPath = getServletContext().getRealPath("") + "uploads";

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        filePart.write(uploadPath + File.separator + fileName);

        String imagePath = "uploads/" + fileName;

        if (type == null || type.isEmpty()) {
            response.getWriter().println("Event type is required!");
            return;
        }

        int capacity;
        try {
            capacity = Integer.parseInt(request.getParameter("capacity"));
            if (capacity <= 0) throw new Exception();
        } catch (Exception e) {
            response.getWriter().println("Invalid capacity!");
            return;
        }

        Event event = EventFactory.createEvent(
                type,
                title,
                description,
                date,
                location,
                capacity,
                category,
                organizerName,
                department
        );
        event.setImage(imagePath);

        boolean success = EventDAO.createEvent(event, user.getId());

        if (success) {
            response.sendRedirect("dashboard.jsp?created=1");
        } else {
            response.sendRedirect("createEvent.jsp?error=1");
        }
    }
}