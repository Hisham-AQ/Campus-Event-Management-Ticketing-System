package model;

public class EventFactory {

    public static Event createEvent(String type, String title, String description,
                                    String date, String location, int capacity, String category, String organizerName, String department) {

        if (type == null || type.trim().isEmpty()) {
            type = "workshop";
        }

        switch (type.toLowerCase()) {
            case "workshop":
                return new WorkshopEvent(title, description, date, location, capacity, category, organizerName, department);

            case "seminar":
                return new SeminarEvent(title, description, date, location, capacity, category, organizerName, department);

            case "sports":
                return new SportsEvent(title, description, date, location, capacity, category, organizerName, department);

            case "social":
                return new SocialEvent(title, description, date, location, capacity, category, organizerName, department);

            default:
                return new WorkshopEvent(title, description, date, location, capacity, category, organizerName, department);
        }
    }
}