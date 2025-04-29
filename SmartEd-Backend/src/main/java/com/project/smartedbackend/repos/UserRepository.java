package com.project.smartedbackend.repos;

import com.project.smartedbackend.entities.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository // Marks this interface as a Spring Data repository
public interface UserRepository extends MongoRepository<User, String> {

    // Custom query method to find a user by username
    Optional<User> findByUsername(String username);

    // Custom query method to find a user by email
    Optional<User> findByEmail(String email);

    // Spring Data MongoDB automatically provides basic CRUD operations:
    // save(User user)
    // findById(String id)
    // findAll()
    // deleteById(String id)
    // count()
}
