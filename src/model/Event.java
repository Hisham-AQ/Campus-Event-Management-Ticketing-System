package model;

public abstract class Event {

    private int id;
    private int organizerId;
    private String title;
    private String description;
    private String eventDate;
    private String location;
    private int capacity;
    private int seatsRemaining;
    private String status;
    private String category;
    private String organizerName;
    private String department;
    private String image;


    public Event(int id, String title, String description, String eventDate,
                 String location, int capacity, int seatsRemaining) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.eventDate = eventDate;
        this.location = location;
        this.capacity = capacity;
        this.seatsRemaining = seatsRemaining;
    }

    public Event(String title, String description, String eventDate,
                 String location, int capacity, String category,
                 String organizerName, String department) {

        this.title = title;
        this.description = description;
        this.eventDate = eventDate;
        this.location = location;
        this.capacity = capacity;
        this.seatsRemaining = capacity;
        this.category = category;
        this.organizerName = organizerName;
        this.department = department;
    }

    // getters
    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getEventDate() { return eventDate; }
    public String getLocation() { return location; }
    public int getCapacity() { return capacity; }
    public int getSeatsRemaining() { return seatsRemaining; }
    public abstract String getEventType();
    public String getStatus() {
        return status;
    }
    public String getCategory() {
        return category;
    }
    public String getOrganizerName() {
        return organizerName;
    }
    public String getDepartment() {
        return department;
    }
    public int getOrganizerId() {
        return organizerId;
    }
    public String getImage() {
        return image;
    }


    // setters
    public void setId(int id) { this.id = id; }
    public void setSeatsRemaining(int seatsRemaining) { this.seatsRemaining = seatsRemaining; }
    public void setStatus(String status) {
        this.status = status;
    }
    public void setCategory(String category) {
        this.category = category;
    }
    public void setOrganizerName(String organizerName) {
        this.organizerName = organizerName;
    }
    public void setDepartment(String department) {
        this.department = department;
    }
    public void setOrganizerId(int organizerId) {
        this.organizerId = organizerId;
    }
    public void setImage(String image) {
        this.image = image;
    }
}