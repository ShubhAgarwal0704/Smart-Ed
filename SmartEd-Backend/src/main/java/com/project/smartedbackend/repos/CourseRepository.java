package com.project.smartedbackend.repos;

import com.project.smartedbackend.entities.Course;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository // Marks this interface as a Spring Data repository
public interface CourseRepository extends MongoRepository<Course, String> {

    // Custom query method to find courses by category
    List<Course> findByCategory(String category);

    // Custom query method to find courses by instructor ID
    List<Course> findByInstructorId(String instructorId);

    // Custom query method to find courses by title (case-insensitive, partial match)
    // You might need more advanced text search depending on requirements
    List<Course> findByTitleContainingIgnoreCase(String title);

    // Custom query method to find courses by tags (matches any of the tags)
    List<Course> findByTagsIn(List<String> tags);

    // Spring Data MongoDB automatically provides basic CRUD operations
}