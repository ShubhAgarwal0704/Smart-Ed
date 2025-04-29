package com.project.smartedbackend.services;

import java.util.List;
import java.util.Optional;

import com.project.smartedbackend.entities.Course;

public interface CourseService {

    Course createCourse(Course course);
    Optional<Course> getCourseById(String id);
    List<Course> getAllCourses();
    Course updateCourse(String id, Course courseDetails);
    void deleteCourse(String id);

    // Methods for course discovery and recommendations
    List<Course> searchCourses(String searchTerm);
    List<Course> getCoursesByCategory(String category);
    List<Course> getCoursesByInstructor(String instructorId);
    List<Course> getRecommendedCoursesForUser(String userId); // Recommendation logic
}


