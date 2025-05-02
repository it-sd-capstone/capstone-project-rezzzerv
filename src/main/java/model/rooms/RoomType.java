package model.rooms;

public class RoomType {
    private Long id;
    private String name;
    private String description;
    private double price;
    private int capacity;

    // Constructors
    public RoomType() {}

    public RoomType(Long id, String name, String description, double price, int capacity) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.capacity = capacity;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
}
