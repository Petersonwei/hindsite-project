require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_users_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_user_url(users(:one))
    assert_response :success
  end
end
