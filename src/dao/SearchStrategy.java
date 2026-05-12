package dao;

import model.Event;
import java.util.List;

public interface SearchStrategy {
    List<Event> search(String keyword);
}