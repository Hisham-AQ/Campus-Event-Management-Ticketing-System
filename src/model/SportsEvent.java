package model;

public class SportsEvent extends Event {

    public SportsEvent(String title, String description,
                       String date, String location, int capacity, String category, String organizerName, String department) {
        super(title, description, date, location, capacity, category, organizerName, department);
    }

    @Override
    public String getEventType() {
        return "sports";
    }
}