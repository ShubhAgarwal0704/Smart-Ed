package com.project.smartedbackend.services.impl;


import com.project.smartedbackend.entities.User;
import com.project.smartedbackend.repos.UserRepository;
import com.project.smartedbackend.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service // Marks this class as a Spring Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Autowired // Injects the UserRepository dependency
    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public User createUser(User user) {
        // In a real application, hash the password before saving
        // user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    @Override
    public Optional<User> getUserById(String id) {
        return userRepository.findById(id);
    }

    @Override
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public User updateUser(String id, User userDetails) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            User existingUser = userOptional.get();
            // Update fields from userDetails
            existingUser.setUsername(userDetails.getUsername());
            // Handle password update carefully (requires current password verification)
            // existingUser.setPassword(userDetails.getPassword()); // Hash before saving!
            existingUser.setEmail(userDetails.getEmail());
            existingUser.setFirstName(userDetails.getFirstName());
            existingUser.setLastName(userDetails.getLastName());
            existingUser.setRole(userDetails.getRole());
            existingUser.setInterests(userDetails.getInterests());
            existingUser.setSkillLevels(userDetails.getSkillLevels());

            // Be careful when updating lists (enrolledCourseIds, completedCourseIds, achievements)
            // You might want separate methods for adding/removing items from these lists
            // For this example, we'll just overwrite them if provided in userDetails
            if (userDetails.getEnrolledCourseIds() != null) {
                existingUser.setEnrolledCourseIds(userDetails.getEnrolledCourseIds());
            }
            if (userDetails.getCompletedCourseIds() != null) {
                existingUser.setCompletedCourseIds(userDetails.getCompletedCourseIds());
            }
            if (userDetails.getAchievements() != null) {
                existingUser.setAchievements(userDetails.getAchievements());
            }


            return userRepository.save(existingUser);
        } else {
            // Handle user not found, perhaps throw an exception
            throw new RuntimeException("User not found with id " + id);
        }
    }

    @Override
    public void deleteUser(String id) {
        userRepository.deleteById(id);
    }

    @Override
    public User enrollUserInCourse(String userId, String courseId) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.enrollCourse(courseId);
            return userRepository.save(user);
        } else {
            throw new RuntimeException("User not found with id " + userId);
        }
    }

    @Override
    public User completeCourseForUser(String userId, String courseId) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.completeCourse(courseId);
            return userRepository.save(user);
        } else {
            throw new RuntimeException("User not found with id " + userId);
        }
    }

    @Override
    public User addAchievementToUser(String userId, String achievementName) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.addAchievement(achievementName);
            return userRepository.save(user);
        } else {
            throw new RuntimeException("User not found with id " + userId);
        }
    }
}

