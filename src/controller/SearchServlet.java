package controller;

import dao.*;
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

        // Strategy Pattern
        SearchStrategy strategy;

        switch (type) {

            case "location":
                strategy = new SearchByLocation();
                break;

            case "type":
                strategy = new SearchByType();
                break;

            case "category":
                strategy = new SearchByCategory();
                break;

            case "department":
                strategy = new SearchByDepartment();
                break;

            case "date":
                strategy = new SearchByDate();
                break;

            default:
                strategy = new SearchByTitle();
        }

        // Search using strategy
        List<Event> filtered = strategy.search(keyword);

        // Additional filters
        Iterator<Event> iterator = filtered.iterator();

        while (iterator.hasNext()) {

            Event e = iterator.next();

            // Availability filter
            if (available != null) {

                if (e.getSeatsRemaining() <= 0) {
                    iterator.remove();
                }
            }
        }

        request.setAttribute("events", filtered);

        request.getRequestDispatcher("results.jsp")
                .forward(request, response);
    }
}