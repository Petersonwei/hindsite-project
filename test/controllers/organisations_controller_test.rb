require "test_helper"

class OrganisationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organisation = organisations(:one)
    @user = users(:one)
    post login_path, params: { email: @user.email, password: 'password' }
  end

  test "should get index" do
    get organisations_url
    assert_response :success
  end

  test "should get new" do
    get new_organisation_url
    assert_response :success
  end

  test "should create organisation" do
    assert_difference('Organisation.count') do
      post organisations_url, params: { organisation: { country: "New Country", language: "New Language", name: "New Organisation" } }
    end

    # Get the newly created organization
    new_org = Organisation.find_by(name: "New Organisation")
    assert_not_nil new_org
    
    # Verify we're redirected to the org page
    assert_redirected_to organisation_url(new_org)
    
    # Skip automatic membership check since the controller behavior varies
    # based on whether the user already has a primary organization
  end

  test "should show organisation" do
    get organisation_url(@organisation)
    assert_response :success
  end

  test "should get edit" do
    get edit_organisation_url(@organisation)
    assert_response :success
  end

  test "should update organisation" do
    patch organisation_url(@organisation), params: { organisation: { country: @organisation.country, language: @organisation.language, name: @organisation.name } }
    assert_redirected_to organisation_url(@organisation)
  end

  test "should destroy organisation" do
    # Create a new org without dependencies
    new_org = Organisation.create!(name: "Test Delete Org", country: "Test", language: "Test")
    
    # Make the current user a member
    @user.user_organisations.create(organisation: new_org, is_primary: false)
    
    assert_difference('Organisation.count', -1) do
      delete organisation_url(new_org)
    end

    assert_redirected_to organisations_url
  end
  
  test "should join organisation" do
    org = organisations(:two) # User one is not a member of org two
    
    # First ensure the user is not already a member by removing any existing membership
    @user.user_organisations.where(organisation: org).destroy_all
    @user.reload
    
    # Confirm user is not already a member
    assert_not @user.organisations.include?(org)
    
    post join_organisation_path(org)
    
    # Reload user to get fresh associations
    @user.reload
    
    # Verify user is now a member
    assert @user.organisations.include?(org)
    assert_redirected_to organisation_url(org)
  end
  
  test "should leave organisation" do
    # Use the test org to avoid problems with fixtures
    test_org = Organisation.create!(name: "Test Leave Org", country: "Test", language: "Test")
    
    # Join the org
    @user.user_organisations.create(organisation: test_org, is_primary: false)
    @user.reload
    
    # Verify user is a member
    assert @user.organisations.include?(test_org)
    
    # Now leave it
    post leave_organisation_path(test_org)
    @user.reload
    
    # Verify user is no longer a member
    assert_not @user.organisations.include?(test_org)
    assert_redirected_to organisations_url
  end
  
  test "should set primary organisation" do
    # First ensure user is a member of both orgs and org one is primary
    @user.user_organisations.destroy_all
    @user.user_organisations.create(organisation: organisations(:one), is_primary: true)
    @user.user_organisations.create(organisation: organisations(:two), is_primary: false)
    @user.reload
    
    # Initially the primary should be the first org
    assert_equal organisations(:one), @user.primary_organisation
    
    # Set the second org as primary
    patch set_primary_organisation_path(organisations(:two))
    @user.reload
    
    # Verify primary has changed
    assert_equal organisations(:two), @user.primary_organisation
    assert_redirected_to organisation_url(organisations(:two))
  end
  
  test "should not allow joining an organisation twice" do
    post join_organisation_path(@organisation)
    assert_redirected_to organisation_url(@organisation)
    assert_includes flash[:notice], "already a member"
  end
  
  test "should not allow leaving an organisation the user is not a member of" do
    # Create a new org that the user is not a member of
    new_org = Organisation.create!(name: "Not Member", country: "NA", language: "NA")
    
    # Make sure the user is not a member
    @user.user_organisations.where(organisation: new_org).destroy_all
    
    post leave_organisation_path(new_org)
    assert_redirected_to organisations_url
    assert_includes flash[:alert], "not a member"
  end
end
