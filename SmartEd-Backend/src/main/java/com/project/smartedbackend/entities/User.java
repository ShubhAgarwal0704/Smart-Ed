package com.project.smartedbackend.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data // Lombok annotation to generate getters, setters, toString, equals, and hashCode
@Document(collection = "users") // Specifies the MongoDB collection name
public class User {

    @Id // Marks this field as the document's ID in MongoDB
    private String id;

    private String username;
    private String password; // In a real application, store hashed passwords!
    private String email;
    private String firstName;
    private String lastName;
    private String role; // e.g., "STUDENT", "TEACHER", "ADMIN"

    private List<String> enrolledCourseIds = new ArrayList<>(); // IDs of courses the user is enrolled in
    private List<String> completedCourseIds = new ArrayList<>(); // IDs of courses the user has completed
    private List<String> achievements = new ArrayList<>(); // List of achievement names or IDs

    // Attributes for tracking progress (example: simple percentage completion per course)
    // A more complex approach might involve a separate Progress document
    // private Map<String, Double> courseProgress = new HashMap<>();

    // Optional: User preferences for recommendations
    private List<String> interests = new ArrayList<>();
    private List<String> skillLevels = new ArrayList<>(); // e.g., "BEGINNER", "INTERMEDIATE"

    // Constructor (Lombok's @Data handles a no-arg constructor and all-args constructor)
    // You can add custom constructors if needed

    // Example of adding a course enrollment
    public void enrollCourse(String courseId) {
        if (!this.enrolledCourseIds.contains(courseId)) {
            this.enrolledCourseIds.add(courseId);
        }
    }

    // Example of marking a course as completed
    public void completeCourse(String courseId) {
        if (this.enrolledCourseIds.contains(courseId) && !this.completedCourseIds.contains(courseId)) {
            this.completedCourseIds.add(courseId);
            // Optionally remove from enrolledCourseIds if completion means unenrolled
            // this.enrolledCourseIds.remove(courseId);
        }
    }

    // Example of adding an achievement
    public void addAchievement(String achievementName) {
        if (!this.achievements.contains(achievementName)) {
            this.achievements.add(achievementName);
        }
    }
}
