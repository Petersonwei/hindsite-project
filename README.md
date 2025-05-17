
# HINDSIT Organisation Management App

## Core Features Implementation

### 1. User Authentication
![image](https://github.com/user-attachments/assets/ea8a6a66-9dde-45eb-82fe-e04d5f4c075f)

![image](https://github.com/user-attachments/assets/4da97fbe-98a5-4f8b-b479-39ebd8cd2a7b)

**Implementation:**
- Used Rails' `has_secure_password` with BCrypt for password storage
- Created `SessionsController` for login/logout functionality
- Added `UsersController` with registration and profile management
- Implemented `ApplicationController` helpers (`current_user`, `logged_in?`, `require_login`)

**Justification:**
- Chose `has_secure_password` over Devise for simplicity and to demonstrate core authentication concepts
- BCrypt provides industry-standard password hashing while remaining lightweight
- Session-based authentication is simpler than token-based for this application's needs
- Centralized authentication helpers in `ApplicationController` to avoid code duplication
- Applied `before_action` filters for cleaner, more maintainable authorization logic

### 2. Organizations Management
![image](https://github.com/user-attachments/assets/7f8b3f31-57d6-4a7a-8657-672f25d0d4aa)
![image](https://github.com/user-attachments/assets/5c1da64a-e66e-46f2-b822-4b2cc15aabf6)
![image](https://github.com/user-attachments/assets/4b13dc39-5e9f-4dcc-907c-fb0e1776d866)


**Implementation:**
- Created Organization model with name, country, and language fields
- Added organization creation, editing, and viewing functionality
- Implemented organization membership management

**Justification:**
- Used string fields for country and language rather than reference tables to keep the implementation simpler
- Added database constraints (NOT NULL for name) to enforce data integrity at the database level
- Implemented soft validation for organization uniqueness to allow similar-named organizations
- Used RESTful controller patterns for maintainability and Rails convention adherence

### 3. Posts System
![image](https://github.com/user-attachments/assets/214413f5-5295-45e6-b321-8e44caa8a4d3)
![image](https://github.com/user-attachments/assets/8cf87638-8b32-4f09-90d9-ea178335e55e)

**Implementation:**
- Created Post model connected to both users and organizations
- Added posts creation and viewing functionality
- Implemented scoping of posts to show only within the proper organization

**Justification:**
- Connected posts directly to organizations to maintain clear data ownership
- Added database-level foreign key constraints to maintain referential integrity
- Implemented scoping at the controller level rather than model level for flexibility
- Used association preloading to avoid N+1 query performance issues
- Added validation for post ownership to enforce proper authorization

## Optional Exercises Implementation

### 1. User Details (Easy)
![image](https://github.com/user-attachments/assets/a2ad9029-ed4f-41ec-aafc-5a4fbd44a8b7)
![image](https://github.com/user-attachments/assets/68e84616-a9e0-4e9c-aef2-68c97ce966dc)


**Implementation:**
- Added user profile editing functionality
- Implemented name, email, and password update capabilities

**Justification:**
- Separated password update logic to handle blank password submissions (allow profile edits without password changes)
- Added email format validation using URI::MailTo::EMAIL_REGEXP for standard-compliant validation
- Implemented conditional password validation for better user experience
- Used strong parameters pattern for security

### 2. Modifying/Deleting Posts (Easy)
![image](https://github.com/user-attachments/assets/9fddbcaa-ab2d-4aab-af49-ff5debf23572)
![image](https://github.com/user-attachments/assets/ac705fdd-1b23-49e3-ab86-dd67153a304e)

**Implementation:**
- Added edit and delete actions for posts
- Implemented authorization to ensure users can only modify their own posts

**Justification:**
- Added authorization at the controller level using before_action callbacks
- Used optimistic record finding with `find` instead of `find_by` to raise clear 404 errors
- Added confirmation for deletion to prevent accidental data loss
- Implemented partial form views for DRY code between new and edit actions

### 3. Departed Employee Post Storage (Easy)
![image](https://github.com/user-attachments/assets/87e70f53-bb3c-4f37-9000-8c923d73b164)
![image](https://github.com/user-attachments/assets/f891cc38-dc3a-4284-9272-61049a21433b)
make the user as departed by click the button at right hand side
![image](https://github.com/user-attachments/assets/d23b6aa4-a887-4b43-9a19-5a310cb258e2)


**Implementation:**
- Added a user status field (`active` or `departed`)
- Created methods to mark users as departed without deleting them
- Implemented a separate view for departed user posts

**Justification:**
- Used string enum pattern for status rather than boolean for extensibility
- Implemented soft-deletion approach to preserve historical data
- Added status scopes (`User.active`, `User.departed`) for query readability
- Created helper methods (`user.depart!`, `user.reactivate!`) for cleaner controller code
- Used a separate view rather than filtering to clearly differentiate active vs. departed content

### 5. Multiple Organizations (Tricky)
![image](https://github.com/user-attachments/assets/6deade5f-3917-4f81-ac38-c0f48d438a19)
![image](https://github.com/user-attachments/assets/86ab8ad3-ec5f-4db8-80c1-086d8f329bd7)


**Implementation:**
- Created a many-to-many relationship between users and organizations via `user_organisations` join table
- Implemented primary organization designation with `is_primary` flag
- Added ability for users to join multiple organizations
- Modified post creation to explicitly specify which organization a post belongs to

**Justification:**
- Used a join model rather than has_and_belongs_to_many for the additional `is_primary` attribute
- Implemented callback in UserOrganisation to ensure only one primary organization per user
- Added helper methods on User model to abstract the complexity of organization management
- Maintained backwards compatibility by keeping the direct `belongs_to :organisation` relationship
- Added database constraints to ensure data integrity for the primary organization flag

### 7. Functional/Unit Tests

**Implementation:**
- Created comprehensive tests for user authentication
- Added tests for organization management
- Implemented tests for posts with proper organization context

**Justification:**
- Used fixture data for predictable test environments
- Implemented system tests for critical user flows like registration
- Added specific tests for security concerns (organization membership verification)
- Created tests for edge cases like departing/reactivating users
- Used controller tests to verify proper HTTP responses and redirects
- Added model tests to verify business logic like primary organization setting

## Enhanced Features

### API Implementation
![image](https://github.com/user-attachments/assets/51a17abe-4bbe-42c3-8c0a-4d6b68fe5901)


**Implementation:**
- Added API endpoints for users and organizations
- Implemented organization context in API responses

**Justification:**
- Used versioned API namespace (`/api/v1`) for future compatibility
- Maintained backward compatibility by keeping original fields while adding new ones
- Implemented JSON serialization through dedicated helper methods for flexibility
- Added documentation to make API usage clear for consumers
- Used proper HTTP status codes throughout API endpoints

### Security Features

**Implementation:**
- Added proper authorization checks throughout the application
- Implemented organization data isolation

**Justification:**
- Used controller-level filters to enforce organization membership
- Implemented scoped queries to prevent data leakage between organizations
- Added session-based CSRF protection against cross-site request forgery
- Used strong parameters to prevent mass assignment vulnerabilities
- Implemented proper validation to prevent organization data manipulation by non-members
