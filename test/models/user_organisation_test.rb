require "test_helper"

class UserOrganisationTest < ActiveSupport::TestCase
  test "should validate uniqueness of user and organisation" do
    user_org = user_organisations(:one)
    duplicate = UserOrganisation.new(user: user_org.user, organisation: user_org.organisation)
    assert_not duplicate.valid?
    assert_includes duplicate.errors.full_messages, "User has already been taken"
  end

  test "should ensure only one primary organisation per user" do
    user = users(:admin)
    assert user_organisations(:admin_org_one).is_primary?
    assert_not user_organisations(:admin_org_two).is_primary?
    
    # Set second org as primary
    user_organisations(:admin_org_two).update(is_primary: true)
    
    # Reload first org and verify it's no longer primary
    user_organisations(:admin_org_one).reload
    assert_not user_organisations(:admin_org_one).is_primary?
    assert user_organisations(:admin_org_two).is_primary?
  end
  
  test "should allow a user to be in multiple organisations" do
    user = users(:admin)
    assert_equal 2, user.organisations.count
    assert_includes user.organisations, organisations(:one)
    assert_includes user.organisations, organisations(:two)
  end
end 