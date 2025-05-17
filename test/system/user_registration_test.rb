require "application_system_test_case"

class UserRegistrationTest < ApplicationSystemTestCase
  test "registering with an organisation" do
    visit new_user_url
    
    fill_in "Name", with: "Test User"
    fill_in "Email", with: "test_registration@example.com"
    select organisations(:one).name, from: "Organisation"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    
    click_on "Create Account"
    
    # Should be redirected to user profile
    assert_text "User was successfully created"
    
    # Should see the organisation in the user's profile
    assert_text organisations(:one).name
  end
  
  test "registering without an organisation" do
    visit new_user_url
    
    fill_in "Name", with: "No Org User"
    fill_in "Email", with: "no_org@example.com"
    # Don't select an organisation
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    
    click_on "Create Account"
    
    # Should be redirected to user profile
    assert_text "User was successfully created"
    
    # Should not see an organisation listed
    assert_no_text "Primary Organisation:"
  end
  
  test "adding an organisation to existing user" do
    user = users(:one)
    
    # Login
    visit login_url
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_on "Login"
    
    # Go to edit user page
    visit edit_user_url(user)
    
    # Select a new organisation
    select organisations(:two).name, from: "Organisation"
    click_on "Update User"
    
    # Should be redirected to user profile
    assert_text "User was successfully updated"
    
    # Should see the new organisation in the profile
    assert_text organisations(:two).name
  end
end 