require "application_system_test_case"

class UserOrganisationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @organisation = organisations(:one)
    @organisation_two = organisations(:two)
    
    # Login
    visit login_url
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    click_on "Login"
  end

  test "user can view their organisations" do
    visit user_url(@user)
    
    assert_text "My Organisations"
    assert_text @organisation.name
  end
  
  test "user can join an organisation" do
    visit organisations_url
    
    # Find the second organisation card
    within("#organisation_#{@organisation_two.id}") do
      click_on "Join"
    end
    
    # Should be redirected to the organisation page
    assert_text "You have successfully joined"
    
    # Go back to user profile
    visit user_url(@user)
    
    # Should now see both organisations
    assert_text @organisation.name
    assert_text @organisation_two.name
  end
  
  test "user can leave an organisation" do
    # First join the second organisation
    visit organisations_url
    within("#organisation_#{@organisation_two.id}") do
      click_on "Join"
    end
    
    # Now leave it
    click_on "Leave"
    assert_text "You have successfully left"
    
    # Go back to user profile
    visit user_url(@user)
    
    # Should only see the first organisation
    assert_text @organisation.name
    assert_no_text @organisation_two.name
  end
  
  test "user can set primary organisation" do
    # First join the second organisation
    visit organisations_url
    within("#organisation_#{@organisation_two.id}") do
      click_on "Join"
    end
    
    # Set as primary
    click_on "Set as Primary"
    assert_text "is now your primary organisation"
    
    # Go back to user profile
    visit user_url(@user)
    
    # The primary badge should be on the second organisation
    within("#organisations") do
      assert_selector ".primary-badge", count: 1
    end
  end
  
  test "user can create a post in their organisation" do
    visit new_post_url
    
    fill_in "Description", with: "Test post"
    select @organisation.name, from: "Organisation"
    click_on "Create Post"
    
    assert_text "Post was successfully created"
    assert_text @organisation.name
  end
  
  test "user cannot create a post in an organisation they are not a member of" do
    # Create a new org the user is not a member of
    other_org = Organisation.create!(name: "Other Org", country: "Test", language: "Test")
    
    visit new_post_url
    
    # Other org should not be in the dropdown
    assert_no_select "post[organisation_id]", text: other_org.name
  end
end 