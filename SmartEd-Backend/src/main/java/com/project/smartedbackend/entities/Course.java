package com.project.smartedbackend.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data // Lombok annotation
@Document(collection = "courses") // Specifies the MongoDB collection name
public class Course {

    @Id // Marks this field as the document's ID in MongoDB
    private String id;

    private String title;
    private String description;
    private String instructorId; // ID of the user who is the instructor
    private String category; // e.g., "Programming", "Mathematics", "Science"
    private String level; // e.g., "BEGINNER", "INTERMEDIATE", "ADVANCED"
    private double price; // Use BigDecimal for currency in a real app
    private String thumbnailUrl; // URL to a thumbnail image for the course

    private List<String> learningObjectives = new ArrayList<>(); // What the user will learn
    private List<String> prerequisites = new ArrayList<>(); // What the user needs to know before starting
    private List<String> moduleIds = new ArrayList<>(); // IDs of modules within the course (assuming separate Module documents)

    private double rating; // Average rating of the course
    private int numberOfRatings; // Number of users who have rated the course

    // Optional: Tags or keywords for search and recommendations
    private List<String> tags = new ArrayList<>();

    // Constructor (Lombok's @Data handles a no-arg constructor and all-args constructor)
    // You can add custom constructors if needed
}
