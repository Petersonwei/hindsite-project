require "application_system_test_case"

class EditOrganisationTest < ApplicationSystemTestCase
  setup do
    # Create a test organisation
    @organisation = organisations(:one)
    # Create a test user
    @user = users(:one)
    # Log in the user
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    find('input[type="submit"][value="Login"]').click
  end

  test "user can access the edit organisation page" do
    visit organisation_path(@organisation)
    assert_selector "h1", text: @organisation.name
    
    click_on "Edit Organisation"
    assert_selector "h1", text: "Edit Organisation"
    assert_selector "form"
  end

  test "user can update organisation details" do
    visit edit_organisation_path(@organisation)
    
    fill_in "organisation[name]", with: "Updated Organisation Name"
    fill_in "organisation[country]", with: "Updated Country"
    fill_in "organisation[language]", with: "Updated Language"
    
    click_on "Update Organisation"
    
    assert_text "Organisation was successfully updated"
    assert_selector "h1", text: "Updated Organisation Name"
    assert_text "Updated Country"
    assert_text "Updated Language"
  end

  test "user sees validation errors when providing invalid data" do
    visit edit_organisation_path(@organisation)
    
    fill_in "organisation[name]", with: ""  # Name is required
    click_on "Update Organisation"
    
    assert_text "prohibited this organisation from being saved"
    assert_text "Name can't be blank"
  end

  test "user can cancel editing and return to organisation page" do
    visit edit_organisation_path(@organisation)
    
    click_on "Cancel"
    
    assert_current_path organisation_path(@organisation)
    assert_selector "h1", text: @organisation.name
  end
end 