package controller;

import dao.EventDAO;
import model.Event;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        String date = request.getParameter("date");
        String available = request.getParameter("available");

        if (keyword == null) keyword = "";
        if (type == null) type = "title";

        keyword = keyword.toLowerCase().trim();

        List<Event> allEvents = EventDAO.getAllEvents();
        List<Event> filtered = new ArrayList<>();

        for (Event e : allEvents) {

            boolean match = true;

            // Keyword search
            switch (type) {

                case "title":
                    match = e.getTitle() != null &&
                            e.getTitle().toLowerCase().contains(keyword);
                    break;

                case "location":
                    match = e.getLocation() != null &&
                            e.getLocation().toLowerCase().contains(keyword);
                    break;

                case "type":
                    match = e.getEventType() != null &&
                            e.getEventType().toLowerCase().contains(keyword);
                    break;

                case "category":
                    match = e.getCategory() != null &&
                            e.getCategory().toLowerCase().contains(keyword);
                    break;

                default:
                    match = true;
            }

            // Date filter
            if (match && date != null && !date.isEmpty()) {
                match = e.getEventDate() != null &&
                        e.getEventDate().contains(date);
            }

            // Availability filter
            if (match && available != null) {
                match = e.getSeatsRemaining() > 0;
            }

            if (match) {
                filtered.add(e);
            }
        }

        request.setAttribute("events", filtered);
        request.getRequestDispatcher("results.jsp").forward(request, response);
    }
}