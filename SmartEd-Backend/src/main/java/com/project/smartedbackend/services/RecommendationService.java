//package com.project.smartedbackend.services;
//
//import com.project.smartedbackend.entities.Recommendation;
//import com.project.smartedbackend.repos.CourseRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//
//@Service
//public class RecommendationService {
//    private final CourseRepository courseRepository;
//
//    @Autowired
//    public RecommendationService(CourseRepository courseRepository) {
//        this.courseRepository = courseRepository;
//    }
//
//    public Recommendation generateRecommendations(String userId) {
//        // In a real scenario, this should be based on user data and preferences
//        List<String> recommendedCourseIds = List.of("course1", "course2", "course3");
//        Recommendation recommendation = new Recommendation();
//        recommendation.setUserId(userId);
//        recommendation.setRecommendedCourses(recommendedCourseIds);
//        return recommendation;
//    }
//}
//
