# Smart Education Platform - Project Documentation

## Overview

This project is a feature-rich, interactive, and modern mobile application built using Flutter for a Smart Education Platform. The platform is designed to enhance the learning experience through an intuitive UI/UX, state management, animations, and backend integration. The backend is developed in Spring Boot and handles core logic like recommendations, search functionality, and user sign-up.

---

## Project Architecture

### High-Level Architecture
The application follows a layered architecture:

1. **UI Layer**
   - Contains screens and reusable widgets for displaying content to the user.
   - Components such as `HomeScreen`, `CourseDetailsScreen`, `SearchScreen`,and `ProfileScreen` are designed for modularity and reusability.

2. **State Management Layer**
   - Uses **Provider** for state management to ensure a reactive UI.
   - Providers like `AuthProvider`, `CourseProvider`, and `ThemeProvider` manage application-specific states.

3. **Service Layer**
   - Handles business logic and interacts with the API client or shared preferences.
   - Services include:
     - `AuthService` for authentication and user management.
     - `CourseService` for course-related operations.
     - `StorageService` for managing persistent data.
     - `UserService` for interacting with user details.

4. **Data Layer**
   - Implements a single `DioClient` for all API interactions.
   - Uses **SharedPreferences** for storing user preferences and session data (like login state and theme preferences).

5. **Backend**
   - Built using **Spring Boot**.
   - Manages course recommendations, search functionality, and user-related operations.
   - Provides endpoints for fetching user details, courses, and categories.

---

## Technical Workflow

### Interaction Model

```
UI <--> Provider <--> Service <--> DioClient / SharedPreferences
```

- **UI**: Displays the data and interacts with the user.
- **Provider**: Acts as the bridge between the UI and the service layer.
- **Service**: Contains the business logic and communicates with the backend or local storage.
- **DioClient**: Handles API calls to the backend.
- **SharedPreferences**: Manages persistent data like theme and user session information.

---

## Features

### 1. Home
- **Enrolled Courses**: Displays courses user is currently enrolled in.
- **Course Recommendations**: Dynamically fetched using backend logic based on user preferences.
- **Search Bar**: Enables quick access to courses and resources.
- **Navigation**: Directs users to key sections like courses, profile, category and search.

### 2. State Management
- Implemented using **Provider** for efficient and scalable state management.
- Ensures a reactive UI that updates with state changes.

### 3. Reusable Widgets
- Custom widgets like `CourseCard`, `CustomButton`, and `CustomTextField` ensure consistency and reusability across the app.

### 4. Dark Mode
- **ThemeProvider** manages light and dark themes using **SharedPreferences** to persist user preferences.

### 5. Animations
- Smooth transitions and animations enhance the user experience.
- Used **AnimatedContainer**, **Hero Animations**, and **FadeTransistions**.

### 6. Backend Integration
- **DioClient** facilitates interaction with the backend to fetch data like:
  - Recommended courses.
  - User details.
  - Search results.
  - New courses

### 7. Persistence
- **SharedPreferences** store:
  - User session information.
  - Theme preferences.

---

## PlantUML Diagram

![PlantUML](https://github.com/user-attachments/assets/621b5a3c-b81f-4fcd-aafa-9644efc5de62)

---

## Development Rationale

1. **UI/UX**:
   - Modern and intuitive design to enhance engagement.
   - Focus on accessibility and responsiveness.

2. **State Management**:
   - Chose **Provider** for its simplicity and scalability.
   - Ensures separation of concerns between UI and business logic.

3. **Backend Integration**:
   - Used **Dio** for API calls due to its powerful HTTP client capabilities.

4. **Persistence**:
   - **SharedPreferences** ensures a seamless user experience by storing preferences and session data.

5. **Dark Mode**:
   - Provides a user-friendly experience for different lighting conditions.

---

## Submission Details

- **Repository**: [GitHub Link](https://github.com/ShubhAgarwal0704/Smart-Ed)
- **Interactive Prototype**: [Prototype Link](https://drive.google.com/drive/folders/1t7mG0L3Y3zIXmN_3WoaJTc5AyhNBvgHu?usp=sharing)
