package com.project.smartedbackend.controllers;

import com.project.smartedbackend.entities.User;
import com.project.smartedbackend.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController // Marks this class as a REST Controller
@RequestMapping("/api/users") // Base path for user-related endpoints
public class UserController {

    private final UserService userService;

    @Autowired // Injects the UserService dependency
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping // Handles POST requests to /api/users
    public ResponseEntity<User> createUser(@RequestBody User user) {
        User createdUser = userService.createUser(user);
        return new ResponseEntity<>(createdUser, HttpStatus.CREATED);
    }

    @GetMapping("/{id}") // Handles GET requests to /api/users/{id}
    public ResponseEntity<User> getUserById(@PathVariable String id) {
        return userService.getUserById(id)
                .map(ResponseEntity::ok) // If user found, return 200 OK with user
                .orElseGet(() -> ResponseEntity.notFound().build()); // If not found, return 404 Not Found
    }

    @GetMapping // Handles GET requests to /api/users
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    @PutMapping("/{id}") // Handles PUT requests to /api/users/{id}
    public ResponseEntity<User> updateUser(@PathVariable String id, @RequestBody User userDetails) {
        try {
            User updatedUser = userService.updateUser(id, userDetails);
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build(); // Or a more specific error response
        }
    }

    @DeleteMapping("/{id}") // Handles DELETE requests to /api/users/{id}
    public ResponseEntity<Void> deleteUser(@PathVariable String id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build(); // Return 204 No Content on successful deletion
    }

    // Endpoint to enroll a user in a course
    @PostMapping("/{userId}/enroll/{courseId}")
    public ResponseEntity<User> enrollUserInCourse(@PathVariable String userId, @PathVariable String courseId) {
        try {
            User updatedUser = userService.enrollUserInCourse(userId, courseId);
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build(); // User or Course not found
        }
    }

    // Endpoint to mark a course as completed for a user
    @PostMapping("/{userId}/complete/{courseId}")
    public ResponseEntity<User> completeCourseForUser(@PathVariable String userId, @PathVariable String courseId) {
        try {
            User updatedUser = userService.completeCourseForUser(userId, courseId);
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build(); // User or Course not found
        }
    }

    // Endpoint to add an achievement to a user
    @PostMapping("/{userId}/achievements")
    public ResponseEntity<User> addAchievementToUser(@PathVariable String userId, @RequestBody String achievementName) {
        try {
            User updatedUser = userService.addAchievementToUser(userId, achievementName);
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build(); // User not found
        }
    }
}
