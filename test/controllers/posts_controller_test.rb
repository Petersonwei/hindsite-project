require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @user = users(:one)
    post login_path, params: { email: @user.email, password: 'password' }
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    get new_post_url
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post posts_url, params: { post: { description: @post.description, organisation_id: organisations(:one).id } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    patch post_url(@post), params: { post: { description: @post.description, organisation_id: organisations(:one).id } }
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
  
  test "should not create post for organisation user is not a member of" do
    # Create a new org that the user is not a member of
    new_org = Organisation.create!(name: "Not Member", country: "NA", language: "NA")
    
    assert_no_difference('Post.count') do
      post posts_url, params: { post: { description: "Test post", organisation_id: new_org.id } }
    end
    
    assert_response :unprocessable_entity
    assert_includes flash[:alert], "only post to organisations you are a member of"
  end
  
  test "should not update post with organisation user is not a member of" do
    # Create a new org that the user is not a member of
    new_org = Organisation.create!(name: "Not Member", country: "NA", language: "NA")
    
    patch post_url(@post), params: { post: { description: @post.description, organisation_id: new_org.id } }
    
    assert_response :unprocessable_entity
    assert_includes flash[:alert], "only post to organisations you are a member of"
  end
end
