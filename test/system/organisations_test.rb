require "application_system_test_case"

class OrganisationsTest < ApplicationSystemTestCase
  setup do
    @organisation = organisations(:one)
    @user = users(:one)
    
    # Login
    visit login_url
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    click_on "Login"
  end

  test "visiting the index" do
    visit organisations_url
    
    assert_selector "h1", text: "Organisations"
    
    # Should see section for user's organisations
    assert_text "My Organisations"
    assert_text @organisation.name
    
    # Should also see all organisations
    assert_text "All Organisations"
    assert_text organisations(:two).name
  end

  test "should create organisation" do
    visit organisations_url
    click_on "New Organisation"

    fill_in "Country", with: "Test Country"
    fill_in "Language", with: "Test Language"
    fill_in "Name", with: "Test Organisation"
    click_on "Create Organisation"

    assert_text "Organisation was successfully created"
    
    # Should automatically be a member
    assert_text "Test Organisation"
    assert_text "You are a member"
  end

  test "should update Organisation" do
    visit organisation_url(@organisation)
    click_on "Edit", match: :first

    fill_in "Country", with: "Updated Country"
    click_on "Update Organisation"

    assert_text "Organisation was successfully updated"
  end

  test "should destroy Organisation" do
    visit organisation_url(@organisation)
    click_on "Delete", match: :first
    
    page.driver.browser.switch_to.alert.accept

    assert_text "Organisation was successfully deleted"
  end
  
  test "user can join an organisation" do
    visit organisation_url(organisations(:two))
    
    assert_text "You are not a member"
    
    click_on "Join"
    
    assert_text "You have successfully joined"
    assert_text "You are a member"
  end
  
  test "user can leave an organisation" do
    # First join the second organisation
    visit organisation_url(organisations(:two))
    click_on "Join"
    
    assert_text "You are a member"
    
    click_on "Leave"
    
    assert_text "You have successfully left"
    assert_text "You are not a member"
  end
  
  test "user can set as primary organisation" do
    # First join the second organisation
    visit organisation_url(organisations(:two))
    click_on "Join"
    
    assert_text "Set as Primary"
    
    click_on "Set as Primary"
    
    assert_text "is now your primary organisation"
    assert_no_text "Set as Primary" # Button should be replaced with "Primary" badge
    assert_text "Primary"
  end
end 