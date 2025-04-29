package com.project.smartedbackend.services;

import com.project.smartedbackend.entities.User;

import java.util.List;
import java.util.Optional;

public interface UserService {

    User createUser(User user);
    Optional<User> getUserById(String id);
    Optional<User> getUserByUsername(String username);
    Optional<User> getUserByEmail(String email);
    List<User> getAllUsers();
    User updateUser(String id, User userDetails);
    void deleteUser(String id);

    // Methods for user-specific actions
    User enrollUserInCourse(String userId, String courseId);
    User completeCourseForUser(String userId, String courseId);
    User addAchievementToUser(String userId, String achievementName);

    // Methods for progress tracking (example)
    // void updateCourseProgress(String userId, String courseId, double progress);
    // double getCourseProgress(String userId, String courseId);
}
