require "test_helper"

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should belong to an organisation" do
    post = posts(:one)
    assert_equal organisations(:one), post.organisation
  end
  
  test "should belong to a user" do
    post = posts(:one)
    assert_equal users(:one), post.user
  end
  
  test "should require an organisation" do
    post = Post.new(description: "Test", user: users(:one))
    assert_not post.valid?
    assert_includes post.errors.full_messages, "Organisation must exist"
  end
end
