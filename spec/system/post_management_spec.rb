require 'rails_helper'

RSpec.describe "Post Management", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  let!(:organisation) { Organisation.create!(name: "Test Org", country: "USA", language: "English") }
  
  let!(:user) do
    User.create!(
      name: "John Doe",
      email: "john@example.com",
      password: "password123",
      password_confirmation: "password123",
      status: "active",
      organisation: organisation
    )
  end
  
  let!(:other_user) do
    User.create!(
      name: "Jane Doe",
      email: "jane@example.com",
      password: "password123",
      password_confirmation: "password123",
      status: "active",
      organisation: organisation
    )
  end
  
  let!(:departed_user) do
    User.create!(
      name: "Former Employee",
      email: "former@example.com",
      password: "password123",
      password_confirmation: "password123",
      status: "departed",
      organisation: organisation
    )
  end
  
  before do
    # Create some posts
    Post.create!(description: "A post by the main user", user: user)
    Post.create!(description: "Another post by the main user", user: user)
    Post.create!(description: "A post by another active user", user: other_user)
    Post.create!(description: "A post by a departed user", user: departed_user)
    
    # Log in
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Login"
  end
  
  describe "post listing" do
    it "shows active users' posts on the main page" do
      visit posts_path
      
      expect(page).to have_content("A post by the main user")
      expect(page).to have_content("Another post by the main user")
      expect(page).to have_content("A post by another active user")
      expect(page).not_to have_content("A post by a departed user")
    end
    
    it "shows departed users' posts on the departed posts page" do
      visit departed_posts_path
      
      expect(page).to have_content("A post by a departed user")
      expect(page).not_to have_content("A post by the main user")
      expect(page).not_to have_content("Another post by the main user")
      expect(page).not_to have_content("A post by another active user")
    end
  end
  
  describe "post creation" do
    it "allows creating a new post" do
      visit new_post_path
      
      fill_in "Description", with: "A brand new post"
      click_button "Create Post"
      
      expect(page).to have_content("Post was successfully created")
      expect(page).to have_content("A brand new post")
    end
    
    it "validates post content" do
      visit new_post_path
      
      # Submit without filling in the description
      click_button "Create Post"
      
      expect(page).to have_content("Description can't be blank")
    end
  end
  
  describe "post management" do
    it "allows editing own posts" do
      # Find the link to the first post
      visit posts_path
      click_link "A post by the main user"
      
      click_link "Edit"
      
      fill_in "Description", with: "An updated post"
      click_button "Update Post"
      
      expect(page).to have_content("Post was successfully updated")
      expect(page).to have_content("An updated post")
    end
    
    it "prevents editing other users' posts" do
      # Try to edit another user's post
      other_post = Post.find_by(description: "A post by another active user")
      visit edit_post_path(other_post)
      
      # Should be redirected with an alert
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content("You are not authorized to perform this action")
    end
    
    it "allows deleting own posts" do
      # Find the link to the first post
      visit posts_path
      click_link "A post by the main user"
      
      accept_confirm do
        click_link "Delete"
      end
      
      expect(page).to have_content("Post was successfully deleted")
      expect(page).not_to have_content("A post by the main user")
    end
    
    it "prevents deleting other users' posts" do
      # Try to delete another user's post directly
      other_post = Post.find_by(description: "A post by another active user")
      
      page.driver.submit :delete, post_path(other_post), {}
      
      # Should be redirected with an alert
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content("You are not authorized to perform this action")
      
      # The post should still exist
      visit posts_path
      expect(page).to have_content("A post by another active user")
    end
  end
  
  describe "user with no organisation" do
    let!(:user_without_org) do
      User.create!(
        name: "Solo User",
        email: "solo@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: nil
      )
    end
    
    it "can only see their own posts" do
      # Create a post for the user without org
      Post.create!(description: "A post by a user without org", user: user_without_org)
      
      # Log out and log in as the user without org
      click_link "Logout"
      
      visit login_path
      fill_in "Email", with: user_without_org.email
      fill_in "Password", with: "password123"
      click_button "Log In"
      
      visit posts_path
      
      # Should only see their own post
      expect(page).to have_content("A post by a user without org")
      expect(page).not_to have_content("A post by the main user")
      expect(page).not_to have_content("A post by another active user")
      expect(page).not_to have_content("A post by a departed user")
    end
  end
end 