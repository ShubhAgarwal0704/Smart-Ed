package com.project.smartedbackend.services.impl;


import com.project.smartedbackend.entities.Course;
import com.project.smartedbackend.entities.User;
import com.project.smartedbackend.repos.CourseRepository;
import com.project.smartedbackend.repos.UserRepository;
import com.project.smartedbackend.services.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service // Marks this class as a Spring Service
public class CourseServiceImpl implements CourseService {

    private final CourseRepository courseRepository;
    private final UserRepository userRepository; // Needed for recommendations

    @Autowired // Injects dependencies
    public CourseServiceImpl(CourseRepository courseRepository, UserRepository userRepository) {
        this.courseRepository = courseRepository;
        this.userRepository = userRepository;
    }

    @Override
    public Course createCourse(Course course) {
        return courseRepository.save(course);
    }

    @Override
    public Optional<Course> getCourseById(String id) {
        return courseRepository.findById(id);
    }

    @Override
    public List<Course> getAllCourses() {
        return courseRepository.findAll();
    }

    @Override
    public Course updateCourse(String id, Course courseDetails) {
        Optional<Course> courseOptional = courseRepository.findById(id);
        if (courseOptional.isPresent()) {
            Course existingCourse = courseOptional.get();
            // Update fields from courseDetails
            existingCourse.setTitle(courseDetails.getTitle());
            existingCourse.setDescription(courseDetails.getDescription());
            existingCourse.setInstructorId(courseDetails.getInstructorId());
            existingCourse.setCategory(courseDetails.getCategory());
            existingCourse.setLevel(courseDetails.getLevel());
            existingCourse.setPrice(courseDetails.getPrice());
            existingCourse.setThumbnailUrl(courseDetails.getThumbnailUrl());
            existingCourse.setLearningObjectives(courseDetails.getLearningObjectives());
            existingCourse.setPrerequisites(courseDetails.getPrerequisites());
            existingCourse.setModuleIds(courseDetails.getModuleIds());
            existingCourse.setRating(courseDetails.getRating());
            existingCourse.setNumberOfRatings(courseDetails.getNumberOfRatings());
            existingCourse.setTags(courseDetails.getTags());

            return courseRepository.save(existingCourse);
        } else {
            // Handle course not found
            throw new RuntimeException("Course not found with id " + id);
        }
    }

    @Override
    public void deleteCourse(String id) {
        courseRepository.deleteById(id);
    }

    @Override
    public List<Course> searchCourses(String searchTerm) {
        // Simple search by title, description, or tags
        // A more advanced search might use MongoDB's text search features
        List<Course> coursesByTitle = courseRepository.findByTitleContainingIgnoreCase(searchTerm);
        List<Course> coursesByDescription = courseRepository.findByTitleContainingIgnoreCase(searchTerm); // Can also search description
        List<Course> coursesByTags = courseRepository.findByTagsIn(List.of(searchTerm.split("\\s+"))); // Split search term into tags

        // Combine results and remove duplicates
        Set<Course> searchResults = new HashSet<>(coursesByTitle);
        searchResults.addAll(coursesByDescription);
        searchResults.addAll(coursesByTags);

        return new ArrayList<>(searchResults);
    }

    @Override
    public List<Course> getCoursesByCategory(String category) {
        return courseRepository.findByCategory(category);
    }

    @Override
    public List<Course> getCoursesByInstructor(String instructorId) {
        return courseRepository.findByInstructorId(instructorId);
    }

    @Override
    public List<Course> getRecommendedCoursesForUser(String userId) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            // Simple Recommendation Logic:
            // 1. Recommend courses based on user's interests
            // 2. Recommend courses based on categories of courses the user is enrolled in or completed
            // 3. Recommend popular courses (e.g., highest rated or most enrolled)

            Set<Course> recommendedCourses = new HashSet<>();

            // 1. Based on interests
            if (user.getInterests() != null && !user.getInterests().isEmpty()) {
                recommendedCourses.addAll(courseRepository.findByTagsIn(user.getInterests()));
            }

            // 2. Based on enrolled/completed course categories
            List<String> relevantCourseIds = new ArrayList<>();
            relevantCourseIds.addAll(user.getEnrolledCourseIds());
            relevantCourseIds.addAll(user.getCompletedCourseIds());

            if (!relevantCourseIds.isEmpty()) {
                List<Course> relevantCourses = courseRepository.findAllById(relevantCourseIds);
                Set<String> relevantCategories = relevantCourses.stream()
                        .map(Course::getCategory)
                        .collect(Collectors.toSet());

                relevantCategories.forEach(category -> recommendedCourses.addAll(courseRepository.findByCategory(category)));
            }

            // 3. Add some popular courses (example: top 5 highest rated)
            // This would require a more complex query or sorting logic
            // List<Course> popularCourses = courseRepository.findTop5ByOrderByRatingDesc();
            // recommendedCourses.addAll(popularCourses);


            // Remove courses the user is already enrolled in or completed
            Set<String> userCourseIds = new HashSet<>();
            userCourseIds.addAll(user.getEnrolledCourseIds());
            userCourseIds.addAll(user.getCompletedCourseIds());

            recommendedCourses.removeIf(course -> userCourseIds.contains(course.getId()));


            return new ArrayList<>(recommendedCourses);

        } else {
            // Handle user not found, perhaps return an empty list or throw exception
            return new ArrayList<>();
        }
    }
}

