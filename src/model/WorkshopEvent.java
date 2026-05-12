package model;

public class WorkshopEvent extends Event {

    public WorkshopEvent(String title, String description,
                         String eventDate, String location, int capacity, String category, String organizerName, String department) {
        super(title, description, eventDate, location, capacity, category, organizerName, department);
    }

    @Override
    public String getEventType() {
        return "Workshop";
    }
}