require "application_system_test_case"

class OrganisationsTest < ApplicationSystemTestCase
  setup do
    # Create a test organisation
    @organisation = organisations(:one)
    # Create a test user
    @user = users(:one)
    # Log in the user
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password" # This assumes the fixture password is 'password'
    find('input[type="submit"][value="Login"]').click
  end

  test "visiting the index" do
    visit organisations_path
    assert_selector "h1", text: "Organisations"
  end

  test "should create organisation" do
    visit organisations_path
    click_on "New Organisation"

    fill_in "Name", with: "New Test Organisation"
    fill_in "Country", with: "Test Country"
    fill_in "Language", with: "Test Language"
    click_on "Create Organisation"

    assert_text "Organisation was successfully created"
  end

  test "should update Organisation" do
    visit organisation_path(@organisation)
    click_on "Edit", match: :first

    fill_in "Name", with: "Updated Organisation Name"
    fill_in "Country", with: "Updated Country"
    fill_in "Language", with: "Updated Language"
    click_on "Update Organisation"

    assert_text "Organisation was successfully updated"
    assert_text "Updated Organisation Name"
  end

  test "should destroy Organisation" do
    visit organisation_path(@organisation)
    click_on "Delete", match: :first
    page.driver.browser.switch_to.alert.accept

    assert_text "Organisation was successfully deleted"
  end
end 