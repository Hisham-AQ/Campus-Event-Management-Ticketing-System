package controller;

import dao.EventDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/rateEvent")
public class RateEventServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            int rating = Integer.parseInt(request.getParameter("rating"));

            if (rating < 1 || rating > 5) {
                response.sendRedirect("events.jsp?error=invalidRating");
                return;
            }

            EventDAO.rateEvent(user.getId(), eventId, rating);

            response.sendRedirect("events.jsp?rated=1");

        } catch (Exception e) {
            response.sendRedirect("events.jsp?error=1");
        }
    }
}