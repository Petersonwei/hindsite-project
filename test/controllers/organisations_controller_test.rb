require "test_helper"

class OrganisationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organisation = organisations(:one)
    @user = users(:one)
    # Log in the user
    post login_path, params: { email: @user.email, password: 'password' }
  end

  test "should get index" do
    get organisations_path
    assert_response :success
  end

  test "should get show" do
    get organisation_path(@organisation)
    assert_response :success
  end

  test "should get new" do
    get new_organisation_path
    assert_response :success
  end

  test "should create organisation" do
    assert_difference('Organisation.count') do
      post organisations_path, params: { 
        organisation: { 
          name: "New Organisation", 
          country: "Test Country", 
          language: "Test Language" 
        } 
      }
    end

    assert_redirected_to organisation_path(Organisation.last)
    assert_equal "Organisation was successfully created.", flash[:notice]
  end

  test "should not create organisation with invalid params" do
    assert_no_difference('Organisation.count') do
      post organisations_path, params: { 
        organisation: { 
          name: "", # Invalid: name is required
          country: "Test Country", 
          language: "Test Language" 
        } 
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_organisation_path(@organisation)
    assert_response :success
  end

  test "should update organisation" do
    patch organisation_path(@organisation), params: { 
      organisation: { 
        name: "Updated Organisation", 
        country: "Updated Country", 
        language: "Updated Language" 
      } 
    }
    
    assert_redirected_to organisation_path(@organisation)
    assert_equal "Organisation was successfully updated.", flash[:notice]
    @organisation.reload
    assert_equal "Updated Organisation", @organisation.name
    assert_equal "Updated Country", @organisation.country
    assert_equal "Updated Language", @organisation.language
  end

  test "should not update organisation with invalid params" do
    patch organisation_path(@organisation), params: { 
      organisation: { 
        name: "", # Invalid: name is required
        country: "Updated Country", 
        language: "Updated Language" 
      } 
    }
    
    assert_response :unprocessable_entity
  end

  test "should destroy organisation" do
    # First remove the association with users to avoid foreign key constraint
    User.where(organisation_id: @organisation.id).update_all(organisation_id: nil)
    
    assert_difference('Organisation.count', -1) do
      delete organisation_path(@organisation)
    end

    assert_redirected_to organisations_path
    assert_equal "Organisation was successfully deleted.", flash[:notice]
  end
end
