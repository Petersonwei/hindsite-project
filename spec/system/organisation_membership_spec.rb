require 'rails_helper'

RSpec.describe "Organisation Membership", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  let!(:organisation) { Organisation.create!(name: "Test Org", country: "USA", language: "English") }
  let!(:other_organisation) { Organisation.create!(name: "Other Org", country: "UK", language: "English") }
  
  let!(:user) do
    User.create!(
      name: "John Doe",
      email: "john@example.com",
      password: "password123",
      password_confirmation: "password123",
      status: "active"
    )
  end
  
  describe "User without an organisation" do
    before do
      # Log in
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password123"
      click_button "Login"
    end
    
    it "can view organisations" do
      visit organisations_path
      expect(page).to have_content("Organisations")
      expect(page).to have_content("Test Org")
      expect(page).to have_content("Other Org")
    end
    
    it "can join an organisation" do
      visit organisations_path
      within(page.find(".org-card", text: "Test Org")) do
        click_button "Join Organisation"
      end
      
      # Should be redirected to the organisation page
      expect(page).to have_content("You have successfully joined Test Org")
      expect(page).to have_current_path(organisation_path(organisation))
      
      # User should now be a member
      user.reload
      expect(user.organisation).to eq(organisation)
    end
    
    it "can create posts when not in an organisation" do
      visit new_post_path
      fill_in "Description", with: "This is a post without an organisation"
      click_button "Create Post"
      
      expect(page).to have_content("Post was successfully created")
      expect(page).to have_content("This is a post without an organisation")
    end
  end
  
  describe "User with an organisation" do
    before do
      # Add user to organisation
      user.update(organisation: organisation)
      
      # Create some posts from the user
      3.times do |i|
        Post.create!(
          description: "Post #{i+1} by the user",
          user: user
        )
      end
      
      # Log in
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password123"
      click_button "Login"
    end
    
    it "sees posts from their organisation" do
      # Create another user in the same org with posts
      other_user = User.create!(
        name: "Jane Doe",
        email: "jane@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: organisation
      )
      
      other_post = Post.create!(
        description: "Post by another user in the same org",
        user: other_user
      )
      
      # Create a user in a different org with posts
      user_from_other_org = User.create!(
        name: "Bob Smith",
        email: "bob@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: other_organisation
      )
      
      external_post = Post.create!(
        description: "Post by user in different org",
        user: user_from_other_org
      )
      
      visit posts_path
      
      # Should see posts from their org
      expect(page).to have_content("Post 1 by the user")
      expect(page).to have_content("Post 2 by the user")
      expect(page).to have_content("Post 3 by the user")
      expect(page).to have_content("Post by another user in the same org")
      
      # Should not see posts from other orgs
      expect(page).not_to have_content("Post by user in different org")
    end
    
    it "can leave their organisation" do
      visit organisation_path(organisation)
      
      accept_confirm do
        click_button "Leave Organisation"
      end
      
      expect(page).to have_content("You have successfully left the organisation")
      
      # User should no longer be in the organisation
      user.reload
      expect(user.organisation).to be_nil
      
      # Their posts should be deleted
      expect(Post.where(user: user)).to be_empty
    end
    
    it "cannot join another organisation without leaving current one" do
      visit organisations_path
      
      within(page.find(".org-card", text: "Other Org")) do
        expect(page).not_to have_button("Join Organisation")
      end
      
      # Try to force a join
      page.driver.submit :post, join_organisation_path(other_organisation), {}
      
      expect(page).to have_content("You must leave your current organisation before joining a new one")
      
      # User should still be in the original organisation
      user.reload
      expect(user.organisation).to eq(organisation)
    end
  end
end 