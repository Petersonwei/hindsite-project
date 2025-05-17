require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @admin = users(:admin)
    post login_path, params: { email: @admin.email, password: 'password' }
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: 'new@example.com', name: 'New User', password: 'password', password_confirmation: 'password', organisation_id: organisations(:one).id } }
    end

    # Check that the user was created and logged in
    assert_redirected_to user_url(User.last)
    
    # Verify user_organisation was created
    assert User.last.organisations.include?(organisations(:one))
    assert User.last.user_organisations.find_by(organisation: organisations(:one)).is_primary?
  end

  test "should create user with no organisation" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: 'no_org@example.com', name: 'No Org User', password: 'password', password_confirmation: 'password' } }
    end

    assert_redirected_to user_url(User.last)
    assert_empty User.last.organisations
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should update user with new organisation" do
    user = users(:one)
    patch user_url(user), params: { user: { name: user.name, email: user.email, organisation_id: organisations(:two).id } }
    
    # Reload user to get fresh data
    user.reload
    
    # Verify membership was created
    assert user.organisations.include?(organisations(:two))
    
    # Verify it's set as primary
    assert_equal organisations(:two), user.primary_organisation
  end
end
