require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should get primary organisation" do
    user = users(:admin)
    assert_equal organisations(:one), user.primary_organisation
  end
  
  test "should set primary organisation" do
    user = users(:admin)
    user.primary_organisation = organisations(:two)
    
    # Check that primary was changed
    assert_equal organisations(:two), user.primary_organisation
    
    # Verify that only the new primary is marked as primary
    assert_not user.user_organisations.find_by(organisation: organisations(:one)).is_primary?
    assert user.user_organisations.find_by(organisation: organisations(:two)).is_primary?
  end
  
  test "should add new organisation and set as primary" do
    user = users(:one)
    org = organisations(:two)
    assert_not user.organisations.include?(org)
    
    user.primary_organisation = org
    
    # Should now have the org in its list
    assert user.organisations.include?(org)
    assert_equal org, user.primary_organisation
  end
  
  test "should return organisation name" do
    user = users(:one)
    assert_equal "Test Organisation", user.organisation_name
  end
end
