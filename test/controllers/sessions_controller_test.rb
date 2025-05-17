require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should login user" do
    user = users(:one)
    post login_path, params: { email: user.email, password: 'password' }
    assert_redirected_to root_path
    assert_equal user.id, session[:user_id]
  end

  test "should logout user" do
    user = users(:one)
    post login_path, params: { email: user.email, password: 'password' }
    assert_equal user.id, session[:user_id]
    
    delete logout_path
    assert_nil session[:user_id]
    assert_redirected_to login_path
  end
end
