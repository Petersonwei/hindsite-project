require "test_helper"

class OrganisationTest < ActiveSupport::TestCase
  test "should have many members through user_organisations" do
    org = organisations(:one)
    assert_includes org.members, users(:one)
    assert_includes org.members, users(:admin)
  end
  
  test "deleting organisation should delete user_organisations" do
    # Create a test org that has no posts or other dependencies
    test_org = Organisation.create!(name: "Test Org for Deletion", country: "Test", language: "Test")
    
    # Create a couple of user_organisations for this org
    user1 = users(:one)
    user2 = users(:two)
    
    user1.user_organisations.create!(organisation: test_org, is_primary: false)
    user2.user_organisations.create!(organisation: test_org, is_primary: false)
    
    assert_difference 'UserOrganisation.count', -2 do
      test_org.destroy
    end
  end
  
  test "should have many posts" do
    org = organisations(:one)
    assert_includes org.posts, posts(:one)
    assert_includes org.posts, posts(:admin_post)
  end
end
