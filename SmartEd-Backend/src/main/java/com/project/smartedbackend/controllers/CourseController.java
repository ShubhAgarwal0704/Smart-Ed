package com.project.smartedbackend.controllers;

import com.project.smartedbackend.entities.Course;
import com.project.smartedbackend.services.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController // Marks this class as a REST Controller
@RequestMapping("/api/courses") // Base path for course-related endpoints
public class CourseController {

    private final CourseService courseService;

    @Autowired // Injects the CourseService dependency
    public CourseController(CourseService courseService) {
        this.courseService = courseService;
    }

    @PostMapping // Handles POST requests to /api/courses
    public ResponseEntity<Course> createCourse(@RequestBody Course course) {
        Course createdCourse = courseService.createCourse(course);
        return new ResponseEntity<>(createdCourse, HttpStatus.CREATED);
    }

    @GetMapping("/{id}") // Handles GET requests to /api/courses/{id}
    public ResponseEntity<Course> getCourseById(@PathVariable String id) {
        return courseService.getCourseById(id)
                .map(ResponseEntity::ok) // Of course found, return 200 OK with course
                .orElseGet(() -> ResponseEntity.notFound().build()); // If not found, return 404 Not Found
    }

    @GetMapping // Handles GET requests to /api/courses
    public List<Course> getAllCourses() {
        return courseService.getAllCourses();
    }

    @PutMapping("/{id}") // Handles PUT requests to /api/courses/{id}
    public ResponseEntity<Course> updateCourse(@PathVariable String id, @RequestBody Course courseDetails) {
        try {
            Course updatedCourse = courseService.updateCourse(id, courseDetails);
            return ResponseEntity.ok(updatedCourse);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build(); // Or a more specific error response
        }
    }

    @DeleteMapping("/{id}") // Handles DELETE requests to /api/courses/{id}
    public ResponseEntity<Void> deleteCourse(@PathVariable String id) {
        courseService.deleteCourse(id);
        return ResponseEntity.noContent().build(); // Return 204 No Content on successful deletion
    }

    // Endpoint for searching courses
    @GetMapping("/search") // Handles GET requests to /api/courses/search?term={searchTerm}
    public List<Course> searchCourses(@RequestParam String term) {
        return courseService.searchCourses(term);
    }

    // Endpoint to get courses by category
    @GetMapping("/category/{category}") // Handles GET requests to /api/courses/category/{category}
    public List<Course> getCoursesByCategory(@PathVariable String category) {
        return courseService.getCoursesByCategory(category);
    }

    // Endpoint to get courses by instructor
    @GetMapping("/instructor/{instructorId}") // Handles GET requests to /api/courses/instructor/{instructorId}
    public List<Course> getCoursesByInstructor(@PathVariable String instructorId) {
        return courseService.getCoursesByInstructor(instructorId);
    }

    // Endpoint to get recommended courses for a user
    @GetMapping("/recommended/{userId}") // Handles GET requests to /api/courses/recommended/{userId}
    public List<Course> getRecommendedCoursesForUser(@PathVariable String userId) {
        return courseService.getRecommendedCoursesForUser(userId);
    }
}
