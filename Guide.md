
# Hindsite Application Documentation

## 1. Introduction

Hindsite is a web application built with Ruby on Rails that allows users to organize into groups (organisations), create posts, and interact with other members of their organization. The application follows a standard Model-View-Controller (MVC) architecture.

## 2. System Architecture

The application consists of three primary models that form the core data structure:

- **Organisations**: Groups that users belong to
- **Users**: Individual user accounts that belong to organisations
- **Posts**: Content created by users within their organisation

## 3. Models and Relationships

### 3.1 Organisation Model
```ruby
# app/models/organisation.rb
class Organisation < ApplicationRecord
  has_many :users, dependent: :destroy
end
```
- Fields: `name`, `country`, `language`
- Relationships: Has many users

### 3.2 User Model
```ruby
# app/models/user.rb
class User < ApplicationRecord
  belongs_to :organisation, optional: true
  has_many :posts, dependent: :destroy
  
  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
end
```
- Fields: `name`, `email`, `password_digest`, `organisation_id`
- Relationships: Belongs to an organization (optional), has many posts
- Security: Uses `has_secure_password` for password encryption
- Validations: Email format and uniqueness, name presence

### 3.3 Post Model
```ruby
# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  
  validates :description, presence: true
end
```
- Fields: `description`, `user_id`
- Relationships: Belongs to a user
- Validations: Description presence

## 4. Controllers

### 4.1 SessionsController
Manages user authentication (login/logout functionality).

- **new**: Renders the login form
- **create**: Authenticates users and creates a session
- **destroy**: Logs users out by destroying the session

### 4.2 OrganisationsController
Handles CRUD operations for organisations and special actions.

- **index**: Lists all organisations
- **show**: Displays a specific organisation and actions
- **new/create**: Creates new organisations
- **edit/update**: Modifies existing organisations
- **destroy**: Deletes organisations
- **leave**: Allows users to leave an organisation (deletes their posts)
- **join**: Allows users without an organisation to join one

### 4.3 UsersController
Manages user accounts.

- **new/create**: User registration
- **show**: User profile
- **edit/update**: Edit user details
- **destroy**: Delete user accounts

### 4.4 PostsController
Handles post creation and management.

- **index**: Shows posts filtered by organisation
- **show**: Displays a specific post
- **new/create**: Creates new posts
- **edit/update**: Modifies posts (with authorization)
- **destroy**: Deletes posts (with authorization)

## 5. Authentication System

The application uses Rails' built-in session-based authentication:

- **Session Creation**: When users log in, their user ID is stored in the session
- **Current User**: The `current_user` helper method retrieves the user from the session ID
- **Authorization**: Controllers use `require_login` to restrict access to authenticated users
- **Password Security**: Uses `bcrypt` for secure password hashing

## 6. Key Features

### 6.1 Organisation Management
- Users can create organisations
- Users can join/leave organisations
- When a user leaves an organisation, their posts are deleted
- Users without an organisation can join an existing one

### 6.2 Post System
- Users can create posts visible to all members of their organisation
- Posts are filtered by organisation
- Users can only edit or delete their own posts
- Users without an organisation can only see their own posts

## 7. Views and UI

### 7.1 Authentication Pages
- Login and signup pages with styled forms
- Hindsite branding and responsive design

### 7.2 Organisation Views
- Index: List of all organizations with join options
- Show: Organisation details with action cards for viewing posts, editing, and leaving

### 7.3 Post Views
- Index: List of posts from organisation members
- Special handling for users without an organisation

## 8. Routes

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # Root path
  root "posts#index"
  
  # Session routes for authentication
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # RESTful routes for resources
  resources :organisations do
    post 'leave', on: :member, as: :leave
    post 'join', on: :member, as: :join
  end
  resources :users
  resources :posts
end
```

## 9. Setup Instructions

1. Clone the repository
2. Install dependencies: `bundle install`
3. Set up the database: `rails db:migrate`
4. Seed sample data: `rails db:seed`
5. Start the server: `rails server`
6. Access the application at http://localhost:3000

## 10. Sample Data

The seed file creates:
- 5 sample organisations
- 2 users per organisation
- 1 unaffiliated user
- 2 posts per user with an organisation
